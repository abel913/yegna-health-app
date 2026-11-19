import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../auth/auth_controller.dart';
import '../../theme/app_glass_theme.dart';

/// Shows the privacy and security modal with optional sign-out action.
void showAccountPrivacyModal(
  BuildContext context,
  AppLocalizations l10n,
  AuthController auth,
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
                    Icons.shield_outlined,
                    color: glass.accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.privacyModalTitle,
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
              l10n.privacyModalBody,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: glass.subtitleText,
              ),
            ),
            const SizedBox(height: 20),
            if (auth.isAuthenticated)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFEF4444),
                  side: const BorderSide(color: Color(0xFFEF4444)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout_rounded),
                label: Text(l10n.signOut),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  auth.signOut();
                },
              ),
            const SizedBox(height: 10),
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
