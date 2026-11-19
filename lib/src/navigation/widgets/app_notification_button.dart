import 'package:flutter/material.dart';

import '../../notifications/notification_center_sheet.dart';
import '../../notifications/notification_controller.dart';
import '../../theme/app_glass_theme.dart';

/// Top bar notification button with unread count badge.
class AppNotificationButton extends StatelessWidget {
  const AppNotificationButton({
    required this.controller,
    this.onOpenSettings,
    this.onNavigate,
    super.key,
  });

  final InAppNotificationController controller;
  final VoidCallback? onOpenSettings;
  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final unreadCount = controller.unreadCount;
        return Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF131D36).withValues(alpha: 0.85)
                      : Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF38BDF8).withValues(alpha: 0.3)
                        : const Color(0xFFBAE6FD).withValues(alpha: 0.9),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? const Color(0x30000000)
                          : const Color(0x100284C7),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.notifications_none_rounded,
                    size: 20,
                    color: isDark
                        ? const Color(0xFF38BDF8)
                        : const Color(0xFF005A71),
                  ),
                  padding: EdgeInsets.zero,
                  tooltip: 'Notifications',
                  onPressed: () {
                    NotificationCenterSheet.show(
                      context,
                      controller: controller,
                      onOpenSettings: onOpenSettings,
                      onNavigate: onNavigate,
                    );
                  },
                ),
              ),
              if (unreadCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      unreadCount > 9 ? '9+' : '$unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
