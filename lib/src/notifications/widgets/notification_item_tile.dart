import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../notification_models.dart';
import '../notification_type_visuals.dart';

/// Interactive dismissible card displaying an individual in-app notification.
class NotificationItemTile extends StatelessWidget {
  const NotificationItemTile({
    required this.notification,
    required this.isDark,
    required this.onTap,
    required this.onDismiss,
    super.key,
  });

  final InAppNotification notification;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  String _formatTimestamp(BuildContext context, DateTime timestamp) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return l10n.notificationTimeJustNow;
    } else if (difference.inMinutes < 60) {
      return l10n.notificationTimeMinutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return l10n.notificationTimeHoursAgo(difference.inHours);
    } else {
      final days = difference.inDays > 0 ? difference.inDays : 1;
      return l10n.notificationTimeDaysAgo(days);
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeIcon = notification.type.icon;
    final iconGradient = notification.type.gradient;

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFDC2626),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
      onDismissed: (_) => onDismiss(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: notification.isRead
                  ? (isDark
                      ? const Color(0xFF131D36).withValues(alpha: 0.6)
                      : Colors.white.withValues(alpha: 0.85))
                  : (isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF0FDF4)),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: notification.isRead
                    ? (isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0))
                    : const Color(0xFF10B981).withValues(alpha: 0.4),
                width: notification.isRead ? 1 : 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type Icon Badge
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: iconGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: iconGradient.colors.first.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(typeIcon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: notification.isRead
                                    ? FontWeight.w600
                                    : FontWeight.w800,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF08264A),
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(left: 6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatTimestamp(context, notification.timestamp),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFF64748B)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
