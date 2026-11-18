import 'dart:ui';
import 'package:flutter/material.dart';

import '../../theme/app_glass_theme.dart';
import '../club_controller.dart';
import 'club_segmented_switcher.dart';

class ClubSearchSegmentedBar extends StatelessWidget {
  const ClubSearchSegmentedBar({
    required this.searchController,
    required this.controller,
    required this.isAmharic,
    required this.isDark,
    required this.glass,
    required this.joinedCount,
    super.key,
  });

  final TextEditingController searchController;
  final ClubController controller;
  final bool isAmharic;
  final bool isDark;
  final AppGlassTheme glass;
  final int joinedCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF131D36).withValues(alpha: 0.76)
                      : Colors.white.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF38BDF8).withValues(alpha: 0.22)
                        : Colors.white.withValues(alpha: 0.85),
                    width: 1.2,
                  ),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: controller.setSearchQuery,
                  style: TextStyle(fontSize: 13.5, color: glass.titleText),
                  decoration: InputDecoration(
                    hintText: isAmharic
                        ? 'ክበብ፣ ርዕስ ወይም አሰልጣኝ ፈልግ...'
                        : 'Search clubs, topics, mentors...',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: glass.subtitleText.withValues(alpha: 0.8),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: isDark
                          ? const Color(0xFF38BDF8)
                          : const Color(0xFF0284C7),
                    ),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              searchController.clear();
                              controller.setSearchQuery('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ClubSegmentedSwitcher(
            controller: controller,
            isAmharic: isAmharic,
            isDark: isDark,
            glass: glass,
            joinedCount: joinedCount,
          ),
        ],
      ),
    );
  }
}
