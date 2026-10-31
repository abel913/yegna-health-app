import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'learning_cache.dart';
import 'learning_models.dart';

abstract interface class AssessmentRepository {
  Future<List<AssessmentSummary>> assessments(String locale);
  Future<CachedValue<Assessment>?> assessment(String versionId, String locale);
  Future<List<PendingAssessmentSubmission>> pendingSubmissions();
  Future<AssessmentSubmission> submit({
    required Assessment assessment,
    required Map<String, String> selectedOptions,
    required bool syncProgress,
  });
  Future<AssessmentSubmission?> retryPending(String requestId);
}

class AssessmentSubmission {
  const AssessmentSubmission.completed(this.result, {required this.requestId})
      : isPending = false;
  const AssessmentSubmission.pending({required this.requestId})
      : result = null,
        isPending = true;

  final String requestId;
  final AssessmentResult? result;
  final bool isPending;
}

class AssessmentRejected implements Exception {
  const AssessmentRejected();
}

class AssessmentUnavailable implements Exception {
  const AssessmentUnavailable();
}

class UnconfiguredAssessmentRepository implements AssessmentRepository {
  const UnconfiguredAssessmentRepository();

  @override
  Future<List<AssessmentSummary>> assessments(String locale) async =>
      throw const AssessmentUnavailable();

  @override
  Future<CachedValue<Assessment>?> assessment(
          String versionId, String locale) async =>
      throw const AssessmentUnavailable();

  @override
  Future<List<PendingAssessmentSubmission>> pendingSubmissions() async =>
      const [];

  @override
  Future<AssessmentSubmission> submit({
    required Assessment assessment,
    required Map<String, String> selectedOptions,
    required bool syncProgress,
  }) async =>
      throw const AssessmentRejected();

  @override
  Future<AssessmentSubmission?> retryPending(String requestId) async => null;
}

class SupabaseAssessmentRepository implements AssessmentRepository {
  SupabaseAssessmentRepository(
    this._client,
    this._cache, {
    FlutterSecureStorage? secureStorage,
  }) : _storage = secureStorage ?? const FlutterSecureStorage();

