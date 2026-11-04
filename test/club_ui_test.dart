import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/clubs/club_controller.dart';
import 'package:yegna_health_app/src/clubs/club_repository.dart';
import 'package:yegna_health_app/src/clubs/clubs_page.dart';
import 'package:yegna_health_app/src/notifications/notification_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildTestableWidget({
    required ClubController controller,
    InAppNotificationController? notificationController,
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
      home: ClubsPage(
        controller: controller,
        userId: 'student_ui_test_1',
        userName: 'Abebe Kebede',
        userEmail: 'abebe@aau.edu.et',
        notificationController: notificationController,
      ),
    );
  }

  group('Student Clubs UI Widget Tests', () {
    late SharedPreferences prefs;
    late ClubRepository repository;
    late ClubController controller;
    late InAppNotificationController notificationController;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      repository = LocalClubRepository(preferences: prefs);
      controller = ClubController(repository: repository);
      notificationController = InAppNotificationController(prefs);
      await notificationController.load();
    });

    testWidgets('renders ClubsPage with title, search, and pre-seeded clubs',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          controller: controller,
          notificationController: notificationController,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Student Health Clubs'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Explore All'), findsOneWidget);
      expect(find.textContaining('My Clubs'), findsOneWidget);
      expect(find.textContaining('Girls\' Health & Wellness Club'),
          findsOneWidget);
    });

    testWidgets('can tap club card to open detail sheet and join club',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          controller: controller,
          notificationController: notificationController,
        ),
      );
      await tester.pumpAndSettle();

      // Tap the first club card
      final firstCard = find.textContaining('Girls\' Health & Wellness Club');
      expect(firstCard, findsOneWidget);
      await tester.tap(firstCard);
      await tester.pumpAndSettle();

      // Detail sheet is presented
      expect(find.text('Meeting Schedule'), findsOneWidget);
      expect(find.text('Location / Venue'), findsOneWidget);
      expect(find.text('Community Guidelines'), findsOneWidget);

      // Scroll sheet down to reveal button
      await tester.drag(find.byType(ListView).last, const Offset(0, -400));
      await tester.pumpAndSettle();

      final joinBtn = find.text('Join This Club');
      expect(joinBtn, findsOneWidget);

      // Tap Join This Club
      await tester.tap(joinBtn);
      await tester.pumpAndSettle();

      // Detail sheet pops, card shows Joined status
      expect(find.textContaining('Joined'), findsWidgets);
      expect(controller.isJoined('template_girls_wellness'), isTrue);
    });

    testWidgets('toggles to My Clubs and shows joined club', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          controller: controller,
          notificationController: notificationController,
        ),
      );
      await tester.pumpAndSettle();

      // Join a club directly
      await controller.joinClub('template_girls_wellness', 'student_ui_test_1');
      await tester.pumpAndSettle();

      // Tap "My Clubs"
      final myClubsTab = find.textContaining('My Clubs');
      await tester.tap(myClubsTab);
      await tester.pumpAndSettle();

      // Should show the joined club
      expect(find.textContaining('Girls\' Health & Wellness Club'),
          findsOneWidget);
    });

    testWidgets('renders cleanly in Amharic locale', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          controller: controller,
          notificationController: notificationController,
          locale: const Locale('am'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('የተማሪዎች የጤና ክበቦች'), findsOneWidget);
      expect(find.text('ሁሉንም አስስ'), findsOneWidget);
      expect(find.textContaining('የሴቶች ጤና እና ደህንነት ክበብ'), findsOneWidget);
    });
  });
}
