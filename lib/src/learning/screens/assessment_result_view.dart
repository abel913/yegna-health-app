import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../assessment_repository.dart';
import '../learning_models.dart';
import 'learn_components.dart';

/// Renders either the pending score state or the scored detailed results.
class AssessmentResultView extends StatelessWidget {
  const AssessmentResultView({
    required this.submission,
    required this.assessment,
    required this.contentIsStale,
    required this.fetchedAt,
    required this.submitting,
    required this.onRetry,
    required this.onRetake,
    required this.l10n,
    super.key,
  });

  final AssessmentSubmission submission;
  final Assessment assessment;
  final bool contentIsStale;
  final DateTime? fetchedAt;
  final bool submitting;
  final Future<void> Function(String requestId) onRetry;
  final VoidCallback onRetake;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final result = submission.result;
    if (result == null) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (contentIsStale)
            LearningStaleBanner(date: fetchedAt ?? DateTime.now()),
          const Icon(Icons.cloud_off_outlined, size: 48),
          const SizedBox(height: 16),
          Text(l10n.pendingScore, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: submitting ? null : () => onRetry(submission.requestId),
            icon: const Icon(Icons.refresh),
            label: Text(l10n.retryAction),
          ),
          TextButton(
            onPressed: onRetake,
            child: Text(l10n.retakeAssessment),
          ),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (contentIsStale)
          LearningStaleBanner(date: fetchedAt ?? DateTime.now()),
        Text(
          l10n.assessmentResult(
            result.score,
            result.totalQuestions,
            result.percentage,
          ),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        ...result.details.map((detail) {
          final question = assessment.questions.firstWhere(
            (item) => item.id == detail.questionId,
          );
          final correctOption = question.options.firstWhere(
            (item) => item.id == detail.correctOptionId,
          );
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(question.prompt,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('${l10n.correctAnswer}: ${correctOption.label}'),
                  if (detail.explanation.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(l10n.answerExplanation,
                        style: Theme.of(context).textTheme.labelLarge),
                    Text(detail.explanation),
                  ],
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: onRetake,
          child: Text(l10n.retakeAssessment),
        ),
      ],
    );
  }
}
