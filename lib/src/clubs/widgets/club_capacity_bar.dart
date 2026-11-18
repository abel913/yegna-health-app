import 'package:flutter/material.dart';

import '../club_models.dart';

class ClubCapacityBar extends StatelessWidget {
  const ClubCapacityBar({
    required this.club,
    required this.isDark,
    super.key,
  });

  final StudentClub club;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (club.maxCapacity == null || club.maxCapacity! <= 0) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: 72,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: club.capacityUtilization,
          minHeight: 5,
          backgroundColor: isDark
              ? const Color(0xFF1E293B)
              : const Color(0xFFE2E8F0),
          valueColor: AlwaysStoppedAnimation<Color>(
            club.isAtCapacity
                ? const Color(0xFFEF4444)
                : (club.isNearCapacity
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFF10B981)),
          ),
        ),
      ),
    );
  }
}
