import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../sync/api_client.dart';
import 'onboarding_survey_models.dart';

class OnboardingSurveyRepository {
  OnboardingSurveyRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  static const String _keyCompleted = 'yegna_baseline_survey_completed_v1';
  static const String _keySkipped = 'yegna_baseline_survey_skipped_v1';
  static const String _keyAnswers = 'yegna_baseline_survey_answers_v1';

  /// Returns true if the user has already answered or dismissed the survey on this device.
  Future<bool> hasCompletedOrDismissed() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool(_keyCompleted) ?? false;
    final skipped = prefs.getBool(_keySkipped) ?? false;
    return completed || skipped;
  }

  /// Returns true if the user successfully completed and submitted the survey.
  Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyCompleted) ?? false;
  }

  /// Retrieves the saved local survey answers, if any.
  Future<OnboardingSurveyAnswers?> getAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyAnswers);
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return OnboardingSurveyAnswers.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  /// Saves survey answers locally and submits them anonymously to the backend database.
  Future<void> saveAnswers(OnboardingSurveyAnswers answers) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyCompleted, true);
    await prefs.setBool(_keySkipped, false);
    await prefs.setString(_keyAnswers, jsonEncode(answers.toJson()));

    // Submit anonymously in the background without blocking the UI flow
    try {
      await _apiClient.submitAnonymousBaselineSurvey(
        ageGroup: answers.ageGroup,
        yearOfStudy: answers.yearOfStudy,
        disabilityNeed: answers.disabilityNeed,
        knowsGondarSrh: answers.knowsGondarSrh,
      );
    } catch (_) {
      // Offline/network failure is handled gracefully; local record is safely preserved
    }
  }

  /// Marks the survey as skipped for this session.
  Future<void> skipForNow() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySkipped, true);
  }

  /// Resets the survey state (e.g. for retaking or testing).
  Future<void> resetSurvey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCompleted);
    await prefs.remove(_keySkipped);
    await prefs.remove(_keyAnswers);
  }
}
