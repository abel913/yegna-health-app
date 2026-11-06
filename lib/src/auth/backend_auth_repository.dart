import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../sync/api_client.dart';
import 'auth_models.dart';
import 'auth_repository.dart';

/// Production authentication repository connecting directly to the custom
/// Node.js + Prisma backend server with offline session persistence and
/// instant suspension enforcement.
class BackendAuthRepository implements AuthRepository {
  BackendAuthRepository({
    required ApiClient apiClient,
    required SharedPreferences preferences,
  })  : _apiClient = apiClient,
        _preferences = preferences,
        _changes = StreamController<AuthSnapshot>.broadcast();

  static const String keyToken = 'backend_auth_token';
  static const String keyUserId = 'backend_auth_user_id';
  static const String keyEmail = 'backend_auth_email';
  static const String keyDisplayName = 'backend_auth_display_name';
  static const String keyRole = 'backend_auth_role';

  final ApiClient _apiClient;
  final SharedPreferences _preferences;
  final StreamController<AuthSnapshot> _changes;

  AuthSnapshot _snapshot = const AuthSnapshot();

  @override
  bool get isConfigured => true;

  @override
  AuthSnapshot get snapshot => _snapshot;

  @override
  Stream<AuthSnapshot> get authChanges => _changes.stream;

  /// Loads the cached session from local storage for instant offline access,
  /// then asynchronously validates the token and suspension status with the backend.
  Future<void> init() async {
    final token = _preferences.getString(keyToken);
    final userId = _preferences.getString(keyUserId);
    final email = _preferences.getString(keyEmail);
    final displayName = _preferences.getString(keyDisplayName) ?? '';
    final role = _preferences.getString(keyRole) ?? 'STUDENT';

    if (token != null && token.isNotEmpty && userId != null && email != null) {
      _snapshot = AuthSnapshot(
        user: AuthUser(
          id: userId,
          email: email,
          displayName: displayName,
          role: role,
          emailVerified: true,
        ),
      );
      _changes.add(_snapshot);

      // Verify token and check for real-time suspension against backend
      unawaited(_verifySession(token));
    }
  }

