import 'self_assessment_models.dart';

/// The 12 clinically validated, educational self-assessment questions
/// designed for youth and young adults in Ethiopia.
List<SelfAssessmentQuestionItem> getSelfAssessmentQuestions() {
  return [
    SelfAssessmentQuestionItem(
      id: 'q1',
      number: 1,
      textGetter: (l10n) => l10n.assessmentQ1Text,
      whyGetter: (l10n) => l10n.assessmentQ1Why,
      categoryGetter: (l10n) => l10n.categoryPartnersRelationships,
      riskWeight: 2,
    ),
    SelfAssessmentQuestionItem(
      id: 'q2',
      number: 2,
      textGetter: (l10n) => l10n.assessmentQ2Text,
      whyGetter: (l10n) => l10n.assessmentQ2Why,
      categoryGetter: (l10n) => l10n.categoryPartnersRelationships,
      riskWeight: 3,
    ),
    SelfAssessmentQuestionItem(
      id: 'q3',
      number: 3,
      textGetter: (l10n) => l10n.assessmentQ3Text,
      whyGetter: (l10n) => l10n.assessmentQ3Why,
      categoryGetter: (l10n) => l10n.categoryProtectionPractices,
      riskWeight: 3,
    ),
    SelfAssessmentQuestionItem(
      id: 'q4',
      number: 4,
      textGetter: (l10n) => l10n.assessmentQ4Text,
      whyGetter: (l10n) => l10n.assessmentQ4Why,
      categoryGetter: (l10n) => l10n.categoryPartnersRelationships,
      riskWeight: 3,
    ),
    SelfAssessmentQuestionItem(
      id: 'q5',
      number: 5,
      textGetter: (l10n) => l10n.assessmentQ5Text,
      whyGetter: (l10n) => l10n.assessmentQ5Why,
      categoryGetter: (l10n) => l10n.categoryClinicalSymptoms,
      riskWeight: 2,
    ),
    SelfAssessmentQuestionItem(
      id: 'q6',
      number: 6,
      textGetter: (l10n) => l10n.assessmentQ6Text,
      whyGetter: (l10n) => l10n.assessmentQ6Why,
      categoryGetter: (l10n) => l10n.categoryHealthHistory,
      riskWeight: 2,
    ),
    SelfAssessmentQuestionItem(
      id: 'q7',
      number: 7,
      textGetter: (l10n) => l10n.assessmentQ7Text,
      whyGetter: (l10n) => l10n.assessmentQ7Why,
      categoryGetter: (l10n) => l10n.categoryBloodSafety,
      riskWeight: 2,
    ),
    SelfAssessmentQuestionItem(
      id: 'q8',
      number: 8,
      textGetter: (l10n) => l10n.assessmentQ8Text,
      whyGetter: (l10n) => l10n.assessmentQ8Why,
      categoryGetter: (l10n) => l10n.categoryBloodSafety,
      riskWeight: 3,
    ),
    SelfAssessmentQuestionItem(
      id: 'q9',
      number: 9,
      textGetter: (l10n) => l10n.assessmentQ9Text,
      whyGetter: (l10n) => l10n.assessmentQ9Why,
      categoryGetter: (l10n) => l10n.categorySubstanceRisk,
      riskWeight: 2,
    ),
    SelfAssessmentQuestionItem(
      id: 'q10',
      number: 10,
      textGetter: (l10n) => l10n.assessmentQ10Text,
      whyGetter: (l10n) => l10n.assessmentQ10Why,
      categoryGetter: (l10n) => l10n.categorySafetySupport,
      riskWeight: 3,
    ),
    SelfAssessmentQuestionItem(
      id: 'q11',
      number: 11,
      textGetter: (l10n) => l10n.assessmentQ11Text,
      whyGetter: (l10n) => l10n.assessmentQ11Why,
      categoryGetter: (l10n) => l10n.categoryClinicalSymptoms,
      riskWeight: 2,
    ),
    SelfAssessmentQuestionItem(
      id: 'q12',
      number: 12,
      textGetter: (l10n) => l10n.assessmentQ12Text,
      whyGetter: (l10n) => l10n.assessmentQ12Why,
      categoryGetter: (l10n) => l10n.categoryTestingPrevention,
      riskWeight: 2,
    ),
  ];
}
