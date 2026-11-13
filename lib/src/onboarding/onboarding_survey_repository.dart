import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_models.dart';
import '../sync/api_client.dart';
import 'onboarding_survey_models.dart';

class OnboardingSurveyRepository {
  OnboardingSurveyRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  // Legacy keys for guest backwards compatibility
  static const String _legacyKeyCompleted =
      'yegna_baseline_survey_completed_v1';
  static const String _legacyKeySkipped = 'yegna_baseline_survey_skipped_v1';
  static const String _legacyKeyAnswers = 'yegna_baseline_survey_answers_v1';
  static const String _cachedQuestionsKey = 'yegna_cached_survey_questions_v1';

  static String _prefix(String? userId) {
    final clean = userId?.trim();
    if (clean != null && clean.isNotEmpty) {
      return 'yegna_survey_${clean}_';
    }
    return 'yegna_survey_guest_';
  }

  /// Default baseline questions providing full offline fallback resilience.
  static final List<DynamicSurveyQuestion> defaultQuestions = [
    const DynamicSurveyQuestion(
      id: 'default_age',
      titleEn: 'What is your age?',
      titleAm: 'ዕድሜዎ ስንት ነው?',
      position: 1,
      isRequired: true,
      options: [
        DynamicSurveyOption(id: 'age_1', value: '18–20', labelEn: '18–20', labelAm: '18–20', position: 1),
        DynamicSurveyOption(id: 'age_2', value: '21–24', labelEn: '21–24', labelAm: '21–24', position: 2),
        DynamicSurveyOption(id: 'age_3', value: '25–29', labelEn: '25–29', labelAm: '25–29', position: 3),
        DynamicSurveyOption(id: 'age_4', value: '30 and above', labelEn: '30 and above', labelAm: '30 እና ከዚያ በላይ', position: 4),
      ],
    ),
    const DynamicSurveyQuestion(
      id: 'default_year',
      titleEn: 'What is your current year of study?',
      titleAm: 'በምን ዓመት የትምህርት ደረጃ ላይ ይገኛሉ?',
      position: 2,
      isRequired: true,
      options: [
        DynamicSurveyOption(id: 'yr_1', value: '1st Year', labelEn: '1st Year', labelAm: '1ኛ ዓመት', position: 1),
        DynamicSurveyOption(id: 'yr_2', value: '2nd Year', labelEn: '2nd Year', labelAm: '2ኛ ዓመት', position: 2),
        DynamicSurveyOption(id: 'yr_3', value: '3rd Year', labelEn: '3rd Year', labelAm: '3ኛ ዓመት', position: 3),
        DynamicSurveyOption(id: 'yr_4', value: '4th Year and above', labelEn: '4th Year and above', labelAm: '4ኛ ዓመት እና ከዚያ በላይ', position: 4),
        DynamicSurveyOption(id: 'yr_5', value: 'Postgraduate', labelEn: 'Postgraduate', labelAm: 'የድህረ-ምረቃ', position: 5),
      ],
    ),
    const DynamicSurveyQuestion(
      id: 'default_disability',
      titleEn: 'Do you have a disability or special accessibility need?',
      titleAm: 'የአካል ጉዳት ወይም የተለየ የተደራሽነት ፍላጎት አለዎት?',
      position: 3,
      isRequired: true,
      options: [
        DynamicSurveyOption(id: 'dis_1', value: 'NONE', labelEn: 'None / No disability', labelAm: 'የለብኝም', position: 1),
        DynamicSurveyOption(id: 'dis_2', value: 'VISUAL', labelEn: 'Visual impairment', labelAm: 'የእይታ ድጋፍ', position: 2),
        DynamicSurveyOption(id: 'dis_3', value: 'HEARING', labelEn: 'Hearing impairment', labelAm: 'የመስማት ድጋፍ', position: 3),
        DynamicSurveyOption(id: 'dis_4', value: 'PHYSICAL', labelEn: 'Physical / Mobility assistance', labelAm: 'የእንቅስቃሴ ድጋፍ', position: 4),
        DynamicSurveyOption(id: 'dis_5', value: 'PREFER_NOT_TO_SAY', labelEn: 'Prefer not to say', labelAm: 'መግለጽ አልፈልግም', position: 5),
      ],
    ),
    const DynamicSurveyQuestion(
      id: 'default_gondar_srh',
      titleEn: 'Do you know where to access sexual & reproductive health services at the University of Gondar?',
      titleAm: 'በጎንደር ዩኒቨርሲቲ የጾታዊና የስነ-ተዋልዶ ጤና አገልግሎት የየት እንደሚገኝ ያውቃሉ?',
      position: 4,
      isRequired: true,
      options: [
        DynamicSurveyOption(id: 'srh_1', value: 'YES', labelEn: 'Yes, I know', labelAm: 'አዎ አውቃለሁ', position: 1),
        DynamicSurveyOption(id: 'srh_2', value: 'NO', labelEn: 'No, not yet', labelAm: 'አልያውቅም', position: 2),
        DynamicSurveyOption(id: 'srh_3', value: 'NOT_SURE', labelEn: 'Not sure', labelAm: 'እርግጠኛ አይደለሁም', position: 3),
      ],
    ),
  ];

