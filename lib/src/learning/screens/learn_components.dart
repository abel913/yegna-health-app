import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// Reusable learning error state with retry action.
class LearningErrorState extends StatelessWidget {
  const LearningErrorState({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      child: Icon(
                        Icons.cloud_off_outlined,
                        size: 28,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      label: Text(AppLocalizations.of(context).retryAction),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

/// Banner indicating cached content may be stale.
class LearningStaleBanner extends StatelessWidget {
  const LearningStaleBanner({required this.date, super.key});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final dateString = MaterialLocalizations.of(context).formatMediumDate(date);
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          AppLocalizations.of(context).staleSavedContentWarning(dateString),
        ),
      ),
    );
  }
}
