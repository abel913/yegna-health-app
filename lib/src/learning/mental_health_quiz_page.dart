import 'package:flutter/material.dart';

import 'data/quiz_questions/mental_health_questions.dart';
import 'dynamic_quiz_helper.dart';
import 'learning_progress_controller.dart';
import 'quiz/quiz_runner_scaffold.dart';

export 'data/quiz_questions/mental_health_questions.dart';

/// Interactive Mental Health & Wellbeing Quiz Screen.
class MentalHealthQuizPage extends StatelessWidget {
  const MentalHealthQuizPage({
    required this.progressController,
    this.questions,
    super.key,
  });

  final LearningProgressController progressController;
  final List<QuizQuestionModel>? questions;

  @override
  Widget build(BuildContext context) {
    return QuizRunnerScaffold(
      title: (l10n) => l10n.mentalHealthQuizTitle,
      moduleId: 'module-06',
      category: 'mental_health',
      defaultQuestions: kMentalHealthQuizQuestions,
      progressController: progressController,
      questions: questions,
    );
  }
}
