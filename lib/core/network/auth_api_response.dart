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
