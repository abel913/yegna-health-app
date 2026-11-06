import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/src/auth/auth_models.dart';
import 'package:yegna_health_app/src/auth/backend_auth_repository.dart';
import 'package:yegna_health_app/src/sync/api_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BackendAuthRepository Tests', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test('init with no stored credentials produces unauthenticated snapshot',
        () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'error': 'UNAUTHORIZED'}), 401);
      });
      final apiClient = ApiClient(
        baseUrl: 'http://localhost:5000/api',
        httpClient: mockClient,
      );
      final repo = BackendAuthRepository(
        apiClient: apiClient,
        preferences: prefs,
      );

      await repo.init();

      expect(repo.isConfigured, isTrue);
      expect(repo.snapshot.user, isNull);
    });

    test('init with stored session loads offline snapshot immediately',
        () async {
      await prefs.setString(BackendAuthRepository.keyToken, 'valid-token-123');
      await prefs.setString(BackendAuthRepository.keyUserId, 'usr-1');
      await prefs.setString(
          BackendAuthRepository.keyEmail, 'student@example.org');
      await prefs.setString(
          BackendAuthRepository.keyDisplayName, 'Bethlehem T.');
      await prefs.setString(BackendAuthRepository.keyRole, 'STUDENT');

      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/auth/me')) {
          return http.Response(
            jsonEncode({
              'user': {
                'id': 'usr-1',
                'email': 'student@example.org',
                'displayName': 'Bethlehem Tadesse',
                'role': 'STUDENT',
                'isSuspended': false,
              }
            }),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      final apiClient = ApiClient(
        baseUrl: 'http://localhost:5000/api',
        httpClient: mockClient,
      );
      final repo = BackendAuthRepository(
        apiClient: apiClient,
        preferences: prefs,
      );

      await repo.init();

      // Immediate offline snapshot available
      expect(repo.snapshot.user, isNotNull);
      expect(repo.snapshot.user!.id, 'usr-1');
      expect(repo.snapshot.user!.email, 'student@example.org');
      expect(repo.snapshot.user!.emailVerified, isTrue);

      // Allow background remote verification microtask to settle
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(repo.snapshot.user!.displayName, 'Bethlehem Tadesse');
    });

    test('init detects suspended account remotely and clears session',
        () async {
      await prefs.setString(
          BackendAuthRepository.keyToken, 'suspended-token-456');
      await prefs.setString(BackendAuthRepository.keyUserId, 'usr-suspended');
      await prefs.setString(
          BackendAuthRepository.keyEmail, 'suspended@example.org');

      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/auth/me')) {
          return http.Response(
            jsonEncode({
              'error': 'ACCOUNT_SUSPENDED',
              'message':
                  'This account has been suspended by community safety.',
            }),
            403,
          );
        }
        return http.Response('Not Found', 404);
      });

      final apiClient = ApiClient(
        baseUrl: 'http://localhost:5000/api',
        httpClient: mockClient,
      );
      final repo = BackendAuthRepository(
        apiClient: apiClient,
        preferences: prefs,
      );

      await repo.init();
      // Allow background remote verification microtask to settle
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Session must be cleared and token deleted from local preferences
      expect(repo.snapshot.user, isNull);
      expect(prefs.getString(BackendAuthRepository.keyToken), isNull);
    });

    test('register persists token and user info upon 201 response with token',
        () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/auth/register')) {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          expect(body['email'], 'newuser@example.org');
          expect(body['displayName'], 'New Student');
          return http.Response(
            jsonEncode({
              'token': 'jwt-registered-token-789',
              'user': {
                'id': 'usr-new-1',
                'email': 'newuser@example.org',
                'displayName': 'New Student',
                'role': 'STUDENT',
              }
            }),
            201,
          );
        }
        return http.Response('Not Found', 404);
      });

      final apiClient = ApiClient(
        baseUrl: 'http://localhost:5000/api',
        httpClient: mockClient,
      );
      final repo = BackendAuthRepository(
        apiClient: apiClient,
        preferences: prefs,
      );

      final outcome = await repo.register(
        email: 'newuser@example.org',
        password: 'Password123!',
        displayName: 'New Student',
      );

      expect(outcome, RegistrationOutcome.signedIn);
      expect(repo.snapshot.user, isNotNull);
      expect(repo.snapshot.user!.id, 'usr-new-1');
      expect(repo.snapshot.user!.email, 'newuser@example.org');
      expect(repo.snapshot.user!.displayName, 'New Student');
      expect(
          prefs.getString(BackendAuthRepository.keyToken), 'jwt-registered-token-789');
    });

    test(
        'register returns verificationPending when email confirmation is required',
        () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/auth/register')) {
          return http.Response(
            jsonEncode({
              'success': true,
              'verificationPending': true,
              'email': 'student@example.org',
              'message': 'Verification email sent.',
            }),
            201,
          );
        }
        return http.Response('Not Found', 404);
      });

      final apiClient = ApiClient(
        baseUrl: 'http://localhost:5000/api',
        httpClient: mockClient,
      );
      final repo = BackendAuthRepository(
        apiClient: apiClient,
        preferences: prefs,
      );

      final outcome = await repo.register(
        email: 'student@example.org',
        password: 'Password123!',
        displayName: 'Student Name',
      );

      expect(outcome, RegistrationOutcome.verificationPending);
      expect(repo.snapshot.user, isNull);
    });

    test('register throws AuthIssue.emailAlreadyInUse on 409 EMAIL_EXISTS',
        () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': 'EMAIL_EXISTS',
            'message': 'An account with this email address already exists.',
          }),
          409,
        );
      });

      final apiClient = ApiClient(
        baseUrl: 'http://localhost:5000/api',
        httpClient: mockClient,
      );
      final repo = BackendAuthRepository(
        apiClient: apiClient,
        preferences: prefs,
      );

      expect(
        () => repo.register(
          email: 'duplicate@example.org',
          password: 'Password123!',
          displayName: 'Duplicate User',
        ),
        throwsA(
          isA<AuthFailure>().having(
            (f) => f.issue,
            'issue',
            AuthIssue.emailAlreadyInUse,
          ),
        ),
      );
    });

    test('signIn with valid credentials saves session and emits snapshot',
        () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/auth/login')) {
          return http.Response(
            jsonEncode({
              'token': 'jwt-login-token-999',
              'user': {
                'id': 'usr-login-1',
                'email': 'student@example.org',
                'displayName': 'Student User',
                'role': 'STUDENT',
              }
            }),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      final apiClient = ApiClient(
        baseUrl: 'http://localhost:5000/api',
        httpClient: mockClient,
      );
      final repo = BackendAuthRepository(
        apiClient: apiClient,
        preferences: prefs,
      );

      await repo.signIn(
        email: 'student@example.org',
        password: 'validPassword123',
      );

      expect(repo.snapshot.user, isNotNull);
      expect(repo.snapshot.user!.id, 'usr-login-1');
      expect(repo.snapshot.user!.email, 'student@example.org');
      expect(prefs.getString(BackendAuthRepository.keyToken), 'jwt-login-token-999');
    });

    test('signIn with suspended account throws AuthIssue.accountSuspended',
        () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': 'ACCOUNT_SUSPENDED',
            'message':
                'This account has been suspended by community safety.',
          }),
          403,
        );
      });

      final apiClient = ApiClient(
        baseUrl: 'http://localhost:5000/api',
        httpClient: mockClient,
      );
      final repo = BackendAuthRepository(
        apiClient: apiClient,
        preferences: prefs,
      );

      expect(
        () => repo.signIn(
          email: 'suspended@example.org',
          password: 'validPassword123',
        ),
        throwsA(
          isA<AuthFailure>().having(
            (f) => f.issue,
            'issue',
            AuthIssue.accountSuspended,
          ),
        ),
      );
      expect(repo.snapshot.user, isNull);
    });

    test('signIn with unverified email throws AuthIssue.emailNotConfirmed',
        () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': 'EMAIL_NOT_CONFIRMED',
            'message':
                'Please confirm your email address before signing in.',
          }),
          403,
        );
      });

      final apiClient = ApiClient(
        baseUrl: 'http://localhost:5000/api',
        httpClient: mockClient,
      );
      final repo = BackendAuthRepository(
        apiClient: apiClient,
        preferences: prefs,
      );

      expect(
        () => repo.signIn(
          email: 'unconfirmed@example.org',
          password: 'validPassword123',
        ),
        throwsA(
          isA<AuthFailure>().having(
            (f) => f.issue,
            'issue',
            AuthIssue.emailNotConfirmed,
          ),
        ),
      );
      expect(repo.snapshot.user, isNull);
    });

    test('signIn with incorrect password throws AuthIssue.invalidCredentials',
        () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': 'INVALID_CREDENTIALS',
            'message': 'Email or password is incorrect.',
          }),
          401,
        );
      });

      final apiClient = ApiClient(
        baseUrl: 'http://localhost:5000/api',
        httpClient: mockClient,
      );
      final repo = BackendAuthRepository(
        apiClient: apiClient,
        preferences: prefs,
      );

      expect(
        () => repo.signIn(
          email: 'student@example.org',
          password: 'wrongPassword',
        ),
        throwsA(
          isA<AuthFailure>().having(
            (f) => f.issue,
            'issue',
            AuthIssue.invalidCredentials,
          ),
        ),
      );
    });

    test('updateDisplayName updates local state and preference', () async {
      await prefs.setString(BackendAuthRepository.keyToken, 'token-profile');
      await prefs.setString(BackendAuthRepository.keyUserId, 'usr-p');
      await prefs.setString(BackendAuthRepository.keyEmail, 'p@example.org');
      await prefs.setString(BackendAuthRepository.keyDisplayName, 'Old Name');

      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/auth/profile')) {
          return http.Response(
            jsonEncode({
              'user': {
                'id': 'usr-p',
                'email': 'p@example.org',
                'displayName': 'Updated Student Name',
                'role': 'STUDENT',
              }
            }),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      final apiClient = ApiClient(
        baseUrl: 'http://localhost:5000/api',
        httpClient: mockClient,
      );
      final repo = BackendAuthRepository(
        apiClient: apiClient,
        preferences: prefs,
      );

      await repo.init();
      await repo.updateDisplayName('Updated Student Name');

      expect(repo.snapshot.user!.displayName, 'Updated Student Name');
      expect(prefs.getString(BackendAuthRepository.keyDisplayName),
          'Updated Student Name');
    });

    test('signOut clears stored credentials and emits empty snapshot',
        () async {
      await prefs.setString(BackendAuthRepository.keyToken, 'token-to-delete');
      await prefs.setString(BackendAuthRepository.keyUserId, 'usr-del');
      await prefs.setString(BackendAuthRepository.keyEmail, 'del@example.org');

      final apiClient = ApiClient(baseUrl: 'http://localhost:5000/api');
      final repo = BackendAuthRepository(
        apiClient: apiClient,
        preferences: prefs,
      );

      await repo.init();
      expect(repo.snapshot.user, isNotNull);

      await repo.signOut();

      expect(repo.snapshot.user, isNull);
      expect(prefs.getString(BackendAuthRepository.keyToken), isNull);
      expect(prefs.getString(BackendAuthRepository.keyUserId), isNull);
      expect(prefs.getString(BackendAuthRepository.keyEmail), isNull);
    });
  });
}
