import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/admin/admin_clubs_page.dart';
import 'package:yegna_health_app/src/admin/admin_controller.dart';
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

  group('Admin Clubs Control Center Widget Tests', () {
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
      await controller.signIn('admin@yegnahealth.org', 'Admin@123');
    });

    testWidgets('renders AdminClubsPage with executive stats and 3 tabs',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildTestableWidget(
          child: AdminClubsPage(controller: controller),
        ),
      );
      await tester.pumpAndSettle();

      // AppBar title & subtitle
      expect(find.text('Student Clubs Control Center'), findsOneWidget);
      expect(find.text('Governance, Rosters & Live Analytics'), findsOneWidget);

      // Executive stats banner
      expect(find.text('CLUBS ENGAGEMENT INTELLIGENCE'), findsOneWidget);
      expect(find.text('Total Clubs'), findsOneWidget);
      expect(find.text('Enrollments'), findsOneWidget);
      expect(find.text('Students'), findsOneWidget);
      expect(find.text('Occupancy'), findsOneWidget);

      // Tab bar tabs
      expect(find.byIcon(Icons.groups_rounded), findsWidgets);
      expect(find.byIcon(Icons.badge_rounded), findsOneWidget);
      expect(find.byIcon(Icons.analytics_rounded), findsWidgets);

      // Clubs listed in Tab 1
      expect(find.textContaining('Mind & Wellbeing Champions'), findsOneWidget);
      expect(find.textContaining('Campus Reproductive Health Pioneers'),
          findsOneWidget);
    });

    testWidgets('can filter clubs by category and search query',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildTestableWidget(
          child: AdminClubsPage(controller: controller),
        ),
      );
      await tester.pumpAndSettle();

      // Search field
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'Substance');
      await tester.pumpAndSettle();

      expect(find.textContaining('Substance-Free Healthy Youth Alliance'),
          findsOneWidget);
      expect(find.textContaining('Mind & Wellbeing Champions'), findsNothing);

      // Clear search
      await tester.enterText(searchField, '');
      await tester.pumpAndSettle();
      expect(find.textContaining('Mind & Wellbeing Champions'), findsOneWidget);
    });

    testWidgets('can toggle between tabs: Rosters and Analytics',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildTestableWidget(
          child: AdminClubsPage(controller: controller),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Tab 2: Rosters using icon
      final rostersTabIcon = find.byIcon(Icons.badge_rounded);
      await tester.tap(rostersTabIcon);
      await tester.pumpAndSettle();

      // Verify student enrolled rosters are displayed
      expect(find.textContaining('enrolled student(s)'), findsOneWidget);
      expect(find.text('Bethlehem T.'), findsWidgets);

      // Tap Tab 3: Analytics using Tab
      final analyticsTab = find.byType(Tab).last;
      await tester.tap(analyticsTab);
      await tester.pumpAndSettle();

      // Verify deep analytics sections are displayed
      expect(find.text('SYSTEM CAPACITY & UTILIZATION'), findsOneWidget);
      expect(find.text('CATEGORY ENROLLMENT DISTRIBUTION'), findsOneWidget);
      expect(find.text('CLUB ENGAGEMENT LEADERBOARD'), findsOneWidget);
    });

    testWidgets('can open club editor and create a new club from template',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildTestableWidget(
          child: AdminClubsPage(controller: controller),
        ),
      );
      await tester.pumpAndSettle();

      final initialCount = controller.clubs.length;

      // Tap Add Club icon button
      final addBtn = find.byIcon(Icons.add_circle_outline_rounded);
      await tester.tap(addBtn);
      await tester.pumpAndSettle();

      // Dialog is open
      expect(find.text('Create Student Club'), findsOneWidget);
      expect(find.text('IDENTIFICATION & CATEGORY'), findsOneWidget);

      // Enter club name
      final nameField = find.widgetWithText(TextField, 'Club Name (English) *');
      await tester.enterText(nameField, 'Test Youth Astronomy & Health Club');

      // Tap Create Club
      await tester.tap(find.text('Create Club'));
      await tester.pumpAndSettle();

      // Verify club is created in controller
      expect(controller.clubs.length, initialCount + 1);
      expect(
        controller.clubs.any(
            (c) => c.nameEn == 'Test Youth Astronomy & Health Club'),
        isTrue,
      );
    });

    testWidgets('renders cleanly in Amharic locale', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildTestableWidget(
          child: AdminClubsPage(controller: controller),
          locale: const Locale('am'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('የተማሪዎች ክበቦች ቁጥጥር ማዕከል'), findsOneWidget);
      expect(find.text('የክበቦች አጠቃላይ ስታቲስቲክስ'), findsOneWidget);
      expect(find.text('ክበቦች'), findsWidgets);
      expect(find.textContaining('አባላት'), findsWidgets);
      expect(find.text('ስታቲስቲክስ'), findsOneWidget);
    });
  });
}
