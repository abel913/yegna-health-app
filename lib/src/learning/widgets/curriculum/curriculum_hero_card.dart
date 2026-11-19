import 'package:flutter/material.dart';

import '../common/module_cover_image.dart';

class CurriculumHeroCard extends StatelessWidget {
  const CurriculumHeroCard({
    required this.imageAsset,
    required this.title,
    required this.description,
    super.key,
  });

  final String imageAsset;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFFD6E8F6),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF005A71).withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: ModuleCoverImage(
                imagePath: imageAsset,
                height: 195,
                fit: BoxFit.contain,
                iconSize: 64,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Color(0xFF08264A),
              letterSpacing: -0.3,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF475569),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
