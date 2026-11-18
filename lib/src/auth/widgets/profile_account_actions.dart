import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

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
    return Column(
      children: [
        const SizedBox(height: 12),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.65),
            side: const BorderSide(color: Color(0xFFFECACA), width: 1.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(vertical: 13),
          ),
          onPressed: isBusy ? null : onSignOut,
          icon: const Icon(Icons.logout, color: Color(0xFFDC2626), size: 18),
          label: Text(
            l10n.signOut,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFFDC2626),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            foregroundColor: const Color(0xFF94A3B8),
          ),
          onPressed: isBusy ? null : onDeleteAccount,
          icon: const Icon(Icons.delete_forever_rounded, color: Color(0xFFEF4444), size: 18),
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
