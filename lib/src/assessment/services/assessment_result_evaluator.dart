import '../models/assessment_result_data.dart';
import 'assessment_sections_result_data.dart';

/// Clinical evaluation service that produces personalized result counseling.
class AssessmentResultEvaluator {
  const AssessmentResultEvaluator._();

  static AssessmentResultData evaluate({
    required int sectionNumber,
    required String sectionTitleEn,
    required String sectionTitleAm,
    required Map<String, String> answers,
  }) {
    final yesCount = answers.values.where((v) {
      final val = v.toUpperCase();
      return val == 'YES' || val.contains('OFTEN') || val.contains('ALWAYS');
    }).length;

    final tier = _calculateTier(sectionNumber, yesCount, answers.length);

    switch (sectionNumber) {
      case 2:
        return AssessmentSectionsResultData.section2(sectionTitleEn, sectionTitleAm, tier);
      case 3:
        return AssessmentSectionsResultData.section3(sectionTitleEn, sectionTitleAm, tier);
      case 4:
        return AssessmentSectionsResultData.section4(sectionTitleEn, sectionTitleAm, tier);
      case 5:
        return AssessmentSectionsResultData.section5(sectionTitleEn, sectionTitleAm, tier);
      case 6:
        return AssessmentSectionsResultData.section6(sectionTitleEn, sectionTitleAm, tier);
      case 7:
        return AssessmentSectionsResultData.section7(sectionTitleEn, sectionTitleAm, tier);
      case 8:
        return AssessmentSectionsResultData.section8(sectionTitleEn, sectionTitleAm, tier);
      default:
        return AssessmentSectionsResultData.fallback(sectionNumber, sectionTitleEn, sectionTitleAm, tier);
    }
  }

  static AssessmentRiskTier _calculateTier(int sectionNumber, int yesCount, int totalAnswered) {
    if (yesCount >= 3) return AssessmentRiskTier.higherRisk;
    if (yesCount >= 1) return AssessmentRiskTier.moderateRisk;
    return AssessmentRiskTier.lowerRisk;
  }
}
