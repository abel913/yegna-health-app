import 'package:flutter/material.dart';

import '../models/mentor.dart';

class MentorDetailHeader extends StatelessWidget {
  const MentorDetailHeader({
    required this.mentor,
    required this.isAmharic,
    required this.isDark,
    required this.brandNavy,
    required this.brandBlue,
    required this.slateText,
    super.key,
  });

  final Mentor mentor;
  final bool isAmharic;
  final bool isDark;
  final Color brandNavy;
  final Color brandBlue;
  final Color slateText;

  static String formatDisplayName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return trimmed;
    return trimmed.split(RegExp(r'\s+')).map((part) {
      if (part.isEmpty) return part;
      if (part == part.toLowerCase()) {
        return part[0].toUpperCase() + part.substring(1);
      }
      return part;
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    mentor.avatarColor.withValues(alpha: 0.85),
                    mentor.avatarColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? const Color(0xFF38BDF8) : Colors.white,
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: mentor.avatarColor.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  mentor.initials,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: mentor.isCurrentlyAvailableNow
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF59E0B),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? const Color(0xFF0B132B) : Colors.white,
                    width: 2.5,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      formatDisplayName(mentor.localizedName(isAmharic)),
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: brandNavy,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  if (mentor.isVerified)
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0284C7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 11,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                mentor.localizedTitle(isAmharic),
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: brandBlue,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                mentor.localizedOrg(isAmharic),
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 12,
                  color: slateText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFBAE6FD),
                    width: 0.9,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on_rounded, size: 12, color: brandBlue),
                    const SizedBox(width: 4),
                    Text(
                      mentor.localizedCampus(isAmharic),
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? const Color(0xFF38BDF8)
                            : const Color(0xFF0369A1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
