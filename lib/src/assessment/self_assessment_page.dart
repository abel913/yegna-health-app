import 'package:flutter/material.dart';

import 'module_assessment_dialog.dart';

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
    color: Color(0xFFDB2777),
  ),
  UogAssessmentSectionMeta(
    number: 6,
    sectionKey: 'section_6',
    moduleKey: 'gbv',
    titleEn: 'Sexual Consent, GBV and Safety',
    titleAm: 'የስምምነት፣ ጾታዊ ጥቃት እና ደህንነት',
    descriptionEn: 'Campus safety, non-consensual experiences, harassment, and reporting.',
    descriptionAm: 'የግቢ ደህንነት፣ ያለስምምነት የደረሰ ጥቃት፣ ትንኮሳ እና የሪፖርት አቀራረብ።',
    questionRangeEn: 'Q.35–Q.40',
    questionRangeAm: 'ጥያቄ 35–40',
    questionCount: 6,
    icon: Icons.shield_rounded,
    color: Color(0xFFEA580C),
  ),
  UogAssessmentSectionMeta(
    number: 7,
    sectionKey: 'section_7',
    moduleKey: 'mental_health',
    titleEn: 'Knowledge, Attitudes & Service Access',
    titleAm: 'ግንዛቤ፣ አመለካከት እና የአገልግሎት ተደራሽነት',
    descriptionEn: 'Campus clinic location, perception of confidentiality, and stigma barriers.',
    descriptionAm: 'የክሊኒክ ቦታ ዕውቀት፣ ሚስጥራዊነት እና የማህበራዊ መገለል ተግዳሮቶች።',
    questionRangeEn: 'Q.41–Q.44',
    questionRangeAm: 'ጥያቄ 41–44',
    questionCount: 4,
    icon: Icons.psychology_rounded,
    color: Color(0xFF2563EB),
  ),
  UogAssessmentSectionMeta(
    number: 8,
    sectionKey: 'section_8',
    moduleKey: 'support',
    titleEn: 'Support Needs & Service Preferences',
    titleAm: 'የድጋፍ ፍላጎት እና የአገልግሎት ምርጫዎች',
    descriptionEn: 'Preferred support services, counseling channels, and campus resources.',
    descriptionAm: 'ተመራጭ የድጋፍ አገልግሎቶች፣ የምክር መስጫ መንገዶች እና የዩኒቨርሲቲ ሀብቶች።',
    questionRangeEn: 'Q.45–Q.50',
    questionRangeAm: 'ጥያቄ 45–50',
    questionCount: 6,
    icon: Icons.support_agent_rounded,
    color: Color(0xFF059669),
  ),
];

class SelfAssessmentPage extends StatelessWidget {
  const SelfAssessmentPage({
    super.key,
    this.onOpenMentors,
    this.onOpenFacilities,
    this.onOpenLearning,
  });

  final VoidCallback? onOpenMentors;
  final VoidCallback? onOpenFacilities;
  final VoidCallback? onOpenLearning;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAmharic ? 'የስነ-ተዋልዶ ጤና ምዘና ማዕከል' : 'SRHR Self-Assessment Hub',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HERO BANNER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                      : [const Color(0xFF004D5A), const Color(0xFF00796B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified_rounded, color: Colors.white, size: 14),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                isAmharic ? 'የጎንደር ዩኒቨርሲቲ ይፋዊ መጠይቅ' : 'Official University of Gondar Tool',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isAmharic
                        ? 'የጾታዊ እና ስነ-ተዋልዶ ጤና ራስን መመዘኛ'
                        : 'SRHR Self-Assessment Suite',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isAmharic
                        ? 'በጎንደር ዩኒቨርሲቲ የጾታ እና ማህበራዊ አካታችነት ዳይሬክቶሬት የተዘጋጀ 8 ክፍሎች ያሉት ክሊኒካዊ ምዘና። መልሶችዎ 100% ሚስጥራዊ ናቸው።'
                        : 'Official clinical instrument by UoG Directorate of Gender & Social Inclusion. 50 questions across 8 sections. 100% confidential.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_outline_rounded, color: Colors.white70, size: 14),
                        const SizedBox(width: 8),
                        Text(
                          isAmharic ? 'ምንም የግል መታወቂያ አይቀመጥም (Zero-PII)' : 'Anonymous & Zero-PII Protected',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. SECTION LIST HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isAmharic ? 'የምዘና ክፍሎች (8 ክፍሎች)' : 'Assessment Sections (8 Total)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isAmharic ? '50 ጥያቄዎች' : '50 Questions',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // 3. SECTIONS ACCORDION / CARDS
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: kUogSections.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final sec = kUogSections[idx];
                final title = isAmharic ? sec.titleAm : sec.titleEn;
                final desc = isAmharic ? sec.descriptionAm : sec.descriptionEn;
                final range = isAmharic ? sec.questionRangeAm : sec.questionRangeEn;

                return Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        ModuleAssessmentDialog.show(
                          context,
                          sectionNumber: sec.number,
                          sectionKey: sec.sectionKey,
                          moduleKey: sec.moduleKey,
                          titleEn: sec.titleEn,
                          titleAm: sec.titleAm,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: sec.color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Icon(sec.icon, color: sec.color, size: 24),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: sec.color.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Section ${sec.number}',
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w800,
                                            color: sec.color,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '$range • ${sec.questionCount} ${isAmharic ? "ጥያቄዎች" : "Questions"}',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    desc,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                      height: 1.45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: sec.color.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(Icons.arrow_forward_rounded, color: sec.color, size: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
