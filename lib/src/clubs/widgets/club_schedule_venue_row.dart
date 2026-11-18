import 'package:flutter/material.dart';

import '../../theme/app_glass_theme.dart';

class ClubScheduleVenueRow extends StatelessWidget {
  const ClubScheduleVenueRow({
    required this.schedule,
    required this.venue,
    required this.isDark,
    required this.glass,
    super.key,
  });

  final String schedule;
  final String venue;
  final bool isDark;
  final AppGlassTheme glass;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0F172A).withValues(alpha: 0.70)
            : const Color(0xFFF1F5F9).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.schedule_rounded,
            size: 14,
            color: Color(0xFF0284C7),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              schedule,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: glass.titleText,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.location_on_rounded,
            size: 14,
            color: Color(0xFF10B981),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              venue,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: glass.subtitleText,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
