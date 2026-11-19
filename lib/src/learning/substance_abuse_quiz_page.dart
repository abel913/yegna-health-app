import 'package:flutter/material.dart';

import 'data/quiz_questions/substance_abuse_questions.dart';
import 'dynamic_quiz_helper.dart';
import 'learning_progress_controller.dart';
import 'quiz/quiz_runner_scaffold.dart';

export 'data/quiz_questions/substance_abuse_questions.dart';

/// Interactive Substance Abuse Module Quiz Screen.
class SubstanceAbuseQuizPage extends StatelessWidget {
  const SubstanceAbuseQuizPage({
    required this.progressController,
    this.questions,
    super.key,
  });

  final LearningProgressController progressController;
  final List<QuizQuestionModel>? questions;

  @override
  Widget build(BuildContext context) {
    return QuizRunnerScaffold(
      title: (l10n) => l10n.substanceQuizTitle,
      moduleId: 'module-08',
      category: 'substance',
      defaultQuestions: kSubstanceAbuseQuizQuestions,
      progressController: progressController,
      questions: questions,
    );
  }
}
