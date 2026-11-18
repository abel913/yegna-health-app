import 'package:flutter/material.dart';

import '../../theme/app_glass_theme.dart';
import '../club_models.dart';

class ClubCardHeader extends StatelessWidget {
  const ClubCardHeader({
    required this.club,
    required this.title,
    required this.mentorName,
    required this.isAmharic,
    required this.glass,
    super.key,
  });

  final StudentClub club;
  final String title;
  final String mentorName;
  final bool isAmharic;
  final AppGlassTheme glass;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: club.category.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Icon(club.category.icon, size: 26, color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: glass.titleText,
                  height: 1.25,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                '${club.category.label(isAmharic)} • $mentorName',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: glass.subtitleText,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
