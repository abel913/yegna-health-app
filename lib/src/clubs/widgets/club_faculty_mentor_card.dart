import 'package:flutter/material.dart';

import '../../theme/app_glass_theme.dart';

class ClubFacultyMentorCard extends StatelessWidget {
  const ClubFacultyMentorCard({
    required this.mentorName,
    required this.mentorContact,
    required this.isAmharic,
    required this.isDark,
    required this.glass,
    required this.onContactTap,
    super.key,
  });

  final String mentorName;
  final String mentorContact;
  final bool isAmharic;
  final bool isDark;
  final AppGlassTheme glass;
  final VoidCallback onContactTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF131D36).withValues(alpha: 0.70)
            : Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? const Color(0xFF38BDF8).withValues(alpha: 0.20)
              : Colors.white.withValues(alpha: 0.90),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                mentorName.isNotEmpty ? mentorName[0].toUpperCase() : 'C',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAmharic ? 'የክበቡ አስተባባሪ / አቻ አማካሪ' : 'Club Counselor / Lead',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: glass.subtitleText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  mentorName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: glass.titleText,
                  ),
                ),
              ],
            ),
          ),
          if (mentorContact.isNotEmpty)
            IconButton.filledTonal(
              onPressed: onContactTap,
              icon: Icon(
                mentorContact.startsWith('@')
                    ? Icons.near_me_rounded
                    : Icons.call_rounded,
                size: 18,
              ),
              style: IconButton.styleFrom(
                backgroundColor:
                    const Color(0xFF0284C7).withValues(alpha: 0.15),
                foregroundColor: const Color(0xFF0284C7),
              ),
            ),
        ],
      ),
    );
  }
}
