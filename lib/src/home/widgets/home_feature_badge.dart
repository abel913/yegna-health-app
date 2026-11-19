import 'package:flutter/material.dart';

import '../../theme/app_glass_theme.dart';

class HomeFeatureBadge extends StatelessWidget {
  const HomeFeatureBadge({
    required this.icon,
    required this.text,
    super.key,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B).withValues(alpha: 0.65)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? const Color(0xFF38BDF8).withValues(alpha: 0.18)
              : const Color(0xFFBAE6FD).withValues(alpha: 0.70),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: glass.accentColor),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: glass.subtitleText,
            ),
          ),
        ],
      ),
    );
  }
}
