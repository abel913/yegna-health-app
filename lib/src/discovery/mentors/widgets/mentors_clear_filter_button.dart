import 'package:flutter/material.dart';

import '../../../theme/app_glass_theme.dart';

class MentorsClearFilterButton extends StatelessWidget {
  const MentorsClearFilterButton({
    required this.glass,
    required this.isDark,
    required this.label,
    required this.onTap,
    super.key,
  });

  final AppGlassTheme glass;
  final bool isDark;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const Key('uog_campus_clear_filter'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF334155).withValues(alpha: 0.60)
                : const Color(0xFFF1F5F9).withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0),
              width: 0.9,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.close_rounded, size: 14, color: glass.subtitleText),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: glass.subtitleText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
