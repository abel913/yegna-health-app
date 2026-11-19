import 'onboarding_survey_models.dart';

/// Default baseline questions providing offline fallback resilience for student onboarding.
class DefaultSurveyQuestions {
  static const List<DynamicSurveyQuestion> list = [
    DynamicSurveyQuestion(
      id: 'default_age',
      titleEn: 'What is your age?',
      titleAm: 'ዕድሜዎ ስንት ነው?',
      position: 1,
      isRequired: true,
      options: [
        DynamicSurveyOption(id: 'age_1', value: '18–20', labelEn: '18–20', labelAm: '18–20', position: 1),
        DynamicSurveyOption(id: 'age_2', value: '21–24', labelEn: '21–24', labelAm: '21–24', position: 2),
        DynamicSurveyOption(id: 'age_3', value: '25–29', labelEn: '25–29', labelAm: '25–29', position: 3),
        DynamicSurveyOption(id: 'age_4', value: '30 and above', labelEn: '30 and above', labelAm: '30 እና ከዚያ በላይ', position: 4),
      ],
    ),
    DynamicSurveyQuestion(
      id: 'default_year',
      titleEn: 'What is your current year of study?',
      titleAm: 'በምን ዓመት የትምህርት ደረጃ ላይ ይገኛሉ?',
      position: 2,
      isRequired: true,
      options: [
        DynamicSurveyOption(id: 'yr_1', value: '1st Year', labelEn: '1st Year', labelAm: '1ኛ ዓመት', position: 1),
        DynamicSurveyOption(id: 'yr_2', value: '2nd Year', labelEn: '2nd Year', labelAm: '2ኛ ዓመት', position: 2),
        DynamicSurveyOption(id: 'yr_3', value: '3rd Year', labelEn: '3rd Year', labelAm: '3ኛ ዓመት', position: 3),
        DynamicSurveyOption(id: 'yr_4', value: '4th Year and above', labelEn: '4th Year and above', labelAm: '4ኛ ዓመት እና ከዚያ በላይ', position: 4),
        DynamicSurveyOption(id: 'yr_5', value: 'Postgraduate', labelEn: 'Postgraduate', labelAm: 'የድህረ-ምረቃ', position: 5),
      ],
    ),
    DynamicSurveyQuestion(
      id: 'default_disability',
      titleEn: 'Do you have a disability or special accessibility need?',
      titleAm: 'የአካል ጉዳት ወይም የተለየ የተደራሽነት ፍላጎት አለዎት?',
      position: 3,
      isRequired: true,
      options: [
        DynamicSurveyOption(id: 'dis_1', value: 'NONE', labelEn: 'None / No disability', labelAm: 'የለብኝም', position: 1),
        DynamicSurveyOption(id: 'dis_2', value: 'VISUAL', labelEn: 'Visual impairment', labelAm: 'የእይታ ድጋፍ', position: 2),
        DynamicSurveyOption(id: 'dis_3', value: 'HEARING', labelEn: 'Hearing impairment', labelAm: 'የመስማት ድጋፍ', position: 3),
        DynamicSurveyOption(id: 'dis_4', value: 'PHYSICAL', labelEn: 'Physical / Mobility assistance', labelAm: 'የእንቅስቃሴ ድጋፍ', position: 4),
        DynamicSurveyOption(id: 'dis_5', value: 'PREFER_NOT_TO_SAY', labelEn: 'Prefer not to say', labelAm: 'መግለጽ አልፈልግም', position: 5),
      ],
    ),
    DynamicSurveyQuestion(
      id: 'default_gondar_srh',
      titleEn: 'Do you know where to access sexual & reproductive health services at the University of Gondar?',
      titleAm: 'በጎንደር ዩኒቨርሲቲ የጾታዊና የስነ-ተዋልዶ ጤና አገልግሎት የየት እንደሚገኝ ያውቃሉ?',
      position: 4,
      isRequired: true,
      options: [
        DynamicSurveyOption(id: 'srh_1', value: 'YES', labelEn: 'Yes, I know', labelAm: 'አዎ አውቃለሁ', position: 1),
        DynamicSurveyOption(id: 'srh_2', value: 'NO', labelEn: 'No, not yet', labelAm: 'አልያውቅም', position: 2),
        DynamicSurveyOption(id: 'srh_3', value: 'NOT_SURE', labelEn: 'Not sure', labelAm: 'እርግጠኛ አይደለሁም', position: 3),
      ],
    ),
  ];
}
