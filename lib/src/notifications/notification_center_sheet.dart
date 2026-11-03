import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_glass_theme.dart';
import 'notification_controller.dart';
import 'notification_models.dart';

/// Modal bottom sheet presenting in-app notifications, unread badges,
/// individual dismissals, mark-all-read, and deep links to settings.
class NotificationCenterSheet extends StatelessWidget {
  const NotificationCenterSheet({
    required this.controller,
    this.onOpenSettings,
    this.onNavigate,
    super.key,
  });

  final InAppNotificationController controller;
  final VoidCallback? onOpenSettings;
  final ValueChanged<String>? onNavigate;

  static void show(
    BuildContext context, {
    required InAppNotificationController controller,
    VoidCallback? onOpenSettings,
    ValueChanged<String>? onNavigate,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NotificationCenterSheet(
        controller: controller,
        onOpenSettings: onOpenSettings,
        onNavigate: onNavigate,
      ),
    );
  }

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
    final l10n = AppLocalizations.of(context);
    final isDark = context.isDark;
    final glass = context.glassTheme;
    final maxSheetHeight = MediaQuery.of(context).size.height * 0.82;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final notifications = controller.notifications;
        final unreadCount = controller.unreadCount;

        return Container(
          constraints: BoxConstraints(maxHeight: maxSheetHeight),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Drag Handle
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),

                // 2. Header Row
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF007A78), Color(0xFF0284C7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0284C7)
                                  .withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.notifications_active_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              l10n.notificationsTitle,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF08264A),
                                letterSpacing: -0.2,
                              ),
                            ),
                            if (unreadCount > 0) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$unreadCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (notifications.isNotEmpty) ...[
                        if (unreadCount > 0)
                          TextButton(
                            onPressed: () => controller.markAllAsRead(),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              visualDensity: VisualDensity.compact,
                            ),
                            child: Text(
                              l10n.markAllReadAction,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF007A78),
                              ),
                            ),
                          ),
                        IconButton(
                          icon:
                              const Icon(Icons.delete_sweep_outlined, size: 22),
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                          tooltip: l10n.clearAllNotificationsAction,
                          onPressed: () => controller.clearAll(),
                        ),
                      ],
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),

                // 3. Notification List or Empty State
                Flexible(
                  child: notifications.isEmpty
                      ? _buildEmptyState(context, l10n, isDark)
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          itemCount: notifications.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = notifications[index];
                            return _buildNotificationCard(
                              context: context,
                              notification: item,
                              isDark: isDark,
                              glass: glass,
                            );
                          },
                        ),
                ),

                // 4. Footer Settings Action
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF8FAFC),
                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.notificationsSubtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onOpenSettings?.call();
                        },
                        icon: const Icon(Icons.tune_rounded, size: 16),
                        label: Text(l10n.notificationSettingsAction),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF0284C7),
                          textStyle: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEAF5FD),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 34,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF0284C7),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noNotifications,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF08264A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.noNotificationsSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required BuildContext context,
    required InAppNotification notification,
    required bool isDark,
    required AppGlassTheme glass,
  }) {
    final typeIcon = _getTypeIcon(notification.type);
    final iconGradient = _getIconGradient(notification.type);

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
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 24),
      ),
      onDismissed: (_) => controller.deleteNotification(notification.id),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (!notification.isRead) {
              controller.markAsRead(notification.id);
            }
            if (notification.routePayload != null) {
              Navigator.of(context).pop();
              onNavigate?.call(notification.routePayload!);
            }
          },
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

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.welcome:
        return Icons.waving_hand_rounded;
      case NotificationType.account:
        return Icons.celebration_rounded;
      case NotificationType.learning:
        return Icons.school_rounded;
      case NotificationType.healthTip:
        return Icons.lightbulb_rounded;
      case NotificationType.system:
        return Icons.info_outline_rounded;
    }
  }

  LinearGradient _getIconGradient(NotificationType type) {
    switch (type) {
      case NotificationType.welcome:
        return const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case NotificationType.account:
        return const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case NotificationType.learning:
        return const LinearGradient(
          colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case NotificationType.healthTip:
        return const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case NotificationType.system:
        return const LinearGradient(
          colors: [Color(0xFF007A78), Color(0xFF005A71)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}
