import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const STANDARD_OPTIONS = [
  { value: 'YES', labelEn: 'Yes', labelAm: 'አዎ', position: 1 },
  { value: 'NO', labelEn: 'No', labelAm: 'አይ', position: 2 },
  { value: 'NOT_SURE', labelEn: 'Not sure', labelAm: 'እርግጠኛ አይደለሁም', position: 3 },
  { value: 'PREFER_NOT_TO_ANSWER', labelEn: 'Prefer not to answer', labelAm: 'መመለስ አልፈልግም', position: 4 },
];

const SECTIONS = [
  {
    number: 1,
    key: 'section_1',
    titleEn: 'Personal and General Information',
    titleAm: 'ክፍል 1፡ አጠቃላይ የግል መረጃ',
    moduleKey: 'general',
    questions: [
      {
        key: 'age_group',
        position: 1,
        titleEn: 'What is your age?',
        titleAm: 'ዕድሜዎ ስንት ነው?',
        type: 'SINGLE_CHOICE',
        options: [
          { value: '18–20', labelEn: '18–20', labelAm: '18–20', position: 1 },
          { value: '21–24', labelEn: '21–24', labelAm: '21–24', position: 2 },
          { value: '25–29', labelEn: '25–29', labelAm: '25–29', position: 3 },
          { value: '30+', labelEn: '30 and above', labelAm: '30 እና ከዚያ በላይ', position: 4 },
        ],
      },
      {
        key: 'year_of_study',
        position: 2,
        titleEn: 'What is your current year of study at University of Gondar?',
        titleAm: 'በምን ዓመት የትምህርት ደረጃ ላይ ይገኛሉ?',
        type: 'SINGLE_CHOICE',
        options: [
          { value: '1st Year', labelEn: '1st Year', labelAm: '1ኛ ዓመት', position: 1 },
          { value: '2nd Year', labelEn: '2nd Year', labelAm: '2ኛ ዓመት', position: 2 },
          { value: '3rd Year', labelEn: '3rd Year', labelAm: '3ኛ ዓመት', position: 3 },
          { value: '4th Year+', labelEn: '4th Year and above', labelAm: '4ኛ ዓመት እና ከዚያ በላይ', position: 4 },
          { value: 'Postgraduate', labelEn: 'Postgraduate', labelAm: 'የድህረ-ምረቃ', position: 5 },
        ],
      },
      {
        key: 'disability_need',
        position: 3,
        titleEn: 'Do you have a disability or special accessibility need?',
        titleAm: 'የአካል ጉዳት ወይም የተለየ የተደራሽነት ፍላጎት አለዎት?',
        type: 'SINGLE_CHOICE',
        options: [
          { value: 'NONE', labelEn: 'None / No disability', labelAm: 'የለብኝም', position: 1 },
          { value: 'VISUAL', labelEn: 'Visual impairment', labelAm: 'የእይታ ድጋፍ', position: 2 },
          { value: 'HEARING', labelEn: 'Hearing impairment', labelAm: 'የመስማት ድጋፍ', position: 3 },
          { value: 'PHYSICAL', labelEn: 'Physical / Mobility assistance', labelAm: 'የእንቅስቃሴ ድጋፍ', position: 4 },
          { value: 'PREFER_NOT_TO_SAY', labelEn: 'Prefer not to say', labelAm: 'መግለጽ አልፈልግም', position: 5 },
        ],
      },
      {
        key: 'gondar_srh',
        position: 4,
        titleEn: 'Do you know where to access sexual and reproductive health services at the University of Gondar?',
        titleAm: 'በጎንደር ዩኒቨርሲቲ የጾታዊና የስነ-ተዋልዶ ጤና አገልግሎት የት እንደሚገኝ ያውቃሉ?',
        type: 'SINGLE_CHOICE',
        options: [
          { value: 'YES', labelEn: 'Yes, I know', labelAm: 'አዎ አውቃለሁ', position: 1 },
          { value: 'NO', labelEn: 'No, not yet', labelAm: 'አላውቅም', position: 2 },
          { value: 'NOT_SURE', labelEn: 'Not sure', labelAm: 'እርግጠኛ አይደለሁም', position: 3 },
        ],
      },
    ],
  },
  {
    number: 2,
    key: 'section_2',
    titleEn: 'Sexual Behaviour and Health Risks',
    titleAm: 'ክፍል 2፡ የጾታዊ ባህሪና የጤና ስጋቶች ግምገማ',
    moduleKey: 'srh',
    questions: [
      { key: 'q5_ever_sex', position: 5, titleEn: 'Have you ever had sexual intercourse?', titleAm: 'በሕይወትዎ ውስጥ የግብረ-ሥጋ ግንኙነት ፈጽመው ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q6_sex_12m', position: 6, titleEn: 'Have you had sexual intercourse in the last 12 months?', titleAm: 'ባለፉት 12 ወራት የግብረ-ሥጋ ግንኙነት ፈጽመዋል?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q7_multiple_partners', position: 7, titleEn: 'Have you had more than one sexual partner in the last 12 months?', titleAm: 'ባለፉት 12 ወራት ከአንድ በላይ የግብረ-ሥጋ ግንኙነት አጋር ነበርዎት?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q8_unknown_status_partner', position: 8, titleEn: 'Have you had sexual intercourse with a new partner without knowing their HIV or STI status?', titleAm: 'የግብረ-ሥጋ ግንኙነት ከጀመሩት አዲስ አጋር የኤችአይቪና የጾታዊ ግንኙነት በሽታዎች (STIs) ሁኔታ ሳያውቁ ግንኙነት ፈጽመዋል?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q9_sex_without_condom', position: 9, titleEn: 'Have you ever had sexual intercourse without using a condom?', titleAm: 'ኮንዶም ሳይጠቀሙ የግብረ-ሥጋ ግንኙነት ፈጽመው ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q10_consistent_condom', position: 10, titleEn: 'Have you used a condom consistently during sexual intercourse?', titleAm: 'የግብረ-ሥጋ ግንኙነት በሚፈጽሙበት ጊዜ ሁልጊዜ ኮንዶም ይጠቀማሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q11_transactional_sex', position: 11, titleEn: 'Have you ever exchanged sex for money, gifts, accommodation, grades, employment opportunities, or other benefits?', titleAm: 'በገንዘብ፣ በስጦታ፣ በመኖሪያ ቦታ፣ በውጤት፣ በሥራ ዕድል ወይም በሌሎች ጥቅሞች ምክንያት የግብረ-ሥጋ ግንኙነት ፈጽመው ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q12_sex_under_substances', position: 12, titleEn: 'Have you ever engaged in sexual activity under the influence of alcohol or other substances?', titleAm: 'በአልኮል ወይም በሌሎች አደንዛዥ ንጥረ ነገሮች ተጽዕኖ ሥር እያሉ የጾታዊ ግንኙነት ፈጽመው ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
    ],
  },
  {
    number: 3,
    key: 'section_3',
    titleEn: 'HIV and Sexually Transmitted Infections (STIs)',
    titleAm: 'ክፍል 3፡ ኤችአይቪና በጾታዊ ግንኙነት የሚተላለፉ በሽታዎች',
    moduleKey: 'hiv',
    questions: [
      { key: 'q13_ever_tested_hiv', position: 13, titleEn: 'Have you ever been tested for HIV?', titleAm: 'ለኤችአይቪ ምርመራ አድርገው ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q14_hiv_test_12m', position: 14, titleEn: 'Have you had an HIV test in the last 12 months?', titleAm: 'ባለፉት 12 ወራት ውስጥ ለኤችአይቪ ምርመራ አድርገዋል?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q15_know_hiv_status', position: 15, titleEn: 'Do you know your current HIV status?', titleAm: 'አሁን ያለዎትን የኤችአይቪ ሁኔታ ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q16_ever_diagnosed_sti', position: 16, titleEn: 'Have you ever been diagnosed with a sexually transmitted infection (STI)?', titleAm: 'በጾታዊ ግንኙነት የሚተላለፍ በሽታ ተጠቂ መሆንዎ በምርመራ ተረጋግጦ ያውቃል?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q17_sti_symptoms', position: 17, titleEn: 'Have you experienced unusual genital discharge, sores, itching, pain, or burning during urination?', titleAm: 'ከብልት የተለመደ ያልሆነ ፈሳሽ መውጣት፣ ቁስለት፣ ማሳከክ፣ ሕመም ወይም በሽንት ጊዜ የማቃጠል ስሜት አጋጥሞዎት ያውቃል?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q18_received_sti_treatment', position: 18, titleEn: 'Have you ever received treatment for an STI?', titleAm: 'ለጾታዊ ግንኙነት በሚተላለፍ በሽታ ሕክምና አግኝተው ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q19_hiv_prep_awareness', position: 19, titleEn: 'Do you know that HIV can be prevented through safer sexual practices, testing, condoms, PrEP and other prevention services?', titleAm: 'ኤችአይቪን በደህንነቱ በተጠበቀ የጾታዊ ግንኙነት ልምድ፣ በምርመራ፣ በኮንዶም፣ በPrEP እና በሌሎች የመከላከያ አገልግሎቶች መከላከል እንደሚቻል ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q20_confidential_hiv_testing_location', position: 20, titleEn: 'Do you know where to obtain confidential HIV testing and STI treatment at UoG?', titleAm: 'ሚስጥራዊነቱ የተጠበቀ የኤችአይቪ ምርመራና የSTI ሕክምና የት እንደሚገኝ ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
    ],
  },
  {
    number: 4,
    key: 'section_4',
    titleEn: 'Contraception and Family Planning',
    titleAm: 'ክፍል 4፡ የቤተሰብ ምጣኔና የእርግዝና መከላከያ',
    moduleKey: 'contraception',
    questions: [
      { key: 'q21_info_modern_contraceptives', position: 21, titleEn: 'Do you have adequate information about modern contraceptive methods?', titleAm: 'ስለ ዘመናዊ የእርግዝና መከላከያ ዘዴዎች በቂ መረጃ አለዎት?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q22_ever_used_contraceptive', position: 22, titleEn: 'Have you ever used a modern contraceptive method?', titleAm: 'ዘመናዊ የእርግዝና መከላከያ ዘዴ ተጠቅመው ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q23_currently_using_contraceptive', position: 23, titleEn: 'Are you currently using any contraceptive method, if sexually active?', titleAm: 'አሁን የጾታዊ ግንኙነት ካለዎት የእርግዝና መከላከያ ዘዴ እየተጠቀሙ ነው?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q24_emergency_contraception_knowledge', position: 24, titleEn: 'Do you know about emergency contraception and when it should be used?', titleAm: 'ስለ ድንገተኛ የእርግዝና መከላከያ መድኃኒትና መቼ መጠቀም እንዳለበት ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q25_unintended_pregnancy_concern', position: 25, titleEn: 'Have you ever experienced an unintended pregnancy or been concerned about an unintended pregnancy?', titleAm: 'ያልታቀደ እርግዝና አጋጥሞዎት ወይም ያልታቀደ እርግዝና ሊያጋጥም ይችላል ብለው ተጨንቀው ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q26_confidential_fp_access', position: 26, titleEn: 'Do you know where to access family planning services confidentially at University of Gondar?', titleAm: 'በሚስጥር የቤተሰብ ምጣኔ አገልግሎት የት ማግኘት እንደሚችሉ ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
    ],
  },
  {
    number: 5,
    key: 'section_5',
    titleEn: 'Menstrual and Reproductive Health',
    titleAm: 'ክፍል 5፡ የወር አበባና የስነ-ተዋልዶ ጤና',
    moduleKey: 'puberty',
    questions: [
      { key: 'q27_menstrual_hygiene_knowledge', position: 27, titleEn: 'Do you have adequate knowledge about menstrual health and hygiene?', titleAm: 'ስለ ወር አበባ ጤናና ንጽህና በቂ ግንዛቤ አለዎት?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q28_severe_menstrual_pain', position: 28, titleEn: 'Do you experience severe menstrual pain or unusually heavy bleeding?', titleAm: 'ከባድ የወር አበባ ሕመም ወይም ከመጠን በላይ የደም መፍሰስ ያጋጥምዎታል?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q29_missed_classes_menstrual', position: 29, titleEn: 'Have you ever missed classes or academic activities because of menstrual problems?', titleAm: 'በወር አበባ ችግር ምክንያት ከትምህርት ወይም ከአካዳሚክ እንቅስቃሴዎች ቀርተው ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q30_pads_clean_toilets_access', position: 30, titleEn: 'Do you have access to affordable sanitary pads and clean toilet facilities on campus?', titleAm: 'በተመጣጣኝ ዋጋ የንጽህና መጠበቂያ ፓዶችንና ንጹህ የመጸዳጃ ቤት አገልግሎትን ማግኘት ይችላሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q31_menstrual_abnormalities_medical_need', position: 31, titleEn: 'Do you know when menstrual abnormalities require medical attention?', titleAm: 'የወር አበባ መዛባት የሕክምና እርዳታ መፈለግ የሚያስፈልገው መቼ እንደሆነ ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
    ],
  },
  {
    number: 6,
    key: 'section_6',
    titleEn: 'Sexual Consent, Gender-Based Violence and Safety',
    titleAm: 'ክፍል 6፡ የጾታዊ ፈቃድ፣ ጾታዊ ጥቃትና ደህንነት',
    moduleKey: 'gbv',
    questions: [
      { key: 'q32_consent_concept', position: 32, titleEn: 'Do you understand the concept of sexual consent?', titleAm: 'የጾታዊ ግንኙነት ፈቃድ ምን ማለት እንደሆነ ይረዳሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q33_pressured_forced_sex', position: 33, titleEn: 'Has anyone ever pressured, threatened, or forced you to engage in sexual activity against your will?', titleAm: 'ያለፈቃድዎ የጾታዊ ግንኙነት እንዲፈጽሙ ማንም ጫና አድርጎብዎት፣ አስፈራርቶዎት ወይም አስገድዶዎት ያውቃል?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q34_unwanted_touching_assault', position: 34, titleEn: 'Have you ever experienced unwanted sexual touching, harassment, or sexual assault?', titleAm: 'ያልተፈለገ የጾታዊ ንክኪ፣ ትንኮሳ ወይም ጾታዊ ጥቃት ደርሶብዎት ያውቃል?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q35_harassment_by_staff_student', position: 35, titleEn: 'Have you ever experienced sexual harassment or exploitation by a lecturer, staff member, or another student?', titleAm: 'በመምህር፣ በሠራተኛ ወይም በሌላ ተማሪ የጾታዊ ትንኮሳ ወይም ብዝበዛ ደርሶብዎት ያውቃል?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q36_academic_grades_threats', position: 36, titleEn: 'Have you ever been threatened with poor academic grades, loss of opportunities, or other consequences for refusing sexual advances?', titleAm: 'የጾታዊ ግንኙነት ጥያቄን ባለመቀበልዎ ምክንያት ዝቅተኛ ውጤት፣ የዕድል ማጣት ወይም ሌላ ቅጣት እንደሚደርስብዎት ተዝተው ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q37_gbv_reporting_mechanism', position: 37, titleEn: 'Do you know where and how to report sexual harassment or gender-based violence at the University?', titleAm: 'በዩኒቨርሲቲው ውስጥ የጾታዊ ትንኮሳን ወይም ጾታዊ ጥቃትን የትና እንዴት ማሳወቅ እንደሚችሉ ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q38_feel_safe_campus', position: 38, titleEn: 'Do you feel safe in your dormitory, classroom, campus, and surrounding community?', titleAm: 'በመኝታ ክፍልዎ፣ በክፍል ውስጥ፣ በግቢውና በአካባቢው ደህንነት ይሰማዎታል?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
    ],
  },
  {
    number: 7,
    key: 'section_7',
    titleEn: 'Knowledge, Attitudes and Access to Services',
    titleAm: 'ክፍል 7፡ እውቀት፣ አመለካከትና የአገልግሎት ተደራሽነት',
    moduleKey: 'mental_health',
    questions: [
      { key: 'q39_adequate_srhr_info', position: 39, titleEn: 'Do you have adequate information about sexual and reproductive health and rights?', titleAm: 'ስለ ጾታዊና የስነ-ተዋልዶ ጤናና መብቶች በቂ መረጃ አለዎት?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q40_received_srhr_training', position: 40, titleEn: 'Have you ever received sexual and reproductive health education or training?', titleAm: 'ስለ ጾታዊና የስነ-ተዋልዶ ጤና ትምህርት ወይም ሥልጠና አግኝተው ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q41_comfortable_discussing_health_pro', position: 41, titleEn: 'Do you feel comfortable discussing sexual and reproductive health concerns with a health professional?', titleAm: 'የጾታዊና የስነ-ተዋልዶ ጤና ችግሮችዎን ከጤና ባለሙያ ጋር በነፃነት መወያየት ይችላሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q42_avoided_services_stigma_fear', position: 42, titleEn: 'Have you ever avoided seeking sexual and reproductive health services because of stigma, discrimination, fear, or lack of confidentiality?', titleAm: 'በመገለል፣ በመድልዎ፣ በፍርሃት ወይም ሚስጥራዊነት አይጠበቅም በሚል ስጋት ምክንያት የጾታዊና የስነ-ተዋልዶ ጤና አገልግሎት ከማግኘት ተቆጥበው ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q43_disability_accessible_services', position: 43, titleEn: 'Do you know that sexual and reproductive health services should be accessible to all students, including students with disabilities?', titleAm: 'የጾታዊና የስነ-ተዋልዶ ጤና አገልግሎቶች የአካል ጉዳት ላላቸው ተማሪዎችን ጨምሮ ለሁሉም ተማሪዎች ተደራሽ መሆን እንዳለባቸው ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
      { key: 'q44_psychosocial_counselling_access', position: 44, titleEn: 'Do you know where to access psychosocial counselling and mental health support on campus?', titleAm: 'የሥነ-ልቦናና የማህበራዊ ድጋፍ ምክር አገልግሎት የት ማግኘት እንደሚችሉ ያውቃሉ?', type: 'SINGLE_CHOICE', options: STANDARD_OPTIONS },
    ],
  },
  {
    number: 8,
    key: 'section_8',
    titleEn: 'Personal Support Needs and Service Preferences',
    titleAm: 'ክፍል 8፡ የግል ድጋፍ ፍላጎቶችና የአገልግሎት ምርጫዎች',
    moduleKey: 'support',
    questions: [
      {
        key: 'q45_support_needs_most',
        position: 45,
        titleEn: 'What type of sexual and reproductive health information or support do you need most?',
        titleAm: 'ከሚከተሉት ውስጥ በብዛት የሚፈልጉት የጾታዊና የስነ-ተዋልዶ ጤና መረጃ ወይም ድጋፍ የትኛው ነው?',
        type: 'MULTI_CHOICE',
        options: [
          { value: 'HIV_TESTING', labelEn: 'HIV prevention and testing', labelAm: 'የኤችአይቪ መከላከልና ምርመራ', position: 1 },
          { value: 'STI_TREATMENT', labelEn: 'STI prevention and treatment', labelAm: 'የSTI መከላከልና ሕክምና', position: 2 },
          { value: 'FAMILY_PLANNING', labelEn: 'Family planning and contraception', labelAm: 'የቤተሰብ ምጣኔና የእርግዝና መከላከያ', position: 3 },
          { value: 'MENSTRUAL_HEALTH', labelEn: 'Menstrual health', labelAm: 'የወር አበባ ጤና', position: 4 },
          { value: 'GBV_SUPPORT', labelEn: 'Sexual violence prevention and response', labelAm: 'የጾታዊ ጥቃት መከላከልና ምላሽ', position: 5 },
          { value: 'PSYCHOSOCIAL', labelEn: 'Psychosocial counselling', labelAm: 'የሥነ-ልቦናና ማህበራዊ ድጋፍ', position: 6 },
          { value: 'PREGNANCY_SERVICES', labelEn: 'Pregnancy-related services', labelAm: 'ከእርግዝና ጋር የተያያዙ አገልግሎቶች', position: 7 },
          { value: 'DISABILITY_SRHR', labelEn: 'Disability-inclusive SRHR services', labelAm: 'ለአካል ጉዳት ተጠቂዎች ተደራሽ የSRHR አገልግሎቶች', position: 8 },
        ],
      },
      {
        key: 'q46_barriers_to_access',
        position: 46,
        titleEn: 'What prevents you from accessing sexual and reproductive health services?',
        titleAm: 'የጾታዊና የስነ-ተዋልዶ ጤና አገልግሎት ከማግኘት የሚያግድዎት ምንድን ነው?',
        type: 'MULTI_CHOICE',
        options: [
          { value: 'LACK_OF_INFO', labelEn: 'Lack of information', labelAm: 'የመረጃ እጥረት', position: 1 },
          { value: 'FINANCIAL', labelEn: 'Financial constraints', labelAm: 'የገንዘብ ችግር', position: 2 },
          { value: 'FEAR_OF_STIGMA', labelEn: 'Fear of stigma and discrimination', labelAm: 'የመገለልና የመድልዎ ፍርሃት', position: 3 },
          { value: 'LACK_OF_CONFIDENTIALITY', labelEn: 'Lack of confidentiality', labelAm: 'ሚስጥራዊነት አለመጠበቅ', position: 4 },
          { value: 'DISTANCE_ACCESS', labelEn: 'Distance or lack of accessible services', labelAm: 'የአገልግሎት ርቀት ወይም ተደራሽ አለመሆን', position: 5 },
          { value: 'CULTURAL_BARRIERS', labelEn: 'Cultural or social barriers', labelAm: 'ባህላዊና ማህበራዊ እንቅፋቶች', position: 6 },
          { value: 'OTHER', labelEn: 'Other reason', labelAm: 'ሌላ', position: 7 },
        ],
      },
      {
        key: 'q47_provider_gender_preference',
        position: 47,
        titleEn: 'Would you prefer to receive SRHR services from a trained female or male health professional, or do you have no preference?',
        titleAm: 'የSRHR አገልግሎት ከሰለጠነች ሴት ወይም ከሰለጠነ ወንድ የጤና ባለሙያ ማግኘት ይመርጣሉ? ወይስ ምርጫ የለዎትም?',
        type: 'SINGLE_CHOICE',
        options: [
          { value: 'FEMALE_PRO', labelEn: 'Female health professional', labelAm: 'ከሰለጠነች ሴት የጤና ባለሙያ', position: 1 },
          { value: 'MALE_PRO', labelEn: 'Male health professional', labelAm: 'ከሰለጠነ ወንድ የጤና ባለሙያ', position: 2 },
          { value: 'NO_PREFERENCE', labelEn: 'No preference / Any trained professional', labelAm: 'ምርጫ የለኝም / ማንኛውም የጤና ባለሙያ', position: 3 },
        ],
      },
      {
        key: 'q48_counselling_referral_request',
        position: 48,
        titleEn: 'Would you like to receive confidential counselling or referral for any sexual and reproductive health concern?',
        titleAm: 'በማንኛውም የጾታዊና የስነ-ተዋልዶ ጤና ጉዳይ ሚስጥራዊ የምክር ወይም የሪፈራል አገልግሎት ማግኘት ይፈልጋሉ?',
        type: 'SINGLE_CHOICE',
        options: [
          { value: 'YES_PLEASE', labelEn: 'Yes, please', labelAm: 'አዎ እፈልጋለሁ', position: 1 },
          { value: 'NO_THANKS', labelEn: 'No, not right now', labelAm: 'አሁን አልፈልግም', position: 2 },
          { value: 'NOT_SURE', labelEn: 'Not sure yet', labelAm: 'እርግጠኛ አይደለሁም', position: 3 },
        ],
      },
    ],
  },
];

async function seed() {
  console.log('Seeding University of Gondar 8-Section SRHR Questions...');

  for (const section of SECTIONS) {
    console.log(`Processing Section ${section.number}: ${section.titleEn}`);
    for (const q of section.questions) {
      const question = await prisma.surveyQuestion.upsert({
        where: { key: q.key },
        update: {
          sectionNumber: section.number,
          sectionKey: section.key,
          sectionTitleEn: section.titleEn,
          sectionTitleAm: section.titleAm,
          moduleKey: section.moduleKey,
          position: q.position,
          titleEn: q.titleEn,
          titleAm: q.titleAm,
          type: q.type,
          isActive: true,
          isRequired: true,
        },
        create: {
          key: q.key,
          sectionNumber: section.number,
          sectionKey: section.key,
          sectionTitleEn: section.titleEn,
          sectionTitleAm: section.titleAm,
          moduleKey: section.moduleKey,
          position: q.position,
          titleEn: q.titleEn,
          titleAm: q.titleAm,
          type: q.type,
          isActive: true,
          isRequired: true,
        },
      });

      // Clear existing options to cleanly replace with official ones
      await prisma.surveyQuestionOption.deleteMany({
        where: { questionId: question.id },
      });

      for (const opt of q.options) {
        await prisma.surveyQuestionOption.create({
          data: {
            questionId: question.id,
            position: opt.position,
            value: opt.value,
            labelEn: opt.labelEn,
            labelAm: opt.labelAm,
          },
        });
      }
    }
  }

  const count = await prisma.surveyQuestion.count();
  console.log(`✅ Successfully seeded ${count} official University of Gondar questions across 8 sections!`);
}

seed()
  .catch((e) => {
    console.error('Error seeding questions:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
