import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../assessment_repository.dart';
import '../learning_models.dart';
import '../learning_progress_controller.dart';

/// Widget displaying any pending offline assessment submissions and retrying them.
class PendingSubmissionList extends StatefulWidget {
  const PendingSubmissionList({
    required this.repository,
    required this.progressController,
    super.key,
  });

  final AssessmentRepository repository;
  final LearningProgressController progressController;

  @override
  State<PendingSubmissionList> createState() => _PendingSubmissionListState();
}

class _PendingSubmissionListState extends State<PendingSubmissionList> {
  late Future<List<PendingAssessmentSubmission>> _pending;
  final Set<String> _retrying = {};

  @override
  void initState() {
    super.initState();
    _pending = widget.repository.pendingSubmissions();
  }

  Future<void> _retry(PendingAssessmentSubmission pending) async {
    setState(() => _retrying.add(pending.requestId));
    try {
      final submission =
          await widget.repository.retryPending(pending.requestId);
      final result = submission?.result;
      if (result != null) {
        await widget.progressController.recordAttempt(
          requestId: submission!.requestId,
          versionId: pending.versionId,
          locale: pending.locale,
          score: result.score,
          totalQuestions: result.totalQuestions,
        );
      }
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).assessmentSubmitError),
        ));
      }
    } finally {
      if (mounted) {
        setState(() {
          _retrying.remove(pending.requestId);
          _pending = widget.repository.pendingSubmissions();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<List<PendingAssessmentSubmission>>(
        future: _pending,
        builder: (context, snapshot) {
          final pending = snapshot.data ?? const [];
          if (pending.isEmpty) return const SizedBox.shrink();
          final l10n = AppLocalizations.of(context);
          return Column(
            children: pending
                .map((item) => ListTile(
                      leading: const Icon(Icons.cloud_upload_outlined),
                      title: Text(l10n.pendingScore),
                      trailing: TextButton(
                        onPressed: _retrying.contains(item.requestId)
                            ? null
                            : () => _retry(item),
                        child: _retrying.contains(item.requestId)
                            ? const SizedBox.square(
                                dimension: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(l10n.retryAction),
                      ),
                    ))
                .toList(),
          );
        },
      );
}
