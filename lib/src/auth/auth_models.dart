enum AuthIssue {
  configurationMissing,
  emailRequired,
  invalidEmail,
  passwordRequired,
  passwordTooShort,
  passwordMismatch,
  displayNameRequired,
  displayNameTooLong,
  invalidCredentials,
  emailNotConfirmed,
  registrationFailed,
  networkUnavailable,
  recoveryExpired,
  sessionUnavailable,
  unexpected,
}

enum RegistrationOutcome { verificationPending, signedIn }

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.emailVerified,
    this.displayName = '',
  });

  final String id;
  final String email;
  final bool emailVerified;
  final String displayName;
}

class AuthSnapshot {
  const AuthSnapshot({this.user, this.passwordRecovery = false});

  final AuthUser? user;
  final bool passwordRecovery;
}

class AuthFailure implements Exception {
  const AuthFailure(this.issue);

  final AuthIssue issue;
}
