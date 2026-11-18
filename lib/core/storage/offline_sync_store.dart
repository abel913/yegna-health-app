import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/clubs/club_models.dart';
import '../../src/discovery/facility_model.dart';
import '../../src/discovery/mentor_model.dart';
import 'offline_clubs_cache.dart';
import 'offline_curriculum_cache.dart';
import 'offline_facilities_cache.dart';
import 'offline_mentors_cache.dart';
import 'offline_model_adapters.dart';

export 'offline_model_adapters.dart';

/// Persistent local storage engine for offline caching of all remote datasets.
/// Ensures zero blank screens and instant offline loading.
class OfflineSyncStore
    with
        OfflineFacilitiesCache,
        OfflineMentorsCache,
        OfflineClubsCache,
        OfflineCurriculumCache {
  OfflineSyncStore({SharedPreferences? preferences})
      : _preferences = preferences;

  SharedPreferences? _preferences;
  static const _metaKey = 'yegna_offline_sync_meta_v1';

  @override
  Future<SharedPreferences> getPrefs() async {
    if (_preferences != null) return _preferences!;
    _preferences = await SharedPreferences.getInstance();
    return _preferences!;
  }

  @override
  Future<void> recordSyncTimestamp(String entity) async {
    try {
      final prefs = await getPrefs();
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

  Future<DateTime?> getLastSyncTime([String entity = 'all']) async {
    try {
      final prefs = await getPrefs();
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

  Future<void> clearAllCache() async {
    try {
      final prefs = await getPrefs();
      await prefs.remove(OfflineFacilitiesCache.facilitiesKey);
      await prefs.remove(OfflineMentorsCache.mentorsKey);
      await prefs.remove(OfflineCurriculumCache.modulesKey);
      await prefs.remove(OfflineCurriculumCache.quizzesKey);
      await prefs.remove(OfflineClubsCache.clubsKey);
      await prefs.remove(_metaKey);
    } catch (_) {}
  }

  // Static proxies for backwards-compatibility
  static Map<String, dynamic> facilityToMap(Facility f) =>
      OfflineModelAdapters.facilityToMap(f);
  static Facility facilityFromMap(Map<String, dynamic> map) =>
      OfflineModelAdapters.facilityFromMap(map);
  static Map<String, dynamic> mentorToMap(Mentor m) =>
      OfflineModelAdapters.mentorToMap(m);
  static Mentor mentorFromMap(Map<String, dynamic> map) =>
      OfflineModelAdapters.mentorFromMap(map);
  static StudentClub clubFromBackendMap(Map<String, dynamic> map) =>
      OfflineModelAdapters.clubFromBackendMap(map);
}
