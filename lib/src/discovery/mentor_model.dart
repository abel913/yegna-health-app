import 'package:flutter/material.dart';

enum MentorTopic {
  all,
  mentalHealth,
  srhGuidance,
  puberty,
  substanceAbuse,
}

class Mentor {
  const Mentor({
    required this.id,
    required this.nameEn,
    required this.nameAm,
    required this.titleEn,
    required this.titleAm,
    required this.organizationEn,
    required this.organizationAm,
    required this.bioEn,
    required this.bioAm,
    required this.isVerified,
    required this.isOnline,
    required this.nextAvailableSlotEn,
    required this.nextAvailableSlotAm,
    required this.languages,
    required this.topics,
    required this.sessionsCount,
    required this.experienceYears,
    required this.initials,
    required this.avatarColor,
    this.phoneNumber = '+251911234567',
    this.displayPhoneNumber = '+251 91 123 4567',
    this.telegramHandle = 'yegna_youth_support',
    this.workingHoursEn = 'Mon – Fri: 8:30 AM – 5:30 PM',
    this.workingHoursAm = 'ከሰኞ – ዓርብ፡ 2:30 – 11:30',
    this.safeguardingPolicyEn =
        'Strictly confidential peer counseling. Peer mentors follow certified national child and youth protection safeguarding guidelines. All conversations remain private and non-judgmental.',
    this.safeguardingPolicyAm =
        'በጥብቅ ሚስጥራዊ የአቻ ምክክር። አቻ አማካሪዎች የተረጋገጡ ብሔራዊ የህፃናትና ወጣቶች ጥበቃ መመሪያዎችን ይከተላሉ። ሁሉም ውይይቶች ሚስጥራዊ እና ከፍረጃ ነፃ ናቸው።',
  });

  final String id;
  final String nameEn;
  final String nameAm;
  final String titleEn;
  final String titleAm;
  final String organizationEn;
  final String organizationAm;
  final String bioEn;
  final String bioAm;
  final bool isVerified;
  final bool isOnline;
  final String nextAvailableSlotEn;
  final String nextAvailableSlotAm;
  final List<String> languages;
  final List<MentorTopic> topics;
  final int sessionsCount;
  final int experienceYears;
  final String initials;
  final Color avatarColor;
  final String phoneNumber;
  final String displayPhoneNumber;
  final String telegramHandle;
  final String workingHoursEn;
  final String workingHoursAm;
  final String safeguardingPolicyEn;
  final String safeguardingPolicyAm;

  String localizedName(bool isAmharic) => isAmharic ? nameAm : nameEn;
  String localizedTitle(bool isAmharic) => isAmharic ? titleAm : titleEn;
  String localizedOrg(bool isAmharic) =>
      isAmharic ? organizationAm : organizationEn;
  String localizedBio(bool isAmharic) => isAmharic ? bioAm : bioEn;
  String localizedNextSlot(bool isAmharic) =>
      isAmharic ? nextAvailableSlotAm : nextAvailableSlotEn;
  String localizedPolicy(bool isAmharic) =>
      isAmharic ? safeguardingPolicyAm : safeguardingPolicyEn;
  String localizedWorkingHours(bool isAmharic) =>
      isAmharic ? workingHoursAm : workingHoursEn;
}
