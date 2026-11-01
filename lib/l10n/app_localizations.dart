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
