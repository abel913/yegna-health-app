import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_glass_theme.dart';
import 'account_guest_promo.dart';

/// Elevated Account page avatar, user status pill, and guest promo callout.
class AccountAvatarHeader extends StatelessWidget {
  const AccountAvatarHeader({
    required this.displayName,
    required this.isAuthenticated,
    required this.onSignIn,
    this.email,
    super.key,
  });

  final String displayName;
  final bool isAuthenticated;
  final VoidCallback onSignIn;
  final String? email;

  String get _initials {
    final clean = displayName.trim();
    if (clean.isEmpty) return '';
    final parts = clean.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      final f = parts[0].isNotEmpty ? parts[0][0] : '';
      final s = parts[1].isNotEmpty ? parts[1][0] : '';
      return (f + s).toUpperCase();
    }
    return clean[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final l10n = AppLocalizations.of(context);
    final initials = _initials;
    final glowColor = glass.isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);

    return Column(
      children: [
        const SizedBox(height: 8),
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withValues(alpha: glass.isDark ? 0.30 : 0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
              ),
              Container(
                width: 98,
                height: 98,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: glass.isDark
                        ? const [Color(0xFF0F172A), Color(0xFF1E293B)]
                        : const [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: glass.isDark ? const Color(0xFF38BDF8) : Colors.white,
                    width: 3.2,
                  ),
                ),
                child: Center(
                  child: initials.isNotEmpty && isAuthenticated
                      ? Text(
                          initials,
                          style: TextStyle(
                            fontSize: initials.length > 1 ? 32 : 38,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.0,
                            color: glowColor,
                          ),
                        )
                      : Icon(Icons.person_rounded, size: 50, color: glowColor),
                ),
              ),
              if (isAuthenticated)
                Positioned(
                  bottom: 2,
                  right: 4,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: glass.isDark ? const Color(0xFF0B1329) : Colors.white,
                        width: 2.2,
                      ),
                    ),
                    child: const Icon(Icons.check, size: 13, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            displayName,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: glass.titleText,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4.5),
            decoration: BoxDecoration(
              color: glass.isDark
                  ? const Color(0xFF1E293B).withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: glass.cardBorder, width: 1.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7.5,
                  height: 7.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isAuthenticated ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  isAuthenticated ? (email ?? l10n.accountTitle) : l10n.accountGuest,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: glass.subtitleText,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (!isAuthenticated) AccountGuestPromo(onSignIn: onSignIn),
      ],
    );
  }
}
