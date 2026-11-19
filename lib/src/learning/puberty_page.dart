import 'package:flutter/material.dart';

import '../assessment/module_assessment_launcher_card.dart';
import 'assessment_repository.dart';
import 'learning_progress_controller.dart';
import 'modules/puberty/puberty_sections.dart';
import 'puberty_quiz_page.dart';
import 'widgets/curriculum/curriculum_widgets.dart';

class PubertyDetailPage extends StatelessWidget {
  const PubertyDetailPage({
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
      moduleId: 'module-01',
      imageAsset: 'assets/images/learning/module_01_puberty.jpg',
      title: (l10n) => l10n.module01Title,
      heroDesc: (l10n) => l10n.pubertyHeroDesc,
      noteTitle: (l10n) => l10n.hivNoteTitle,
      noteText: (l10n) => l10n.pubertyNoteText,
      totalSections: 4,
      sectionsBuilder: buildPubertySections,
      progressController: progressController,
      onTakeQuiz: onOpenQuiz ??
          () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => PubertyQuizPage(
                  progressController: progressController,
                ),
              ),
            );
          },
      assessmentCard: const ModuleAssessmentLauncherCard(
        sectionNumber: 5,
        sectionKey: 'section_5',
        moduleKey: 'puberty',
        titleEn: 'Menstrual & Reproductive Health Assessment',
        titleAm: 'የወር አበባ እና ስነ-ተዋልዶ ጤና ምዘና',
        questionRangeTextEn: 'Q.27–Q.34 • 8 Questions',
        questionRangeTextAm: 'ጥያቄ 27–34 • 8 ጥያቄዎች',
        badgeColor: Color(0xFFD946EF),
      ),
    );
  }
}
