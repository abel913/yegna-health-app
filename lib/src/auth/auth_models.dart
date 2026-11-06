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
  accountSuspended,
  emailAlreadyInUse,
}

enum RegistrationOutcome { verificationPending, signedIn }

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.emailVerified,
    this.displayName = '',
    this.role,
    this.isSuspended = false,
  });

  final String id;
  final String email;
  final bool emailVerified;
  final String displayName;
  final String? role;
  final bool isSuspended;
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
