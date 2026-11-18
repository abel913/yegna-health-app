import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../l10n/app_localizations.dart';

class MentorLauncherHelper {
  const MentorLauncherHelper._();

  static Future<void> launchCall(
    BuildContext context,
    String phone,
    AppLocalizations l10n,
  ) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    final messenger = ScaffoldMessenger.maybeOf(context);
    try {
      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await Clipboard.setData(ClipboardData(text: cleanPhone));
        messenger?.showSnackBar(
          SnackBar(
            content: Text('${l10n.copyPhoneSuccess} ($cleanPhone)'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: cleanPhone));
      messenger?.showSnackBar(
        SnackBar(
          content: Text('${l10n.copyPhoneSuccess} ($cleanPhone)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  static Future<void> launchTelegram(
    BuildContext context,
    String handle,
    AppLocalizations l10n,
  ) async {
    final cleanHandle = handle.replaceAll('@', '').trim();
    final uri = Uri.parse('https://t.me/$cleanHandle');
    final messenger = ScaffoldMessenger.maybeOf(context);
    try {
      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await Clipboard.setData(ClipboardData(text: '@$cleanHandle'));
        messenger?.showSnackBar(
          SnackBar(
            content: Text('${l10n.copyHandleSuccess} (@$cleanHandle)'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: '@$cleanHandle'));
      messenger?.showSnackBar(
        SnackBar(
          content: Text('${l10n.copyHandleSuccess} (@$cleanHandle)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  static Future<void> launchWhatsApp(
    BuildContext context,
    String rawInput,
    AppLocalizations l10n,
  ) async {
    var cleanDigits = rawInput.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanDigits.startsWith('09')) {
      cleanDigits = '251${cleanDigits.substring(1)}';
    } else if (cleanDigits.startsWith('9') && cleanDigits.length == 9) {
      cleanDigits = '251$cleanDigits';
    }

    final Uri uri;
    if (cleanDigits.length >= 7) {
      uri = Uri.parse('https://wa.me/$cleanDigits');
    } else {
      final text = Uri.encodeComponent(rawInput.trim());
      uri = Uri.parse('https://wa.me/?text=Hello%20$text');
    }

    final messenger = ScaffoldMessenger.maybeOf(context);
    try {
      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await Clipboard.setData(ClipboardData(text: rawInput));
        messenger?.showSnackBar(
          SnackBar(
            content: Text('${l10n.copyWhatsappSuccess} ($rawInput)'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: rawInput));
      messenger?.showSnackBar(
        SnackBar(
          content: Text('${l10n.copyWhatsappSuccess} ($rawInput)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  static Future<void> launchEmail(
    BuildContext context,
    String email,
    AppLocalizations l10n,
  ) async {
    final cleanEmail = email.trim();
    final uri = Uri.parse('mailto:$cleanEmail');
    final messenger = ScaffoldMessenger.maybeOf(context);
    try {
      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await Clipboard.setData(ClipboardData(text: cleanEmail));
        messenger?.showSnackBar(
          SnackBar(
            content: Text('${l10n.copyEmailSuccess} ($cleanEmail)'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: cleanEmail));
      messenger?.showSnackBar(
        SnackBar(
          content: Text('${l10n.copyEmailSuccess} ($cleanEmail)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
