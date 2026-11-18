import 'package:flutter/material.dart';

import '../../../theme/app_glass_theme.dart';
import '../models/mentor.dart';

class MentorCardHeader extends StatelessWidget {
  const MentorCardHeader({
    required this.mentor,
    required this.isAmharic,
    required this.glass,
    required this.isDark,
    super.key,
  });

  final Mentor mentor;
  final bool isAmharic;
  final AppGlassTheme glass;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                mentor.localizedName(isAmharic),
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: glass.titleText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (mentor.isVerified) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.verified_rounded,
                size: 16,
                color: isDark
                    ? const Color(0xFF38BDF8)
                    : const Color(0xFF0284C7),
              ),
            ],
          ],
        ),
        const SizedBox(height: 2),
        Text(
          mentor.localizedTitle(isAmharic),
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 1),
        Text(
          mentor.localizedOrg(isAmharic),
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 11.5,
            color: glass.subtitleText,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF312E81).withValues(alpha: 0.55)
                : const Color(0xFFEEF2FF).withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF6366F1).withValues(alpha: 0.35)
                  : const Color(0xFFC7D2FE).withValues(alpha: 0.85),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 11,
                color: isDark
                    ? const Color(0xFFA5B4FC)
                    : const Color(0xFF4F46E5),
              ),
              const SizedBox(width: 3),
              Text(
                mentor.localizedCampus(isAmharic),
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? const Color(0xFFC7D2FE)
                      : const Color(0xFF4338CA),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
