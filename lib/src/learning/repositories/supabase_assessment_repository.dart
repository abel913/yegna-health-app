import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../learning_cache.dart';
import '../models/assessment_models.dart';
import 'assessment_repository.dart';
import 'assessment_submission_storage.dart';
import 'supabase_assessment_codec.dart';

class SupabaseAssessmentRepository implements AssessmentRepository {
  SupabaseAssessmentRepository(
    this._client,
    this._cache, {
    FlutterSecureStorage? secureStorage,
    AssessmentSubmissionStorage? submissionStorage,
  }) : _storage = submissionStorage ??
            AssessmentSubmissionStorage(secureStorage: secureStorage);

  final SupabaseClient _client;
  final LearningCache _cache;
  final AssessmentSubmissionStorage _storage;

  @override
  Future<List<AssessmentSummary>> assessments(String locale) async {
    _validateLocale(locale);
    final rows = await _client
        .from('education_assessment_version_translations')
        .select(
          'version_id,title,description,version:education_assessment_versions!inner(version,assessment_id,publication_status,assessment:education_assessments!inner(id,slug))',
        )
        .eq('locale', locale)
        .eq('publication_status', 'published')
        .gte('review_due_at', DateTime.now().toUtc().toIso8601String())
        .eq('version.publication_status', 'published')
        .order('title')
        .limit(200);
    return rows.map((row) {
      final version = row['version'] as Map<String, dynamic>;
      final assessment = version['assessment'] as Map<String, dynamic>;
      return AssessmentSummary(
        id: assessment['id'] as String,
        versionId: row['version_id'] as String,
        slug: assessment['slug'] as String,
        locale: locale,
        title: row['title'] as String,
        description: row['description'] as String? ?? '',
        version: version['version'] as int,
      );
    }).toList(growable: false);
  }

  @override
  Future<CachedValue<Assessment>?> assessment(
      String versionId, String locale) async {
    _validateLocale(locale);
    try {
      final versionRow = await _client
          .from('education_assessment_version_translations')
          .select(
            'version_id,title,description,version:education_assessment_versions!inner(version,assessment_id,publication_status,assessment:education_assessments!inner(id,slug))',
          )
          .eq('version_id', versionId)
          .eq('locale', locale)
          .eq('publication_status', 'published')
          .gte('review_due_at', DateTime.now().toUtc().toIso8601String())
          .eq('version.publication_status', 'published')
          .maybeSingle();
      if (versionRow == null) {
        await _cache.remove('assessment_${locale}_$versionId');
        return null;
      }
      final questionRows = await _client
          .from('education_assessment_questions')
          .select(
            'id,position,translations:education_assessment_question_translations!inner(prompt,locale),options:education_assessment_options(id,position,translations:education_assessment_option_translations!inner(label,locale))',
          )
          .eq('version_id', versionId)
          .eq('translations.locale', locale)
          .eq('options.translations.locale', locale)
          .order('position')
          .limit(50);
      final summary = SupabaseAssessmentCodec.parseSummary(
        versionRow: versionRow,
        versionId: versionId,
        locale: locale,
      );
      final questions = SupabaseAssessmentCodec.parseQuestions(questionRows);
      final result = Assessment(summary: summary, questions: questions);
      if (result.questions.isEmpty ||
          result.questions.any((q) => q.options.isEmpty)) {
        throw const AssessmentRejected();
      }
      await _cache.write(
        'assessment_${locale}_$versionId',
        SupabaseAssessmentCodec.assessmentToJson(result),
      );
      return CachedValue(
          value: result, isStale: false, fetchedAt: DateTime.now());
    } on Object {
      final cached = await _cache.read<Assessment>(
        'assessment_${locale}_$versionId',
        (value) => SupabaseAssessmentCodec.assessmentFromJson(
          (value! as Map<Object?, Object?>).cast<String, Object?>(),
        ),
      );
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<List<PendingAssessmentSubmission>> pendingSubmissions() =>
      _storage.readPending(_identityKey);

  @override
  Future<AssessmentSubmission> submit({
    required Assessment assessment,
    required Map<String, String> selectedOptions,
    required bool syncProgress,
  }) async {
    if (selectedOptions.length != assessment.questions.length ||
        assessment.questions.any((question) => !question.options
            .any((option) => option.id == selectedOptions[question.id]))) {
      throw const AssessmentRejected();
    }
    final pending = PendingAssessmentSubmission(
      requestId: AssessmentSubmissionStorage.newUuid(),
      versionId: assessment.summary.versionId,
      locale: assessment.summary.locale,
      syncProgress: syncProgress,
      answers: assessment.questions
          .map((question) => {
                'questionId': question.id,
                'optionId': selectedOptions[question.id]!,
              })
          .toList(growable: false),
    );
    await _storage.savePending(_identityKey, pending);
    return _trySubmit(pending);
  }

  @override
  Future<AssessmentSubmission?> retryPending(String requestId) async {
    final pending = await _storage.readPending(_identityKey);
    final item = pending.where((row) => row.requestId == requestId).firstOrNull;
    if (item == null) return null;
    return _trySubmit(item);
  }

  Future<AssessmentSubmission> _trySubmit(
    PendingAssessmentSubmission submission,
  ) async {
    try {
      final response = await _client.functions.invoke(
        'submit-assessment',
        body: {
          'versionId': submission.versionId,
          'locale': submission.locale,
          'requestId': submission.requestId,
          'answers': submission.answers,
          'syncProgress': submission.syncProgress,
        },
      );
      final body = response.data as Map<String, dynamic>;
      final raw = body['result'] as Map<String, dynamic>;
      await _storage.removePending(_identityKey, submission.requestId);
      return AssessmentSubmission.completed(
        SupabaseAssessmentCodec.resultFromJson(raw,
            synchronized: body['synchronized'] as bool? ?? false),
        requestId: submission.requestId,
      );
    } on FunctionException catch (error) {
      if (error.status >= 500 || error.status == 408 || error.status == 429) {
        return AssessmentSubmission.pending(requestId: submission.requestId);
      }
      await _storage.removePending(_identityKey, submission.requestId);
      throw const AssessmentRejected();
    } on Exception {
      return AssessmentSubmission.pending(requestId: submission.requestId);
    }
  }

  String get _identityKey => _client.auth.currentUser?.id ?? 'guest';

  void _validateLocale(String locale) {
    if (locale != 'en' && locale != 'am') {
      throw ArgumentError.value(locale, 'locale');
    }
  }
}
