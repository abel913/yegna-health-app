import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/learning_progress_models.dart';
import 'progress_local_storage.dart';
import 'stored_progress_entity.dart';

class ProgressSyncHelper {
  const ProgressSyncHelper._();

  static Future<void> upsertCloudCompletion(
    SupabaseClient client,
    String userId,
    ArticleCompletion completion,
    DateTime now,
  ) async {
    try {
      await client.from('user_article_progress').upsert(
        {
          'user_id': userId,
          'article_id': completion.articleId,
          'locale': completion.locale,
          'completed_at': completion.completedAt.toIso8601String(),
          'updated_at': now.toUtc().toIso8601String(),
        },
        onConflict: 'user_id,article_id,locale',
      );
    } on Object {
      // Retained locally
    }
  }

  static Future<void> syncLocalArticlesToCloud({
    required SupabaseClient client,
    required String userId,
    required StoredProgress local,
    required DateTime now,
  }) async {
    for (final completion in local.articles) {
      if (local.historyClearedAt == null ||
          completion.completedAt.isAfter(local.historyClearedAt!)) {
        await upsertCloudCompletion(client, userId, completion, now);
      }
    }
  }

  static Future<List<ArticleCompletion>> fetchMergedArticles({
    required SupabaseClient client,
    required String userId,
    required List<ArticleCompletion> localArticles,
  }) async {
    final cloudArticles = await client
        .from('user_article_progress')
        .select('article_id,locale,completed_at')
        .eq('user_id', userId)
        .order('completed_at', ascending: false)
        .limit(500);

    final articlesByKey = <String, ArticleCompletion>{
      for (final completion in localArticles)
        '${completion.articleId}:${completion.locale}': completion,
      for (final row in cloudArticles)
        '${row['article_id']}:${row['locale']}': ArticleCompletion(
          articleId: row['article_id'] as String,
          locale: row['locale'] as String,
          completedAt: DateTime.parse(row['completed_at'] as String),
        ),
    };
    return articlesByKey.values.toList();
  }

  static Future<List<LearningAttempt>> fetchCloudAttempts({
    required SupabaseClient client,
    required String userId,
  }) async {
    final cloudAttempts = await client
        .from('user_assessment_attempts')
        .select('request_id,version_id,locale,score,total_questions,completed_at')
        .eq('user_id', userId)
        .order('completed_at', ascending: false)
        .limit(100);

    return cloudAttempts.map(ProgressLocalStorage.attemptFromRow).toList();
  }

  static Future<void> setPreferenceSync({
    required SupabaseClient client,
    required String userId,
    required bool enabled,
    required DateTime now,
  }) async {
    await client.from('user_learning_preferences').upsert({
      'user_id': userId,
      'sync_enabled': enabled,
      'updated_at': now.toUtc().toIso8601String(),
    });
  }

  static Future<({StoredProgress local, bool syncEnabled})> syncPreferences({
    required SupabaseClient client,
    required String userId,
    required StoredProgress local,
    required DateTime now,
  }) async {
    var updated = local;
    if (updated.syncDisablePending) {
      await setPreferenceSync(
        client: client,
        userId: userId,
        enabled: false,
        now: now,
      );
      updated = updated.copyWith(syncDisablePending: false);
    }
    final preference = await client
        .from('user_learning_preferences')
        .select('sync_enabled,history_cleared_at')
        .eq('user_id', userId)
        .maybeSingle();

    final syncEnabled = updated.syncDisablePending
        ? false
        : preference?['sync_enabled'] as bool? ?? false;
    final rawClearedAt = preference?['history_cleared_at'] as String?;
    final clearedAt =
        rawClearedAt == null ? null : DateTime.parse(rawClearedAt);

    updated = updated.copyWith(
      syncEnabled: syncEnabled,
      historyClearedAt: clearedAt,
    );
    return (local: updated, syncEnabled: syncEnabled);
  }

  static Future<void> clearCloudHistory({
    required SupabaseClient? client,
    required FlutterSecureStorage storage,
    required String userId,
    required DateTime now,
  }) async {
    if (client == null) throw const ProgressSyncFailure();
    try {
      await client.rpc('clear_my_learning_history');
      final local = await ProgressLocalStorage.readLocal(storage, userId);
      await ProgressLocalStorage.writeLocal(
        storage,
        userId,
        local.copyWith(historyClearedAt: now.toUtc()),
      );
    } on Object {
      throw const ProgressSyncFailure();
    }
  }
}
