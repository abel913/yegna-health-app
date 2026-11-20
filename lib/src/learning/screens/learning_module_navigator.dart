import 'package:flutter/material.dart';

import '../assessment_repository.dart';
import '../dynamic_module_detail_page.dart';
import '../dynamic_quiz_helper.dart';
import '../gbv_page.dart';
import '../gbv_quiz_page.dart';
import '../hepatitis_page.dart';
import '../hepatitis_quiz_page.dart';
import '../hiv_module_page.dart';
import '../hiv_quiz_page.dart';
import '../learning_modules_carousel.dart';
import '../learning_progress_controller.dart';
import '../mental_health_page.dart';
import '../mental_health_quiz_page.dart';
import '../puberty_page.dart';
import '../puberty_quiz_page.dart';
import '../quiz/quiz_runner_scaffold.dart';
import '../srh_page.dart';
import '../srh_quiz_page.dart';
import '../sti_module_page.dart';
import '../sti_quiz_page.dart';
import '../substance_abuse_page.dart';
import '../substance_abuse_quiz_page.dart';
import 'assessment_session_page.dart';

/// Centralized navigation router for learning curriculum modules and knowledge quizzes.
class LearningModuleNavigator {
  const LearningModuleNavigator._();

  static void openModule({
    required BuildContext context,
    required LearningModuleItem module,
    required LearningProgressController progressController,
    required AssessmentRepository? assessmentRepository,
    required VoidCallback onOpenDynamicQuiz,
  }) {
    if (module.contentEn.isEmpty) {
      final page = _resolveBundledModulePage(
        module.id,
        progressController,
        assessmentRepository,
      );
      if (page != null) {
        Navigator.of(context).push<void>(
          MaterialPageRoute<void>(builder: (_) => page),
        );
        return;
      }
    }

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => DynamicModuleDetailPage(
          module: module,
          progressController: progressController,
          assessmentRepository: assessmentRepository,
          onOpenQuiz: onOpenDynamicQuiz,
        ),
      ),
    );
  }

  static Widget? _resolveBundledModulePage(
    String id,
    LearningProgressController progress,
    AssessmentRepository? assessment,
  ) {
    switch (id) {
      case 'module-01':
        return PubertyDetailPage(progressController: progress, assessmentRepository: assessment);
      case 'module-02':
        return StiModuleDetailPage(progressController: progress, assessmentRepository: assessment);
      case 'module-03':
        return HepatitisDetailPage(progressController: progress, assessmentRepository: assessment);
      case 'module-04':
        return GenderBasedViolenceDetailPage(progressController: progress, assessmentRepository: assessment);
      case 'module-05':
        return SrhDetailPage(progressController: progress, assessmentRepository: assessment);
      case 'module-06':
        return MentalHealthDetailPage(progressController: progress, assessmentRepository: assessment);
      case 'module-07':
        return HivModuleDetailPage(progressController: progress, assessmentRepository: assessment);
      case 'module-08':
        return SubstanceAbuseDetailPage(progressController: progress, assessmentRepository: assessment);
      default:
        return null;
    }
  }

  static Future<void> openQuiz({
    required BuildContext context,
    required LearningModuleItem module,
    required LearningProgressController progressController,
    required AssessmentRepository assessmentRepository,
    required String locale,
    required void Function(BuildContext, LearningModuleItem) onShowFallbackInfo,
  }) async {
    final dynamicQuestions = await DynamicQuizHelper.loadFromCache(
      moduleId: module.id,
      category: module.category,
    );
    if (dynamicQuestions != null &&
        dynamicQuestions.isNotEmpty &&
        context.mounted) {
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => QuizRunnerScaffold(
            title: module.title,
            moduleId: module.id,
            category: module.category,
            defaultQuestions: dynamicQuestions,
            progressController: progressController,
          ),
        ),
      );
      return;
    }

    final quizPage = _resolveBundledQuizPage(module.id, progressController);
    if (quizPage != null && context.mounted) {
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => quizPage),
      );
      return;
    }

    try {
      final assessments = await assessmentRepository.assessments(locale);
      if (assessments.isNotEmpty && context.mounted) {
        final matched = assessments.firstWhere(
          (a) => a.slug.contains(module.id) || a.id == module.id || module.id.contains(a.slug),
          orElse: () => assessments.first,
        );
        Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) => AssessmentSessionPage(
              summary: matched,
              repository: assessmentRepository,
              progressController: progressController,
            ),
          ),
        );
        return;
      }
    } catch (_) {}

    if (context.mounted) {
      onShowFallbackInfo(context, module);
    }
  }

  static Widget? _resolveBundledQuizPage(
    String id,
    LearningProgressController progress,
  ) {
    switch (id) {
      case 'module-01':
        return PubertyQuizPage(progressController: progress);
      case 'module-02':
        return StiQuizPage(progressController: progress);
      case 'module-03':
        return HepatitisQuizPage(progressController: progress);
      case 'module-04':
        return GbvQuizPage(progressController: progress);
      case 'module-05':
        return SrhQuizPage(progressController: progress);
      case 'module-06':
        return MentalHealthQuizPage(progressController: progress);
      case 'module-07':
        return HivQuizPage(progressController: progress);
      case 'module-08':
        return SubstanceAbuseQuizPage(progressController: progress);
      default:
        return null;
    }
  }
}
