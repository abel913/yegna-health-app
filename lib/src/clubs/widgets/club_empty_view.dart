import 'package:flutter/material.dart';

import '../../theme/app_glass_theme.dart';
import '../club_controller.dart';
import '../club_models.dart';

class ClubEmptyView extends StatelessWidget {
  const ClubEmptyView({
    required this.controller,
    required this.isAmharic,
    required this.isDark,
    required this.glass,
    super.key,
  });

  final ClubController controller;
  final bool isAmharic;
  final bool isDark;
  final AppGlassTheme glass;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE0F2FE),
                shape: BoxShape.circle,
              ),
              child: Icon(
                controller.filterOnlyJoined
                    ? Icons.group_add_rounded
                    : Icons.search_off_rounded,
                size: 36,
                color: const Color(0xFF0284C7),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              controller.filterOnlyJoined
                  ? (isAmharic
                      ? 'እስካሁን የተቀላቀሉት ክበብ የለም'
                      : 'No Clubs Joined Yet')
                  : (isAmharic
                      ? 'ምንም ክበብ አልተገኘም'
                      : 'No Matching Clubs Found'),
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                color: glass.titleText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              controller.filterOnlyJoined
                  ? (isAmharic
                      ? 'ከላይ "ሁሉንም ክበቦች" በመምረጥ ተስማሚ የጤና ክበቦችን ይቀላቀሉ።'
                      : 'Browse "Explore All" above and join wellness clubs to connect with peers.')
                  : (isAmharic
                      ? 'እባክዎ የተለየ የፍለጋ ቃል ወይም ምድብ ይሞክሩ።'
                      : 'Try adjusting your search query or category filter.'),
              style: TextStyle(
                fontSize: 13,
                color: glass.subtitleText,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            if (controller.filterOnlyJoined) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => controller.toggleFilterJoined(false),
                icon: const Icon(Icons.explore_rounded, size: 16),
                label: Text(
                  isAmharic ? 'ክበቦችን ያስሱ' : 'Explore Clubs',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ] else if (controller.selectedCategory != ClubCategory.all) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () =>
                    controller.setSelectedCategory(ClubCategory.all),
                child: Text(isAmharic ? 'ሁሉንም አሳይ' : 'Reset Category'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
