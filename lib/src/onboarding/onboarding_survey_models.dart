class DynamicSurveyOption {
  const DynamicSurveyOption({
    required this.id,
    required this.value,
    required this.labelEn,
    required this.labelAm,
    this.position = 0,
  });

  final String id;
  final String value;
  final String labelEn;
  final String labelAm;
  final int position;

  String localizedLabel(bool isAmharic) {
    if (isAmharic && labelAm.trim().isNotEmpty) {
      return labelAm;
    }
    return labelEn;
  }

  factory DynamicSurveyOption.fromJson(Map<String, dynamic> json) {
    return DynamicSurveyOption(
      id: json['id'] as String? ?? '',
      value: json['value'] as String? ?? '',
      labelEn: json['labelEn'] as String? ?? '',
      labelAm: json['labelAm'] as String? ?? '',
      position: json['position'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'value': value,
        'labelEn': labelEn,
        'labelAm': labelAm,
        'position': position,
      };
}

class DynamicSurveyQuestion {
  const DynamicSurveyQuestion({
    required this.id,
    required this.titleEn,
    required this.titleAm,
    this.sectionNumber = 1,
    this.sectionKey = 'section_1',
    this.sectionTitleEn = 'Personal and General Information',
    this.sectionTitleAm = 'ክፍል 1፡ አጠቃላይ የግል መረጃ',
    this.moduleKey,
    this.type = 'SINGLE_CHOICE',
    this.position = 0,
    this.isRequired = true,
    this.options = const [],
  });

  final String id;
  final String titleEn;
  final String titleAm;
  final int sectionNumber;
  final String sectionKey;
  final String sectionTitleEn;
  final String sectionTitleAm;
  final String? moduleKey;
  final String type;
  final int position;
  final bool isRequired;
  final List<DynamicSurveyOption> options;

  String localizedTitle(bool isAmharic) {
    if (isAmharic && titleAm.trim().isNotEmpty) {
      return titleAm;
    }
    return titleEn;
  }

  String localizedSectionTitle(bool isAmharic) {
    if (isAmharic && sectionTitleAm.trim().isNotEmpty) {
      return sectionTitleAm;
    }
    return sectionTitleEn;
  }

  factory DynamicSurveyQuestion.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'] as List<dynamic>? ?? [];
    final options = rawOptions
        .map((e) => DynamicSurveyOption.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => a.position.compareTo(b.position));

    return DynamicSurveyQuestion(
      id: json['id'] as String? ?? '',
      titleEn: json['titleEn'] as String? ?? '',
      titleAm: json['titleAm'] as String? ?? '',
      sectionNumber: json['sectionNumber'] as int? ?? 1,
      sectionKey: json['sectionKey'] as String? ?? 'section_1',
      sectionTitleEn: json['sectionTitleEn'] as String? ?? 'Personal and General Information',
      sectionTitleAm: json['sectionTitleAm'] as String? ?? 'ክፍል 1፡ አጠቃላይ የግል መረጃ',
      moduleKey: json['moduleKey'] as String?,
      type: json['type'] as String? ?? 'SINGLE_CHOICE',
      position: json['position'] as int? ?? 0,
      isRequired: json['isRequired'] as bool? ?? true,
      options: options,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'titleEn': titleEn,
        'titleAm': titleAm,
        'sectionNumber': sectionNumber,
        'sectionKey': sectionKey,
        'sectionTitleEn': sectionTitleEn,
        'sectionTitleAm': sectionTitleAm,
        'moduleKey': moduleKey,
        'type': type,
        'position': position,
        'isRequired': isRequired,
        'options': options.map((o) => o.toJson()).toList(),
      };
}

class OnboardingSurveyAnswers {
  const OnboardingSurveyAnswers({
    required this.ageGroup,
    required this.yearOfStudy,
    required this.disabilityNeed,
    required this.knowsGondarSrh,
    this.dynamicAnswers = const {},
    this.completedAt,
  });

  final String ageGroup;
  final String yearOfStudy;
  final String disabilityNeed;
  final String knowsGondarSrh;
  final Map<String, String> dynamicAnswers;
  final DateTime? completedAt;

  Map<String, dynamic> toJson() => {
        'ageGroup': ageGroup,
        'yearOfStudy': yearOfStudy,
        'disabilityNeed': disabilityNeed,
        'knowsGondarSrh': knowsGondarSrh,
        'dynamicAnswers': dynamicAnswers,
        'completedAt': (completedAt ?? DateTime.now()).toIso8601String(),
      };

  factory OnboardingSurveyAnswers.fromJson(Map<String, dynamic> json) {
    final rawDynamic = json['dynamicAnswers'];
    Map<String, String> dynamicMap = {};
    if (rawDynamic is Map) {
      dynamicMap = rawDynamic.map(
        (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
      );
    }

    return OnboardingSurveyAnswers(
      ageGroup: json['ageGroup'] as String? ?? '',
      yearOfStudy: json['yearOfStudy'] as String? ?? '',
      disabilityNeed: json['disabilityNeed'] as String? ?? '',
      knowsGondarSrh: json['knowsGondarSrh'] as String? ?? '',
      dynamicAnswers: dynamicMap,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
    );
  }
}
