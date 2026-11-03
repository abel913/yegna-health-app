import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/notifications/notification_center_sheet.dart';
import 'package:yegna_health_app/src/notifications/notification_controller.dart';

Widget _buildTestApp({
  required InAppNotificationController controller,
  Locale locale = const Locale('en'),
  VoidCallback? onOpenSettings,
  ValueChanged<String>? onNavigate,
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
        builder: (context) => Center(
          child: ElevatedButton(
            onPressed: () => NotificationCenterSheet.show(
              context,
              controller: controller,
              onOpenSettings: onOpenSettings,
              onNavigate: onNavigate,
            ),
            child: const Text('Open Notifications'),
          ),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('In-App Notification Center UI Tests', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    testWidgets('displays notifications, unread badges, and formatted cards',
        (tester) async {
      final controller = InAppNotificationController(prefs);
      await controller.load(isAmharic: false, healthTipsEnabled: true);

      await tester.pumpWidget(_buildTestApp(controller: controller));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Notifications'));
      await tester.pumpAndSettle();

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('2 Learning Modules Updated'), findsOneWidget);
      expect(find.text('Daily Youth Health Tip'), findsOneWidget);
      expect(find.text('Mark all read'), findsOneWidget);
    });

    testWidgets('tapping Mark all read updates cards and clears badge',
        (tester) async {
      final controller = InAppNotificationController(prefs);
      await controller.load(isAmharic: false, healthTipsEnabled: true);

      await tester.pumpWidget(_buildTestApp(controller: controller));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Notifications'));
      await tester.pumpAndSettle();

      expect(controller.unreadCount, 2);

      await tester.tap(find.text('Mark all read'));
      await tester.pumpAndSettle();

      expect(controller.unreadCount, 0);
      expect(find.text('Mark all read'), findsNothing);
    });

    testWidgets('clearing all notifications displays empty state view',
        (tester) async {
      final controller = InAppNotificationController(prefs);
      await controller.load(isAmharic: false, healthTipsEnabled: false);

      await tester.pumpWidget(_buildTestApp(controller: controller));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Notifications'));
      await tester.pumpAndSettle();

      final clearButton = find.byIcon(Icons.delete_sweep_outlined);
      expect(clearButton, findsOneWidget);
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      expect(find.text('No notifications yet'), findsOneWidget);
      expect(find.textContaining('You\'re all caught up!'), findsOneWidget);
    });

    testWidgets('renders properly in Amharic', (tester) async {
      final controller = InAppNotificationController(prefs);
      await controller.load(isAmharic: true, healthTipsEnabled: true);

      await tester.pumpWidget(_buildTestApp(
        controller: controller,
        locale: const Locale('am'),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Notifications'));
      await tester.pumpAndSettle();

      expect(find.text('ማሳወቂያዎች'), findsOneWidget);
      expect(find.text('2 የትምህርት ክፍሎች ተዘምነዋል'), findsOneWidget);
      expect(find.text('የዕለቱ የወጣቶች ጤና ምክር'), findsOneWidget);
      expect(find.text('ሁሉንም አንብብ'), findsOneWidget);
    });
  });
}
