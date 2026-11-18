import 'package:flutter/material.dart';

import '../models/facility.dart';

class FacilityCategoryIconPod extends StatelessWidget {
  const FacilityCategoryIconPod({
    required this.facility,
    required this.isDark,
    required this.isOpen,
    required this.catColor,
    super.key,
  });

  final Facility facility;
  final bool isDark;
  final bool isOpen;
  final Color catColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                catColor.withValues(alpha: isDark ? 0.35 : 0.22),
                catColor.withValues(alpha: isDark ? 0.18 : 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: catColor.withValues(alpha: isDark ? 0.50 : 0.30),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: catColor.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              facility.categoryIcon,
              color: catColor,
              size: 26,
            ),
          ),
        ),
        Positioned(
          bottom: 1,
          right: 1,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isOpen
                  ? const Color(0xFF10B981)
                  : const Color(0xFFF59E0B),
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                width: 2,
              ),
              boxShadow: [
                if (isOpen)
                  BoxShadow(
                    color: const Color(0xFF10B981).withValues(alpha: 0.5),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
