import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../learning/assessment_repository.dart';
import '../auth/auth_controller.dart';
import '../learning/learning_progress_controller.dart';
import '../locale_controller.dart';
import '../theme/app_glass_theme.dart';
import 'app_settings_controller.dart';
import 'widgets/account_avatar_header.dart';
import 'widgets/account_profile_card.dart';
import 'widgets/account_settings_card.dart';

/// Full-featured Account and Settings page in Deep Glass theme.
class AccountPage extends StatelessWidget {
  const AccountPage({
    required this.localeController,
    required this.authController,
    required this.progressController,
    required this.assessmentRepository,
    required this.settingsController,
    required this.onOpenAccount,
    required this.onOpenLearningProgress,
    this.onOpenClubs,
    super.key,
  });

  final LocaleController localeController;
  final AuthController authController;
  final LearningProgressController progressController;
  final AssessmentRepository assessmentRepository;
  final AppSettingsController settingsController;
  final VoidCallback onOpenAccount;
  final VoidCallback onOpenLearningProgress;
  final VoidCallback? onOpenClubs;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (context, _) {
        final glass = context.glassTheme;
        final l10n = AppLocalizations.of(context);
        final selectedLanguage = localeController.locale.languageCode;
        final user = authController.user;

        final themeBadge = switch (settingsController.themeMode) {
          ThemeMode.system => l10n.systemTheme,
          ThemeMode.light => l10n.lightTheme,
          ThemeMode.dark => l10n.darkTheme,
        };

        final textSizeBadge = switch (settingsController.textScale) {
          AppTextScale.small => l10n.smallTextSize,
          AppTextScale.normal => l10n.defaultTextSize,
          AppTextScale.large => l10n.largeTextSize,
        };

        final rawName = user?.displayName;
        final displayName = (rawName != null && rawName.trim().isNotEmpty)
            ? rawName.trim()
            : (user != null && user.email.isNotEmpty
                ? user.email.split('@').first
                : (authController.isAuthenticated ? 'abebebe' : l10n.accountGuest));

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AccountAvatarHeader(
                displayName: displayName,
                isAuthenticated: authController.isAuthenticated,
                onSignIn: onOpenAccount,
              ),
              AccountProfileCard(
                settingsController: settingsController,
                onOpenAccount: onOpenAccount,
                onOpenClubs: onOpenClubs,
              ),
              _buildSectionHeader(glass, l10n.accountSettingsHeader),
              AccountSettingsCard(
                authController: authController,
                localeController: localeController,
                settingsController: settingsController,
                selectedLanguage: selectedLanguage,
                themeBadge: themeBadge,
                textSizeBadge: textSizeBadge,
              ),
              _buildVersionFooter(glass, l10n.appVersion),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(AppGlassTheme glass, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 24, 6, 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w800,
          color: glass.isDark ? const Color(0xFF38BDF8) : const Color(0xFF005A71),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildVersionFooter(AppGlassTheme glass, String appVersion) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          appVersion,
          style: TextStyle(
            color: glass.subtitleText,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
