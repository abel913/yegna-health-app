import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import 'auth_models.dart';
import 'auth_repository.dart';

const authCallbackUri = 'com.yegnahealth.amharic://auth-callback';

String get _authRedirectUri => kIsWeb ? Uri.base.origin : authCallbackUri;

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client) {
    _authSubscription = _client.auth.onAuthStateChange.listen(
      (state) => _authChanges.add(_snapshotFrom(state)),
      onError: (Object error, StackTrace stackTrace) {
        _authChanges.addError(const AuthFailure(AuthIssue.networkUnavailable));
      },
    );
  }

  final SupabaseClient _client;
  final _authChanges = StreamController<AuthSnapshot>.broadcast();
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  bool get isConfigured => true;

  @override
  AuthSnapshot get snapshot => AuthSnapshot(
        user: _toAuthUser(_client.auth.currentUser),
      );

  @override
  Stream<AuthSnapshot> get authChanges => _authChanges.stream;

  @override
  Future<RegistrationOutcome> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password,
        emailRedirectTo: _authRedirectUri,
        data: {'display_name': displayName.trim()},
      );
      final user = response.user;
      if (user == null) throw const AuthFailure(AuthIssue.registrationFailed);
      if (response.session == null || user.emailConfirmedAt == null) {
        return RegistrationOutcome.verificationPending;
      }
      return RegistrationOutcome.signedIn;
    } on AuthFailure {
      rethrow;
    } on AuthRetryableFetchException {
      throw const AuthFailure(AuthIssue.networkUnavailable);
    } on AuthException catch (error) {
      throw AuthFailure(_mapAuthException(error));
    } on TimeoutException catch (_) {
      throw const AuthFailure(AuthIssue.networkUnavailable);
    } catch (_) {
      throw const AuthFailure(AuthIssue.unexpected);
    }
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      final user = response.user;
      if (user == null || response.session == null) {
        throw const AuthFailure(AuthIssue.invalidCredentials);
      }
      if (user.emailConfirmedAt == null) {
        await _client.auth.signOut();
        throw const AuthFailure(AuthIssue.emailNotConfirmed);
      }
    } on AuthFailure {
      rethrow;
    } on AuthRetryableFetchException {
      throw const AuthFailure(AuthIssue.networkUnavailable);
    } on AuthException catch (error) {
      throw AuthFailure(_mapAuthException(error));
    } on TimeoutException catch (_) {
      throw const AuthFailure(AuthIssue.networkUnavailable);
    } catch (_) {
      throw const AuthFailure(AuthIssue.unexpected);
    }
  }

  @override
  Future<void> sendPasswordRecovery(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: _authRedirectUri,
      );
    } on AuthException catch (error) {
      throw AuthFailure(_mapAuthException(error));
    } on TimeoutException catch (_) {
      throw const AuthFailure(AuthIssue.networkUnavailable);
    } catch (_) {
      throw const AuthFailure(AuthIssue.unexpected);
    }
  }

  @override
  Future<void> updatePassword(String password) async {
    _requireVerifiedUser();
    try {
      await _client.auth.updateUser(UserAttributes(password: password));
    } on AuthException catch (error) {
      throw AuthFailure(_mapAuthException(error));
    } on TimeoutException catch (_) {
      throw const AuthFailure(AuthIssue.networkUnavailable);
    } catch (_) {
      throw const AuthFailure(AuthIssue.unexpected);
    }
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    _requireVerifiedUser();
    try {
      await _client.auth.updateUser(
        UserAttributes(data: {'display_name': displayName.trim()}),
      );
    } on AuthException catch (error) {
      throw AuthFailure(_mapAuthException(error));
    } on TimeoutException catch (_) {
      throw const AuthFailure(AuthIssue.networkUnavailable);
    } catch (_) {
      throw const AuthFailure(AuthIssue.unexpected);
    }
  }

  @override
  Future<void> verifyEmailCode(
      {required String email, required String code}) async {
    try {
      await _client.auth.verifyOTP(
        email: email.trim(),
        token: code.trim(),
        type: OtpType.signup,
      );
    } on AuthException catch (error) {
      throw AuthFailure(_mapAuthException(error));
    } catch (_) {
      throw const AuthFailure(AuthIssue.unexpected);
    }
  }

  @override
  Future<void> resendVerification(String email) async {
    try {
      await _client.auth.resend(
        type: OtpType.signup,
        email: email.trim(),
      );
    } on AuthException catch (error) {
      throw AuthFailure(_mapAuthException(error));
    } catch (_) {
      throw const AuthFailure(AuthIssue.unexpected);
    }
  }

  @override
  Future<void> deleteAccount() async {
    _requireVerifiedUser();
    await signOut();
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (error) {
      throw AuthFailure(_mapAuthException(error));
    } on TimeoutException catch (_) {
      throw const AuthFailure(AuthIssue.networkUnavailable);
    } catch (_) {
      throw const AuthFailure(AuthIssue.unexpected);
    }
  }

  void _requireVerifiedUser() {
    final user = _client.auth.currentUser;
    if (user == null || user.emailConfirmedAt == null) {
      throw const AuthFailure(AuthIssue.sessionUnavailable);
    }
  }

  AuthSnapshot _snapshotFrom(AuthState state) => AuthSnapshot(
        user: _toAuthUser(state.session?.user),
        passwordRecovery: state.event == AuthChangeEvent.passwordRecovery,
      );

  AuthUser? _toAuthUser(User? user) {
    if (user == null) return null;
    final displayName = user.userMetadata?['display_name'];
    final surveyCompleted = user.userMetadata?['survey_completed'] == true;
    return AuthUser(
      id: user.id,
      email: user.email ?? '',
      emailVerified: user.emailConfirmedAt != null,
      displayName: displayName is String ? displayName : '',
      hasCompletedSurvey: surveyCompleted,
    );
  }

  AuthIssue _mapAuthException(AuthException error) {
    final code = error.code?.toLowerCase() ?? '';
    final statusCode = int.tryParse(error.statusCode ?? '');
    if (statusCode != null && statusCode >= 500) {
      return AuthIssue.networkUnavailable;
    }
    return switch (code) {
      'invalid_credentials' || 'user_not_found' => AuthIssue.invalidCredentials,
      'email_not_confirmed' => AuthIssue.emailNotConfirmed,
      'user_already_exists' || 'email_exists' => AuthIssue.registrationFailed,
      'weak_password' => AuthIssue.passwordTooShort,
      'flow_state_expired' || 'otp_expired' => AuthIssue.recoveryExpired,
      'over_email_send_rate_limit' ||
      'email_address_not_authorized' =>
        AuthIssue.networkUnavailable,
      _ => AuthIssue.unexpected,
    };
  }

  @override
  Future<void> dispose() async {
    await _authSubscription.cancel();
    await _authChanges.close();
  }
}
