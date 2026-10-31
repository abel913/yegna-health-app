import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ArticleCompletion {
  const ArticleCompletion({
    required this.articleId,
    required this.locale,
    required this.completedAt,
  });
  final String articleId;
  final String locale;
  final DateTime completedAt;
}

class LearningAttempt {
  const LearningAttempt({
    required this.requestId,
    required this.versionId,
    required this.locale,
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
  });
  final String requestId;
  final String versionId;
  final String locale;
  final int score;
  final int totalQuestions;
  final DateTime completedAt;
}

class LearningProgress {
  const LearningProgress({
    required this.syncEnabled,
    required this.articles,
    required this.attempts,
  });
  final bool syncEnabled;
  final List<ArticleCompletion> articles;
  final List<LearningAttempt> attempts;
}

class ProgressSyncFailure implements Exception {
  const ProgressSyncFailure();
}

abstract interface class LearningProgressStore {
  Future<LearningProgress> load(String? userId);
  Future<bool> setSyncEnabled(String? userId, bool enabled);
  Future<void> markArticleCompleted({
    required String? userId,
    required String articleId,
    required String locale,
    required bool syncEnabled,
  });
  Future<void> recordAttempt({
    required String? userId,
    required String requestId,
    required String versionId,
    required String locale,
    required int score,
    required int totalQuestions,
  });
  Future<void> clearSynchronizedHistory(String userId);
}

class ProgressRepository implements LearningProgressStore {
  ProgressRepository(
    this._client, {
    FlutterSecureStorage? secureStorage,
    DateTime Function()? clock,
  })  : _storage = secureStorage ?? const FlutterSecureStorage(),
        _clock = clock ?? DateTime.now;

  final SupabaseClient? _client;
  final FlutterSecureStorage _storage;
  final DateTime Function() _clock;

  @override
  Future<LearningProgress> load(String? userId) async {
    var local = await _readLocal(userId);
    var syncEnabled = local.syncEnabled;
    var attempts = local.attempts;
    if (userId != null && _client != null) {
      try {
        if (local.syncDisablePending) {
          await _client.from('user_learning_preferences').upsert({
            'user_id': userId,
            'sync_enabled': false,
            'updated_at': _clock().toUtc().toIso8601String(),
          });
          local = local.copyWith(syncDisablePending: false);
          await _writeLocal(userId, local);
        }
        final preference = await _client
            .from('user_learning_preferences')
            .select('sync_enabled,history_cleared_at')
            .eq('user_id', userId)
            .maybeSingle();
        syncEnabled = local.syncDisablePending
            ? false
            : preference?['sync_enabled'] as bool? ?? false;
        final rawClearedAt = preference?['history_cleared_at'] as String?;
        final clearedAt =
            rawClearedAt == null ? null : DateTime.parse(rawClearedAt);
        local = local.copyWith(
          syncEnabled: syncEnabled,
          historyClearedAt: clearedAt,
        );
        await _writeLocal(userId, local);
        if (syncEnabled) {
          for (final completion in local.articles) {
            if (local.historyClearedAt == null ||
                completion.completedAt.isAfter(local.historyClearedAt!)) {
              await _upsertCloudCompletion(userId, completion);
            }
          }
          final cloudArticles = await _client
              .from('user_article_progress')
              .select('article_id,locale,completed_at')
              .eq('user_id', userId)
              .order('completed_at', ascending: false)
              .limit(500);
          final articlesByKey = <String, ArticleCompletion>{
            for (final completion in local.articles)
              '${completion.articleId}:${completion.locale}': completion,
            for (final row in cloudArticles)
              '${row['article_id']}:${row['locale']}': ArticleCompletion(
                articleId: row['article_id'] as String,
                locale: row['locale'] as String,
                completedAt: DateTime.parse(row['completed_at'] as String),
              ),
          };
          local = local.copyWith(articles: articlesByKey.values.toList());
          await _writeLocal(userId, local);
          final cloudAttempts = await _client
              .from('user_assessment_attempts')
              .select(
                  'request_id,version_id,locale,score,total_questions,completed_at')
              .eq('user_id', userId)
              .order('completed_at', ascending: false)
              .limit(100);
          attempts = [
            ...local.attempts,
            ...cloudAttempts.map(_attemptFromRow),
          ];
        }
      } on Object {
        // Keep the locally protected progress usable if the connection is offline.
      }
    }
    return LearningProgress(
      syncEnabled: syncEnabled,
      articles: local.articles,
      attempts: _deduplicateAttempts(attempts),
    );
  }

