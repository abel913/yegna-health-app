import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_models.dart';
import 'onboarding_survey_models.dart';

/// Handles local persistence of onboarding survey status and answers in SharedPreferences.
class OnboardingSurveyStorage {
  static const String legacyKeyCompleted = 'yegna_baseline_survey_completed_v1';
  static const String legacyKeySkipped = 'yegna_baseline_survey_skipped_v1';
  static const String legacyKeyAnswers = 'yegna_baseline_survey_answers_v1';

  static String prefix(String? userId) {
    final clean = userId?.trim();
    if (clean != null && clean.isNotEmpty) return 'yegna_survey_${clean}_';
    return 'yegna_survey_guest_';
  }

  static Future<bool> hasCompletedOrDismissed({String? userId, AuthUser? user}) async {
    if (await isCompleted(userId: userId, user: user)) return true;
    final prefs = await SharedPreferences.getInstance();
    final pfx = prefix(userId ?? user?.id);
    final userSkipped = prefs.getBool('${pfx}skipped') ?? false;
    final deviceSkipped = prefs.getBool(legacyKeySkipped) ?? false;
    return userSkipped || deviceSkipped;
  }

  static Future<bool> isCompleted({String? userId, AuthUser? user}) async {
    if (user?.hasCompletedSurvey == true) return true;
    if (user != null && user.role != null && user.role!.toUpperCase() != 'STUDENT') {
      return true;
    }
    if (user != null && user.displayName.toLowerCase().contains('admin')) {
      return true;
    }
    final prefs = await SharedPreferences.getInstance();
    final pfx = prefix(userId ?? user?.id);
    if (prefs.getBool('${pfx}completed') == true) return true;
    if (prefs.getBool(legacyKeyCompleted) == true) return true;
    return false;
  }

  static Future<OnboardingSurveyAnswers?> getAnswers({String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final pfx = prefix(userId);
    final raw = prefs.getString('${pfx}answers') ??
        (userId == null ? prefs.getString(legacyKeyAnswers) : null);
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return OnboardingSurveyAnswers.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveAnswers(OnboardingSurveyAnswers answers, {String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final pfx = prefix(userId);
    final jsonStr = jsonEncode(answers.toJson());
    await prefs.setBool('${pfx}completed', true);
    await prefs.setBool('${pfx}skipped', false);
    await prefs.setString('${pfx}answers', jsonStr);
    await prefs.setBool(legacyKeyCompleted, true);
    await prefs.setBool(legacyKeySkipped, false);
    await prefs.setString(legacyKeyAnswers, jsonStr);
  }

  static Future<void> skipForNow({String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final pfx = prefix(userId);
    await prefs.setBool('${pfx}skipped', true);
    await prefs.setBool(legacyKeySkipped, true);
  }

  static Future<void> resetSurvey({String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final pfx = prefix(userId);
    await prefs.remove('${pfx}completed');
    await prefs.remove('${pfx}skipped');
    await prefs.remove('${pfx}answers');
    if (userId == null) {
      await prefs.remove(legacyKeyCompleted);
      await prefs.remove(legacyKeySkipped);
      await prefs.remove(legacyKeyAnswers);
    }
  }
}
