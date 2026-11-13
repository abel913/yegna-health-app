import 'dart:async';

import 'package:yegna_health_app/src/auth/auth_models.dart';
import 'package:yegna_health_app/src/auth/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    AuthSnapshot initialSnapshot = const AuthSnapshot(),
    this.registrationOutcome = RegistrationOutcome.verificationPending,
    this.failure,
  }) : _snapshot = initialSnapshot;

  AuthSnapshot _snapshot;
  final _changes = StreamController<AuthSnapshot>.broadcast();
  final RegistrationOutcome registrationOutcome;
  final AuthIssue? failure;
  int registerCalls = 0;
  int signInCalls = 0;
  int recoveryCalls = 0;
  int updateProfileCalls = 0;
  int signOutCalls = 0;
  String? updatedDisplayName;

  @override
  bool get isConfigured => true;

  @override
  AuthSnapshot get snapshot => _snapshot;

  @override
  Stream<AuthSnapshot> get authChanges => _changes.stream;

  void emit(AuthSnapshot value) {
    _snapshot = value;
    _changes.add(value);
  }

  void _throwFailure() {
    if (failure != null) throw AuthFailure(failure!);
  }

  @override
  Future<RegistrationOutcome> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    registerCalls++;
    _throwFailure();
    return registrationOutcome;
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    signInCalls++;
    _throwFailure();
    emit(AuthSnapshot(
      user: AuthUser(
        id: 'user-1',
        email: email,
        emailVerified: true,
        displayName: 'Test User',
        hasCompletedSurvey: true,
      ),
    ));
  }

  @override
  Future<void> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    _throwFailure();
    emit(AuthSnapshot(
      user: AuthUser(
        id: 'user-verified-1',
        email: email,
        emailVerified: true,
        displayName: 'Verified Student',
        hasCompletedSurvey: false,
      ),
    ));
  }

  @override
  Future<void> resendVerification(String email) async {
    _throwFailure();
  }

  @override
  Future<void> deleteAccount() async {
    _throwFailure();
    await signOut();
  }

  @override
  Future<void> sendPasswordRecovery(String email) async {
    recoveryCalls++;
    _throwFailure();
  }

  @override
  Future<void> updatePassword(String password) async => _throwFailure();

  @override
  Future<void> updateDisplayName(String displayName) async {
    updateProfileCalls++;
    _throwFailure();
    updatedDisplayName = displayName;
    final current = _snapshot.user;
    if (current != null) {
      emit(AuthSnapshot(
        user: AuthUser(
          id: current.id,
          email: current.email,
          emailVerified: current.emailVerified,
          displayName: displayName,
          hasCompletedSurvey: current.hasCompletedSurvey,
        ),
      ));
    }
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
    _throwFailure();
    emit(const AuthSnapshot());
  }

  @override
  Future<void> dispose() => _changes.close();
}