  @override
  Future<bool> setSyncEnabled(String? userId, bool enabled) async {
    if (userId == null || _client == null) throw const ProgressSyncFailure();
    var local = await _readLocal(userId);
    if (!enabled) {
      await _writeLocal(
          userId,
          local.copyWith(
            syncEnabled: false,
            syncDisablePending: true,
          ));
      try {
        await _client.from('user_learning_preferences').upsert({
          'user_id': userId,
          'sync_enabled': false,
          'updated_at': _clock().toUtc().toIso8601String(),
        });
        await _writeLocal(
            userId,
            local.copyWith(
              syncEnabled: false,
              syncDisablePending: false,
            ));
        return true;
      } on Object {
        throw const ProgressSyncFailure();
      }
    }

    try {
      await _client.from('user_learning_preferences').upsert({
        'user_id': userId,
        'sync_enabled': true,
        'updated_at': _clock().toUtc().toIso8601String(),
      });
      local = local.copyWith(syncEnabled: true);
      await _writeLocal(userId, local);
      for (final completion in local.articles) {
        if (local.historyClearedAt == null ||
            completion.completedAt.isAfter(local.historyClearedAt!)) {
          await _upsertCloudCompletion(userId, completion);
        }
      }
      return true;
    } on Object {
      await _writeLocal(userId, local.copyWith(syncEnabled: false));
      throw const ProgressSyncFailure();
    }
  }

  @override
  Future<void> markArticleCompleted({
    required String? userId,
    required String articleId,
    required String locale,
    required bool syncEnabled,
  }) async {
    if (locale != 'en' && locale != 'am') throw ArgumentError.value(locale);
    final current = await _readLocal(userId);
    final completion = ArticleCompletion(
      articleId: articleId,
      locale: locale,
      completedAt: _clock().toUtc(),
    );
    final syncPreference = syncEnabled && current.syncEnabled;
    final articles = [
      ...current.articles.where(
        (item) => item.articleId != articleId || item.locale != locale,
      ),
      completion,
    ];
    await _writeLocal(userId, current.copyWith(articles: articles));
    if (userId != null && syncPreference && _client != null) {
      await _upsertCloudCompletion(userId, completion);
    }
  }

  @override
  Future<void> recordAttempt({
    required String? userId,
    required String requestId,
    required String versionId,
    required String locale,
    required int score,
    required int totalQuestions,
  }) async {
    final current = await _readLocal(userId);
    final attempt = LearningAttempt(
      requestId: requestId,
      versionId: versionId,
      locale: locale,
      score: score,
      totalQuestions: totalQuestions,
      completedAt: _clock().toUtc(),
    );
    final attempts = _deduplicateAttempts([...current.attempts, attempt]);
    await _writeLocal(userId, current.copyWith(attempts: attempts));
  }

  @override
  Future<void> clearSynchronizedHistory(String userId) async {
    if (_client == null) throw const ProgressSyncFailure();
    try {
      await _client.rpc('clear_my_learning_history');
      await _writeLocal(
          userId,
          (await _readLocal(userId)).copyWith(
            historyClearedAt: _clock().toUtc(),
          ));
    } on Object {
      throw const ProgressSyncFailure();
    }
  }

  Future<void> _upsertCloudCompletion(
    String userId,
    ArticleCompletion completion,
  ) async {
    try {
      await _client!.from('user_article_progress').upsert(
        {
          'user_id': userId,
          'article_id': completion.articleId,
          'locale': completion.locale,
          'completed_at': completion.completedAt.toIso8601String(),
          'updated_at': _clock().toUtc().toIso8601String(),
        },
        onConflict: 'user_id,article_id,locale',
      );
    } on Object {
      // Local completion is retained and can be retried during a later sync.
    }
  }

