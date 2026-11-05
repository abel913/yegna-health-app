import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Robust HTTP client connecting the Flutter mobile app to the custom
/// Node.js + Prisma backend server with timeouts and error resilience.
class ApiClient {
  ApiClient({
    String? baseUrl,
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 4),
  })  : _client = httpClient ?? http.Client(),
        _configuredBaseUrl = baseUrl;

  final http.Client _client;
  final String? _configuredBaseUrl;
  final Duration timeout;

  /// Resolves the backend base URL dynamically based on environment and platform.
  String get baseUrl {
    final configured = _configuredBaseUrl;
    if (configured != null && configured.isNotEmpty) {
      return configured;
    }
    const envUrl = String.fromEnvironment('BACKEND_API_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }
    // Android emulator routes host machine loopback to 10.0.2.2
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000/api';
    }
    // iOS Simulator, Web, Desktop (Windows/macOS/Linux)
    return 'http://localhost:5000/api';
  }

  /// Checks if the backend server is reachable.
  Future<bool> checkHealth() async {
    try {
      final uri = Uri.parse('$baseUrl/health');
      final res = await _client.get(uri).timeout(timeout);
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Fetches published health facilities from `GET /api/facilities`.
  Future<List<Map<String, dynamic>>?> fetchFacilities() async {
    try {
      final uri = Uri.parse('$baseUrl/facilities');
      final res = await _client.get(uri).timeout(timeout);
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
      final res = await _client.get(uri).timeout(timeout);
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
      final res = await _client.get(uri).timeout(timeout);
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
      final res = await _client.get(uri).timeout(timeout);
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
      final res = await _client.get(uri).timeout(timeout);
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
      final res =
          await _client.post(uri, headers: headers).timeout(timeout);
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _client.close();
  }
}
