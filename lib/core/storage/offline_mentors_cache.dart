import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/discovery/mentor_model.dart';
import 'offline_model_adapters.dart';

/// Mixin for caching peer mentors and counselors locally.
mixin OfflineMentorsCache {
  Future<SharedPreferences> getPrefs();
  Future<void> recordSyncTimestamp(String entity);

  static const mentorsKey = 'yegna_offline_mentors_v1';

  Future<List<Mentor>?> getCachedMentors() async {
    try {
      final prefs = await getPrefs();
      final jsonStr = prefs.getString(mentorsKey);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .map((e) => OfflineModelAdapters.mentorFromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveMentors(List<Mentor> mentors) async {
    try {
      final prefs = await getPrefs();
      final list = mentors.map(OfflineModelAdapters.mentorToMap).toList();
      await prefs.setString(mentorsKey, jsonEncode(list));
      await recordSyncTimestamp('mentors');
    } catch (_) {}
  }
}
