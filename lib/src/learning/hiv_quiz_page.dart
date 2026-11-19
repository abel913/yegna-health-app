import 'package:flutter/material.dart';

import 'data/quiz_questions/hiv_questions.dart';
import 'dynamic_quiz_helper.dart';
import 'learning_progress_controller.dart';
import 'quiz/quiz_runner_scaffold.dart';

export 'data/quiz_questions/hiv_questions.dart';

/// Interactive, optical-glass styled HIV Module Quiz screen.
class HivQuizPage extends StatelessWidget {
  const HivQuizPage({
    required this.progressController,
    this.questions,
    super.key,
  });

  final LearningProgressController progressController;
  final List<QuizQuestionModel>? questions;

  @override
  Widget build(BuildContext context) {
    return QuizRunnerScaffold(
      title: (l10n) => l10n.hivQuizTitle,
      moduleId: 'module-07',
      category: 'hiv',
      defaultQuestions: kHivQuizQuestions,
      progressController: progressController,
      questions: questions,
    );
  }
}
