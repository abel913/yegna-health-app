import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_auth_methods.dart';
import 'api_data_methods.dart';

export 'api_auth_credentials.dart';
export 'api_auth_methods.dart';
export 'api_auth_profile.dart';
export 'api_data_methods.dart';
export 'auth_api_response.dart';

/// Robust HTTP client connecting the Flutter mobile app to the custom
/// Node.js + Prisma backend server with timeouts and error resilience.
class ApiClient
    with
        ApiAuthCredentials,
        ApiAuthProfile,
        ApiAuthMethods,
        ApiDataMethods {
  ApiClient({
    String? baseUrl,
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 25),
  })  : _client = httpClient ?? http.Client(),
        _configuredBaseUrl = baseUrl;

  final http.Client _client;
  final String? _configuredBaseUrl;

  @override
  final Duration timeout;

  @override
  http.Client get client => _client;

  @override
  String get baseUrl {
    final configured = _configuredBaseUrl;
    if (configured != null && configured.isNotEmpty) {
      return configured;
    }
    const envUrl = String.fromEnvironment('BACKEND_API_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }
    // Release builds use the public Cloudflare backend
    if (kReleaseMode) {
      return 'https://yegna-health-admin-portal.smartserve.workers.dev/api';
    }
    if (kIsWeb) {
      final host = Uri.base.host.isNotEmpty ? Uri.base.host : 'localhost';
      return 'http://$host:5000/api';
    }
    // Android emulator routes host machine loopback to 10.0.2.2
    if (defaultTargetPlatform == TargetPlatform.android) {
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

  void dispose() {
    _client.close();
  }
}
