import '../../core/network/auth_api_response.dart';
import 'auth_models.dart';

AuthFailure mapBackendAuthError(AuthApiResponse res) {
  if (res.errorCode == 'ACCOUNT_SUSPENDED') {
    return const AuthFailure(AuthIssue.accountSuspended);
  }
  if (res.errorCode == 'EMAIL_NOT_CONFIRMED') {
    return const AuthFailure(AuthIssue.emailNotConfirmed);
  }
  if (res.errorCode == 'EMAIL_EXISTS' || res.statusCode == 409) {
    return const AuthFailure(AuthIssue.emailAlreadyInUse);
  }
  if (res.errorCode == 'INVALID_CODE' || res.statusCode == 400) {
    return const AuthFailure(AuthIssue.invalidVerificationCode);
  }
  if (res.errorCode == 'INVALID_CREDENTIALS' || res.statusCode == 401) {
    return const AuthFailure(AuthIssue.invalidCredentials);
  }
  if (res.statusCode == 403) {
    return const AuthFailure(AuthIssue.accountSuspended);
  }
  if (res.errorCode == 'NETWORK_ERROR') {
    return const AuthFailure(AuthIssue.networkUnavailable);
  }
  return const AuthFailure(AuthIssue.unexpected);
}
