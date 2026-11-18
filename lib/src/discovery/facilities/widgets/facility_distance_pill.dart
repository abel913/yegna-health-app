import 'package:flutter/material.dart';

import '../../location_service.dart';
import '../models/facility.dart';

class FacilityDistancePill extends StatelessWidget {
  const FacilityDistancePill({
    required this.facility,
    required this.isDark,
    required this.isAmharic,
    required this.isNearest,
    super.key,
  });

  final Facility facility;
  final bool isDark;
  final bool isAmharic;
  final bool isNearest;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isNearest) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0369A1).withValues(alpha: 0.55)
                  : const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF38BDF8)
                    : const Color(0xFF0284C7),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.stars_rounded,
                  size: 11,
                  color: isDark
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFF0284C7),
                ),
                const SizedBox(width: 3),
                Text(
                  isAmharic ? 'በጣም ቅርብ' : 'Nearest',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? const Color(0xFF38BDF8)
                        : const Color(0xFF0284C7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF38BDF8).withValues(alpha: 0.15)
                  : Colors.white,
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.near_me_rounded,
                size: 11,
                color: isDark
                    ? const Color(0xFF38BDF8)
                    : const Color(0xFF475569),
              ),
              const SizedBox(width: 4),
              Text(
                LocationService.formatDistance(
                    facility.distanceKm, isAmharic),
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? const Color(0xFFE2E8F0)
                      : const Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
