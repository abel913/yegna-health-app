import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class AuthSnackBars {
  static void _show(
    BuildContext context, {
    required Widget content,
    Color bg = const Color(0xFF0F172A),
    Color borderColor = const Color(0xFF0284C7),
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: bg,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor, width: 1.2),
        ),
        content: content,
        duration: duration,
      ),
    );
  }

  static void showAccountSuspended(BuildContext context, AppLocalizations l10n) {
    _show(
      context,
      bg: const Color(0xFFDC2626),
      borderColor: const Color(0xFFFCA5A5),
      duration: const Duration(seconds: 5),
      content: Row(
        children: [
          const Icon(Icons.shield_outlined, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.errorAccountSuspended,
              style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  static void showEmailNotConfirmed(BuildContext context, AppLocalizations l10n) {
    _show(
      context,
      content: Row(
        children: [
          const Icon(Icons.mark_email_unread_rounded, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.emailNotConfirmedBanner,
              style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  static void showWelcomeBack(BuildContext context, AppLocalizations l10n, String name) {
    _show(
      context,
      borderColor: const Color(0xFF007A78),
      content: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(color: Color(0xFF007A78), shape: BoxShape.circle),
            child: const Icon(Icons.waving_hand_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.welcomeBackMessage(name),
              style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  static void showRegistrationPending(BuildContext context, AppLocalizations l10n) {
    _show(
      context,
      content: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(color: Color(0xFF0284C7), shape: BoxShape.circle),
            child: const Icon(Icons.mark_email_unread_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.verificationPendingNotification,
              style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  static void showRegistrationSuccess(BuildContext context, AppLocalizations l10n, String name) {
    _show(
      context,
      borderColor: const Color(0xFF10B981),
      content: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
            child: const Icon(Icons.celebration_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.accountCreatedMessage(name),
              style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  static void showVerifiedSuccess(BuildContext context, AppLocalizations l10n, String name) {
    _show(
      context,
      borderColor: const Color(0xFF10B981),
      content: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
            child: const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.welcomeBackMessage(name),
              style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  static void showAccountDeletedSuccess(BuildContext context, AppLocalizations l10n) {
    _show(
      context,
      borderColor: const Color(0xFF10B981),
      content: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF10B981), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.accountDeletedSuccess,
              style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  static void showCodeResent(BuildContext context, AppLocalizations l10n) {
    _show(
      context,
      content: Row(
        children: [
          const Icon(Icons.mark_email_read_rounded, color: Color(0xFF38BDF8), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.codeResentSuccess,
              style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFDC2626),
        content: Text(message),
      ),
    );
  }
}
