import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../../models/learning_module_item.dart';
import '../common/module_category_theme.dart';
import 'module_card_actions.dart';

class ModuleCardContent extends StatelessWidget {
  const ModuleCardContent({
    required this.module,
    required this.l10n,
    required this.onMore,
    required this.onQuiz,
    required this.isCompleted,
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
    final titleText = module.title(l10n);
    final descText = module.description(l10n);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: categoryTheme.accentColor
                      .withValues(alpha: isDark ? 0.22 : 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: categoryTheme.accentColor
                        .withValues(alpha: isDark ? 0.40 : 0.25),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      categoryTheme.icon,
                      size: 11,
                      color: categoryTheme.accentColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${l10n.moduleLabel(module.number).toUpperCase()} · ${categoryTheme.tag}',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: categoryTheme.accentColor,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 13,
                    color: glass.subtitleText,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${module.readTimeMin} min',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: glass.subtitleText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            titleText,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: glass.titleText,
              height: 1.25,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            descText,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.45,
              color: glass.subtitleText,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (isCompleted) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 15,
                  color: Color(0xFF10B981),
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.completedStatus,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF10B981),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF34D399)],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
          const SizedBox(height: 14),
          ModuleCardActions(
            l10n: l10n,
            onMore: onMore,
            onQuiz: onQuiz,
            categoryTheme: categoryTheme,
          ),
        ],
      ),
    );
  }
}
