import 'package:flutter/material.dart';

import 'data/quiz_questions/srh_questions.dart';
import 'dynamic_quiz_helper.dart';
import 'learning_progress_controller.dart';
import 'quiz/quiz_runner_scaffold.dart';

export 'data/quiz_questions/srh_questions.dart';

/// Interactive Sexual and Reproductive Health (SRH) Module Quiz Screen.
class SrhQuizPage extends StatelessWidget {
  const SrhQuizPage({
    required this.progressController,
    this.questions,
    super.key,
  });

  final LearningProgressController progressController;
  final List<QuizQuestionModel>? questions;

  @override
  Widget build(BuildContext context) {
    return QuizRunnerScaffold(
      title: (l10n) => l10n.srhQuizTitle,
      moduleId: 'module-05',
      category: 'srh',
      defaultQuestions: kSrhQuizQuestions,
      progressController: progressController,
      questions: questions,
    );
  }
}
