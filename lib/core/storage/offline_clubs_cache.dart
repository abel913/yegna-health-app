import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/clubs/club_models.dart';

/// Mixin for caching student clubs locally.
mixin OfflineClubsCache {
  Future<SharedPreferences> getPrefs();
  Future<void> recordSyncTimestamp(String entity);

  static const clubsKey = 'yegna_offline_clubs_v1';

  Future<List<StudentClub>?> getCachedClubs() async {
    try {
      final prefs = await getPrefs();
      final jsonStr = prefs.getString(clubsKey);
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
      final prefs = await getPrefs();
      final list = clubs.map((c) => c.toJson()).toList();
      await prefs.setString(clubsKey, jsonEncode(list));
      await recordSyncTimestamp('clubs');
    } catch (_) {}
  }
}
