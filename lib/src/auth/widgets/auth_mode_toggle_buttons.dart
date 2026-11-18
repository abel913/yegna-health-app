import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../auth_page_mode.dart';

class AuthModeToggleButtons extends StatelessWidget {
  const AuthModeToggleButtons({
    required this.mode,
    required this.onChangeMode,
    super.key,
  });

  final AuthPageMode mode;
  final ValueChanged<AuthPageMode> onChangeMode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isRegister = mode == AuthPageMode.register;
    final isRecovery = mode == AuthPageMode.recover;
    final isNewPassword = mode == AuthPageMode.newPassword;

    if (mode == AuthPageMode.signIn || isRegister) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0284C7).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFBAE6FD).withValues(alpha: 0.7),
              width: 1,
            ),
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () => onChangeMode(
              isRegister ? AuthPageMode.signIn : AuthPageMode.register,
            ),
            child: Text(
              isRegister ? l10n.hasAccount : l10n.noAccount,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0369A1),
              ),
            ),
          ),
        ),
      );
    }

    if (isRecovery || isNewPassword) {
      return Center(
        child: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () => onChangeMode(AuthPageMode.signIn),
          child: Text(
            l10n.signIn,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0369A1),
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
