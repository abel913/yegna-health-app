import 'package:flutter/material.dart';

import 'data/quiz_questions/hepatitis_questions.dart';
import 'dynamic_quiz_helper.dart';
import 'learning_progress_controller.dart';
import 'quiz/quiz_runner_scaffold.dart';

export 'data/quiz_questions/hepatitis_questions.dart';

/// Interactive Hepatitis Module Quiz Screen.
class HepatitisQuizPage extends StatelessWidget {
  const HepatitisQuizPage({
    required this.progressController,
    this.questions,
    super.key,
  });

  final LearningProgressController progressController;
  final List<QuizQuestionModel>? questions;

  @override
  Widget build(BuildContext context) {
    return QuizRunnerScaffold(
      title: (l10n) => l10n.hepatitisQuizTitle,
      moduleId: 'module-03',
      category: 'hepatitis',
      defaultQuestions: kHepatitisQuizQuestions,
      progressController: progressController,
      questions: questions,
    );
  }
}
