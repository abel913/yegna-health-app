import '../models/assessment_result_data.dart';

/// Clinical result copy for Sections 2 through 5.
class AssessmentSectionsResultData {
  const AssessmentSectionsResultData._();

  static AssessmentResultData section2(String titleEn, String titleAm, AssessmentRiskTier tier) {
    final isHigh = tier == AssessmentRiskTier.higherRisk;
    return AssessmentResultData(
      sectionNumber: 2,
      sectionTitleEn: titleEn,
      sectionTitleAm: titleAm,
      headlineEn: isHigh ? 'Higher Risk for Sexual Health' : 'Moderate Sexual Health Risk',
      headlineAm: isHigh ? 'ከፍተኛ የጾታዊ ጤና ስጋት' : 'መካከለኛ የጾታዊ ጤና ስጋት',
      tier: tier,
      actionsEn: const [
        'Practice consistent condom and barrier protection during intercourse.',
        'Schedule a routine sexual health checkup at the campus clinic.',
        'Discuss mutual STI screening and protection openly with your partner.',
      ],
      actionsAm: const [
        'በእያንዳንዱ ግንኙነት ወቅት ኮንዶምን በትክክል እና ዘወትር ይጠቀሙ።',
        'በግቢው ክሊኒክ መደበኛ የጾታዊ ጤና ምርመራ ያድርጉ።',
        'ከአጋርዎ ጋር ስለ ምርመራ እና ደህንነት ግልጽ ውይይት ያድርጉ።',
      ],
      keyMessageEn: 'Understanding sexual risk factors is key to protecting your health and education. Consistent dual protection effectively prevents infections and unintended outcomes.',
      keyMessageAm: 'የጾታዊ ተጋላጭነት መንስኤዎችን ማወቅ ጤናዎን ለመጠበቅ ወሳኝ ነው። ጥንቃቄ ማድረግ ከበሽታዎች እና ካልታቀደ እርግዝና ይጠብቃል።',
    );
  }

  static AssessmentResultData section3(String titleEn, String titleAm, AssessmentRiskTier tier) {
    final isHigh = tier == AssessmentRiskTier.higherRisk;
    return AssessmentResultData(
      sectionNumber: 3,
      sectionTitleEn: titleEn,
      sectionTitleAm: titleAm,
      headlineEn: isHigh ? 'Higher Risk for HIV Infection' : 'Routine HIV Testing Recommended',
      headlineAm: isHigh ? 'ከፍተኛ የኤችአይቪ ተጋላጭነት ስጋት' : 'መደበኛ የኤችአይቪ ምርመራ ይመከራል',
      tier: tier,
      actionsEn: const [
        'Get tested for HIV immediately.',
        'Use condoms consistently and correctly.',
        'Actively participate in all peer learning sessions.',
      ],
      actionsAm: const [
        'በተቻለ ፍጥነት የኤችአይቪ ምርመራ ያድርጉ።',
        'ኮንዶምን ዘወትር እና በትክክል በእያንዳንዱ ግንኙነት ይጠቀሙ።',
        'በአቻ ለአቻ የትምህርት ክፍለ-ጊዜዎች በንቃት ይሳተፉ።',
      ],
      keyMessageEn: 'Having a high-risk score does not mean that you are infected with HIV. However, if risky behaviors continue, there is a possibility of acquiring HIV infection. Therefore, make strong efforts to reduce your level of HIV exposure risk.',
      keyMessageAm: 'ከፍተኛ የስጋት ውጤት ማግኘት ማለት በኤችአይቪ ተይዘዋል ማለት አይደለም። ይሁን እንጂ አደገኛ ባህሪያት ከቀጠሉ በቫይረሱ የመያዝ ዕድል ይኖራል። ስለዚህ የተጋላጭነት ደረጃዎን ለመቀነስ ጠንካራ ጥረት ያድርጉ።',
    );
  }

