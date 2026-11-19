import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../../models/learning_module_item.dart';
import 'module_card_content.dart';

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

    final contentSection = ModuleCardContent(
      module: module,
      l10n: l10n,
      onMore: onMore,
      onQuiz: onQuiz,
      isCompleted: isCompleted,
    );

    final imageSection = Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: Center(
          child: Image.asset(
            module.imageAsset,
            fit: BoxFit.contain,
            width: double.infinity,
            alignment: Alignment.center,
            errorBuilder: (_, __, ___) => Icon(
              Icons.menu_book_rounded,
              size: 64,
              color: glass.accentColor,
            ),
          ),
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF131D36).withValues(alpha: 0.85)
            : Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isDark
              ? glass.cardBorder
              : const Color(0xFFBAE6FD).withValues(alpha: 0.65),
          width: 1.5,
        ),
        boxShadow: glass.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: module.illustrationOnTop
            ? [imageSection, contentSection]
            : [contentSection, imageSection],
      ),
    );
  }
}
