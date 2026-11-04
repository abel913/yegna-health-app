import 'package:flutter/material.dart';

import 'mentor_model.dart';

abstract class MentorRepository {
  Future<List<Mentor>> getMentors({
    String? query,
    MentorTopic? topic,
    String? language,
    bool? onlineOnly,
  });
}

class UnconfiguredMentorRepository implements MentorRepository {
  const UnconfiguredMentorRepository();

  @override
  Future<List<Mentor>> getMentors({
    String? query,
    MentorTopic? topic,
    String? language,
    bool? onlineOnly,
  }) async =>
      const [];
}

class LocalVerifiedMentorRepository implements MentorRepository {
  const LocalVerifiedMentorRepository();

  static const List<Mentor> _verifiedMentors = [
    Mentor(
      id: 'selamawit_tadesse',
      nameEn: 'Selamawit Tadesse',
      nameAm: 'ሰላማዊት ታደሰ',
      titleEn: 'Certified Youth Peer Counselor',
      titleAm: 'የተረጋገጠች የወጣቶች አቻ አማካሪ',
      organizationEn: 'Talent Youth Association (TYA)',
      organizationAm: 'ታለንት የወጣቶች ማህበር',
      bioEn:
          'Passionate youth mentor offering confidential, stigma-free guidance on adolescent reproductive health, exam stress, and emotional wellness.',
      bioAm:
          'በአፍላ ወጣቶች ስነ-ተዋልዶ ጤና፣ የፈተና ጭንቀት አያያዝ እና ስሜታዊ ጤንነት ላይ ሚስጥራዊ እና ከፍረጃ ነፃ የሆነ የአቻ ድጋፍ የምትሰጥ ታታሪ አማካሪ።',
      isVerified: true,
      isOnline: true,
      nextAvailableSlotEn: 'Available Now',
      nextAvailableSlotAm: 'አሁን ይገኛሉ',
      languages: ['Amharic', 'English'],
      topics: [
        MentorTopic.mentalHealth,
        MentorTopic.srhGuidance,
        MentorTopic.puberty,
      ],
      sessionsCount: 320,
      experienceYears: 3,
      initials: 'ST',
      avatarColor: Color(0xFF0284C7),
      phoneNumber: '+251911234567',
      displayPhoneNumber: '+251 91 123 4567',
      telegramHandle: 'selam_tya_peer',
      workingHoursEn: 'Mon – Fri: 8:30 AM – 5:30 PM',
      workingHoursAm: 'ከሰኞ – ዓርብ፡ 2:30 – 11:30',
    ),
    Mentor(
      id: 'dawit_haile',
      nameEn: 'Dawit Haile',
      nameAm: 'ዳዊት ኃይሌ',
      titleEn: 'Adolescent Life & Health Coach',
      titleAm: 'የአፍላ ዕድሜ ህይወት እና ጤና አሰልጣኝ',
      organizationEn: 'Ethiopian Red Cross Youth',
      organizationAm: 'የኢትዮጵያ ቀይ መስቀል ወጣቶች',
      bioEn:
          'Trained peer educator helping adolescents overcome negative peer pressure, navigate healthy lifestyle choices, and resist substance abuse.',
      bioAm:
          'ወጣቶች አሉታዊ የአቻ ግፊትን እንዲቋቋሙ፣ ጤናማ የአኗኗር ዘይቤ እንዲከተሉ እና ከዕፅ ሱስ እንዲጠበቁ የሚያግዝ የሰለጠነ አቻ አስተማሪ።',
      isVerified: true,
      isOnline: false,
      nextAvailableSlotEn: 'Today at 3:00 PM',
      nextAvailableSlotAm: 'ዛሬ ከቀኑ 9:00',
      languages: ['Amharic', 'Afaan Oromoo', 'English'],
      topics: [
        MentorTopic.substanceAbuse,
        MentorTopic.mentalHealth,
      ],
      sessionsCount: 215,
      experienceYears: 2,
      initials: 'DH',
      avatarColor: Color(0xFF059669),
      phoneNumber: '+251922345678',
      displayPhoneNumber: '+251 92 234 5678',
      telegramHandle: 'dawit_redcross_youth',
      workingHoursEn: 'Mon – Sat: 9:00 AM – 6:00 PM',
      workingHoursAm: 'ከሰኞ – ቅዳሜ፡ 3:00 – 12:00',
    ),
    Mentor(
      id: 'hana_girma',
      nameEn: 'Hana Girma',
      nameAm: 'ሀና ግርማ',
      titleEn: 'Campus SRH Peer Educator',
      titleAm: 'የዩኒቨርሲቲ ስነ-ተዋልዶ አቻ አስተማሪ',
      organizationEn: 'AAU Peer Educators Network',
      organizationAm: 'የአዲስ አበባ ዩኒቨርሲቲ አቻ አስተማሪዎች',
      bioEn:
          'University campus leader providing young women and men safe, accurate guidance on puberty changes, menstrual health, and STI awareness.',
      bioAm:
          'ለተማሪዎችና ለወጣቶች ስለ ጉርምስና ለውጦች፣ የወር አበባ ንፅህና አጠባበቅ እና የአባለዘር በሽታዎች ግንዛቤ አስተማማኝ ትምህርት የምትሰጥ የካምፓስ መሪ።',
      isVerified: true,
      isOnline: true,
      nextAvailableSlotEn: 'Available Now',
      nextAvailableSlotAm: 'አሁን ይገኛሉ',
      languages: ['Amharic', 'English'],
      topics: [
        MentorTopic.srhGuidance,
        MentorTopic.puberty,
      ],
      sessionsCount: 410,
      experienceYears: 4,
      initials: 'HG',
      avatarColor: Color(0xFF7C3AED),
      phoneNumber: '+251933456789',
      displayPhoneNumber: '+251 93 345 6789',
      telegramHandle: 'hana_aau_peer',
      workingHoursEn: 'Mon – Fri: 8:00 AM – 5:00 PM',
      workingHoursAm: 'ከሰኞ – ዓርብ፡ 2:00 – 11:00',
    ),
    Mentor(
      id: 'yohannes_bekele',
      nameEn: 'Yohannes Bekele',
      nameAm: 'ዮሐንስ በቀለ',
      titleEn: 'Youth Mental Wellbeing Mentor',
      titleAm: 'የወጣቶች አእምሮ ጤንነት አማካሪ',
      organizationEn: 'Mental Health Ethiopia Youth Wing',
      organizationAm: 'የኢትዮጵያ አእምሮ ጤና የወጣቶች ዘርፍ',
      bioEn:
          'Active listener and youth advocate promoting positive self-esteem, healthy coping mechanisms, and emotional resilience for students.',
      bioAm:
          'የወጣቶችን በራስ መተማመን የሚያበረታታ፣ ስሜታዊ ጥንካሬን የሚያዳብር እና ለጭንቀት አያያዝ አጋዥ የሆነ አማካሪ።',
      isVerified: true,
      isOnline: false,
      nextAvailableSlotEn: 'Tomorrow at 10:00 AM',
      nextAvailableSlotAm: 'ነገ ጠዋት 4:00',
      languages: ['Amharic', 'Tigrinya', 'English'],
      topics: [
        MentorTopic.mentalHealth,
      ],
      sessionsCount: 185,
      experienceYears: 2,
      initials: 'YB',
      avatarColor: Color(0xFFD97706),
      phoneNumber: '+251944567890',
      displayPhoneNumber: '+251 94 456 7890',
      telegramHandle: 'yohannes_mhe_peer',
      workingHoursEn: 'Mon – Fri: 9:00 AM – 5:30 PM',
      workingHoursAm: 'ከሰኞ – ዓርብ፡ 3:00 – 11:30',
    ),
    Mentor(
      id: 'bethelhem_alemu',
      nameEn: 'Bethelhem Alemu',
      nameAm: 'ቤተልሔም አለሙ',
      titleEn: 'Adolescent Wellness & Peer Support',
      titleAm: 'የአፍላ ወጣቶች ደህንነት እና አቻ ድጋፍ',
      organizationEn: 'DKT Ethiopia Youth Ambassadors',
      organizationAm: 'ዲ.ኬ.ቲ ኢትዮጵያ የወጣቶች አምባሳደሮች',
      bioEn:
          'Committed youth advocate helping teenagers build healthy relationships, make informed decisions, and understand adolescent physiology.',
      bioAm:
          'ወጣቶች ጤናማ ግንኙነት እንዲገነቡ፣ ትክክለኛ ውሳኔ እንዲያደርጉ እና ስለ ሰውነታቸው ለውጥ በቂ እውቀት እንዲኖራቸው የምትደግፍ ታታሪ ወጣት።',
      isVerified: true,
      isOnline: true,
      nextAvailableSlotEn: 'Available Now',
      nextAvailableSlotAm: 'አሁን ይገኛሉ',
      languages: ['Amharic', 'English'],
      topics: [
        MentorTopic.srhGuidance,
        MentorTopic.puberty,
        MentorTopic.substanceAbuse,
      ],
      sessionsCount: 280,
      experienceYears: 3,
      initials: 'BA',
      avatarColor: Color(0xFF0D9488),
      phoneNumber: '+251955678901',
      displayPhoneNumber: '+251 95 567 8901',
      telegramHandle: 'betty_dkt_ambassador',
      workingHoursEn: 'Mon – Sat: 8:30 AM – 5:00 PM',
      workingHoursAm: 'ከሰኞ – ቅዳሜ፡ 2:30 – 11:00',
    ),
  ];

