import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import 'auth_glass_container.dart';
import 'auth_notice.dart';

class AuthUnconfiguredView extends StatelessWidget {
  const AuthUnconfiguredView({
    required this.onContinueAsGuest,
    super.key,
  });

  final VoidCallback onContinueAsGuest;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AuthGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthNotice(
            icon: Icons.info_outline,
            text: l10n.authConfigMissing,
          ),
          const SizedBox(height: 14),
          Text(
            l10n.guestAccessDescription,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF26435F),
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.7),
              side: const BorderSide(
                color: Color(0xFFBAE6FD),
                width: 1.2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
            onPressed: onContinueAsGuest,
            child: Text(
              l10n.continueAsGuest,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0369A1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
