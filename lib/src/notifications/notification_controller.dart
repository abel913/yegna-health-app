import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'default_notification_seed.dart';
import 'notification_models.dart';

/// Available category and status filters for notification center views.
enum NotificationFilter {
  all,
  unread,
  urgent,
  clubs,
  tips,
  learning,
}

/// Manages in-app notifications, unread counters, real-time sync, and offline persistence.
class InAppNotificationController extends ChangeNotifier {
  InAppNotificationController([this._preferences]);

  final SharedPreferences? _preferences;
  static const String storageKey = 'yegna_in_app_notifications_v1';

  final List<InAppNotification> _notifications = [];
  bool _initialized = false;

  /// Surfaces newly arrived urgent or high-priority notifications for floating banners.
  final ValueNotifier<InAppNotification?> bannerNotifier = ValueNotifier(null);

  List<InAppNotification> get notifications =>
      List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  int get urgentCount =>
      _notifications.where((n) => !n.isRead && n.priority == NotificationPriority.urgent).length;

  bool get isInitialized => _initialized;

  List<InAppNotification> filteredNotifications(NotificationFilter filter) {
    switch (filter) {
      case NotificationFilter.all:
        return notifications;
      case NotificationFilter.unread:
        return _notifications.where((n) => !n.isRead).toList();
      case NotificationFilter.urgent:
        return _notifications
            .where((n) => n.priority == NotificationPriority.urgent || n.type == NotificationType.alert)
            .toList();
      case NotificationFilter.clubs:
        return _notifications
            .where((n) => n.type == NotificationType.club || n.type == NotificationType.facility)
            .toList();
      case NotificationFilter.tips:
        return _notifications.where((n) => n.type == NotificationType.healthTip).toList();
      case NotificationFilter.learning:
        return _notifications.where((n) => n.type == NotificationType.learning).toList();
    }
  }

  Future<void> load({
    bool isAmharic = false,
    bool healthTipsEnabled = true,
  }) async {
    _notifications.clear();
    try {
      final prefs = _preferences ?? await SharedPreferences.getInstance();
      final raw = prefs.getString(storageKey);
      if (raw != null && raw.trim().isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          for (final item in decoded) {
            if (item is Map<String, dynamic>) {
              _notifications.add(InAppNotification.fromJson(item));
            }
          }
        }
      }
    } catch (_) {
      // Safe fallback if storage unavailable
    }

    if (_notifications.isEmpty) {
      _notifications.addAll(
        DefaultNotificationSeed.generate(
          isAmharic: isAmharic,
          healthTipsEnabled: healthTipsEnabled,
        ),
      );
    }

