import 'package:flutter/material.dart';

import '../clubs/club_models.dart';
import '../discovery/facility_model.dart';
import '../discovery/mentor_model.dart';

class ModuleSectionDraft {
  const ModuleSectionDraft({
    required this.titleEn,
    required this.titleAm,
    required this.contentEn,
    required this.contentAm,
    required this.order,
  });

  final String titleEn;
  final String titleAm;
  final String contentEn;
  final String contentAm;
  final int order;
}

class ModuleDraft {
  const ModuleDraft({
    required this.id,
    required this.titleEn,
    required this.titleAm,
    required this.descriptionEn,
    required this.descriptionAm,
    required this.iconAsset,
    required this.estimatedReadTimeMinutes,
    required this.sections,
  });

  final String id;
  final String titleEn;
  final String titleAm;
  final String descriptionEn;
  final String descriptionAm;
  final String iconAsset;
  final int estimatedReadTimeMinutes;
  final List<ModuleSectionDraft> sections;
}

class QuestionOptionDraft {
  const QuestionOptionDraft({
    required this.id,
    required this.labelEn,
    required this.labelAm,
    required this.isCorrect,
  });

  final String id;
  final String labelEn;
  final String labelAm;
  final bool isCorrect;
}

class QuestionDraft {
  const QuestionDraft({
    required this.id,
    required this.quizId,
    required this.promptEn,
    required this.promptAm,
    required this.options,
    required this.explanationEn,
    required this.explanationAm,
  });

  final String id;
  final String quizId;
  final String promptEn;
  final String promptAm;
  final List<QuestionOptionDraft> options;
  final String explanationEn;
  final String explanationAm;
}

class ArticleDraft {
  const ArticleDraft({
    required this.id,
    required this.titleEn,
    required this.titleAm,
    required this.summaryEn,
    required this.summaryAm,
    required this.bodyMarkdownEn,
    required this.bodyMarkdownAm,
    required this.authorName,
    required this.category,
    required this.sources,
  });

  final String id;
  final String titleEn;
  final String titleAm;
  final String summaryEn;
  final String summaryAm;
  final String bodyMarkdownEn;
  final String bodyMarkdownAm;
  final String authorName;
  final String category;
  final List<String> sources;
}

class ContentTemplates {
  ContentTemplates._();

  // --- MODULE TEMPLATES ---
  static const List<ModuleDraft> moduleTemplates = [
    ModuleDraft(
      id: 'template_clinical_topic',
      titleEn: 'Adolescent Wellness & Preventive Care',
      titleAm: 'የአፍላ ወጣቶች ጤና እና ቅድመ መከላከል እንክብካቤ',
      descriptionEn:
          'Essential youth health guidance covering physical development, nutrition, and routine screening.',
      descriptionAm:
          'አጠቃላይ የአካል እድገት፣ የተመጣጠነ ምግብ እና መደበኛ የጤና ምርመራዎችን ያካተተ የወጣቶች የጤና መመሪያ።',
      iconAsset: 'assets/images/yegna_health_icon.png',
      estimatedReadTimeMinutes: 7,
      sections: [
        ModuleSectionDraft(
          titleEn: '1. Overview and Core Concept',
          titleAm: '1. አጠቃላይ እይታ እና ዋና ፅንሰ ሀሳብ',
          contentEn:
              'Understanding the natural biological and emotional transitions in youth is fundamental for lifelong wellbeing.',
          contentAm:
              'በወጣትነት ዕድሜ ላይ የሚከሰቱ የተፈጥሮ አካላዊ እና ስሜታዊ ለውጦችን መረዳት ለዘላቂ ጤንነት ወሳኝ ነው።',
          order: 1,
        ),
        ModuleSectionDraft(
          titleEn: '2. Preventive Practices',
          titleAm: '2. የመከላከያ ተግባራት',
          contentEn:
              'Regular physical activity, balanced nutrition, safe habits, and hygiene protect against avoidable conditions.',
          contentAm:
              'መደበኛ የአካል ብቃት እንቅስቃሴ፣ የተመጣጠነ ምግብ፣ ደህንነታቸው የተጠበቁ ልምዶች እና ንፅህናን መጠበቅ በሽታዎችን ይከላከላሉ።',
          order: 2,
        ),
        ModuleSectionDraft(
          titleEn: '3. When to Seek Care',
          titleAm: '3. የባለሙያ ህክምና መቼ ማግኘት ያስፈልጋል',
          contentEn:
              'Always consult a qualified healthcare provider or youth clinic for persistent concerns or severe symptoms.',
          contentAm:
              'ለማይሻሻሉ ስሜቶች ወይም ከባድ ምልክቶች ሁል ጊዜ የህክምና ባለሙያ ወይም የወጣቶች ክሊኒክ ያማክሩ።',
          order: 3,
        ),
      ],
    ),
  ];

