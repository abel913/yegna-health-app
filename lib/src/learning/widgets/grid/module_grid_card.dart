import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../../models/learning_module_item.dart';
import '../common/module_category_theme.dart';
import '../common/module_cover_image.dart';

/// Compact frosted glass tile for curriculum grid browsing.
class ModuleGridCard extends StatelessWidget {
  const ModuleGridCard({
    required this.module,
    required this.l10n,
    required this.onTap,
    this.isCompleted = false,
    super.key,
  });

  final LearningModuleItem module;
  final AppLocalizations l10n;
  final VoidCallback onTap;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;
    final catTheme = ModuleCategoryTheme.forCategory(module.category);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF131D36).withValues(alpha: 0.75)
                    : Colors.white.withValues(alpha: 0.70),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? catTheme.accentColor.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.85),
                  width: 1.2,
                ),
                boxShadow: glass.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF0F172A).withValues(alpha: 0.5)
                            : const Color(0xFFF0F9FF).withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Stack(
                          children: [
                            Center(
                              child: ModuleCoverImage(
                                imagePath: module.imageAsset,
                                fallbackCategory: module.category,
                                fit: BoxFit.contain,
                                iconSize: 36,
                              ),
                            ),
                            if (isCompleted)
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 11,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: catTheme.accentColor
                              .withValues(alpha: isDark ? 0.22 : 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          catTheme.tag,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: catTheme.accentColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${module.readTimeMin}m',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: glass.subtitleText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    module.title(l10n),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: glass.titleText,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
