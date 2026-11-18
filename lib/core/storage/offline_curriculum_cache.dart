import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Mixin for caching educational modules and quizzes locally.
mixin OfflineCurriculumCache {
  Future<SharedPreferences> getPrefs();
  Future<void> recordSyncTimestamp(String entity);

  static const modulesKey = 'yegna_offline_modules_v1';
  static const quizzesKey = 'yegna_offline_quizzes_v1';

  Future<List<Map<String, dynamic>>?> getCachedModules() async {
    try {
      final prefs = await getPrefs();
      final jsonStr = prefs.getString(modulesKey);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveModules(List<Map<String, dynamic>> modules) async {
    try {
      final prefs = await getPrefs();
      await prefs.setString(modulesKey, jsonEncode(modules));
      await recordSyncTimestamp('modules');
    } catch (_) {}
  }

  Future<List<Map<String, dynamic>>?> getCachedQuizzes() async {
    try {
      final prefs = await getPrefs();
      final jsonStr = prefs.getString(quizzesKey);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveQuizzes(List<Map<String, dynamic>> quizzes) async {
    try {
      final prefs = await getPrefs();
      await prefs.setString(quizzesKey, jsonEncode(quizzes));
      await recordSyncTimestamp('quizzes');
    } catch (_) {}
  }
}
