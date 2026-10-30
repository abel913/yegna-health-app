import 'auth_models.dart';

abstract final class AuthValidation {
  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static AuthIssue? email(String value) {
    final email = value.trim();
    if (email.isEmpty) return AuthIssue.emailRequired;
    if (!_emailPattern.hasMatch(email)) return AuthIssue.invalidEmail;
    return null;
  }

  static AuthIssue? password(String value) {
    if (value.isEmpty) return AuthIssue.passwordRequired;
    if (value.length < 8) return AuthIssue.passwordTooShort;
    return null;
  }

  static AuthIssue? passwordConfirmation(String password, String confirmation) {
    if (confirmation.isEmpty || password != confirmation) {
      return AuthIssue.passwordMismatch;
    }
    return null;
  }

  static AuthIssue? displayName(String value) {
    final name = value.trim();
    if (name.isEmpty) return AuthIssue.displayNameRequired;
    if (name.length > 80) return AuthIssue.displayNameTooLong;
    return null;
  }
}
