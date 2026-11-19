import 'package:flutter/material.dart';

import '../assessment/module_assessment_launcher_card.dart';
import 'assessment_repository.dart';
import 'hiv_quiz_page.dart';
import 'learning_progress_controller.dart';
import 'modules/hiv/hiv_sections.dart';
import 'widgets/curriculum/curriculum_widgets.dart';

/// Detailed educational learning module page for Module 07:
/// Human immune virus (HIV)/AIDS.
class HivModuleDetailPage extends StatelessWidget {
  const HivModuleDetailPage({
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
      moduleId: 'module-07',
      imageAsset: 'assets/images/learning/module_07_hiv.png',
      title: (l10n) => l10n.module07Title,
      heroDesc: (l10n) => l10n.hivHeroDesc,
      noteTitle: (l10n) => l10n.hivNoteTitle,
      noteText: (l10n) => l10n.hivNoteContent,
      totalSections: 5,
      initialReadSections: const {0, 1, 2, 3, 4},
      sectionsBuilder: buildHivSections,
      progressController: progressController,
      onTakeQuiz: onOpenQuiz ??
          () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => HivQuizPage(
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
        questionRangeTextEn: 'Q.11–Q.18 • 8 Questions',
        questionRangeTextAm: 'ጥያቄ 11–18 • 8 ጥያቄዎች',
        badgeColor: Color(0xFFEF4444),
      ),
    );
  }
}