  /// Fetches published survey questions from the backend API, caching them locally
  /// in [SharedPreferences] and falling back to cached or default questions when offline.
  Future<List<DynamicSurveyQuestion>> getSurveyQuestions({
    int? sectionNumber,
    String? moduleKey,
    bool forceRefresh = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '${_cachedQuestionsKey}_s${sectionNumber ?? "all"}_m${moduleKey ?? "all"}';

    // Check cached questions first if not forcing refresh
    if (!forceRefresh) {
      final cachedJson = prefs.getString(cacheKey);
      if (cachedJson != null && cachedJson.isNotEmpty) {
        try {
          final list = jsonDecode(cachedJson) as List<dynamic>;
          final parsed = list
              .map((e) => DynamicSurveyQuestion.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList()
            ..sort((a, b) => a.position.compareTo(b.position));
          if (parsed.isNotEmpty) {
            // Background fetch fresh questions to keep cache warm
            _fetchAndCacheQuestions(
              prefs,
              sectionNumber: sectionNumber,
              moduleKey: moduleKey,
              cacheKey: cacheKey,
            );
            return parsed;
          }
        } catch (_) {}
      }
    }

    // Attempt direct fetch from server
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
        return parsed;
      }
    } catch (_) {}

    // Fallback to cached if available
    final cachedFallback = prefs.getString(cacheKey);
    if (cachedFallback != null && cachedFallback.isNotEmpty) {
      try {
        final list = jsonDecode(cachedFallback) as List<dynamic>;
        return list
            .map((e) => DynamicSurveyQuestion.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList()
          ..sort((a, b) => a.position.compareTo(b.position));
      } catch (_) {}
    }

    // Default static fallback for Section 1 or default baseline
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

  /// Returns true if the survey was answered or dismissed for the given user (or guest).
  Future<bool> hasCompletedOrDismissed({String? userId, AuthUser? user}) async {
    if (user?.hasCompletedSurvey == true) return true;

    final prefs = await SharedPreferences.getInstance();
    final pfx = _prefix(userId ?? user?.id);
    final completed = prefs.getBool('${pfx}completed') ??
        (userId == null
            ? (prefs.getBool(_legacyKeyCompleted) ?? false)
            : false);
    final skipped = prefs.getBool('${pfx}skipped') ??
        (userId == null ? (prefs.getBool(_legacyKeySkipped) ?? false) : false);

    return completed || skipped;
  }

  /// Returns true if the user successfully completed and submitted the survey.
  Future<bool> isCompleted({String? userId, AuthUser? user}) async {
    if (user?.hasCompletedSurvey == true) return true;

    final prefs = await SharedPreferences.getInstance();
    final pfx = _prefix(userId ?? user?.id);
    final completed = prefs.getBool('${pfx}completed');
    if (completed != null) return completed;

    // Fallback to legacy key for guest students
    if (userId == null && user == null) {
      return prefs.getBool(_legacyKeyCompleted) ?? false;
    }
    return false;
  }

  /// Retrieves the saved survey answers for the given user (or guest), if any.
  Future<OnboardingSurveyAnswers?> getAnswers({String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final pfx = _prefix(userId);
    final raw = prefs.getString('${pfx}answers') ??
        (userId == null ? prefs.getString(_legacyKeyAnswers) : null);

    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return OnboardingSurveyAnswers.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  /// Saves survey answers locally scoped to the active student account (or guest),
  /// and submits them anonymously to the backend database.
  Future<void> saveAnswers(
    OnboardingSurveyAnswers answers, {
    String? userId,
    String? authToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final pfx = _prefix(userId);

    await prefs.setBool('${pfx}completed', true);
    await prefs.setBool('${pfx}skipped', false);
    await prefs.setString('${pfx}answers', jsonEncode(answers.toJson()));

    // Keep legacy key in sync for backwards compatibility
    await prefs.setBool(_legacyKeyCompleted, true);
    await prefs.setBool(_legacyKeySkipped, false);
    await prefs.setString(_legacyKeyAnswers, jsonEncode(answers.toJson()));

    // Submit anonymously in the background without blocking the UI flow
    try {
      await _apiClient.submitAnonymousBaselineSurvey(
        ageGroup: answers.ageGroup,
        yearOfStudy: answers.yearOfStudy,
        disabilityNeed: answers.disabilityNeed,
        knowsGondarSrh: answers.knowsGondarSrh,
        answers: answers.dynamicAnswers,
        authToken: authToken,
      );
    } catch (_) {
      // Offline/network failure is handled gracefully; local record is safely preserved
    }
  }

  /// Marks the survey as skipped for this student session.
  Future<void> skipForNow({String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final pfx = _prefix(userId);
    await prefs.setBool('${pfx}skipped', true);
    await prefs.setBool(_legacyKeySkipped, true);
  }

  /// Resets the survey state for the given student (or guest).
  Future<void> resetSurvey({String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final pfx = _prefix(userId);
    await prefs.remove('${pfx}completed');
    await prefs.remove('${pfx}skipped');
    await prefs.remove('${pfx}answers');

    if (userId == null) {
      await prefs.remove(_legacyKeyCompleted);
      await prefs.remove(_legacyKeySkipped);
      await prefs.remove(_legacyKeyAnswers);
    }
  }
}
