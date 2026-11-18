import 'dart:ui';
import 'package:flutter/material.dart';

class AuthGlassContainer extends StatelessWidget {
  const AuthGlassContainer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const borderRadius = 24.0;
    const padding = EdgeInsets.symmetric(horizontal: 22, vertical: 22);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.42),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.75),
                Colors.white.withValues(alpha: 0.28),
                const Color(0xFFBAE6FD).withValues(alpha: 0.18),
              ],
              stops: const [0.0, 0.65, 1.0],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.90),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                blurRadius: 28,
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
                      colors: [
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
  }
}
