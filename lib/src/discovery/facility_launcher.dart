import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';

/// Centralized launcher for facility phone calls, Telegram messaging, and GPS map navigation.
class FacilityLauncher {
  const FacilityLauncher._();

  /// Launches the native phone dialer for [phone], falling back to clipboard copy.
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

  /// Opens Telegram chat for [handle], falling back to clipboard copy.
  static Future<void> launchTelegram(
    BuildContext context,
    String handle,
    AppLocalizations l10n,
  ) async {
    final cleanHandle = handle.replaceAll('@', '').trim();
    if (cleanHandle.isEmpty) return;

    final messenger = ScaffoldMessenger.maybeOf(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    final tgUri = Uri.parse('https://t.me/$cleanHandle');

    try {
      final launched =
          await launchUrl(tgUri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await Clipboard.setData(ClipboardData(text: '@$cleanHandle'));
        messenger?.showSnackBar(
          SnackBar(
            content: Text(isAmharic
                ? 'የቴሌግራም አድራሻ ተቀድቷል፡ @$cleanHandle'
                : 'Telegram handle copied: @$cleanHandle'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: '@$cleanHandle'));
      messenger?.showSnackBar(
        SnackBar(
          content: Text(isAmharic
              ? 'የቴሌግራም አድራሻ ተቀድቷል፡ @$cleanHandle'
              : 'Telegram handle copied: @$cleanHandle'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Launches native map navigation to the facility coordinates.
  static Future<void> launchMapNavigation(
    BuildContext context, {
    required double latitude,
    required double longitude,
    required String label,
    required AppLocalizations l10n,
  }) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    // 1. Try Google Maps / Universal Web Map URI
    final encodedLabel = Uri.encodeComponent(label);
    final webMapUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&query_place_id=$encodedLabel',
    );

    try {
      final launched =
          await launchUrl(webMapUri, mode: LaunchMode.externalApplication);
      if (!launched) {
        final coordText = '$latitude, $longitude';
        await Clipboard.setData(ClipboardData(text: coordText));
        messenger?.showSnackBar(
          SnackBar(
            content: Text(isAmharic
                ? 'የካርታ መጋጠሚያዎች ተቀድተዋል ($coordText)'
                : 'Campus GPS coordinates copied ($coordText)'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      final coordText = '$latitude, $longitude';
      await Clipboard.setData(ClipboardData(text: coordText));
      messenger?.showSnackBar(
        SnackBar(
          content: Text(isAmharic
              ? 'የካርታ መጋጠሚያዎች ተቀድተዋል ($coordText)'
              : 'Campus GPS coordinates copied ($coordText)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
