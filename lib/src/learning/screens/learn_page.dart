import 'package:flutter/material.dart';

import '../../locale_controller.dart';
import '../assessment_repository.dart';
import '../education_repository.dart';
import '../learning_modules_carousel.dart';
import '../learning_progress_controller.dart';
import '../sync_education_repository.dart';
import 'learn_header_pill.dart';
import 'learn_quiz_bottom_sheet.dart';
import 'learning_module_navigator.dart';

/// Main Learning screen displaying curriculum modules carousel and assessments.
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

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newLocale = Localizations.localeOf(context).languageCode;
    if (_locale != newLocale) {
      _locale = newLocale;
      _loadModules();
    }
  }

  Future<void> _loadModules({bool forceRefresh = false}) async {
    if (widget.educationRepository is SyncEducationRepository) {
      final repo = widget.educationRepository as SyncEducationRepository;
      final modules =
          await repo.getCurriculumModuleItems(forceRefresh: forceRefresh);
      if (mounted) {
        setState(() {
          _dynamicModules = modules;
        });
      }
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

  void _handleOpenModule(LearningModuleItem module) {
    LearningModuleNavigator.openModule(
      context: context,
      module: module,
      progressController: widget.progressController,
      assessmentRepository: widget.assessmentRepository,
      onOpenDynamicQuiz: () => _handleOpenQuiz(module),
    );
  }

  Future<void> _handleOpenQuiz(LearningModuleItem module) async {
    await LearningModuleNavigator.openQuiz(
      context: context,
      module: module,
      progressController: widget.progressController,
      assessmentRepository: widget.assessmentRepository,
      locale: _locale,
      onShowFallbackInfo: (ctx, mod) => LearnQuizBottomSheet.show(ctx, mod),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            const LearnHeaderPill(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => _reload(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
                  child: ListenableBuilder(
                    listenable: widget.progressController,
                    builder: (_, __) {
                      final completed = widget
                              .progressController.progress?.articles
                              .map((a) => a.articleId)
                              .toSet() ??
                          const <String>{};
                      return LearningModulesCarousel(
                        completedModuleIds: completed,
                        modules: _dynamicModules,
                        onOpenModule: _handleOpenModule,
                        onOpenQuiz: _handleOpenQuiz,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
