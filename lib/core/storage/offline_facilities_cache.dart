import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/discovery/facility_model.dart';
import 'offline_model_adapters.dart';

/// Mixin for caching health facilities locally.
mixin OfflineFacilitiesCache {
  Future<SharedPreferences> getPrefs();
  Future<void> recordSyncTimestamp(String entity);

  static const facilitiesKey = 'yegna_offline_facilities_v1';

  Future<List<Facility>?> getCachedFacilities() async {
    try {
      final prefs = await getPrefs();
      final jsonStr = prefs.getString(facilitiesKey);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .map((e) => OfflineModelAdapters.facilityFromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveFacilities(List<Facility> facilities) async {
    try {
      final prefs = await getPrefs();
      final list = facilities.map(OfflineModelAdapters.facilityToMap).toList();
      await prefs.setString(facilitiesKey, jsonEncode(list));
      await recordSyncTimestamp('facilities');
    } catch (_) {}
  }
}
