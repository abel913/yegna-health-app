import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

Future<bool?> showProfileDeleteDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.deleteAccountTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
      content: Text(
        l10n.deleteAccountConfirm,
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
          color: Color(0xFF334155),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFDC2626),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(
            l10n.deleteAccountButton,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}
