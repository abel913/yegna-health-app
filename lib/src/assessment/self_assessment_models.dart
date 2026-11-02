import '../../l10n/app_localizations.dart';

enum RiskTier {
  lowerRisk,
  moderateRisk,
  higherRisk,
}

class SelfAssessmentQuestionItem {
  const SelfAssessmentQuestionItem({
    required this.id,
    required this.number,
    required this.textGetter,
    required this.whyGetter,
    required this.categoryGetter,
    required this.riskWeight,
    this.affirmativeIsRisk = true,
  });

  final String id;
  final int number;
  final String Function(AppLocalizations l10n) textGetter;
  final String Function(AppLocalizations l10n) whyGetter;
  final String Function(AppLocalizations l10n) categoryGetter;
  final int riskWeight;
  final bool affirmativeIsRisk;

  String title(AppLocalizations l10n) => textGetter(l10n);
  String why(AppLocalizations l10n) => whyGetter(l10n);
  String category(AppLocalizations l10n) => categoryGetter(l10n);
}

class SelfAssessmentEvaluation {
  const SelfAssessmentEvaluation({
    required this.score,
    required this.maxScore,
    required this.tier,
    required this.answeredYesCount,
    required this.answeredNoCount,
    required this.totalQuestions,
  });

  final int score;
  final int maxScore;
  final RiskTier tier;
  final int answeredYesCount;
  final int answeredNoCount;
  final int totalQuestions;

  double get scoreRatio =>
      maxScore > 0 ? (score / maxScore).clamp(0.0, 1.0) : 0.0;
  int get scorePercent => (scoreRatio * 100).round();
}

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

SelfAssessmentEvaluation evaluateAssessment(
  List<SelfAssessmentQuestionItem> questions,
  Map<String, bool> answers,
) {
  int totalScore = 0;
  int maxPossibleScore = 0;
  int yesCount = 0;
  int noCount = 0;
  bool hasHighImpactExposure = false;

  for (final q in questions) {
    maxPossibleScore += q.riskWeight;
    final answered = answers[q.id];
    if (answered != null) {
      if (answered) {
        yesCount++;
        totalScore += q.riskWeight;
        // High impact triggers (e.g. sharing needles, transactional sex, forced sexual contact)
        if (q.id == 'q2' || q.id == 'q8' || q.id == 'q10') {
          hasHighImpactExposure = true;
        }
      } else {
        noCount++;
      }
    }
  }

  final RiskTier tier;
  if (totalScore == 0) {
    tier = RiskTier.lowerRisk;
  } else if (totalScore >= 6 || hasHighImpactExposure) {
    tier = RiskTier.higherRisk;
  } else {
    tier = RiskTier.moderateRisk;
  }

  return SelfAssessmentEvaluation(
    score: totalScore,
    maxScore: maxPossibleScore,
    tier: tier,
    answeredYesCount: yesCount,
    answeredNoCount: noCount,
    totalQuestions: questions.length,
  );
}
