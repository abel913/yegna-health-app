import 'package:flutter/material.dart';

import '../../../theme/app_glass_theme.dart';

/// Atmospheric ambient backdrop featuring dynamic radial gradient orbs
/// that produce high-fidelity optical glassmorphism across Light and Dark themes.
class LearnAmbientBackdrop extends StatelessWidget {
  const LearnAmbientBackdrop({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: glass.scaffoldGradientColors,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            left: -30,
            child: Container(
              width: 340,
              height: 340,
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
                          Color(0x6038BDF8),
                          Color(0x250284C7),
                          Colors.transparent,
                        ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 220,
            right: -50,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isDark
                      ? const [
                          Color(0x288B5CF6),
                          Color(0x12A78BFA),
                          Colors.transparent,
                        ]
                      : const [
                          Color(0x50C4B5FD),
                          Color(0x208B5CF6),
                          Colors.transparent,
                        ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: -40,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isDark
                      ? const [
                          Color(0x250D9488),
                          Color(0x102DD4BF),
                          Colors.transparent,
                        ]
                      : const [
                          Color(0x452DD4BF),
                          Color(0x150D9488),
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
