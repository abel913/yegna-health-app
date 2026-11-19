import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/learning_progress_models.dart';
import 'stored_progress_entity.dart';

class ProgressLocalStorage {
  const ProgressLocalStorage._();

  static String key(String? userId) =>
      'learning.progress.${userId ?? 'guest'}';

  static Future<StoredProgress> readLocal(
    FlutterSecureStorage storage,
    String? userId,
  ) async {
    final k = key(userId);
    final raw = await storage.read(key: k);
    if (raw == null) return const StoredProgress();
    try {
      final json = jsonDecode(raw) as Map<String, Object?>;
      return StoredProgress(
        syncEnabled: json['syncEnabled'] as bool? ?? false,
        syncDisablePending: json['syncDisablePending'] as bool? ?? false,
        historyClearedAt: json['historyClearedAt'] == null
            ? null
            : DateTime.parse(json['historyClearedAt'] as String),
        articles: (json['articles'] as List<Object?>? ?? const [])
            .map((row) => articleFromJson(
                (row! as Map<Object?, Object?>).cast<String, Object?>()))
            .toList(),
        attempts: (json['attempts'] as List<Object?>? ?? const [])
            .map((row) => attemptFromJson(
                (row! as Map<Object?, Object?>).cast<String, Object?>()))
            .toList(),
      );
    } on Object {
      await storage.delete(key: k);
      return const StoredProgress();
    }
  }

  static Future<void> writeLocal(
    FlutterSecureStorage storage,
    String? userId,
    StoredProgress progress,
  ) =>
      storage.write(key: key(userId), value: jsonEncode(progress.toJson()));

  static ArticleCompletion articleFromJson(Map<String, Object?> json) =>
      ArticleCompletion(
        articleId: json['articleId']! as String,
        locale: json['locale']! as String,
        completedAt: DateTime.parse(json['completedAt']! as String),
      );

  static LearningAttempt attemptFromJson(Map<String, Object?> json) =>
      LearningAttempt(
        requestId: json['requestId']! as String,
        versionId: json['versionId']! as String,
        locale: json['locale']! as String,
        score: json['score']! as int,
        totalQuestions: json['totalQuestions']! as int,
        completedAt: DateTime.parse(json['completedAt']! as String),
      );

  static LearningAttempt attemptFromRow(Map<String, dynamic> row) =>
      LearningAttempt(
        requestId: row['request_id'] as String,
        versionId: row['version_id'] as String,
        locale: row['locale'] as String,
        score: row['score'] as int,
        totalQuestions: row['total_questions'] as int,
        completedAt: DateTime.parse(row['completed_at'] as String),
      );

  static List<LearningAttempt> deduplicateAttempts(
      List<LearningAttempt> attempts) {
    final byRequest = <String, LearningAttempt>{};
    for (final attempt in attempts) {
      byRequest.putIfAbsent(attempt.requestId, () => attempt);
    }
    return byRequest.values.toList()
      ..sort((left, right) => right.completedAt.compareTo(left.completedAt));
  }
}
