import 'package:flutter/material.dart';

class ClubAmbientBackdrop extends StatelessWidget {
  const ClubAmbientBackdrop({required this.isDark, super.key});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? const [
                      Color(0xFF070D1E),
                      Color(0xFF0B132B),
                      Color(0xFF0F172A),
                    ]
                  : const [
                      Color(0xFFF0F9FF),
                      Color(0xFFE0F2FE),
                      Color(0xFFF8FAFC),
                    ],
            ),
          ),
        ),
        Positioned(
          top: 100,
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
          top: 380,
          left: -50,
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
          bottom: 40,
          right: -40,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDark
                    ? const [
                        Color(0x250D9488),
                        Color(0x100284C7),
                        Colors.transparent,
                      ]
                    : const [
                        Color(0x650D9488),
                        Color(0x250284C7),
                        Colors.transparent,
                      ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
