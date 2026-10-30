import 'package:flutter_test/flutter_test.dart';
import 'package:yegna_health_app/src/auth/auth_controller.dart';
import 'package:yegna_health_app/src/auth/auth_models.dart';
import 'package:yegna_health_app/src/auth/auth_validation.dart';
import 'package:yegna_health_app/src/auth/auth_repository.dart';

import 'support/fake_auth_repository.dart';

void main() {
  group('AuthValidation', () {
    test('validates email and rejects malformed addresses', () {
      expect(AuthValidation.email(''), AuthIssue.emailRequired);
      expect(AuthValidation.email('not-an-email'), AuthIssue.invalidEmail);
      expect(AuthValidation.email('person@example.org'), isNull);
    });

    test('validates password, confirmation, and display name', () {
      expect(AuthValidation.password('short'), AuthIssue.passwordTooShort);
      expect(AuthValidation.password('long-enough-password'), isNull);
      expect(
        AuthValidation.passwordConfirmation('onePassword', 'anotherPassword'),
        AuthIssue.passwordMismatch,
      );
      expect(AuthValidation.displayName('   '), AuthIssue.displayNameRequired);
      expect(AuthValidation.displayName('Yegna'), isNull);
    });
  });

  group('AuthController', () {
    test('registration remains pending until email confirmation', () async {
      final repository = FakeAuthRepository();
      final controller = AuthController(repository);

      final result = await controller.register(
        email: ' person@example.org ',
        password: 'a-secure-password',
        confirmation: 'a-secure-password',
        displayName: 'Guest Name',
      );

      expect(result, RegistrationOutcome.verificationPending);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.verificationEmail, 'person@example.org');
      expect(repository.registerCalls, 1);
      controller.dispose();
    });

    test('invalid client input never calls the provider', () async {
      final repository = FakeAuthRepository();
      final controller = AuthController(repository);

      final result =
          await controller.signIn(email: 'bad', password: 'password');

      expect(result, isFalse);
      expect(controller.issue, AuthIssue.invalidEmail);
      expect(repository.signInCalls, 0);
      controller.dispose();
    });

    test('only a verified provider user is authenticated', () async {
      final repository = FakeAuthRepository();
      final controller = AuthController(repository);

      expect(controller.isAuthenticated, isFalse);
      expect(
          await controller.signIn(
            email: 'person@example.org',
            password: 'a-secure-password',
          ),
          isTrue);
      expect(controller.isAuthenticated, isTrue);
      expect(controller.user?.email, 'person@example.org');
      controller.dispose();
    });

    test('provider credential errors are surfaced as safe issue codes',
        () async {
      final repository =
          FakeAuthRepository(failure: AuthIssue.invalidCredentials);
      final controller = AuthController(repository);

      final success = await controller.signIn(
        email: 'person@example.org',
        password: 'a-secure-password',
      );

      expect(success, isFalse);
      expect(controller.issue, AuthIssue.invalidCredentials);
      controller.dispose();
    });

    test('password recovery response does not reveal account existence',
        () async {
      final repository = FakeAuthRepository();
      final controller = AuthController(repository);

      expect(await controller.requestPasswordRecovery('person@example.org'),
          isTrue);
      expect(repository.recoveryCalls, 1);
      controller.dispose();
    });

    test('profile updates require verified auth and update only display name',
        () async {
      final repository = FakeAuthRepository(
        initialSnapshot: const AuthSnapshot(
          user: AuthUser(
            id: 'u1',
            email: 'person@example.org',
            emailVerified: true,
            displayName: 'Before',
          ),
        ),
      );
      final controller = AuthController(repository);

      expect(await controller.updateDisplayName(' New Name '), isTrue);
      expect(repository.updatedDisplayName, 'New Name');
      expect(controller.user?.displayName, 'New Name');
      controller.dispose();
    });

    test('password recovery event is exposed for reset navigation', () async {
      final repository = FakeAuthRepository();
      final controller = AuthController(repository);
      repository.emit(const AuthSnapshot(passwordRecovery: true));
      await Future<void>.delayed(Duration.zero);

      expect(controller.recoveryRequested, isTrue);
      controller.dispose();
    });

    test('unconfigured provider never reports an authenticated session',
        () async {
      final controller = AuthController(const UnconfiguredAuthRepository());
      expect(controller.isAuthenticated, isFalse);
      expect(controller.isConfigured, isFalse);
      expect(
          await controller.signIn(
            email: 'person@example.org',
            password: 'a-secure-password',
          ),
          isFalse);
      expect(controller.issue, AuthIssue.configurationMissing);
      controller.dispose();
    });
  });
}
