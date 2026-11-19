import 'dart:async';

import '../../sync/api_client.dart';
import '../../sync/offline_sync_store.dart';
import '../models/assessment_models.dart';
import 'assessment_repository.dart';
import 'sync_assessment_parser.dart';

class SyncAssessmentRepository implements AssessmentRepository {
  SyncAssessmentRepository({
    required OfflineSyncStore store,
    ApiClient? apiClient,
  })  : _store = store,
        _apiClient = apiClient;

  final OfflineSyncStore _store;
  final ApiClient? _apiClient;

  @override
  Future<List<AssessmentSummary>> assessments(String locale) async {
    final isAmharic = locale.startsWith('am');
    final rawQuizzes = await _store.getCachedQuizzes() ?? [];

    if (rawQuizzes.isEmpty && !(await _store.hasSynced('quizzes'))) {
      return SyncAssessmentParser.defaultSummaries(locale, isAmharic);
    }

    final summaries = <AssessmentSummary>[];
    final seen = <String>{};
    for (final q in rawQuizzes) {
      final modId = q['moduleId']?.toString() ?? 'general';
      if (!seen.contains(modId)) {
        seen.add(modId);
        final modInfo = q['module'] as Map<String, dynamic>?;
        final title = isAmharic
            ? (modInfo?['titleAm'] as String? ?? 'የሞጁል ምዘና')
            : (modInfo?['titleEn'] as String? ?? 'Module Quiz');
        summaries.add(AssessmentSummary(
          id: 'assessment_$modId',
          versionId: 'ver_${modId}_v1',
          slug: modId,
          locale: locale,
          title: title,
          description: isAmharic
              ? 'የተማሩትን ትምህርት ግንዛቤ በዚህ ፈተና ይገምግሙ።'
              : 'Test your knowledge on the completed health module.',
          version: 1,
        ));
      }
    }

    if (_apiClient != null) {
      unawaited(_revalidateQuizzes());
    }

    return summaries;
  }

  @override
  Future<CachedValue<Assessment>?> assessment(
    String versionId,
    String locale,
  ) async {
    final isAmharic = locale.startsWith('am');
    final rawQuizzes = await _store.getCachedQuizzes() ?? [];
    final questions = SyncAssessmentParser.parseQuestions(rawQuizzes, isAmharic);

    final summary = AssessmentSummary(
      id: versionId,
      versionId: versionId,
      slug: versionId,
      locale: locale,
      title: isAmharic ? 'የጤና እውቀት ምዘና' : 'Youth Health Knowledge Check',
      description: isAmharic
          ? 'ሚስጥራዊ የራስ ምዘና ጥያቄዎች።'
          : 'Confidential self-assessment questions.',
      version: 1,
    );

    return CachedValue(
      value: Assessment(summary: summary, questions: questions),
      isStale: false,
      fetchedAt: DateTime.now(),
    );
  }

  @override
  Future<List<PendingAssessmentSubmission>> pendingSubmissions() async =>
      const [];

  @override
  Future<AssessmentSubmission> submit({
    required Assessment assessment,
    required Map<String, String> selectedOptions,
    required bool syncProgress,
  }) async {
    int correctCount = 0;
    final questionResults = <QuestionResult>[];

    for (final q in assessment.questions) {
      final selected = selectedOptions[q.id];
      final isCorrect = selected != null &&
          (selected == 'opt_0' || selected == q.options.first.id);
      if (isCorrect) correctCount++;

      questionResults.add(QuestionResult(
        questionId: q.id,
        selectedOptionId: selected ?? '',
        correctOptionId: q.options.isNotEmpty ? q.options.first.id : '',
        isCorrect: isCorrect,
        explanation: 'Great job reviewing key adolescent health guidance.',
      ));
    }

    final result = AssessmentResult(
      score: correctCount,
      totalQuestions: assessment.questions.length,
      details: questionResults,
      synchronized: true,
    );

    return AssessmentSubmission.completed(
      result,
      requestId: 'local_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<AssessmentSubmission?> retryPending(String requestId) async => null;

  Future<void> _revalidateQuizzes() async {
    try {
      final remoteList = await _apiClient?.fetchQuizzes();
      if (remoteList != null && remoteList.isNotEmpty) {
        await _store.saveQuizzes(remoteList);
      }
    } catch (_) {}
  }
}
