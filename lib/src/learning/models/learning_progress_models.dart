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
