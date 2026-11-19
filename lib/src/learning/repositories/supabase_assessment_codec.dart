import '../models/assessment_models.dart';

class SupabaseAssessmentCodec {
  const SupabaseAssessmentCodec._();

  static AssessmentSummary parseSummary({
    required Map<String, dynamic> versionRow,
    required String versionId,
    required String locale,
  }) {
    final version = versionRow['version'] as Map<String, dynamic>;
    final assessmentInfo = version['assessment'] as Map<String, dynamic>;
    return AssessmentSummary(
      id: assessmentInfo['id'] as String,
      versionId: versionId,
      slug: assessmentInfo['slug'] as String,
      locale: locale,
      title: versionRow['title'] as String,
      description: versionRow['description'] as String? ?? '',
      version: version['version'] as int,
    );
  }

  static List<AssessmentQuestion> parseQuestions(List<dynamic> questionRows) {
    return questionRows.map((row) {
      final translations = row['translations'] as List<dynamic>;
      final options = row['options'] as List<dynamic>;
      return AssessmentQuestion(
        id: row['id'] as String,
        prompt: (translations.first as Map<String, dynamic>)['prompt'] as String,
        options: options.map((option) {
          final optionTranslations = option['translations'] as List<dynamic>;
          return AssessmentOption(
            id: option['id'] as String,
            label: (optionTranslations.first
                as Map<String, dynamic>)['label'] as String,
          );
        }).toList(growable: false),
      );
    }).toList(growable: false);
  }

  static Map<String, Object?> assessmentToJson(Assessment assessment) => {
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
                      .map((option) =>
                          {'id': option.id, 'label': option.label})
                      .toList(),
                })
            .toList(),
      };

  static Assessment assessmentFromJson(Map<String, Object?> json) {
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

  static AssessmentResult resultFromJson(
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