  @override
  Future<List<Mentor>> getMentors({
    String? query,
    MentorTopic? topic,
    String? language,
    bool? onlineOnly,
  }) async {
    var result = List<Mentor>.from(_verifiedMentors);

    if (onlineOnly == true) {
      result = result.where((m) => m.isOnline).toList();
    }

    if (topic != null && topic != MentorTopic.all) {
      result = result.where((m) => m.topics.contains(topic)).toList();
    }

    if (language != null && language.isNotEmpty && language != 'All') {
      result = result.where((m) => m.languages.contains(language)).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final clean = query.trim().toLowerCase();
      result = result.where((m) {
        final matchEn = m.nameEn.toLowerCase().contains(clean) ||
            m.organizationEn.toLowerCase().contains(clean) ||
            m.bioEn.toLowerCase().contains(clean) ||
            m.telegramHandle.toLowerCase().contains(clean) ||
            m.phoneNumber.contains(clean) ||
            m.displayPhoneNumber.contains(clean) ||
            m.languages.any((l) => l.toLowerCase().contains(clean));
        final matchAm = m.nameAm.contains(clean) ||
            m.organizationAm.contains(clean) ||
            m.bioAm.contains(clean);
        return matchEn || matchAm;
      }).toList();
    }

    return result;
  }
}

class DynamicMentorRepository implements MentorRepository {
  const DynamicMentorRepository({
    this.customMentorsProvider,
    this.fallback = const LocalVerifiedMentorRepository(),
  });

  final Future<List<Mentor>> Function()? customMentorsProvider;
  final MentorRepository fallback;

  @override
  Future<List<Mentor>> getMentors({
    String? query,
    MentorTopic? topic,
    String? language,
    bool? onlineOnly,
  }) async {
    final base = await fallback.getMentors(
      query: query,
      topic: topic,
      language: language,
      onlineOnly: onlineOnly,
    );
    if (fallback is UnconfiguredMentorRepository) {
      return base;
    }
    if (customMentorsProvider == null) return base;
    try {
      final custom = await customMentorsProvider!();
      final ids = base.map((m) => m.id).toSet();
      final extras = custom.where((m) => !ids.contains(m.id)).toList();
      return [...base, ...extras];
    } catch (_) {
      return base;
    }
  }
}
