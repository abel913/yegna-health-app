import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../auth_models.dart';

String authIssueMessage(AppLocalizations l10n, AuthIssue issue) =>
    switch (issue) {
      AuthIssue.configurationMissing => l10n.authConfigMissing,
      AuthIssue.emailRequired => l10n.errorEmailRequired,
      AuthIssue.invalidEmail => l10n.errorInvalidEmail,
      AuthIssue.passwordRequired => l10n.errorPasswordRequired,
      AuthIssue.passwordTooShort => l10n.errorPasswordTooShort,
      AuthIssue.passwordMismatch => l10n.errorPasswordMismatch,
      AuthIssue.displayNameRequired => l10n.errorDisplayNameRequired,
      AuthIssue.displayNameTooLong => l10n.errorDisplayNameTooLong,
      AuthIssue.invalidCredentials => l10n.errorInvalidCredentials,
      AuthIssue.emailNotConfirmed => l10n.errorEmailNotConfirmed,
      AuthIssue.registrationFailed => l10n.errorRegistration,
      AuthIssue.networkUnavailable => l10n.errorNetwork,
      AuthIssue.recoveryExpired => l10n.errorRecoveryExpired,
      AuthIssue.sessionUnavailable => l10n.errorSessionUnavailable,
      AuthIssue.unexpected => l10n.errorUnexpected,
      AuthIssue.accountSuspended => l10n.errorAccountSuspended,
      AuthIssue.emailAlreadyInUse => l10n.errorEmailAlreadyInUse,
      AuthIssue.invalidVerificationCode => l10n.invalidCodeError,
      AuthIssue.verificationFailed => l10n.invalidCodeError,
    };

class AuthNotice extends StatelessWidget {
  const AuthNotice({
    required this.icon,
    required this.text,
    this.isError = false,
    super.key,
  });

  final IconData icon;
  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isError
            ? const Color(0xFFFEF2F2).withValues(alpha: 0.90)
            : const Color(0xFFF0FDF4).withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isError ? const Color(0xFFFECACA) : const Color(0xFFBBF7D0),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: isError ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color:
                    isError ? const Color(0xFF991B1B) : const Color(0xFF166534),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
