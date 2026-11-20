import 'auth_models.dart';

abstract interface class AuthRepository {
  bool get isConfigured;
  String? get token;
  AuthSnapshot get snapshot;
  Stream<AuthSnapshot> get authChanges;

  Future<RegistrationOutcome> register({
    required String email,
    required String password,
    required String displayName,
  });

  Future<void> signIn({required String email, required String password});
  Future<void> verifyEmailCode({required String email, required String code});
  Future<void> resendVerification(String email);
  Future<void> deleteAccount();
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
  String? get token => null;

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
  Future<void> verifyEmailCode(
          {required String email, required String code}) async =>
      _unavailable();

  @override
  Future<void> resendVerification(String email) async => _unavailable();

  @override
  Future<void> deleteAccount() async => _unavailable();

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
