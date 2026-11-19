import 'package:flutter/material.dart';

import 'data/quiz_questions/gbv_questions.dart';
import 'dynamic_quiz_helper.dart';
import 'learning_progress_controller.dart';
import 'quiz/quiz_runner_scaffold.dart';

export 'data/quiz_questions/gbv_questions.dart';

/// Interactive Gender-Based Violence (GBV) Module Quiz Screen.
class GbvQuizPage extends StatelessWidget {
  const GbvQuizPage({
    required this.progressController,
    this.questions,
    super.key,
  });

  final LearningProgressController progressController;
  final List<QuizQuestionModel>? questions;

  @override
  Widget build(BuildContext context) {
    return QuizRunnerScaffold(
      title: (l10n) => l10n.gbvQuizTitle,
      moduleId: 'module-04',
      category: 'gbv',
      defaultQuestions: kGbvQuizQuestions,
      progressController: progressController,
      questions: questions,
    );
  }
}
