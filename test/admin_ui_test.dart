import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/admin/admin_controller.dart';
import 'package:yegna_health_app/src/admin/admin_dashboard_page.dart';
import 'package:yegna_health_app/src/admin/admin_login_page.dart';
import 'package:yegna_health_app/src/admin/admin_modules_page.dart';
import 'package:yegna_health_app/src/admin/admin_quizzes_page.dart';
import 'package:yegna_health_app/src/admin/admin_repository.dart';
import 'package:yegna_health_app/src/clubs/club_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildTestableWidget({
    required Widget child,
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
      home: child,
    );
  }

  group('Admin Portal UI Widget Tests', () {
    late SharedPreferences prefs;
    late ClubRepository clubRepository;
    late AdminRepository adminRepository;
    late AdminController controller;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      clubRepository = LocalClubRepository(preferences: prefs);
      adminRepository = LocalAdminRepository(
        clubRepository: clubRepository,
        preferences: prefs,
      );
      controller = AdminController(repository: adminRepository);
    });

    testWidgets(
        'AdminLoginPage rejects invalid password and signs in with valid',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          child: AdminLoginPage(controller: controller),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Administrator Authentication'), findsOneWidget);
      expect(find.text('Enter Dashboard'), findsOneWidget);

      // Enter invalid password
      final emailField = find.byType(TextField).first;
      final passwordField = find.byType(TextField).last;
      await tester.enterText(emailField, 'natnaelzemene21@gmail.com');
      await tester.enterText(passwordField, 'wrongPassword');
      await tester.tap(find.text('Enter Dashboard'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Invalid administrator credentials'),
          findsOneWidget);

      // Enter valid password stored in database
      await tester.enterText(passwordField, 'admin1234');
      await tester.tap(find.text('Enter Dashboard'));
      await tester.pumpAndSettle();

      expect(find.text('Executive Admin Console'), findsOneWidget);
    });

    testWidgets(
        'AdminDashboardPage displays metric cards and management sections',
        (tester) async {
      await controller.signIn('admin@yegnahealth.org', 'Admin@123');

      await tester.pumpWidget(
        buildTestableWidget(
          child: AdminDashboardPage(controller: controller),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Executive Admin Console'), findsOneWidget);
      expect(find.text('Student Clubs'), findsWidgets);
      expect(find.text('Quiz Questions'), findsWidgets);
      expect(find.text('Learning Modules'), findsWidgets);
      expect(find.text('Published Articles'), findsWidgets);
      expect(find.text('Health Facilities'), findsWidgets);
      expect(find.text('Peer Mentors'), findsWidgets);
    });

    testWidgets('AdminModulesPage renders modules list and adds from template',
        (tester) async {
      await controller.signIn('admin@yegnahealth.org', 'Admin@123');

      await tester.pumpWidget(
        buildTestableWidget(
          child: AdminModulesPage(controller: controller),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Manage Learning Modules'), findsOneWidget);

      // Tap + button to open editor dialog
      await tester.tap(find.byIcon(Icons.add_circle_outline_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Create Learning Module'), findsOneWidget);
      expect(find.text('Load Template'), findsOneWidget);

      // Tap Load Template
      await tester.tap(find.text('Load Template'));
      await tester.pumpAndSettle();

      // Tap Save Module
      await tester.tap(find.text('Save Module'));
      await tester.pumpAndSettle();

      expect(find.text('Create Learning Module'), findsNothing);
    });

    testWidgets('AdminQuizzesPage renders questions bank and editor',
        (tester) async {
      await controller.signIn('admin@yegnahealth.org', 'Admin@123');

      await tester.pumpWidget(
        buildTestableWidget(
          child: AdminQuizzesPage(controller: controller),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Quiz & Question Bank'), findsOneWidget);
      expect(find.textContaining('Q1'), findsOneWidget);

      // Tap + button
      await tester.tap(find.byIcon(Icons.add_circle_outline_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Add Quiz Question'), findsOneWidget);
      expect(find.text('Template'), findsOneWidget);

      // Tap Template to load
      await tester.tap(find.text('Template'));
      await tester.pumpAndSettle();

      // Cancel dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Add Quiz Question'), findsNothing);
    });
  });
}
