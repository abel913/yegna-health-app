import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../locale_controller.dart';
import '../../notifications/notification_controller.dart';
import '../../theme/app_glass_theme.dart';
import 'app_language_dropdown.dart';
import 'app_notification_button.dart';

/// Top App Bar with notification center trigger, title, and language dropdown.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    required this.notificationController,
    required this.localeController,
    this.onOpenNotificationSettings,
    this.onNotificationNavigate,
    super.key,
  });

  final InAppNotificationController notificationController;
  final LocaleController localeController;
  final VoidCallback? onOpenNotificationSettings;
  final ValueChanged<String>? onNotificationNavigate;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = context.isDark;
    final l10n = AppLocalizations.of(context);

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
      title: Text(
        l10n.appTitle,
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w900,
          color: glass.titleText,
          letterSpacing: -0.4,
          shadows: isDark
              ? [
                  const Shadow(
                    color: Color(0x60000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
      ),
      actions: [
        AppLanguageDropdown(localeController: localeController),
        const SizedBox(width: 14),
      ],
    );
  }
}
