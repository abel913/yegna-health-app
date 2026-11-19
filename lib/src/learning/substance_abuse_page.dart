import 'package:flutter/material.dart';
import 'assessment_repository.dart';
import 'learning_progress_controller.dart';
import 'modules/substance_abuse/substance_abuse_sections.dart';
import 'substance_abuse_quiz_page.dart';
import 'widgets/curriculum/curriculum_detail_scaffold.dart';

/// Detailed learning module screen for Module 08: Substance Abuse.
class SubstanceAbuseDetailPage extends StatelessWidget {
  const SubstanceAbuseDetailPage({
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
      moduleId: 'module-08',
      imageAsset: 'assets/images/learning/module_08_substance_abuse.png',
      title: (l10n) => l10n.module08Title,
      heroDesc: (l10n) => l10n.substanceHeroDesc,
      noteTitle: (l10n) => l10n.hivNoteTitle,
      noteText: (l10n) => l10n.substanceNoteContent,
      totalSections: 4,
      initialExpandedSections: const <int>{},
      initialReadSections: const <int>{},
      progressController: progressController,
      onTakeQuiz: onOpenQuiz ??
          () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => SubstanceAbuseQuizPage(
                  progressController: progressController,
                ),
              ),
            );
          },
      sectionsBuilder: (context, l10n, expanded, read, toggle) =>
          buildSubstanceAbuseSections(
        context: context,
        l10n: l10n,
        expanded: expanded,
        read: read,
        toggle: toggle,
      ),
    );
  }
}
