import 'package:flutter/material.dart';

import '../../widgets/curriculum/section_video_card.dart';
import 'dynamic_module_parser.dart';

/// Builds children widgets for a parsed dynamic curriculum section.
List<Widget> buildDynamicSectionChildren(
  ParsedSection section, {
  bool isAmharic = false,
}) {
  return [
    if (section.body.isNotEmpty) ...[
      Text(
        section.body,
        style: const TextStyle(
          fontSize: 13.5,
          color: Color(0xFF334155),
          height: 1.6,
        ),
      ),
      const SizedBox(height: 12),
    ],
    for (final bullet in section.bullets)
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 7, right: 10),
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF0284C7),
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                bullet,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF334155),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    if (section.note != null) ...[
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFBBF7D0)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle_outline_rounded,
                color: Color(0xFF16A34A), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                section.note!,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF166534),
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
    if (section.videoId != null) ...[
      SectionVideoCard(
        videoId: section.videoId!,
        videoUrl: section.videoUrl ??
            'https://www.youtube.com/watch?v=${section.videoId}',
        sectionTitle: section.title,
        isAmharic: isAmharic,
      ),
    ],
  ];
}
