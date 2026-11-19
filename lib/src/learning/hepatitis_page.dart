import 'package:flutter/material.dart';
import 'assessment_repository.dart';
import 'hepatitis_quiz_page.dart';
import 'learning_progress_controller.dart';
import 'modules/hepatitis/hepatitis_sections.dart';
import 'widgets/curriculum/curriculum_detail_scaffold.dart';

/// Detailed learning module screen for Module 03: Hepatitis.
class HepatitisDetailPage extends StatelessWidget {
  const HepatitisDetailPage({
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
      moduleId: 'module-03',
      imageAsset: 'assets/images/learning/module_03_hepatitis.png',
      title: (l10n) => l10n.module03Title,
      heroDesc: (l10n) => l10n.hepatitisHeroDesc,
      noteTitle: (l10n) => l10n.hivNoteTitle,
      noteText: (l10n) => l10n.hepatitisNoteContent,
      totalSections: 6,
      initialExpandedSections: const <int>{},
      initialReadSections: const <int>{},
      progressController: progressController,
      onTakeQuiz: onOpenQuiz ??
          () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => HepatitisQuizPage(
                  progressController: progressController,
                ),
              ),
            );
          },
      sectionsBuilder: (context, l10n, expanded, read, toggle) =>
          buildHepatitisSections(
        context: context,
        l10n: l10n,
        expanded: expanded,
        read: read,
        toggle: toggle,
      ),
    );
  }
}
