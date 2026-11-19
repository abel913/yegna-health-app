import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_glass_theme.dart';

class ProfileAccountActions extends StatelessWidget {
  const ProfileAccountActions({
    required this.isBusy,
    required this.onSignOut,
    required this.onDeleteAccount,
    super.key,
  });

  final bool isBusy;
  final VoidCallback onSignOut;
  final VoidCallback onDeleteAccount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final glass = context.glassTheme;

    return Column(
      children: [
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              backgroundColor: glass.isDark
                  ? const Color(0xFF7F1D1D).withValues(alpha: 0.16)
                  : Colors.white.withValues(alpha: 0.65),
              side: BorderSide(
                color: glass.isDark
                    ? const Color(0xFF991B1B).withValues(alpha: 0.6)
                    : const Color(0xFFFECACA),
                width: 1.2,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
            onPressed: isBusy ? null : onSignOut,
            icon: const Icon(Icons.logout_rounded,
                color: Color(0xFFDC2626), size: 18),
            label: Text(
              l10n.signOut,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFFDC2626),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            foregroundColor: const Color(0xFF94A3B8),
          ),
          onPressed: isBusy ? null : onDeleteAccount,
          icon: const Icon(Icons.delete_forever_rounded,
              color: Color(0xFFEF4444), size: 18),
          label: Text(
            l10n.deleteAccountAction,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFFEF4444),
            ),
          ),
        ),
      ],
    );
  }
}