  // --- QUESTION TEMPLATES ---
  static const List<QuestionDraft> questionTemplates = [
    QuestionDraft(
      id: 'template_mcq_standard',
      quizId: 'general',
      promptEn:
          'Which of the following is an effective preventive health practice?',
      promptAm: 'ከሚከተሉት ውስጥ ውጤታማ የጤና መከላከያ ልማድ የትኛው ነው?',
      options: [
        QuestionOptionDraft(
          id: 'opt_1',
          labelEn: 'Routine health screening and balanced nutrition',
          labelAm: 'መደበኛ የጤና ምርመራ እና የተመጣጠነ ምግብ',
          isCorrect: true,
        ),
        QuestionOptionDraft(
          id: 'opt_2',
          labelEn: 'Ignoring mild physical discomfort',
          labelAm: 'ቀለል ያሉ የሰውነት ህመሞችን ችላ ማለት',
          isCorrect: false,
        ),
        QuestionOptionDraft(
          id: 'opt_3',
          labelEn: 'Self-medicating without clinical advice',
          labelAm: 'ያለ ባለሙያ ትዕዛዝ መድኃኒቶችን መውሰድ',
          isCorrect: false,
        ),
        QuestionOptionDraft(
          id: 'opt_4',
          labelEn: 'Skipping sleep and hydration',
          labelAm: 'እንቅልፍ እና ውሃ መጠጣትን መቀነስ',
          isCorrect: false,
        ),
      ],
      explanationEn:
          'Routine check-ups, early detection, and balanced nourishment form the backbone of preventive youth care.',
      explanationAm:
          'መደበኛ ምርመራ፣ ቀደም ብሎ ማወቅ እና የተመጣጠነ ምግብ የወጣቶች የጤና ጥበቃ መሰረቶች ናቸው።',
    ),
    QuestionDraft(
      id: 'template_true_false',
      quizId: 'general',
      promptEn:
          'Youth-friendly clinics provide confidential consultations without mandatory parental disclosure.',
      promptAm:
          'ለወጣቶች ምቹ የሆኑ ክሊኒኮች ያለ ወላጆች የግዴታ ጣልቃ ገብነት ሚስጥራዊ የምክር አገልግሎት ይሰጣሉ።',
      options: [
        QuestionOptionDraft(
          id: 'opt_tf_1',
          labelEn: 'True',
          labelAm: 'እውነት',
          isCorrect: true,
        ),
        QuestionOptionDraft(
          id: 'opt_tf_2',
          labelEn: 'False',
          labelAm: 'ሀሰት',
          isCorrect: false,
        ),
      ],
      explanationEn:
          'National youth health policies guarantee confidential, non-judgmental counseling for young people.',
      explanationAm:
          'ብሔራዊ የወጣቶች ጤና ፖሊሲዎች ለወጣቶች ሚስጥራዊ እና ከፍረጃ ነፃ የሆነ የምክር አገልግሎት ያረጋግጣሉ።',
    ),
  ];

