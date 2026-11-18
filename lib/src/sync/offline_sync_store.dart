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
          .map((e) => StudentClub.fromJson(Map<String, Object?>.from(e as Map)))
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

  Future<bool> hasSynced(String entity) async {
    final time = await getLastSyncTime(entity);
    return time != null;
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
        'category': f.category.toDbString(),
        'subCity': f.subCityEn,
        'subCityEn': f.subCityEn,
        'subCityAm': f.subCityAm,
        'buildingEn': f.buildingEn,
        'buildingAm': f.buildingAm,
        'landmarkEn': f.landmarkEn,
        'landmarkAm': f.landmarkAm,
        'focalPerson': f.focalPerson,
        'focalPhone': f.focalPhone,
        'telegramHandle': f.telegramHandle,
        'addressEn': f.addressEn,
        'addressAm': f.addressAm,
        'phone': f.phone,
        'type': f.type.name,
        'latitude': f.latitude,
        'longitude': f.longitude,
        'distanceKm': f.distanceKm,
        'isYouthFriendly': f.isYouthFriendly,
        'isFreeForYouth': f.isFreeForYouth,
        'isWheelchairAccessible': f.isWheelchairAccessible,
        'hasPrivateRoom': f.hasPrivateRoom,
        'operatingHours': f.operatingHours,
        'openingHour': f.openingHour,
        'closingHour': f.closingHour,
        'isVerified': f.isVerified,
        'services': f.services,
        'campusNameEn': f.campusNameEn ?? f.subCityEn,
        'campusNameAm': f.campusNameAm ?? f.subCityAm,
        'confidentialityPolicyEn': f.confidentialityPolicyEn,
        'confidentialityPolicyAm': f.confidentialityPolicyAm,
      };

  static Facility facilityFromMap(Map<String, dynamic> map) {
    String cleanSubCityStr(String? raw) {
      if (raw == null) return '';
      return raw.replaceAll(RegExp(r'\s+Sub-City', caseSensitive: false), '').trim();
    }

    final rawCampus = (map['subCity'] ?? map['campusNameEn'] ?? map['subCityEn']) as String?;
    final cleanCampus = rawCampus != null && cleanSubCityStr(rawCampus).isNotEmpty
        ? cleanSubCityStr(rawCampus)
        : 'University of Gondar';

    final subCityEn = cleanSubCityStr(map['subCityEn'] as String?).isNotEmpty
        ? cleanSubCityStr(map['subCityEn'] as String?)
        : cleanCampus;
    final subCityAm = cleanSubCityStr(map['subCityAm'] as String?).isNotEmpty
        ? cleanSubCityStr(map['subCityAm'] as String?)
        : (cleanSubCityStr(map['campusNameAm'] as String?).isNotEmpty
            ? cleanSubCityStr(map['campusNameAm'] as String?)
            : cleanCampus);

    // Category parsing
    final category = FacilityCategory.fromString(map['category'] as String?);

    // Operating hours parsing with 24/7 & "Open Now" resilience
    final operatingHours = map['operatingHours'] as String? ?? '08:30 - 17:30';
    final lowerHours = operatingHours.toLowerCase().trim();
    int openingHour = map['openingHour'] as int? ?? 8;
    int closingHour = map['closingHour'] as int? ?? 18;

    if (lowerHours.contains('24/7') ||
        lowerHours.contains('24 hours') ||
        lowerHours.contains('emergency') ||
        lowerHours.startsWith('open now')) {
      openingHour = 0;
      closingHour = 24;
    } else if (operatingHours.contains('-')) {
      final parts = operatingHours.split('-');
      if (parts.length >= 2) {
        final startRaw = parts[0].trim().replaceAll(RegExp(r'[^0-9]'), '');
        final endRaw = parts[1].trim().replaceAll(RegExp(r'[^0-9]'), '');
        if (startRaw.isNotEmpty) {
          final start = int.tryParse(startRaw.padRight(2, '0').substring(0, 2));
          if (start != null) openingHour = start;
        }
        if (endRaw.isNotEmpty) {
          final end = int.tryParse(endRaw.padRight(2, '0').substring(0, 2));
          if (end != null) closingHour = end;
        }
      }
    }

    final servicesList = (map['services'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>[];

    final typeStr = map['type'] as String? ?? '';
    final type = FacilityType.values.firstWhere(
      (t) => t.name == typeStr,
      orElse: () => FacilityType.campusClinic,
    );

    // Building/Department fallback to woreda if building is empty
    final rawBuildingEn = (map['buildingEn'] as String?)?.trim();
    final rawWoreda = (map['woreda'] as String?)?.trim();
    final buildingEn = (rawBuildingEn != null && rawBuildingEn.isNotEmpty)
        ? rawBuildingEn
        : ((rawWoreda != null && rawWoreda.isNotEmpty) ? rawWoreda : null);

    return Facility(
      id: map['id']?.toString() ??
          'fac_${DateTime.now().millisecondsSinceEpoch}',
      nameEn: map['nameEn'] as String? ?? 'UoG Campus Facility',
      nameAm: map['nameAm'] as String? ?? 'የዩኒቨርሲቲ ተቋም',
      subCityEn: subCityEn,
      subCityAm: subCityAm,
      category: category,
      buildingEn: buildingEn,
      buildingAm: map['buildingAm'] as String?,
      landmarkEn: map['landmarkEn'] as String? ?? '',
      landmarkAm: map['landmarkAm'] as String? ?? '',
      focalPerson: map['focalPerson'] as String?,
      focalPhone: map['focalPhone'] as String?,
      telegramHandle: map['telegramHandle'] as String?,
      addressEn: map['addressEn'] as String? ?? 'University of Gondar, Gondar, Ethiopia',
      addressAm: map['addressAm'] as String? ?? 'የጎንደር ዩኒቨርሲቲ፣ ጎንደር፣ ኢትዮጵያ',
      phone: map['phone'] as String? ?? '+251-58-114-1234',
      type: type,
      latitude: (map['latitude'] as num?)?.toDouble() ?? 12.6075,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 37.4589,
      distanceKm: (map['distanceKm'] as num?)?.toDouble() ?? 1.5,
      isYouthFriendly: map['isYouthFriendly'] as bool? ?? true,
      isFreeForYouth: map['isFreeForYouth'] as bool? ?? true,
      isWheelchairAccessible: map['isWheelchairAccessible'] as bool? ?? false,
      hasPrivateRoom: map['hasPrivateRoom'] as bool? ?? false,
      operatingHours: operatingHours,
      openingHour: openingHour,
      closingHour: closingHour,
      isVerified: map['isVerified'] as bool? ?? true,
      services: servicesList,
      campusNameEn: cleanCampus,
      campusNameAm: cleanSubCityStr(map['campusNameAm'] as String?).isNotEmpty
          ? cleanSubCityStr(map['campusNameAm'] as String?)
          : cleanCampus,
      confidentialityPolicyEn: map['confidentialityPolicyEn'] as String? ??
          'Private and youth-friendly services. All student health, guidance, and counseling sessions are strictly confidential without mandatory disclosure.',
      confidentialityPolicyAm: map['confidentialityPolicyAm'] as String? ??
          'ሚስጥራዊ እና ለወጣቶች ምቹ የጤና አገልግሎት። ሁሉም የተማሪዎች ጤና፣ ምክር እና ድጋፍ አገልግሎቶች በጥብቅ ሚስጥራዊነት የተጠበቁ ናቸው።',
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
        'whatsapp': m.whatsapp,
        'email': m.email,
        'campus': m.campus,
        'workingHoursEn': m.workingHoursEn,
        'workingHoursAm': m.workingHoursAm,
        'safeguardingPolicyEn': m.safeguardingPolicyEn,
        'safeguardingPolicyAm': m.safeguardingPolicyAm,
        'weeklySchedule': m.weeklySchedule?.map((k, v) => MapEntry(k, v.toJson())),
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

    final isAvailable =
        map['isAvailable'] as bool? ?? map['isOnline'] as bool? ?? true;
    final isVerified = map['isVerified'] as bool? ?? true;

    // Parse topics from specialties or stored topic names
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
    final topicsList = topicsSet.toList();

    final langs = (map['languages'] as List<dynamic>?)
            ?.map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
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
      id: map['id']?.toString() ??
          'men_${DateTime.now().millisecondsSinceEpoch}',
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
      topics: topicsList,
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
