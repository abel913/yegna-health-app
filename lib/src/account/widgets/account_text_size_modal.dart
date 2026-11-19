import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_glass_theme.dart';
import '../app_settings_controller.dart';

/// Shows text scaling selection modal sheet.
void showAccountTextSizeModal(
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
                  l10n.textSizeDialogTitle,
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
                    side: settings.textScale == AppTextScale.small
                        ? BorderSide(
                            color: glass.isDark
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFFBAE6FD),
                            width: 1.2,
                          )
                        : BorderSide.none,
                  ),
                  tileColor: settings.textScale == AppTextScale.small
                      ? glass.modalSelectedTile
                      : null,
                  title: Text(
                    l10n.smallTextSize,
                    style: TextStyle(
                      fontWeight: settings.textScale == AppTextScale.small
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: glass.titleText,
                    ),
                  ),
                  trailing: settings.textScale == AppTextScale.small
                      ? Icon(Icons.check, color: glass.accentColor)
                      : null,
                  onTap: () {
                    settings.setTextScale(AppTextScale.small);
                    Navigator.of(ctx).pop();
                  },
                ),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: settings.textScale == AppTextScale.normal
                        ? BorderSide(
                            color: glass.isDark
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFFBAE6FD),
                            width: 1.2,
                          )
                        : BorderSide.none,
                  ),
                  tileColor: settings.textScale == AppTextScale.normal
                      ? glass.modalSelectedTile
                      : null,
                  title: Text(
                    l10n.defaultTextSize,
                    style: TextStyle(
                      fontWeight: settings.textScale == AppTextScale.normal
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: glass.titleText,
                    ),
                  ),
                  trailing: settings.textScale == AppTextScale.normal
                      ? Icon(Icons.check, color: glass.accentColor)
                      : null,
                  onTap: () {
                    settings.setTextScale(AppTextScale.normal);
                    Navigator.of(ctx).pop();
                  },
                ),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: settings.textScale == AppTextScale.large
                        ? BorderSide(
                            color: glass.isDark
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFFBAE6FD),
                            width: 1.2,
                          )
                        : BorderSide.none,
                  ),
                  tileColor: settings.textScale == AppTextScale.large
                      ? glass.modalSelectedTile
                      : null,
                  title: Text(
                    l10n.largeTextSize,
                    style: TextStyle(
                      fontWeight: settings.textScale == AppTextScale.large
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: glass.titleText,
                    ),
                  ),
                  trailing: settings.textScale == AppTextScale.large
                      ? Icon(Icons.check, color: glass.accentColor)
                      : null,
                  onTap: () {
                    settings.setTextScale(AppTextScale.large);
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