  Future<_StoredProgress> _readLocal(String? userId) async {
    final key = _key(userId);
    final raw = await _storage.read(key: key);
    if (raw == null) return const _StoredProgress();
    try {
      final json = jsonDecode(raw) as Map<String, Object?>;
      return _StoredProgress(
        syncEnabled: json['syncEnabled'] as bool? ?? false,
        syncDisablePending: json['syncDisablePending'] as bool? ?? false,
        historyClearedAt: json['historyClearedAt'] == null
            ? null
            : DateTime.parse(json['historyClearedAt'] as String),
        articles: (json['articles'] as List<Object?>? ?? const [])
            .map((row) => _articleFromJson(
                (row! as Map<Object?, Object?>).cast<String, Object?>()))
            .toList(),
        attempts: (json['attempts'] as List<Object?>? ?? const [])
            .map((row) => _attemptFromJson(
                (row! as Map<Object?, Object?>).cast<String, Object?>()))
            .toList(),
      );
    } on Object {
      await _storage.delete(key: key);
      return const _StoredProgress();
    }
  }

  Future<void> _writeLocal(String? userId, _StoredProgress progress) =>
      _storage.write(key: _key(userId), value: jsonEncode(progress.toJson()));

  String _key(String? userId) => 'learning.progress.${userId ?? 'guest'}';

  ArticleCompletion _articleFromJson(Map<String, Object?> json) =>
      ArticleCompletion(
        articleId: json['articleId']! as String,
        locale: json['locale']! as String,
        completedAt: DateTime.parse(json['completedAt']! as String),
      );

  LearningAttempt _attemptFromJson(Map<String, Object?> json) =>
      LearningAttempt(
        requestId: json['requestId']! as String,
        versionId: json['versionId']! as String,
        locale: json['locale']! as String,
        score: json['score']! as int,
        totalQuestions: json['totalQuestions']! as int,
        completedAt: DateTime.parse(json['completedAt']! as String),
      );

  LearningAttempt _attemptFromRow(Map<String, dynamic> row) => LearningAttempt(
        requestId: row['request_id'] as String,
        versionId: row['version_id'] as String,
        locale: row['locale'] as String,
        score: row['score'] as int,
        totalQuestions: row['total_questions'] as int,
        completedAt: DateTime.parse(row['completed_at'] as String),
      );

  List<LearningAttempt> _deduplicateAttempts(List<LearningAttempt> attempts) {
    final byRequest = <String, LearningAttempt>{};
    for (final attempt in attempts) {
      byRequest.putIfAbsent(attempt.requestId, () => attempt);
    }
    return byRequest.values.toList()
      ..sort((left, right) => right.completedAt.compareTo(left.completedAt));
  }
}

class _StoredProgress {
  const _StoredProgress({
    this.syncEnabled = false,
    this.syncDisablePending = false,
    this.historyClearedAt,
    this.articles = const [],
    this.attempts = const [],
  });

  final bool syncEnabled;
  final bool syncDisablePending;
  final DateTime? historyClearedAt;
  final List<ArticleCompletion> articles;
  final List<LearningAttempt> attempts;

  _StoredProgress copyWith({
    bool? syncEnabled,
    bool? syncDisablePending,
    DateTime? historyClearedAt,
    List<ArticleCompletion>? articles,
    List<LearningAttempt>? attempts,
  }) =>
      _StoredProgress(
        syncEnabled: syncEnabled ?? this.syncEnabled,
        syncDisablePending: syncDisablePending ?? this.syncDisablePending,
        historyClearedAt: historyClearedAt ?? this.historyClearedAt,
        articles: articles ?? this.articles,
        attempts: attempts ?? this.attempts,
      );

  Map<String, Object?> toJson() => {
        'syncEnabled': syncEnabled,
        'syncDisablePending': syncDisablePending,
        'historyClearedAt': historyClearedAt?.toIso8601String(),
        'articles': articles
            .map((item) => {
                  'articleId': item.articleId,
                  'locale': item.locale,
                  'completedAt': item.completedAt.toIso8601String(),
                })
            .toList(),
        'attempts': attempts
            .map((item) => {
                  'requestId': item.requestId,
                  'versionId': item.versionId,
                  'locale': item.locale,
                  'score': item.score,
                  'totalQuestions': item.totalQuestions,
                  'completedAt': item.completedAt.toIso8601String(),
                })
            .toList(),
      };
}
