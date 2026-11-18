import 'dart:convert';
import '../../src/clubs/club_models.dart';

/// Serialization adapter for student club offline caching.
class ClubOfflineAdapter {
  static StudentClub fromBackendMap(Map<String, dynamic> map) {
    final catStr = (map['category'] as String? ?? '').toLowerCase();
    ClubCategory category = ClubCategory.srhWellness;
    if (catStr.contains('mental')) {
      category = ClubCategory.mentalHealth;
    } else if (catStr.contains('substance')) {
      category = ClubCategory.antiSubstance;
    } else if (catStr.contains('aid')) {
      category = ClubCategory.firstAid;
    } else if (catStr.contains('hygiene') || catStr.contains('girl')) {
      category = ClubCategory.girlsHygiene;
    } else if (catStr.contains('leader')) {
      category = ClubCategory.peerLeadership;
    }

    final name = map['name'] as String? ?? 'Student Club';
    final desc =
        map['description'] as String? ?? 'Youth health engagement club';
    final venue = map['venue'] as String? ?? 'Youth Center';
    final meetingTime = map['meetingTime'] as String? ?? 'Saturdays 10:00 AM';
    final mentorContact = map['mentorContact'] as String? ??
        map['counselorPhone'] as String? ??
        map['phone'] as String? ??
        '+251 91 123 4567';

    List<String> rulesList = const [
      'Maintain 100% confidentiality and respect peer privacy.',
      'Create an inclusive, judgment-free safe space.',
      'Active participation and support for all members.',
    ];

    if (map['rules'] is List) {
      rulesList = (map['rules'] as List).map((e) => e.toString()).toList();
    } else if (map['guidelines'] is List) {
      rulesList =
          (map['guidelines'] as List).map((e) => e.toString()).toList();
    } else if (map['rules'] is String && (map['rules'] as String).isNotEmpty) {
      try {
        final decoded = jsonDecode(map['rules'] as String);
        if (decoded is List) {
          rulesList = decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {}
    }

    return StudentClub(
      id: map['id']?.toString() ??
          'club_${DateTime.now().millisecondsSinceEpoch}',
      nameEn: name,
      nameAm: map['nameAm'] as String? ?? name,
      descriptionEn: desc,
      descriptionAm: map['descriptionAm'] as String? ?? desc,
      category: category,
      meetingScheduleEn: meetingTime,
      meetingScheduleAm: map['meetingScheduleAm'] as String? ?? 'ቅዳሜ ከጠዋቱ 4:00',
      meetingLocationEn: venue,
      meetingLocationAm: map['meetingLocationAm'] as String? ?? venue,
      mentorNameEn: map['mentorName'] as String? ?? 'Certified Peer Counselor',
      mentorNameAm: map['mentorNameAm'] as String? ?? 'የተረጋገጠ አቻ አማካሪ',
      mentorContact: mentorContact,
      memberCount: map['memberCount'] as int? ?? 0,
      rulesEn: rulesList,
      rulesAm: rulesList,
      isActive: map['isApproved'] as bool? ?? true,
      createdAt: DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
