import 'auth_models.dart';

abstract interface class AuthRepository {
  bool get isConfigured;
  AuthSnapshot get snapshot;
  Stream<AuthSnapshot> get authChanges;

  Future<RegistrationOutcome> register({
    required String email,
    required String password,
    required String displayName,
  });

  Future<void> signIn({required String email, required String password});
  Future<void> sendPasswordRecovery(String email);
  Future<void> updatePassword(String password);
  Future<void> updateDisplayName(String displayName);
  Future<void> signOut();
  Future<void> dispose();
}

class UnconfiguredAuthRepository implements AuthRepository {
  const UnconfiguredAuthRepository();

  @override
  bool get isConfigured => false;

  @override
  AuthSnapshot get snapshot => const AuthSnapshot();

  @override
  Stream<AuthSnapshot> get authChanges => const Stream.empty();

  Never _unavailable() =>
      throw const AuthFailure(AuthIssue.configurationMissing);

  @override
  Future<RegistrationOutcome> register({
    required String email,
    required String password,
    required String displayName,
  }) async =>
      _unavailable();

  @override
  Future<void> signIn(
          {required String email, required String password}) async =>
      _unavailable();

  @override
  Future<void> sendPasswordRecovery(String email) async => _unavailable();

  @override
  Future<void> updatePassword(String password) async => _unavailable();

  @override
  Future<void> updateDisplayName(String displayName) async => _unavailable();

  @override
  Future<void> signOut() async => _unavailable();

  @override
  Future<void> dispose() async {}
}
