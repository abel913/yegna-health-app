import 'package:flutter/material.dart';

import '../models/facility.dart';

class FacilityMapPin extends StatelessWidget {
  const FacilityMapPin({
    required this.facility,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final Facility facility;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.22 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isSelected
                      ? const [Color(0xFF0F172A), Color(0xFF334155)]
                      : [
                          facility.categoryColor,
                          facility.categoryColor.withValues(alpha: 0.85),
                        ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: isSelected ? 2.6 : 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? const Color(0x770F172A)
                        : const Color(0x40000000),
                    blurRadius: isSelected ? 12 : 6,
                    spreadRadius: isSelected ? 2 : 0,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                facility.categoryIcon,
                color: Colors.white,
                size: 19,
              ),
            ),
            CustomPaint(
              size: const Size(10, 6),
              painter: PinTipPainter(
                color: isSelected
                    ? const Color(0xFF0F172A)
                    : facility.categoryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PinTipPainter extends CustomPainter {
  const PinTipPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant PinTipPainter oldDelegate) =>
      oldDelegate.color != color;
}
