import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Yegna Health'**
  String get appTitle;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @learnTab.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learnTab;

  /// No description provided for @servicesTab.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesTab;

  /// No description provided for @settingsTab.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTab;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your health, your journey'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'A trusted place for health education and services in English and Amharic.'**
  String get welcomeBody;

  /// No description provided for @foundationLabel.
  ///
  /// In en, this message translates to:
  /// **'Getting started'**
  String get foundationLabel;

  /// No description provided for @foundationBody.
  ///
  /// In en, this message translates to:
  /// **'Health education and service features are being prepared. This app does not provide medical advice.'**
  String get foundationBody;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the language used in the app.'**
  String get languageDescription;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @amharicLanguage.
  ///
  /// In en, this message translates to:
  /// **'Amharic'**
  String get amharicLanguage;

  /// No description provided for @learnPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Learning content will appear here in a future update.'**
  String get learnPlaceholder;

  /// No description provided for @servicesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Verified health services will appear here in a future update.'**
  String get servicesPlaceholder;

  /// No description provided for @settingsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Language preferences are available here.'**
  String get settingsPlaceholder;

  /// No description provided for @localeChanged.
  ///
  /// In en, this message translates to:
  /// **'Language updated'**
  String get localeChanged;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTitle;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @accountGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest access'**
  String get accountGuest;

  /// No description provided for @accountSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}'**
  String accountSignedInAs(String email);

  /// No description provided for @manageAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage account'**
  String get manageAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @registerAction.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerAction;

  /// No description provided for @loginAction.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginAction;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'New here? Create an account'**
  String get noAccount;

  /// No description provided for @hasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get hasAccount;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @displayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayNameLabel;

  /// No description provided for @sendRecoveryEmail.
  ///
  /// In en, this message translates to:
  /// **'Send recovery email'**
  String get sendRecoveryEmail;

  /// No description provided for @recoveryInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we’ll send recovery instructions if an account can receive them.'**
  String get recoveryInstructions;

  /// No description provided for @recoveryEmailSent.
  ///
  /// In en, this message translates to:
  /// **'If an account matches that email, password recovery instructions have been sent.'**
  String get recoveryEmailSent;

  /// No description provided for @verificationPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get verificationPendingTitle;

  /// No description provided for @verificationPendingBody.
  ///
  /// In en, this message translates to:
  /// **'We sent a confirmation link to {email}. Open it on this device to confirm your email, then sign in.'**
  String verificationPendingBody(String email);

  /// No description provided for @passwordUpdatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordUpdatedTitle;

  /// No description provided for @passwordUpdatedBody.
  ///
  /// In en, this message translates to:
  /// **'Your password was updated. Sign in with your new password.'**
  String get passwordUpdatedBody;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get updatePassword;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get saveProfile;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved.'**
  String get profileSaved;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get continueAsGuest;

  /// No description provided for @guestAccessDescription.
  ///
  /// In en, this message translates to:
  /// **'You can browse public health education without an account.'**
  String get guestAccessDescription;

  /// No description provided for @authConfigMissing.
  ///
  /// In en, this message translates to:
  /// **'Account services are not configured for this build. Public pages are still available.'**
  String get authConfigMissing;

  /// No description provided for @errorEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address.'**
  String get errorEmailRequired;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get errorInvalidEmail;

  /// No description provided for @errorPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get errorPasswordRequired;

  /// No description provided for @errorPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters for your password.'**
  String get errorPasswordTooShort;

  /// No description provided for @errorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'The passwords do not match.'**
  String get errorPasswordMismatch;

  /// No description provided for @errorDisplayNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a display name.'**
  String get errorDisplayNameRequired;

  /// No description provided for @errorDisplayNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Use 80 characters or fewer for your display name.'**
  String get errorDisplayNameTooLong;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirm your email before signing in. Check your inbox for the confirmation link.'**
  String get errorEmailNotConfirmed;

  /// No description provided for @errorRegistration.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t create the account. Try signing in or password recovery.'**
  String get errorRegistration;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t reach the account service. Check your connection and try again.'**
  String get errorNetwork;

  /// No description provided for @errorRecoveryExpired.
  ///
  /// In en, this message translates to:
  /// **'This recovery link has expired. Request a new one.'**
  String get errorRecoveryExpired;

  /// No description provided for @errorSessionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Your session is no longer available. Sign in again.'**
  String get errorSessionUnavailable;

  /// No description provided for @errorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnexpected;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Account request could not be completed'**
  String get errorTitle;

  /// No description provided for @sessionEnded.
  ///
  /// In en, this message translates to:
  /// **'Your session ended. Sign in again to view your profile.'**
  String get sessionEnded;

  /// No description provided for @profileDescription.
  ///
  /// In en, this message translates to:
  /// **'Your profile details are private to your signed-in account.'**
  String get profileDescription;

  /// No description provided for @passwordRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get passwordRecoveryTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['am', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
