/// Clinical risk/evaluation tier for self-assessment outcomes.
enum AssessmentRiskTier {
  higherRisk,
  moderateRisk,
  lowerRisk,
  infoOnly,
}

/// Structured assessment result data matching clinical counseling standards.
class AssessmentResultData {
  const AssessmentResultData({
    required this.sectionNumber,
    required this.sectionTitleEn,
    required this.sectionTitleAm,
    required this.headlineEn,
    required this.headlineAm,
    required this.tier,
    required this.actionsEn,
    required this.actionsAm,
    required this.keyMessageEn,
    required this.keyMessageAm,
  });

  final int sectionNumber;
  final String sectionTitleEn;
  final String sectionTitleAm;
  final String headlineEn;
  final String headlineAm;
  final AssessmentRiskTier tier;
  final List<String> actionsEn;
  final List<String> actionsAm;
  final String keyMessageEn;
  final String keyMessageAm;

  String localizedHeadline(bool isAmharic) =>
      isAmharic && headlineAm.isNotEmpty ? headlineAm : headlineEn;

  List<String> localizedActions(bool isAmharic) =>
      isAmharic && actionsAm.isNotEmpty ? actionsAm : actionsEn;

  String localizedKeyMessage(bool isAmharic) =>
      isAmharic && keyMessageAm.isNotEmpty ? keyMessageAm : keyMessageEn;
}
