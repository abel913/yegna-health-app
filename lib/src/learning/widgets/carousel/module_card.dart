import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../../models/learning_module_item.dart';
import '../common/module_category_theme.dart';
import '../common/module_cover_image.dart';
import 'module_card_content.dart';

/// Glassmorphic Module Card with dynamic category gradients and frosted backdrop blur.
class ModuleCard extends StatelessWidget {
  const ModuleCard({
    required this.module,
    required this.l10n,
    required this.onMore,
    required this.onQuiz,
    this.isCompleted = false,
    super.key,
  });

  final LearningModuleItem module;
  final AppLocalizations l10n;
  final VoidCallback onMore;
  final VoidCallback onQuiz;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;
    final categoryTheme = ModuleCategoryTheme.forCategory(module.category);

    final contentSection = ModuleCardContent(
      module: module,
      l10n: l10n,
      onMore: onMore,
      onQuiz: onQuiz,
      isCompleted: isCompleted,
    );

    final imageSection = Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF0F172A).withValues(alpha: 0.5)
                : const Color(0xFFF0F9FF).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? categoryTheme.accentColor.withValues(alpha: 0.15)
                  : const Color(0xFFBAE6FD).withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Center(
                  child: ModuleCoverImage(
                    imagePath: module.imageAsset,
                    fallbackCategory: module.category,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    alignment: Alignment.center,
                    iconSize: 64,
                  ),
                ),
                if (isCompleted)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981)
                            .withValues(alpha: isDark ? 0.30 : 0.85),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3310B981),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_rounded,
                              size: 13, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Completed',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF131D36).withValues(alpha: 0.78)
                : Colors.white.withValues(alpha: 0.68),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      categoryTheme.accentColor.withValues(alpha: 0.16),
                      const Color(0xFF131D36).withValues(alpha: 0.85),
                      const Color(0xFF0F172A).withValues(alpha: 0.72),
                    ]
                  : [
                      categoryTheme.accentColor.withValues(alpha: 0.08),
                      Colors.white.withValues(alpha: 0.75),
                      const Color(0xFFBAE6FD).withValues(alpha: 0.16),
                    ],
              stops: const [0.0, 0.45, 1.0],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isDark
                  ? categoryTheme.accentColor.withValues(alpha: 0.32)
                  : Colors.white.withValues(alpha: 0.90),
              width: 1.5,
            ),
            boxShadow: [
              ...glass.cardShadow,
              BoxShadow(
                color: categoryTheme.accentColor
                    .withValues(alpha: isDark ? 0.12 : 0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: module.illustrationOnTop
                ? [imageSection, contentSection]
                : [contentSection, imageSection],
          ),
        ),
      ),
    );
  }
}
