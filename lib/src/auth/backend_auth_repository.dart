import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../onboarding/onboarding_survey_storage.dart';
import '../sync/api_client.dart';
import 'auth_models.dart';
import 'auth_repository.dart';
import 'backend_auth_error_mapper.dart';
import 'backend_auth_session_store.dart';

/// Production authentication repository connecting directly to the custom
/// Node.js + Prisma backend server with offline session persistence.
class BackendAuthRepository implements AuthRepository {
  BackendAuthRepository({
    required ApiClient apiClient,
    required SharedPreferences preferences,
  })  : _apiClient = apiClient,
        _session = BackendAuthSessionStore(preferences),
        _changes = StreamController<AuthSnapshot>.broadcast();

  static const String keyToken = BackendAuthSessionStore.keyToken;
  static const String keyUserId = BackendAuthSessionStore.keyUserId;
  static const String keyEmail = BackendAuthSessionStore.keyEmail;
  static const String keyDisplayName = BackendAuthSessionStore.keyDisplayName;
  static const String keyRole = BackendAuthSessionStore.keyRole;
  static const String keySurveyCompleted = BackendAuthSessionStore.keySurveyCompleted;

  final ApiClient _apiClient;
  final BackendAuthSessionStore _session;
  final StreamController<AuthSnapshot> _changes;

  AuthSnapshot _snapshot = const AuthSnapshot();

  @override
  bool get isConfigured => true;

  @override
  String? get token => _session.token;

  @override
  AuthSnapshot get snapshot => _snapshot;

  @override
  Stream<AuthSnapshot> get authChanges => _changes.stream;

  Future<void> init() async {
    final cachedUser = _session.loadUser();
    if (cachedUser != null) {
      _snapshot = AuthSnapshot(user: cachedUser);
      _changes.add(_snapshot);

      final token = _session.token;
      if (token != null) unawaited(_verifySession(token));
    }
  }

  Future<void> _verifySession(String token) async {
    final res = await _apiClient.getCurrentUser(token);
    if (!res.success) {
      if (res.errorCode == 'ACCOUNT_SUSPENDED' || res.statusCode == 403 || res.statusCode == 401) await signOut();
      return;
    }

    final user = res.user;
    if (user != null) {
      final updatedName = user['displayName'] as String? ?? '';
      final updatedRole = user['role'] as String? ?? 'STUDENT';
      var updatedSurvey = user['hasCompletedSurvey'] as bool? ?? false;
      if (!updatedSurvey && await OnboardingSurveyStorage.isCompleted()) {
        updatedSurvey = true;
        unawaited(_apiClient.markUserSurveyCompleted(token));
      }
      await _session.updateProfile(displayName: updatedName, role: updatedRole, surveyCompleted: updatedSurvey);

      final current = _snapshot.user;
      if (current != null) {
        _snapshot = AuthSnapshot(
          user: AuthUser(
            id: current.id,
            email: current.email,
            displayName: updatedName,
            role: updatedRole,
            emailVerified: true,
            hasCompletedSurvey: updatedSurvey,
          ),
        );
        _changes.add(_snapshot);
      }
    }
  }

  @override
  Future<RegistrationOutcome> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final res = await _apiClient.register(email: email, password: password, displayName: displayName);
    if (res.success) {
      if (res.token != null && res.user != null) {
        final user = await _session.saveUserFromMap(res.token!, res.user!, fallbackName: displayName);
        _snapshot = AuthSnapshot(user: user);
        _changes.add(_snapshot);
        return RegistrationOutcome.signedIn;
      }
      return RegistrationOutcome.verificationPending;
    }
    throw mapBackendAuthError(res);
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    final res = await _apiClient.login(email: email, password: password);
    if (res.success && res.token != null && res.user != null) {
      final user = await _session.saveUserFromMap(res.token!, res.user!);
      _snapshot = AuthSnapshot(user: user);
      _changes.add(_snapshot);
      if (!user.hasCompletedSurvey && await OnboardingSurveyStorage.isCompleted()) {
        unawaited(_apiClient.markUserSurveyCompleted(res.token!));
      }
      return;
    }
    throw mapBackendAuthError(res);
  }

  @override
  Future<void> verifyEmailCode({required String email, required String code}) async {
    final res = await _apiClient.verifyEmailCode(email: email, code: code);
    if (res.success && res.token != null && res.user != null) {
      final user = await _session.saveUserFromMap(res.token!, res.user!);
      _snapshot = AuthSnapshot(user: user);
      _changes.add(_snapshot);
      return;
    }
    throw mapBackendAuthError(res);
  }

  @override
  Future<void> resendVerification(String email) async {
    final res = await _apiClient.resendVerification(email: email);
    if (!res.success) throw mapBackendAuthError(res);
  }

  @override
  Future<void> deleteAccount() async {
    final token = _session.token;
    if (token != null && token.isNotEmpty) {
      await _apiClient.deleteAccount(token: token);
    }
    await signOut();
  }

  @override
  Future<void> sendPasswordRecovery(String email) async {}

  @override
  Future<void> updatePassword(String password) async {
    final token = _session.token;
    if (token == null || token.isEmpty) throw const AuthFailure(AuthIssue.sessionUnavailable);
    final res = await _apiClient.updatePassword(token: token, newPassword: password);
    if (!res.success) throw mapBackendAuthError(res);
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    final token = _session.token;
    if (token == null || token.isEmpty) throw const AuthFailure(AuthIssue.sessionUnavailable);
    final res = await _apiClient.updateProfile(token: token, displayName: displayName);
    if (res.success && res.user != null) {
      final updatedName = (res.user!['displayName'] as String?) ?? displayName;
      await _session.updateProfile(displayName: updatedName);
      final current = _snapshot.user;
      if (current != null) {
        _snapshot = AuthSnapshot(
          user: AuthUser(
            id: current.id,
            email: current.email,
            displayName: updatedName,
            role: current.role,
            emailVerified: true,
          ),
        );
        _changes.add(_snapshot);
      }
      return;
    }
    throw mapBackendAuthError(res);
  }

  @override
  Future<void> signOut() async {
    await _session.clearSession();
    _changes.add(_snapshot = const AuthSnapshot(user: null));
  }

  @override
  Future<void> dispose() async {
    unawaited(_changes.close());
  }
}
