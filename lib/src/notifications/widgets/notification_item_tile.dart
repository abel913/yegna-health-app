import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../notification_models.dart';
import '../notification_type_visuals.dart';

/// Interactive dismissible glass card displaying an individual notification.
class NotificationItemTile extends StatelessWidget {
  const NotificationItemTile({
    required this.notification,
    required this.isDark,
    required this.onTap,
    required this.onDismiss,
    this.isAmharic = false,
    super.key,
  });

  final InAppNotification notification;
  final bool isDark;
  final bool isAmharic;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  String _formatTimestamp(BuildContext context, DateTime timestamp) {
    final l10n = AppLocalizations.of(context);
    final difference = DateTime.now().difference(timestamp);

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
    final l10n = AppLocalizations.of(context);
    final isUrgent = notification.priority == NotificationPriority.urgent ||
        notification.type == NotificationType.alert;
    final title = notification.localizedTitle(isAmharic);
    final message = notification.localizedMessage(isAmharic);
    final actionLabel = notification.localizedActionLabel(isAmharic);

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFDC2626),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
      ),
      onDismissed: (_) => onDismiss(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: notification.isRead
                  ? (isDark
                      ? const Color(0xFF131D36).withValues(alpha: 0.6)
                      : Colors.white.withValues(alpha: 0.85))
                  : (isUrgent
                      ? (isDark
                          ? const Color(0xFF450A0A).withValues(alpha: 0.35)
                          : const Color(0xFFFFF1F2))
                      : (isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF0FDF4))),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isUrgent
                    ? const Color(0xFFEF4444).withValues(alpha: 0.6)
                    : (notification.isRead
                        ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0))
                        : const Color(0xFF10B981).withValues(alpha: 0.4)),
                width: isUrgent ? 1.6 : (notification.isRead ? 1 : 1.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: isUrgent
                      ? const Color(0xFFEF4444).withValues(alpha: 0.15)
                      : Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: isUrgent ? 12 : 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTypeBadge(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                if (notification.isPinned) ...[
                                  const Icon(Icons.push_pin_rounded, size: 14, color: Color(0xFFF59E0B)),
                                  const SizedBox(width: 4),
                                ],
                                if (isUrgent) ...[
                                  const Icon(Icons.local_fire_department_rounded, size: 14, color: Color(0xFFEF4444)),
                                  const SizedBox(width: 4),
                                ],
                                Expanded(
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w800,
                                      color: isDark ? Colors.white : const Color(0xFF08264A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(left: 6),
                              decoration: BoxDecoration(
                                color: isUrgent ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatTimestamp(context, notification.timestamp),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                            ),
                          ),
                          if (notification.routePayload != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.25 : 0.12),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    actionLabel ?? l10n.notificationActionExplore,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF6366F1),
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  const Icon(Icons.arrow_forward_rounded, size: 12, color: Color(0xFF6366F1)),
                                ],
                              ),
                            ),
                        ],
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

  Widget _buildTypeBadge() {
    final typeIcon = notification.type.icon;
    final iconGradient = notification.type.gradient;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: iconGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: iconGradient.colors.first.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(typeIcon, color: Colors.white, size: 20),
    );
  }
}
