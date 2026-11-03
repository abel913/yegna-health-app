import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_models.dart';

/// Manages in-app notifications, unread counters, and offline persistence.
class InAppNotificationController extends ChangeNotifier {
  InAppNotificationController([this._preferences]);

  final SharedPreferences? _preferences;
  static const String storageKey = 'yegna_in_app_notifications_v1';

  final List<InAppNotification> _notifications = [];
  bool _initialized = false;

  List<InAppNotification> get notifications =>
      List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  bool get isInitialized => _initialized;

  Future<void> load(
      {bool isAmharic = false, bool healthTipsEnabled = true}) async {
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
      _seedDefaultNotifications(
        isAmharic: isAmharic,
        healthTipsEnabled: healthTipsEnabled,
      );
    }

    _initialized = true;
    notifyListeners();
  }

  void _seedDefaultNotifications({
    required bool isAmharic,
    bool healthTipsEnabled = true,
  }) {
    final now = DateTime.now();

    // 1. Learning module update notification
    _notifications.add(
      InAppNotification(
        id: 'seed_learning_modules',
        title:
            isAmharic ? '2 የትምህርት ክፍሎች ተዘምነዋል' : '2 Learning Modules Updated',
        message: isAmharic
            ? 'ስለ የጉርምስና ወቅት ለውጦች እና ኤችአይቪ/የአባላዘር በሽታዎች መከላከል የተዘጋጁ አዳዲስ መመሪያዎችን ይመልከቱ።'
            : 'Check out the newly updated youth guides on Puberty Changes and HIV/STI Prevention.',
        timestamp: now.subtract(const Duration(hours: 1)),
        type: NotificationType.learning,
        isRead: false,
        routePayload: 'learn',
      ),
    );

    // 2. Health tip notification
    if (healthTipsEnabled) {
      _notifications.add(
        InAppNotification(
          id: 'seed_daily_tip',
          title: isAmharic ? 'የዕለቱ የወጣቶች ጤና ምክር' : 'Daily Youth Health Tip',
          message: isAmharic
              ? 'በቂ ውሀ መጠጣትና 8 ሰዓት መተኛት የተፈጥሮ በሽታ የመከላከል አቅምን እና የአእምሮ ንቃትን ያጎለብታል።'
              : 'Staying hydrated and getting 8 hours of sleep strengthens your immune system and mental focus.',
          timestamp: now.subtract(const Duration(hours: 4)),
          type: NotificationType.healthTip,
          isRead: false,
        ),
      );
    }
  }

  Future<void> addNotification(InAppNotification notification) async {
    _notifications.insert(0, notification);
    if (_notifications.length > 50) {
      _notifications.removeRange(50, _notifications.length);
    }
    notifyListeners();
    await _persist();
  }

  Future<void> addWelcomeBackNotification(
    String displayName, {
    required bool isAmharic,
  }) async {
    final name = displayName.trim().isNotEmpty ? displayName.trim() : 'User';
    final notification = InAppNotification(
      id: 'welcome_back_${DateTime.now().millisecondsSinceEpoch}',
      title: isAmharic ? 'እንኳን ደህና መጡ!' : 'Welcome back!',
      message: isAmharic
          ? 'ሰላም $name፣ እንደገና ወደ የየኛ ጤና እንኳን ደህና መጡ! የጤና ረዳትዎ እና የትምህርት ክፍሎች ዝግጁ ናቸው።'
          : 'Hello $name, welcome back to Yegna Health! Your health assistant and learning modules are ready.',
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
        message: isAmharic
            ? 'መለያዎ ተፈጥሯል! ማረጋገጫውን ለማጠናቀቅ እባክዎ ኢሜይልዎን ያረጋግጡ።'
            : 'Your account was created! Please check your email to complete verification.',
        timestamp: DateTime.now(),
        type: NotificationType.account,
        isRead: false,
      );
    } else {
      notification = InAppNotification(
        id: 'account_created_${DateTime.now().millisecondsSinceEpoch}',
        title:
            isAmharic ? 'እንኳን ወደ የየኛ ጤና በደህና መጡ!' : 'Welcome to Yegna Health!',
        message: isAmharic
            ? 'ሰላም $name፣ የወጣቶች ጤና መለያዎ ነቅቷል። ሚስጥራዊ መመሪያዎችን፣ የSRH ትምህርቶችን እና ክሊኒኮችን ያስሱ።'
            : 'Hello $name, your youth health account is active. Explore confidential guidance, SRH modules, and youth clinics.',
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
}
