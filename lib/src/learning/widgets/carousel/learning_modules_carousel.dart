import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/bundled_learning_modules.dart';
import '../../models/learning_module_item.dart';
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
    final screenHeight = MediaQuery.sizeOf(context).height;
    final carouselHeight = (screenHeight * 0.65).clamp(540.0, 600.0);
    final items = (widget.modules != null && widget.modules!.isNotEmpty)
        ? widget.modules!
        : kLearningModules;

    if (_currentPage >= items.length && items.isNotEmpty) {
      _currentPage = items.length - 1;
    }

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
                  width: i == _currentPage ? 24 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: i == _currentPage
                        ? const Color(0xFF0284C7)
                        : const Color(0xFFBAE6FD),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                if (i < items.length - 1) const SizedBox(width: 5),
              ],
              const SizedBox(width: 14),
              Text(
                '${_currentPage + 1} / ${items.length}',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF005A71),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
