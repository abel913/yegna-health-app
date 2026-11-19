import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/learning_progress_models.dart';
import 'learning_progress_store.dart';
import 'progress_local_storage.dart';
import 'progress_sync_helper.dart';

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
    var local = await ProgressLocalStorage.readLocal(_storage, userId);
    var syncEnabled = local.syncEnabled;
    var attempts = local.attempts;
    final client = _client;
    if (userId != null && client != null) {
      try {
        final prefResult = await ProgressSyncHelper.syncPreferences(
          client: client,
          userId: userId,
          local: local,
          now: _clock(),
        );
        local = prefResult.local;
        syncEnabled = prefResult.syncEnabled;
        await ProgressLocalStorage.writeLocal(_storage, userId, local);

        if (syncEnabled) {
          await ProgressSyncHelper.syncLocalArticlesToCloud(
            client: client,
            userId: userId,
            local: local,
            now: _clock(),
          );
          final merged = await ProgressSyncHelper.fetchMergedArticles(
            client: client,
            userId: userId,
            localArticles: local.articles,
          );
          local = local.copyWith(articles: merged);
          await ProgressLocalStorage.writeLocal(_storage, userId, local);
          final cloudAttempts = await ProgressSyncHelper.fetchCloudAttempts(
            client: client,
            userId: userId,
          );
          attempts = [...local.attempts, ...cloudAttempts];
        }
      } on Object {
        // Keep the locally protected progress usable if the connection is offline.
      }
    }
    return LearningProgress(
      syncEnabled: syncEnabled,
      articles: local.articles,
      attempts: ProgressLocalStorage.deduplicateAttempts(attempts),
    );
  }

  @override
  Future<bool> setSyncEnabled(String? userId, bool enabled) async {
    final client = _client;
    if (userId == null || client == null) throw const ProgressSyncFailure();
    var local = await ProgressLocalStorage.readLocal(_storage, userId);
    if (!enabled) {
      await ProgressLocalStorage.writeLocal(
        _storage,
        userId,
        local.copyWith(syncEnabled: false, syncDisablePending: true),
      );
      try {
        await ProgressSyncHelper.setPreferenceSync(
          client: client,
          userId: userId,
          enabled: false,
          now: _clock(),
        );
        await ProgressLocalStorage.writeLocal(
          _storage,
          userId,
          local.copyWith(syncEnabled: false, syncDisablePending: false),
        );
        return true;
      } on Object {
        throw const ProgressSyncFailure();
      }
    }

    try {
      await ProgressSyncHelper.setPreferenceSync(
        client: client,
        userId: userId,
        enabled: true,
        now: _clock(),
      );
      local = local.copyWith(syncEnabled: true);
      await ProgressLocalStorage.writeLocal(_storage, userId, local);
      await ProgressSyncHelper.syncLocalArticlesToCloud(
        client: client,
        userId: userId,
        local: local,
        now: _clock(),
      );
      return true;
    } on Object {
      await ProgressLocalStorage.writeLocal(
        _storage,
        userId,
        local.copyWith(syncEnabled: false),
      );
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
    final current = await ProgressLocalStorage.readLocal(_storage, userId);
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
    await ProgressLocalStorage.writeLocal(
      _storage,
      userId,
      current.copyWith(articles: articles),
    );
    final client = _client;
    if (userId != null && syncPreference && client != null) {
      await ProgressSyncHelper.upsertCloudCompletion(
        client,
        userId,
        completion,
        _clock(),
      );
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
    final current = await ProgressLocalStorage.readLocal(_storage, userId);
    final attempt = LearningAttempt(
      requestId: requestId,
      versionId: versionId,
      locale: locale,
      score: score,
      totalQuestions: totalQuestions,
      completedAt: _clock().toUtc(),
    );
    final attempts = ProgressLocalStorage.deduplicateAttempts(
      [...current.attempts, attempt],
    );
    await ProgressLocalStorage.writeLocal(
      _storage,
      userId,
      current.copyWith(attempts: attempts),
    );
  }

  @override
  Future<void> clearSynchronizedHistory(String userId) async {
    await ProgressSyncHelper.clearCloudHistory(
      client: _client,
      storage: _storage,
      userId: userId,
      now: _clock(),
    );
  }
}