  // --- ARTICLE TEMPLATES ---
  static const List<ArticleDraft> articleTemplates = [
    ArticleDraft(
      id: 'template_doctor_column',
      titleEn: 'Doctor\'s Youth Advice: Healthy Habits for Vitality',
      titleAm: 'የዶክተር ማስታወሻ፡ ለወጣቶች ንቁ እና ጤናማ የአኗኗር ዘይቤ',
      summaryEn:
          'Practical daily recommendations from adolescent health specialists on maintaining physical and mental balance.',
      summaryAm:
          'ከአፍላ ወጣቶች የጤና ባለሙያዎች የተሰጡ የእለት ተእለት አካላዊና አእምሯዊ ሚዛንን የመጠበቂያ ምክሮች።',
      bodyMarkdownEn:
          '### The Three Pillars of Youth Health\n\n1. **Restorative Sleep**: Aim for 7 to 9 hours nightly.\n2. **Nutrition & Hydration**: Drink water regularly and incorporate fresh food.\n3. **Open Communication**: Never hesitate to speak with peer mentors or certified doctors about your physical changes.',
      bodyMarkdownAm:
          '### ሶስቱ የወጣቶች ጤና ምሰሶዎች\n\n1. **በቂ እንቅልፍ**፡ በየቀኑ ከ7 እስከ 9 ሰዓት ያህል ማረፍ።\n2. **የተመጣጠነ ምግብ እና ውሃ**፡ በቂ ውሃ መጠጣትና ጤናማ ምግቦችን መጠቀም።\n3. **ግልጽ ውይይት**፡ ስለሚያጋጥሟችሁ አካላዊ ለውጦች ከአቻ አማካሪዎች ወይም የጤና ባለሙያዎች ጋር ለመወያየት አታመንቱ።',
      authorName: 'Dr. Hanna Bekele, MD',
      category: 'General Wellness',
      sources: [
        'Ethiopian Ministry of Health Adolescent Guidelines',
        'WHO Youth Health'
      ],
    ),
  ];

