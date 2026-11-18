import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../auth_page_mode.dart';

class AuthFormHeader extends StatelessWidget {
  const AuthFormHeader({required this.mode, super.key});
  final AuthPageMode mode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isRegister = mode == AuthPageMode.register;
    final isRecovery = mode == AuthPageMode.recover;
    final isNewPassword = mode == AuthPageMode.newPassword;
    final title = isRegister
        ? l10n.createAccount
        : isRecovery
            ? l10n.passwordRecoveryTitle
            : isNewPassword
                ? l10n.passwordRecoveryTitle
                : l10n.signIn;

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color(0x350284C7),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.shield_rounded, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF08264A),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isRegister
                    ? l10n.guestAccessDescription
                    : isRecovery
                        ? l10n.recoveryInstructions
                        : l10n.profileDescription,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
