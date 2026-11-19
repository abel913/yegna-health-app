import 'package:flutter/material.dart';

/// Metadata representing an official University of Gondar assessment section.
class UogAssessmentSectionMeta {
  const UogAssessmentSectionMeta({
    required this.number,
    required this.sectionKey,
    required this.moduleKey,
    required this.titleEn,
    required this.titleAm,
    required this.descriptionEn,
    required this.descriptionAm,
    required this.questionRangeEn,
    required this.questionRangeAm,
    required this.questionCount,
    required this.icon,
    required this.color,
  });

  final int number;
  final String sectionKey;
  final String moduleKey;
  final String titleEn;
  final String titleAm;
  final String descriptionEn;
  final String descriptionAm;
  final String questionRangeEn;
  final String questionRangeAm;
  final int questionCount;
  final IconData icon;
  final Color color;
}

/// The 8 canonical assessment sections designed by UoG Directorate of Gender & Social Inclusion.
const List<UogAssessmentSectionMeta> kUogSections = [
  UogAssessmentSectionMeta(
    number: 1,
    sectionKey: 'section_1',
    moduleKey: 'general',
    titleEn: 'Personal and General Information',
    titleAm: 'አጠቃላይ የግል መረጃ',
    descriptionEn: 'Demographics, year of study, accessibility needs, and SRH awareness.',
    descriptionAm: 'ዕድሜ፣ የትምህርት ዓመት፣ የተደራሽነት ፍላጎት እና የአገልግሎት ግንዛቤ።',
    questionRangeEn: 'Q.01–Q.04',
    questionRangeAm: 'ጥያቄ 01–04',
    questionCount: 4,
    icon: Icons.person_pin_rounded,
    color: Color(0xFF0F766E),
  ),
  UogAssessmentSectionMeta(
    number: 2,
    sectionKey: 'section_2',
    moduleKey: 'srh',
    titleEn: 'Sexual Behaviour and Health Risks',
    titleAm: 'የጾታዊ ባህሪ እና የጤና ተጋላጭነት',
    descriptionEn: 'Sexual activity, partner history, protection consistency, and risk factors.',
    descriptionAm: 'የጾታዊ ግንኙነት ልምድ፣ ጥንቃቄ እና የተጋላጭነት ሁኔታዎች።',
    questionRangeEn: 'Q.05–Q.12',
    questionRangeAm: 'ጥያቄ 05–12',
    questionCount: 8,
    icon: Icons.health_and_safety_rounded,
    color: Color(0xFF0284C7),
  ),
  UogAssessmentSectionMeta(
    number: 3,
    sectionKey: 'section_3',
    moduleKey: 'hiv',
    titleEn: 'HIV and STIs Self-Assessment',
    titleAm: 'የኤችአይቪ እና አባለዘር በሽታዎች ምዘና',
    descriptionEn: 'Testing history, symptoms, perceived risk, and partner notification.',
    descriptionAm: 'የምርመራ ታሪክ፣ ምልክቶች፣ ተጋላጭነት እና የትዳር አጋር ማሳወቅ።',
    questionRangeEn: 'Q.13–Q.20',
    questionRangeAm: 'ጥያቄ 13–20',
    questionCount: 8,
    icon: Icons.coronavirus_rounded,
    color: Color(0xFFE11D48),
  ),
  UogAssessmentSectionMeta(
    number: 4,
    sectionKey: 'section_4',
    moduleKey: 'contraception',
    titleEn: 'Contraception and Family Planning',
    titleAm: 'የእርግዝና መከላከያ እና የቤተሰብ እቅድ',
    descriptionEn: 'Method utilization, emergency contraception, and pregnancy history.',
    descriptionAm: 'የመከላከያ ዘዴዎች አጠቃቀም፣ የአደጋ ጊዜ መከላከያ እና የእርግዝና ሁኔታ።',
    questionRangeEn: 'Q.21–Q.26',
    questionRangeAm: 'ጥያቄ 21–26',
    questionCount: 6,
    icon: Icons.favorite_rounded,
    color: Color(0xFF7C3AED),
  ),
  UogAssessmentSectionMeta(
    number: 5,
    sectionKey: 'section_5',
    moduleKey: 'puberty',
    titleEn: 'Menstrual and Reproductive Health',
    titleAm: 'የወር አበባ እና ስነ-ተዋልዶ ጤና',
    descriptionEn: 'Menstrual regularity, severe pain, product access, and private facilities.',
    descriptionAm: 'የወር አበባ ዑደት፣ ህመም፣ የንጽህና መጠበቂያ ቁሳቁሶች እና ምቹ ቦታዎች።',
    questionRangeEn: 'Q.27–Q.34',
    questionRangeAm: 'ጥያቄ 27–34',
    questionCount: 8,
    icon: Icons.water_drop_rounded,
    color: Color(0xFFD97706),
  ),
  UogAssessmentSectionMeta(
    number: 6,
    sectionKey: 'section_6',
    moduleKey: 'gbv',
    titleEn: 'Gender-Based Violence (GBV) and Safety',
    titleAm: 'ጾታ-ተኮር ጥቃት እና ደህንነት',
    descriptionEn: 'Harassment experience, consent understanding, campus safety, and reporting.',
    descriptionAm: 'የትንኮሳ ተሞክሮ፣ የስምምነት ግንዛቤ፣ የግቢው ደህንነት እና ሪፖርት የማድረግ ሂደት።',
    questionRangeEn: 'Q.35–Q.42',
    questionRangeAm: 'ጥያቄ 35–42',
    questionCount: 8,
    icon: Icons.shield_rounded,
    color: Color(0xFFDC2626),
  ),
  UogAssessmentSectionMeta(
    number: 7,
    sectionKey: 'section_7',
    moduleKey: 'mental_health',
    titleEn: 'Mental and Emotional Health Screening',
    titleAm: 'ስነ-ልቦናዊ እና አእምሮአዊ ጤና',
    descriptionEn: 'Depression screen, academic stress, loneliness, and substance use.',
    descriptionAm: 'ድብርት፣ የትምህርት ጭንቀት፣ የብቸኝነት ስሜት እና የሱስ አጠቃቀም።',
    questionRangeEn: 'Q.43–Q.47',
    questionRangeAm: 'ጥያቄ 43–47',
    questionCount: 5,
    icon: Icons.psychology_rounded,
    color: Color(0xFF4F46E5),
  ),
  UogAssessmentSectionMeta(
    number: 8,
    sectionKey: 'section_8',
    moduleKey: 'services',
    titleEn: 'Campus Health Services & Clinic Utilization',
    titleAm: 'የግቢው ጤና አገልግሎት እና ተጠቃሚነት',
    descriptionEn: 'Clinic visits, service satisfaction, provider attitude, and barriers.',
    descriptionAm: 'የክሊኒክ ጉብኝት፣ እርካታ፣ የአገልግሎት ሰጪዎች አቀራረብ እና ተግዳሮቶች።',
    questionRangeEn: 'Q.48–Q.50',
    questionRangeAm: 'ጥያቄ 48–50',
    questionCount: 3,
    icon: Icons.support_agent_rounded,
    color: Color(0xFF059669),
  ),
];
