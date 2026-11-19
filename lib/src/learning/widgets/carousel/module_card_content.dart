import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../../models/learning_module_item.dart';

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
    final titleText = module.title(l10n);
    final descText = module.description(l10n);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.moduleLabel(module.number).toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: glass.accentColor,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
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
          const SizedBox(height: 8),
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
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF10B981),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              ElevatedButton(
                onPressed: onMore,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? glass.accentColor : const Color(0xFF005A71),
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.moreButton,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded, size: 15),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: onQuiz,
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      isDark ? glass.accentColor : const Color(0xFF005A71),
                  side: BorderSide(
                    color: isDark ? glass.accentColor : const Color(0xFF005A71),
                    width: 1.4,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.quiz_outlined, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      l10n.takeQuizButton,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
