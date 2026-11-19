import '../models/learning_progress_models.dart';

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
