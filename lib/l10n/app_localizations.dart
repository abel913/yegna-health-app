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
  /// **'Learning Modules'**
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
  /// **'Connect confidentially with certified youth peer counselors for free guidance.'**
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

  /// No description provided for @selfAssessmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Self-Assessment'**
  String get selfAssessmentTitle;

  /// No description provided for @selfAssessmentDesc.
  ///
  /// In en, this message translates to:
  /// **'Assess your health status and get guided recommendations.'**
  String get selfAssessmentDesc;

  /// No description provided for @learnDesc.
  ///
  /// In en, this message translates to:
  /// **'Explore sexual and reproductive health education.'**
  String get learnDesc;

  /// No description provided for @findFacilitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Find Health Facilities'**
  String get findFacilitiesTitle;

  /// No description provided for @findFacilitiesDesc.
  ///
  /// In en, this message translates to:
  /// **'Locate verified youth-friendly health facilities.'**
  String get findFacilitiesDesc;

  /// No description provided for @peerMentorTitle.
  ///
  /// In en, this message translates to:
  /// **'Peer Mentor'**
  String get peerMentorTitle;

  /// No description provided for @peerMentorDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect with compassionate mentors for guidance.'**
  String get peerMentorDesc;

  /// No description provided for @welcomeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Yegna Health'**
  String get welcomeHeroTitle;

  /// No description provided for @welcomeHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Empowering youth to conduct self-assessments, explore health education, and connect with compassionate professionals.'**
  String get welcomeHeroSubtitle;

  /// No description provided for @confidentialPill.
  ///
  /// In en, this message translates to:
  /// **'100% Confidential'**
  String get confidentialPill;

  /// No description provided for @reviewedPill.
  ///
  /// In en, this message translates to:
  /// **'Reviewed Sources'**
  String get reviewedPill;

  /// No description provided for @guestReadyPill.
  ///
  /// In en, this message translates to:
  /// **'Open & Free'**
  String get guestReadyPill;

  /// No description provided for @learningModulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning Modules'**
  String get learningModulesTitle;

  /// No description provided for @moreButton.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreButton;

  /// No description provided for @takeQuizButton.
  ///
  /// In en, this message translates to:
  /// **'Take Quiz'**
  String get takeQuizButton;

  /// No description provided for @moduleLabel.
  ///
  /// In en, this message translates to:
  /// **'MODULE {number}'**
  String moduleLabel(String number);

  /// No description provided for @module01Title.
  ///
  /// In en, this message translates to:
  /// **'Adolescent health & puberty'**
  String get module01Title;

  /// No description provided for @module01Desc.
  ///
  /// In en, this message translates to:
  /// **'This module covers physical and emotional changes during puberty, personal hygiene, and growing body confidence.'**
  String get module01Desc;

  /// No description provided for @module02Title.
  ///
  /// In en, this message translates to:
  /// **'Sexual transmitted infections (STI)'**
  String get module02Title;

  /// No description provided for @module02Desc.
  ///
  /// In en, this message translates to:
  /// **'This module explains Sexually Transmitted Infections, including what they are, their signs and symptoms, how they are diagnosed, treated, and prevented.'**
  String get module02Desc;

  /// No description provided for @module03Title.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis'**
  String get module03Title;

  /// No description provided for @module03Desc.
  ///
  /// In en, this message translates to:
  /// **'This module introduces Hepatitis, focusing on its causes, types, symptoms, and how it affects liver health.'**
  String get module03Desc;

  /// No description provided for @module04Title.
  ///
  /// In en, this message translates to:
  /// **'Gender-based violence (GBV)'**
  String get module04Title;

  /// No description provided for @module04Desc.
  ///
  /// In en, this message translates to:
  /// **'This module addresses Gender-Based Violence, helping learners understand its forms, causes, and impact on individuals and society.'**
  String get module04Desc;

  /// No description provided for @module05Title.
  ///
  /// In en, this message translates to:
  /// **'Sexual and reproductive health (SRH)'**
  String get module05Title;

  /// No description provided for @module05Desc.
  ///
  /// In en, this message translates to:
  /// **'This module focuses on helping individuals understand their well-being in relation to sexuality, relationships, and reproduction.'**
  String get module05Desc;

  /// No description provided for @module06Title.
  ///
  /// In en, this message translates to:
  /// **'Mental health & wellbeing'**
  String get module06Title;

  /// No description provided for @module06Desc.
  ///
  /// In en, this message translates to:
  /// **'This module explores mental well-being, stress management, overcoming anxiety, and finding safe support.'**
  String get module06Desc;

  /// No description provided for @module07Title.
  ///
  /// In en, this message translates to:
  /// **'Human immune virus (HIV)/AIDS'**
  String get module07Title;

  /// No description provided for @module07Desc.
  ///
  /// In en, this message translates to:
  /// **'This module provides essential knowledge about HIV/AIDS, including what it is, how it spreads, how to prevent it, and how it can be treated.'**
  String get module07Desc;

  /// No description provided for @module08Title.
  ///
  /// In en, this message translates to:
  /// **'Substance Abuse'**
  String get module08Title;

  /// No description provided for @module08Desc.
  ///
  /// In en, this message translates to:
  /// **'This module explores by helping you understand different types of substances, how they affect the brain and behavior, and how to maintain a healthy lifestyle.'**
  String get module08Desc;

  /// No description provided for @completedStatus.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedStatus;

  /// No description provided for @hivHeroDesc.
  ///
  /// In en, this message translates to:
  /// **'HIV/AIDS is a virus that weakens the immune system, spreads mainly through unsafe sex, blood, and mother-to-child, but can be prevented with safe practices and managed effectively with early testing and treatment (ART).'**
  String get hivHeroDesc;

  /// No description provided for @hivNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get hivNoteTitle;

  /// No description provided for @hivNoteContent.
  ///
  /// In en, this message translates to:
  /// **'HIV can be prevented and managed—practice safe behaviors, get tested early, and start treatment (ART) to live a healthy life and protect others.'**
  String get hivNoteContent;

  /// No description provided for @stiHeroDesc.
  ///
  /// In en, this message translates to:
  /// **'STIs are infections spread mainly through unprotected sexual contact; they may show no symptoms but can cause serious health complications if untreated, and can be managed effectively with early diagnosis and proper treatment.'**
  String get stiHeroDesc;

  /// No description provided for @stiNoteContent.
  ///
  /// In en, this message translates to:
  /// **'Protect yourself by practicing safe sex, getting tested regularly, and seeking medical care early knowing your status helps prevent complications and protects others.'**
  String get stiNoteContent;

  /// No description provided for @stiDefinitionTitle.
  ///
  /// In en, this message translates to:
  /// **'Definition'**
  String get stiDefinitionTitle;

  /// No description provided for @stiDefinitionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What are Sexually Transmitted Infections (STIs)?'**
  String get stiDefinitionSubtitle;

  /// No description provided for @stiDefinitionDesc1.
  ///
  /// In en, this message translates to:
  /// **'Sexually Transmitted Infections (STIs) are infections passed from person to person primarily through sexual contact (vaginal, oral, or anal intercourse). They are caused by bacteria, viruses, or parasites.'**
  String get stiDefinitionDesc1;

  /// No description provided for @stiDefinitionDesc2.
  ///
  /// In en, this message translates to:
  /// **'Common bacterial STIs include Chlamydia, Gonorrhea, and Syphilis. Common viral STIs include HPV (Human Papillomavirus), Herpes (HSV), Hepatitis B, and HIV. Common parasitic STIs include Trichomoniasis.'**
  String get stiDefinitionDesc2;

  /// No description provided for @stiDefinitionDesc3.
  ///
  /// In en, this message translates to:
  /// **'An infection (STI) means a pathogen is present in the body, often without causing symptoms. It becomes a disease (STD) when the infection causes noticeable damage or illness. Many STIs are silent but still contagious.'**
  String get stiDefinitionDesc3;

  /// No description provided for @stiSymptomsTitle.
  ///
  /// In en, this message translates to:
  /// **'Signs and Symptoms of STI'**
  String get stiSymptomsTitle;

  /// No description provided for @stiSymptomsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recognizing common signs and asymptomatic cases'**
  String get stiSymptomsSubtitle;

  /// No description provided for @stiSymptomsIntro.
  ///
  /// In en, this message translates to:
  /// **'Symptoms can vary depending on the specific infection and gender, but commonly include:'**
  String get stiSymptomsIntro;

  /// No description provided for @stiSymptom1.
  ///
  /// In en, this message translates to:
  /// **'Unusual discharge: Thick, watery, yellow, green, or foul-smelling discharge from the penis, vagina, or anus.'**
  String get stiSymptom1;

  /// No description provided for @stiSymptom2.
  ///
  /// In en, this message translates to:
  /// **'Pain or burning sensation: Discomfort or burning pain during urination (dysuria) or during sexual intercourse.'**
  String get stiSymptom2;

  /// No description provided for @stiSymptom3.
  ///
  /// In en, this message translates to:
  /// **'Sores, bumps, or blisters: Painful or painless blisters, ulcers, warts, or lesions on the genitals, groin, mouth, or anus.'**
  String get stiSymptom3;

  /// No description provided for @stiSymptom4.
  ///
  /// In en, this message translates to:
  /// **'Itching and irritation: Persistent itching, redness, or swelling around the genital and perineal areas.'**
  String get stiSymptom4;

  /// No description provided for @stiSymptom5.
  ///
  /// In en, this message translates to:
  /// **'Abdominal or pelvic pain: Lower belly pain, unexpected bleeding between menstrual periods, or bleeding after intercourse.'**
  String get stiSymptom5;

  /// No description provided for @stiSymptomsAsymptomaticAlert.
  ///
  /// In en, this message translates to:
  /// **'Silent infections: Up to 70% of women and many men with STIs like chlamydia or gonorrhea experience NO noticeable symptoms. Regular clinical testing is the only reliable way to confirm status.'**
  String get stiSymptomsAsymptomaticAlert;

  /// No description provided for @stiDiagnosisTitle.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis of STI'**
  String get stiDiagnosisTitle;

  /// No description provided for @stiDiagnosisSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How healthcare providers detect and evaluate STIs'**
  String get stiDiagnosisSubtitle;

  /// No description provided for @stiDiagnosisIntro.
  ///
  /// In en, this message translates to:
  /// **'Early diagnosis ensures quick cure and prevents irreversible reproductive damage. Healthcare providers use:'**
  String get stiDiagnosisIntro;

  /// No description provided for @stiDiagnosisItem1.
  ///
  /// In en, this message translates to:
  /// **'Clinical examination: Confidential, private, and respectful physical assessment by a trained health professional.'**
  String get stiDiagnosisItem1;

  /// No description provided for @stiDiagnosisItem2.
  ///
  /// In en, this message translates to:
  /// **'Laboratory tests: Blood tests (for Syphilis, HIV, Hepatitis B), urine samples, and swabs from fluid or sores.'**
  String get stiDiagnosisItem2;

  /// No description provided for @stiDiagnosisItem3.
  ///
  /// In en, this message translates to:
  /// **'National syndromic management: In primary health clinics across Ethiopia, healthcare workers follow national guidelines to treat symptoms immediately on the first visit without waiting days for lab results.'**
  String get stiDiagnosisItem3;

  /// No description provided for @stiDiagnosisYouthFriendly.
  ///
  /// In en, this message translates to:
  /// **'Youth-friendly centers provide completely confidential, stigma-free counseling, tests, and care for adolescents and youth.'**
  String get stiDiagnosisYouthFriendly;

  /// No description provided for @stiComplicationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Complications of STI'**
  String get stiComplicationsTitle;

  /// No description provided for @stiComplicationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Serious risks of leaving STIs untreated'**
  String get stiComplicationsSubtitle;

  /// No description provided for @stiComplicationsIntro.
  ///
  /// In en, this message translates to:
  /// **'When left untreated or improperly treated, STIs can lead to severe and lasting health consequences:'**
  String get stiComplicationsIntro;

  /// No description provided for @stiComplication1.
  ///
  /// In en, this message translates to:
  /// **'Infertility & PID: Untreated chlamydia or gonorrhea can cause Pelvic Inflammatory Disease (PID) in women, leading to scarring of fallopian tubes, chronic pain, life-threatening ectopic pregnancy, or infertility. In men, it can cause painful epididymitis and infertility.'**
  String get stiComplication1;

  /// No description provided for @stiComplication2.
  ///
  /// In en, this message translates to:
  /// **'Higher HIV risk: Open genital sores and mucosal inflammation from STIs multiply the risk of contracting or transmitting HIV by 3 to 5 times.'**
  String get stiComplication2;

  /// No description provided for @stiComplication3.
  ///
  /// In en, this message translates to:
  /// **'Mother-to-child transmission: Pregnant mothers with untreated STIs can pass infections to their babies, leading to miscarriage, stillbirth, premature birth, low birth weight, and newborn eye infections.'**
  String get stiComplication3;

  /// No description provided for @stiComplication4.
  ///
  /// In en, this message translates to:
  /// **'Cervical & other cancers: Persistent infections with high-risk HPV strains are the primary cause of cervical cancer in women.'**
  String get stiComplication4;

  /// No description provided for @stiTreatmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Management and treatment of STI'**
  String get stiTreatmentTitle;

  /// No description provided for @stiTreatmentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Medical therapies and critical rules for recovery'**
  String get stiTreatmentSubtitle;

  /// No description provided for @stiTreatmentDesc1.
  ///
  /// In en, this message translates to:
  /// **'Bacterial and parasitic STIs (Chlamydia, Gonorrhea, Syphilis, Trichomoniasis) are fully curable with specific prescription antibiotics or antiparasitics.'**
  String get stiTreatmentDesc1;

  /// No description provided for @stiTreatmentDesc2.
  ///
  /// In en, this message translates to:
  /// **'Viral STIs (Herpes, HPV, HIV, Hepatitis B) cannot be cured with antibiotics, but modern antiviral medications effectively manage symptoms, reduce recurrences, and prevent complications.'**
  String get stiTreatmentDesc2;

  /// No description provided for @stiTreatmentRule1.
  ///
  /// In en, this message translates to:
  /// **'Finish all medication: Always complete the full prescribed course, even if symptoms vanish early. Incomplete treatment creates antibiotic-resistant strains.'**
  String get stiTreatmentRule1;

  /// No description provided for @stiTreatmentRule2.
  ///
  /// In en, this message translates to:
  /// **'Treat sexual partners simultaneously: Both partners must receive treatment at the same time to prevent passing the infection back and forth (ping-pong effect).'**
  String get stiTreatmentRule2;

  /// No description provided for @stiTreatmentRule3.
  ///
  /// In en, this message translates to:
  /// **'Abstain during treatment: Refrain from all sexual intercourse until both partners finish all medicines and clinical symptoms are completely gone.'**
  String get stiTreatmentRule3;

  /// No description provided for @stiTreatmentRule4.
  ///
  /// In en, this message translates to:
  /// **'Never self-medicate: Do not take leftover pills or buy random antibiotics from pharmacies without a medical diagnosis, as wrong medications can make infections worse.'**
  String get stiTreatmentRule4;

  /// No description provided for @stiPreventionTitle.
  ///
  /// In en, this message translates to:
  /// **'Prevention of STI'**
  String get stiPreventionTitle;

  /// No description provided for @stiPreventionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Effective ways to protect yourself and your partner'**
  String get stiPreventionSubtitle;

  /// No description provided for @stiPreventionIntro.
  ///
  /// In en, this message translates to:
  /// **'Protecting yourself from STIs requires practical, consistent safe behaviors:'**
  String get stiPreventionIntro;

  /// No description provided for @stiPreventionItem1.
  ///
  /// In en, this message translates to:
  /// **'Consistent & correct condom use: Latex and polyurethane male and female condoms provide highly effective barrier protection against most STIs when used properly every single time.'**
  String get stiPreventionItem1;

  /// No description provided for @stiPreventionItem2.
  ///
  /// In en, this message translates to:
  /// **'Mutual fidelity: Being in a faithful relationship with one uninfected partner after both have been tested.'**
  String get stiPreventionItem2;

  /// No description provided for @stiPreventionItem3.
  ///
  /// In en, this message translates to:
  /// **'Abstinence: Choosing not to engage in sexual intercourse is the only 100% foolproof way to prevent STIs.'**
  String get stiPreventionItem3;

  /// No description provided for @stiPreventionItem4.
  ///
  /// In en, this message translates to:
  /// **'Vaccination: Vaccines against HPV (protects against cervical cancer) and Hepatitis B are safe, highly effective, and available.'**
  String get stiPreventionItem4;

  /// No description provided for @stiPreventionItem5.
  ///
  /// In en, this message translates to:
  /// **'Regular checkups & screening: Getting tested before starting a new sexual relationship and getting screened annually if sexually active.'**
  String get stiPreventionItem5;

  /// No description provided for @stiPreventionItem6.
  ///
  /// In en, this message translates to:
  /// **'Avoid alcohol and substance abuse: Intoxication impairs judgment and significantly reduces the use of protection.'**
  String get stiPreventionItem6;

  /// No description provided for @hepatitisHeroDesc.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis is inflammation of the liver caused by viruses or other factors, often showing mild or no symptoms but potentially leading to serious complications like cirrhosis, liver failure, or cancer if untreated; early diagnosis and proper management are essential.'**
  String get hepatitisHeroDesc;

  /// No description provided for @hepatitisNoteContent.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis can be prevented and managed—practice good hygiene, avoid risky behaviors, get vaccinated where possible, and seek early testing to protect your liver health.'**
  String get hepatitisNoteContent;

  /// No description provided for @hepatitisSection1Title.
  ///
  /// In en, this message translates to:
  /// **'Definition'**
  String get hepatitisSection1Title;

  /// No description provided for @hepatitisSection1Desc1.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis is a general term used to describe inflammation of the liver. Liver inflammation can be caused by several viruses (viral hepatitis), chemicals, drugs, alcohol, certain genetic disorders or by an overactive immune system that mistakenly attacks the liver, called autoimmune hepatitis.'**
  String get hepatitisSection1Desc1;

  /// No description provided for @hepatitisSection1Desc2.
  ///
  /// In en, this message translates to:
  /// **'There are several types of hepatitis, which are categorized as viral hepatitis and non-viral hepatitis. The most common types of viral hepatitis are A, B, C, D, and E. Then there are non-viral causes of hepatitis, such as autoimmune hepatitis, alcoholic hepatitis, and drug-induced hepatitis.'**
  String get hepatitisSection1Desc2;

  /// No description provided for @hepatitisSection2Title.
  ///
  /// In en, this message translates to:
  /// **'Sign and symptoms of Hepatitis'**
  String get hepatitisSection2Title;

  /// No description provided for @hepatitisSection2Intro.
  ///
  /// In en, this message translates to:
  /// **'Many people with hepatitis A, B, C, D or E exhibit only mild symptoms or no symptoms at all. Each form of the virus, however, can cause more severe symptoms. Symptoms of hepatitis A, B and C may include: -'**
  String get hepatitisSection2Intro;

  /// No description provided for @hepatitisSymptom1.
  ///
  /// In en, this message translates to:
  /// **'fever'**
  String get hepatitisSymptom1;

  /// No description provided for @hepatitisSymptom2.
  ///
  /// In en, this message translates to:
  /// **'malaise'**
  String get hepatitisSymptom2;

  /// No description provided for @hepatitisSymptom3.
  ///
  /// In en, this message translates to:
  /// **'loss of appetite'**
  String get hepatitisSymptom3;

  /// No description provided for @hepatitisSymptom4.
  ///
  /// In en, this message translates to:
  /// **'diarrhea'**
  String get hepatitisSymptom4;

  /// No description provided for @hepatitisSymptom5.
  ///
  /// In en, this message translates to:
  /// **'nausea'**
  String get hepatitisSymptom5;

  /// No description provided for @hepatitisSymptom6.
  ///
  /// In en, this message translates to:
  /// **'abdominal discomfort'**
  String get hepatitisSymptom6;

  /// No description provided for @hepatitisSymptom7.
  ///
  /// In en, this message translates to:
  /// **'dark-colored urine and jaundice (a yellowing of the skin and whites of the eyes).'**
  String get hepatitisSymptom7;

  /// No description provided for @hepatitisSection2ChronicNote.
  ///
  /// In en, this message translates to:
  /// **'In some cases, the virus can also cause a chronic liver infection that can later develop into cirrhosis (a scarring of the liver) or liver cancer. These patients are at risk of death.'**
  String get hepatitisSection2ChronicNote;

  /// No description provided for @hepatitisBTitle.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis B'**
  String get hepatitisBTitle;

  /// No description provided for @hepatitisBDesc.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis B is a viral infection that affects the liver, caused by the Hepatitis B virus (HBV). It can range from a mild illness to a serious, long-term (chronic) condition that can lead to liver cirrhosis, liver failure, or liver cancer.'**
  String get hepatitisBDesc;

  /// No description provided for @hepatitisBTransmissionIntro.
  ///
  /// In en, this message translates to:
  /// **'The virus is transmitted through contact with infectious body fluids, such as blood, semen, and vaginal fluids, commonly through:'**
  String get hepatitisBTransmissionIntro;

  /// No description provided for @hepatitisBTransmission1.
  ///
  /// In en, this message translates to:
  /// **'Unprotected sexual contact'**
  String get hepatitisBTransmission1;

  /// No description provided for @hepatitisBTransmission2.
  ///
  /// In en, this message translates to:
  /// **'Sharing needles or other drug paraphernalia'**
  String get hepatitisBTransmission2;

  /// No description provided for @hepatitisBTransmission3.
  ///
  /// In en, this message translates to:
  /// **'From an infected mother to her newborn during childbirth'**
  String get hepatitisBTransmission3;

  /// No description provided for @hepatitisBTransmission4.
  ///
  /// In en, this message translates to:
  /// **'Exposure to contaminated blood in healthcare settings'**
  String get hepatitisBTransmission4;

  /// No description provided for @hepatitisBAlert.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis B is preventable with a vaccine, but it has no cure.'**
  String get hepatitisBAlert;

  /// No description provided for @hepatitisCTitle.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis C'**
  String get hepatitisCTitle;

  /// No description provided for @hepatitisCDesc.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis C is a viral infection caused by the Hepatitis C virus (HCV), primarily affecting the liver. It is most commonly spread through blood-to-blood contact, often through:'**
  String get hepatitisCDesc;

  /// No description provided for @hepatitisCTransmission1.
  ///
  /// In en, this message translates to:
  /// **'Sharing needles or other drug equipment'**
  String get hepatitisCTransmission1;

  /// No description provided for @hepatitisCTransmission2.
  ///
  /// In en, this message translates to:
  /// **'Receiving contaminated blood products (though this is less common now due to screening)'**
  String get hepatitisCTransmission2;

  /// No description provided for @hepatitisCTransmission3.
  ///
  /// In en, this message translates to:
  /// **'In some cases, through sexual contact or from an infected mother to her baby during childbirth.'**
  String get hepatitisCTransmission3;

  /// No description provided for @hepatitisCChronicDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlike Hepatitis B, Hepatitis C often becomes chronic, meaning the infection persists for years and can lead to liver damage, cirrhosis, liver cancer, and even liver failure. Many people with Hepatitis C don\'t show symptoms until liver damage is severe.'**
  String get hepatitisCChronicDesc;

  /// No description provided for @hepatitisCTreatmentDesc.
  ///
  /// In en, this message translates to:
  /// **'Treatment has evolved significantly, with direct-acting antivirals (DAAs) offering a high cure rate, making chronic Hepatitis C much more manageable now than in the past.'**
  String get hepatitisCTreatmentDesc;

  /// No description provided for @hepatitisSection3Title.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis of Hepatitis'**
  String get hepatitisSection3Title;

  /// No description provided for @hepatitisSection3Desc.
  ///
  /// In en, this message translates to:
  /// **'The diagnosis of hepatitis involves a combination of blood tests, imaging, and sometimes liver biopsy to determine the cause, severity, and appropriate treatment of the disease. Each type of hepatitis has its own set of diagnostic markers, so identifying the specific cause is essential for effective management.'**
  String get hepatitisSection3Desc;

  /// No description provided for @hepatitisSection4Title.
  ///
  /// In en, this message translates to:
  /// **'Complication of Hepatitis'**
  String get hepatitisSection4Title;

  /// No description provided for @hepatitisSection4Intro.
  ///
  /// In en, this message translates to:
  /// **'Complications of hepatitis can vary depending on the type (A, B, C, etc.), the severity of the infection, and whether it becomes chronic. Some common and serious complications include:'**
  String get hepatitisSection4Intro;

  /// No description provided for @hepatitisComp1Title.
  ///
  /// In en, this message translates to:
  /// **'Chronic Hepatitis'**
  String get hepatitisComp1Title;

  /// No description provided for @hepatitisComp1Desc.
  ///
  /// In en, this message translates to:
  /// **'Chronic Hepatitis B and C: If untreated, viral hepatitis can progress to chronic infection, where the virus remains in the body for years, leading to ongoing liver inflammation.'**
  String get hepatitisComp1Desc;

  /// No description provided for @hepatitisComp2Title.
  ///
  /// In en, this message translates to:
  /// **'Cirrhosis'**
  String get hepatitisComp2Title;

  /// No description provided for @hepatitisComp2Desc.
  ///
  /// In en, this message translates to:
  /// **'Liver Scarring: Long-term inflammation can cause cirrhosis, a condition where the liver tissue becomes scarred, impairing liver function. This can result from chronic Hepatitis B, C, or alcohol use.'**
  String get hepatitisComp2Desc;

  /// No description provided for @hepatitisComp3Title.
  ///
  /// In en, this message translates to:
  /// **'Liver Failure'**
  String get hepatitisComp3Title;

  /// No description provided for @hepatitisComp3Desc.
  ///
  /// In en, this message translates to:
  /// **'Acute or Chronic Liver Failure: Severe liver damage can lead to liver failure, where the liver loses its ability to perform vital functions such as detoxification and protein production. It can occur acutely (e.g., in acute Hepatitis B or D) or chronically in cases of Hepatitis C.'**
  String get hepatitisComp3Desc;

  /// No description provided for @hepatitisComp4Title.
  ///
  /// In en, this message translates to:
  /// **'Liver Cancer (Hepatocellular Carcinoma)'**
  String get hepatitisComp4Title;

  /// No description provided for @hepatitisComp4Desc.
  ///
  /// In en, this message translates to:
  /// **'Chronic Hepatitis B and C increase the risk of developing liver cancer over time due to ongoing liver cell damage and mutations.'**
  String get hepatitisComp4Desc;

  /// No description provided for @hepatitisSection4Conclusion.
  ///
  /// In en, this message translates to:
  /// **'Early diagnosis and management of hepatitis, particularly chronic forms, are key to preventing or managing these complications.'**
  String get hepatitisSection4Conclusion;

  /// No description provided for @hepatitisSection5Title.
  ///
  /// In en, this message translates to:
  /// **'Management and treatment of Hepatitis'**
  String get hepatitisSection5Title;

  /// No description provided for @hepatitisSection5Desc.
  ///
  /// In en, this message translates to:
  /// **'The treatment of hepatitis varies based on its type and severity. While many forms (especially Hepatitis A and E) resolve on their own with supportive care, others (like Hepatitis B, C, and chronic conditions) require long-term management with antiviral drugs, lifestyle changes, or immunosuppressive therapies. Early diagnosis and appropriate treatment are key to preventing liver damage and complications such as cirrhosis and liver cancer.'**
  String get hepatitisSection5Desc;

  /// No description provided for @hepatitisSection6Title.
  ///
  /// In en, this message translates to:
  /// **'Prevention Of Hepatitis'**
  String get hepatitisSection6Title;

  /// No description provided for @hepatitisSection6Subtitle.
  ///
  /// In en, this message translates to:
  /// **'General Preventive Measures for All Types of Hepatitis'**
  String get hepatitisSection6Subtitle;

  /// No description provided for @hepatitisPreventionMeasure1.
  ///
  /// In en, this message translates to:
  /// **'Good Hygiene Practices: Wash hands thoroughly with soap and water after using the bathroom, handling food, and before eating.'**
  String get hepatitisPreventionMeasure1;

  /// No description provided for @hepatitisPreventionMeasure2.
  ///
  /// In en, this message translates to:
  /// **'Avoid alcohol and drugs: Excessive alcohol use and drug abuse can exacerbate liver damage.'**
  String get hepatitisPreventionMeasure2;

  /// No description provided for @hepatitisPreventionMeasure3.
  ///
  /// In en, this message translates to:
  /// **'Vaccination: Vaccines against Hepatitis A and Hepatitis B are safe, highly effective, and available.'**
  String get hepatitisPreventionMeasure3;

  /// No description provided for @hepatitisPreventionMeasure4.
  ///
  /// In en, this message translates to:
  /// **'Safe needles & blood screening: Always use sterile single-use needles and ensure medical blood products are rigorously screened.'**
  String get hepatitisPreventionMeasure4;

  /// No description provided for @substanceHeroDesc.
  ///
  /// In en, this message translates to:
  /// **'Substance abuse is the harmful use of drugs or alcohol that affects health, behavior, and relationships, leading to physical and mental problems, dependency, and serious life consequences if not addressed early.'**
  String get substanceHeroDesc;

  /// No description provided for @substanceNoteContent.
  ///
  /// In en, this message translates to:
  /// **'Substance abuse is preventable and treatable—recognizing early signs and seeking help can protect your health, relationships, and future.'**
  String get substanceNoteContent;

  /// No description provided for @substanceDefTitle.
  ///
  /// In en, this message translates to:
  /// **'Definition of substance abuse'**
  String get substanceDefTitle;

  /// No description provided for @substanceDefDesc1.
  ///
  /// In en, this message translates to:
  /// **'Substance abuse refers to the harmful or hazardous use of psychoactive substances, including alcohol and illicit drugs, characterized by a compulsive pattern of consumption. This behavior often leads to significant adverse consequences in various aspects of an individual\'s life, such as health, relationships, and social responsibilities. It can result in physical and psychological dependence, tolerance, and withdrawal symptoms.'**
  String get substanceDefDesc1;

  /// No description provided for @substanceDefDesc2.
  ///
  /// In en, this message translates to:
  /// **'Psychoactive substance is a drug or other substance that affects how the brain works and causes changes in mood, awareness, thoughts, feelings, or behavior. The commonly used psychoactive substances include alcohol, caffeine, nicotine, marijuana, and certain pain medicines.'**
  String get substanceDefDesc2;

  /// No description provided for @substanceDefDesc3.
  ///
  /// In en, this message translates to:
  /// **'Substance use disorder (SUD) is a mental disorder that affects a person\'s brain and behavior, leading to a person\'s inability to control their use of substances such as legal or illegal drugs, alcohol, or medications. A substance use disorder involves using too much alcohol, tobacco or other drugs.'**
  String get substanceDefDesc3;

  /// No description provided for @substanceTypesTitle.
  ///
  /// In en, this message translates to:
  /// **'Types of drugs/Substances'**
  String get substanceTypesTitle;

  /// No description provided for @substanceTypeDepressants.
  ///
  /// In en, this message translates to:
  /// **'Depressants: - the most commonly found types of drugs in society are depressants. Alcohol, Sedatives/hypnotics.'**
  String get substanceTypeDepressants;

  /// No description provided for @substanceTypeStimulants.
  ///
  /// In en, this message translates to:
  /// **'Stimulants: - Increase energy, alertness, and wakefulness. Such as Nicotine, Cocaine, Amphetamines and Caffeine.'**
  String get substanceTypeStimulants;

  /// No description provided for @substanceTypeOpioids.
  ///
  /// In en, this message translates to:
  /// **'Opioids: - These are pain-killing drugs that increase feelings of happiness or euphoria and create a tranquilizing effect. Heroin, morphine, opium, buprenorphine, methadone, pethidine and Cough syrup with codeine.'**
  String get substanceTypeOpioids;

  /// No description provided for @substanceTypeHallucinogens.
  ///
  /// In en, this message translates to:
  /// **'Hallucinogens: - They can also cause a person to perceive time differently, feel detached from their surroundings, or feel deeply insightful.'**
  String get substanceTypeHallucinogens;

  /// No description provided for @substanceEffectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Effects of substance abuse'**
  String get substanceEffectsTitle;

  /// No description provided for @substanceEffectsIntro.
  ///
  /// In en, this message translates to:
  /// **'Substance abuse refers to a pattern of using drugs or alcohol that leads to significant problems or distress in an individual\'s life. This can manifest in various ways, including:'**
  String get substanceEffectsIntro;

  /// No description provided for @substanceEffect1.
  ///
  /// In en, this message translates to:
  /// **'Increased risk of disease (Liver diseases, heart diseases, respiratory problems, HIV)'**
  String get substanceEffect1;

  /// No description provided for @substanceEffect2.
  ///
  /// In en, this message translates to:
  /// **'Mental health disorder increased risk of anxiety, depression etc.'**
  String get substanceEffect2;

  /// No description provided for @substanceEffect3.
  ///
  /// In en, this message translates to:
  /// **'Missing work or school due to substance use.'**
  String get substanceEffect3;

  /// No description provided for @substanceEffect4.
  ///
  /// In en, this message translates to:
  /// **'Engaging in dangerous activities while under the influence, such as driving.'**
  String get substanceEffect4;

  /// No description provided for @substanceEffect5.
  ///
  /// In en, this message translates to:
  /// **'Experiencing legal issues related to substance use.'**
  String get substanceEffect5;

  /// No description provided for @substanceEffect6.
  ///
  /// In en, this message translates to:
  /// **'Strained relationships with family and friends due to ongoing substance use.'**
  String get substanceEffect6;

  /// No description provided for @substanceEffect7.
  ///
  /// In en, this message translates to:
  /// **'Substance abuse can involve both illegal drugs (like heroin, cocaine, and methamphetamine) and the misuse of prescription drugs or legal substances.'**
  String get substanceEffect7;

  /// No description provided for @substanceSignsTitle.
  ///
  /// In en, this message translates to:
  /// **'Signs of a Substance Use Problem'**
  String get substanceSignsTitle;

  /// No description provided for @substanceSignsIntro.
  ///
  /// In en, this message translates to:
  /// **'Recognizing early behavioral and physical indicators helps individuals get timely care before severe complications arise:'**
  String get substanceSignsIntro;

  /// No description provided for @substanceSign1.
  ///
  /// In en, this message translates to:
  /// **'Compulsive cravings: Intense urges to consume the substance daily or multiple times a day.'**
  String get substanceSign1;

  /// No description provided for @substanceSign2.
  ///
  /// In en, this message translates to:
  /// **'Developing tolerance: Needing larger amounts over time to produce the initial desired effect.'**
  String get substanceSign2;

  /// No description provided for @substanceSign3.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal symptoms: Experiencing restlessness, tremors, sweating, anxiety, or nausea when attempting to stop.'**
  String get substanceSign3;

  /// No description provided for @substanceSign4.
  ///
  /// In en, this message translates to:
  /// **'Neglecting responsibilities: Falling behind in school performance, missing work shifts, or ignoring family duties.'**
  String get substanceSign4;

  /// No description provided for @substanceSign5.
  ///
  /// In en, this message translates to:
  /// **'Abandoning interests: Giving up sports, creative hobbies, and social activities once enjoyed.'**
  String get substanceSign5;

  /// No description provided for @substanceSign6.
  ///
  /// In en, this message translates to:
  /// **'Social withdrawal and secretive behavior: Withdrawing from family gatherings, hiding substance use, or drastic personality shifts.'**
  String get substanceSign6;

  /// No description provided for @substanceSignsHelpAlert.
  ///
  /// In en, this message translates to:
  /// **'Substance use disorder is a treatable health condition, not a sign of moral weakness. Youth mentors, counseling facilities, and national toll-free hotlines (952 or 8335) provide confidential, compassionate assistance.'**
  String get substanceSignsHelpAlert;

  /// No description provided for @substanceQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Substance Abuse Quiz'**
  String get substanceQuizTitle;

  /// No description provided for @substanceQ1Text.
  ///
  /// In en, this message translates to:
  /// **'Is substance use disorder (SUD) a treatable medical condition affecting the brain and behavior, rather than a failure of willpower or personal morality?'**
  String get substanceQ1Text;

  /// No description provided for @substanceQ1Insight.
  ///
  /// In en, this message translates to:
  /// **'Substance use disorders alter brain chemistry and neural reward pathways. Recognized by medical authorities worldwide, recovery is achievable through evidence-based treatment, counseling, and social support.'**
  String get substanceQ1Insight;

  /// No description provided for @substanceQ2Text.
  ///
  /// In en, this message translates to:
  /// **'Which category of substances slows down central nervous system function, heart rate, and brain activity (such as alcohol and sedatives)?'**
  String get substanceQ2Text;

  /// No description provided for @substanceQ2OptA.
  ///
  /// In en, this message translates to:
  /// **'Depressants'**
  String get substanceQ2OptA;

  /// No description provided for @substanceQ2OptB.
  ///
  /// In en, this message translates to:
  /// **'Stimulants'**
  String get substanceQ2OptB;

  /// No description provided for @substanceQ2OptC.
  ///
  /// In en, this message translates to:
  /// **'Hallucinogens'**
  String get substanceQ2OptC;

  /// No description provided for @substanceQ2OptD.
  ///
  /// In en, this message translates to:
  /// **'Vitamins'**
  String get substanceQ2OptD;

  /// No description provided for @substanceQ2Insight.
  ///
  /// In en, this message translates to:
  /// **'Depressants slow down neural messaging and heart rate, leading to reduced alertness and relaxation. In contrast, stimulants speed up the nervous system.'**
  String get substanceQ2Insight;

  /// No description provided for @substanceQ3Text.
  ///
  /// In en, this message translates to:
  /// **'What does developing \"tolerance\" mean when someone regularly consumes drugs or alcohol?'**
  String get substanceQ3Text;

  /// No description provided for @substanceQ3OptA.
  ///
  /// In en, this message translates to:
  /// **'The body needs increasingly larger amounts over time to produce the initial desired effect'**
  String get substanceQ3OptA;

  /// No description provided for @substanceQ3OptB.
  ///
  /// In en, this message translates to:
  /// **'The substance permanently leaves the body after a single use'**
  String get substanceQ3OptB;

  /// No description provided for @substanceQ3OptC.
  ///
  /// In en, this message translates to:
  /// **'The person can immediately stop taking the substance with zero symptoms'**
  String get substanceQ3OptC;

  /// No description provided for @substanceQ3OptD.
  ///
  /// In en, this message translates to:
  /// **'Having a complete natural immunity to all chemicals'**
  String get substanceQ3OptD;

  /// No description provided for @substanceQ3Insight.
  ///
  /// In en, this message translates to:
  /// **'Tolerance occurs when cells and brain receptors adapt to regular substance exposure, leading people to consume higher doses to feel the original impact.'**
  String get substanceQ3Insight;

  /// No description provided for @substanceQ4Text.
  ///
  /// In en, this message translates to:
  /// **'Substance abuse is both preventable and treatable, and free national health hotlines (952 or 8335) provide confidential, judgment-free support?'**
  String get substanceQ4Text;

  /// No description provided for @substanceQ4Insight.
  ///
  /// In en, this message translates to:
  /// **'Early intervention saves lives. Confidential health hotlines (952 or 8335) connect youth with empathetic professionals, referrals to youth-friendly centers, and recovery guidance.'**
  String get substanceQ4Insight;

  /// No description provided for @mentalHealthHeroDesc.
  ///
  /// In en, this message translates to:
  /// **'Mental health is an essential part of overall health, encompassing emotional, psychological, and social wellbeing. It influences how we think, feel, manage stress, connect with others, and make decisions throughout life.'**
  String get mentalHealthHeroDesc;

  /// No description provided for @mentalHealthNoteContent.
  ///
  /// In en, this message translates to:
  /// **'Mental health exists on a continuum and can be nurtured and healed—seeking support during tough times is a sign of courage and strength, not weakness.'**
  String get mentalHealthNoteContent;

  /// No description provided for @mentalHealthSection1Title.
  ///
  /// In en, this message translates to:
  /// **'Understanding Mental Health & Wellbeing'**
  String get mentalHealthSection1Title;

  /// No description provided for @mentalHealthSection1Desc1.
  ///
  /// In en, this message translates to:
  /// **'Mental health includes our emotional, psychological, and social wellbeing. It affects how we handle daily challenges, relate to friends and family, and make healthy lifestyle choices.'**
  String get mentalHealthSection1Desc1;

  /// No description provided for @mentalHealthSection1Desc2.
  ///
  /// In en, this message translates to:
  /// **'Good mental health does not mean feeling happy every moment. It means having the emotional resilience to navigate sadness, anger, stress, and joy in balanced, constructive ways.'**
  String get mentalHealthSection1Desc2;

  /// No description provided for @mentalHealthSection1Alert.
  ///
  /// In en, this message translates to:
  /// **'Mental health is just as important as physical health. The mind and body are deeply interconnected: prolonged physical illness impacts emotional health, and chronic stress directly triggers physical ailments.'**
  String get mentalHealthSection1Alert;

  /// No description provided for @mentalHealthSection2Title.
  ///
  /// In en, this message translates to:
  /// **'Common Challenges in Youth'**
  String get mentalHealthSection2Title;

  /// No description provided for @mentalHealthSection2Intro.
  ///
  /// In en, this message translates to:
  /// **'Young people experience intense transitions, biological changes, and social pressures. Common challenges include:'**
  String get mentalHealthSection2Intro;

  /// No description provided for @mentalHealthChallenge1.
  ///
  /// In en, this message translates to:
  /// **'Academic stress and burnout: Overwhelming anxiety about school grades, examinations, and future expectations.'**
  String get mentalHealthChallenge1;

  /// No description provided for @mentalHealthChallenge2.
  ///
  /// In en, this message translates to:
  /// **'General and social anxiety: Persistent, excessive worry about social situations, fear of judgment, or constant nervousness.'**
  String get mentalHealthChallenge2;

  /// No description provided for @mentalHealthChallenge3.
  ///
  /// In en, this message translates to:
  /// **'Depressive mood and sadness: Ongoing feelings of hopelessness, emptiness, loss of interest in favorite activities, and low energy.'**
  String get mentalHealthChallenge3;

  /// No description provided for @mentalHealthChallenge4.
  ///
  /// In en, this message translates to:
  /// **'Peer pressure and cyberbullying: Pressure to conform to unhealthy behaviors, fear of missing out (FOMO), or online harassment.'**
  String get mentalHealthChallenge4;

  /// No description provided for @mentalHealthSection3Title.
  ///
  /// In en, this message translates to:
  /// **'Positive Coping & Self-Care Strategies'**
  String get mentalHealthSection3Title;

  /// No description provided for @mentalHealthSection3Intro.
  ///
  /// In en, this message translates to:
  /// **'Building daily mental wellness practices helps protect against stress and strengthens emotional resilience:'**
  String get mentalHealthSection3Intro;

  /// No description provided for @mentalHealthStrategy1.
  ///
  /// In en, this message translates to:
  /// **'Daily physical movement: 30 minutes of walking, jogging, dancing, or sports naturally releases endorphins that boost mood and reduce tension.'**
  String get mentalHealthStrategy1;

  /// No description provided for @mentalHealthStrategy2.
  ///
  /// In en, this message translates to:
  /// **'Restful sleep hygiene: Consistent 7–9 hours of sleep per night stabilizes mood, memory, and cognitive focus.'**
  String get mentalHealthStrategy2;

  /// No description provided for @mentalHealthStrategy3.
  ///
  /// In en, this message translates to:
  /// **'Mindful breathing and relaxation: Deep belly breathing, quiet reflection, and grounding exercises calm the nervous system when overwhelmed.'**
  String get mentalHealthStrategy3;

  /// No description provided for @mentalHealthStrategy4.
  ///
  /// In en, this message translates to:
  /// **'Expressive outlets: Journaling feelings, creating art, music, or prayer and meditation provide safe emotional release.'**
  String get mentalHealthStrategy4;

  /// No description provided for @mentalHealthStrategy5.
  ///
  /// In en, this message translates to:
  /// **'Healthy boundaries: Learning to say \'no\' to overwhelming requests and limiting excessive, draining social media use.'**
  String get mentalHealthStrategy5;

  /// No description provided for @mentalHealthSection4Title.
  ///
  /// In en, this message translates to:
  /// **'Recognizing Warning Signs & Seeking Support'**
  String get mentalHealthSection4Title;

  /// No description provided for @mentalHealthSection4Intro.
  ///
  /// In en, this message translates to:
  /// **'It is important to recognize when stress or sadness has crossed into a health challenge that needs outside support:'**
  String get mentalHealthSection4Intro;

  /// No description provided for @mentalHealthSign1.
  ///
  /// In en, this message translates to:
  /// **'Prolonged withdrawal: Isolating completely from friends, family, and social activities for weeks.'**
  String get mentalHealthSign1;

  /// No description provided for @mentalHealthSign2.
  ///
  /// In en, this message translates to:
  /// **'Extreme mood shifts: Sudden, drastic fluctuations in personality, explosive anger, or extreme hopelessness.'**
  String get mentalHealthSign2;

  /// No description provided for @mentalHealthSign3.
  ///
  /// In en, this message translates to:
  /// **'Changes in sleeping or eating: Severe insomnia, sleeping all day, or major appetite and weight changes.'**
  String get mentalHealthSign3;

  /// No description provided for @mentalHealthSign4.
  ///
  /// In en, this message translates to:
  /// **'Turning to substances: Relying on alcohol, khat, or drugs to escape difficult feelings.'**
  String get mentalHealthSign4;

  /// No description provided for @mentalHealthSign5.
  ///
  /// In en, this message translates to:
  /// **'Thoughts of self-harm: Persistent thoughts of wanting to disappear, hurting oneself, or despair.'**
  String get mentalHealthSign5;

  /// No description provided for @mentalHealthHelpAlert.
  ///
  /// In en, this message translates to:
  /// **'You never have to carry emotional pain alone. Talking to a verified peer counselor, school counselor, or calling toll-free national health lines (952 or 8335) connects you with compassionate, 100% confidential support.'**
  String get mentalHealthHelpAlert;

  /// No description provided for @mentalHealthQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Mental Health & Wellbeing Quiz'**
  String get mentalHealthQuizTitle;

  /// No description provided for @mentalHealthQ1Text.
  ///
  /// In en, this message translates to:
  /// **'Mental health is just as important as physical health, and experiencing emotional struggles is a medical condition, not a sign of personal weakness?'**
  String get mentalHealthQ1Text;

  /// No description provided for @mentalHealthQ1Insight.
  ///
  /// In en, this message translates to:
  /// **'Mental health is a fundamental component of total health. Seeking support for emotional distress is a responsible, courageous step toward wellbeing.'**
  String get mentalHealthQ1Insight;

  /// No description provided for @mentalHealthQ2Text.
  ///
  /// In en, this message translates to:
  /// **'Which of the following is a healthy, effective way to manage everyday stress and emotional overwhelm?'**
  String get mentalHealthQ2Text;

  /// No description provided for @mentalHealthQ2OptA.
  ///
  /// In en, this message translates to:
  /// **'Regular physical exercise, mindful breathing, and getting 7–9 hours of sleep'**
  String get mentalHealthQ2OptA;

  /// No description provided for @mentalHealthQ2OptB.
  ///
  /// In en, this message translates to:
  /// **'Isolating yourself in your room and avoiding talking to anyone'**
  String get mentalHealthQ2OptB;

  /// No description provided for @mentalHealthQ2OptC.
  ///
  /// In en, this message translates to:
  /// **'Using alcohol or drugs to numb difficult emotions'**
  String get mentalHealthQ2OptC;

  /// No description provided for @mentalHealthQ2OptD.
  ///
  /// In en, this message translates to:
  /// **'Skipping meals and staying awake all night'**
  String get mentalHealthQ2OptD;

  /// No description provided for @mentalHealthQ2Insight.
  ///
  /// In en, this message translates to:
  /// **'Physical activity releases mood-lifting endorphins, while adequate sleep and deep breathing reset the autonomic nervous system.'**
  String get mentalHealthQ2Insight;

  /// No description provided for @mentalHealthQ3Text.
  ///
  /// In en, this message translates to:
  /// **'Does good mental health mean you should feel happy and positive every single moment of your life?'**
  String get mentalHealthQ3Text;

  /// No description provided for @mentalHealthQ3Insight.
  ///
  /// In en, this message translates to:
  /// **'Good mental health involves experiencing the full range of human emotions (including sadness, frustration, and grief) and having healthy tools to process them.'**
  String get mentalHealthQ3Insight;

  /// No description provided for @mentalHealthQ4Text.
  ///
  /// In en, this message translates to:
  /// **'If you or a friend are feeling overwhelmed by sadness or anxiety for several weeks, what is the best course of action?'**
  String get mentalHealthQ4Text;

  /// No description provided for @mentalHealthQ4OptA.
  ///
  /// In en, this message translates to:
  /// **'Reach out to a trusted counselor, youth mentor, or call toll-free hotlines 952 / 8335'**
  String get mentalHealthQ4OptA;

  /// No description provided for @mentalHealthQ4OptB.
  ///
  /// In en, this message translates to:
  /// **'Keep it completely secret and hope it goes away on its own'**
  String get mentalHealthQ4OptB;

  /// No description provided for @mentalHealthQ4OptC.
  ///
  /// In en, this message translates to:
  /// **'Criticize the friend for feeling sad'**
  String get mentalHealthQ4OptC;

  /// No description provided for @mentalHealthQ4OptD.
  ///
  /// In en, this message translates to:
  /// **'Ignore school and stop eating'**
  String get mentalHealthQ4OptD;

  /// No description provided for @mentalHealthQ4Insight.
  ///
  /// In en, this message translates to:
  /// **'Early conversations with peer mentors, counselors, or calling national hotlines (952 or 8335) provide confidential, life-saving support.'**
  String get mentalHealthQ4Insight;

  /// No description provided for @gbvHeroDesc.
  ///
  /// In en, this message translates to:
  /// **'Gender-based violence is harmful behavior directed at individuals based on gender, caused by inequality and cultural norms, leading to serious physical, psychological, social, and economic consequences, but it can be addressed through prevention, support services, and legal protection.'**
  String get gbvHeroDesc;

  /// No description provided for @gbvNoteContent.
  ///
  /// In en, this message translates to:
  /// **'GBV is preventable—promoting respect, equality, and early support for survivors helps build safer communities and protects human dignity.'**
  String get gbvNoteContent;

  /// No description provided for @gbvSection1Title.
  ///
  /// In en, this message translates to:
  /// **'Definition'**
  String get gbvSection1Title;

  /// No description provided for @gbvSection1Desc1.
  ///
  /// In en, this message translates to:
  /// **'Gender-based violence (GBV) refers to harmful acts directed at an individual based on their gender. It can occur in any context, but it most often affects women and girls, though men and boys can also experience it. GBV is a violation of human rights and a major barrier to achieving gender equality and social justice.'**
  String get gbvSection1Desc1;

  /// No description provided for @gbvSection1Desc2.
  ///
  /// In en, this message translates to:
  /// **'In humanitarian settings, responding to sexual violence has been a priority because conflict-related violence, in particular rape as a tactic of war, has received international attention. However, there is growing recognition that populations affected by conflict and natural disaster experience various forms of GBV during crisis and displacement, and during and following return. In particular, intimate partner violence is increasingly recognized as a critical concern in humanitarian settings. Gender based violence can manifest in various forms, including:'**
  String get gbvSection1Desc2;

  /// No description provided for @gbvForm1Title.
  ///
  /// In en, this message translates to:
  /// **'Physical Violence'**
  String get gbvForm1Title;

  /// No description provided for @gbvForm1Item1Title.
  ///
  /// In en, this message translates to:
  /// **'Domestic violence (intimate partner violence):'**
  String get gbvForm1Item1Title;

  /// No description provided for @gbvForm1Item1Body.
  ///
  /// In en, this message translates to:
  /// **'Includes hitting, slapping, kicking, and other forms of physical abuse within intimate relationships.'**
  String get gbvForm1Item1Body;

  /// No description provided for @gbvForm1Item2Title.
  ///
  /// In en, this message translates to:
  /// **'Sexual violence:'**
  String get gbvForm1Item2Title;

  /// No description provided for @gbvForm1Item2Body.
  ///
  /// In en, this message translates to:
  /// **'Forced or coerced sexual acts, including rape, sexual assault, and harassment.'**
  String get gbvForm1Item2Body;

  /// No description provided for @gbvForm2Title.
  ///
  /// In en, this message translates to:
  /// **'Psychological/Emotional Violence'**
  String get gbvForm2Title;

  /// No description provided for @gbvForm2Item1Title.
  ///
  /// In en, this message translates to:
  /// **'Verbal abuse:'**
  String get gbvForm2Item1Title;

  /// No description provided for @gbvForm2Item1Body.
  ///
  /// In en, this message translates to:
  /// **'Insults, threats, humiliation, and controlling behaviors that undermine the victim\'s sense of self-worth.'**
  String get gbvForm2Item1Body;

  /// No description provided for @gbvForm2Item2Title.
  ///
  /// In en, this message translates to:
  /// **'Isolation:'**
  String get gbvForm2Item2Title;

  /// No description provided for @gbvForm2Item2Body.
  ///
  /// In en, this message translates to:
  /// **'Forcing a victim to cut ties with family and friends.'**
  String get gbvForm2Item2Body;

  /// No description provided for @gbvForm2Item3Title.
  ///
  /// In en, this message translates to:
  /// **'Coercive control:'**
  String get gbvForm2Item3Title;

  /// No description provided for @gbvForm2Item3Body.
  ///
  /// In en, this message translates to:
  /// **'A pattern of controlling behavior that limits a person’s freedom, such as dictating what they wear, where they go, or who they interact with.'**
  String get gbvForm2Item3Body;

  /// No description provided for @gbvForm3Title.
  ///
  /// In en, this message translates to:
  /// **'Sexual Violence and Exploitation'**
  String get gbvForm3Title;

  /// No description provided for @gbvForm3Item1Title.
  ///
  /// In en, this message translates to:
  /// **'Rape:'**
  String get gbvForm3Item1Title;

  /// No description provided for @gbvForm3Item1Body.
  ///
  /// In en, this message translates to:
  /// **'Non-consensual sexual intercourse.'**
  String get gbvForm3Item1Body;

  /// No description provided for @gbvForm3Item2Title.
  ///
  /// In en, this message translates to:
  /// **'Sexual harassment:'**
  String get gbvForm3Item2Title;

  /// No description provided for @gbvForm3Item2Body.
  ///
  /// In en, this message translates to:
  /// **'Unwanted sexual advances or behavior, often in the workplace, school, or public spaces.'**
  String get gbvForm3Item2Body;

  /// No description provided for @gbvForm3Item3Title.
  ///
  /// In en, this message translates to:
  /// **'Trafficking:'**
  String get gbvForm3Item3Title;

  /// No description provided for @gbvForm3Item3Body.
  ///
  /// In en, this message translates to:
  /// **'The illegal trade of people for sexual exploitation or forced labor.'**
  String get gbvForm3Item3Body;

  /// No description provided for @gbvForm4Title.
  ///
  /// In en, this message translates to:
  /// **'Economic Violence'**
  String get gbvForm4Title;

  /// No description provided for @gbvForm4Item1Title.
  ///
  /// In en, this message translates to:
  /// **'Withholding financial resources:'**
  String get gbvForm4Item1Title;

  /// No description provided for @gbvForm4Item1Body.
  ///
  /// In en, this message translates to:
  /// **'Preventing a partner from accessing money or resources, controlling their economic independence.'**
  String get gbvForm4Item1Body;

  /// No description provided for @gbvForm4Item2Title.
  ///
  /// In en, this message translates to:
  /// **'Coercion through financial dependence:'**
  String get gbvForm4Item2Title;

  /// No description provided for @gbvForm4Item2Body.
  ///
  /// In en, this message translates to:
  /// **'Using financial control as a way to maintain power over someone.'**
  String get gbvForm4Item2Body;

  /// No description provided for @gbvForm5Title.
  ///
  /// In en, this message translates to:
  /// **'Harmful Traditional Practices'**
  String get gbvForm5Title;

  /// No description provided for @gbvForm5Item1Title.
  ///
  /// In en, this message translates to:
  /// **'Female genital mutilation/cutting (FGM/C):'**
  String get gbvForm5Item1Title;

  /// No description provided for @gbvForm5Item1Body.
  ///
  /// In en, this message translates to:
  /// **'The practice of partially or completely removing the female genitalia for non-medical reasons, often as a means of controlling women\'s sexuality.'**
  String get gbvForm5Item1Body;

  /// No description provided for @gbvForm5Item2Title.
  ///
  /// In en, this message translates to:
  /// **'Early or forced marriage:'**
  String get gbvForm5Item2Title;

  /// No description provided for @gbvForm5Item2Body.
  ///
  /// In en, this message translates to:
  /// **'Marrying off young girls or individuals without their consent, often as a result of cultural practices.'**
  String get gbvForm5Item2Body;

  /// No description provided for @gbvForm5Item3Title.
  ///
  /// In en, this message translates to:
  /// **'Honor killings:'**
  String get gbvForm5Item3Title;

  /// No description provided for @gbvForm5Item3Body.
  ///
  /// In en, this message translates to:
  /// **'The killing of a family member, typically a woman or girl, for bringing perceived dishonor or shame upon the family or community.'**
  String get gbvForm5Item3Body;

  /// No description provided for @gbvSection2Title.
  ///
  /// In en, this message translates to:
  /// **'Sex and Gender'**
  String get gbvSection2Title;

  /// No description provided for @gbvSection2Desc1.
  ///
  /// In en, this message translates to:
  /// **'Understanding the distinction between sex and gender is essential for addressing gender-based violence. Sex refers to biological and physiological characteristics, such as chromosomes, hormones, and reproductive organs. Gender refers to the socially constructed roles, behaviors, expressions, and identities that society considers appropriate for men, women, and gender-diverse individuals.'**
  String get gbvSection2Desc1;

  /// No description provided for @gbvSection2Desc2.
  ///
  /// In en, this message translates to:
  /// **'Gender norms dictate how individuals are expected to act, speak, dress, and interact based on their assigned sex. When rigid patriarchal expectations grant unequal power, authority, or entitlement to one group over another, it creates a systemic imbalance that justifies or normalizes violence and discrimination.'**
  String get gbvSection2Desc2;

  /// No description provided for @gbvSection3Title.
  ///
  /// In en, this message translates to:
  /// **'Consequences of gender-based violence'**
  String get gbvSection3Title;

  /// No description provided for @gbvConsequenceBullet1.
  ///
  /// In en, this message translates to:
  /// **'Physical, injury, disability, chronic health problem, sexual and reproductive health problems, death'**
  String get gbvConsequenceBullet1;

  /// No description provided for @gbvConsequenceBullet2.
  ///
  /// In en, this message translates to:
  /// **'Psychological, anxiety, fear, loneliness depression, alcohol or drug use suicide'**
  String get gbvConsequenceBullet2;

  /// No description provided for @gbvConsequenceBullet3.
  ///
  /// In en, this message translates to:
  /// **'Economic and social impact, reduced ability to participate in social and economic activities, social stigma at community level, negative impact on women income generating power, increased vulnerability to other types of gender-based violence'**
  String get gbvConsequenceBullet3;

  /// No description provided for @gbvConsequenceBullet4.
  ///
  /// In en, this message translates to:
  /// **'The impact on women family and dependents, divorce, or broken families, jeopardize family\'s economic and emotional development, emotional and behavioral disturbances'**
  String get gbvConsequenceBullet4;

  /// No description provided for @gbvConsequenceBullet5.
  ///
  /// In en, this message translates to:
  /// **'Emotional Consequences, Depression stress, low self esteem'**
  String get gbvConsequenceBullet5;

  /// No description provided for @gbvTableTitle.
  ///
  /// In en, this message translates to:
  /// **'Consequences of GBV'**
  String get gbvTableTitle;

  /// No description provided for @gbvTableColPhysical.
  ///
  /// In en, this message translates to:
  /// **'Physical health consequences'**
  String get gbvTableColPhysical;

  /// No description provided for @gbvTableColPsychological.
  ///
  /// In en, this message translates to:
  /// **'Psychological health consequences'**
  String get gbvTableColPsychological;

  /// No description provided for @gbvTableColSocial.
  ///
  /// In en, this message translates to:
  /// **'Social & Economic consequences'**
  String get gbvTableColSocial;

  /// No description provided for @gbvTablePhys1.
  ///
  /// In en, this message translates to:
  /// **'Physical injury'**
  String get gbvTablePhys1;

  /// No description provided for @gbvTablePhys2.
  ///
  /// In en, this message translates to:
  /// **'HIV/AIDS'**
  String get gbvTablePhys2;

  /// No description provided for @gbvTablePhys3.
  ///
  /// In en, this message translates to:
  /// **'STIs'**
  String get gbvTablePhys3;

  /// No description provided for @gbvTablePhys4.
  ///
  /// In en, this message translates to:
  /// **'Unwanted pregnancy'**
  String get gbvTablePhys4;

  /// No description provided for @gbvTablePhys5.
  ///
  /// In en, this message translates to:
  /// **'Unsafe abortion'**
  String get gbvTablePhys5;

  /// No description provided for @gbvTablePhys6.
  ///
  /// In en, this message translates to:
  /// **'Fistula'**
  String get gbvTablePhys6;

  /// No description provided for @gbvTablePhys7.
  ///
  /// In en, this message translates to:
  /// **'Death'**
  String get gbvTablePhys7;

  /// No description provided for @gbvTablePsych1.
  ///
  /// In en, this message translates to:
  /// **'Depression'**
  String get gbvTablePsych1;

  /// No description provided for @gbvTablePsych2.
  ///
  /// In en, this message translates to:
  /// **'Fear'**
  String get gbvTablePsych2;

  /// No description provided for @gbvTablePsych3.
  ///
  /// In en, this message translates to:
  /// **'Self-blame'**
  String get gbvTablePsych3;

  /// No description provided for @gbvTablePsych4.
  ///
  /// In en, this message translates to:
  /// **'Anxiety'**
  String get gbvTablePsych4;

  /// No description provided for @gbvTablePsych5.
  ///
  /// In en, this message translates to:
  /// **'Mental illness'**
  String get gbvTablePsych5;

  /// No description provided for @gbvTablePsych6.
  ///
  /// In en, this message translates to:
  /// **'Suicidal thoughts/actions'**
  String get gbvTablePsych6;

  /// No description provided for @gbvTableSoc1.
  ///
  /// In en, this message translates to:
  /// **'Victim-blaming'**
  String get gbvTableSoc1;

  /// No description provided for @gbvTableSoc2.
  ///
  /// In en, this message translates to:
  /// **'Stigmatisation'**
  String get gbvTableSoc2;

  /// No description provided for @gbvTableSoc3.
  ///
  /// In en, this message translates to:
  /// **'Rejection'**
  String get gbvTableSoc3;

  /// No description provided for @gbvTableSoc4.
  ///
  /// In en, this message translates to:
  /// **'Isolation'**
  String get gbvTableSoc4;

  /// No description provided for @gbvTableSoc5.
  ///
  /// In en, this message translates to:
  /// **'Decreased earning capacity/contribution'**
  String get gbvTableSoc5;

  /// No description provided for @gbvTableSoc6.
  ///
  /// In en, this message translates to:
  /// **'Increased poverty'**
  String get gbvTableSoc6;

  /// No description provided for @gbvTableSoc7.
  ///
  /// In en, this message translates to:
  /// **'Risk of re-victimization'**
  String get gbvTableSoc7;

  /// No description provided for @gbvSection4Title.
  ///
  /// In en, this message translates to:
  /// **'Management and Prevention of Gender-Based Violence (GBV)'**
  String get gbvSection4Title;

  /// No description provided for @gbvSec4Main1Title.
  ///
  /// In en, this message translates to:
  /// **'Immediate Response: Management of GBV'**
  String get gbvSec4Main1Title;

  /// No description provided for @gbvSec4Main1Intro.
  ///
  /// In en, this message translates to:
  /// **'When GBV occurs, immediate intervention is necessary to support survivors and address the situation.'**
  String get gbvSec4Main1Intro;

  /// No description provided for @gbvSec4SubATitle.
  ///
  /// In en, this message translates to:
  /// **'Providing Safety and Protection'**
  String get gbvSec4SubATitle;

  /// No description provided for @gbvSec4SubA1Title.
  ///
  /// In en, this message translates to:
  /// **'Safe spaces:'**
  String get gbvSec4SubA1Title;

  /// No description provided for @gbvSec4SubA1Body.
  ///
  /// In en, this message translates to:
  /// **'Shelters and crisis centers provide immediate refuge for survivors.'**
  String get gbvSec4SubA1Body;

  /// No description provided for @gbvSec4SubA2Title.
  ///
  /// In en, this message translates to:
  /// **'Hotlines and crisis counseling:'**
  String get gbvSec4SubA2Title;

  /// No description provided for @gbvSec4SubA2Body.
  ///
  /// In en, this message translates to:
  /// **'support services to offer guidance, emotional support, and legal advice.'**
  String get gbvSec4SubA2Body;

  /// No description provided for @gbvSec4SubA3Title.
  ///
  /// In en, this message translates to:
  /// **'Protection orders:'**
  String get gbvSec4SubA3Title;

  /// No description provided for @gbvSec4SubA3Body.
  ///
  /// In en, this message translates to:
  /// **'Legal measures to prevent abusers from contacting or approaching survivors. In some cases, law enforcement involvement may be necessary to ensure the safety of survivors and hold perpetrators accountable.'**
  String get gbvSec4SubA3Body;

  /// No description provided for @gbvSec4SubA4Title.
  ///
  /// In en, this message translates to:
  /// **'Medical care:'**
  String get gbvSec4SubA4Title;

  /// No description provided for @gbvSec4SubA4Body.
  ///
  /// In en, this message translates to:
  /// **'Ensuring that survivors receive prompt medical attention, including trauma care and sexual health services.'**
  String get gbvSec4SubA4Body;

  /// No description provided for @gbvSec4SubBTitle.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive Support Services'**
  String get gbvSec4SubBTitle;

  /// No description provided for @gbvSec4SubB1Title.
  ///
  /// In en, this message translates to:
  /// **'Psychosocial support:'**
  String get gbvSec4SubB1Title;

  /// No description provided for @gbvSec4SubB1Body.
  ///
  /// In en, this message translates to:
  /// **'Counseling and therapy to help survivors heal from trauma.'**
  String get gbvSec4SubB1Body;

  /// No description provided for @gbvSec4SubB2Title.
  ///
  /// In en, this message translates to:
  /// **'Legal aid:'**
  String get gbvSec4SubB2Title;

  /// No description provided for @gbvSec4SubB2Body.
  ///
  /// In en, this message translates to:
  /// **'Support to navigate the legal system, file reports, and pursue justice.'**
  String get gbvSec4SubB2Body;

  /// No description provided for @gbvSec4SubB3Title.
  ///
  /// In en, this message translates to:
  /// **'Economic support:'**
  String get gbvSec4SubB3Title;

  /// No description provided for @gbvSec4SubB3Body.
  ///
  /// In en, this message translates to:
  /// **'Assistance in rebuilding financial independence, including job training, micro-loans, or cash support.'**
  String get gbvSec4SubB3Body;

  /// No description provided for @gbvSec4Main2Title.
  ///
  /// In en, this message translates to:
  /// **'Preventing GBV'**
  String get gbvSec4Main2Title;

  /// No description provided for @gbvSec4Main2Intro.
  ///
  /// In en, this message translates to:
  /// **'Prevention strategies focus on addressing the root causes of violence and working toward a society where GBV is not tolerated.'**
  String get gbvSec4Main2Intro;

  /// No description provided for @gbvSec4Sub2ATitle.
  ///
  /// In en, this message translates to:
  /// **'Changing Social Norms and Attitudes'**
  String get gbvSec4Sub2ATitle;

  /// No description provided for @gbvSec4Sub2A1Title.
  ///
  /// In en, this message translates to:
  /// **'Public awareness campaigns:'**
  String get gbvSec4Sub2A1Title;

  /// No description provided for @gbvSec4Sub2A1Body.
  ///
  /// In en, this message translates to:
  /// **'Educating communities on the harmful effects of GBV, promoting gender equality, and challenging stereotypes.'**
  String get gbvSec4Sub2A1Body;

  /// No description provided for @gbvSec4Sub2A2Title.
  ///
  /// In en, this message translates to:
  /// **'Media advocacy:'**
  String get gbvSec4Sub2A2Title;

  /// No description provided for @gbvSec4Sub2A2Body.
  ///
  /// In en, this message translates to:
  /// **'Using films, social media, and other platforms to spread messages about healthy relationships and the importance of respect for all genders.'**
  String get gbvSec4Sub2A2Body;

  /// No description provided for @gbvSec4Sub2A3Title.
  ///
  /// In en, this message translates to:
  /// **'School programs:'**
  String get gbvSec4Sub2A3Title;

  /// No description provided for @gbvSec4Sub2A3Body.
  ///
  /// In en, this message translates to:
  /// **'Implementing educational curricula that promote respect, gender equality, and healthy relationships.'**
  String get gbvSec4Sub2A3Body;

  /// No description provided for @gbvSec4Sub2A4Title.
  ///
  /// In en, this message translates to:
  /// **'Community dialogues:'**
  String get gbvSec4Sub2A4Title;

  /// No description provided for @gbvSec4Sub2A4Body.
  ///
  /// In en, this message translates to:
  /// **'Facilitating conversations between different groups (e.g., community leaders, youth, men, and women) to address the cultural norms that perpetuate violence.'**
  String get gbvSec4Sub2A4Body;

  /// No description provided for @gbvSec4Sub2BTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal and Policy Reform'**
  String get gbvSec4Sub2BTitle;

  /// No description provided for @gbvSec4Sub2B1Title.
  ///
  /// In en, this message translates to:
  /// **'Strengthening laws:'**
  String get gbvSec4Sub2B1Title;

  /// No description provided for @gbvSec4Sub2B1Body.
  ///
  /// In en, this message translates to:
  /// **'Enacting and enforcing laws that specifically address GBV, such as domestic violence laws, sexual harassment regulations, and anti-human trafficking laws.'**
  String get gbvSec4Sub2B1Body;

  /// No description provided for @gbvSec4Sub2B2Title.
  ///
  /// In en, this message translates to:
  /// **'Supporting survivors\' rights:'**
  String get gbvSec4Sub2B2Title;

  /// No description provided for @gbvSec4Sub2B2Body.
  ///
  /// In en, this message translates to:
  /// **'Ensuring that survivors of GBV have access to justice and are not revictimized by legal or societal systems.'**
  String get gbvSec4Sub2B2Body;

  /// No description provided for @gbvSec4Sub2B3Title.
  ///
  /// In en, this message translates to:
  /// **'Gender-sensitive law enforcement:'**
  String get gbvSec4Sub2B3Title;

  /// No description provided for @gbvSec4Sub2B3Body.
  ///
  /// In en, this message translates to:
  /// **'Training police and other law enforcement officers on how to respond appropriately to GBV cases, including sensitivity to gender issues and survivor trauma.'**
  String get gbvSec4Sub2B3Body;

  /// No description provided for @gbvSec4Sub2CTitle.
  ///
  /// In en, this message translates to:
  /// **'Empowering Women and Gender Minorities'**
  String get gbvSec4Sub2CTitle;

  /// No description provided for @gbvSec4Sub2C1Title.
  ///
  /// In en, this message translates to:
  /// **'Economic empowerment:'**
  String get gbvSec4Sub2C1Title;

  /// No description provided for @gbvSec4Sub2C1Body.
  ///
  /// In en, this message translates to:
  /// **'Providing women and marginalized genders with access to education, employment, and financial independence reduces their vulnerability to abuse.'**
  String get gbvSec4Sub2C1Body;

  /// No description provided for @gbvSec4Sub2C2Title.
  ///
  /// In en, this message translates to:
  /// **'Leadership training:'**
  String get gbvSec4Sub2C2Title;

  /// No description provided for @gbvSec4Sub2C2Body.
  ///
  /// In en, this message translates to:
  /// **'Encouraging the participation of women and gender minorities in leadership positions in politics, business, and social spheres to create role models and disrupt patriarchal structures.'**
  String get gbvSec4Sub2C2Body;

  /// No description provided for @gbvSec4Sub2C3Title.
  ///
  /// In en, this message translates to:
  /// **'Men as allies:'**
  String get gbvSec4Sub2C3Title;

  /// No description provided for @gbvSec4Sub2C3Body.
  ///
  /// In en, this message translates to:
  /// **'Engaging men and boys in GBV prevention efforts, emphasizing positive masculinity, healthy relationships, and shared responsibility in addressing violence.'**
  String get gbvSec4Sub2C3Body;

  /// No description provided for @gbvSec4Sub2DTitle.
  ///
  /// In en, this message translates to:
  /// **'Community-based Approaches'**
  String get gbvSec4Sub2DTitle;

  /// No description provided for @gbvSec4Sub2D1Title.
  ///
  /// In en, this message translates to:
  /// **'Community mobilization:'**
  String get gbvSec4Sub2D1Title;

  /// No description provided for @gbvSec4Sub2D1Body.
  ///
  /// In en, this message translates to:
  /// **'Working with community leaders, religious figures, and local organizations to promote zero-tolerance for GBV and to create a supportive environment for survivors.'**
  String get gbvSec4Sub2D1Body;

  /// No description provided for @gbvSec4Sub2D2Title.
  ///
  /// In en, this message translates to:
  /// **'Self-help groups and peer support:'**
  String get gbvSec4Sub2D2Title;

  /// No description provided for @gbvSec4Sub2D2Body.
  ///
  /// In en, this message translates to:
  /// **'Creating spaces where survivors can support each other and share their experiences, empowering individuals to speak out and seek help.'**
  String get gbvSec4Sub2D2Body;

  /// No description provided for @gbvSec4Sub2ETitle.
  ///
  /// In en, this message translates to:
  /// **'Education and Awareness'**
  String get gbvSec4Sub2ETitle;

  /// No description provided for @gbvSec4Sub2E1Title.
  ///
  /// In en, this message translates to:
  /// **'School curricula:'**
  String get gbvSec4Sub2E1Title;

  /// No description provided for @gbvSec4Sub2E1Body.
  ///
  /// In en, this message translates to:
  /// **'Educating young people about consent, respectful relationships, and healthy sexuality.'**
  String get gbvSec4Sub2E1Body;

  /// No description provided for @gbvSec4Sub2E2Title.
  ///
  /// In en, this message translates to:
  /// **'Workplace training:'**
  String get gbvSec4Sub2E2Title;

  /// No description provided for @gbvSec4Sub2E2Body.
  ///
  /// In en, this message translates to:
  /// **'Developing policies and training programs to prevent sexual harassment and abuse in the workplace, ensuring there are clear reporting channels.'**
  String get gbvSec4Sub2E2Body;

  /// No description provided for @gbvSec4Sub2E3Title.
  ///
  /// In en, this message translates to:
  /// **'Public campaigns:'**
  String get gbvSec4Sub2E3Title;

  /// No description provided for @gbvSec4Sub2E3Body.
  ///
  /// In en, this message translates to:
  /// **'Using media to raise awareness about GBV and challenge harmful norms related to gender and violence.'**
  String get gbvSec4Sub2E3Body;

  /// No description provided for @gbvSec4Main3Title.
  ///
  /// In en, this message translates to:
  /// **'Long-Term Strategies: Changing Structural and Cultural Factors'**
  String get gbvSec4Main3Title;

  /// No description provided for @gbvSec4Main3Intro.
  ///
  /// In en, this message translates to:
  /// **'Long-term efforts are required to address the underlying social, cultural, and economic factors that sustain GBV.'**
  String get gbvSec4Main3Intro;

  /// No description provided for @gbvSec4Sub3ATitle.
  ///
  /// In en, this message translates to:
  /// **'Addressing Gender Inequality'**
  String get gbvSec4Sub3ATitle;

  /// No description provided for @gbvSec4Sub3A1Title.
  ///
  /// In en, this message translates to:
  /// **'Promote gender equality:'**
  String get gbvSec4Sub3A1Title;

  /// No description provided for @gbvSec4Sub3A1Body.
  ///
  /// In en, this message translates to:
  /// **'Ensure equal rights for all genders in areas such as education, employment, healthcare, and political participation.'**
  String get gbvSec4Sub3A1Body;

  /// No description provided for @gbvSec4Sub3A2Title.
  ///
  /// In en, this message translates to:
  /// **'Strengthen women\'s rights:'**
  String get gbvSec4Sub3A2Title;

  /// No description provided for @gbvSec4Sub3A2Body.
  ///
  /// In en, this message translates to:
  /// **'Advocate for women\'s legal and social rights, including property rights, inheritance, and access to public services.'**
  String get gbvSec4Sub3A2Body;

  /// No description provided for @gbvSec4Sub3A3Title.
  ///
  /// In en, this message translates to:
  /// **'End discriminatory practices:'**
  String get gbvSec4Sub3A3Title;

  /// No description provided for @gbvSec4Sub3A3Body.
  ///
  /// In en, this message translates to:
  /// **'Combat harmful traditional practices like child marriage, dowry-related violence, and FGM, often rooted in patriarchal social structures.'**
  String get gbvSec4Sub3A3Body;

  /// No description provided for @gbvSec4Sub3BTitle.
  ///
  /// In en, this message translates to:
  /// **'Engaging Men and Boys'**
  String get gbvSec4Sub3BTitle;

  /// No description provided for @gbvSec4Sub3B1Title.
  ///
  /// In en, this message translates to:
  /// **'Positive masculinity:'**
  String get gbvSec4Sub3B1Title;

  /// No description provided for @gbvSec4Sub3B1Body.
  ///
  /// In en, this message translates to:
  /// **'Promote a model of masculinity that is non-violent, respectful, and supportive of gender equality.'**
  String get gbvSec4Sub3B1Body;

  /// No description provided for @gbvSec4Sub3B2Title.
  ///
  /// In en, this message translates to:
  /// **'Anti-violence programs:'**
  String get gbvSec4Sub3B2Title;

  /// No description provided for @gbvSec4Sub3B2Body.
  ///
  /// In en, this message translates to:
  /// **'Educate boys and men about the harmful effects of violence and the importance of being allies in the fight against GBV.'**
  String get gbvSec4Sub3B2Body;

  /// No description provided for @gbvSection4HelpAlert.
  ///
  /// In en, this message translates to:
  /// **'If you or someone you know is experiencing violence or abuse, you are not alone. Safe, confidential medical and legal support is available. Call the national toll-free emergency lines 952, 8335, or 7711 immediately.'**
  String get gbvSection4HelpAlert;

  /// No description provided for @learningSectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning Sections'**
  String get learningSectionsTitle;

  /// No description provided for @readSectionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} / {total} read'**
  String readSectionsCount(int count, int total);

  /// No description provided for @hivDefinitionTitle.
  ///
  /// In en, this message translates to:
  /// **'Defination'**
  String get hivDefinitionTitle;

  /// No description provided for @hivDefinitionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What is HIV/AIDS and how it affects the immune system'**
  String get hivDefinitionSubtitle;

  /// No description provided for @hivDefinitionDesc1.
  ///
  /// In en, this message translates to:
  /// **'HIV (Human Immunodeficiency Virus) is a virus that attacks the body’s immune system, specifically the CD4 white blood cells (T cells) that fight off infections.'**
  String get hivDefinitionDesc1;

  /// No description provided for @hivDefinitionDesc2.
  ///
  /// In en, this message translates to:
  /// **'Without treatment, HIV can gradually destroy CD4 cells over time and advance to AIDS (Acquired Immunodeficiency Syndrome), which is the most advanced clinical stage of HIV infection.'**
  String get hivDefinitionDesc2;

  /// No description provided for @hivDefinitionDesc3.
  ///
  /// In en, this message translates to:
  /// **'With modern antiretroviral therapy (ART), people living with HIV suppress the virus to undetectable levels (Undetectable = Untransmittable or U=U), stay healthy, and live long, normal lives.'**
  String get hivDefinitionDesc3;

  /// No description provided for @hivTransmissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Mode of transmission'**
  String get hivTransmissionTitle;

  /// No description provided for @hivTransmissionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How the virus spreads and debunking common myths'**
  String get hivTransmissionSubtitle;

  /// No description provided for @hivTransmissionIntro.
  ///
  /// In en, this message translates to:
  /// **'HIV is transmitted through contact with specific body fluids from someone with a detectable viral load:'**
  String get hivTransmissionIntro;

  /// No description provided for @hivTransmissionItem1.
  ///
  /// In en, this message translates to:
  /// **'Unprotected sexual intercourse (vaginal or anal sex without condoms).'**
  String get hivTransmissionItem1;

  /// No description provided for @hivTransmissionItem2.
  ///
  /// In en, this message translates to:
  /// **'Sharing contaminated needles, syringes, tattoo needles, or sharp piercing instruments.'**
  String get hivTransmissionItem2;

  /// No description provided for @hivTransmissionItem3.
  ///
  /// In en, this message translates to:
  /// **'Mother-to-child transmission during pregnancy, childbirth, or breastfeeding (largely preventable through PMTCT care).'**
  String get hivTransmissionItem3;

  /// No description provided for @hivTransmissionItem4.
  ///
  /// In en, this message translates to:
  /// **'Transfusion of unscreened blood (extremely rare due to universal laboratory screening).'**
  String get hivTransmissionItem4;

  /// No description provided for @hivNotTransmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'How HIV is NOT transmitted:'**
  String get hivNotTransmittedTitle;

  /// No description provided for @hivNotTransmittedDesc.
  ///
  /// In en, this message translates to:
  /// **'HIV cannot survive outside the human body. It is NOT spread through shaking hands, hugging, coughing, sneezing, sharing food or toilets, swimming pools, or mosquito/insect bites.'**
  String get hivNotTransmittedDesc;

  /// No description provided for @hivPreventionTitle.
  ///
  /// In en, this message translates to:
  /// **'HIV-Prevention'**
  String get hivPreventionTitle;

  /// No description provided for @hivPreventionIntro.
  ///
  /// In en, this message translates to:
  /// **'Protecting yourself from HIV begins with understanding how the virus is spread. Some of HIV prevention methods are discussed as follows:'**
  String get hivPreventionIntro;

  /// No description provided for @hivMethodA.
  ///
  /// In en, this message translates to:
  /// **'Abstinence from sex (not having sex), before marriage'**
  String get hivMethodA;

  /// No description provided for @hivMethodB.
  ///
  /// In en, this message translates to:
  /// **'Being faithful (Decide to one sexual partner) after testing.'**
  String get hivMethodB;

  /// No description provided for @hivMethodC.
  ///
  /// In en, this message translates to:
  /// **'Consistent and correct use of condom every time you have sex.'**
  String get hivMethodC;

  /// No description provided for @hivMethodD.
  ///
  /// In en, this message translates to:
  /// **'Not sharing sharp objects with other people and Proper use and removal of sharp objects.'**
  String get hivMethodD;

  /// No description provided for @hivAdditionalPreventionIntro.
  ///
  /// In en, this message translates to:
  /// **'In addition to above mentioned prevention methods, the following are also used to prevent HIV.'**
  String get hivAdditionalPreventionIntro;

  /// No description provided for @hivMethodE.
  ///
  /// In en, this message translates to:
  /// **'Provision of anti-HIV treatment for pregnant women living with HIV to avoid transmission to fetus.'**
  String get hivMethodE;

  /// No description provided for @hivMethodF.
  ///
  /// In en, this message translates to:
  /// **'Pre-Exposure Prophylaxis- Given for people at high risk of acquiring HIV and it is given before exposure to HIV.'**
  String get hivMethodF;

  /// No description provided for @prepDesc.
  ///
  /// In en, this message translates to:
  /// **'pre-exposure prophylaxis (PrEP) is HIV medicine taken to prevent the chances of getting HIV infection.. Since PrEP only protects against HIV, condom use is still important for the protection against other STI. It will be provided to people at substantial risk (high risk) of acquiring HIV. This service is available at public health facilities like Health center and Hospital.'**
  String get prepDesc;

  /// No description provided for @watchOnYouTube.
  ///
  /// In en, this message translates to:
  /// **'Watch on YouTube'**
  String get watchOnYouTube;

  /// No description provided for @cinemaMode.
  ///
  /// In en, this message translates to:
  /// **'Cinema View'**
  String get cinemaMode;

  /// No description provided for @playInline.
  ///
  /// In en, this message translates to:
  /// **'Play in App'**
  String get playInline;

  /// No description provided for @closePlayer.
  ///
  /// In en, this message translates to:
  /// **'Close Player'**
  String get closePlayer;

  /// No description provided for @playingInApp.
  ///
  /// In en, this message translates to:
  /// **'Playing in App'**
  String get playingInApp;

  /// No description provided for @returnToLesson.
  ///
  /// In en, this message translates to:
  /// **'Return to Lesson'**
  String get returnToLesson;

  /// No description provided for @hivQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'HIV Module Quiz'**
  String get hivQuizTitle;

  /// No description provided for @nextQuestionBtn.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextQuestionBtn;

  /// No description provided for @finishQuizBtn.
  ///
  /// In en, this message translates to:
  /// **'Finish Quiz'**
  String get finishQuizBtn;

  /// No description provided for @retakeQuizBtn.
  ///
  /// In en, this message translates to:
  /// **'Retake Quiz'**
  String get retakeQuizBtn;

  /// No description provided for @reviewAnswersBtn.
  ///
  /// In en, this message translates to:
  /// **'Review Answers'**
  String get reviewAnswersBtn;

  /// No description provided for @quizScoreCelebration.
  ///
  /// In en, this message translates to:
  /// **'Great Job!'**
  String get quizScoreCelebration;

  /// No description provided for @quizScoreSummary.
  ///
  /// In en, this message translates to:
  /// **'You scored {score} out of {total} ({percent}%)'**
  String quizScoreSummary(int score, int total, int percent);

  /// No description provided for @selectAnOptionHint.
  ///
  /// In en, this message translates to:
  /// **'Please select an answer to continue'**
  String get selectAnOptionHint;

  /// No description provided for @educationalInsight.
  ///
  /// In en, this message translates to:
  /// **'Key Clinical Insight'**
  String get educationalInsight;

  /// No description provided for @trueOption.
  ///
  /// In en, this message translates to:
  /// **'True'**
  String get trueOption;

  /// No description provided for @falseOption.
  ///
  /// In en, this message translates to:
  /// **'False'**
  String get falseOption;

  /// No description provided for @hivQ1Text.
  ///
  /// In en, this message translates to:
  /// **'HIV infects and destroys cells of human immune system, making it hard to fight other diseases?'**
  String get hivQ1Text;

  /// No description provided for @hivQ1Insight.
  ///
  /// In en, this message translates to:
  /// **'HIV targets CD4 white blood cells. Without ART treatment, the body loses its natural defenses against opportunistic infections.'**
  String get hivQ1Insight;

  /// No description provided for @hivQ2Text.
  ///
  /// In en, this message translates to:
  /// **'Which of the following is/are correct about mode of HIV transmission?'**
  String get hivQ2Text;

  /// No description provided for @hivQ2OptA.
  ///
  /// In en, this message translates to:
  /// **'Unprotected sexual practice'**
  String get hivQ2OptA;

  /// No description provided for @hivQ2OptB.
  ///
  /// In en, this message translates to:
  /// **'HIV positive mother to their fetus or child'**
  String get hivQ2OptB;

  /// No description provided for @hivQ2OptC.
  ///
  /// In en, this message translates to:
  /// **'Eating together'**
  String get hivQ2OptC;

  /// No description provided for @hivQ2OptD.
  ///
  /// In en, this message translates to:
  /// **'A & B'**
  String get hivQ2OptD;

  /// No description provided for @hivQ2Insight.
  ///
  /// In en, this message translates to:
  /// **'HIV spreads through specific body fluids (unprotected sex and mother-to-child), but cannot be spread through casual contact like sharing food.'**
  String get hivQ2Insight;

  /// No description provided for @hivQ3Text.
  ///
  /// In en, this message translates to:
  /// **'Can HIV be transmitted through mosquito or insect bites, hugging, or sharing toilet seats?'**
  String get hivQ3Text;

  /// No description provided for @hivQ3Insight.
  ///
  /// In en, this message translates to:
  /// **'HIV cannot survive outside human fluids or inside insects. Casual social contact is completely safe.'**
  String get hivQ3Insight;

  /// No description provided for @hivQ4Text.
  ///
  /// In en, this message translates to:
  /// **'Within how many hours must Post-Exposure Prophylaxis (PEP) be started after possible exposure to HIV?'**
  String get hivQ4Text;

  /// No description provided for @hivQ4OptA.
  ///
  /// In en, this message translates to:
  /// **'Within 24 hours only'**
  String get hivQ4OptA;

  /// No description provided for @hivQ4OptB.
  ///
  /// In en, this message translates to:
  /// **'Within 72 hours (3 days)'**
  String get hivQ4OptB;

  /// No description provided for @hivQ4OptC.
  ///
  /// In en, this message translates to:
  /// **'Within 1 month'**
  String get hivQ4OptC;

  /// No description provided for @hivQ4OptD.
  ///
  /// In en, this message translates to:
  /// **'PEP is only taken before exposure'**
  String get hivQ4OptD;

  /// No description provided for @hivQ4Insight.
  ///
  /// In en, this message translates to:
  /// **'PEP is an emergency medication course that must begin strictly within 72 hours of potential exposure to prevent infection.'**
  String get hivQ4Insight;

  /// No description provided for @hivQ5Text.
  ///
  /// In en, this message translates to:
  /// **'Which of the following lubricants are safe to use with latex condoms?'**
  String get hivQ5Text;

  /// No description provided for @hivQ5OptA.
  ///
  /// In en, this message translates to:
  /// **'Petroleum jelly (Vaseline) and baby oils'**
  String get hivQ5OptA;

  /// No description provided for @hivQ5OptB.
  ///
  /// In en, this message translates to:
  /// **'Body lotions and butter'**
  String get hivQ5OptB;

  /// No description provided for @hivQ5OptC.
  ///
  /// In en, this message translates to:
  /// **'Water-based or silicone-based lubricants only'**
  String get hivQ5OptC;

  /// No description provided for @hivQ5OptD.
  ///
  /// In en, this message translates to:
  /// **'Household cooking oils'**
  String get hivQ5OptD;

  /// No description provided for @hivQ5Insight.
  ///
  /// In en, this message translates to:
  /// **'Oil-based lubricants weaken and tear latex condoms in under a minute. Only water-based or silicone lubricants are safe.'**
  String get hivQ5Insight;

  /// No description provided for @hivQ6Text.
  ///
  /// In en, this message translates to:
  /// **'When a person with HIV takes ART and reaches an undetectable viral load, they cannot transmit the virus sexually (Undetectable = Untransmittable / U=U).'**
  String get hivQ6Text;

  /// No description provided for @hivQ6Insight.
  ///
  /// In en, this message translates to:
  /// **'Decades of evidence confirm Undetectable = Untransmittable (U=U). Regular ART adherence keeps people healthy and prevents transmission.'**
  String get hivQ6Insight;

  /// No description provided for @moduleComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Full module content and interactive quizzes will be configured in the next step.'**
  String get moduleComingSoon;

  /// No description provided for @watchVideo.
  ///
  /// In en, this message translates to:
  /// **'Watch video'**
  String get watchVideo;

  /// No description provided for @waysToPreventHiv.
  ///
  /// In en, this message translates to:
  /// **'Ways to prevent HIV'**
  String get waysToPreventHiv;

  /// No description provided for @hivTesting.
  ///
  /// In en, this message translates to:
  /// **'HIV testing'**
  String get hivTesting;

  /// No description provided for @treatmentForHivPositive.
  ///
  /// In en, this message translates to:
  /// **'Treatment for HIV positive client'**
  String get treatmentForHivPositive;

  /// No description provided for @pepTitle.
  ///
  /// In en, this message translates to:
  /// **'Post-exposure prophylaxis (PEP) -Given for people exposed to HIV.'**
  String get pepTitle;

  /// No description provided for @pepDesc.
  ///
  /// In en, this message translates to:
  /// **'PEP stands for post-exposure prophylaxis. The word “prophylaxis” means to prevent or control the spread of an infection or disease. PEP means taking HIV medicines within 72 hours (3 days) after a possible exposure to HIV to prevent HIV.'**
  String get pepDesc;

  /// No description provided for @condomStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'How to use a condom in 10 steps- for age greater than 18'**
  String get condomStepsTitle;

  /// No description provided for @condomStepsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Follow the 10 steps below to avoid condom breakage or slippage. The how to put on a condom video shows these steps.'**
  String get condomStepsSubtitle;

  /// No description provided for @condomStep1.
  ///
  /// In en, this message translates to:
  /// **'Check the expiry date. Do not use expired condoms.'**
  String get condomStep1;

  /// No description provided for @condomStep2.
  ///
  /// In en, this message translates to:
  /// **'Press the package between your fingers. Do not use if there is no resistance from air inside.'**
  String get condomStep2;

  /// No description provided for @condomStep3.
  ///
  /// In en, this message translates to:
  /// **'Tear open the condom package from the corner and remove the condom. Do not use teeth or sharp objects to open as this can damage the condom.'**
  String get condomStep3;

  /// No description provided for @condomStep4.
  ///
  /// In en, this message translates to:
  /// **'Identify which way the condom unrolls.'**
  String get condomStep4;

  /// No description provided for @condomStep5.
  ///
  /// In en, this message translates to:
  /// **'Pinch the receptor tip of the condom to remove air.'**
  String get condomStep5;

  /// No description provided for @condomStep6.
  ///
  /// In en, this message translates to:
  /// **'Place the condom on the head of the penis while still pinching the condom receptor tip.'**
  String get condomStep6;

  /// No description provided for @condomStep7.
  ///
  /// In en, this message translates to:
  /// **'Unroll the condom to the base of the shaft.'**
  String get condomStep7;

  /// No description provided for @condomStep8.
  ///
  /// In en, this message translates to:
  /// **'Insert the penis into vagina.'**
  String get condomStep8;

  /// No description provided for @condomStep9.
  ///
  /// In en, this message translates to:
  /// **'Pull out while still erect, holding the base of the condom firmly.'**
  String get condomStep9;

  /// No description provided for @condomStep10.
  ///
  /// In en, this message translates to:
  /// **'Remove the condom from the penis and discard.'**
  String get condomStep10;

  /// No description provided for @hivTestingDesc.
  ///
  /// In en, this message translates to:
  /// **'HIV testing services refer to the full range of services that include HIV testing, counseling and linkage to appropriate HIV prevention, treatment and care. The following are HIV testing methods.'**
  String get hivTestingDesc;

  /// No description provided for @pitcTitle.
  ///
  /// In en, this message translates to:
  /// **'Provider Initiated Testing and Counseling (PITC): '**
  String get pitcTitle;

  /// No description provided for @pitcDesc.
  ///
  /// In en, this message translates to:
  /// **'This refers to HIV testing, and counseling recommended by a provider during a visit to a health care facility.'**
  String get pitcDesc;

  /// No description provided for @vctTitle.
  ///
  /// In en, this message translates to:
  /// **'Voluntary Counseling and Testing (VCT): '**
  String get vctTitle;

  /// No description provided for @vctDesc.
  ///
  /// In en, this message translates to:
  /// **'VCT is initiated by clients seeking to know their HIV status.'**
  String get vctDesc;

  /// No description provided for @artDesc1.
  ///
  /// In en, this message translates to:
  /// **'People with HIV need to start taking special medicine called antiretroviral therapy, or ART, as soon as they can. This medicine helps slow down the HIV virus in their bodies. When someone takes ART, the amount of virus goes down, and their immune system gets stronger.'**
  String get artDesc1;

  /// No description provided for @artDesc2.
  ///
  /// In en, this message translates to:
  /// **'Everyone, including children, Adolescents and adults, who have HIV should begin this treatment right after they find out they have the virus. Starting treatment early can help people live longer, stay healthier, and reduce the chances of passing HIV to others. It also helps prevent other illnesses and makes life better for those living with HIV.'**
  String get artDesc2;

  /// No description provided for @artDesc3.
  ///
  /// In en, this message translates to:
  /// **'ART service is available in public health facilities like Health center and Hospital.'**
  String get artDesc3;

  /// No description provided for @markCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as Completed'**
  String get markCompleted;

  /// No description provided for @moduleCompletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Module marked as completed!'**
  String get moduleCompletedSuccess;

  /// No description provided for @videoDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Educational Video'**
  String get videoDialogTitle;

  /// No description provided for @lubricantsVideoDesc.
  ///
  /// In en, this message translates to:
  /// **'Demonstration on condom safety: Petroleum jelly, baby oils, and body lotions weaken latex and cause condom failure. Only water-based or silicone lubricants are safe to use with condoms.'**
  String get lubricantsVideoDesc;

  /// No description provided for @counsellingVideoDesc.
  ///
  /// In en, this message translates to:
  /// **'Demonstration and clinical counseling on proper condom usage, correct sizing, and dual protection against STIs and unintended pregnancy.'**
  String get counsellingVideoDesc;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// No description provided for @viewProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Identity • Age'**
  String get viewProfileSubtitle;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences • Alerts'**
  String get notificationsSubtitle;

  /// No description provided for @accountSettingsHeader.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT SETTINGS'**
  String get accountSettingsHeader;

  /// No description provided for @privacyAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacyAndSecurity;

  /// No description provided for @privacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Password • Privacy • Security'**
  String get privacySubtitle;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @appLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get appLanguageSubtitle;

  /// No description provided for @appTheme.
  ///
  /// In en, this message translates to:
  /// **'App Theme'**
  String get appTheme;

  /// No description provided for @appThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Light or dark'**
  String get appThemeSubtitle;

  /// No description provided for @textSize.
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get textSize;

  /// No description provided for @textSizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Display • Reading • Size'**
  String get textSizeSubtitle;

  /// No description provided for @supportCenter.
  ///
  /// In en, this message translates to:
  /// **'Support Center'**
  String get supportCenter;

  /// No description provided for @supportCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help • Contact • Support'**
  String get supportCenterSubtitle;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @defaultTextSize.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultTextSize;

  /// No description provided for @smallTextSize.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get smallTextSize;

  /// No description provided for @largeTextSize.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get largeTextSize;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get appVersion;

  /// No description provided for @supportCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Support & Helpline'**
  String get supportCenterTitle;

  /// No description provided for @supportCenterBody.
  ///
  /// In en, this message translates to:
  /// **'If you have questions about sexual and reproductive health or need confidential peer assistance, reach out to verified youth centers and national health hotlines (such as 952 or 8335). Yegna Health provides general education and does not replace emergency medical care.'**
  String get supportCenterBody;

  /// No description provided for @notificationsModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationsModalTitle;

  /// No description provided for @notificationsModalBody.
  ///
  /// In en, this message translates to:
  /// **'Configure alert preferences, daily learning reminders, and health tips.'**
  String get notificationsModalBody;

  /// No description provided for @privacyModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security Settings'**
  String get privacyModalTitle;

  /// No description provided for @privacyModalBody.
  ///
  /// In en, this message translates to:
  /// **'Your health exploration and progress records are securely stored on this device with industry-standard PKCE tokens and encryption. You can change your password anytime.'**
  String get privacyModalBody;

  /// No description provided for @themeDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose App Theme'**
  String get themeDialogTitle;

  /// No description provided for @textSizeDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Text Size'**
  String get textSizeDialogTitle;

  /// No description provided for @srhVctFilter.
  ///
  /// In en, this message translates to:
  /// **'SRH & VCT'**
  String get srhVctFilter;

  /// No description provided for @mentalHealthFilter.
  ///
  /// In en, this message translates to:
  /// **'Mental Health'**
  String get mentalHealthFilter;

  /// No description provided for @listViewLabel.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get listViewLabel;

  /// No description provided for @mapViewLabel.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapViewLabel;

  /// No description provided for @openNowStatus.
  ///
  /// In en, this message translates to:
  /// **'Open Now'**
  String get openNowStatus;

  /// No description provided for @closedStatus.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closedStatus;

  /// No description provided for @verifiedYouthFriendlyBadge.
  ///
  /// In en, this message translates to:
  /// **'Verified Youth-Friendly'**
  String get verifiedYouthFriendlyBadge;

  /// No description provided for @freeForYouthBadge.
  ///
  /// In en, this message translates to:
  /// **'Free Services'**
  String get freeForYouthBadge;

  /// No description provided for @callClinicAction.
  ///
  /// In en, this message translates to:
  /// **'Call Clinic'**
  String get callClinicAction;

  /// No description provided for @directionsAction.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directionsAction;

  /// No description provided for @viewDetailsAction.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetailsAction;

  /// No description provided for @confidentialityNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Youth Confidentiality Guarantee'**
  String get confidentialityNoticeTitle;

  /// No description provided for @landmarkLabel.
  ///
  /// In en, this message translates to:
  /// **'Landmark'**
  String get landmarkLabel;

  /// No description provided for @operatingHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Operating Hours'**
  String get operatingHoursLabel;

  /// No description provided for @servicesOfferedLabel.
  ///
  /// In en, this message translates to:
  /// **'Available Services'**
  String get servicesOfferedLabel;

  /// No description provided for @resetFiltersAction.
  ///
  /// In en, this message translates to:
  /// **'Reset Filters'**
  String get resetFiltersAction;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Phone number copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @campusClinicBadge.
  ///
  /// In en, this message translates to:
  /// **'Campus Clinic'**
  String get campusClinicBadge;

  /// No description provided for @distanceKm.
  ///
  /// In en, this message translates to:
  /// **'{distance} km away'**
  String distanceKm(String distance);

  /// No description provided for @closesAt.
  ///
  /// In en, this message translates to:
  /// **'Closes at {time}'**
  String closesAt(String time);

  /// No description provided for @opensAt.
  ///
  /// In en, this message translates to:
  /// **'Opens at {time}'**
  String opensAt(String time);

  /// No description provided for @onlineNowFilter.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get onlineNowFilter;

  /// No description provided for @pubertyFilter.
  ///
  /// In en, this message translates to:
  /// **'Puberty'**
  String get pubertyFilter;

  /// No description provided for @substanceFilter.
  ///
  /// In en, this message translates to:
  /// **'Healthy Lifestyle'**
  String get substanceFilter;

  /// No description provided for @availableNowBadge.
  ///
  /// In en, this message translates to:
  /// **'Available Now'**
  String get availableNowBadge;

  /// No description provided for @nextSlotBadge.
  ///
  /// In en, this message translates to:
  /// **'Next: {time}'**
  String nextSlotBadge(String time);

  /// No description provided for @verifiedPeerBadge.
  ///
  /// In en, this message translates to:
  /// **'Verified Peer Counselor'**
  String get verifiedPeerBadge;

  /// No description provided for @chatConfidentialAction.
  ///
  /// In en, this message translates to:
  /// **'Chat Confidential'**
  String get chatConfidentialAction;

  /// No description provided for @viewProfileBtn.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfileBtn;

  /// No description provided for @safeguardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Safeguarding & Confidentiality'**
  String get safeguardingTitle;

  /// No description provided for @experienceMetrics.
  ///
  /// In en, this message translates to:
  /// **'{years} yrs exp • {sessions}+ sessions'**
  String experienceMetrics(int years, int sessions);

  /// No description provided for @sessionsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessionsCountLabel;

  /// No description provided for @languagesSpokenLabel.
  ///
  /// In en, this message translates to:
  /// **'Languages Spoken'**
  String get languagesSpokenLabel;

  /// No description provided for @specialtiesLabel.
  ///
  /// In en, this message translates to:
  /// **'Focus Areas'**
  String get specialtiesLabel;

  /// No description provided for @startChatPrompt.
  ///
  /// In en, this message translates to:
  /// **'Start confidential conversation with {name}'**
  String startChatPrompt(String name);

  /// No description provided for @emergencyDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Peer mentors provide general guidance and active listening. In severe emotional distress or medical emergency, please call toll-free hotlines 952 or 8335 immediately.'**
  String get emergencyDisclaimer;

  /// No description provided for @sendPeerMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendPeerMessage;

  /// No description provided for @peerChatComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Live anonymous messaging session initialized. Your counselor will respond within moments.'**
  String get peerChatComingSoon;

  /// No description provided for @languageAll.
  ///
  /// In en, this message translates to:
  /// **'All Languages'**
  String get languageAll;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @guestGreetingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your safe space for confidential youth health'**
  String get guestGreetingSubtitle;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest Explorer'**
  String get guestUser;

  /// No description provided for @dailyTipBadge.
  ///
  /// In en, this message translates to:
  /// **'Daily Insight'**
  String get dailyTipBadge;

  /// No description provided for @dailyTipMythFact.
  ///
  /// In en, this message translates to:
  /// **'Myth vs Fact'**
  String get dailyTipMythFact;

  /// No description provided for @dailyTipTitle.
  ///
  /// In en, this message translates to:
  /// **'Hormonal changes during puberty'**
  String get dailyTipTitle;

  /// No description provided for @dailyTipBody.
  ///
  /// In en, this message translates to:
  /// **'Acne and mood shifts are normal bodily adjustments during growth, not signs of poor hygiene.'**
  String get dailyTipBody;

  /// No description provided for @readArticleAction.
  ///
  /// In en, this message translates to:
  /// **'Explore Article'**
  String get readArticleAction;

  /// No description provided for @emergencyHelplineTitle.
  ///
  /// In en, this message translates to:
  /// **'24/7 Confidential Helplines'**
  String get emergencyHelplineTitle;

  /// No description provided for @emergencyHelplineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Toll-free: 952 (Health) / 8335 (Youth Line)'**
  String get emergencyHelplineSubtitle;

  /// No description provided for @emergencyHelplineAction.
  ///
  /// In en, this message translates to:
  /// **'Call / Help'**
  String get emergencyHelplineAction;

  /// No description provided for @emergencySheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Urgent Help & Support'**
  String get emergencySheetTitle;

  /// No description provided for @emergencySheetDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'For immediate clinical emergencies or acute crisis, call toll-free numbers anytime.'**
  String get emergencySheetDisclaimer;

  /// No description provided for @emergencyHotline952Name.
  ///
  /// In en, this message translates to:
  /// **'National Health Emergency Hotline'**
  String get emergencyHotline952Name;

  /// No description provided for @emergencyHotline952Desc.
  ///
  /// In en, this message translates to:
  /// **'Ministry of Health 24/7 free hotline for acute health concerns'**
  String get emergencyHotline952Desc;

  /// No description provided for @emergencyHotline8335Name.
  ///
  /// In en, this message translates to:
  /// **'National Youth & Mental Health Line'**
  String get emergencyHotline8335Name;

  /// No description provided for @emergencyHotline8335Desc.
  ///
  /// In en, this message translates to:
  /// **'Confidential counseling for reproductive health and emotional distress'**
  String get emergencyHotline8335Desc;

  /// No description provided for @exploreServicesHeading.
  ///
  /// In en, this message translates to:
  /// **'Explore Services'**
  String get exploreServicesHeading;

  /// No description provided for @exploreServicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Private tools, peer support, and verified clinics'**
  String get exploreServicesSubtitle;

  /// No description provided for @callNowAction.
  ///
  /// In en, this message translates to:
  /// **'Call Now'**
  String get callNowAction;

  /// No description provided for @pubertyHeroDesc.
  ///
  /// In en, this message translates to:
  /// **'Puberty is a natural transition from childhood into adulthood, characterized by physical, hormonal, and emotional changes that shape personal growth and health.'**
  String get pubertyHeroDesc;

  /// No description provided for @pubertyNoteText.
  ///
  /// In en, this message translates to:
  /// **'Every adolescent experiences puberty at their own unique pace—practicing good hygiene, understanding bodily changes, and embracing self-confidence helps ensure a healthy transition.'**
  String get pubertyNoteText;

  /// No description provided for @pubertySection1Title.
  ///
  /// In en, this message translates to:
  /// **'Understanding Puberty & Adolescence'**
  String get pubertySection1Title;

  /// No description provided for @pubertySection1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'The Natural Transition to Adulthood'**
  String get pubertySection1Subtitle;

  /// No description provided for @pubertySection1Intro.
  ///
  /// In en, this message translates to:
  /// **'Puberty is the developmental stage where the body undergoes rapid hormonal and biological changes, enabling physical maturity and reproductive capability.'**
  String get pubertySection1Intro;

  /// No description provided for @pubertySection1Item1.
  ///
  /// In en, this message translates to:
  /// **'Hormonal triggers: The pituitary gland releases hormones that signal the body to grow and develop secondary sexual characteristics.'**
  String get pubertySection1Item1;

  /// No description provided for @pubertySection1Item2.
  ///
  /// In en, this message translates to:
  /// **'Individual timing: Puberty typically begins between ages 9 and 14, varying naturally among individuals.'**
  String get pubertySection1Item2;

  /// No description provided for @pubertySection1Item3.
  ///
  /// In en, this message translates to:
  /// **'Normal variation: Growing at different rates than peers is completely normal and healthy.'**
  String get pubertySection1Item3;

  /// No description provided for @pubertySection2Title.
  ///
  /// In en, this message translates to:
  /// **'Physical Changes in Females & Males'**
  String get pubertySection2Title;

  /// No description provided for @pubertySection2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Key Physical Milestones'**
  String get pubertySection2Subtitle;

  /// No description provided for @pubertySection2FemaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Changes in Females:'**
  String get pubertySection2FemaleTitle;

  /// No description provided for @pubertySection2FemaleItem1.
  ///
  /// In en, this message translates to:
  /// **'Breast development and widening of hips'**
  String get pubertySection2FemaleItem1;

  /// No description provided for @pubertySection2FemaleItem2.
  ///
  /// In en, this message translates to:
  /// **'Growth of body hair (underarms and pubic area)'**
  String get pubertySection2FemaleItem2;

  /// No description provided for @pubertySection2FemaleItem3.
  ///
  /// In en, this message translates to:
  /// **'Onset of menstruation (menarche), the monthly cycle preparing the uterus for potential pregnancy'**
  String get pubertySection2FemaleItem3;

  /// No description provided for @pubertySection2MaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Changes in Males:'**
  String get pubertySection2MaleTitle;

  /// No description provided for @pubertySection2MaleItem1.
  ///
  /// In en, this message translates to:
  /// **'Deepening of the voice (voice cracks and lower pitch)'**
  String get pubertySection2MaleItem1;

  /// No description provided for @pubertySection2MaleItem2.
  ///
  /// In en, this message translates to:
  /// **'Growth of facial, underarm, chest, and pubic hair'**
  String get pubertySection2MaleItem2;

  /// No description provided for @pubertySection2MaleItem3.
  ///
  /// In en, this message translates to:
  /// **'Growth of testicles and penis, along with nocturnal emissions (\'wet dreams\'), a normal involuntary release of semen during sleep'**
  String get pubertySection2MaleItem3;

  /// No description provided for @pubertySection3Title.
  ///
  /// In en, this message translates to:
  /// **'Emotional & Psychological Changes'**
  String get pubertySection3Title;

  /// No description provided for @pubertySection3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Navigating Thoughts and Emotions'**
  String get pubertySection3Subtitle;

  /// No description provided for @pubertySection3Intro.
  ///
  /// In en, this message translates to:
  /// **'Alongside physical transformations, teenagers experience significant cognitive and emotional growth.'**
  String get pubertySection3Intro;

  /// No description provided for @pubertySection3Item1.
  ///
  /// In en, this message translates to:
  /// **'Mood shifts: Fluctuating hormones combined with social adjustments can cause temporary mood swings.'**
  String get pubertySection3Item1;

  /// No description provided for @pubertySection3Item2.
  ///
  /// In en, this message translates to:
  /// **'Identity search: Developing self-awareness, exploring personal values, and discovering individuality.'**
  String get pubertySection3Item2;

  /// No description provided for @pubertySection3Item3.
  ///
  /// In en, this message translates to:
  /// **'Desire for independence: Transitioning toward greater personal autonomy and decision-making.'**
  String get pubertySection3Item3;

  /// No description provided for @pubertySection3Item4.
  ///
  /// In en, this message translates to:
  /// **'Peer influence: Friendships and social groups become central to emotional support and communication.'**
  String get pubertySection3Item4;

  /// No description provided for @pubertySection4Title.
  ///
  /// In en, this message translates to:
  /// **'Hygiene & Self-Care during Adolescence'**
  String get pubertySection4Title;

  /// No description provided for @pubertySection4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Habits for Lifelong Health'**
  String get pubertySection4Subtitle;

  /// No description provided for @pubertySection4Item1.
  ///
  /// In en, this message translates to:
  /// **'Bathing and deodorants: Sweat glands become more active; daily washing with clean water and mild soap prevents body odor.'**
  String get pubertySection4Item1;

  /// No description provided for @pubertySection4Item2.
  ///
  /// In en, this message translates to:
  /// **'Skin and face care: Increased oil production can cause acne; wash the face twice daily and avoid squeezing pimples.'**
  String get pubertySection4Item2;

  /// No description provided for @pubertySection4Item3.
  ///
  /// In en, this message translates to:
  /// **'Menstrual hygiene: Change sanitary pads or clean supplies every 4–6 hours, wash hands before and after, and dispose of materials safely.'**
  String get pubertySection4Item3;

  /// No description provided for @pubertySection4Item4.
  ///
  /// In en, this message translates to:
  /// **'Nutrition and sleep: Growing bodies require 8–10 hours of restful sleep each night and a balanced diet rich in vitamins and iron.'**
  String get pubertySection4Item4;

  /// No description provided for @pubertyQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Adolescent Health & Puberty Quiz'**
  String get pubertyQuizTitle;

  /// No description provided for @pubertyQ1Text.
  ///
  /// In en, this message translates to:
  /// **'Puberty is a natural biological transition where each person grows and develops at their own unique, normal pace.'**
  String get pubertyQ1Text;

  /// No description provided for @pubertyQ1Insight.
  ///
  /// In en, this message translates to:
  /// **'Puberty begins at different times for everyone, usually between ages 9 and 14. Variance in timing and growth rate is completely normal.'**
  String get pubertyQ1Insight;

  /// No description provided for @pubertyQ2Text.
  ///
  /// In en, this message translates to:
  /// **'What is a normal and healthy physical change that occurs during male puberty?'**
  String get pubertyQ2Text;

  /// No description provided for @pubertyQ2OptA.
  ///
  /// In en, this message translates to:
  /// **'Deepening of the voice and growth of facial/body hair'**
  String get pubertyQ2OptA;

  /// No description provided for @pubertyQ2OptB.
  ///
  /// In en, this message translates to:
  /// **'Sudden complete loss of appetite'**
  String get pubertyQ2OptB;

  /// No description provided for @pubertyQ2OptC.
  ///
  /// In en, this message translates to:
  /// **'Permanent loss of sleep'**
  String get pubertyQ2OptC;

  /// No description provided for @pubertyQ2OptD.
  ///
  /// In en, this message translates to:
  /// **'Inability to run or exercise'**
  String get pubertyQ2OptD;

  /// No description provided for @pubertyQ2Insight.
  ///
  /// In en, this message translates to:
  /// **'Voice deepening, growth spurts, and hair development are classic signs of testosterone production and healthy male pubertal development.'**
  String get pubertyQ2Insight;

  /// No description provided for @pubertyQ3Text.
  ///
  /// In en, this message translates to:
  /// **'What is the recommended hygiene practice during menstruation?'**
  String get pubertyQ3Text;

  /// No description provided for @pubertyQ3OptA.
  ///
  /// In en, this message translates to:
  /// **'Change sanitary products regularly (every 4–6 hours) and wash hands'**
  String get pubertyQ3OptA;

  /// No description provided for @pubertyQ3OptB.
  ///
  /// In en, this message translates to:
  /// **'Avoid bathing until the cycle ends'**
  String get pubertyQ3OptB;

  /// No description provided for @pubertyQ3OptC.
  ///
  /// In en, this message translates to:
  /// **'Use unwashed cloths repeatedly without drying'**
  String get pubertyQ3OptC;

  /// No description provided for @pubertyQ3OptD.
  ///
  /// In en, this message translates to:
  /// **'Avoid drinking water throughout the cycle'**
  String get pubertyQ3OptD;

  /// No description provided for @pubertyQ3Insight.
  ///
  /// In en, this message translates to:
  /// **'Regularly changing sanitary supplies every 4 to 6 hours and practicing good hand hygiene prevents irritation and bacterial infections.'**
  String get pubertyQ3Insight;

  /// No description provided for @pubertyQ4Text.
  ///
  /// In en, this message translates to:
  /// **'Emotional changes and mood shifts during adolescence are common and can be managed through open communication, exercise, and adequate sleep.'**
  String get pubertyQ4Text;

  /// No description provided for @pubertyQ4Insight.
  ///
  /// In en, this message translates to:
  /// **'Hormonal shifts and expanding social worlds make emotional fluctuations normal. Talking to trusted friends or family helps navigate these feelings.'**
  String get pubertyQ4Insight;

  /// No description provided for @stiQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Sexually Transmitted Infections Quiz'**
  String get stiQuizTitle;

  /// No description provided for @stiQ1Text.
  ///
  /// In en, this message translates to:
  /// **'Many sexually transmitted infections (STIs) may show no noticeable symptoms at first, which is why regular screening and testing are essential.'**
  String get stiQ1Text;

  /// No description provided for @stiQ1Insight.
  ///
  /// In en, this message translates to:
  /// **'Asymptomatic infections are common with STIs like chlamydia and gonorrhea. Regular testing allows prompt treatment before complications occur.'**
  String get stiQ1Insight;

  /// No description provided for @stiQ2Text.
  ///
  /// In en, this message translates to:
  /// **'Which of the following is an effective method for reducing the risk of transmitting most STIs during sexual activity?'**
  String get stiQ2Text;

  /// No description provided for @stiQ2OptA.
  ///
  /// In en, this message translates to:
  /// **'Consistent and correct use of male or female condoms'**
  String get stiQ2OptA;

  /// No description provided for @stiQ2OptB.
  ///
  /// In en, this message translates to:
  /// **'Taking vitamins immediately before contact'**
  String get stiQ2OptB;

  /// No description provided for @stiQ2OptC.
  ///
  /// In en, this message translates to:
  /// **'Washing with hot water after intercourse only'**
  String get stiQ2OptC;

  /// No description provided for @stiQ2OptD.
  ///
  /// In en, this message translates to:
  /// **'Relying on herbal teas'**
  String get stiQ2OptD;

  /// No description provided for @stiQ2Insight.
  ///
  /// In en, this message translates to:
  /// **'Condoms provide a physical barrier that drastically lowers the risk of STI transmission when used correctly every time.'**
  String get stiQ2Insight;

  /// No description provided for @stiQ3Text.
  ///
  /// In en, this message translates to:
  /// **'If you test positive for a bacterial STI and start antibiotics, what is the most important instruction to follow?'**
  String get stiQ3Text;

  /// No description provided for @stiQ3OptA.
  ///
  /// In en, this message translates to:
  /// **'Complete the entire course of medication as prescribed by the healthcare worker'**
  String get stiQ3OptA;

  /// No description provided for @stiQ3OptB.
  ///
  /// In en, this message translates to:
  /// **'Stop medication the moment pain disappears'**
  String get stiQ3OptB;

  /// No description provided for @stiQ3OptC.
  ///
  /// In en, this message translates to:
  /// **'Share the remaining pills with friends'**
  String get stiQ3OptC;

  /// No description provided for @stiQ3OptD.
  ///
  /// In en, this message translates to:
  /// **'Double the dose on the final day'**
  String get stiQ3OptD;

  /// No description provided for @stiQ3Insight.
  ///
  /// In en, this message translates to:
  /// **'Stopping antibiotics early can lead to bacterial resistance and reinfection. Always complete the entire prescribed treatment course.'**
  String get stiQ3Insight;

  /// No description provided for @stiQ4Text.
  ///
  /// In en, this message translates to:
  /// **'When someone is diagnosed and treated for an STI, it is vital that sexual partners are also notified and treated to prevent reinfection.'**
  String get stiQ4Text;

  /// No description provided for @stiQ4Insight.
  ///
  /// In en, this message translates to:
  /// **'Treating partners simultaneously breaks the cycle of transmission and protects both individuals from repeated health complications.'**
  String get stiQ4Insight;

  /// No description provided for @hepatitisQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis Module Quiz'**
  String get hepatitisQuizTitle;

  /// No description provided for @hepatitisQ1Text.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis primarily affects which vital organ in the human body?'**
  String get hepatitisQ1Text;

  /// No description provided for @hepatitisQ1OptA.
  ///
  /// In en, this message translates to:
  /// **'Liver'**
  String get hepatitisQ1OptA;

  /// No description provided for @hepatitisQ1OptB.
  ///
  /// In en, this message translates to:
  /// **'Lungs'**
  String get hepatitisQ1OptB;

  /// No description provided for @hepatitisQ1OptC.
  ///
  /// In en, this message translates to:
  /// **'Heart'**
  String get hepatitisQ1OptC;

  /// No description provided for @hepatitisQ1OptD.
  ///
  /// In en, this message translates to:
  /// **'Kidneys'**
  String get hepatitisQ1OptD;

  /// No description provided for @hepatitisQ1Insight.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis is an inflammation of the liver, which performs vital roles like filtering toxins, aiding digestion, and storing energy.'**
  String get hepatitisQ1Insight;

  /// No description provided for @hepatitisQ2Text.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis A and Hepatitis E are primarily spread through contaminated food and water, making clean water and hand hygiene key defenses.'**
  String get hepatitisQ2Text;

  /// No description provided for @hepatitisQ2Insight.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis A and E spread via the fecal-oral route. Thorough handwashing and safe drinking water effectively stop transmission.'**
  String get hepatitisQ2Insight;

  /// No description provided for @hepatitisQ3Text.
  ///
  /// In en, this message translates to:
  /// **'Which safe and effective preventive measure protects against Hepatitis B infection?'**
  String get hepatitisQ3Text;

  /// No description provided for @hepatitisQ3OptA.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis B vaccination and screening'**
  String get hepatitisQ3OptA;

  /// No description provided for @hepatitisQ3OptB.
  ///
  /// In en, this message translates to:
  /// **'Drinking caffeinated beverages'**
  String get hepatitisQ3OptB;

  /// No description provided for @hepatitisQ3OptC.
  ///
  /// In en, this message translates to:
  /// **'Avoiding regular exercise'**
  String get hepatitisQ3OptC;

  /// No description provided for @hepatitisQ3OptD.
  ///
  /// In en, this message translates to:
  /// **'Taking painkillers daily'**
  String get hepatitisQ3OptD;

  /// No description provided for @hepatitisQ3Insight.
  ///
  /// In en, this message translates to:
  /// **'The Hepatitis B vaccine provides long-lasting immunity. Avoiding needle-sharing and safe sexual practices also prevent transmission.'**
  String get hepatitisQ3Insight;

  /// No description provided for @hepatitisQ4Text.
  ///
  /// In en, this message translates to:
  /// **'Modern direct-acting antiviral (DAA) medications can successfully cure more than 95% of chronic Hepatitis C infections.'**
  String get hepatitisQ4Text;

  /// No description provided for @hepatitisQ4Insight.
  ///
  /// In en, this message translates to:
  /// **'Advances in medicine have made chronic Hepatitis C a curable condition with an oral medication course lasting 8 to 12 weeks.'**
  String get hepatitisQ4Insight;

  /// No description provided for @gbvQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Gender-Based Violence Quiz'**
  String get gbvQuizTitle;

  /// No description provided for @gbvQ1Text.
  ///
  /// In en, this message translates to:
  /// **'Gender-based violence (GBV) includes physical, sexual, psychological, and economic harm directed at an individual based on their gender.'**
  String get gbvQ1Text;

  /// No description provided for @gbvQ1Insight.
  ///
  /// In en, this message translates to:
  /// **'GBV encompasses all forms of coercive control, emotional abuse, physical harm, and economic deprivation rooted in unequal gender norms.'**
  String get gbvQ1Insight;

  /// No description provided for @gbvQ2Text.
  ///
  /// In en, this message translates to:
  /// **'What is a vital immediate step when supporting a survivor who has experienced sexual violence?'**
  String get gbvQ2Text;

  /// No description provided for @gbvQ2OptA.
  ///
  /// In en, this message translates to:
  /// **'Ensure their safety and seek confidential medical care (including PEP within 72 hours)'**
  String get gbvQ2OptA;

  /// No description provided for @gbvQ2OptB.
  ///
  /// In en, this message translates to:
  /// **'Blame them for being in the situation'**
  String get gbvQ2OptB;

  /// No description provided for @gbvQ2OptC.
  ///
  /// In en, this message translates to:
  /// **'Disclose their private story to neighborhood groups'**
  String get gbvQ2OptC;

  /// No description provided for @gbvQ2OptD.
  ///
  /// In en, this message translates to:
  /// **'Ignore their feelings and tell them to stay silent'**
  String get gbvQ2OptD;

  /// No description provided for @gbvQ2Insight.
  ///
  /// In en, this message translates to:
  /// **'Immediate safety, non-judgmental empathy, and clinical care—including post-exposure prophylaxis (PEP) within 72 hours—are crucial for survivors.'**
  String get gbvQ2Insight;

  /// No description provided for @gbvQ3Text.
  ///
  /// In en, this message translates to:
  /// **'What role can men and boys play in preventing gender-based violence in our communities?'**
  String get gbvQ3Text;

  /// No description provided for @gbvQ3OptA.
  ///
  /// In en, this message translates to:
  /// **'Promote respectful relationships, reject violent norms, and speak out against abuse'**
  String get gbvQ3OptA;

  /// No description provided for @gbvQ3OptB.
  ///
  /// In en, this message translates to:
  /// **'Remain silent when witnessing harassment'**
  String get gbvQ3OptB;

  /// No description provided for @gbvQ3OptC.
  ///
  /// In en, this message translates to:
  /// **'Enforce rigid traditional inequalities'**
  String get gbvQ3OptC;

  /// No description provided for @gbvQ3OptD.
  ///
  /// In en, this message translates to:
  /// **'Discourage girls from attending school'**
  String get gbvQ3OptD;

  /// No description provided for @gbvQ3Insight.
  ///
  /// In en, this message translates to:
  /// **'Engaging men and boys as allies and champions for gender equality creates safer, more supportive communities for everyone.'**
  String get gbvQ3Insight;

  /// No description provided for @gbvQ4Text.
  ///
  /// In en, this message translates to:
  /// **'Survivors of GBV are never to blame for the violence committed against them.'**
  String get gbvQ4Text;

  /// No description provided for @gbvQ4Insight.
  ///
  /// In en, this message translates to:
  /// **'Responsibility for violence rests solely on the perpetrator. Blaming survivors causes secondary trauma and deters people from seeking help.'**
  String get gbvQ4Insight;

  /// No description provided for @srhHeroDesc.
  ///
  /// In en, this message translates to:
  /// **'Sexual and Reproductive Health is a state of physical, mental, and social well-being in all matters relating to the reproductive system, relationships, and fertility.'**
  String get srhHeroDesc;

  /// No description provided for @srhNoteText.
  ///
  /// In en, this message translates to:
  /// **'Informed decisions, mutual respect, open communication, and access to healthcare ensure healthy relationships and empowered family planning.'**
  String get srhNoteText;

  /// No description provided for @srhSection1Title.
  ///
  /// In en, this message translates to:
  /// **'Understanding Sexual & Reproductive Health'**
  String get srhSection1Title;

  /// No description provided for @srhSection1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'A Holistic View of Wellbeing'**
  String get srhSection1Subtitle;

  /// No description provided for @srhSection1Intro.
  ///
  /// In en, this message translates to:
  /// **'SRH is not just about avoiding disease; it is the right to make informed choices about your body, sexuality, and future.'**
  String get srhSection1Intro;

  /// No description provided for @srhSection1Item1.
  ///
  /// In en, this message translates to:
  /// **'Physical health: Caring for reproductive organs, preventing infections, and accessing routine checkups.'**
  String get srhSection1Item1;

  /// No description provided for @srhSection1Item2.
  ///
  /// In en, this message translates to:
  /// **'Emotional health: Developing positive self-esteem, healthy body image, and respect in intimate relationships.'**
  String get srhSection1Item2;

  /// No description provided for @srhSection1Item3.
  ///
  /// In en, this message translates to:
  /// **'Social wellbeing: Experiencing equality, free from stigma, coercion, or gender discrimination.'**
  String get srhSection1Item3;

  /// No description provided for @srhSection2Title.
  ///
  /// In en, this message translates to:
  /// **'Anatomy & Reproductive Systems'**
  String get srhSection2Title;

  /// No description provided for @srhSection2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'How the Human Body Functions'**
  String get srhSection2Subtitle;

  /// No description provided for @srhSection2Intro.
  ///
  /// In en, this message translates to:
  /// **'Understanding how female and male reproductive systems work empowers individuals to care for their bodily health.'**
  String get srhSection2Intro;

  /// No description provided for @srhSection2Item1.
  ///
  /// In en, this message translates to:
  /// **'Female anatomy: Ovaries produce eggs and hormones (estrogen/progesterone); fallopian tubes guide eggs to the uterus where a baby can develop.'**
  String get srhSection2Item1;

  /// No description provided for @srhSection2Item2.
  ///
  /// In en, this message translates to:
  /// **'Male anatomy: Testicles produce sperm and testosterone; sperm travels through the vas deferens and urethra.'**
  String get srhSection2Item2;

  /// No description provided for @srhSection2Item3.
  ///
  /// In en, this message translates to:
  /// **'Conception: Fertilization occurs when a sperm cell joins with a mature egg, initiating pregnancy.'**
  String get srhSection2Item3;

  /// No description provided for @srhSection3Title.
  ///
  /// In en, this message translates to:
  /// **'Family Planning & Contraceptive Methods'**
  String get srhSection3Title;

  /// No description provided for @srhSection3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Empowering Family and Life Planning'**
  String get srhSection3Subtitle;

  /// No description provided for @srhSection3Intro.
  ///
  /// In en, this message translates to:
  /// **'Family planning allows individuals and couples to decide if and when to have children, promoting maternal and child health.'**
  String get srhSection3Intro;

  /// No description provided for @srhSection3Item1.
  ///
  /// In en, this message translates to:
  /// **'Barrier methods: Male and female condoms prevent pregnancy and provide essential protection against STIs and HIV (dual protection).'**
  String get srhSection3Item1;

  /// No description provided for @srhSection3Item2.
  ///
  /// In en, this message translates to:
  /// **'Hormonal methods: Pills, injections, implants, and IUDs offer reliable pregnancy prevention by regulating ovulation and cervical mucus.'**
  String get srhSection3Item2;

  /// No description provided for @srhSection3Item3.
  ///
  /// In en, this message translates to:
  /// **'Permanent methods: Vasectomy and tubal ligation are voluntary surgical procedures for individuals who have completed their family size.'**
  String get srhSection3Item3;

  /// No description provided for @srhSection3Item4.
  ///
  /// In en, this message translates to:
  /// **'Emergency contraception: Can prevent unintended pregnancy when taken within 72 to 120 hours following unprotected intercourse.'**
  String get srhSection3Item4;

  /// No description provided for @srhSection4Title.
  ///
  /// In en, this message translates to:
  /// **'Consent, Rights & Healthy Relationships'**
  String get srhSection4Title;

  /// No description provided for @srhSection4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Building Trust and Mutual Respect'**
  String get srhSection4Subtitle;

  /// No description provided for @srhSection4Intro.
  ///
  /// In en, this message translates to:
  /// **'Healthy relationships are built on communication, equality, and uncoerced consent.'**
  String get srhSection4Intro;

  /// No description provided for @srhSection4Item1.
  ///
  /// In en, this message translates to:
  /// **'What is consent: An active, freely given, reversible, and informed agreement between partners.'**
  String get srhSection4Item1;

  /// No description provided for @srhSection4Item2.
  ///
  /// In en, this message translates to:
  /// **'Bodily autonomy: Everyone has the fundamental right to make decisions regarding their own body and reproductive health.'**
  String get srhSection4Item2;

  /// No description provided for @srhSection4Item3.
  ///
  /// In en, this message translates to:
  /// **'Effective communication: Talking openly with partners about boundaries, health history, and contraception leads to safer relationships.'**
  String get srhSection4Item3;

  /// No description provided for @srhQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Sexual & Reproductive Health Quiz'**
  String get srhQuizTitle;

  /// No description provided for @srhQ1Text.
  ///
  /// In en, this message translates to:
  /// **'Sexual and Reproductive Health includes physical, emotional, and social well-being, not merely the absence of disease.'**
  String get srhQ1Text;

  /// No description provided for @srhQ1Insight.
  ///
  /// In en, this message translates to:
  /// **'The World Health Organization recognizes SRH as a positive, holistic state of wellbeing that respects individual rights and choices.'**
  String get srhQ1Insight;

  /// No description provided for @srhQ2Text.
  ///
  /// In en, this message translates to:
  /// **'Which family planning method provides \'dual protection\' by preventing both unintended pregnancy AND sexually transmitted infections?'**
  String get srhQ2Text;

  /// No description provided for @srhQ2OptA.
  ///
  /// In en, this message translates to:
  /// **'External or internal condoms'**
  String get srhQ2OptA;

  /// No description provided for @srhQ2OptB.
  ///
  /// In en, this message translates to:
  /// **'Daily oral contraceptive pills alone'**
  String get srhQ2OptB;

  /// No description provided for @srhQ2OptC.
  ///
  /// In en, this message translates to:
  /// **'Injectable hormones alone'**
  String get srhQ2OptC;

  /// No description provided for @srhQ2OptD.
  ///
  /// In en, this message translates to:
  /// **'Intrauterine devices (IUDs) alone'**
  String get srhQ2OptD;

  /// No description provided for @srhQ2Insight.
  ///
  /// In en, this message translates to:
  /// **'While hormonal methods prevent pregnancy effectively, only barrier methods like condoms protect against STIs and HIV simultaneously.'**
  String get srhQ2Insight;

  /// No description provided for @srhQ3Text.
  ///
  /// In en, this message translates to:
  /// **'Consent in any healthy relationship must be freely given, enthusiastic, informed, and can be changed or withdrawn at any time.'**
  String get srhQ3Text;

  /// No description provided for @srhQ3Insight.
  ///
  /// In en, this message translates to:
  /// **'True consent requires freedom of choice without pressure or fear. Respecting partner boundaries is fundamental to healthy relationships.'**
  String get srhQ3Insight;

  /// No description provided for @srhQ4Text.
  ///
  /// In en, this message translates to:
  /// **'Family planning enables individuals and couples to choose if, when, and how many children to have, supporting maternal and family well-being.'**
  String get srhQ4Text;

  /// No description provided for @srhQ4Insight.
  ///
  /// In en, this message translates to:
  /// **'Family planning empowers women and families, reduces maternal complications, and supports healthy child development and financial stability.'**
  String get srhQ4Insight;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to calculate real-time distance and show nearby facilities.'**
  String get locationPermissionDenied;

  /// No description provided for @locationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are turned off on this device. Please turn on GPS.'**
  String get locationDisabled;

  /// No description provided for @calculatingDistance.
  ///
  /// In en, this message translates to:
  /// **'Determining your location...'**
  String get calculatingDistance;

  /// No description provided for @callMentorAction.
  ///
  /// In en, this message translates to:
  /// **'Call Mentor'**
  String get callMentorAction;

  /// No description provided for @telegramChatAction.
  ///
  /// In en, this message translates to:
  /// **'Chat on Telegram'**
  String get telegramChatAction;

  /// No description provided for @directContactsHeading.
  ///
  /// In en, this message translates to:
  /// **'Direct Contact Channels'**
  String get directContactsHeading;

  /// No description provided for @workingHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Available Hours: {hours}'**
  String workingHoursLabel(String hours);

  /// No description provided for @copyHandleSuccess.
  ///
  /// In en, this message translates to:
  /// **'Telegram username copied to clipboard'**
  String get copyHandleSuccess;

  /// No description provided for @copyPhoneSuccess.
  ///
  /// In en, this message translates to:
  /// **'Phone number copied to clipboard'**
  String get copyPhoneSuccess;

  /// No description provided for @sendSmsAction.
  ///
  /// In en, this message translates to:
  /// **'Send SMS'**
  String get sendSmsAction;

  /// No description provided for @phoneCallUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unable to launch phone dialer on this device'**
  String get phoneCallUnavailable;

  /// No description provided for @telegramUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unable to open Telegram link'**
  String get telegramUnavailable;

  /// No description provided for @callHotlineAction.
  ///
  /// In en, this message translates to:
  /// **'Call {number}'**
  String callHotlineAction(String number);

  /// No description provided for @chatbotTitle.
  ///
  /// In en, this message translates to:
  /// **'Yegna Health Assistant'**
  String get chatbotTitle;

  /// No description provided for @chatbotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Confidential youth health guidance'**
  String get chatbotSubtitle;

  /// No description provided for @chatbotDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Educational health assistant only, not a doctor. For clinical emergencies, call 952 or 8335.'**
  String get chatbotDisclaimer;

  /// No description provided for @chatbotInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about health, modules, or clinics...'**
  String get chatbotInputHint;

  /// No description provided for @chatbotWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello! I am your private Yegna Health Assistant. Ask me anything about puberty, HIV/AIDS, STIs, reproductive health, mental health, or finding youth-friendly clinics in Ethiopia.'**
  String get chatbotWelcomeMessage;

  /// No description provided for @chatbotSuggestedHiv.
  ///
  /// In en, this message translates to:
  /// **'How to prevent HIV?'**
  String get chatbotSuggestedHiv;

  /// No description provided for @chatbotSuggestedPuberty.
  ///
  /// In en, this message translates to:
  /// **'Normal puberty changes'**
  String get chatbotSuggestedPuberty;

  /// No description provided for @chatbotSuggestedClinics.
  ///
  /// In en, this message translates to:
  /// **'Where can I get tested?'**
  String get chatbotSuggestedClinics;

  /// No description provided for @chatbotSuggestedContraception.
  ///
  /// In en, this message translates to:
  /// **'Emergency contraception'**
  String get chatbotSuggestedContraception;

  /// No description provided for @chatbotEmergencyAlert.
  ///
  /// In en, this message translates to:
  /// **'Immediate emergency help is available. Call 952 (Health Emergency) or 8335 (Youth Helpline) now for free confidential care.'**
  String get chatbotEmergencyAlert;

  /// No description provided for @chatbotEmergencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency Helpline Alert'**
  String get chatbotEmergencyTitle;

  /// No description provided for @chatbotEmergencyCall952.
  ///
  /// In en, this message translates to:
  /// **'Call 952 (Health)'**
  String get chatbotEmergencyCall952;

  /// No description provided for @chatbotEmergencyCall8335.
  ///
  /// In en, this message translates to:
  /// **'Call 8335 (Youth)'**
  String get chatbotEmergencyCall8335;

  /// No description provided for @chatbotClearChat.
  ///
  /// In en, this message translates to:
  /// **'Clear conversation'**
  String get chatbotClearChat;

  /// No description provided for @chatbotTyping.
  ///
  /// In en, this message translates to:
  /// **'Yegna Assistant is typing...'**
  String get chatbotTyping;

  /// No description provided for @askYegnaFabTooltip.
  ///
  /// In en, this message translates to:
  /// **'Ask Yegna Health Assistant'**
  String get askYegnaFabTooltip;

  /// No description provided for @askYegnaFabLabel.
  ///
  /// In en, this message translates to:
  /// **'Ask AI'**
  String get askYegnaFabLabel;

  /// No description provided for @selfAssessmentHeading.
  ///
  /// In en, this message translates to:
  /// **'Self-Assessment'**
  String get selfAssessmentHeading;

  /// No description provided for @selfAssessmentQuestionProgress.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String selfAssessmentQuestionProgress(int current, int total);

  /// No description provided for @yesOption.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesOption;

  /// No description provided for @noOption.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noOption;

  /// No description provided for @nextQuestionAction.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextQuestionAction;

  /// No description provided for @viewResultsAction.
  ///
  /// In en, this message translates to:
  /// **'View Results'**
  String get viewResultsAction;

  /// No description provided for @retakeAssessmentAction.
  ///
  /// In en, this message translates to:
  /// **'Retake Assessment'**
  String get retakeAssessmentAction;

  /// No description provided for @selectAnswerPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please select Yes or No to proceed'**
  String get selectAnswerPrompt;

  /// No description provided for @assessmentResultHeader.
  ///
  /// In en, this message translates to:
  /// **'Assessment Result'**
  String get assessmentResultHeader;

  /// No description provided for @higherRiskTitle.
  ///
  /// In en, this message translates to:
  /// **'Higher Risk for HIV Infection'**
  String get higherRiskTitle;

  /// No description provided for @moderateRiskTitle.
  ///
  /// In en, this message translates to:
  /// **'Moderate Risk for Exposure'**
  String get moderateRiskTitle;

  /// No description provided for @lowerRiskTitle.
  ///
  /// In en, this message translates to:
  /// **'Lower Risk Profile'**
  String get lowerRiskTitle;

  /// No description provided for @recommendedActionsHeader.
  ///
  /// In en, this message translates to:
  /// **'Recommended actions'**
  String get recommendedActionsHeader;

  /// No description provided for @keyMessageHeader.
  ///
  /// In en, this message translates to:
  /// **'Key message'**
  String get keyMessageHeader;

  /// No description provided for @highRiskKeyMessage.
  ///
  /// In en, this message translates to:
  /// **'Having a high-risk score does not mean that you are infected with HIV. However, if risky behaviors continue, there is a possibility of acquiring HIV infection. Therefore, make strong efforts to reduce your level of HIV exposure risk.'**
  String get highRiskKeyMessage;

  /// No description provided for @moderateRiskKeyMessage.
  ///
  /// In en, this message translates to:
  /// **'Having moderate risk factors indicates that certain behaviors or situations may expose you to HIV or STIs. Adopting preventive practices like regular testing and consistent condom use protects your health.'**
  String get moderateRiskKeyMessage;

  /// No description provided for @lowerRiskKeyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your responses indicate lower exposure risk. Continue practicing protective behaviors, staying informed, and taking routine health checkups to keep yourself and your partner safe.'**
  String get lowerRiskKeyMessage;

  /// No description provided for @talkToMentorAction.
  ///
  /// In en, this message translates to:
  /// **'Talk to Mentor'**
  String get talkToMentorAction;

  /// No description provided for @talkToMentorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect confidentially with a certified youth mentor'**
  String get talkToMentorSubtitle;

  /// No description provided for @getServiceAction.
  ///
  /// In en, this message translates to:
  /// **'Get Service'**
  String get getServiceAction;

  /// No description provided for @getServiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find verified youth-friendly health facilities'**
  String get getServiceSubtitle;

  /// No description provided for @assessmentEducationalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Educational self-assessment only. Not a medical diagnosis. For clinical testing and professional care, visit a verified youth clinic.'**
  String get assessmentEducationalDisclaimer;

  /// No description provided for @restartAssessmentDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Restart Assessment?'**
  String get restartAssessmentDialogTitle;

  /// No description provided for @restartAssessmentDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Your current responses will be reset. Are you sure you want to start from the beginning?'**
  String get restartAssessmentDialogBody;

  /// No description provided for @restartAction.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restartAction;

  /// No description provided for @whyThisMattersLabel.
  ///
  /// In en, this message translates to:
  /// **'Why this matters'**
  String get whyThisMattersLabel;

  /// No description provided for @riskScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Risk Score: {score} / {maxScore}'**
  String riskScoreLabel(int score, int maxScore);

  /// No description provided for @categoryPartnersRelationships.
  ///
  /// In en, this message translates to:
  /// **'Partners & Relationships'**
  String get categoryPartnersRelationships;

  /// No description provided for @categoryProtectionPractices.
  ///
  /// In en, this message translates to:
  /// **'Protection Practices'**
  String get categoryProtectionPractices;

  /// No description provided for @categoryClinicalSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Clinical Symptoms'**
  String get categoryClinicalSymptoms;

  /// No description provided for @categoryHealthHistory.
  ///
  /// In en, this message translates to:
  /// **'Health History'**
  String get categoryHealthHistory;

  /// No description provided for @categoryBloodSafety.
  ///
  /// In en, this message translates to:
  /// **'Blood & Instrument Safety'**
  String get categoryBloodSafety;

  /// No description provided for @categorySubstanceRisk.
  ///
  /// In en, this message translates to:
  /// **'Substance & Behavioral Risk'**
  String get categorySubstanceRisk;

  /// No description provided for @categorySafetySupport.
  ///
  /// In en, this message translates to:
  /// **'Safety & Support'**
  String get categorySafetySupport;

  /// No description provided for @categoryTestingPrevention.
  ///
  /// In en, this message translates to:
  /// **'Testing & Prevention'**
  String get categoryTestingPrevention;

  /// No description provided for @assessmentQ1Text.
  ///
  /// In en, this message translates to:
  /// **'Have you had more than one sexual partner in the last 12 months?'**
  String get assessmentQ1Text;

  /// No description provided for @assessmentQ1Why.
  ///
  /// In en, this message translates to:
  /// **'Multiple partners without consistent barrier protection increases exposure to asymptomatic viral transmission.'**
  String get assessmentQ1Why;

  /// No description provided for @assessmentQ2Text.
  ///
  /// In en, this message translates to:
  /// **'Have you engaged in sexual activity in exchange for money, gifts, housing, or other benefits (transactional sex) in the last 12 months?'**
  String get assessmentQ2Text;

  /// No description provided for @assessmentQ2Why.
  ///
  /// In en, this message translates to:
  /// **'Transactional encounters often involve power imbalances that can make negotiating consistent condom use difficult.'**
  String get assessmentQ2Why;

  /// No description provided for @assessmentQ3Text.
  ///
  /// In en, this message translates to:
  /// **'Have you had sexual intercourse without using a condom consistently and correctly in the last 6 months?'**
  String get assessmentQ3Text;

  /// No description provided for @assessmentQ3Why.
  ///
  /// In en, this message translates to:
  /// **'Consistent and correct latex condom usage provides over 95% protection against HIV and substantially reduces other STIs.'**
  String get assessmentQ3Why;

  /// No description provided for @assessmentQ4Text.
  ///
  /// In en, this message translates to:
  /// **'Have you had sexual intercourse with a partner whose HIV status was unknown to you, or who has unsuppressed viral levels?'**
  String get assessmentQ4Text;

  /// No description provided for @assessmentQ4Why.
  ///
  /// In en, this message translates to:
  /// **'Knowing partner status is essential. Effective ART suppresses HIV (U=U), but unsuppressed or unknown statuses carry transmission risk.'**
  String get assessmentQ4Why;

  /// No description provided for @assessmentQ5Text.
  ///
  /// In en, this message translates to:
  /// **'In the past 6 months, have you noticed unusual genital discharge, sores, burning during urination, or pelvic pain?'**
  String get assessmentQ5Text;

  /// No description provided for @assessmentQ5Why.
  ///
  /// In en, this message translates to:
  /// **'Untreated STIs cause mucosal ulcerations, increasing biological susceptibility to HIV transmission by 3 to 5 times.'**
  String get assessmentQ5Why;

  /// No description provided for @assessmentQ6Text.
  ///
  /// In en, this message translates to:
  /// **'Have you or any of your partners ever been diagnosed with or treated for a sexually transmitted infection (STI)?'**
  String get assessmentQ6Text;

  /// No description provided for @assessmentQ6Why.
  ///
  /// In en, this message translates to:
  /// **'A past STI indicates previous unprotected exposure and potential risk of reinfection if both partners were not treated simultaneously.'**
  String get assessmentQ6Why;

  /// No description provided for @assessmentQ7Text.
  ///
  /// In en, this message translates to:
  /// **'Have you received tattoos, body piercings, or traditional skin cuts using equipment that might not have been sterile?'**
  String get assessmentQ7Text;

  /// No description provided for @assessmentQ7Why.
  ///
  /// In en, this message translates to:
  /// **'Direct blood contact via non-sterile instruments can transmit bloodborne viruses including Hepatitis B, C, and HIV.'**
  String get assessmentQ7Why;

  /// No description provided for @assessmentQ8Text.
  ///
  /// In en, this message translates to:
  /// **'Have you ever shared needles, syringes, or injection equipment with another person?'**
  String get assessmentQ8Text;

  /// No description provided for @assessmentQ8Why.
  ///
  /// In en, this message translates to:
  /// **'Sharing injection equipment carries one of the highest direct risks for rapid HIV and Hepatitis transmission.'**
  String get assessmentQ8Why;

  /// No description provided for @assessmentQ9Text.
  ///
  /// In en, this message translates to:
  /// **'Do you frequently consume alcohol, khat, or substances before sex, making condom use harder to remember or negotiate?'**
  String get assessmentQ9Text;

  /// No description provided for @assessmentQ9Why.
  ///
  /// In en, this message translates to:
  /// **'Substances impair decision-making and are the primary behavioral factor in unplanned condomless sexual activity.'**
  String get assessmentQ9Why;

  /// No description provided for @assessmentQ10Text.
  ///
  /// In en, this message translates to:
  /// **'Have you ever experienced forced sexual contact, coercion, or non-consensual sexual activity?'**
  String get assessmentQ10Text;

  /// No description provided for @assessmentQ10Why.
  ///
  /// In en, this message translates to:
  /// **'Non-consensual encounters carry high trauma and exposure risk. Emergency PEP is available within 72 hours alongside crisis counseling.'**
  String get assessmentQ10Why;

  /// No description provided for @assessmentQ11Text.
  ///
  /// In en, this message translates to:
  /// **'Have you experienced chronic unexplained fever, severe fatigue, drenching night sweats, or rapid weight loss?'**
  String get assessmentQ11Text;

  /// No description provided for @assessmentQ11Why.
  ///
  /// In en, this message translates to:
  /// **'These systemic warning symptoms require prompt professional evaluation to check for infections, tuberculosis, or HIV.'**
  String get assessmentQ11Why;

  /// No description provided for @assessmentQ12Text.
  ///
  /// In en, this message translates to:
  /// **'Has it been more than 6 months since your last HIV and sexual health test (or have you never been tested)?'**
  String get assessmentQ12Text;

  /// No description provided for @assessmentQ12Why.
  ///
  /// In en, this message translates to:
  /// **'HIV can be asymptomatic for years. Routine testing every 3 to 6 months provides peace of mind and early life-saving care.'**
  String get assessmentQ12Why;

  /// No description provided for @highRiskAction1.
  ///
  /// In en, this message translates to:
  /// **'Get tested for HIV immediately at a youth-friendly clinic.'**
  String get highRiskAction1;

  /// No description provided for @highRiskAction2.
  ///
  /// In en, this message translates to:
  /// **'Use condoms consistently and correctly every time.'**
  String get highRiskAction2;

  /// No description provided for @highRiskAction3.
  ///
  /// In en, this message translates to:
  /// **'Actively participate in all peer learning sessions and talk to a mentor.'**
  String get highRiskAction3;

  /// No description provided for @highRiskAction4.
  ///
  /// In en, this message translates to:
  /// **'Ask a clinician about PrEP (Pre-Exposure Prophylaxis) for ongoing protection.'**
  String get highRiskAction4;

  /// No description provided for @modRiskAction1.
  ///
  /// In en, this message translates to:
  /// **'Schedule a routine HIV and STI screening test soon.'**
  String get modRiskAction1;

  /// No description provided for @modRiskAction2.
  ///
  /// In en, this message translates to:
  /// **'Ensure consistent barrier protection (condoms) in all sexual encounters.'**
  String get modRiskAction2;

  /// No description provided for @modRiskAction3.
  ///
  /// In en, this message translates to:
  /// **'Explore our learning modules and discuss testing with your partner.'**
  String get modRiskAction3;

  /// No description provided for @lowRiskAction1.
  ///
  /// In en, this message translates to:
  /// **'Continue practicing safe behaviors and mutual open communication.'**
  String get lowRiskAction1;

  /// No description provided for @lowRiskAction2.
  ///
  /// In en, this message translates to:
  /// **'Maintain annual or bi-annual routine health checkups.'**
  String get lowRiskAction2;

  /// No description provided for @lowRiskAction3.
  ///
  /// In en, this message translates to:
  /// **'Share reliable health facts with friends and peers in your community.'**
  String get lowRiskAction3;
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
