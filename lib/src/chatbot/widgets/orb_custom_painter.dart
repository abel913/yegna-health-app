import 'dart:math' as math;
import 'package:flutter/material.dart';

class OrbCustomPainter extends CustomPainter {
  OrbCustomPainter({
    required this.progress,
    required this.isDark,
  });

  final double progress;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Deep Core Base Gradient
    final baseGradient = RadialGradient(
      center: const Alignment(-0.25, -0.30),
      radius: 0.95,
      colors: isDark
          ? const [
              Color(0xFF38BDF8),
              Color(0xFF0284C7),
              Color(0xFF6366F1),
              Color(0xFF1E1B4B),
            ]
          : const [
              Color(0xFFE0F2FE),
              Color(0xFF38BDF8),
              Color(0xFF007A78),
              Color(0xFF0A3749),
            ],
      stops: const [0.0, 0.35, 0.70, 1.0],
    );

    final basePaint = Paint()
      ..shader = baseGradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..isAntiAlias = true;

    canvas.drawCircle(center, radius, basePaint);

    // 2. Swirling Fluid Accent Layer
    final angle = progress * 2 * math.pi;
    final fluidCenter = Offset(
      center.dx + (radius * 0.22 * math.cos(angle)),
      center.dy + (radius * 0.20 * math.sin(angle)),
    );

    final fluidGradient = RadialGradient(
      center: Alignment(
        (fluidCenter.dx - center.dx) / radius,
        (fluidCenter.dy - center.dy) / radius,
      ),
      radius: 0.75,
      colors: isDark
          ? [
              const Color(0xFFA855F7).withValues(alpha: 0.65),
              const Color(0xFFEC4899).withValues(alpha: 0.40),
              Colors.transparent,
            ]
          : [
              const Color(0xFF00F2FE).withValues(alpha: 0.55),
              const Color(0xFF60A5FA).withValues(alpha: 0.30),
              Colors.transparent,
            ],
      stops: const [0.0, 0.55, 1.0],
    );

    final fluidPaint = Paint()
      ..shader = fluidGradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..blendMode = BlendMode.screen
      ..isAntiAlias = true;

    canvas.drawCircle(center, radius, fluidPaint);

    // 3. Electric Cyan Rim Lighting
    final rimGradient = RadialGradient(
      center: const Alignment(0.45, 0.50),
      radius: 0.65,
      colors: isDark
          ? [
              const Color(0xFF06B6D4).withValues(alpha: 0.60),
              Colors.transparent,
            ]
          : [
              const Color(0xFF2DD4BF).withValues(alpha: 0.45),
              Colors.transparent,
            ],
      stops: const [0.0, 1.0],
    );

    final rimPaint = Paint()
      ..shader = rimGradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..blendMode = BlendMode.screen
      ..isAntiAlias = true;

    canvas.drawCircle(center, radius, rimPaint);

    // 4. Specular Curved Gloss Highlight
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: isDark ? 0.85 : 0.95),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.55],
      ).createShader(Rect.fromLTWH(
        center.dx - radius * 0.70,
        center.dy - radius * 0.75,
        radius * 1.0,
        radius * 0.70,
      ))
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final highlightPath = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(center.dx - radius * 0.28, center.dy - radius * 0.35),
        width: radius * 0.70,
        height: radius * 0.38,
      ));

    canvas.drawPath(highlightPath, highlightPaint);

    // 5. Outer Glass Micro-Border
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = SweepGradient(
        colors: [
          Colors.white.withValues(alpha: 0.60),
          isDark
              ? const Color(0xFF38BDF8).withValues(alpha: 0.20)
              : const Color(0xFFBAE6FD).withValues(alpha: 0.30),
          Colors.white.withValues(alpha: 0.55),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..isAntiAlias = true;

    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant OrbCustomPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}
