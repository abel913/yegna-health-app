import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/src/notifications/notification_controller.dart';
import 'package:yegna_health_app/src/notifications/notification_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InAppNotificationController Unit Tests', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test('loads default seed notifications when empty', () async {
      final controller = InAppNotificationController(prefs);
      expect(controller.notifications, isEmpty);
      expect(controller.unreadCount, 0);

      await controller.load(isAmharic: false, healthTipsEnabled: true);
      expect(controller.notifications.length, 2);
      expect(controller.unreadCount, 2);
      expect(controller.notifications[0].type, NotificationType.learning);
      expect(controller.notifications[1].type, NotificationType.healthTip);
      expect(controller.notifications[0].title, '2 Learning Modules Updated');
    });

    test('loads default seed notifications in Amharic', () async {
      final controller = InAppNotificationController(prefs);
      await controller.load(isAmharic: true, healthTipsEnabled: true);

      expect(controller.notifications.length, 2);
      expect(controller.notifications[0].title, '2 የትምህርት ክፍሎች ተዘምነዋል');
      expect(controller.notifications[1].title, 'የዕለቱ የወጣቶች ጤና ምክር');
    });

    test('respects healthTipsEnabled false when seeding', () async {
      final controller = InAppNotificationController(prefs);
      await controller.load(isAmharic: false, healthTipsEnabled: false);

      expect(controller.notifications.length, 1);
      expect(controller.notifications.first.type, NotificationType.learning);
    });

    test(
        'addWelcomeBackNotification inserts notification and increments unread',
        () async {
      final controller = InAppNotificationController(prefs);
      await controller.load(isAmharic: false, healthTipsEnabled: false);
      expect(controller.unreadCount, 1);

      await controller.addWelcomeBackNotification('Bethlehem',
          isAmharic: false);

      expect(controller.unreadCount, 2);
      final first = controller.notifications.first;
      expect(first.type, NotificationType.welcome);
      expect(first.title, 'Welcome back!');
      expect(first.message, contains('Bethlehem'));
    });

    test('addAccountCreatedNotification adds celebratory notification',
        () async {
      final controller = InAppNotificationController(prefs);
      await controller.load(isAmharic: false, healthTipsEnabled: false);

      await controller.addAccountCreatedNotification('Abebe',
          isAmharic: false, verificationPending: false);

      final first = controller.notifications.first;
      expect(first.type, NotificationType.account);
      expect(first.title, 'Welcome to Yegna Health!');
      expect(first.message, contains('Abebe'));
    });

    test(
        'addAccountCreatedNotification with verificationPending handles pending state',
        () async {
      final controller = InAppNotificationController(prefs);
      await controller.load(isAmharic: false, healthTipsEnabled: false);

      await controller.addAccountCreatedNotification('Abebe',
          isAmharic: false, verificationPending: true);

      final first = controller.notifications.first;
      expect(first.type, NotificationType.account);
      expect(first.title, 'Account Created — Verification Pending');
      expect(first.message, contains('check your email'));
    });

    test('markAsRead updates isRead state and unreadCount', () async {
      final controller = InAppNotificationController(prefs);
      await controller.load(isAmharic: false, healthTipsEnabled: false);

      expect(controller.unreadCount, 1);
      final id = controller.notifications.first.id;

      await controller.markAsRead(id);
      expect(controller.unreadCount, 0);
      expect(controller.notifications.first.isRead, isTrue);
    });

    test('markAllAsRead clears unreadCount', () async {
      final controller = InAppNotificationController(prefs);
      await controller.load(isAmharic: false, healthTipsEnabled: true);
      expect(controller.unreadCount, 2);

      await controller.markAllAsRead();
      expect(controller.unreadCount, 0);
      expect(controller.notifications.every((n) => n.isRead), isTrue);
    });

    test('deleteNotification removes single item', () async {
      final controller = InAppNotificationController(prefs);
      await controller.load(isAmharic: false, healthTipsEnabled: true);
      expect(controller.notifications.length, 2);

      final targetId = controller.notifications.first.id;
      await controller.deleteNotification(targetId);

      expect(controller.notifications.length, 1);
      expect(controller.notifications.any((n) => n.id == targetId), isFalse);
    });

    test('clearAll removes all items', () async {
      final controller = InAppNotificationController(prefs);
      await controller.load(isAmharic: false, healthTipsEnabled: true);
      expect(controller.notifications.isNotEmpty, isTrue);

      await controller.clearAll();
      expect(controller.notifications, isEmpty);
      expect(controller.unreadCount, 0);
    });

    test('persists notifications across controller reloads', () async {
      final controller1 = InAppNotificationController(prefs);
      await controller1.load(isAmharic: false, healthTipsEnabled: false);
      await controller1.addWelcomeBackNotification('Sara', isAmharic: false);

      final controller2 = InAppNotificationController(prefs);
      await controller2.load(isAmharic: false, healthTipsEnabled: false);

      expect(controller2.notifications.length, 2);
      expect(controller2.notifications.first.title, 'Welcome back!');
      expect(controller2.notifications.first.message, contains('Sara'));
    });
  });
}
