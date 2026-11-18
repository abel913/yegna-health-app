import 'package:flutter/material.dart';

import '../models/facility_enums.dart';

class FacilitiesCategoryChip extends StatelessWidget {
  const FacilitiesCategoryChip({
    required this.label,
    required this.icon,
    required this.category,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;
  final FacilityFilterCategory category;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? const Color(0xFF0284C7).withValues(alpha: 0.85)
                  : const Color(0xFF0284C7))
              : (isDark
                  ? const Color(0xFF131D36).withValues(alpha: 0.65)
                  : Colors.white.withValues(alpha: 0.65)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7))
                : (isDark
                    ? const Color(0xFF38BDF8).withValues(alpha: 0.18)
                    : Colors.white.withValues(alpha: 0.85)),
            width: isSelected ? 1.4 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? Colors.white
                  : (isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B)),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFF334155)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