  // --- CLUB TEMPLATES ---
  static List<StudentClub> get clubTemplates => [
        StudentClub(
          id: 'template_girls_wellness',
          nameEn: 'Girls\' Health & Wellness Club',
          nameAm: 'የሴቶች ጤና እና ደህንነት ክበብ',
          descriptionEn:
              'A safe, supportive space for young women to discuss menstrual hygiene, self-esteem, nutrition, and personal wellness.',
          descriptionAm:
              'ወጣት ሴቶች የወር አበባ ንፅህናን፣ በራስ መተማመንን፣ የተመጣጠነ ምግብን እና አጠቃላይ ደህንነትን በግልፅ የሚወያዩበት ደጋፊ ክበብ።',
          category: ClubCategory.girlsHygiene,
          meetingScheduleEn: 'Every Thursday, 4:00 PM – 5:30 PM',
          meetingScheduleAm: 'በየሳምንቱ ሐሙስ፡ ከቀኑ 10:00 – 11:30',
          meetingLocationEn: 'Campus Student Center, Room 204',
          meetingLocationAm: 'የግቢው የተማሪዎች ማዕከል፣ ቢሮ ቁጥር 204',
          mentorNameEn: 'Sister Selamawit Tadesse',
          mentorNameAm: 'ሲስተር ሰላማዊት ታደሰ',
          mentorContact: '+251 91 144 8899',
          maxCapacity: 40,
          rulesEn: const [
            'Maintain strict mutual respect and confidentiality.',
            'Support every member without judgment.',
            'Be punctual for weekly dialogue circles.',
          ],
          rulesAm: const [
            'የጋራ መከባበር እና ጥብቅ ሚስጥራዊነትን መጠበቅ።',
            'ማናቸውንም አባል ያለ ፍረጃ መደገፍ።',
            'ለሳምንታዊ የውይይት መድረኮች በሰዓቱ መገኘት።',
          ],
          tags: const ['Menstrual Health', 'Hygiene', 'Peer Support'],
          createdAt: DateTime.now(),
        ),
        StudentClub(
          id: 'template_mental_health',
          nameEn: 'Mind & Wellbeing Champions',
          nameAm: 'የአእምሮ ጤና እና ደህንነት አምባሳደሮች',
          descriptionEn:
              'Peer-led discussions on managing academic stress, building resilience, mindfulness, and eliminating mental health stigma.',
          descriptionAm:
              'የትምህርት ጭንቀትን መቆጣጠር፣ ፅናትን ማዳበር፣ አእምሯዊ መረጋጋት እና የአእምሮ ጤና መገለልን ስለማስወገድ የሚሰራ የአቻ ተማሪዎች ክበብ።',
          category: ClubCategory.mentalHealth,
          meetingScheduleEn: 'Every Wednesday, 3:30 PM – 5:00 PM',
          meetingScheduleAm: 'በየሳምንቱ ረቡዕ፡ ከቀኑ 9:30 – 11:00',
          meetingLocationEn: 'Library Discussion Hall & Telegram Online',
          meetingLocationAm: 'የቤተ-መጽሐፍት የውይይት አዳራሽ እና በቴሌግራም',
          mentorNameEn: 'Dr. Yonas Girma (Counselor)',
          mentorNameAm: 'ዶ/ር ዮናስ ግርማ (አማካሪ)',
          mentorContact: '@yonas_counseling',
          maxCapacity: 50,
          rulesEn: const [
            'Everything shared in the circle stays in the circle.',
            'Practice active, empathetic listening.',
            'Direct crisis cases immediately to certified hotlines (8335 / 952).',
          ],
          rulesAm: const [
            'በክበቡ ውስጥ የተነገረ ነገር ሁሉ እዛው ሚስጥር ሆኖ ይቀራል።',
            'ትኩረት ሰጥቶ ማዳመጥ እና መረዳት።',
            'አስቸኳይ ጉዳዮች ሲያጋጥሙ ወዲያውኑ ወደ ነፃ የስልክ መስመሮች (8335 / 952) ማስተላለፍ።',
          ],
          tags: const ['Mental Health', 'Stress Management', 'Mindfulness'],
          createdAt: DateTime.now(),
        ),
        StudentClub(
          id: 'template_srh_wellness',
          nameEn: 'Campus Reproductive Health Pioneers',
          nameAm: 'የግቢው ስነ-ተዋልዶ ጤና አቅኚዎች',
          descriptionEn:
              'Promoting safe reproductive health practices, STI and HIV prevention, and facilitating access to youth-friendly clinics.',
          descriptionAm:
              'ደህንነቱ የተጠበቀ የስነ-ተዋልዶ ጤና፣ የአባለዘር እና የኤች አይ ቪ መከላከል እና የወጣቶች ክሊኒክ አገልግሎቶችን ተደራሽ ማድረግ ላይ የሚሰራ ክበብ።',
          category: ClubCategory.srhWellness,
          meetingScheduleEn: 'Every Friday, 4:30 PM – 6:00 PM',
          meetingScheduleAm: 'በየሳምንቱ አርብ፡ ከቀኑ 10:30 – 12:00',
          meetingLocationEn: 'Youth Resource Center & Amphitheater',
          meetingLocationAm: 'የወጣቶች የመረጃ ማዕከል እና አምፊቲያትር',
          mentorNameEn: 'Alemayehu Kebede (Health Officer)',
          mentorNameAm: 'አለማየሁ ከበደ (የጤና መኮንን)',
          mentorContact: '+251 92 333 4455',
          maxCapacity: 60,
          rulesEn: const [
            'Open, honest, and respectful conversations.',
            'Adhere to certified Ministry of Health scientific facts.',
            'Respect bodily autonomy and diversity.',
          ],
          rulesAm: const [
            'ግልጽ፣ ታማኝ እና የተከበረ ውይይት ማድረግ።',
            'በጤና ጥበቃ ሚኒስቴር የተረጋገጡ ሳይንሳዊ እውነታዎችን ብቻ መከተል።',
            'የሰውነት ክብርን እና ልዩነቶችን ማክበር።',
          ],
          tags: const ['SRH', 'HIV Prevention', 'Youth Clinics'],
          createdAt: DateTime.now(),
        ),
        StudentClub(
          id: 'template_anti_substance',
          nameEn: 'Substance-Free Healthy Youth Alliance',
          nameAm: 'ከሱሶች የፀዱ ጤናማ ወጣቶች ህብረት',
          descriptionEn:
              'Empowering students to live healthy, addiction-free lives through sports, art, positive mentorship, and peer intervention.',
          descriptionAm:
              'ተማሪዎች በስፖርት፣ በስነ-ጥበብ እና በአቻ ድጋፍ ጤናማ እና ከሱስ ነፃ የሆነ ህይወት እንዲመሩ የሚያበረታታ የወጣቶች ህብረት።',
          category: ClubCategory.antiSubstance,
          meetingScheduleEn: 'Every Saturday, 9:30 AM – 11:30 AM',
          meetingScheduleAm: 'በየሳምንቱ ቅዳሜ፡ ከጠዋቱ 3:30 – 5:30',
          meetingLocationEn: 'University Sports Complex',
          meetingLocationAm: 'የዩኒቨርሲቲው የስፖርት ማዕከል',
          mentorNameEn: 'Coach Dawit Mulugeta',
          mentorNameAm: 'አሰልጣኝ ዳዊት ሙሉጌታ',
          mentorContact: '+251 91 777 8899',
          maxCapacity: 100,
          rulesEn: const [
            'Total commitment to clean, healthy living.',
            'Encourage and assist peers seeking recovery.',
            'Participate actively in positive extracurriculars.',
          ],
          rulesAm: const [
            'ጤናማ እና ንፁህ ህይወት ለመኖር ቁርጠኝነት ማሳየት።',
            'ከሱስ ለመላቀቅ የሚጥሩ ጓደኞችን ማበረታታት እና መደገፍ።',
            'በትምህርት ውጭ እንቅስቃሴዎች እና ስፖርት ላይ በንቃት መሳተፍ።',
          ],
          tags: const ['Substance Free', 'Fitness', 'Peer Mentorship'],
          createdAt: DateTime.now(),
        ),
      ];

