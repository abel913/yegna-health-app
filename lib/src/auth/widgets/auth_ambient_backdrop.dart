import 'package:flutter/material.dart';

class AuthAmbientBackdrop extends StatelessWidget {
  const AuthAmbientBackdrop({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD4EDFD),
            Color(0xFFBAE6FD),
            Color(0xFFCEE5FD),
            Color(0xFFE2F0FB),
            Color(0xFFEBF4FA),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Ambient Optical Refraction Glow Orbs
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              width: 320,
              height: 320,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x950284C7),
                    Color(0x5038BDF8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 220,
            right: -60,
            child: Container(
              width: 360,
              height: 360,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x806366F1),
                    Color(0x3506B6D4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: 10,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x750D9488),
                    Color(0x3014B8A6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
