import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../clubs/club_models.dart';
import '../discovery/facility_model.dart';
import '../discovery/mentor_model.dart';

/// Persistent local storage engine for offline caching of all remote datasets.
/// Ensures zero blank screens and instant offline loading.
class OfflineSyncStore {
  OfflineSyncStore({SharedPreferences? preferences})
      : _preferences = preferences;

  SharedPreferences? _preferences;

  static const _facilitiesKey = 'yegna_offline_facilities_v1';
  static const _mentorsKey = 'yegna_offline_mentors_v1';
  static const _modulesKey = 'yegna_offline_modules_v1';
  static const _quizzesKey = 'yegna_offline_quizzes_v1';
  static const _clubsKey = 'yegna_offline_clubs_v1';
  static const _metaKey = 'yegna_offline_sync_meta_v1';

  Future<SharedPreferences> _getPrefs() async {
    if (_preferences != null) return _preferences!;
    _preferences = await SharedPreferences.getInstance();
    return _preferences!;
  }

  // ==========================================
  // FACILITIES CACHE
  // ==========================================

  Future<List<Facility>?> getCachedFacilities() async {
    try {
      final prefs = await _getPrefs();
      final jsonStr = prefs.getString(_facilitiesKey);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .map((e) => facilityFromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveFacilities(List<Facility> facilities) async {
    try {
      final prefs = await _getPrefs();
      final list = facilities.map(facilityToMap).toList();
      await prefs.setString(_facilitiesKey, jsonEncode(list));
      await _recordSyncTimestamp('facilities');
    } catch (_) {}
  }

  // ==========================================
  // MENTORS CACHE
  // ==========================================

  Future<List<Mentor>?> getCachedMentors() async {
    try {
      final prefs = await _getPrefs();
      final jsonStr = prefs.getString(_mentorsKey);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .map((e) => mentorFromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveMentors(List<Mentor> mentors) async {
    try {
      final prefs = await _getPrefs();
      final list = mentors.map(mentorToMap).toList();
      await prefs.setString(_mentorsKey, jsonEncode(list));
      await _recordSyncTimestamp('mentors');
    } catch (_) {}
  }

  // ==========================================
  // STUDENT CLUBS CACHE
  // ==========================================

  Future<List<StudentClub>?> getCachedClubs() async {
    try {
      final prefs = await _getPrefs();
      final jsonStr = prefs.getString(_clubsKey);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .map((e) =>
              StudentClub.fromJson(Map<String, Object?>.from(e as Map)))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveClubs(List<StudentClub> clubs) async {
    try {
      final prefs = await _getPrefs();
      final list = clubs.map((c) => c.toJson()).toList();
      await prefs.setString(_clubsKey, jsonEncode(list));
      await _recordSyncTimestamp('clubs');
    } catch (_) {}
  }

  // ==========================================
  // MODULES & QUIZZES CACHE (RAW JSON)
  // ==========================================

  Future<List<Map<String, dynamic>>?> getCachedModules() async {
    try {
      final prefs = await _getPrefs();
      final jsonStr = prefs.getString(_modulesKey);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveModules(List<Map<String, dynamic>> modules) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setString(_modulesKey, jsonEncode(modules));
      await _recordSyncTimestamp('modules');
    } catch (_) {}
  }

  Future<List<Map<String, dynamic>>?> getCachedQuizzes() async {
    try {
      final prefs = await _getPrefs();
      final jsonStr = prefs.getString(_quizzesKey);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveQuizzes(List<Map<String, dynamic>> quizzes) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setString(_quizzesKey, jsonEncode(quizzes));
      await _recordSyncTimestamp('quizzes');
    } catch (_) {}
  }

  // ==========================================
  // SYNC METADATA & TIMESTAMPS
  // ==========================================

  Future<DateTime?> getLastSyncTime([String entity = 'all']) async {
    try {
      final prefs = await _getPrefs();
      final metaStr = prefs.getString(_metaKey);
      if (metaStr == null) return null;
      final map = jsonDecode(metaStr) as Map<String, dynamic>;
      final timeStr = map[entity] as String? ?? map['all'] as String?;
      return timeStr != null ? DateTime.tryParse(timeStr) : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _recordSyncTimestamp(String entity) async {
    try {
      final prefs = await _getPrefs();
      final metaStr = prefs.getString(_metaKey);
      final map = metaStr != null
          ? Map<String, dynamic>.from(jsonDecode(metaStr) as Map)
          : <String, dynamic>{};
      final now = DateTime.now().toIso8601String();
      map[entity] = now;
      map['all'] = now;
      await prefs.setString(_metaKey, jsonEncode(map));
    } catch (_) {}
  }

  Future<void> clearAllCache() async {
    try {
      final prefs = await _getPrefs();
      await prefs.remove(_facilitiesKey);
      await prefs.remove(_mentorsKey);
      await prefs.remove(_modulesKey);
      await prefs.remove(_quizzesKey);
      await prefs.remove(_clubsKey);
      await prefs.remove(_metaKey);
    } catch (_) {}
  }

  // ==========================================
  // SAFE MODEL SERIALIZATION ADAPTERS
  // ==========================================

  static Map<String, dynamic> facilityToMap(Facility f) => {
        'id': f.id,
        'nameEn': f.nameEn,
        'nameAm': f.nameAm,
        'subCityEn': f.subCityEn,
        'subCityAm': f.subCityAm,
        'addressEn': f.addressEn,
        'addressAm': f.addressAm,
        'landmarkEn': f.landmarkEn,
        'landmarkAm': f.landmarkAm,
        'phone': f.phone,
        'type': f.type.name,
        'latitude': f.latitude,
        'longitude': f.longitude,
        'distanceKm': f.distanceKm,
        'isYouthFriendly': f.isYouthFriendly,
        'isFreeForYouth': f.isFreeForYouth,
        'openingHour': f.openingHour,
        'closingHour': f.closingHour,
        'services': f.services,
        'campusNameEn': f.campusNameEn,
        'campusNameAm': f.campusNameAm,
        'confidentialityPolicyEn': f.confidentialityPolicyEn,
        'confidentialityPolicyAm': f.confidentialityPolicyAm,
      };

  static Facility facilityFromMap(Map<String, dynamic> map) {
    // Determine if parsing from Backend REST API or Internal Cache
    final subCityRaw = map['subCity'] as String?;
    final subCityEn = map['subCityEn'] as String? ??
        (subCityRaw != null ? '$subCityRaw Sub-City' : 'Addis Ababa');
    final subCityAm = map['subCityAm'] as String? ??
        (subCityRaw != null ? '$subCityRaw ክፍለ ከተማ' : 'አዲስ አበባ');

    // Parse operating hours if provided as "08:00 - 18:00"
    int openingHour = map['openingHour'] as int? ?? 8;
    int closingHour = map['closingHour'] as int? ?? 18;
    final hoursStr = map['operatingHours'] as String?;
    if (hoursStr != null && hoursStr.contains('-')) {
      final parts = hoursStr.split('-');
      if (parts.length == 2) {
        final start = int.tryParse(parts[0].trim().split(':')[0]);
        final end = int.tryParse(parts[1].trim().split(':')[0]);
        if (start != null) openingHour = start;
        if (end != null) closingHour = end;
      }
    }

    final servicesList = (map['services'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>[];

    final typeStr = map['type'] as String? ?? '';
    final type = FacilityType.values.firstWhere(
      (t) => t.name == typeStr,
      orElse: () => FacilityType.youthCenter,
    );

    return Facility(
      id: map['id']?.toString() ?? 'fac_${DateTime.now().millisecondsSinceEpoch}',
      nameEn: map['nameEn'] as String? ?? 'Youth Health Clinic',
      nameAm: map['nameAm'] as String? ?? 'የወጣቶች ጤና ክሊኒክ',
      subCityEn: subCityEn,
      subCityAm: subCityAm,
      addressEn: map['addressEn'] as String? ?? 'Addis Ababa, Ethiopia',
      addressAm: map['addressAm'] as String? ?? 'አዲስ አበባ፣ ኢትዮጵያ',
      landmarkEn: map['landmarkEn'] as String? ?? '',
      landmarkAm: map['landmarkAm'] as String? ?? '',
      phone: map['phone'] as String? ?? '+251-11-000-0000',
      type: type,
      latitude: (map['latitude'] as num?)?.toDouble() ?? 9.0300,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 38.7400,
      distanceKm: (map['distanceKm'] as num?)?.toDouble() ?? 1.5,
      isYouthFriendly: map['isYouthFriendly'] as bool? ?? true,
      isFreeForYouth: map['isFreeForYouth'] as bool? ?? true,
      openingHour: openingHour,
      closingHour: closingHour,
      services: servicesList,
      campusNameEn: map['campusNameEn'] as String?,
      campusNameAm: map['campusNameAm'] as String?,
    );
  }

  static Map<String, dynamic> mentorToMap(Mentor m) => {
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
        'workingHoursEn': m.workingHoursEn,
        'workingHoursAm': m.workingHoursAm,
        'safeguardingPolicyEn': m.safeguardingPolicyEn,
        'safeguardingPolicyAm': m.safeguardingPolicyAm,
      };

  static Mentor mentorFromMap(Map<String, dynamic> map) {
    final rawName = map['name'] as String?;
    final nameEn = map['nameEn'] as String? ?? rawName ?? 'Peer Counselor';
    final nameAm = map['nameAm'] as String? ?? rawName ?? 'አቻ አማካሪ';

    final rawOrg = map['organization'] as String?;
    final organizationEn =
        map['organizationEn'] as String? ?? rawOrg ?? 'Youth Health Initiative';
    final organizationAm =
        map['organizationAm'] as String? ?? rawOrg ?? 'የወጣቶች ጤና ጥረት';

    final isAvailable = map['isAvailable'] as bool? ?? map['isOnline'] as bool? ?? true;
    final isVerified = map['isVerified'] as bool? ?? true;

    // Parse topics from specialties or stored topic names
    final topicsList = <MentorTopic>[];
    final rawTopics = (map['topics'] ?? map['specialties']) as List<dynamic>?;
    if (rawTopics != null) {
      for (final t in rawTopics) {
        final str = t.toString().toLowerCase();
        if (str.contains('mental')) topicsList.add(MentorTopic.mentalHealth);
        if (str.contains('srh') || str.contains('reproduct')) {
          topicsList.add(MentorTopic.srhGuidance);
        }
        if (str.contains('pubert')) topicsList.add(MentorTopic.puberty);
        if (str.contains('substance') || str.contains('addict')) {
          topicsList.add(MentorTopic.substanceAbuse);
        }
      }
    }
    if (topicsList.isEmpty) {
      topicsList.addAll([MentorTopic.mentalHealth, MentorTopic.srhGuidance]);
    }

    final langs = (map['languages'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        ['Amharic', 'English'];

    // Generate initials
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

    // Avatar color
    final colorVal = map['avatarColor'] as int?;
    final avatarColor = colorVal != null
        ? Color(colorVal)
        : const Color(0xFF0284C7);

    final phone = map['phoneNumber'] as String? ?? map['phone'] as String? ?? '+251911234567';

    return Mentor(
      id: map['id']?.toString() ?? 'men_${DateTime.now().millisecondsSinceEpoch}',
      nameEn: nameEn,
      nameAm: nameAm,
      titleEn: map['titleEn'] as String? ?? 'Certified Youth Peer Counselor',
      titleAm: map['titleAm'] as String? ?? 'የተረጋገጠ የወጣቶች አቻ አማካሪ',
      organizationEn: organizationEn,
      organizationAm: organizationAm,
      bioEn: map['bioEn'] as String? ??
          'Certified youth mentor offering confidential, stigma-free guidance on emotional wellness and health.',
      bioAm: map['bioAm'] as String? ??
          'በአፍላ ወጣቶች ጤና እና ስሜታዊ ደህንነት ላይ ሚስጥራዊ እና ከፍረጃ ነፃ የሆነ የአቻ ድጋፍ የሚሰጥ አማካሪ።',
      isVerified: isVerified,
      isOnline: isAvailable,
      nextAvailableSlotEn: isAvailable ? 'Available Now' : 'Available Tomorrow',
      nextAvailableSlotAm: isAvailable ? 'አሁን ይገኛሉ' : 'ነገ ይገኛሉ',
      languages: langs,
      topics: topicsList,
      sessionsCount: map['sessionsCount'] as int? ?? 120,
      experienceYears: map['experienceYears'] as int? ?? 2,
      initials: initials,
      avatarColor: avatarColor,
      phoneNumber: phone,
      displayPhoneNumber: map['displayPhoneNumber'] as String? ?? phone,
      telegramHandle: map['telegramHandle'] as String? ?? 'yegna_youth_support',
      workingHoursEn:
          map['workingHoursEn'] as String? ?? 'Mon – Fri: 8:30 AM – 5:30 PM',
      workingHoursAm:
          map['workingHoursAm'] as String? ?? 'ከሰኞ – ዓርብ፡ 2:30 – 11:30',
    );
  }

  static StudentClub clubFromBackendMap(Map<String, dynamic> map) {
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
    final desc = map['description'] as String? ?? 'Youth health engagement club';
    final venue = map['venue'] as String? ?? 'Youth Center';
    final meetingTime = map['meetingTime'] as String? ?? 'Saturdays 10:00 AM';

    return StudentClub(
      id: map['id']?.toString() ?? 'club_${DateTime.now().millisecondsSinceEpoch}',
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
      memberCount: map['memberCount'] as int? ?? 0,
      isActive: map['isApproved'] as bool? ?? true,
      createdAt: DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