  final SupabaseClient _client;
  final LearningCache _cache;
  final FlutterSecureStorage _storage;

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
      final version = versionRow['version'] as Map<String, dynamic>;
      final assessmentInfo = version['assessment'] as Map<String, dynamic>;
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
      final summary = AssessmentSummary(
        id: assessmentInfo['id'] as String,
        versionId: versionId,
        slug: assessmentInfo['slug'] as String,
        locale: locale,
        title: versionRow['title'] as String,
        description: versionRow['description'] as String? ?? '',
        version: version['version'] as int,
      );
      final result = Assessment(
        summary: summary,
        questions: questionRows.map((row) {
          final translations = row['translations'] as List<dynamic>;
          final options = row['options'] as List<dynamic>;
          return AssessmentQuestion(
            id: row['id'] as String,
            prompt: (translations.first as Map<String, dynamic>)['prompt']
                as String,
            options: options.map((option) {
              final optionTranslations =
                  option['translations'] as List<dynamic>;
              return AssessmentOption(
                id: option['id'] as String,
                label: (optionTranslations.first
                    as Map<String, dynamic>)['label'] as String,
              );
            }).toList(growable: false),
          );
        }).toList(growable: false),
      );
      if (result.questions.isEmpty ||
          result.questions.any((q) => q.options.isEmpty)) {
        throw const AssessmentRejected();
      }
      await _cache.write(
          'assessment_${locale}_$versionId', _assessmentToJson(result));
      return CachedValue(
          value: result, isStale: false, fetchedAt: DateTime.now());
    } on Object {
      final cached = await _cache.read<Assessment>(
        'assessment_${locale}_$versionId',
        (value) => _assessmentFromJson(
          (value! as Map<Object?, Object?>).cast<String, Object?>(),
        ),
      );
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<List<PendingAssessmentSubmission>> pendingSubmissions() =>
      _readPending();

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
      requestId: _newUuid(),
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
    await _savePending(pending);
    return _trySubmit(pending);
  }

  @override
  Future<AssessmentSubmission?> retryPending(String requestId) async {
    final pending = await _readPending();
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
      await _removePending(submission.requestId);
      return AssessmentSubmission.completed(
        _resultFromJson(raw,
            synchronized: body['synchronized'] as bool? ?? false),
        requestId: submission.requestId,
      );
    } on FunctionException catch (error) {
      if (error.status >= 500 || error.status == 408 || error.status == 429) {
        return AssessmentSubmission.pending(requestId: submission.requestId);
      }
      await _removePending(submission.requestId);
      throw const AssessmentRejected();
    } on Exception {
      return AssessmentSubmission.pending(requestId: submission.requestId);
    }
  }

  Future<void> _savePending(PendingAssessmentSubmission submission) async {
    final pending = await _readPending();
    pending.removeWhere((item) => item.requestId == submission.requestId);
    pending.add(submission);
    await _storage.write(
      key: 'learning.pending.$_identityKey',
      value: jsonEncode(pending.map((item) => item.toJson()).toList()),
    );
  }

  Future<List<PendingAssessmentSubmission>> _readPending() async {
    final raw = await _storage.read(key: 'learning.pending.$_identityKey');
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List<Object?>)
          .map((item) => PendingAssessmentSubmission.fromJson(
              (item! as Map<Object?, Object?>).cast<String, Object?>()))
          .toList();
    } on Object {
      await _storage.delete(key: 'learning.pending.$_identityKey');
      return [];
    }
  }

  Future<void> _removePending(String requestId) async {
    final pending = await _readPending();
    pending.removeWhere((item) => item.requestId == requestId);
    if (pending.isEmpty) {
      await _storage.delete(key: 'learning.pending.$_identityKey');
    } else {
      await _storage.write(
        key: 'learning.pending.$_identityKey',
        value: jsonEncode(pending.map((item) => item.toJson()).toList()),
      );
    }
  }

  String get _identityKey => _client.auth.currentUser?.id ?? 'guest';

  String _newUuid() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex =
        bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  void _validateLocale(String locale) {
    if (locale != 'en' && locale != 'am') {
      throw ArgumentError.value(locale, 'locale');
    }
  }

  Map<String, Object?> _assessmentToJson(Assessment assessment) => {
        'summary': {
          'id': assessment.summary.id,
          'versionId': assessment.summary.versionId,
          'slug': assessment.summary.slug,
          'locale': assessment.summary.locale,
          'title': assessment.summary.title,
          'description': assessment.summary.description,
          'version': assessment.summary.version,
        },
        'questions': assessment.questions
            .map((question) => {
                  'id': question.id,
                  'prompt': question.prompt,
                  'options': question.options
                      .map((option) => {'id': option.id, 'label': option.label})
                      .toList(),
                })
            .toList(),
      };

  Assessment _assessmentFromJson(Map<String, Object?> json) {
    final rawSummary =
        (json['summary']! as Map<Object?, Object?>).cast<String, Object?>();
    final summary = AssessmentSummary(
      id: rawSummary['id']! as String,
      versionId: rawSummary['versionId']! as String,
      slug: rawSummary['slug']! as String,
      locale: rawSummary['locale']! as String,
      title: rawSummary['title']! as String,
      description: rawSummary['description']! as String,
      version: rawSummary['version']! as int,
    );
    return Assessment(
      summary: summary,
      questions: (json['questions']! as List<Object?>).map((rawQuestion) {
        final question =
            (rawQuestion! as Map<Object?, Object?>).cast<String, Object?>();
        return AssessmentQuestion(
          id: question['id']! as String,
          prompt: question['prompt']! as String,
          options: (question['options']! as List<Object?>).map((rawOption) {
            final option =
                (rawOption! as Map<Object?, Object?>).cast<String, Object?>();
            return AssessmentOption(
              id: option['id']! as String,
              label: option['label']! as String,
            );
          }).toList(growable: false),
        );
      }).toList(growable: false),
    );
  }

  AssessmentResult _resultFromJson(
    Map<String, dynamic> json, {
    required bool synchronized,
  }) {
    return AssessmentResult(
      score: json['score'] as int,
      totalQuestions: json['totalQuestions'] as int,
      synchronized: synchronized,
      details: (json['details'] as List<dynamic>).map((row) {
        final detail = row as Map<String, dynamic>;
        return QuestionResult(
          questionId: detail['questionId'] as String,
          selectedOptionId: detail['selectedOptionId'] as String,
          correctOptionId: detail['correctOptionId'] as String,
          isCorrect: detail['isCorrect'] as bool,
          explanation: detail['explanation'] as String? ?? '',
        );
      }).toList(growable: false),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}
