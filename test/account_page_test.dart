import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/account/app_settings_controller.dart';
import 'package:yegna_health_app/src/app.dart';
import 'package:yegna_health_app/src/auth/auth_controller.dart';
import 'package:yegna_health_app/src/auth/auth_models.dart';
import 'package:yegna_health_app/src/locale_controller.dart';
import 'package:yegna_health_app/src/learning/learning_progress_controller.dart';

import 'support/fake_auth_repository.dart';
import 'support/fake_learning.dart';

void main() {
  Widget buildTestApp({
    Locale locale = const Locale('en'),
    required AuthController authController,
    required AppSettingsController settingsController,
    required LocaleController localeController,
    LearningProgressController? progressController,
    VoidCallback? onOpenAccount,
  }) {
    final assessments = FakeAssessmentRepository();
    final progress = progressController ??
        LearningProgressController(
          repository: FakeLearningProgressStore(),
          authController: authController,
        );

    return ListenableBuilder(
      listenable: settingsController,
      builder: (context, _) => MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        themeMode: settingsController.themeMode,
        theme: ThemeData(
          brightness: Brightness.light,
          cardTheme: const CardThemeData(color: Colors.white),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          cardTheme: const CardThemeData(color: Color(0xFF1E293B)),
        ),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(settingsController.textScaleFactor),
          ),
          child: child!,
        ),
        home: AppShell(
          localeController: localeController,
          authController: authController,
          settingsController: settingsController,
          educationRepository: FakeEducationRepository(),
          assessmentRepository: assessments,
          progressController: progress,
        ),
      ),
    );
  }

  group('Account Page & Functional Settings Widget Tests', () {
    testWidgets('authenticated user can open theme modal to select dark mode',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final settingsController = AppSettingsController(prefs);
      await settingsController.load();

      final authController = AuthController(FakeAuthRepository(
        initialSnapshot: const AuthSnapshot(
          user: AuthUser(
            id: 'test_user',
            email: 'user@example.org',
            displayName: 'Abebe Bikila',
            emailVerified: true,
          ),
        ),
      ));

      final localeController = LocaleController(prefs);
      await localeController.load();

      await tester.pumpWidget(buildTestApp(
        authController: authController,
        settingsController: settingsController,
        localeController: localeController,
      ));
      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      // Navigate to Account tab (index 4)
      await tester.tap(find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(l10n.accountTab),
      ));
      await tester.pumpAndSettle();

      // Verify user display name is visible and no guest promo banner
      expect(find.text('Abebe Bikila'), findsOneWidget);
      expect(find.text(l10n.guestSignInPromoTitle), findsNothing);

      // Verify initial theme badge displays Light theme
      expect(find.text(l10n.lightTheme), findsOneWidget);

      // Tap App Theme
      await tester.tap(find.text(l10n.appTheme));
      await tester.pumpAndSettle();

      // Modal is visible with only 2 theme options (System Default is removed)
      expect(find.text(l10n.themeDialogTitle), findsOneWidget);
      expect(find.text(l10n.systemTheme), findsNothing);
      expect(find.text(l10n.lightTheme), findsWidgets);
      expect(find.text(l10n.darkTheme), findsOneWidget);

      // Tap Dark Theme
      await tester.tap(find.text(l10n.darkTheme));
      await tester.pumpAndSettle();

      // Verify ThemeMode changed to dark
      expect(settingsController.themeMode, ThemeMode.dark);
      expect(settingsController.isDark, isTrue);
      expect(prefs.getString('app_theme_mode'), 'dark');
      expect(find.text(l10n.darkTheme), findsOneWidget);
    });

    testWidgets('allows changing text size and updates global scaling',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final settingsController = AppSettingsController(prefs);
      await settingsController.load();

      final authController = AuthController(FakeAuthRepository(
        initialSnapshot: const AuthSnapshot(
          user: AuthUser(
            id: 'test_user',
            email: 'user@example.org',
            displayName: 'Abebe Bikila',
            emailVerified: true,
          ),
        ),
      ));

      final localeController = LocaleController(prefs);
      await localeController.load();

      await tester.pumpWidget(buildTestApp(
        authController: authController,
        settingsController: settingsController,
        localeController: localeController,
      ));
      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      // Navigate to Account tab
      await tester.tap(find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(l10n.accountTab),
      ));
      await tester.pumpAndSettle();

      // Tap Text Size
      await tester.tap(find.text(l10n.textSize));
      await tester.pumpAndSettle();

      expect(find.text(l10n.textSizeDialogTitle), findsOneWidget);
      expect(find.text(l10n.smallTextSize), findsOneWidget);
      expect(find.text(l10n.defaultTextSize), findsWidgets);
      expect(find.text(l10n.largeTextSize), findsOneWidget);

      // Tap Large Text Size
      await tester.tap(find.text(l10n.largeTextSize));
      await tester.pumpAndSettle();

      expect(settingsController.textScale, AppTextScale.large);
      expect(settingsController.textScaleFactor, 1.18);
      expect(prefs.getString('app_text_scale'), 'large');
    });

    testWidgets('notifications modal allows toggling preferences and persists',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final settingsController = AppSettingsController(prefs);
      await settingsController.load();

      final authController = AuthController(FakeAuthRepository(
        initialSnapshot: const AuthSnapshot(
          user: AuthUser(
            id: 'test_user',
            email: 'user@example.org',
            displayName: 'Abebe Bikila',
            emailVerified: true,
          ),
        ),
      ));

      final localeController = LocaleController(prefs);
      await localeController.load();

      await tester.pumpWidget(buildTestApp(
        authController: authController,
        settingsController: settingsController,
        localeController: localeController,
      ));
      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      // Navigate to Account tab
      await tester.tap(find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(l10n.accountTab),
      ));
      await tester.pumpAndSettle();

      // Tap Notifications
      await tester.tap(find.text(l10n.notifications));
      await tester.pumpAndSettle();

      expect(find.text(l10n.notificationsModalTitle), findsOneWidget);
      expect(find.text(l10n.pushAlertsLabel), findsOneWidget);
      expect(find.text(l10n.healthTipsLabel), findsOneWidget);
      expect(find.text(l10n.assessmentRemindersLabel), findsOneWidget);

      // Toggle first switch (Push Alerts)
      final switches = find.byType(Switch);
      expect(switches, findsNWidgets(3));

      await tester.tap(switches.at(0));
      await tester.pumpAndSettle();

      expect(settingsController.pushAlertsEnabled, isFalse);
      expect(prefs.getBool('notifications_push_alerts'), isFalse);

      // Close modal
      await tester.tap(find.text(l10n.closeButton));
      await tester.pumpAndSettle();
      expect(find.text(l10n.notificationsModalTitle), findsNothing);
    });

    testWidgets('authenticated user sees display name and no guest banner',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final settingsController = AppSettingsController(prefs);
      await settingsController.load();

      final authController = AuthController(FakeAuthRepository(
        initialSnapshot: const AuthSnapshot(
          user: AuthUser(
            id: 'user_123',
            email: 'chala@yegna.org',
            displayName: 'Chala Gemechu',
            emailVerified: true,
          ),
        ),
      ));

      final localeController = LocaleController(prefs);
      await localeController.load();

      await tester.pumpWidget(buildTestApp(
        authController: authController,
        settingsController: settingsController,
        localeController: localeController,
      ));
      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      // Navigate to Profile tab
      await tester.tap(find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(l10n.accountTab),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Chala Gemechu'), findsOneWidget);
      expect(find.text(l10n.guestSignInPromoTitle), findsNothing);

      // Sign out and verify user is safely redirected back to Home as a guest
      authController.signOut();
      await tester.pumpAndSettle();

      expect(authController.isAuthenticated, isFalse);
      expect(find.text(l10n.exploreServicesHeading), findsOneWidget);
    });
  });
}