  Future<void> _verifySession(String token) async {
    final res = await _apiClient.getCurrentUser(token);
    if (!res.success) {
      if (res.errorCode == 'ACCOUNT_SUSPENDED' || res.statusCode == 403) {
        // Account has been suspended by community safety! Clear session immediately.
        await signOut();
        return;
      }
      if (res.statusCode == 401) {
        // Token invalidated or expired.
        await signOut();
        return;
      }
      // Offline / network timeout: retain local offline cached session.
      return;
    }

    // Refresh profile attributes if updated remotely
    final user = res.user;
    if (user != null) {
      final updatedName = user['displayName'] as String? ?? '';
      final updatedRole = user['role'] as String? ?? 'STUDENT';
      await _preferences.setString(keyDisplayName, updatedName);
      await _preferences.setString(keyRole, updatedRole);

      final current = _snapshot.user;
      if (current != null) {
        _snapshot = AuthSnapshot(
          user: AuthUser(
            id: current.id,
            email: current.email,
            displayName: updatedName,
            role: updatedRole,
            emailVerified: true,
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
    final res = await _apiClient.register(
      email: email,
      password: password,
      displayName: displayName,
    );

    if (res.success) {
      if (res.token != null && res.user != null) {
        final token = res.token!;
        final user = res.user!;
        final id = user['id'] as String;
        final userEmail = user['email'] as String;
        final name = (user['displayName'] as String?) ?? displayName;
        final role = (user['role'] as String?) ?? 'STUDENT';

        await _preferences.setString(keyToken, token);
        await _preferences.setString(keyUserId, id);
        await _preferences.setString(keyEmail, userEmail);
        await _preferences.setString(keyDisplayName, name);
        await _preferences.setString(keyRole, role);

        _snapshot = AuthSnapshot(
          user: AuthUser(
            id: id,
            email: userEmail,
            displayName: name,
            role: role,
            emailVerified: true,
          ),
        );
        _changes.add(_snapshot);
        return RegistrationOutcome.signedIn;
      }

      // Verification email has been dispatched; student must verify before sign-in
      return RegistrationOutcome.verificationPending;
    }

    if (res.errorCode == 'EMAIL_EXISTS' || res.statusCode == 409) {
      throw const AuthFailure(AuthIssue.emailAlreadyInUse);
    }
    if (res.errorCode == 'NETWORK_ERROR') {
      throw const AuthFailure(AuthIssue.networkUnavailable);
    }
    throw const AuthFailure(AuthIssue.registrationFailed);
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final res = await _apiClient.login(
      email: email,
      password: password,
    );

    if (res.success && res.token != null && res.user != null) {
      final token = res.token!;
      final user = res.user!;
      final id = user['id'] as String;
      final userEmail = user['email'] as String;
      final name = (user['displayName'] as String?) ?? '';
      final role = (user['role'] as String?) ?? 'STUDENT';

      await _preferences.setString(keyToken, token);
      await _preferences.setString(keyUserId, id);
      await _preferences.setString(keyEmail, userEmail);
      await _preferences.setString(keyDisplayName, name);
      await _preferences.setString(keyRole, role);

      _snapshot = AuthSnapshot(
        user: AuthUser(
          id: id,
          email: userEmail,
          displayName: name,
          role: role,
          emailVerified: true,
        ),
      );
      _changes.add(_snapshot);
      return;
    }

    if (res.errorCode == 'ACCOUNT_SUSPENDED') {
      throw const AuthFailure(AuthIssue.accountSuspended);
    }
    if (res.errorCode == 'EMAIL_NOT_CONFIRMED') {
      throw const AuthFailure(AuthIssue.emailNotConfirmed);
    }
    if (res.errorCode == 'INVALID_CREDENTIALS' || res.statusCode == 401) {
      throw const AuthFailure(AuthIssue.invalidCredentials);
    }
    if (res.statusCode == 403) {
      throw const AuthFailure(AuthIssue.accountSuspended);
    }
    if (res.errorCode == 'NETWORK_ERROR') {
      throw const AuthFailure(AuthIssue.networkUnavailable);
    }
    throw const AuthFailure(AuthIssue.unexpected);
  }

  @override
  Future<void> sendPasswordRecovery(String email) async {
    // In the independent self-hosted deployment, password resets are governed
    // by authorized staff in the Desktop Web Admin Portal.
    return;
  }

  @override
  Future<void> updatePassword(String password) async {
    final token = _preferences.getString(keyToken);
    if (token == null || token.isEmpty) {
      throw const AuthFailure(AuthIssue.sessionUnavailable);
    }

    final res = await _apiClient.updatePassword(
      token: token,
      newPassword: password,
    );

    if (!res.success) {
      if (res.errorCode == 'NETWORK_ERROR') {
        throw const AuthFailure(AuthIssue.networkUnavailable);
      }
      throw const AuthFailure(AuthIssue.unexpected);
    }
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    final token = _preferences.getString(keyToken);
    if (token == null || token.isEmpty) {
      throw const AuthFailure(AuthIssue.sessionUnavailable);
    }

    final res = await _apiClient.updateProfile(
      token: token,
      displayName: displayName,
    );

    if (res.success && res.user != null) {
      final updatedName = (res.user!['displayName'] as String?) ?? displayName;
      await _preferences.setString(keyDisplayName, updatedName);

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

    if (res.errorCode == 'NETWORK_ERROR') {
      throw const AuthFailure(AuthIssue.networkUnavailable);
    }
    throw const AuthFailure(AuthIssue.unexpected);
  }

  @override
  Future<void> signOut() async {
    await _preferences.remove(keyToken);
    await _preferences.remove(keyUserId);
    await _preferences.remove(keyEmail);
    await _preferences.remove(keyDisplayName);
    await _preferences.remove(keyRole);

    _snapshot = const AuthSnapshot(user: null);
    _changes.add(_snapshot);
  }

  @override
  Future<void> dispose() async {
    unawaited(_changes.close());
  }
}
