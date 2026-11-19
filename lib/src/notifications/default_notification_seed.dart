import 'notification_models.dart';

/// Provides initial seed notifications for new student installations.
class DefaultNotificationSeed {
  static List<InAppNotification> generate({
    required bool isAmharic,
    bool healthTipsEnabled = true,
  }) {
    final now = DateTime.now();
    final list = <InAppNotification>[
      InAppNotification(
        id: 'seed_learning_modules',
        title: isAmharic ? '2 የትምህርት ክፍሎች ተዘምነዋል' : '2 Learning Modules Updated',
        message: isAmharic
            ? 'ስለ የጉርምስና ወቅት ለውጦች እና ኤችአይቪ/የአባላዘር በሽታዎች መከላከል የተዘጋጁ አዳዲስ መመሪያዎችን ይመልከቱ።'
            : 'Check out the newly updated youth guides on Puberty Changes and HIV/STI Prevention.',
        timestamp: now.subtract(const Duration(hours: 1)),
        type: NotificationType.learning,
        isRead: false,
        routePayload: 'learn',
      ),
    ];

    if (healthTipsEnabled) {
      list.add(
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

    return list;
  }
}
