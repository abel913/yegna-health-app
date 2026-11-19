import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../assessment_repository.dart';
import '../learning_progress_controller.dart';
import 'learn_components.dart';
import 'pending_submission_list.dart';

/// Screen wrapper for user learning progress and history.
class LearningProgressScreen extends StatelessWidget {
  const LearningProgressScreen({
    required this.controller,
    required this.assessmentRepository,
    super.key,
  });

  final LearningProgressController controller;
  final AssessmentRepository assessmentRepository;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.progressHeading)),
      body: LearningProgressPage(
        controller: controller,
        assessmentRepository: assessmentRepository,
      ),
    );
  }
}

/// Learning progress details, cloud sync configuration, and score history.
class LearningProgressPage extends StatelessWidget {
  const LearningProgressPage({
    required this.controller,
    required this.assessmentRepository,
    super.key,
  });

  final LearningProgressController controller;
  final AssessmentRepository assessmentRepository;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final progress = controller.progress;
        if (controller.isLoading && progress == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.loadError != null && progress == null) {
          return LearningErrorState(
            message: l10n.learningLoadError,
            onRetry: controller.refresh,
          );
        }
        final articles = progress?.articles ?? const [];
        final attempts = progress?.attempts ?? const [];
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.progressSyncTitle,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(l10n.progressSyncDescription),
                    const SizedBox(height: 8),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(controller.syncEnabled
                          ? l10n.progressSyncEnabled
                          : l10n.progressSyncDisabled),
                      value: controller.syncEnabled,
                      onChanged:
                          controller.isAuthenticated && !controller.isBusy
                              ? (value) => _setSync(context, value)
                              : null,
                    ),
                    if (!controller.isAuthenticated)
                      Text(l10n.progressSyncSignInRequired),
                    if (controller.isAuthenticated)
                      OutlinedButton.icon(
                        onPressed: controller.isBusy
                            ? null
                            : () => _clearHistory(context),
                        icon: const Icon(Icons.delete_outline),
                        label: Text(l10n.clearSyncedHistory),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.phone_android),
              title: Text(l10n.localProgressLabel),
              subtitle: Text(l10n.completedArticlesCount(articles.length)),
            ),
            ListTile(
              leading: const Icon(Icons.quiz_outlined),
              title: Text(l10n.scoreHistoryLabel),
              subtitle: Text(l10n.assessmentAttemptsCount(attempts.length)),
            ),
            PendingSubmissionList(
              repository: assessmentRepository,
              progressController: controller,
            ),
            if (articles.isEmpty && attempts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(child: Text(l10n.noLearningProgress)),
              ),
            ...attempts.map((attempt) => ListTile(
                  leading: const Icon(Icons.task_alt),
                  title: Text(l10n.assessmentScorePercent(
                    attempt.totalQuestions == 0
                        ? 0
                        : attempt.score * 100 ~/ attempt.totalQuestions,
                  )),
                  subtitle: Text(MaterialLocalizations.of(context)
                      .formatMediumDate(attempt.completedAt.toLocal())),
                )),
          ],
        );
      },
    );
  }

  Future<void> _setSync(BuildContext context, bool enabled) async {
    final l10n = AppLocalizations.of(context);
    final changed = await controller.setSyncEnabled(enabled);
    if (!context.mounted) return;
    if (!changed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.progressSyncError)),
      );
    }
  }

  Future<void> _clearHistory(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearSyncedHistoryTitle),
        content: Text(l10n.clearSyncedHistoryBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.clearHistoryAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final cleared = await controller.clearSyncedHistory();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text(cleared ? l10n.syncedHistoryCleared : l10n.clearHistoryError),
    ));
  }
}
