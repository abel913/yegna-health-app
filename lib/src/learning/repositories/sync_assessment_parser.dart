import '../../content/content_templates.dart';
import '../models/assessment_models.dart';

class SyncAssessmentParser {
  const SyncAssessmentParser._();

  static List<AssessmentSummary> defaultSummaries(String locale, bool isAmharic) {
    return [
      AssessmentSummary(
        id: 'assessment_puberty',
        versionId: 'ver_puberty_v1',
        slug: 'puberty-knowledge',
        locale: locale,
        title: isAmharic ? 'የጉርምስና እውቀት ምዘና' : 'Puberty & Growth Quiz',
        description: isAmharic
            ? 'ስለ ጉርምስና አካላዊ እና ሆርሞናዊ ለውጦች ግንዛቤዎን ይፈትሹ።'
            : 'Test your understanding of adolescent changes and emotional wellness.',
        version: 1,
      ),
      AssessmentSummary(
        id: 'assessment_srh',
        versionId: 'ver_srh_v1',
        slug: 'srh-safety',
        locale: locale,
        title: isAmharic ? 'የስነ-ተዋልዶ ጤና ግንዛቤ' : 'Reproductive Health Assessment',
        description: isAmharic
            ? 'ስለ ጤናማ ግንኙነት፣ የአባለዘር በሽታዎች እና መከላከያ ዘዴዎች።'
            : 'Evaluate your knowledge on healthy relationships and prevention.',
        version: 1,
      ),
    ];
  }

  static List<AssessmentQuestion> parseQuestions(
    List<Map<String, dynamic>> rawQuizzes,
    bool isAmharic,
  ) {
    final questions = <AssessmentQuestion>[];

    for (final q in rawQuizzes) {
      final qId = q['id']?.toString() ?? 'q_0';
      final prompt = isAmharic
          ? (q['questionAm'] as String? ?? q['questionEn'] as String? ?? '')
          : (q['questionEn'] as String? ?? '');
      final optionsRaw = isAmharic
          ? (q['optionsAm'] as List<dynamic>? ??
              q['optionsEn'] as List<dynamic>? ??
              [])
          : (q['optionsEn'] as List<dynamic>? ?? []);

      final options = <AssessmentOption>[];
      for (int i = 0; i < optionsRaw.length; i++) {
        options.add(AssessmentOption(
          id: 'opt_$i',
          label: optionsRaw[i].toString(),
        ));
      }

      if (prompt.isNotEmpty && options.isNotEmpty) {
        questions.add(AssessmentQuestion(
          id: qId,
          prompt: prompt,
          options: options,
        ));
      }
    }

    if (questions.isEmpty) {
      for (final tq in ContentTemplates.questionTemplates) {
        final prompt = isAmharic ? tq.promptAm : tq.promptEn;
        final options = tq.options
            .map((o) => AssessmentOption(
                  id: o.id,
                  label: isAmharic ? o.labelAm : o.labelEn,
                ))
            .toList();
        questions.add(AssessmentQuestion(
          id: tq.id,
          prompt: prompt,
          options: options,
        ));
      }
    }

    return questions;
  }
}
