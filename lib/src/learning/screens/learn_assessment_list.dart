import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../assessment_repository.dart';
import '../learning_models.dart';
import '../learning_progress_controller.dart';
import 'assessment_session_page.dart';
import 'learn_components.dart';

/// Renders the list of reviewed self-assessments in the learn tab.
class LearnAssessmentList extends StatefulWidget {
  const LearnAssessmentList({
    required this.repository,
    required this.progressController,
    required this.locale,
    super.key,
  });

  final AssessmentRepository repository;
  final LearningProgressController progressController;
  final String locale;

  @override
  State<LearnAssessmentList> createState() => _LearnAssessmentListState();
}

class _LearnAssessmentListState extends State<LearnAssessmentList> {
  late Future<List<AssessmentSummary>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.assessments(widget.locale);
  }

  @override
  void didUpdateWidget(covariant LearnAssessmentList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.locale != widget.locale) {
      _future = widget.repository.assessments(widget.locale);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder<List<AssessmentSummary>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return LearningErrorState(
            message: snapshot.error is AssessmentUnavailable
                ? l10n.educationUnavailable
                : l10n.learningLoadError,
            onRetry: () => setState(
              () => _future = widget.repository.assessments(widget.locale),
            ),
          );
        }
        final assessments = snapshot.data ?? const <AssessmentSummary>[];
        if (assessments.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child:
                  Text(l10n.noReviewedAssessments, textAlign: TextAlign.center),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: assessments
              .map((summary) => Card(
                    child: ListTile(
                      title: Text(summary.title),
                      subtitle: Text(summary.description),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => AssessmentSessionPage(
                            summary: summary,
                            repository: widget.repository,
                            progressController: widget.progressController,
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}
