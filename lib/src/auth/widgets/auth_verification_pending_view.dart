import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class AuthVerificationPendingView extends StatelessWidget {
  const AuthVerificationPendingView({
    required this.targetEmail,
    required this.verificationCodeController,
    required this.isVerifyingCode,
    required this.isResendingCode,
    required this.resendCooldownSeconds,
    required this.onVerify,
    required this.onResend,
    required this.onChangeEmail,
    super.key,
  });

  final String targetEmail;
  final TextEditingController verificationCodeController;
  final bool isVerifyingCode;
  final bool isResendingCode;
  final int resendCooldownSeconds;
  final VoidCallback onVerify;
  final VoidCallback onResend;
  final VoidCallback onChangeEmail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final emailDisplay = targetEmail.isNotEmpty ? targetEmail : 'your email';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE0F2FE),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.shield_outlined,
              size: 44,
              color: Color(0xFF0284C7),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          l10n.verificationPendingTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF08264A),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.enterVerificationCodePrompt(emailDisplay),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13.5,
            height: 1.5,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 1.4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
            controller: verificationCodeController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: 10,
              color: Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: '000000',
              hintStyle: TextStyle(
                color: const Color(0xFF94A3B8).withValues(alpha: 0.5),
                letterSpacing: 10,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF0284C7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            elevation: 2,
          ),
          onPressed: isVerifyingCode ? null : onVerify,
          child: isVerifyingCode
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      l10n.verifyCodeButton,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton.icon(
            onPressed: resendCooldownSeconds > 0 || isResendingCode
                ? null
                : onResend,
            icon: isResendingCode
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded, size: 16),
            label: Text(
              resendCooldownSeconds > 0
                  ? l10n.resendCooldown(resendCooldownSeconds)
                  : l10n.resendCodeButton,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: onChangeEmail,
            child: Text(
              l10n.changeEmailAction,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
