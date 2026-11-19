import 'package:flutter/material.dart';
import '../assessment/module_assessment_launcher_card.dart';
import 'assessment_repository.dart';
import 'learning_progress_controller.dart';
import 'modules/sti/sti_sections.dart';
import 'sti_quiz_page.dart';
import 'widgets/curriculum/curriculum_detail_scaffold.dart';

/// Detailed clinical and educational learning page for Module 02:
/// Sexual transmitted infections (STI).
class StiModuleDetailPage extends StatelessWidget {
  const StiModuleDetailPage({
    required this.progressController,
    this.assessmentRepository,
    this.onOpenQuiz,
    super.key,
  });

  final LearningProgressController progressController;
  final AssessmentRepository? assessmentRepository;
  final VoidCallback? onOpenQuiz;

  @override
  Widget build(BuildContext context) {
    return CurriculumDetailScaffold(
      moduleId: 'module-02',
      imageAsset: 'assets/images/learning/module_02_sti.png',
      title: (l10n) => l10n.module02Title,
      heroDesc: (l10n) => l10n.stiHeroDesc,
      noteTitle: (l10n) => l10n.hivNoteTitle,
      noteText: (l10n) => l10n.stiNoteContent,
      totalSections: 6,
      initialExpandedSections: const <int>{},
      initialReadSections: const <int>{1, 2, 4, 5},
      progressController: progressController,
      onTakeQuiz: onOpenQuiz ??
          () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => StiQuizPage(
                  progressController: progressController,
                ),
              ),
            );
          },
      assessmentCard: const ModuleAssessmentLauncherCard(
        sectionNumber: 3,
        sectionKey: 'section_3',
        moduleKey: 'hiv',
        titleEn: 'HIV & STIs Self-Assessment',
        titleAm: 'የኤችአይቪ እና አባለዘር በሽታዎች ምዘና',
        questionRangeTextEn: 'Q.13–Q.20 • 8 Questions',
        questionRangeTextAm: 'ጥያቄ 13–20 • 8 ጥያቄዎች',
        badgeColor: Color(0xFF0284C7),
      ),
      sectionsBuilder: (context, l10n, expanded, read, toggle) =>
          buildStiSections(
        context: context,
        l10n: l10n,
        expanded: expanded,
        read: read,
        toggle: toggle,
      ),
    );
  }
}
