import 'package:flutter/material.dart';

/// Stub implementation for non-web platforms / VM tests.
Widget createInAppVideoEmbed({
  required String videoId,
  double? width,
  double? height,
}) {
  return Container(
    width: width ?? double.infinity,
    height: height ?? 220,
    decoration: BoxDecoration(
      color: const Color(0xFF0F172A),
      borderRadius: BorderRadius.circular(16),
    ),
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.play_circle_fill_rounded,
          color: Color(0xFFEF4444),
          size: 54,
        ),
        const SizedBox(height: 8),
        Text(
          'Video ID: $videoId',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
