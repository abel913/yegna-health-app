import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../theme/app_glass_theme.dart';
import 'learn_category_chip.dart';

/// Interactive frosted glass category filter bar and search trigger.
class LearnFilterBar extends StatelessWidget {
  const LearnFilterBar({
    required this.selectedCategory,
    required this.onSelectCategory,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.isSearchOpen,
    required this.onToggleSearch,
    super.key,
  });

  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final bool isSearchOpen;
  final VoidCallback onToggleSearch;

  static const List<String> categories = [
    'All',
    'Puberty',
    'SRH',
    'Mental Health',
    'STIs',
    'HIV',
    'GBV',
    'Substance',
  ];

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSearchOpen) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF131D36).withValues(alpha: 0.8)
                          : Colors.white.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF38BDF8).withValues(alpha: 0.3)
                            : const Color(0xFFBAE6FD),
                        width: 1.2,
                      ),
                    ),
                    child: TextField(
                      autofocus: true,
                      onChanged: onSearchChanged,
                      style: TextStyle(fontSize: 14, color: glass.titleText),
                      decoration: InputDecoration(
                        hintText: 'Search health modules or topics...',
                        hintStyle:
                            TextStyle(fontSize: 13, color: glass.subtitleText),
                        prefixIcon: Icon(Icons.search_rounded,
                            size: 18, color: glass.accentColor),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18),
                          onPressed: () {
                            onSearchChanged('');
                            onToggleSearch();
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 11),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildSearchTrigger(glass, isDark);
                }
                final cat = categories[index - 1];
                final isSelected =
                    selectedCategory.toLowerCase() == cat.toLowerCase();
                return LearnCategoryChip(
                  category: cat,
                  isSelected: isSelected,
                  onTap: () => onSelectCategory(cat),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTrigger(AppGlassTheme glass, bool isDark) {
    return GestureDetector(
      onTap: onToggleSearch,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isSearchOpen
              ? glass.accentColor.withValues(alpha: isDark ? 0.25 : 0.15)
              : (isDark
                  ? const Color(0xFF131D36).withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.6)),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSearchOpen ? glass.accentColor : glass.cardBorder,
            width: 1.2,
          ),
        ),
        child: Icon(
          isSearchOpen ? Icons.search_off_rounded : Icons.search_rounded,
          size: 18,
          color: isSearchOpen ? glass.accentColor : glass.subtitleText,
        ),
      ),
    );
  }
}
