import 'dart:ui';
import 'package:flutter/material.dart';

import '../../theme/app_glass_theme.dart';

/// Advanced Deep Glass Container (Optical Frosted Glassmorphism)
class DeepGlassContainer extends StatelessWidget {
  const DeepGlassContainer({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 26.0,
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    final glassBody = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF131D36).withValues(alpha: 0.76)
                : Colors.white.withValues(alpha: 0.38),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF1E293B).withValues(alpha: 0.85),
                      const Color(0xFF0F172A).withValues(alpha: 0.70),
                      const Color(0xFF0284C7).withValues(alpha: 0.16),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.65),
                      Colors.white.withValues(alpha: 0.22),
                      const Color(0xFFBAE6FD).withValues(alpha: 0.16),
                    ],
              stops: const [0.0, 0.65, 1.0],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF38BDF8).withValues(alpha: 0.24)
                  : Colors.white.withValues(alpha: 0.90),
              width: 1.5,
            ),
            boxShadow: isDark
                ? const [
                    BoxShadow(
                      color: Color(0x60000000),
                      blurRadius: 26,
                      offset: Offset(0, 10),
                      spreadRadius: -2,
                    ),
                    BoxShadow(
                      color: Color(0x1F38BDF8),
                      blurRadius: 8,
                      offset: Offset(-1, -1),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.16),
                      blurRadius: 26,
                      offset: const Offset(0, 10),
                      spreadRadius: -2,
                    ),
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.75),
                      blurRadius: 8,
                      offset: const Offset(-2, -2),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 12,
                right: 12,
                child: Container(
                  height: 1.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              const Color(0xFF38BDF8).withValues(alpha: 0.50),
                              const Color(0xFF38BDF8).withValues(alpha: 0.15),
                              Colors.transparent,
                            ]
                          : [
                              Colors.white.withValues(alpha: 0.95),
                              Colors.white.withValues(alpha: 0.30),
                              Colors.transparent,
                            ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: padding,
                child: child,
              ),
            ],
          ),
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: glassBody,
        ),
      );
    }
    return glassBody;
  }
}
