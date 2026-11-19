import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_glass_theme.dart';
import '../app_settings_controller.dart';

/// Shows theme selection modal sheet (Light & Dark options).
void showAccountThemeModal(
  BuildContext context,
  AppLocalizations l10n,
  AppSettingsController settings,
) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => ListenableBuilder(
      listenable: settings,
      builder: (ctx, _) {
        final glass = ctx.glassTheme;
        final isLight = settings.themeMode == ThemeMode.light;
        final isDark = settings.themeMode == ThemeMode.dark;

        return Material(
          color: glass.modalBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              border: glass.isDark
                  ? Border.all(color: glass.cardBorder, width: 1.2)
                  : null,
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: glass.modalHandle,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.themeDialogTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: glass.titleText,
                  ),
                ),
                const SizedBox(height: 14),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: isLight
                        ? BorderSide(
                            color: glass.isDark
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFFBAE6FD),
                            width: 1.2,
                          )
                        : BorderSide.none,
                  ),
                  tileColor: isLight ? glass.modalSelectedTile : null,
                  leading: Icon(
                    Icons.wb_sunny_rounded,
                    color: isLight ? glass.accentColor : glass.subtitleText,
                  ),
                  title: Text(
                    l10n.lightTheme,
                    style: TextStyle(
                      fontWeight: isLight ? FontWeight.w700 : FontWeight.w500,
                      color: glass.titleText,
                    ),
                  ),
                  trailing: isLight
                      ? Icon(Icons.check, color: glass.accentColor)
                      : null,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    settings.setThemeMode(ThemeMode.light);
                    Navigator.of(ctx).pop();
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: isDark
                        ? const BorderSide(
                            color: Color(0xFF38BDF8),
                            width: 1.2,
                          )
                        : BorderSide.none,
                  ),
                  tileColor: isDark ? glass.modalSelectedTile : null,
                  leading: Icon(
                    Icons.nightlight_round,
                    color: isDark ? glass.accentColor : glass.subtitleText,
                  ),
                  title: Text(
                    l10n.darkTheme,
                    style: TextStyle(
                      fontWeight: isDark ? FontWeight.w700 : FontWeight.w500,
                      color: glass.titleText,
                    ),
                  ),
                  trailing: isDark
                      ? Icon(Icons.check, color: glass.accentColor)
                      : null,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    settings.setThemeMode(ThemeMode.dark);
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
