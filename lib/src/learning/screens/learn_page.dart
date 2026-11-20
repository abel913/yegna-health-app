import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../locale_controller.dart';
import '../assessment_repository.dart';
import '../education_repository.dart';
import '../learning_modules_carousel.dart';
import '../learning_progress_controller.dart';
import '../sync_education_repository.dart';
import '../widgets/common/learn_ambient_backdrop.dart';
import '../widgets/common/learn_filter_bar.dart';
import '../widgets/common/learn_progress_capsule.dart';
import '../widgets/grid/learn_modules_grid.dart';
import 'learning_module_navigator.dart';
import 'learning_progress_page.dart';
import 'learn_filter_helper.dart';
import 'learn_header_pill.dart';
import 'learn_quiz_bottom_sheet.dart';

/// Main Learning screen with optical glassmorphism, progress capsule,
/// category filtering, and dual Carousel/Grid view modes.
class LearnPage extends StatefulWidget {
  const LearnPage({
    required this.educationRepository,
    required this.assessmentRepository,
    required this.progressController,
    required this.localeController,
    super.key,
  });

  final EducationRepository educationRepository;
  final AssessmentRepository assessmentRepository;
  final LearningProgressController progressController;
  final LocaleController localeController;

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  String _locale = '';
  List<LearningModuleItem>? _dynamicModules;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isSearchOpen = false;
  bool _isGridMode = false;

  @override
  void initState() {
    super.initState();
    _loadModules();
    final repo = widget.educationRepository;
    if (repo is Listenable) (repo as Listenable).addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    final repo = widget.educationRepository;
    if (repo is Listenable) (repo as Listenable).removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) _loadModules();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = Localizations.localeOf(context).languageCode;
    if (_locale != loc) {
      _locale = loc;
      _loadModules();
    }
  }

  Future<void> _loadModules({bool forceRefresh = false}) async {
    final repo = widget.educationRepository;
    if (repo is SyncEducationRepository) {
      final m = await repo.getCurriculumModuleItems(forceRefresh: forceRefresh);
      if (mounted) setState(() => _dynamicModules = m);
    }
  }

  Future<void> _reload() async {
    try {
      await Future.wait([
        widget.educationRepository.articles(_locale),
        widget.assessmentRepository.assessments(_locale),
        _loadModules(forceRefresh: true),
      ]);
    } catch (_) {}
  }

  void _handleOpenModule(LearningModuleItem module) =>
      LearningModuleNavigator.openModule(
        context: context,
        module: module,
        progressController: widget.progressController,
        assessmentRepository: widget.assessmentRepository,
        onOpenDynamicQuiz: () => _handleOpenQuiz(module),
      );

  Future<void> _handleOpenQuiz(LearningModuleItem module) =>
      LearningModuleNavigator.openQuiz(
        context: context,
        module: module,
        progressController: widget.progressController,
        assessmentRepository: widget.assessmentRepository,
        locale: _locale,
        onShowFallbackInfo: (ctx, mod) => LearnQuizBottomSheet.show(ctx, mod),
      );

  void _openProgress(BuildContext context) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => LearningProgressPage(
            controller: widget.progressController,
            assessmentRepository: widget.assessmentRepository,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final allModules = _dynamicModules ?? kLearningModules;
    final filtered = LearnFilterHelper.filter(
      rawModules: _dynamicModules,
      selectedCategory: _selectedCategory,
      searchQuery: _searchQuery,
      l10n: l10n,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LearnAmbientBackdrop(
        child: SafeArea(
          child: Column(
            children: [
              LearnHeaderPill(
                isGridMode: _isGridMode,
                onToggleMode: () => setState(() => _isGridMode = !_isGridMode),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _reload(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.only(bottom: 32),
                    child: ListenableBuilder(
                      listenable: widget.progressController,
                      builder: (context, _) {
                        final completed = widget.progressController.progress
                                ?.articles.map((a) => a.articleId).toSet() ??
                            const <String>{};

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            LearnProgressCapsule(
                              completedCount: completed.length,
                              totalCount: allModules.length,
                              onTap: () => _openProgress(context),
                            ),
                            LearnFilterBar(
                              selectedCategory: _selectedCategory,
                              onSelectCategory: (c) => setState(() => _selectedCategory = c),
                              searchQuery: _searchQuery,
                              onSearchChanged: (q) => setState(() => _searchQuery = q),
                              isSearchOpen: _isSearchOpen,
                              onToggleSearch: () => setState(() => _isSearchOpen = !_isSearchOpen),
                            ),
                            const SizedBox(height: 6),
                            _isGridMode
                                ? LearnModulesGrid(
                                    modules: filtered,
                                    completedModuleIds: completed,
                                    onOpenModule: _handleOpenModule)
                                : LearningModulesCarousel(
                                    completedModuleIds: completed,
                                    modules: filtered,
                                    onOpenModule: _handleOpenModule,
                                    onOpenQuiz: _handleOpenQuiz),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
