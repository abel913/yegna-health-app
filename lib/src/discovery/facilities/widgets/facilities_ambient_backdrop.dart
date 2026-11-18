import 'package:flutter/material.dart';

import '../../../theme/app_glass_theme.dart';

class FacilitiesAmbientBackdrop extends StatelessWidget {
  const FacilitiesAmbientBackdrop({
    required this.glass,
    required this.isDark,
    required this.child,
    super.key,
  });

  final AppGlassTheme glass;
  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
            top: 140,
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
            top: 420,
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
                          Color(0x1014B8A6),
                          Colors.transparent,
                        ]
                      : const [
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
