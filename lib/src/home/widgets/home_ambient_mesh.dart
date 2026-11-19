import 'package:flutter/material.dart';

class HomeAmbientMesh extends StatelessWidget {
  const HomeAmbientMesh({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -40,
          left: -30,
          child: Container(
            width: 360,
            height: 360,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDark
                    ? const [
                        Color(0x350284C7),
                        Color(0x1838BDF8),
                        Colors.transparent,
                      ]
                    : const [
                        Color(0x950284C7),
                        Color(0x5038BDF8),
                        Colors.transparent,
                      ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 90,
          right: -60,
          child: Container(
            width: 380,
            height: 380,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDark
                    ? const [
                        Color(0x3006B6D4),
                        Color(0x150EA5E9),
                        Colors.transparent,
                      ]
                    : const [
                        Color(0x8806B6D4),
                        Color(0x450EA5E9),
                        Colors.transparent,
                      ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 360,
          left: -60,
          child: Container(
            width: 340,
            height: 340,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDark
                    ? const [
                        Color(0x286366F1),
                        Color(0x1238BDF8),
                        Colors.transparent,
                      ]
                    : const [
                        Color(0x806366F1),
                        Color(0x3538BDF8),
                        Colors.transparent,
                      ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 540,
          right: -50,
          child: Container(
            width: 340,
            height: 340,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDark
                    ? const [
                        Color(0x250D9488),
                        Color(0x1014B8A6),
                        Colors.transparent,
                      ]
                    : const [
                        Color(0x750D9488),
                        Color(0x3514B8A6),
                        Colors.transparent,
                      ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 70,
          left: 20,
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? const Color(0xFF38BDF8).withValues(alpha: 0.25)
                    : Colors.white.withValues(alpha: 0.50),
                width: 2,
              ),
              gradient: RadialGradient(
                colors: isDark
                    ? [
                        const Color(0xFF38BDF8).withValues(alpha: 0.12),
                        Colors.transparent,
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.35),
                        Colors.white.withValues(alpha: 0.05),
                      ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 480,
          right: 26,
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? const Color(0xFF38BDF8).withValues(alpha: 0.25)
                    : Colors.white.withValues(alpha: 0.45),
                width: 2,
              ),
              gradient: RadialGradient(
                colors: isDark
                    ? [
                        const Color(0xFF38BDF8).withValues(alpha: 0.12),
                        Colors.transparent,
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.30),
                        Colors.white.withValues(alpha: 0.05),
                      ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