    _sortNotifications();
    _initialized = true;
    notifyListeners();
  }

  void _sortNotifications() {
    _notifications.sort((a, b) {
      if (a.isPinned != b.isPinned) {
        return a.isPinned ? -1 : 1;
      }
      if (a.priority == NotificationPriority.urgent &&
          b.priority != NotificationPriority.urgent) {
        return -1;
      }
      if (b.priority == NotificationPriority.urgent &&
          a.priority != NotificationPriority.urgent) {
        return 1;
      }
      return b.timestamp.compareTo(a.timestamp);
    });
  }

  Future<void> addNotification(InAppNotification notification) async {
    _notifications.insert(0, notification);
    _sortNotifications();
    if (_notifications.length > 50) {
      _notifications.removeRange(50, _notifications.length);
    }
    notifyListeners();
    await _persist();

    // Trigger floating heads-up banner if urgent or high priority
    if (notification.priority == NotificationPriority.urgent ||
        notification.priority == NotificationPriority.high) {
      bannerNotifier.value = notification;
    }
  }

  Future<void> addWelcomeBackNotification(
    String displayName, {
    required bool isAmharic,
  }) async {
    final name = displayName.trim().isNotEmpty ? displayName.trim() : 'User';
    final notification = InAppNotification(
      id: 'welcome_back_${DateTime.now().millisecondsSinceEpoch}',
      title: isAmharic ? 'እንኳን ደህና መጡ!' : 'Welcome back!',
      titleAm: 'እንኳን ደህና መጡ!',
      message: isAmharic
          ? 'ሰላም $name፣ እንደገና ወደ የየኛ ጤና እንኳን ደህና መጡ! የጤና ረዳትዎ እና የትምህርት ክፍሎች ዝግጁ ናቸው።'
          : 'Hello $name, welcome back to Yegna Health! Your health assistant and learning modules are ready.',
      messageAm: 'ሰላም $name፣ እንደገና ወደ የየኛ ጤና እንኳን ደህና መጡ! የጤና ረዳትዎ እና የትምህርት ክፍሎች ዝግጁ ናቸው።',
      timestamp: DateTime.now(),
      type: NotificationType.welcome,
      isRead: false,
    );
    await addNotification(notification);
  }

  Future<void> addAccountCreatedNotification(
    String displayName, {
    required bool isAmharic,
    bool verificationPending = false,
  }) async {
    final name = displayName.trim().isNotEmpty ? displayName.trim() : 'User';
    final InAppNotification notification;
    if (verificationPending) {
      notification = InAppNotification(
        id: 'account_created_${DateTime.now().millisecondsSinceEpoch}',
        title: isAmharic
            ? 'መለያ ተፈጥሯል — ማረጋገጫ በመጠባበቅ ላይ'
            : 'Account Created — Verification Pending',
        titleAm: 'መለያ ተፈጥሯል — ማረጋገጫ በመጠባበቅ ላይ',
        message: isAmharic
            ? 'መለያዎ ተፈጥሯል! ማረጋገጫውን ለማጠናቀቅ እባክዎ ኢሜይልዎን ያረጋግጡ።'
            : 'Your account was created! Please check your email to complete verification.',
        messageAm: 'መለያዎ ተፈጥሯል! ማረጋገጫውን ለማጠናቀቅ እባክዎ ኢሜይልዎን ያረጋግጡ።',
        timestamp: DateTime.now(),
        type: NotificationType.account,
        isRead: false,
      );
    } else {
      notification = InAppNotification(
        id: 'account_created_${DateTime.now().millisecondsSinceEpoch}',
        title:
            isAmharic ? 'እንኳን ወደ የየኛ ጤና በደህና መጡ!' : 'Welcome to Yegna Health!',
        titleAm: 'እንኳን ወደ የየኛ ጤና በደህና መጡ!',
        message: isAmharic
            ? 'ሰላም $name፣ የወጣቶች ጤና መለያዎ ነቅቷል። ሚስጥራዊ መመሪያዎችን፣ የSRH ትምህርቶችን እና ክሊኒኮችን ያስሱ።'
            : 'Hello $name, your youth health account is active. Explore confidential guidance, SRH modules, and youth clinics.',
        messageAm: 'ሰላም $name፣ የወጣቶች ጤና መለያዎ ነቅቷል። ሚስጥራዊ መመሪያዎችን፣ የSRH ትምህርቶችን እና ክሊኒኮችን ያስሱ።',
        timestamp: DateTime.now(),
        type: NotificationType.account,
        isRead: false,
      );
    }
    await addNotification(notification);
  }

  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index >= 0 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
      await _persist();
    }
  }

  Future<void> markAllAsRead() async {
    bool hasUnread = false;
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
        hasUnread = true;
      }
    }
    if (hasUnread) {
      notifyListeners();
      await _persist();
    }
  }

  Future<void> deleteNotification(String id) async {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
    await _persist();
  }

  Future<void> clearAll() async {
    _notifications.clear();
    notifyListeners();
    await _persist();
  }

  Future<void> syncRemoteNotifications(
      List<Map<String, dynamic>>? remoteList) async {
    if (remoteList == null || remoteList.isEmpty) return;
    bool changed = false;
    InAppNotification? newestUrgent;

    for (final raw in remoteList) {
      final parsed = InAppNotification.fromJson(raw);
      final existingIndex = _notifications.indexWhere((n) => n.id == parsed.id);

      if (existingIndex < 0) {
        _notifications.insert(0, parsed);
        changed = true;
        if (parsed.priority == NotificationPriority.urgent ||
            parsed.priority == NotificationPriority.high) {
          newestUrgent ??= parsed;
        }
      } else {
        // Preserve local isRead state while updating remote metadata
        final current = _notifications[existingIndex];
        _notifications[existingIndex] = parsed.copyWith(
          isRead: current.isRead,
        );
      }
    }

    if (changed) {
      _sortNotifications();
      if (_notifications.length > 50) {
        _notifications.removeRange(50, _notifications.length);
      }
      notifyListeners();
      await _persist();

      if (newestUrgent != null) {
        bannerNotifier.value = newestUrgent;
      }
    }
  }

  Future<void> _persist() async {
    try {
      final prefs = _preferences ?? await SharedPreferences.getInstance();
      final encoded =
          jsonEncode(_notifications.map((n) => n.toJson()).toList());
      await prefs.setString(storageKey, encoded);
    } catch (_) {
      // Safe fallback
    }
  }

  @override
  void dispose() {
    bannerNotifier.dispose();
    super.dispose();
  }
}
