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

  /// No description provided for @learningHeading.
  ///
  /// In en, this message translates to:
  /// **'Health education'**
  String get learningHeading;

  /// No description provided for @learningIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Browse educational resources reviewed for publication. This app does not replace professional care.'**
  String get learningIntroduction;

  /// No description provided for @articlesHeading.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get articlesHeading;

  /// No description provided for @assessmentsHeading.
  ///
  /// In en, this message translates to:
  /// **'Assessments'**
  String get assessmentsHeading;

  /// No description provided for @progressHeading.
  ///
  /// In en, this message translates to:
  /// **'My learning'**
  String get progressHeading;

  /// No description provided for @searchArticles.
  ///
  /// In en, this message translates to:
  /// **'Search articles'**
  String get searchArticles;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get allCategories;

  /// No description provided for @noReviewedArticles.
  ///
  /// In en, this message translates to:
  /// **'No reviewed articles are available yet.'**
  String get noReviewedArticles;

  /// No description provided for @noReviewedAssessments.
  ///
  /// In en, this message translates to:
  /// **'No reviewed assessments are available yet.'**
  String get noReviewedAssessments;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No articles match your search.'**
  String get noSearchResults;

  /// No description provided for @learningLoadError.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t load learning content. Check your connection and try again.'**
  String get learningLoadError;

  /// No description provided for @educationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Learning content is not available in this build.'**
  String get educationUnavailable;

  /// No description provided for @retryAction.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retryAction;

  /// No description provided for @staleSavedContentWarning.
  ///
  /// In en, this message translates to:
  /// **'This saved copy was last checked on {date}. It may be out of date or withdrawn. Reconnect before relying on it.'**
  String staleSavedContentWarning(String date);

  /// No description provided for @sourceReferences.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get sourceReferences;

  /// No description provided for @articleReviewInfo.
  ///
  /// In en, this message translates to:
  /// **'Reviewed on {date}. Educational information does not replace professional care.'**
  String articleReviewInfo(String date);

  /// No description provided for @relatedLearning.
  ///
  /// In en, this message translates to:
  /// **'Related learning'**
  String get relatedLearning;

  /// No description provided for @markArticleComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get markArticleComplete;

  /// No description provided for @articleMarkedComplete.
  ///
  /// In en, this message translates to:
  /// **'Reading saved to your learning progress.'**
  String get articleMarkedComplete;

  /// No description provided for @startAssessment.
  ///
  /// In en, this message translates to:
  /// **'Start assessment'**
  String get startAssessment;

  /// No description provided for @questionProgress.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String questionProgress(int current, int total);

  /// No description provided for @nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next question'**
  String get nextQuestion;

  /// No description provided for @submitAnswers.
  ///
  /// In en, this message translates to:
  /// **'Submit answers'**
  String get submitAnswers;

  /// No description provided for @retakeAssessment.
  ///
  /// In en, this message translates to:
  /// **'Retake assessment'**
  String get retakeAssessment;

  /// No description provided for @assessmentResult.
  ///
  /// In en, this message translates to:
  /// **'{score} of {total} correct ({percent}%)'**
  String assessmentResult(int score, int total, int percent);

  /// No description provided for @answerExplanation.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get answerExplanation;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct answer'**
  String get correctAnswer;

  /// No description provided for @pendingScore.
  ///
  /// In en, this message translates to:
  /// **'Your answers are saved on this device. Connect to the internet to receive a verified score.'**
  String get pendingScore;

  /// No description provided for @assessmentSubmitError.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t submit your answers. Your score is not available yet.'**
  String get assessmentSubmitError;

  /// No description provided for @selectAnAnswer.
  ///
  /// In en, this message translates to:
  /// **'Select an answer to continue.'**
  String get selectAnAnswer;

  /// No description provided for @progressSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning progress sync'**
  String get progressSyncTitle;

  /// No description provided for @progressSyncDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose whether to sync completed articles and assessment history to your signed-in account. Local progress stays available when sync is off.'**
  String get progressSyncDescription;

  /// No description provided for @progressSyncEnable.
  ///
  /// In en, this message translates to:
  /// **'Turn on sync'**
  String get progressSyncEnable;

  /// No description provided for @progressSyncDisable.
  ///
  /// In en, this message translates to:
  /// **'Turn off sync'**
  String get progressSyncDisable;

  /// No description provided for @progressSyncEnabled.
  ///
  /// In en, this message translates to:
  /// **'Progress sync is on.'**
  String get progressSyncEnabled;

  /// No description provided for @progressSyncDisabled.
  ///
  /// In en, this message translates to:
  /// **'Progress sync is off. Local progress is still available.'**
  String get progressSyncDisabled;

  /// No description provided for @progressSyncSignInRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync learning progress.'**
  String get progressSyncSignInRequired;

  /// No description provided for @progressSyncError.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t update sync settings. Your local progress is still available.'**
  String get progressSyncError;

  /// No description provided for @clearSyncedHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear synced history'**
  String get clearSyncedHistory;

  /// No description provided for @clearSyncedHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear synced learning history?'**
  String get clearSyncedHistoryTitle;

  /// No description provided for @clearSyncedHistoryBody.
  ///
  /// In en, this message translates to:
  /// **'This removes article completions and assessment attempts from your account. Progress stored on this device will remain.'**
  String get clearSyncedHistoryBody;

  /// No description provided for @clearHistoryAction.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get clearHistoryAction;

  /// No description provided for @cancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAction;

  /// No description provided for @syncedHistoryCleared.
  ///
  /// In en, this message translates to:
  /// **'Synced learning history was cleared.'**
  String get syncedHistoryCleared;

  /// No description provided for @clearHistoryError.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t clear synced history. Try again.'**
  String get clearHistoryError;

  /// No description provided for @completedArticlesCount.
  ///
  /// In en, this message translates to:
  /// **'Completed articles: {count}'**
  String completedArticlesCount(int count);

  /// No description provided for @assessmentAttemptsCount.
  ///
  /// In en, this message translates to:
  /// **'Assessment attempts: {count}'**
  String assessmentAttemptsCount(int count);

  /// No description provided for @noLearningProgress.
  ///
  /// In en, this message translates to:
  /// **'Your learning progress will appear here.'**
  String get noLearningProgress;

  /// No description provided for @localProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Saved on this device'**
  String get localProgressLabel;

  /// No description provided for @scoreHistoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Verified score history'**
  String get scoreHistoryLabel;

  /// No description provided for @assessmentScorePercent.
  ///
  /// In en, this message translates to:
  /// **'{score}%'**
  String assessmentScorePercent(int score);

  /// No description provided for @facilitiesTab.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get facilitiesTab;

  /// No description provided for @mentorsTab.
  ///
  /// In en, this message translates to:
  /// **'Mentors'**
  String get mentorsTab;

  /// No description provided for @accountTab.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTab;

  /// No description provided for @healthEducationBoundary.
  ///
  /// In en, this message translates to:
  /// **'Educational information only. This app does not replace professional care.'**
  String get healthEducationBoundary;

  /// No description provided for @quickLinksHeading.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get quickLinksHeading;

  /// No description provided for @quickLinksDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose a section to continue.'**
  String get quickLinksDescription;

  /// No description provided for @featuredArticlesHeading.
  ///
  /// In en, this message translates to:
  /// **'Health education'**
  String get featuredArticlesHeading;

  /// No description provided for @viewAllAction.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAllAction;

  /// No description provided for @noFeaturedArticlesTitle.
  ///
  /// In en, this message translates to:
  /// **'No reviewed articles yet'**
  String get noFeaturedArticlesTitle;

  /// No description provided for @noFeaturedArticlesBody.
  ///
  /// In en, this message translates to:
  /// **'Published learning resources will appear here when they are ready.'**
  String get noFeaturedArticlesBody;

  /// No description provided for @homeFaqHeading.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get homeFaqHeading;

  /// No description provided for @noReviewedFaqsTitle.
  ///
  /// In en, this message translates to:
  /// **'No reviewed questions yet'**
  String get noReviewedFaqsTitle;

  /// No description provided for @noReviewedFaqsBody.
  ///
  /// In en, this message translates to:
  /// **'Answers will appear here after they are reviewed and approved.'**
  String get noReviewedFaqsBody;

  /// No description provided for @findVerifiedCare.
  ///
  /// In en, this message translates to:
  /// **'Looking for care?'**
  String get findVerifiedCare;

  /// No description provided for @facilitiesIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Explore youth-friendly health facilities and services.'**
  String get facilitiesIntroduction;

  /// No description provided for @searchFacilities.
  ///
  /// In en, this message translates to:
  /// **'Search facilities'**
  String get searchFacilities;

  /// No description provided for @allFacilities.
  ///
  /// In en, this message translates to:
  /// **'All facilities'**
  String get allFacilities;

  /// No description provided for @nearbyFilter.
  ///
  /// In en, this message translates to:
  /// **'Nearby'**
  String get nearbyFilter;

  /// No description provided for @campusFilter.
  ///
  /// In en, this message translates to:
  /// **'Campus'**
  String get campusFilter;

  /// No description provided for @noVerifiedFacilitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'No verified facilities listed yet'**
  String get noVerifiedFacilitiesTitle;

  /// No description provided for @facilitiesNotAvailableBody.
  ///
  /// In en, this message translates to:
  /// **'Facility information is not available yet. No providers or contact details are listed until they can be verified.'**
  String get facilitiesNotAvailableBody;

  /// No description provided for @mapPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapPreviewTitle;

  /// No description provided for @mapNotAvailableBody.
  ///
  /// In en, this message translates to:
  /// **'A map will be available when a verified facility directory is ready.'**
  String get mapNotAvailableBody;

  /// No description provided for @mentorsIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Find peer support when verified profiles become available.'**
  String get mentorsIntroduction;

  /// No description provided for @searchMentors.
  ///
  /// In en, this message translates to:
  /// **'Search mentors'**
  String get searchMentors;

  /// No description provided for @allMentors.
  ///
  /// In en, this message translates to:
  /// **'All mentors'**
  String get allMentors;

  /// No description provided for @languageFilter.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageFilter;

  /// No description provided for @noVerifiedMentorsTitle.
  ///
  /// In en, this message translates to:
  /// **'No verified mentor profiles yet'**
  String get noVerifiedMentorsTitle;

  /// No description provided for @noVerifiedMentorsBody.
  ///
  /// In en, this message translates to:
  /// **'Mentor profiles and contact options will appear here after identity and safety checks are in place.'**
  String get noVerifiedMentorsBody;

  /// No description provided for @mentorSafetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Peer support directory'**
  String get mentorSafetyTitle;

  /// No description provided for @mentorSafetyBody.
  ///
  /// In en, this message translates to:
  /// **'No people or contact information are displayed until a verification process is available.'**
  String get mentorSafetyBody;

  /// No description provided for @learningProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Your learning activity'**
  String get learningProgressTitle;
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
