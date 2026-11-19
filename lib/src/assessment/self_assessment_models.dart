import '../../l10n/app_localizations.dart';
export 'default_self_assessment_questions.dart' show getSelfAssessmentQuestions;

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
