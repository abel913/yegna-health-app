import 'package:flutter/material.dart';

import '../../theme/app_glass_theme.dart';
import '../club_models.dart';

class ClubRulesSection extends StatelessWidget {
  const ClubRulesSection({
    required this.liveClub,
    required this.isAmharic,
    required this.isDark,
    required this.glass,
    super.key,
  });

  final StudentClub liveClub;
  final bool isAmharic;
  final bool isDark;
  final AppGlassTheme glass;

  @override
  Widget build(BuildContext context) {
    final rules = isAmharic ? liveClub.rulesAm : liveClub.rulesEn;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isAmharic ? 'የክበቡ መመሪያዎች' : 'Community Guidelines',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: glass.titleText,
          ),
        ),
        const SizedBox(height: 10),
        ...rules.map((rule) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.shield_rounded,
                      size: 16,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      rule,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: glass.subtitleText,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