  // --- FACILITY TEMPLATES ---
  static const List<Facility> facilityTemplates = [
    Facility(
      id: 'template_youth_clinic',
      nameEn: 'Youth-Friendly Health & Counseling Center',
      nameAm: 'ለወጣቶች ምቹ የጤና እና የምክር ማዕከል',
      subCityEn: 'Bole Sub-City, Woreda 03',
      subCityAm: 'ቦሌ ክፍለ ከተማ፣ ወረዳ 03',
      addressEn: 'Airport Road, near Edna Mall, Addis Ababa',
      addressAm: 'ኤርፖርት መንገድ፣ ኤድና ሞል አጠገብ፣ አዲስ አበባ',
      landmarkEn: 'Opposite Bole Youth Center',
      landmarkAm: 'ከቦሌ ወጣቶች ማዕከል ፊት ለፊት',
      phone: '+251-11-662-8899',
      type: FacilityType.youthCenter,
      latitude: 9.0012,
      longitude: 38.7845,
      distanceKm: 2.1,
      isYouthFriendly: true,
      isFreeForYouth: true,
      openingHour: 8,
      closingHour: 18,
      services: [
        'SRH Services',
        'VCT / HIV Testing',
        'Mental Health & Counseling',
        'Free Contraceptives',
      ],
    ),
  ];

  // --- MENTOR TEMPLATES ---
  static const List<Mentor> mentorTemplates = [
    Mentor(
      id: 'template_peer_mentor',
      nameEn: 'Hanan Mohammed',
      nameAm: 'ሀናን መሀመድ',
      titleEn: 'Certified Youth Peer Counselor',
      titleAm: 'የተመሰከረላት የወጣቶች አቻ አማካሪ',
      organizationEn: 'Yegna Health Peer Network',
      organizationAm: 'የእኛ ጤና የአቻ አውታረ መረብ',
      bioEn:
          'Passionate peer mentor with over 4 years experience supporting students through mental wellness, puberty, and relationship questions.',
      bioAm:
          'ለተማሪዎች በአእምሮ ጤና፣ በአፍላ ጉርምስና እና በግንኙነት ጉዳዮች ላይ ከ4 ዓመታት በላይ የአቻ የምክር ድጋፍ የሰጠች አጋዥ አቻ አማካሪ።',
      isVerified: true,
      isOnline: true,
      nextAvailableSlotEn: 'Today at 3:00 PM',
      nextAvailableSlotAm: 'ዛሬ ከቀኑ 9:00',
      languages: ['Amharic', 'English', 'Oromiffa'],
      topics: [
        MentorTopic.mentalHealth,
        MentorTopic.puberty,
        MentorTopic.srhGuidance
      ],
      sessionsCount: 380,
      experienceYears: 4,
      initials: 'HM',
      avatarColor: Color(0xFF0284C7),
      phoneNumber: '+251911998877',
      displayPhoneNumber: '+251 91 199 8877',
      telegramHandle: 'hanan_peer_counselor',
      workingHoursEn: 'Mon – Fri: 9:00 AM – 5:00 PM',
      workingHoursAm: 'ከሰኞ – ዓርብ፡ 3:00 – 11:00',
    ),
  ];
}
