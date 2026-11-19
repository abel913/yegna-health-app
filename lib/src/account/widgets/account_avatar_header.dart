import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_glass_theme.dart';

/// Account page avatar, user display name, and guest promo callout.
class AccountAvatarHeader extends StatelessWidget {
  const AccountAvatarHeader({
    required this.displayName,
    required this.isAuthenticated,
    required this.onSignIn,
    super.key,
  });

  final String displayName;
  final bool isAuthenticated;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Center(
          child: Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: glass.isDark
                  ? const Color(0xFF131D36)
                  : const Color(0xFFF0F9FF),
              border: Border.all(
                color: glass.isDark
                    ? const Color(0xFF38BDF8)
                    : const Color(0xFF7DD3FC),
                width: 3.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: glass.isDark
                      ? const Color(0x3338BDF8)
                      : const Color(0x120284C7),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.person,
              size: 58,
              color: glass.isDark
                  ? const Color(0xFF38BDF8)
                  : const Color(0xFF0284C7),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            displayName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: glass.titleText,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (!isAuthenticated) _buildGuestPromo(context, glass, l10n),
      ],
    );
  }

  Widget _buildGuestPromo(
    BuildContext context,
    AppGlassTheme glass,
    AppLocalizations l10n,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: glass.isDark
              ? const [Color(0xFF0F172A), Color(0xFF1E293B)]
              : const [Color(0xFFE0F2FE), Color(0xFFF0F9FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: glass.isDark ? glass.cardBorder : const Color(0xFFBAE6FD),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: glass.isDark
                ? const Color(0x33000000)
                : const Color(0x0C0284C7),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.cloud_sync_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.guestSignInPromoTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: glass.titleText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.guestSignInPromoBody,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: glass.subtitleText,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: glass.accentColor,
                foregroundColor: glass.isDark ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.login_rounded, size: 18),
              label: Text(
                l10n.guestSignInAction,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              onPressed: onSignIn,
            ),
          ),
        ],
      ),
    );
  }
}
