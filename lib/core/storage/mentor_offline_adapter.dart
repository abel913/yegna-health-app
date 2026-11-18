import 'package:flutter/material.dart';

import '../../src/discovery/mentor_model.dart';

/// Serialization adapters for caching mentors offline.
class MentorOfflineAdapter {
  static Map<String, dynamic> toMap(Mentor m) => {
        'id': m.id,
        'nameEn': m.nameEn,
        'nameAm': m.nameAm,
        'titleEn': m.titleEn,
        'titleAm': m.titleAm,
        'organizationEn': m.organizationEn,
        'organizationAm': m.organizationAm,
        'bioEn': m.bioEn,
        'bioAm': m.bioAm,
        'isVerified': m.isVerified,
        'isOnline': m.isOnline,
        'nextAvailableSlotEn': m.nextAvailableSlotEn,
        'nextAvailableSlotAm': m.nextAvailableSlotAm,
        'languages': m.languages,
        'topics': m.topics.map((t) => t.name).toList(),
        'sessionsCount': m.sessionsCount,
        'experienceYears': m.experienceYears,
        'initials': m.initials,
        'avatarColor': m.avatarColor.toARGB32(),
        'phoneNumber': m.phoneNumber,
        'displayPhoneNumber': m.displayPhoneNumber,
        'telegramHandle': m.telegramHandle,
        'whatsapp': m.whatsapp,
        'email': m.email,
        'campus': m.campus,
        'workingHoursEn': m.workingHoursEn,
        'workingHoursAm': m.workingHoursAm,
        'safeguardingPolicyEn': m.safeguardingPolicyEn,
        'safeguardingPolicyAm': m.safeguardingPolicyAm,
        'weeklySchedule': m.weeklySchedule?.map((k, v) => MapEntry(k, v.toJson())),
      };

  static Mentor fromMap(Map<String, dynamic> map) {
    final rawName = map['name'] as String?;
    final nameEn = map['nameEn'] as String? ?? rawName ?? 'Peer Counselor';
    final nameAm = map['nameAm'] as String? ?? rawName ?? 'አቻ አማካሪ';

    final rawOrg = map['organization'] as String?;
    final organizationEn =
        map['organizationEn'] as String? ?? rawOrg ?? 'Youth Health Initiative';
    final organizationAm =
        map['organizationAm'] as String? ?? rawOrg ?? 'የወጣቶች ጤና ጥረት';

    final isAvailable =
        map['isAvailable'] as bool? ?? map['isOnline'] as bool? ?? true;
    final isVerified = map['isVerified'] as bool? ?? true;

    final topicsSet = <MentorTopic>{};
    final rawTopics = (map['topics'] ?? map['specialties']) as List<dynamic>?;
    if (rawTopics != null) {
      for (final t in rawTopics) {
        final str = t.toString().toLowerCase();
        if (str.contains('mental')) topicsSet.add(MentorTopic.mentalHealth);
        if (str.contains('srh') || str.contains('reproduct')) {
          topicsSet.add(MentorTopic.srhGuidance);
        }
        if (str.contains('pubert')) topicsSet.add(MentorTopic.puberty);
        if (str.contains('substance') || str.contains('addict')) {
          topicsSet.add(MentorTopic.substanceAbuse);
        }
      }
    }
    if (topicsSet.isEmpty) {
      topicsSet.addAll([MentorTopic.mentalHealth, MentorTopic.srhGuidance]);
    }

    final langs = (map['languages'] as List<dynamic>?)
            ?.map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList() ??
        ['Amharic', 'English'];

    String initials = map['initials'] as String? ?? '';
    if (initials.isEmpty) {
      final parts = nameEn.trim().split(RegExp(r'\s+'));
      if (parts.length >= 2) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
        initials = parts[0][0].toUpperCase();
      } else {
        initials = 'YC';
      }
    }

    final colorVal = map['avatarColor'] as int?;
    final avatarColor =
        colorVal != null ? Color(colorVal) : const Color(0xFF0284C7);

    final phone = map['phoneNumber'] as String? ??
        map['phone'] as String? ??
        '+251911234567';

    Map<String, DayAvailability>? weeklySchedule;
    final rawSched = map['weeklySchedule'];
    if (rawSched is Map) {
      weeklySchedule = {};
      rawSched.forEach((key, val) {
        if (val is Map) {
          weeklySchedule![key.toString().toLowerCase()] =
              DayAvailability.fromJson(Map<String, dynamic>.from(val));
        }
      });
    }

    return Mentor(
      id: map['id']?.toString() ?? 'men_${DateTime.now().millisecondsSinceEpoch}',
      nameEn: nameEn,
      nameAm: nameAm,
      titleEn: map['roleTitleEn'] as String? ?? map['titleEn'] as String? ?? 'Certified Youth Peer Counselor',
      titleAm: map['roleTitleAm'] as String? ?? map['titleAm'] as String? ?? 'የተረጋገጠ የወጣቶች አቻ አማካሪ',
      organizationEn: organizationEn,
      organizationAm: organizationAm,
      campus: map['campus'] as String? ?? 'Atse Fasil Campus',
      whatsapp: map['whatsapp'] as String?,
      email: map['email'] as String?,
      bioEn: map['bioEn'] as String? ??
          'Certified youth mentor offering confidential, stigma-free guidance on emotional wellness and health.',
      bioAm: map['bioAm'] as String? ??
          'ሚስጥራዊ፣ ነፃ እና ፍረጃ የሌለበት የስነ-ልቦና እና የስነ-ተዋልዶ ጤና የምክር አገልግሎት የሚሰጥ የተረጋገጠ አቻ አማካሪ።',
      isVerified: isVerified,
      isOnline: isAvailable,
      nextAvailableSlotEn: isAvailable ? 'Available Now' : 'Available Tomorrow',
      nextAvailableSlotAm: isAvailable ? 'አሁን ይገኛሉ' : 'ነገ ይገኛሉ',
      languages: langs,
      topics: topicsSet.toList(),
      sessionsCount: map['sessionsCount'] is num
          ? (map['sessionsCount'] as num).toInt()
          : 120,
      experienceYears: map['experienceYears'] is num
          ? (map['experienceYears'] as num).toInt()
          : 2,
      initials: initials,
      avatarColor: avatarColor,
      phoneNumber: phone,
      displayPhoneNumber: map['displayPhoneNumber'] as String? ?? phone,
      telegramHandle: map['telegramHandle'] as String? ?? 'yegna_youth_support',
      workingHoursEn:
          map['workingHoursEn'] as String? ?? 'Mon – Fri: 8:30 AM – 5:30 PM',
      workingHoursAm:
          map['workingHoursAm'] as String? ?? 'ከሰኞ – ዓርብ፡ 2:30 – 11:30',
      weeklySchedule: weeklySchedule,
    );
  }
}
