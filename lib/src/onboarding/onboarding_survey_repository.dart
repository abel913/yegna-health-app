import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_models.dart';
import '../sync/api_client.dart';
import 'default_survey_questions.dart';
import 'onboarding_survey_models.dart';
import 'onboarding_survey_storage.dart';

/// Repository for fetching dynamic survey questions and persisting student survey responses.
class OnboardingSurveyRepository {
  OnboardingSurveyRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;
  static const String _cachedQuestionsKey = 'yegna_cached_survey_questions_v1';

  /// Default baseline questions providing full offline fallback resilience.
  static List<DynamicSurveyQuestion> get defaultQuestions =>
      DefaultSurveyQuestions.list;

  /// Baseline 4 demographic questions for onboarding modal only.
  Future<List<DynamicSurveyQuestion>> getBaselineSurveyQuestions({
    bool forceRefresh = false,
  }) async {
    final list = await getSurveyQuestions(sectionNumber: 1, forceRefresh: forceRefresh);
    if (list.isNotEmpty) return list.take(4).toList();
    return defaultQuestions.take(4).toList();
  }

  /// Fetches published survey questions from the backend API with local cache and fallback.
  Future<List<DynamicSurveyQuestion>> getSurveyQuestions({
    int? sectionNumber,
    String? moduleKey,
    bool forceRefresh = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '${_cachedQuestionsKey}_s${sectionNumber ?? "all"}_m${moduleKey ?? "all"}';

    if (!forceRefresh) {
      final cachedJson = prefs.getString(cacheKey);
      if (cachedJson != null && cachedJson.isNotEmpty) {
        try {
          final list = jsonDecode(cachedJson) as List<dynamic>;
          return list
              .map((e) => DynamicSurveyQuestion.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList()
            ..sort((a, b) => a.position.compareTo(b.position));
        } catch (_) {}
      }
    }

    _fetchAndCacheQuestions(prefs, sectionNumber: sectionNumber, moduleKey: moduleKey, cacheKey: cacheKey);

    if (sectionNumber == null || sectionNumber == 1) {
      return defaultQuestions;
    }
    return const [];
  }

  Future<void> _fetchAndCacheQuestions(
    SharedPreferences prefs, {
    int? sectionNumber,
    String? moduleKey,
    required String cacheKey,
  }) async {
    try {
      final remoteList = await _apiClient.fetchSurveyQuestions(
        sectionNumber: sectionNumber,
        moduleKey: moduleKey,
      );
      if (remoteList != null && remoteList.isNotEmpty) {
        final parsed = remoteList
            .map((e) => DynamicSurveyQuestion.fromJson(e))
            .toList()
          ..sort((a, b) => a.position.compareTo(b.position));
        await prefs.setString(cacheKey, jsonEncode(parsed.map((q) => q.toJson()).toList()));
      }
    } catch (_) {}
  }

  Future<bool> hasCompletedOrDismissed({String? userId, AuthUser? user}) =>
      OnboardingSurveyStorage.hasCompletedOrDismissed(userId: userId, user: user);

  Future<bool> isCompleted({String? userId, AuthUser? user}) =>
      OnboardingSurveyStorage.isCompleted(userId: userId, user: user);

  Future<OnboardingSurveyAnswers?> getAnswers({String? userId}) =>
      OnboardingSurveyStorage.getAnswers(userId: userId);

  Future<void> saveAnswers(
    OnboardingSurveyAnswers answers, {
    String? userId,
    String? authToken,
  }) async {
    await OnboardingSurveyStorage.saveAnswers(answers, userId: userId);
    try {
      await _apiClient.submitAnonymousBaselineSurvey(
        ageGroup: answers.ageGroup,
        yearOfStudy: answers.yearOfStudy,
        disabilityNeed: answers.disabilityNeed,
        knowsGondarSrh: answers.knowsGondarSrh,
        answers: answers.dynamicAnswers,
        authToken: authToken,
      );
      if (authToken != null && authToken.isNotEmpty) {
        await _apiClient.markUserSurveyCompleted(authToken);
      }
    } catch (_) {}
  }

  Future<void> skipForNow({String? userId}) =>
      OnboardingSurveyStorage.skipForNow(userId: userId);

  Future<void> resetSurvey({String? userId}) =>
      OnboardingSurveyStorage.resetSurvey(userId: userId);
}
