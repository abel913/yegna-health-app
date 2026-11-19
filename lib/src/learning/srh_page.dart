import 'package:flutter/material.dart';
import '../assessment/module_assessment_launcher_card.dart';
import 'assessment_repository.dart';
import 'learning_progress_controller.dart';
import 'modules/srh/srh_sections.dart';
import 'srh_quiz_page.dart';
import 'widgets/curriculum/curriculum_detail_scaffold.dart';

/// Detailed educational learning module page for Module 05:
/// Sexual and reproductive health (SRH).
class SrhDetailPage extends StatelessWidget {
  const SrhDetailPage({
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
      moduleId: 'module-05',
      imageAsset: 'assets/images/learning/module_05_srh.png',
      title: (l10n) => l10n.module05Title,
      heroDesc: (l10n) => l10n.srhHeroDesc,
      noteTitle: (l10n) => l10n.hivNoteTitle,
      noteText: (l10n) => l10n.srhNoteText,
      totalSections: 4,
      initialExpandedSections: const <int>{0},
      initialReadSections: const <int>{0},
      progressController: progressController,
      onTakeQuiz: onOpenQuiz ??
          () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => SrhQuizPage(
                  progressController: progressController,
                ),
              ),
            );
          },
      assessmentCard: const ModuleAssessmentLauncherCard(
        sectionNumber: 2,
        sectionKey: 'section_2',
        moduleKey: 'srh',
        titleEn: 'Sexual Behaviour & Health Assessment',
        titleAm: 'የጾታዊ ባህሪ እና የጤና ተጋላጭነት ምዘና',
        questionRangeTextEn: 'Q.05–Q.12 • 8 Questions',
        questionRangeTextAm: 'ጥያቄ 05–12 • 8 ጥያቄዎች',
        badgeColor: Color(0xFF0D9488),
      ),
      sectionsBuilder: (context, l10n, expanded, read, toggle) =>
          buildSrhSections(
        context: context,
        l10n: l10n,
        expanded: expanded,
        read: read,
        toggle: toggle,
      ),
    );
  }
}
