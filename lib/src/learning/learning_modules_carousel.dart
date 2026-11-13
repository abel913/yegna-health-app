import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_glass_theme.dart';

class LearningModuleItem {
  const LearningModuleItem({
    required this.id,
    required this.number,
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.illustrationOnTop,
    this.category = 'srh',
    this.contentEn = '',
    this.contentAm = '',
    this.readTimeMin = 4,
    this.authorName,
  });

  final String id;
  final String number;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) description;
  final String imageAsset;
  final bool illustrationOnTop;
  final String category;
  final String contentEn;
  final String contentAm;
  final int readTimeMin;
  final String? authorName;

  static String resolveImageAsset(String id, String category) {
    switch (id) {
      case 'module-01':
        return 'assets/images/learning/module_01_puberty.jpg';
      case 'module-02':
        return 'assets/images/learning/module_02_sti.png';
      case 'module-03':
        return 'assets/images/learning/module_03_hepatitis.png';
      case 'module-04':
        return 'assets/images/learning/module_04_gbv.png';
      case 'module-05':
        return 'assets/images/learning/module_05_srh.png';
      case 'module-06':
        return 'assets/images/learning/module_06_mental_health.jpg';
      case 'module-07':
        return 'assets/images/learning/module_07_hiv.png';
      case 'module-08':
        return 'assets/images/learning/module_08_substance_abuse.png';
    }

    final cat = category.toLowerCase();
    if (cat.contains('puberty')) {
      return 'assets/images/learning/module_01_puberty.jpg';
    } else if (cat.contains('sti')) {
      return 'assets/images/learning/module_02_sti.png';
    } else if (cat.contains('hepatitis')) {
      return 'assets/images/learning/module_03_hepatitis.png';
    } else if (cat.contains('gbv') || cat.contains('violence') || cat.contains('consent')) {
      return 'assets/images/learning/module_04_gbv.png';
    } else if (cat.contains('srh') || cat.contains('reproduct')) {
      return 'assets/images/learning/module_05_srh.png';
    } else if (cat.contains('mental') || cat.contains('stress')) {
      return 'assets/images/learning/module_06_mental_health.jpg';
    } else if (cat.contains('hiv') || cat.contains('aids')) {
      return 'assets/images/learning/module_07_hiv.png';
    } else if (cat.contains('substance') || cat.contains('addiction')) {
      return 'assets/images/learning/module_08_substance_abuse.png';
    }
    return 'assets/images/learning/module_05_srh.png';
  }

  factory LearningModuleItem.fromMap(Map<String, dynamic> data, int index) {
    final id = data['id']?.toString() ?? 'module-${index + 1}';
    final number = (index + 1).toString().padLeft(2, '0');
    final titleEn = data['titleEn']?.toString() ?? '';
    final titleAm = data['titleAm']?.toString() ?? '';
    final summaryEn = data['summaryEn']?.toString() ?? '';
    final summaryAm = data['summaryAm']?.toString() ?? '';
    final category = data['category']?.toString() ?? 'srh';

    return LearningModuleItem(
      id: id,
      number: number,
      title: (l10n) {
        final isAmharic = l10n.localeName.startsWith('am');
        if (isAmharic && titleAm.isNotEmpty) return titleAm;
        if (titleEn.isNotEmpty) return titleEn;
        return _fallbackTitle(id, l10n);
      },
      description: (l10n) {
        final isAmharic = l10n.localeName.startsWith('am');
        if (isAmharic && summaryAm.isNotEmpty) return summaryAm;
        if (summaryEn.isNotEmpty) return summaryEn;
        return _fallbackDescription(id, l10n);
      },
      imageAsset: resolveImageAsset(id, category),
      illustrationOnTop: index % 2 == 0,
      category: category,
      contentEn: data['contentEn']?.toString() ?? '',
      contentAm: data['contentAm']?.toString() ?? '',
      readTimeMin: (data['readTimeMin'] as num?)?.toInt() ?? 4,
      authorName: data['authorName']?.toString(),
    );
  }

  static String _fallbackTitle(String id, AppLocalizations l10n) {
    switch (id) {
      case 'module-01':
        return l10n.module01Title;
      case 'module-02':
        return l10n.module02Title;
      case 'module-03':
        return l10n.module03Title;
      case 'module-04':
        return l10n.module04Title;
      case 'module-05':
        return l10n.module05Title;
      case 'module-06':
        return l10n.module06Title;
      case 'module-07':
        return l10n.module07Title;
      case 'module-08':
        return l10n.module08Title;
      default:
        return 'Youth Health Module';
    }
  }

  static String _fallbackDescription(String id, AppLocalizations l10n) {
    switch (id) {
      case 'module-01':
        return l10n.module01Desc;
      case 'module-02':
        return l10n.module02Desc;
      case 'module-03':
        return l10n.module03Desc;
      case 'module-04':
        return l10n.module04Desc;
      case 'module-05':
        return l10n.module05Desc;
      case 'module-06':
        return l10n.module06Desc;
      case 'module-07':
        return l10n.module07Desc;
      case 'module-08':
        return l10n.module08Desc;
      default:
        return '';
    }
  }
}

