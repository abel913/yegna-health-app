import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_glass_theme.dart';
import '../app_settings_controller.dart';
import 'account_notifications_modal.dart';
import 'account_tile.dart';

/// Account Profile Card containing Profile link, Notifications, and Clubs.
class AccountProfileCard extends StatelessWidget {
  const AccountProfileCard({
    required this.settingsController,
    required this.onOpenAccount,
    this.onOpenClubs,
    super.key,
  });

  final AppSettingsController settingsController;
  final VoidCallback onOpenAccount;
  final VoidCallback? onOpenClubs;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final l10n = AppLocalizations.of(context);

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
            icon: Icons.person_outline_rounded,
            title: l10n.viewProfile,
            subtitle: l10n.viewProfileSubtitle,
            onTap: onOpenAccount,
          ),
          Divider(height: 1, indent: 72, endIndent: 16, color: glass.divider),
          AccountTile(
            icon: Icons.notifications_none_rounded,
            title: l10n.notifications,
            subtitle: l10n.notificationsSubtitle,
            onTap: () => showAccountNotificationsModal(context, l10n, settingsController),
          ),
          Divider(height: 1, indent: 72, endIndent: 16, color: glass.divider),
          AccountTile(
            icon: Icons.groups_rounded,
            title: l10n.studentClubsTitle,
            subtitle: l10n.studentClubsSubtitle,
            onTap: onOpenClubs ?? () {},
          ),
        ],
      ),
    );
  }
}