  static AssessmentResultData section4(String titleEn, String titleAm, AssessmentRiskTier tier) {
    return AssessmentResultData(
      sectionNumber: 4,
      sectionTitleEn: titleEn,
      sectionTitleAm: titleAm,
      headlineEn: 'Family Planning & Contraception Guidance',
      headlineAm: 'የቤተሰብ እቅድ እና የእርግዝና መከላከያ መመሪያ',
      tier: tier,
      actionsEn: const [
        'Visit the campus clinic for personalized contraceptive counseling.',
        'Adopt dual protection (condoms plus modern method) for maximum safety.',
        'Keep emergency contraception awareness and access in mind when needed.',
      ],
      actionsAm: const [
        'የእርግዝና መከላከያ አማራጮችን ለማወቅ የግቢውን ክሊኒክ ያማክሩ።',
        'ድርብ ጥበቃን (ኮንዶም እና ዘመናዊ መከላከያ ዘዴን) ይጠቀሙ።',
        'አስፈላጊ ሆኖ ሲገኝ ስለ ድንገተኛ የእርግዝና መከላከያ ግንዛቤ ይኑርዎት።',
      ],
      keyMessageEn: 'Modern family planning methods empower students to manage reproductive health confidently and pursue academic goals without interruption.',
      keyMessageAm: 'ዘመናዊ የእርግዝና መከላከያ ዘዴዎች ተማሪዎች የስነ-ተዋልዶ ጤናቸውን በልበ ሙሉነት እንዲቆጣጠሩ እና ትምህርታቸውን ያለ እንቅፋት እንዲከታተሉ ይረዳሉ።',
    );
  }

  static AssessmentResultData section5(String titleEn, String titleAm, AssessmentRiskTier tier) {
    return AssessmentResultData(
      sectionNumber: 5,
      sectionTitleEn: titleEn,
      sectionTitleAm: titleAm,
      headlineEn: 'Menstrual Health & Cycle Support',
      headlineAm: 'የወር አበባ ጤና እና የዑደት ድጋፍ',
      tier: tier,
      actionsEn: const [
        'Track your cycle days and symptoms in a private journal or app.',
        'Utilize campus female-friendly sanitary facilities when needed.',
        'Consult clinic staff if severe pain impacts your daily academic study.',
      ],
      actionsAm: const [
        'የወር አበባ ዑደትዎን እና ምልክቶችዎን በመደበኛነት ይከታተሉ።',
        'በግቢው ውስጥ የተዘጋጁ ለሴቶች ምቹ የንጽህና ቦታዎችን ይጠቀሙ።',
        'ከባድ የወር አበባ ህመም ትምህርትዎን የሚረብሽ ከሆነ ክሊኒክ ያማክሩ።',
      ],
      keyMessageEn: 'Menstrual health is normal and integral to well-being. Debilitating pain or persistent irregularity can be addressed with youth-friendly campus support.',
      keyMessageAm: 'የወር አበባ ጤና የተፈጥሮ ሂደት ነው። ከባድ ህመም ወይም መዛባት ካለ በግቢው ውስጥ በሚገኙ ባለሙያዎች ድጋፍ ማግኘት ይቻላል።',
    );
  }

  static AssessmentResultData section6(String tEn, String tAm, AssessmentRiskTier r) =>
      AssessmentSectionsSupportData.section6(tEn, tAm, r);
  static AssessmentResultData section7(String tEn, String tAm, AssessmentRiskTier r) =>
      AssessmentSectionsSupportData.section7(tEn, tAm, r);
  static AssessmentResultData section8(String tEn, String tAm, AssessmentRiskTier r) =>
      AssessmentSectionsSupportData.section8(tEn, tAm, r);
  static AssessmentResultData fallback(int n, String tEn, String tAm, AssessmentRiskTier r) =>
      AssessmentSectionsSupportData.fallback(n, tEn, tAm, r);
}

class AssessmentSectionsSupportData {
  const AssessmentSectionsSupportData._();

