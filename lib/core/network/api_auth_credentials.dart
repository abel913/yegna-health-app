import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_api_response.dart';

/// Mixin providing credential-related authentication methods (login, register, verify, resend).
mixin ApiAuthCredentials {
  String get baseUrl;
  Duration get timeout;
  http.Client get client;

  /// Authenticates a user against `POST /api/auth/login`.
  Future<AuthApiResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/auth/login');
      final res = await client
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
      final res = await client
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

  /// Verifies a student's 6-digit confirmation code against `POST /api/auth/verify-email`.
  Future<AuthApiResponse> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/auth/verify-email');
      final res = await client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email.trim().toLowerCase(),
              'code': code.trim(),
            }),
          )
          .timeout(timeout);

      final data = jsonDecode(res.body) as Map<String, dynamic>? ?? {};
      if (res.statusCode == 200 || res.statusCode == 201) {
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

  /// Resends a 6-digit verification code against `POST /api/auth/resend-verification`.
  Future<AuthApiResponse> resendVerification({
    required String email,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/auth/resend-verification');
      final res = await client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email.trim().toLowerCase(),
            }),
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
