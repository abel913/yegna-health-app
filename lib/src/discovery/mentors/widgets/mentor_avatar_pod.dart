import 'package:flutter/material.dart';

import '../models/mentor.dart';

class MentorAvatarPod extends StatelessWidget {
  const MentorAvatarPod({
    required this.mentor,
    required this.isDark,
    this.size = 50.0,
    super.key,
  });

  final Mentor mentor;
  final bool isDark;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isAvailableNow = mentor.isCurrentlyAvailableNow;

    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                mentor.avatarColor.withValues(alpha: 0.8),
                mentor.avatarColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark
                  ? const Color(0xFF38BDF8).withValues(alpha: 0.6)
                  : Colors.white,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: mentor.avatarColor.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              mentor.initials,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: size * 0.34,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 1,
          right: 1,
          child: Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: isAvailableNow
                  ? const Color(0xFF10B981)
                  : const Color(0xFFF59E0B),
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                width: 2,
              ),
              boxShadow: [
                if (isAvailableNow)
                  BoxShadow(
                    color: const Color(0xFF10B981).withValues(alpha: 0.5),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
