import 'package:flutter/material.dart';

import 'data/quiz_questions/puberty_questions.dart';
import 'dynamic_quiz_helper.dart';
import 'learning_progress_controller.dart';
import 'quiz/quiz_runner_scaffold.dart';

export 'data/quiz_questions/puberty_questions.dart';

/// Interactive Adolescent Health & Puberty Module Quiz Screen.
class PubertyQuizPage extends StatelessWidget {
  const PubertyQuizPage({
    required this.progressController,
    this.questions,
    super.key,
  });

  final LearningProgressController progressController;
  final List<QuizQuestionModel>? questions;

  @override
  Widget build(BuildContext context) {
    return QuizRunnerScaffold(
      title: (l10n) => l10n.pubertyQuizTitle,
      moduleId: 'module-01',
      category: 'puberty',
      defaultQuestions: kPubertyQuizQuestions,
      progressController: progressController,
      questions: questions,
    );
  }
}
