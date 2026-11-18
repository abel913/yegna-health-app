import 'dart:ui';
import 'package:flutter/material.dart';

import '../club_controller.dart';
import '../club_models.dart';

class ClubCategoryChips extends StatelessWidget {
  const ClubCategoryChips({
    required this.controller,
    required this.isAmharic,
    required this.isDark,
    super.key,
  });

  final ClubController controller;
  final bool isAmharic;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: ClubCategory.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, idx) {
          final cat = ClubCategory.values[idx];
          final isSelected = controller.selectedCategory == cat;
          final catColor = cat.color;

          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: InkWell(
                onTap: () => controller.setSelectedCategory(cat),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? catColor
                        : (isDark
                            ? const Color(0xFF131D36).withValues(alpha: 0.70)
                            : Colors.white.withValues(alpha: 0.60)),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? catColor
                          : (isDark
                              ? const Color(0xFF38BDF8).withValues(alpha: 0.20)
                              : Colors.white.withValues(alpha: 0.85)),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        cat.icon,
                        size: 14,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFF0284C7)),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        cat.label(isAmharic),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                  ? const Color(0xFFF8FAFC)
                                  : const Color(0xFF08264A)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
