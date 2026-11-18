import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class AuthRecoverySentView extends StatelessWidget {
  const AuthRecoverySentView({
    required this.onSignIn,
    super.key,
  });

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE0F2FE),
          ),
          child: const Icon(
            Icons.mark_email_read_outlined,
            size: 48,
            color: Color(0xFF0284C7),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.recoveryEmailSent,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Color(0xFF26435F),
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF0284C7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 13),
          ),
          onPressed: onSignIn,
          child: Text(
            l10n.signIn,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class AuthPasswordUpdatedView extends StatelessWidget {
  const AuthPasswordUpdatedView({
    required this.onDismiss,
    super.key,
  });

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFDCFCE7),
          ),
          child: const Icon(
            Icons.check_circle_outline,
            size: 48,
            color: Color(0xFF16A34A),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.passwordUpdatedTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF08264A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.passwordUpdatedBody,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13.5,
            height: 1.5,
            color: Color(0xFF26435F),
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF0284C7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 13),
          ),
          onPressed: onDismiss,
          child: Text(
            l10n.signIn,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
