import 'package:flutter/material.dart';

import '../../theme/app_glass_theme.dart';
import '../club_models.dart';

class ClubSheetHeader extends StatelessWidget {
  const ClubSheetHeader({
    required this.liveClub,
    required this.isJoined,
    required this.isAmharic,
    required this.isDark,
    required this.glass,
    required this.title,
    super.key,
  });

  final StudentClub liveClub;
  final bool isJoined;
  final bool isAmharic;
  final bool isDark;
  final AppGlassTheme glass;
  final String title;

  @override
  Widget build(BuildContext context) {
    final catColor = liveClub.category.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: catColor.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: catColor.withValues(alpha: 0.35),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(liveClub.category.icon, size: 15, color: catColor),
                  const SizedBox(width: 6),
                  Text(
                    liveClub.category.label(isAmharic).toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: catColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isJoined
                    ? const Color(0xFF10B981).withValues(alpha: 0.16)
                    : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isJoined
                      ? const Color(0xFF10B981).withValues(alpha: 0.4)
                      : Colors.transparent,
                ),
              ),
              child: Text(
                isJoined
                    ? (isAmharic ? '✓ ተቀላቅለዋል' : '✓ Active Member')
                    : '${liveClub.memberCount} ${isAmharic ? "አባላት" : "members"}'
                        '${liveClub.maxCapacity != null ? " / ${liveClub.maxCapacity}" : ""}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isJoined ? const Color(0xFF10B981) : glass.subtitleText,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: liveClub.category.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Icon(liveClub.category.icon, size: 30, color: Colors.white),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      color: glass.titleText,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${liveClub.category.label(isAmharic)} • ${isAmharic ? "ክበብ" : "Club"}',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: catColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
