import 'content_draft_models.dart';

/// Seed templates for learning modules, quizzes, and health articles.
class LearningContentTemplates {
  LearningContentTemplates._();

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
}
