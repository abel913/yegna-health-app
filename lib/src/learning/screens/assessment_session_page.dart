import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../assessment_repository.dart';
import '../learning_models.dart';
import '../learning_progress_controller.dart';
import 'assessment_question_form.dart';
import 'assessment_result_view.dart';
import 'learn_components.dart';

/// Screen managing an active self-assessment question progression and submission.
class AssessmentSessionPage extends StatefulWidget {
  const AssessmentSessionPage({
    required this.summary,
    required this.repository,
    required this.progressController,
    super.key,
  });

  final AssessmentSummary summary;
  final AssessmentRepository repository;
  final LearningProgressController progressController;

  @override
  State<AssessmentSessionPage> createState() => _AssessmentSessionPageState();
}

class _AssessmentSessionPageState extends State<AssessmentSessionPage> {
  late Future<CachedValue<Assessment>?> _future;
  final Map<String, String> _answers = {};
  int _questionIndex = 0;
  Assessment? _assessment;
  bool _contentIsStale = false;
  DateTime? _fetchedAt;
  AssessmentSubmission? _submission;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _future = widget.repository
        .assessment(widget.summary.versionId, widget.summary.locale);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.summary.title)),
      body: FutureBuilder<CachedValue<Assessment>?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return LearningErrorState(
              message: snapshot.hasError
                  ? l10n.learningLoadError
                  : l10n.educationUnavailable,
              onRetry: () => setState(() {
                _future = widget.repository.assessment(
                    widget.summary.versionId, widget.summary.locale);
              }),
            );
          }
          final cachedAssessment = snapshot.data;
          if (cachedAssessment == null ||
              cachedAssessment.value.questions.isEmpty) {
            return LearningErrorState(
              message: l10n.educationUnavailable,
              onRetry: () => setState(() {
                _future = widget.repository.assessment(
                  widget.summary.versionId,
                  widget.summary.locale,
                );
              }),
            );
          }
          _contentIsStale = cachedAssessment.isStale;
          _fetchedAt = cachedAssessment.fetchedAt;
          _assessment = cachedAssessment.value;
          final submission = _submission;
          if (submission != null) {
            return AssessmentResultView(
              submission: submission,
              assessment: _assessment!,
              contentIsStale: _contentIsStale,
              fetchedAt: _fetchedAt,
              submitting: _submitting,
              onRetry: _retry,
              onRetake: _retake,
              l10n: l10n,
            );
          }
          final assessment = _assessment!;
          return AssessmentQuestionForm(
            assessment: assessment,
            questionIndex: _questionIndex,
            answers: _answers,
            contentIsStale: _contentIsStale,
            fetchedAt: _fetchedAt,
            submitting: _submitting,
            l10n: l10n,
            onAnswerChanged: (value) => setState(() {
              if (!_submitting && value != null) {
                _answers[assessment.questions[_questionIndex].id] = value;
              }
            }),
            onContinue: () => _continue(assessment, l10n),
          );
        },
      ),
    );
  }

  Future<void> _continue(Assessment assessment, AppLocalizations l10n) async {
    final question = assessment.questions[_questionIndex];
    if (!_answers.containsKey(question.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectAnAnswer)),
      );
      return;
    }
    if (_questionIndex < assessment.questions.length - 1) {
      setState(() => _questionIndex++);
      return;
    }
    setState(() => _submitting = true);
    try {
      final submission = await widget.repository.submit(
        assessment: assessment,
        selectedOptions: _answers,
        syncProgress: widget.progressController.syncEnabled &&
            widget.progressController.isAuthenticated,
      );
      if (!mounted) return;
      setState(() => _submission = submission);
      final result = submission.result;
      if (result != null) {
        await widget.progressController.recordAttempt(
          requestId: submission.requestId,
          versionId: assessment.summary.versionId,
          locale: assessment.summary.locale,
          score: result.score,
          totalQuestions: result.totalQuestions,
        );
      }
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.assessmentSubmitError)),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _retry(String requestId) async {
    setState(() => _submitting = true);
    final result = await widget.repository.retryPending(requestId);
    if (!mounted) return;
    if (result != null) {
      setState(() => _submission = result);
      final score = result.result;
      if (score != null) {
        await widget.progressController.recordAttempt(
          requestId: result.requestId,
          versionId: widget.summary.versionId,
          locale: widget.summary.locale,
          score: score.score,
          totalQuestions: score.totalQuestions,
        );
      }
    }
    setState(() => _submitting = false);
  }

  void _retake() {
    setState(() {
      _answers.clear();
      _questionIndex = 0;
      _submission = null;
    });
  }
}
