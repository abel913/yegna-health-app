import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../learning/models/learning_module_item.dart';
import '../../learning/widgets/common/module_cover_image.dart';
import '../../theme/app_glass_theme.dart';

class HomeLearningModuleModal {
  const HomeLearningModuleModal._();

  static void show(
    BuildContext context, {
    required LearningModuleItem module,
    required bool isAmharic,
    required bool isCompleted,
    required VoidCallback onOpenLearning,
  }) {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final glass = ctx.glassTheme;
        final isDark = glass.isDark;

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0F172A).withValues(alpha: 0.96)
                  : Colors.white.withValues(alpha: 0.96),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              border: isDark
                  ? Border.all(color: glass.cardBorder, width: 1.2)
                  : null,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x30000000),
                  blurRadius: 28,
                  offset: Offset(0, -6),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: glass.modalHandle,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: ModuleCoverImage(
                    imagePath: module.imageAsset,
                    fallbackCategory: module.category,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    iconSize: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        l10n.moduleLabel(module.number).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF16A34A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 13,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.completedStatus,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  module.title(l10n),
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: glass.titleText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  module.description(l10n),
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: glass.subtitleText,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onOpenLearning();
                    },
                    icon: const Icon(Icons.menu_book_rounded, size: 18),
                    label: Text(
                      isAmharic ? 'በትምህርት ገጽ ይመልከቱ' : 'Explore in Learn Tab',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: glass.accentColor,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
