import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../locale_controller.dart';
import '../../notifications/notification_controller.dart';
import '../../theme/app_glass_theme.dart';
import 'app_language_dropdown.dart';
import 'app_notification_button.dart';

/// Top App Bar with notification center trigger, title, and language dropdown / account menu.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    required this.notificationController,
    required this.localeController,
    this.selectedIndex = 0,
    this.isAuthenticated = false,
    this.onOpenNotificationSettings,
    this.onNotificationNavigate,
    this.onOpenLearningProgress,
    this.onSignOut,
    super.key,
  });

  final InAppNotificationController notificationController;
  final LocaleController localeController;
  final int selectedIndex;
  final bool isAuthenticated;
  final VoidCallback? onOpenNotificationSettings;
  final ValueChanged<String>? onNotificationNavigate;
  final VoidCallback? onOpenLearningProgress;
  final VoidCallback? onSignOut;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final l10n = AppLocalizations.of(context);
    final isAccountTab = selectedIndex == 4;

    return AppBar(
      titleSpacing: 20,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 62,
      leading: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: AppNotificationButton(
            controller: notificationController,
            onOpenSettings: onOpenNotificationSettings,
            onNavigate: onNotificationNavigate,
          ),
        ),
      ),
      centerTitle: true,
      title: isAccountTab
          ? Text(
              l10n.profile,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: glass.appBarTitle,
                letterSpacing: -0.3,
              ),
            )
          : null,
      actions: isAccountTab
          ? [
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: glass.accentColor),
                onSelected: (value) {
                  if (value == 'learning') {
                    onOpenLearningProgress?.call();
                  } else if (value == 'sign_out') {
                    onSignOut?.call();
                  }
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'learning',
                    child: Row(
                      children: [
                        Icon(Icons.school_outlined,
                            size: 20, color: glass.accentColor),
                        const SizedBox(width: 10),
                        Text(l10n.progressHeading),
                      ],
                    ),
                  ),
                  if (isAuthenticated)
                    PopupMenuItem(
                      value: 'sign_out',
                      child: Row(
                        children: [
                          const Icon(Icons.logout_rounded,
                              size: 20, color: Color(0xFFD32F2F)),
                          const SizedBox(width: 10),
                          Text(
                            l10n.signOut,
                            style: const TextStyle(color: Color(0xFFD32F2F)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
            ]
          : [
              AppLanguageDropdown(localeController: localeController),
              const SizedBox(width: 14),
            ],
    );
  }
}
