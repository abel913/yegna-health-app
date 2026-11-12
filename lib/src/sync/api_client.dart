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

  /// Authenticates a user against `POST /api/auth/login`.
  Future<AuthApiResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/auth/login');
      final res = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email.trim().toLowerCase(),
              'password': password,
            }),
          )
          .timeout(timeout);

      final data = jsonDecode(res.body) as Map<String, dynamic>? ?? {};
      if (res.statusCode == 200) {
        return AuthApiResponse(
          success: true,
          token: data['token'] as String?,
          user: data['user'] as Map<String, dynamic>?,
          statusCode: res.statusCode,
        );
      }
      return AuthApiResponse(
        success: false,
        errorCode: data['error'] as String?,
        errorMessage: data['message'] as String?,
        statusCode: res.statusCode,
      );
    } catch (e) {
      return AuthApiResponse(
        success: false,
        errorCode: 'NETWORK_ERROR',
        errorMessage: e.toString(),
      );
    }
  }

  /// Registers a new student account against `POST /api/auth/register`.
  Future<AuthApiResponse> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/auth/register');
      final res = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email.trim().toLowerCase(),
              'password': password,
              'displayName': displayName.trim(),
            }),
          )
          .timeout(timeout);

      final data = jsonDecode(res.body) as Map<String, dynamic>? ?? {};
      if (res.statusCode == 200 || res.statusCode == 201) {
        return AuthApiResponse(
          success: true,
          verificationPending: data['verificationPending'] == true,
          token: data['token'] as String?,
          user: data['user'] as Map<String, dynamic>?,
          statusCode: res.statusCode,
        );
      }
      return AuthApiResponse(
        success: false,
        errorCode: data['error'] as String?,
        errorMessage: data['message'] as String?,
        statusCode: res.statusCode,
      );
    } catch (e) {
      return AuthApiResponse(
        success: false,
        errorCode: 'NETWORK_ERROR',
        errorMessage: e.toString(),
      );
    }
  }

  /// Fetches current user session profile against `GET /api/auth/me`.
  Future<AuthApiResponse> getCurrentUser(String token) async {
    try {
      final uri = Uri.parse('$baseUrl/auth/me');
      final res = await _client
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(timeout);

      final data = jsonDecode(res.body) as Map<String, dynamic>? ?? {};
      if (res.statusCode == 200) {
        return AuthApiResponse(
          success: true,
          user: data['user'] as Map<String, dynamic>?,
          statusCode: res.statusCode,
        );
      }
      return AuthApiResponse(
        success: false,
        errorCode: data['error'] as String?,
        errorMessage: data['message'] as String?,
        statusCode: res.statusCode,
      );
    } catch (e) {
      return AuthApiResponse(
        success: false,
        errorCode: 'NETWORK_ERROR',
        errorMessage: e.toString(),
      );
    }
  }

  /// Updates profile information against `PUT /api/auth/profile`.
  Future<AuthApiResponse> updateProfile({
    required String token,
    required String displayName,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/auth/profile');
      final res = await _client
          .put(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'displayName': displayName.trim()}),
          )
          .timeout(timeout);

      final data = jsonDecode(res.body) as Map<String, dynamic>? ?? {};
      if (res.statusCode == 200) {
        return AuthApiResponse(
          success: true,
          user: data['user'] as Map<String, dynamic>?,
          statusCode: res.statusCode,
        );
      }
      return AuthApiResponse(
        success: false,
        errorCode: data['error'] as String?,
        errorMessage: data['message'] as String?,
        statusCode: res.statusCode,
      );
    } catch (e) {
      return AuthApiResponse(
        success: false,
        errorCode: 'NETWORK_ERROR',
        errorMessage: e.toString(),
      );
    }
  }

  /// Updates user password against `PUT /api/auth/password`.
  Future<AuthApiResponse> updatePassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/auth/password');
      final res = await _client
          .put(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'newPassword': newPassword}),
          )
          .timeout(timeout);

      final data = jsonDecode(res.body) as Map<String, dynamic>? ?? {};
      if (res.statusCode == 200) {
        return AuthApiResponse(
          success: true,
          statusCode: res.statusCode,
        );
      }
      return AuthApiResponse(
        success: false,
        errorCode: data['error'] as String?,
        errorMessage: data['message'] as String?,
        statusCode: res.statusCode,
      );
    } catch (e) {
      return AuthApiResponse(
        success: false,
        errorCode: 'NETWORK_ERROR',
        errorMessage: e.toString(),
      );
    }
  }

  /// Submits anonymous student baseline survey responses to `POST /api/survey/baseline`.
  /// Strictly avoids attaching any user token, name, or identifiable data.
  Future<bool> submitAnonymousBaselineSurvey({
    required String ageGroup,
    required String yearOfStudy,
    required String disabilityNeed,
    required String knowsGondarSrh,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/survey/baseline');
      final res = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'ageGroup': ageGroup,
              'yearOfStudy': yearOfStudy,
              'disabilityNeed': disabilityNeed,
              'knowsGondarSrh': knowsGondarSrh,
            }),
          )
          .timeout(timeout);
      return res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _client.close();
  }
}

/// Standardized response wrapper for API authentication and profile operations.
class AuthApiResponse {
  const AuthApiResponse({
    this.success = false,
    this.verificationPending = false,
    this.token,
    this.user,
    this.errorCode,
    this.errorMessage,
    this.statusCode = 0,
  });

  final bool success;
  final bool verificationPending;
  final String? token;
  final Map<String, dynamic>? user;
  final String? errorCode;
  final String? errorMessage;
  final int statusCode;
}
