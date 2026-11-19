import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../../data/bundled_learning_modules.dart';
import '../../models/learning_module_item.dart';
import '../common/module_category_theme.dart';
import 'module_card.dart';

class LearningModulesCarousel extends StatefulWidget {
  const LearningModulesCarousel({
    required this.onOpenModule,
    required this.onOpenQuiz,
    this.completedModuleIds = const {},
    this.modules,
    super.key,
  });

  final ValueChanged<LearningModuleItem> onOpenModule;
  final ValueChanged<LearningModuleItem> onOpenQuiz;
  final Set<String> completedModuleIds;
  final List<LearningModuleItem>? modules;

  @override
  State<LearningModulesCarousel> createState() =>
      _LearningModulesCarouselState();
}

class _LearningModulesCarouselState extends State<LearningModulesCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.94,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final glass = context.glassTheme;
    final isDark = glass.isDark;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final carouselHeight = (screenHeight * 0.65).clamp(540.0, 600.0);
    final items = (widget.modules != null)
        ? widget.modules!
        : kLearningModules;

    if (items.isEmpty) {
      return _buildEmptyState(glass, isDark);
    }

    if (_currentPage >= items.length && items.isNotEmpty) {
      _currentPage = items.length - 1;
    }

    final activeModule = items[_currentPage];
    final activeTheme = ModuleCategoryTheme.forCategory(activeModule.category);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: carouselHeight,
          child: PageView.builder(
            controller: _pageController,
            itemCount: items.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final module = items[index];
              final isCompleted = widget.completedModuleIds.contains(module.id);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: ModuleCard(
                  module: module,
                  l10n: l10n,
                  isCompleted: isCompleted,
                  onMore: () => widget.onOpenModule(module),
                  onQuiz: () => widget.onOpenQuiz(module),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < items.length; i++) ...[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  width: i == _currentPage ? 26 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    gradient: i == _currentPage
                        ? LinearGradient(colors: activeTheme.gradientColors)
                        : null,
                    color: i == _currentPage
                        ? null
                        : (isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFBAE6FD).withValues(alpha: 0.6)),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: i == _currentPage
                        ? [
                            BoxShadow(
                              color: activeTheme.accentColor.withValues(alpha: 0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 1.5),
                            ),
                          ]
                        : null,
                  ),
                ),
                if (i < items.length - 1) const SizedBox(width: 5),
              ],
              const SizedBox(width: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF131D36).withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: glass.cardBorder.withValues(alpha: isDark ? 0.2 : 0.4),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${_currentPage + 1} / ${items.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: activeTheme.accentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppGlassTheme glass, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF131D36).withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: glass.cardBorder, width: 1.2),
      ),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: glass.accentColor),
          const SizedBox(height: 14),
          Text(
            'No matching modules found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: glass.titleText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try selecting another category or clear your search term.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: glass.subtitleText),
          ),
        ],
      ),
    );
  }
}
