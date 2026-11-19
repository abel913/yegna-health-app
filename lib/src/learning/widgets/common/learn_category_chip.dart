import 'package:flutter/material.dart';

import '../../../theme/app_glass_theme.dart';
import 'module_category_theme.dart';

/// Category filter chip with active gradient glow and icon motif.
class LearnCategoryChip extends StatelessWidget {
  const LearnCategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;
    final theme = ModuleCategoryTheme.forCategory(category);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: theme.gradientColors)
              : null,
          color: isSelected
              ? null
              : (isDark
                  ? const Color(0xFF131D36).withValues(alpha: 0.65)
                  : Colors.white.withValues(alpha: 0.60)),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : glass.cardBorder.withValues(alpha: isDark ? 0.2 : 0.5),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.accentColor.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (category != 'All') ...[
              Icon(
                theme.icon,
                size: 13,
                color: isSelected ? Colors.white : theme.accentColor,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : glass.titleText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
