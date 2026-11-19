import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../locale_controller.dart';
import '../../theme/app_glass_theme.dart';

/// Shows language selection modal sheet.
void showAccountLanguageModal(
  BuildContext context,
  AppLocalizations l10n,
  LocaleController localeCtrl,
) {
  final current = localeCtrl.locale.languageCode;
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
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
                l10n.appLanguage,
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
                  side: current == 'en'
                      ? BorderSide(
                          color: glass.isDark
                              ? const Color(0xFF38BDF8)
                              : const Color(0xFFBAE6FD),
                          width: 1.2,
                        )
                      : BorderSide.none,
                ),
                tileColor: current == 'en' ? glass.modalSelectedTile : null,
                leading: Icon(
                  Icons.check_circle_rounded,
                  color: current == 'en'
                      ? glass.accentColor
                      : glass.subtitleText,
                ),
                title: Text(
                  'English (US)',
                  style: TextStyle(
                    fontWeight:
                        current == 'en' ? FontWeight.w700 : FontWeight.w500,
                    color: glass.titleText,
                  ),
                ),
                onTap: () {
                  localeCtrl.setLanguage('en');
                  Navigator.of(ctx).pop();
                },
              ),
              const SizedBox(height: 6),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: current == 'am'
                      ? BorderSide(
                          color: glass.isDark
                              ? const Color(0xFF38BDF8)
                              : const Color(0xFFBAE6FD),
                          width: 1.2,
                        )
                      : BorderSide.none,
                ),
                tileColor: current == 'am' ? glass.modalSelectedTile : null,
                leading: Icon(
                  Icons.check_circle_rounded,
                  color: current == 'am'
                      ? glass.accentColor
                      : glass.subtitleText,
                ),
                title: Text(
                  'አማርኛ (Amharic)',
                  style: TextStyle(
                    fontWeight:
                        current == 'am' ? FontWeight.w700 : FontWeight.w500,
                    color: glass.titleText,
                  ),
                ),
                onTap: () {
                  localeCtrl.setLanguage('am');
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
