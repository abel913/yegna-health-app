import 'dart:ui';
import 'package:flutter/material.dart';

import '../../theme/app_glass_theme.dart';
import '../club_controller.dart';

class ClubSegmentedSwitcher extends StatelessWidget {
  const ClubSegmentedSwitcher({
    required this.controller,
    required this.isAmharic,
    required this.isDark,
    required this.glass,
    required this.joinedCount,
    super.key,
  });

  final ClubController controller;
  final bool isAmharic;
  final bool isDark;
  final AppGlassTheme glass;
  final int joinedCount;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF0F172A).withValues(alpha: 0.70)
                : Colors.white.withValues(alpha: 0.50),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF38BDF8).withValues(alpha: 0.18)
                  : Colors.white.withValues(alpha: 0.80),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => controller.toggleFilterJoined(false),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: !controller.filterOnlyJoined
                          ? (isDark ? const Color(0xFF0284C7) : Colors.white)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        isAmharic ? 'ሁሉንም አስስ' : 'Explore All',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: !controller.filterOnlyJoined
                              ? (isDark ? Colors.white : const Color(0xFF0284C7))
                              : glass.subtitleText,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => controller.toggleFilterJoined(true),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: controller.filterOnlyJoined
                          ? (isDark ? const Color(0xFF0284C7) : Colors.white)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isAmharic ? 'የእኔ ክበቦች' : 'My Clubs',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: controller.filterOnlyJoined
                                  ? (isDark ? Colors.white : const Color(0xFF0284C7))
                                  : glass.subtitleText,
                            ),
                          ),
                          if (joinedCount > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: controller.filterOnlyJoined
                                    ? (isDark
                                        ? const Color(0xFF38BDF8)
                                        : const Color(0xFF0284C7))
                                    : const Color(0xFF10B981),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$joinedCount',
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
