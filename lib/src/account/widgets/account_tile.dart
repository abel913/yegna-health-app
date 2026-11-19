import 'package:flutter/material.dart';

import '../../theme/app_glass_theme.dart';

/// Reusable styled Account tile with leading icon container and trailing badge/chevron.
class AccountTile extends StatelessWidget {
  const AccountTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badgeText,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? badgeText;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: glass.isDark
                ? const Color(0xFF0F172A)
                : const Color(0xFF0284C7),
            borderRadius: BorderRadius.circular(12),
            border: glass.isDark
                ? Border.all(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.35),
                  )
                : null,
          ),
          child: Icon(
            icon,
            color: glass.isDark ? const Color(0xFF38BDF8) : Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: glass.titleText,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: glass.subtitleText,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badgeText != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: glass.badgeBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: glass.isDark
                      ? Border.all(
                          color:
                              const Color(0xFF38BDF8).withValues(alpha: 0.25),
                        )
                      : null,
                ),
                child: Text(
                  badgeText!,
                  style: TextStyle(
                    color: glass.badgeText,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: glass.badgeBackground,
                shape: BoxShape.circle,
                border: glass.isDark
                    ? Border.all(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.25),
                      )
                    : null,
              ),
              child: Icon(
                Icons.chevron_right_rounded,
                color: glass.badgeText,
                size: 20,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
