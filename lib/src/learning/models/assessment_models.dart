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

  int get percentage =>
      totalQuestions == 0 ? 0 : score * 100 ~/ totalQuestions;
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
