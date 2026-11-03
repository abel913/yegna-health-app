import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/auth/auth_controller.dart';
import 'package:yegna_health_app/src/auth/auth_models.dart';
import 'package:yegna_health_app/src/auth/auth_pages.dart';
import 'package:yegna_health_app/src/notifications/notification_controller.dart';
import 'package:yegna_health_app/src/notifications/notification_models.dart';

import 'support/fake_auth_repository.dart';

Widget _buildAuthTestApp({
  required AuthController controller,
  required InAppNotificationController notificationController,
  AuthPageMode initialMode = AuthPageMode.signIn,
  Locale locale = const Locale('en'),
}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Scaffold(
      body: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => Navigator.of(context).push<void>(
            MaterialPageRoute<void>(
              builder: (_) => AuthPage(
                controller: controller,
                notificationController: notificationController,
                initialMode: initialMode,
              ),
            ),
          ),
          child: const Text('Open Auth'),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Feedback & Notifications Tests', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    testWidgets(
        'successful sign-in displays Welcome back SnackBar and records notification',
        (tester) async {
      final fakeRepo = FakeAuthRepository();
      final authController = AuthController(fakeRepo);
      final notificationController = InAppNotificationController(prefs);
      await notificationController.load(
          isAmharic: false, healthTipsEnabled: false);

      await tester.pumpWidget(_buildAuthTestApp(
        controller: authController,
        notificationController: notificationController,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Auth'));
      await tester.pumpAndSettle();

      final emailField = find.byType(TextFormField).at(0);
      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(emailField, 'bethlehem@example.org');
      await tester.enterText(passwordField, 'securePassword123');

      final l10n = AppLocalizations.of(tester.element(find.byType(AuthPage)));
      await tester.tap(find.text(l10n.loginAction).last);
      await tester.pumpAndSettle();

      // Verify Welcome back banner appeared
      expect(find.textContaining('Welcome back, Test User!'), findsOneWidget);
      expect(find.byIcon(Icons.waving_hand_rounded), findsOneWidget);

      // Verify notification recorded in controller
      expect(
          notificationController.notifications.any((n) =>
              n.type == NotificationType.welcome && n.title == 'Welcome back!'),
          isTrue);

      authController.dispose();
    });

    testWidgets(
        'successful registration with direct sign-in displays Welcome to Yegna Health banner',
        (tester) async {
      final fakeRepo = FakeAuthRepository(
        registrationOutcome: RegistrationOutcome.signedIn,
      );
      final authController = AuthController(fakeRepo);
      final notificationController = InAppNotificationController(prefs);
      await notificationController.load(
          isAmharic: false, healthTipsEnabled: false);

      await tester.pumpWidget(_buildAuthTestApp(
        controller: authController,
        notificationController: notificationController,
        initialMode: AuthPageMode.register,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Auth'));
      await tester.pumpAndSettle();

      final nameField = find.byType(TextFormField).at(0);
      final emailField = find.byType(TextFormField).at(1);
      final passField = find.byType(TextFormField).at(2);
      final confirmField = find.byType(TextFormField).at(3);

      await tester.enterText(nameField, 'Kidus');
      await tester.enterText(emailField, 'kidus@example.org');
      await tester.enterText(passField, 'securePass123');
      await tester.enterText(confirmField, 'securePass123');

      final l10n = AppLocalizations.of(tester.element(find.byType(AuthPage)));
      await tester.tap(find.text(l10n.registerAction).last);
      await tester.pumpAndSettle();

      // Verify celebratory banner appeared
      expect(find.textContaining('Welcome to Yegna Health, Kidus!'),
          findsOneWidget);
      expect(find.byIcon(Icons.celebration_rounded), findsOneWidget);

      // Verify notification recorded
      expect(
          notificationController.notifications.any((n) =>
              n.type == NotificationType.account &&
              n.title == 'Welcome to Yegna Health!'),
          isTrue);

      authController.dispose();
    });

    testWidgets(
        'registration with verificationPending displays check email banner',
        (tester) async {
      final fakeRepo = FakeAuthRepository(
        registrationOutcome: RegistrationOutcome.verificationPending,
      );
      final authController = AuthController(fakeRepo);
      final notificationController = InAppNotificationController(prefs);
      await notificationController.load(
          isAmharic: false, healthTipsEnabled: false);

      await tester.pumpWidget(_buildAuthTestApp(
        controller: authController,
        notificationController: notificationController,
        initialMode: AuthPageMode.register,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Auth'));
      await tester.pumpAndSettle();

      final nameField = find.byType(TextFormField).at(0);
      final emailField = find.byType(TextFormField).at(1);
      final passField = find.byType(TextFormField).at(2);
      final confirmField = find.byType(TextFormField).at(3);

      await tester.enterText(nameField, 'Sara');
      await tester.enterText(emailField, 'sara@example.org');
      await tester.enterText(passField, 'securePass123');
      await tester.enterText(confirmField, 'securePass123');

      final l10n = AppLocalizations.of(tester.element(find.byType(AuthPage)));
      await tester.tap(find.text(l10n.registerAction).last);
      await tester.pumpAndSettle();

      // Verify pending notification banner appeared
      expect(find.textContaining('Please check your email'), findsOneWidget);
      expect(find.byIcon(Icons.mark_email_unread_rounded), findsOneWidget);

      // Verify notification recorded
      expect(
          notificationController.notifications.any((n) =>
              n.type == NotificationType.account &&
              n.title == 'Account Created — Verification Pending'),
          isTrue);

      authController.dispose();
    });
  });
}
