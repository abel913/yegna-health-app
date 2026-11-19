import '../models/learning_progress_models.dart';

class StoredProgress {
  const StoredProgress({
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

  StoredProgress copyWith({
    bool? syncEnabled,
    bool? syncDisablePending,
    DateTime? historyClearedAt,
    List<ArticleCompletion>? articles,
    List<LearningAttempt>? attempts,
  }) =>
      StoredProgress(
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
