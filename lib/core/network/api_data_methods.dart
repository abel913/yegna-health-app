import 'dart:convert';
import 'package:http/http.dart' as http;

/// Mixin providing data fetching and interaction endpoints (facilities, mentors, clubs, modules, quizzes).
mixin ApiDataMethods {
  String get baseUrl;
  Duration get timeout;
  http.Client get client;

  /// Fetches published baseline or modular survey questions from `GET /api/survey/questions`.
  Future<List<Map<String, dynamic>>?> fetchSurveyQuestions({
    int? sectionNumber,
    String? moduleKey,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (sectionNumber != null) {
        queryParams['section'] = sectionNumber.toString();
      }
      if (moduleKey != null && moduleKey.isNotEmpty) {
        queryParams['moduleKey'] = moduleKey;
      }

      final baseUri = Uri.parse('$baseUrl/survey/questions');
      final uri = queryParams.isNotEmpty
          ? baseUri.replace(queryParameters: queryParams)
          : baseUri;

      final res = await client.get(uri).timeout(timeout);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final list = data['questions'] as List<dynamic>?;
        if (list != null) {
          return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Fetches published health facilities from `GET /api/facilities`.
  Future<List<Map<String, dynamic>>?> fetchFacilities() async {
    try {
      final uri = Uri.parse('$baseUrl/facilities');
      final res = await client.get(uri).timeout(timeout);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final list = data['facilities'] as List<dynamic>?;
        if (list != null) {
          return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Fetches peer mentors and counselors from `GET /api/mentors`.
  Future<List<Map<String, dynamic>>?> fetchMentors() async {
    try {
      final uri = Uri.parse('$baseUrl/mentors');
      final res = await client.get(uri).timeout(timeout);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final list = data['mentors'] as List<dynamic>?;
        if (list != null) {
          return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Fetches curriculum learning modules from `GET /api/modules`.
  Future<List<Map<String, dynamic>>?> fetchModules() async {
    try {
      final uri = Uri.parse('$baseUrl/modules');
      final res = await client.get(uri).timeout(timeout);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final list = data['modules'] as List<dynamic>?;
        if (list != null) {
          return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Fetches assessment questions from `GET /api/quizzes`.
  Future<List<Map<String, dynamic>>?> fetchQuizzes() async {
    try {
      final uri = Uri.parse('$baseUrl/quizzes');
      final res = await client.get(uri).timeout(timeout);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final list = data['questions'] as List<dynamic>?;
        if (list != null) {
          return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Fetches student clubs from `GET /api/clubs`.
  Future<List<Map<String, dynamic>>?> fetchClubs() async {
    try {
      final uri = Uri.parse('$baseUrl/clubs');
      final res = await client.get(uri).timeout(timeout);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final list = data['clubs'] as List<dynamic>?;
        if (list != null) {
          return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Joins a student club via `POST /api/clubs/:id/join`.
  Future<bool> joinClub(String clubId, {String? token}) async {
    try {
      final uri = Uri.parse('$baseUrl/clubs/$clubId/join');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      final res = await client.post(uri, headers: headers).timeout(timeout);
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  /// Leaves a student club via `POST /api/clubs/:id/leave`.
  Future<bool> leaveClub(String clubId, {String? token}) async {
    try {
      final uri = Uri.parse('$baseUrl/clubs/$clubId/leave');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      final res = await client.post(uri, headers: headers).timeout(timeout);
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Submits anonymous student baseline survey responses to `POST /api/survey/baseline`.
  Future<bool> submitAnonymousBaselineSurvey({
    required String ageGroup,
    required String yearOfStudy,
    required String disabilityNeed,
    required String knowsGondarSrh,
    Map<String, String>? answers,
    String? authToken,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/survey/baseline');
      final headers = <String, String>{'Content-Type': 'application/json'};
      if (authToken != null && authToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $authToken';
      }
      final payload = <String, dynamic>{
        'ageGroup': ageGroup,
        'yearOfStudy': yearOfStudy,
        'disabilityNeed': disabilityNeed,
        'knowsGondarSrh': knowsGondarSrh,
      };
      if (answers != null && answers.isNotEmpty) {
        payload['answers'] = answers;
      }
      final res = await client
          .post(
            uri,
            headers: headers,
            body: jsonEncode(payload),
          )
          .timeout(timeout);
      return res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }
}
