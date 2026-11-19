import 'package:flutter/material.dart';
import '../assessment/module_assessment_launcher_card.dart';
import 'assessment_repository.dart';
import 'gbv_quiz_page.dart';
import 'learning_progress_controller.dart';
import 'modules/gbv/gbv_sections.dart';
import 'widgets/curriculum/curriculum_detail_scaffold.dart';

/// Detailed learning module screen for Module 04: Gender-based violence (GBV).
class GenderBasedViolenceDetailPage extends StatelessWidget {
  const GenderBasedViolenceDetailPage({
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
      moduleId: 'module-04',
      imageAsset: 'assets/images/learning/module_04_gbv.png',
      title: (l10n) => l10n.module04Title,
      heroDesc: (l10n) => l10n.gbvHeroDesc,
      noteTitle: (l10n) => l10n.hivNoteTitle,
      noteText: (l10n) => l10n.gbvNoteContent,
      totalSections: 4,
      initialExpandedSections: const <int>{},
      initialReadSections: const <int>{},
      progressController: progressController,
      onTakeQuiz: onOpenQuiz ??
          () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => GbvQuizPage(
                  progressController: progressController,
                ),
              ),
            );
          },
      assessmentCard: const ModuleAssessmentLauncherCard(
        sectionNumber: 6,
        sectionKey: 'section_6',
        moduleKey: 'gbv',
        titleEn: 'Consent, GBV & Safety Assessment',
        titleAm: 'የስምምነት፣ ጾታዊ ጥቃት እና ደህንነት ምዘና',
        questionRangeTextEn: 'Q.35–Q.40 • 6 Questions',
        questionRangeTextAm: 'ጥያቄ 35–40 • 6 ጥያቄዎች',
        badgeColor: Color(0xFFEF4444),
      ),
      sectionsBuilder: (context, l10n, expanded, read, toggle) =>
          buildGbvSections(
        context: context,
        l10n: l10n,
        expanded: expanded,
        read: read,
        toggle: toggle,
      ),
    );
  }
}
