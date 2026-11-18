import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_api_response.dart';

/// Mixin providing profile and session management endpoints.
mixin ApiAuthProfile {
  String get baseUrl;
  Duration get timeout;
  http.Client get client;

  /// Permanently deletes the authenticated student account against `DELETE /api/auth/me`.
  Future<AuthApiResponse> deleteAccount({
    required String token,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/auth/me');
      final res = await client.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeout);

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

  /// Fetches current user session profile against `GET /api/auth/me`.
  Future<AuthApiResponse> getCurrentUser(String token) async {
    try {
      final uri = Uri.parse('$baseUrl/auth/me');
      final res = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeout);

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
      final res = await client
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
      final res = await client
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
}
