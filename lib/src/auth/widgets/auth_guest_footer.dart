import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class AuthGuestFooter extends StatelessWidget {
  const AuthGuestFooter({
    required this.onContinueAsGuest,
    super.key,
  });

  final VoidCallback onContinueAsGuest;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        const SizedBox(height: 16),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.65),
            side: const BorderSide(color: Color(0xFFBAE6FD), width: 1.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: onContinueAsGuest,
          child: Text(
            l10n.continueAsGuest,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0369A1)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.guestAccessDescription,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Color(0xFF4A6277)),
        ),
      ],
    );
  }
}
