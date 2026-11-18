import 'package:flutter/material.dart';

import '../models/mentor.dart';

class MentorLiveStatusBanner extends StatelessWidget {
  const MentorLiveStatusBanner({
    required this.mentor,
    required this.isAmharic,
    required this.isDark,
    super.key,
  });

  final Mentor mentor;
  final bool isAmharic;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isCurrentlyOnline = mentor.isCurrentlyAvailableNow;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: isCurrentlyOnline
            ? (isDark
                ? const Color(0xFF064E3B).withValues(alpha: 0.45)
                : const Color(0xFFECFDF5))
            : (isDark
                ? const Color(0xFF78350F).withValues(alpha: 0.4)
                : const Color(0xFFFFFBEB)),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentlyOnline
              ? (isDark
                  ? const Color(0xFF10B981).withValues(alpha: 0.35)
                  : const Color(0xFFA7F3D0))
              : (isDark
                  ? const Color(0xFFF59E0B).withValues(alpha: 0.35)
                  : const Color(0xFFFDE68A)),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurrentlyOnline
                  ? const Color(0xFF10B981)
                  : const Color(0xFFF59E0B),
              boxShadow: [
                BoxShadow(
                  color: (isCurrentlyOnline
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF59E0B))
                      .withValues(alpha: 0.5),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              mentor.getCurrentStatusText(isAmharic),
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: isCurrentlyOnline
                    ? (isDark
                        ? const Color(0xFF34D399)
                        : const Color(0xFF065F46))
                    : (isDark
                        ? const Color(0xFFFBBF24)
                        : const Color(0xFF92400E)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
