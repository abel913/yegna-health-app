import 'package:flutter/material.dart';
import '../assessment/module_assessment_launcher_card.dart';
import 'assessment_repository.dart';
import 'learning_progress_controller.dart';
import 'mental_health_quiz_page.dart';
import 'modules/mental_health/mental_health_sections.dart';
import 'widgets/curriculum/curriculum_detail_scaffold.dart';

/// Detailed learning module screen for Module 06: Mental Health & Wellbeing.
class MentalHealthDetailPage extends StatelessWidget {
  const MentalHealthDetailPage({
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
      moduleId: 'module-06',
      imageAsset: 'assets/images/learning/module_06_mental_health.jpg',
      title: (l10n) => l10n.module06Title,
      heroDesc: (l10n) => l10n.mentalHealthHeroDesc,
      noteTitle: (l10n) => l10n.hivNoteTitle,
      noteText: (l10n) => l10n.mentalHealthNoteContent,
      totalSections: 4,
      initialExpandedSections: const <int>{},
      initialReadSections: const <int>{},
      progressController: progressController,
      onTakeQuiz: onOpenQuiz ??
          () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => MentalHealthQuizPage(
                  progressController: progressController,
                ),
              ),
            );
          },
      assessmentCard: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ModuleAssessmentLauncherCard(
            sectionNumber: 7,
            sectionKey: 'section_7',
            moduleKey: 'mental_health',
            titleEn: 'Mental Wellbeing & Service Access Assessment',
            titleAm: 'የአእምሮ ጤና እና የአገልግሎት ተደራሽነት ምዘና',
            questionRangeTextEn: 'Q.41–Q.44 • 4 Questions',
            questionRangeTextAm: 'ጥያቄ 41–44 • 4 ጥያቄዎች',
            badgeColor: Color(0xFF0284C7),
          ),
          SizedBox(height: 10),
          ModuleAssessmentLauncherCard(
            sectionNumber: 8,
            sectionKey: 'section_8',
            moduleKey: 'support',
            titleEn: 'Support Needs & Service Preferences',
            titleAm: 'የድጋፍ ፍላጎት እና የአገልግሎት ምርጫዎች',
            questionRangeTextEn: 'Q.45–Q.50 • 6 Questions',
            questionRangeTextAm: 'ጥያቄ 45–50 • 6 ጥያቄዎች',
            badgeColor: Color(0xFF10B981),
          ),
        ],
      ),
      sectionsBuilder: (context, l10n, expanded, read, toggle) =>
          buildMentalHealthSections(
        context: context,
        l10n: l10n,
        expanded: expanded,
        read: read,
        toggle: toggle,
      ),
    );
  }
}
