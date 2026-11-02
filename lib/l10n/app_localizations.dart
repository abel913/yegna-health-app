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
