class OnboardingSurveyAnswers {
  const OnboardingSurveyAnswers({
    required this.ageGroup,
    required this.yearOfStudy,
    required this.disabilityNeed,
    required this.knowsGondarSrh,
    this.completedAt,
  });

  final String ageGroup;
  final String yearOfStudy;
  final String disabilityNeed;
  final String knowsGondarSrh;
  final DateTime? completedAt;

  Map<String, dynamic> toJson() => {
        'ageGroup': ageGroup,
        'yearOfStudy': yearOfStudy,
        'disabilityNeed': disabilityNeed,
        'knowsGondarSrh': knowsGondarSrh,
        'completedAt': (completedAt ?? DateTime.now()).toIso8601String(),
      };

  factory OnboardingSurveyAnswers.fromJson(Map<String, dynamic> json) {
    return OnboardingSurveyAnswers(
      ageGroup: json['ageGroup'] as String? ?? '',
      yearOfStudy: json['yearOfStudy'] as String? ?? '',
      disabilityNeed: json['disabilityNeed'] as String? ?? '',
      knowsGondarSrh: json['knowsGondarSrh'] as String? ?? '',
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
    );
  }
}
