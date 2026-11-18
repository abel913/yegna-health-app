import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClubContactLauncher {
  static Future<void> launch(BuildContext context, String contact) async {
    final clean = contact.trim();
    Uri? uri;
    if (clean.startsWith('+') ||
        clean.replaceAll(RegExp(r'\D'), '').length >= 9) {
      uri = Uri.parse('tel:${clean.replaceAll(RegExp(r'[\s\-]'), '')}');
    } else if (clean.startsWith('@') || !clean.contains(' ')) {
      uri = Uri.parse('https://t.me/${clean.replaceFirst('@', '')}');
    }

    if (uri != null) {
      try {
        final launched =
            await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!launched && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Contact: $contact')),
          );
        }
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Contact: $contact')),
          );
        }
      }
    }
  }
}
