import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../auth/auth_controller.dart';
import '../../locale_controller.dart';
import '../../theme/app_glass_theme.dart';
import '../app_settings_controller.dart';
import 'account_language_modal.dart';
import 'account_privacy_modal.dart';
import 'account_support_modal.dart';
import 'account_text_size_modal.dart';
import 'account_theme_modal.dart';
import 'account_tile.dart';

/// Account Settings Card with Privacy, Language, Theme, Text Size, and Support.
class AccountSettingsCard extends StatelessWidget {
  const AccountSettingsCard({
    required this.authController,
    required this.localeController,
    required this.settingsController,
    required this.selectedLanguage,
    required this.themeBadge,
    required this.textSizeBadge,
    super.key,
  });

  final AuthController authController;
  final LocaleController localeController;
  final AppSettingsController settingsController;
  final String selectedLanguage;
  final String themeBadge;
  final String textSizeBadge;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final l10n = AppLocalizations.of(context);
    final langBadge = selectedLanguage == 'am' ? l10n.amharicLanguage : l10n.englishLanguage;

    return Container(
      decoration: BoxDecoration(
        color: glass.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: glass.cardBorder, width: 1.2),
        boxShadow: glass.cardShadow,
      ),
      child: Column(
        children: [
          AccountTile(
            icon: Icons.shield_outlined,
            title: l10n.privacyAndSecurity,
            subtitle: l10n.privacySubtitle,
            onTap: () => showAccountPrivacyModal(context, l10n, authController),
          ),
          Divider(height: 1, indent: 72, endIndent: 16, color: glass.divider),
          AccountTile(
            icon: Icons.language_rounded,
            title: l10n.appLanguage,
            subtitle: l10n.appLanguageSubtitle,
            badgeText: langBadge,
            onTap: () => showAccountLanguageModal(context, l10n, localeController),
          ),
          Divider(height: 1, indent: 72, endIndent: 16, color: glass.divider),
          AccountTile(
            icon: Icons.palette_outlined,
            title: l10n.appTheme,
            subtitle: l10n.appThemeSubtitle,
            badgeText: themeBadge,
            onTap: () => showAccountThemeModal(context, l10n, settingsController),
          ),
          Divider(height: 1, indent: 72, endIndent: 16, color: glass.divider),
          AccountTile(
            icon: Icons.text_fields_rounded,
            title: l10n.textSize,
            subtitle: l10n.textSizeSubtitle,
            badgeText: textSizeBadge,
            onTap: () => showAccountTextSizeModal(context, l10n, settingsController),
          ),
          Divider(height: 1, indent: 72, endIndent: 16, color: glass.divider),
          AccountTile(
            icon: Icons.help_outline_rounded,
            title: l10n.supportCenter,
            subtitle: l10n.supportCenterSubtitle,
            onTap: () => showAccountSupportModal(context, l10n),
          ),
        ],
      ),
    );
  }
}
