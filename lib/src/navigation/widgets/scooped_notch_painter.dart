import 'dart:math' as math;
import 'package:flutter/material.dart';

/// CustomPainter rendering a smooth organic concave scoop along the top edge of the navigation bar.
class ScoopedNotchBarPainter extends CustomPainter {
  const ScoopedNotchBarPainter({
    required this.notchX,
    required this.color,
    required this.borderColor,
    required this.cradleBorderColor,
    required this.shadowColor,
  });

  final double notchX;
  final Color color;
  final Color borderColor;
  final Color cradleBorderColor;
  final Color shadowColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    const r = 30.0;
    const depth = 22.0;
    const s = 12.0;

    final leftLip = math.max(0.0, notchX - r - s);
    final rightLip = math.min(w, notchX + r + s);

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(leftLip, 0)
      ..cubicTo(
        notchX - r,
        0,
        notchX - r + 3,
        depth,
        notchX,
        depth,
      )
      ..cubicTo(
        notchX + r - 3,
        depth,
        notchX + r,
        0,
        rightLip,
        0,
      )
      ..lineTo(w, 0)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    // 1. Ambient drop shadow
    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawPath(path, shadowPaint);

    // 2. Bar background fill
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // 3. Top edge continuous border
    final borderPath = Path()
      ..moveTo(0, 0)
      ..lineTo(leftLip, 0)
      ..cubicTo(
        notchX - r,
        0,
        notchX - r + 3,
        depth,
        notchX,
        depth,
      )
      ..cubicTo(
        notchX + r - 3,
        depth,
        notchX + r,
        0,
        rightLip,
        0,
      )
      ..lineTo(w, 0);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawPath(borderPath, borderPaint);

    // 4. Half-circle cradle accent contour
    final cradleContour = Path()
      ..moveTo(notchX - r + 2, 2)
      ..cubicTo(
        notchX - r + 5,
        depth,
        notchX + r - 5,
        depth,
        notchX + r - 2,
        2,
      );

    final cradlePaint = Paint()
      ..color = cradleBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawPath(cradleContour, cradlePaint);
  }

  @override
  bool shouldRepaint(covariant ScoopedNotchBarPainter oldDelegate) {
    return oldDelegate.notchX != notchX ||
        oldDelegate.color != color ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.cradleBorderColor != cradleBorderColor;
  }
}
