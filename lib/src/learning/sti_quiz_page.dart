import 'package:flutter/material.dart';

import 'data/quiz_questions/sti_questions.dart';
import 'dynamic_quiz_helper.dart';
import 'learning_progress_controller.dart';
import 'quiz/quiz_runner_scaffold.dart';

export 'data/quiz_questions/sti_questions.dart';

/// Interactive STI Module Quiz Screen.
class StiQuizPage extends StatelessWidget {
  const StiQuizPage({
    required this.progressController,
    this.questions,
    super.key,
  });

  final LearningProgressController progressController;
  final List<QuizQuestionModel>? questions;

  @override
  Widget build(BuildContext context) {
    return QuizRunnerScaffold(
      title: (l10n) => l10n.stiQuizTitle,
      moduleId: 'module-02',
      category: 'sti',
      defaultQuestions: kStiQuizQuestions,
      progressController: progressController,
      questions: questions,
    );
  }
}