final List<LearningModuleItem> kLearningModules = [
  LearningModuleItem(
    id: 'module-01',
    number: '01',
    title: (l10n) => l10n.module01Title,
    description: (l10n) => l10n.module01Desc,
    imageAsset: 'assets/images/learning/module_01_puberty.jpg',
    illustrationOnTop: true,
  ),
  LearningModuleItem(
    id: 'module-02',
    number: '02',
    title: (l10n) => l10n.module02Title,
    description: (l10n) => l10n.module02Desc,
    imageAsset: 'assets/images/learning/module_02_sti.png',
    illustrationOnTop: false,
  ),
  LearningModuleItem(
    id: 'module-03',
    number: '03',
    title: (l10n) => l10n.module03Title,
    description: (l10n) => l10n.module03Desc,
    imageAsset: 'assets/images/learning/module_03_hepatitis.png',
    illustrationOnTop: true,
  ),
  LearningModuleItem(
    id: 'module-04',
    number: '04',
    title: (l10n) => l10n.module04Title,
    description: (l10n) => l10n.module04Desc,
    imageAsset: 'assets/images/learning/module_04_gbv.png',
    illustrationOnTop: false,
  ),
  LearningModuleItem(
    id: 'module-05',
    number: '05',
    title: (l10n) => l10n.module05Title,
    description: (l10n) => l10n.module05Desc,
    imageAsset: 'assets/images/learning/module_05_srh.png',
    illustrationOnTop: true,
  ),
  LearningModuleItem(
    id: 'module-06',
    number: '06',
    title: (l10n) => l10n.module06Title,
    description: (l10n) => l10n.module06Desc,
    imageAsset: 'assets/images/learning/module_06_mental_health.jpg',
    illustrationOnTop: false,
  ),
  LearningModuleItem(
    id: 'module-07',
    number: '07',
    title: (l10n) => l10n.module07Title,
    description: (l10n) => l10n.module07Desc,
    imageAsset: 'assets/images/learning/module_07_hiv.png',
    illustrationOnTop: true,
  ),
  LearningModuleItem(
    id: 'module-08',
    number: '08',
    title: (l10n) => l10n.module08Title,
    description: (l10n) => l10n.module08Desc,
    imageAsset: 'assets/images/learning/module_08_substance_abuse.png',
    illustrationOnTop: false,
  ),
];

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
                child: _ModuleCard(
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
        // Indicator Row matching reference: dots on left, "$page / $total" on right
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

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.module,
    required this.l10n,
    required this.onMore,
    required this.onQuiz,
    this.isCompleted = false,
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

    final contentSection = Padding(
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
            ? [
                imageSection,
                contentSection,
              ]
            : [
                contentSection,
                imageSection,
              ],
      ),
    );
  }
}
