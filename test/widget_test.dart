import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/main.dart';
import 'package:yegna_health_app/src/auth/auth_controller.dart';
import 'package:yegna_health_app/src/auth/auth_repository.dart';
import 'package:yegna_health_app/src/locale_controller.dart';

import 'support/fake_auth_repository.dart';
import 'support/fake_learning.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('account form is localized in Amharic',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'preferred_locale': 'am'});
    final preferences = await SharedPreferences.getInstance();
    final localeController = LocaleController(preferences);
    await localeController.load();
    final authController = AuthController(FakeAuthRepository());
    final amharic = await AppLocalizations.delegate.load(const Locale('am'));

    await tester.pumpWidget(YegnaHealthApp(
      localeController: localeController,
      authController: authController,
      progressStore: FakeLearningProgressStore(),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(amharic.accountTab),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, amharic.accountTitle));
    await tester.pumpAndSettle();

    expect(find.text(amharic.emailLabel), findsOneWidget);
    expect(find.text(amharic.noAccount), findsOneWidget);
    authController.dispose();
  });

  testWidgets('Yegna Health app starts', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final localeController = LocaleController(preferences);
    await localeController.load();
    final authController = AuthController(const UnconfiguredAuthRepository());

    await tester.pumpWidget(
      YegnaHealthApp(
        localeController: localeController,
        authController: authController,
        progressStore: FakeLearningProgressStore(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(YegnaHealthApp), findsOneWidget);
    authController.dispose();
  });

  testWidgets('five main destinations navigate and locale toggle updates UI',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final localeController = LocaleController(preferences);
    await localeController.load();
    final authController = AuthController(const UnconfiguredAuthRepository());

    await tester.pumpWidget(YegnaHealthApp(
      localeController: localeController,
      authController: authController,
      progressStore: FakeLearningProgressStore(),
    ));
    await tester.pumpAndSettle();
    final en = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.tap(find.text(en.facilitiesTab).last);
    await tester.pumpAndSettle();
    expect(find.text(en.noVerifiedFacilitiesTitle), findsOneWidget);

    await tester.tap(find.text(en.mentorsTab).last);
    await tester.pumpAndSettle();
    expect(find.text(en.noVerifiedMentorsTitle), findsOneWidget);

    await tester.tap(find.text(en.learnTab).last);
    await tester.pumpAndSettle();
    expect(find.text(en.articlesHeading), findsOneWidget);
    expect(find.text(en.assessmentsHeading), findsOneWidget);

    await tester.tap(find.text(en.accountTab).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('language_dropdown_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('አማ').last);
    await tester.pumpAndSettle();
    final am = await AppLocalizations.delegate.load(const Locale('am'));
    expect(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(am.accountTab),
      ),
      findsOneWidget,
    );
    expect(find.text(am.languageTitle), findsOneWidget);
    authController.dispose();
  });

  testWidgets('guest can open public services and account entry',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final localeController = LocaleController(preferences);
    await localeController.load();
    final authController = AuthController(FakeAuthRepository());

    await tester.pumpWidget(YegnaHealthApp(
      localeController: localeController,
      authController: authController,
      progressStore: FakeLearningProgressStore(),
    ));
    await tester.pumpAndSettle();
    final l10n =
        AppLocalizations.of(tester.element(find.byType(NavigationBar)));

    // Phase 2 account access is visible from the initial Home screen.
    await tester.tap(find.text(l10n.accountTitle).first);
    await tester.pumpAndSettle();
    expect(find.text(l10n.loginAction), findsNWidgets(2));
    await tester.tap(find.text(l10n.continueAsGuest));
    await tester.pumpAndSettle();

    // Public destinations remain reachable for guest users.
    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(l10n.facilitiesTab),
    ));
    await tester.pumpAndSettle();
    expect(find.text(l10n.noVerifiedFacilitiesTitle), findsOneWidget);
    await tester.tap(find.text(l10n.mentorsTab).last);
    await tester.pumpAndSettle();
    expect(find.text(l10n.noVerifiedMentorsTitle), findsOneWidget);
    expect(authController.isAuthenticated, isFalse);

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(l10n.accountTab),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, l10n.accountTitle));
    await tester.pumpAndSettle();
    expect(find.text(l10n.emailLabel), findsOneWidget);
    expect(find.text(l10n.continueAsGuest), findsOneWidget);
    authController.dispose();
  });

  testWidgets(
      'home account entry opens sign-in, validation, registration, and recovery',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final localeController = LocaleController(preferences);
    await localeController.load();
    final authController = AuthController(FakeAuthRepository());

    await tester.pumpWidget(YegnaHealthApp(
      localeController: localeController,
      authController: authController,
      progressStore: FakeLearningProgressStore(),
    ));
    await tester.pumpAndSettle();
    final l10n =
        AppLocalizations.of(tester.element(find.byType(NavigationBar)));

    await tester.tap(find.text(l10n.accountTitle).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.loginAction).last);
    await tester.pumpAndSettle();
    expect(find.text(l10n.errorEmailRequired), findsOneWidget);

    await tester.tap(find.text(l10n.noAccount));
    await tester.pumpAndSettle();
    expect(find.text(l10n.createAccount), findsNWidgets(2));
    await tester.tap(find.text(l10n.hasAccount));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.forgotPassword));
    await tester.pumpAndSettle();
    expect(find.text(l10n.sendRecoveryEmail), findsOneWidget);

    authController.dispose();
  });

  testWidgets('verified user can open, edit, and sign out of profile',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final localeController = LocaleController(preferences);
    await localeController.load();
    final repository = FakeAuthRepository();
    final authController = AuthController(repository);

    await tester.pumpWidget(YegnaHealthApp(
      localeController: localeController,
      authController: authController,
      progressStore: FakeLearningProgressStore(),
    ));
    await tester.pumpAndSettle();
    final l10n =
        AppLocalizations.of(tester.element(find.byType(NavigationBar)));

    await tester.tap(find.text(l10n.accountTitle).first);
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byType(TextFormField).at(0), 'test@example.org');
    await tester.enterText(find.byType(TextFormField).at(1), 'valid-password');
    await tester.tap(find.text(l10n.loginAction).last);
    await tester.pumpAndSettle();
    expect(authController.isAuthenticated, isTrue);

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(l10n.accountTab),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, l10n.profile));
    await tester.pumpAndSettle();
    expect(find.text(l10n.saveProfile), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'Updated Name');
    await tester.tap(find.text(l10n.saveProfile));
    await tester.pumpAndSettle();
    expect(find.text(l10n.profileSaved), findsOneWidget);
    expect(repository.updatedDisplayName, 'Updated Name');

    await tester.tap(find.text(l10n.signOut));
    await tester.pumpAndSettle();
    expect(authController.isAuthenticated, isFalse);
    expect(find.text(l10n.accountTitle).first, findsOneWidget);

    authController.dispose();
  });

  testWidgets(
      'registration displays provider-backed verification pending state',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final localeController = LocaleController(preferences);
    await localeController.load();
    final repository = FakeAuthRepository();
    final authController = AuthController(repository);

    await tester.pumpWidget(YegnaHealthApp(
      localeController: localeController,
      authController: authController,
      progressStore: FakeLearningProgressStore(),
    ));
    await tester.pumpAndSettle();
    final l10n =
        AppLocalizations.of(tester.element(find.byType(NavigationBar)));
    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(l10n.accountTab),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, l10n.accountTitle));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.noAccount));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'test@example.org');
    await tester.enterText(
        find.byType(TextFormField).at(2), 'long-enough-password');
    await tester.enterText(
        find.byType(TextFormField).at(3), 'long-enough-password');
    await tester.tap(find.text(l10n.registerAction).last);
    await tester.pumpAndSettle();

    expect(find.text(l10n.verificationPendingTitle), findsOneWidget);
    expect(repository.registerCalls, 1);
    expect(authController.isAuthenticated, isFalse);
    authController.dispose();
  });
}
