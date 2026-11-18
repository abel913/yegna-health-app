import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import 'auth_models.dart';

class SupabaseAuthMapping {
  static AuthSnapshot snapshotFrom(AuthState state) => AuthSnapshot(
        user: toAuthUser(state.session?.user),
        passwordRecovery: state.event == AuthChangeEvent.passwordRecovery,
      );

  static AuthUser? toAuthUser(User? user) {
    if (user == null) return null;
    final displayName = user.userMetadata?['display_name'];
    final surveyCompleted = user.userMetadata?['survey_completed'] == true;
    return AuthUser(
      id: user.id,
      email: user.email ?? '',
      emailVerified: user.emailConfirmedAt != null,
      displayName: displayName is String ? displayName : '',
      hasCompletedSurvey: surveyCompleted,
    );
  }

  static AuthIssue mapAuthException(AuthException error) {
    final code = error.code?.toLowerCase() ?? '';
    final statusCode = int.tryParse(error.statusCode ?? '');
    if (statusCode != null && statusCode >= 500) {
      return AuthIssue.networkUnavailable;
    }
    return switch (code) {
      'invalid_credentials' || 'user_not_found' => AuthIssue.invalidCredentials,
      'email_not_confirmed' => AuthIssue.emailNotConfirmed,
      'user_already_exists' || 'email_exists' => AuthIssue.registrationFailed,
      'weak_password' => AuthIssue.passwordTooShort,
      'flow_state_expired' || 'otp_expired' => AuthIssue.recoveryExpired,
      'over_email_send_rate_limit' ||
      'email_address_not_authorized' =>
        AuthIssue.networkUnavailable,
      _ => AuthIssue.unexpected,
    };
  }
}
