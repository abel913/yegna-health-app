class LearningCategory {
  const LearningCategory({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.sortOrder,
  });

  final String id;
  final String slug;
  final String name;
  final String description;
  final int sortOrder;
}

class ArticlePreview {
  const ArticlePreview({
    required this.id,
    required this.slug,
    required this.categoryId,
    required this.locale,
    required this.title,
    required this.summary,
  });
  final String id;
  final String slug;
  final String categoryId;
  final String locale;
  final String title;
  final String summary;
}

class ArticleSource {
  const ArticleSource({
    required this.citationTitle,
    required this.publisher,
    this.url,
    this.identifier,
  });

  final String citationTitle;
  final String publisher;
  final String? url;
  final String? identifier;
}

class RelatedArticle {
  const RelatedArticle({required this.id, required this.title});

  final String id;
  final String title;
}

class EducationArticle {
  const EducationArticle({
    required this.id,
    required this.slug,
    required this.categoryId,
    required this.locale,
    required this.title,
    required this.summary,
    required this.bodyMarkdown,
    required this.reviewedAt,
    required this.reviewDueAt,
    this.sources = const [],
    this.relatedArticles = const [],
  });

  final String id;
  final String slug;
  final String categoryId;
  final String locale;
  final String title;
  final String summary;
  final String bodyMarkdown;
  final DateTime reviewedAt;
  final DateTime reviewDueAt;
  final List<ArticleSource> sources;
  final List<RelatedArticle> relatedArticles;

  Map<String, Object?> toJson() => {
        'id': id,
        'slug': slug,
        'categoryId': categoryId,
        'locale': locale,
        'title': title,
        'summary': summary,
        'bodyMarkdown': bodyMarkdown,
        'reviewedAt': reviewedAt.toIso8601String(),
        'reviewDueAt': reviewDueAt.toIso8601String(),
        'sources': sources
            .map((source) => {
                  'citationTitle': source.citationTitle,
                  'publisher': source.publisher,
                  'url': source.url,
                  'identifier': source.identifier,
                })
            .toList(),
        'relatedArticles': relatedArticles
            .map((article) => {'id': article.id, 'title': article.title})
            .toList(),
      };

  factory EducationArticle.fromJson(Map<String, Object?> json) {
    final sourceRows = json['sources'] as List<Object?>? ?? const [];
    return EducationArticle(
      id: json['id']! as String,
      slug: json['slug']! as String,
      categoryId: json['categoryId']! as String,
      locale: json['locale']! as String,
      title: json['title']! as String,
      summary: json['summary'] as String? ?? '',
      bodyMarkdown: json['bodyMarkdown']! as String,
      reviewedAt: DateTime.parse(json['reviewedAt']! as String),
      reviewDueAt: DateTime.parse(json['reviewDueAt']! as String),
      sources: sourceRows
          .map((row) => row! as Map<String, Object?>)
          .map((row) => ArticleSource(
                citationTitle: row['citationTitle']! as String,
                publisher: row['publisher']! as String,
                url: row['url'] as String?,
                identifier: row['identifier'] as String?,
              ))
          .toList(growable: false),
      relatedArticles:
          (json['relatedArticles'] as List<Object?>? ?? const []).map((row) {
        final article = (row! as Map<Object?, Object?>).cast<String, Object?>();
        return RelatedArticle(
          id: article['id']! as String,
          title: article['title']! as String,
        );
      }).toList(growable: false),
    );
  }
}

class AssessmentSummary {
  const AssessmentSummary({
    required this.id,
    required this.versionId,
    required this.slug,
    required this.locale,
    required this.title,
    required this.description,
    required this.version,
  });

  final String id;
  final String versionId;
  final String slug;
  final String locale;
  final String title;
  final String description;
  final int version;
}

class AssessmentOption {
  const AssessmentOption({required this.id, required this.label});
  final String id;
  final String label;
}

class AssessmentQuestion {
  const AssessmentQuestion({
    required this.id,
    required this.prompt,
    required this.options,
  });
  final String id;
  final String prompt;
  final List<AssessmentOption> options;
}

class Assessment {
  const Assessment({
    required this.summary,
    required this.questions,
  });
  final AssessmentSummary summary;
  final List<AssessmentQuestion> questions;
}

class QuestionResult {
  const QuestionResult({
    required this.questionId,
    required this.selectedOptionId,
    required this.correctOptionId,
    required this.isCorrect,
    required this.explanation,
  });
  final String questionId;
  final String selectedOptionId;
  final String correctOptionId;
  final bool isCorrect;
  final String explanation;
}

class AssessmentResult {
  const AssessmentResult({
    required this.score,
    required this.totalQuestions,
    required this.details,
    required this.synchronized,
  });
  final int score;
  final int totalQuestions;
  final List<QuestionResult> details;
  final bool synchronized;

  int get percentage => totalQuestions == 0 ? 0 : score * 100 ~/ totalQuestions;
}

class PendingAssessmentSubmission {
  const PendingAssessmentSubmission({
    required this.requestId,
    required this.versionId,
    required this.locale,
    required this.answers,
    required this.syncProgress,
  });

  final String requestId;
  final String versionId;
  final String locale;
  final List<Map<String, String>> answers;
  final bool syncProgress;

  Map<String, Object?> toJson() => {
        'requestId': requestId,
        'versionId': versionId,
        'locale': locale,
        'answers': answers,
        'syncProgress': syncProgress,
      };

  factory PendingAssessmentSubmission.fromJson(Map<String, Object?> json) =>
      PendingAssessmentSubmission(
        requestId: json['requestId']! as String,
        versionId: json['versionId']! as String,
        locale: json['locale']! as String,
        answers: (json['answers']! as List<Object?>)
            .map((row) => (row! as Map<String, Object?>).cast<String, String>())
            .toList(growable: false),
        syncProgress: json['syncProgress']! as bool,
      );
}

class CachedValue<T> {
  const CachedValue({
    required this.value,
    required this.isStale,
    this.fetchedAt,
  });
  final T value;
  final bool isStale;
  final DateTime? fetchedAt;
}
