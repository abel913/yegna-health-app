// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Yegna Health';

  @override
  String get homeTab => 'Home';

  @override
  String get learnTab => 'Learn';

  @override
  String get servicesTab => 'Services';

  @override
  String get settingsTab => 'Settings';

  @override
  String get welcomeTitle => 'Your health, your journey';

  @override
  String get welcomeBody =>
      'A trusted place for health education and services in English and Amharic.';

  @override
  String get foundationLabel => 'Getting started';

  @override
  String get foundationBody =>
      'Health education and service features are being prepared. This app does not provide medical advice.';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageDescription => 'Choose the language used in the app.';

  @override
  String get englishLanguage => 'English';

  @override
  String get amharicLanguage => 'Amharic';

  @override
  String get learnPlaceholder =>
      'Learning content will appear here in a future update.';

  @override
  String get servicesPlaceholder =>
      'Verified health services will appear here in a future update.';

  @override
  String get settingsPlaceholder => 'Language preferences are available here.';

  @override
  String get localeChanged => 'Language updated';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get accountTitle => 'Account';

  @override
  String get profile => 'Profile';

  @override
  String get accountGuest => 'Guest access';

  @override
  String accountSignedInAs(String email) {
    return 'Signed in as $email';
  }

  @override
  String get manageAccount => 'Manage account';

  @override
  String get signIn => 'Sign in';

  @override
  String get signOut => 'Sign out';

  @override
  String get createAccount => 'Create account';

  @override
  String get registerAction => 'Create account';

  @override
  String get loginAction => 'Sign in';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get noAccount => 'New here? Create an account';

  @override
  String get hasAccount => 'Already have an account? Sign in';

  @override
  String get emailLabel => 'Email address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get displayNameLabel => 'Display name';

  @override
  String get sendRecoveryEmail => 'Send recovery email';

  @override
  String get recoveryInstructions =>
      'Enter your email and we’ll send recovery instructions if an account can receive them.';

  @override
  String get recoveryEmailSent =>
      'If an account matches that email, password recovery instructions have been sent.';

  @override
  String get verificationPendingTitle => 'Check your email';

  @override
  String verificationPendingBody(String email) {
    return 'We sent a confirmation link to $email. Open it on this device to confirm your email, then sign in.';
  }

  @override
  String get passwordUpdatedTitle => 'Password updated';

  @override
  String get passwordUpdatedBody =>
      'Your password was updated. Sign in with your new password.';

  @override
  String get updatePassword => 'Update password';

  @override
  String get saveProfile => 'Save profile';

  @override
  String get profileSaved => 'Profile saved.';

  @override
  String get continueAsGuest => 'Continue as guest';

  @override
  String get guestAccessDescription =>
      'You can browse public health education without an account.';

  @override
  String get authConfigMissing =>
      'Account services are not configured for this build. Public pages are still available.';

  @override
  String get errorEmailRequired => 'Enter your email address.';

  @override
  String get errorInvalidEmail => 'Enter a valid email address.';

  @override
  String get errorPasswordRequired => 'Enter your password.';

  @override
  String get errorPasswordTooShort =>
      'Use at least 8 characters for your password.';

  @override
  String get errorPasswordMismatch => 'The passwords do not match.';

  @override
  String get errorDisplayNameRequired => 'Enter a display name.';

  @override
  String get errorDisplayNameTooLong =>
      'Use 80 characters or fewer for your display name.';

  @override
  String get errorInvalidCredentials => 'Email or password is incorrect.';

  @override
  String get errorEmailNotConfirmed =>
      'Confirm your email before signing in. Check your inbox for the confirmation link.';

  @override
  String get errorRegistration =>
      'We couldn’t create the account. Try signing in or password recovery.';

  @override
  String get errorNetwork =>
      'We couldn’t reach the account service. Check your connection and try again.';

  @override
  String get errorRecoveryExpired =>
      'This recovery link has expired. Request a new one.';

  @override
  String get errorSessionUnavailable =>
      'Your session is no longer available. Sign in again.';

  @override
  String get errorUnexpected => 'Something went wrong. Please try again.';

  @override
  String get errorTitle => 'Account request could not be completed';

  @override
  String get sessionEnded =>
      'Your session ended. Sign in again to view your profile.';

  @override
  String get profileDescription =>
      'Your profile details are private to your signed-in account.';

  @override
  String get passwordRecoveryTitle => 'Reset your password';
}
