import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../learning_models.dart';
import 'learn_components.dart';

class AssessmentQuestionForm extends StatelessWidget {
  const AssessmentQuestionForm({
    required this.assessment,
    required this.questionIndex,
    required this.answers,
    required this.contentIsStale,
    required this.fetchedAt,
    required this.submitting,
    required this.l10n,
    required this.onAnswerChanged,
    required this.onContinue,
    super.key,
  });

  final Assessment assessment;
  final int questionIndex;
  final Map<String, String> answers;
  final bool contentIsStale;
  final DateTime? fetchedAt;
  final bool submitting;
  final AppLocalizations l10n;
  final ValueChanged<String?> onAnswerChanged;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final question = assessment.questions[questionIndex];
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        if (contentIsStale)
          LearningStaleBanner(
            date: fetchedAt ?? DateTime.now(),
          ),
        Text(l10n.questionProgress(
          questionIndex + 1,
          assessment.questions.length,
        )),
        const SizedBox(height: 20),
        Text(question.prompt, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        IgnorePointer(
          ignoring: submitting,
          child: RadioGroup<String>(
            groupValue: answers[question.id],
            onChanged: onAnswerChanged,
            child: Column(
              children: question.options
                  .map((option) => RadioListTile<String>(
                        value: option.id,
                        title: Text(option.label),
                      ))
                  .toList(growable: false),
            ),
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: submitting ? null : onContinue,
          child: submitting
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(questionIndex == assessment.questions.length - 1
                  ? l10n.submitAnswers
                  : l10n.nextQuestion),
        ),
      ],
    );
  }
}
