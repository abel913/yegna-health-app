import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../common/module_category_theme.dart';

/// Action buttons dock (More & Take Quiz) for curriculum module cards.
class ModuleCardActions extends StatelessWidget {
  const ModuleCardActions({
    required this.l10n,
    required this.onMore,
    required this.onQuiz,
    required this.categoryTheme,
    super.key,
  });

  final AppLocalizations l10n;
  final VoidCallback onMore;
  final VoidCallback onQuiz;
  final ModuleCategoryTheme categoryTheme;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF006064), Color(0xFF00838F)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33006064),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onMore,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: categoryTheme.accentColor
                    .withValues(alpha: isDark ? 0.45 : 0.35),
                width: 1.3,
              ),
            ),
            child: OutlinedButton(
              onPressed: onQuiz,
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    isDark ? glass.accentColor : const Color(0xFF006064),
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.quiz_outlined,
                    size: 15,
                    color: isDark ? glass.accentColor : const Color(0xFF006064),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.takeQuizButton,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