  static AssessmentResultData section6(String titleEn, String titleAm, AssessmentRiskTier tier) {
    return AssessmentResultData(
      sectionNumber: 6,
      sectionTitleEn: titleEn,
      sectionTitleAm: titleAm,
      headlineEn: 'Safety & Campus GBV Support Guidance',
      headlineAm: 'የደህንነት እና ጾታ-ተኮር ጥቃት ድጋፍ መመሪያ',
      tier: tier,
      actionsEn: const [
        'Reach out to the University Directorate of Gender & Social Inclusion.',
        'Save campus emergency hotline and focal person contacts on your phone.',
        'Access confidential psychological, legal, and medical assistance if needed.',
      ],
      actionsAm: const [
        'የዩኒቨርሲቲውን የጾታ እና ማህበራዊ አካታችነት ዳይሬክቶሬት ያነጋግሩ።',
        'የግቢውን የድንገተኛ አደጋ እና አስተባባሪዎች ስልክ ቁጥር ያስቀምጡ።',
        'ሚስጥራዊ የስነ-ልቦና፣ የህግ እና የህክምና ድጋፍ አገልግሎቶችን ያግኙ።',
      ],
      keyMessageEn: 'Your safety and personal boundaries are absolute rights. Confidential university focal persons and counselors are here to protect and support you.',
      keyMessageAm: 'ደህንነትዎ እና የግል ክብርዎ የተጠበቀ መብት ነው። ሚስጥራዊ የዩኒቨርሲቲው አስተባባሪዎች እርስዎን ለመርዳት ዝግጁ ናቸው።',
    );
  }

  static AssessmentResultData section7(String titleEn, String titleAm, AssessmentRiskTier tier) {
    return AssessmentResultData(
      sectionNumber: 7,
      sectionTitleEn: titleEn,
      sectionTitleAm: titleAm,
      headlineEn: 'Mental Well-Being & Stress Management',
      headlineAm: 'የአእምሮ ጤና እና የጭንቀት አያያዝ ድጋፍ',
      tier: tier,
      actionsEn: const [
        'Connect with a university student counselor or trusted peer mentor.',
        'Build daily stress relief habits and maintain positive social circles.',
        'Visit the student wellness clinic for private, stigma-free counseling.',
      ],
      actionsAm: const [
        'የዩኒቨርሲቲውን አማካሪ ወይም አቻ አስተባባሪ ያነጋግሩ።',
        'የጭንቀት ማስታገሻ ልምዶችን ያዳብሩ እና ከጓደኞች ጋር ይገናኙ።',
        'ለሚስጥራዊ የምክር አገልግሎት የተማሪዎች ጤና ማዕከልን ይጎብኙ።',
      ],
      keyMessageEn: 'Academic pressure can be overwhelming. Seeking guidance is a sign of resilience and campus counseling services are completely confidential.',
      keyMessageAm: 'የትምህርት ጫና በሚኖርበት ጊዜ የምክር ድጋፍ ማግኘት የብርታት ምልክት ነው። የግቢው የምክር አገልግሎት ሙሉ በሙሉ ሚስጥራዊ ነው።',
    );
  }

  static AssessmentResultData section8(String titleEn, String titleAm, AssessmentRiskTier tier) {
    return AssessmentResultData(
      sectionNumber: 8,
      sectionTitleEn: titleEn,
      sectionTitleAm: titleAm,
      headlineEn: 'Campus Health Services Utilization',
      headlineAm: 'የግቢው ጤና አገልግሎት ተጠቃሚነት',
      tier: tier,
      actionsEn: const [
        'Locate your campus primary clinic and note daily service hours.',
        'Take advantage of free preventative health and testing services.',
        'Engage with health mentors to learn about student health coverage.',
      ],
      actionsAm: const [
        'የግቢዎን ክሊኒክ መገኛ እና የአገልግሎት ሰዓት ይወቁ።',
        'በነጻ የሚሰጡ የቅድመ-መከላከያ እና የምርመራ አገልግሎቶችን ይጠቀሙ።',
        'ስለ ተማሪዎች የጤና ሽፋን ከአማካሪዎች ጋር ይወያዩ።',
      ],
      keyMessageEn: 'Campus health facilities are dedicated to supporting your student journey with free, private, and respectful clinical care.',
      keyMessageAm: 'የግቢው የጤና ተቋማት የተማሪዎችን ጉዞ በነጻ፣ በሚስጥራዊ እና በአክብሮት በተሞላ የህክምና አገልግሎት ለመደገፍ የተዘጋጁ ናቸው።',
    );
  }

  static AssessmentResultData fallback(int n, String titleEn, String titleAm, AssessmentRiskTier tier) {
    return AssessmentSectionsResultData.section3(titleEn, titleAm, tier);
  }
}
