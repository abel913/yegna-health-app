import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_glass_theme.dart';
import 'notification_controller.dart';
import 'widgets/notification_empty_state.dart';
import 'widgets/notification_item_tile.dart';
import 'widgets/notification_sheet_header.dart';

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = context.isDark;
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
                NotificationSheetHeader(
                  unreadCount: unreadCount,
                  hasNotifications: notifications.isNotEmpty,
                  isDark: isDark,
                  onMarkAllRead: () => controller.markAllAsRead(),
                  onClearAll: () => controller.clearAll(),
                ),
                Flexible(
                  child: notifications.isEmpty
                      ? NotificationEmptyState(isDark: isDark)
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          itemCount: notifications.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = notifications[index];
                            return NotificationItemTile(
                              notification: item,
                              isDark: isDark,
                              onTap: () {
                                if (!item.isRead) {
                                  controller.markAsRead(item.id);
                                }
                                if (item.routePayload != null) {
                                  Navigator.of(context).pop();
                                  onNavigate?.call(item.routePayload!);
                                }
                              },
                              onDismiss: () =>
                                  controller.deleteNotification(item.id),
                            );
                          },
                        ),
                ),
                _NotificationFooter(
                  isDark: isDark,
                  subtitle: l10n.notificationsSubtitle,
                  actionLabel: l10n.notificationSettingsAction,
                  onOpenSettings: () {
                    Navigator.of(context).pop();
                    onOpenSettings?.call();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NotificationFooter extends StatelessWidget {
  const _NotificationFooter({
    required this.isDark,
    required this.subtitle,
    required this.actionLabel,
    required this.onOpenSettings,
  });

  final bool isDark;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          TextButton.icon(
            onPressed: onOpenSettings,
            icon: const Icon(Icons.tune_rounded, size: 16),
            label: Text(actionLabel),
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
    );
  }
}
