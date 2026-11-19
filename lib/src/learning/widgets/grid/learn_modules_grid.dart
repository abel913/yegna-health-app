import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../../models/learning_module_item.dart';
import 'module_grid_card.dart';

/// 2-column curriculum grid layout for scanning all modules quickly.
class LearnModulesGrid extends StatelessWidget {
  const LearnModulesGrid({
    required this.modules,
    required this.onOpenModule,
    this.completedModuleIds = const {},
    super.key,
  });

  final List<LearningModuleItem> modules;
  final ValueChanged<LearningModuleItem> onOpenModule;
  final Set<String> completedModuleIds;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    if (modules.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF131D36).withValues(alpha: 0.7)
              : Colors.white.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: glass.cardBorder, width: 1.2),
        ),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 40, color: glass.accentColor),
            const SizedBox(height: 12),
            Text(
              'No modules match your selection',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: glass.titleText,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.74,
        ),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          final isCompleted = completedModuleIds.contains(module.id);
          return ModuleGridCard(
            module: module,
            l10n: l10n,
            isCompleted: isCompleted,
            onTap: () => onOpenModule(module),
          );
        },
      ),
    );
  }
}
