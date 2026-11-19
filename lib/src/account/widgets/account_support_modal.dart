import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_glass_theme.dart';

/// Shows support center bottom sheet with hotline contact information.
void showAccountSupportModal(
  BuildContext context,
  AppLocalizations l10n,
) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final glass = ctx.glassTheme;
      return Container(
        decoration: BoxDecoration(
          color: glass.modalBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: glass.isDark
              ? Border.all(color: glass.cardBorder, width: 1.2)
              : null,
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: glass.modalHandle,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: glass.isDark
                        ? glass.badgeBackground
                        : const Color(0xFF0284C7).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.support_agent_rounded,
                    color: glass.accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.supportCenterTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: glass.titleText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              l10n.supportCenterBody,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: glass.subtitleText,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: glass.isDark
                    ? const Color(0xFF131D36)
                    : const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: glass.isDark
                      ? glass.cardBorder
                      : const Color(0xFFBAE6FD),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.phone_in_talk_rounded, color: glass.accentColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Emergency Hotlines: 952 / 8335 (Toll-Free)',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: glass.titleText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: glass.accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  l10n.closeButton,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: glass.isDark ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
