import 'package:flutter/material.dart';

import '../../theme/app_glass_theme.dart';

/// Reusable styled Account tile with custom icon tinting and trailing badge/chevron.
class AccountTile extends StatelessWidget {
  const AccountTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badgeText,
    this.iconColor,
    this.iconBgColor,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? badgeText;
  final Color? iconColor;
  final Color? iconBgColor;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final resolvedIconColor = iconColor ??
        (glass.isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7));
    final resolvedBgColor = iconBgColor ??
        (glass.isDark
            ? const Color(0xFF0F172A)
            : const Color(0xFF0284C7).withValues(alpha: 0.10));

    return Material(
      color: Colors.transparent,
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: onTap,
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: resolvedBgColor,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: resolvedIconColor.withValues(
                alpha: glass.isDark ? 0.30 : 0.18,
              ),
              width: 1.0,
            ),
          ),
          child: Center(
            child: Icon(
              icon,
              color: resolvedIconColor,
              size: 22,
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15.5,
            color: glass.titleText,
            letterSpacing: -0.2,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12.5,
            color: glass.subtitleText,
            height: 1.25,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badgeText != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(
                  color: glass.badgeBackground,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: glass.isDark
                        ? const Color(0xFF38BDF8).withValues(alpha: 0.25)
                        : const Color(0xFFBAE6FD).withValues(alpha: 0.6),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  badgeText!,
                  style: TextStyle(
                    color: glass.badgeText,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
            Icon(
              Icons.chevron_right_rounded,
              color: glass.subtitleText.withValues(alpha: 0.65),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
