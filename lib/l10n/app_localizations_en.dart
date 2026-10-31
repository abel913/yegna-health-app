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

  @override
  String get learningHeading => 'Health education';

  @override
  String get learningIntroduction =>
      'Browse educational resources reviewed for publication. This app does not replace professional care.';

  @override
  String get articlesHeading => 'Articles';

  @override
  String get assessmentsHeading => 'Assessments';

  @override
  String get progressHeading => 'My learning';

  @override
  String get searchArticles => 'Search articles';

  @override
  String get allCategories => 'All categories';

  @override
  String get noReviewedArticles => 'No reviewed articles are available yet.';

  @override
  String get noReviewedAssessments =>
      'No reviewed assessments are available yet.';

  @override
  String get noSearchResults => 'No articles match your search.';

  @override
  String get learningLoadError =>
      'We couldn’t load learning content. Check your connection and try again.';

  @override
  String get educationUnavailable =>
      'Learning content is not available in this build.';

  @override
  String get retryAction => 'Try again';

  @override
  String staleSavedContentWarning(String date) {
    return 'This saved copy was last checked on $date. It may be out of date or withdrawn. Reconnect before relying on it.';
  }

  @override
  String get sourceReferences => 'Sources';

  @override
  String articleReviewInfo(String date) {
    return 'Reviewed on $date. Educational information does not replace professional care.';
  }

  @override
  String get relatedLearning => 'Related learning';

  @override
  String get markArticleComplete => 'Mark as read';

  @override
  String get articleMarkedComplete =>
      'Reading saved to your learning progress.';

  @override
  String get startAssessment => 'Start assessment';

  @override
  String questionProgress(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get nextQuestion => 'Next question';

  @override
  String get submitAnswers => 'Submit answers';

  @override
  String get retakeAssessment => 'Retake assessment';

  @override
  String assessmentResult(int score, int total, int percent) {
    return '$score of $total correct ($percent%)';
  }

  @override
  String get answerExplanation => 'Explanation';

  @override
  String get correctAnswer => 'Correct answer';

  @override
  String get pendingScore =>
      'Your answers are saved on this device. Connect to the internet to receive a verified score.';

  @override
  String get assessmentSubmitError =>
      'We couldn’t submit your answers. Your score is not available yet.';

  @override
  String get selectAnAnswer => 'Select an answer to continue.';

  @override
  String get progressSyncTitle => 'Learning progress sync';

  @override
  String get progressSyncDescription =>
      'Choose whether to sync completed articles and assessment history to your signed-in account. Local progress stays available when sync is off.';

  @override
  String get progressSyncEnable => 'Turn on sync';

  @override
  String get progressSyncDisable => 'Turn off sync';

  @override
  String get progressSyncEnabled => 'Progress sync is on.';

  @override
  String get progressSyncDisabled =>
      'Progress sync is off. Local progress is still available.';

  @override
  String get progressSyncSignInRequired => 'Sign in to sync learning progress.';

  @override
  String get progressSyncError =>
      'We couldn’t update sync settings. Your local progress is still available.';

  @override
  String get clearSyncedHistory => 'Clear synced history';

  @override
  String get clearSyncedHistoryTitle => 'Clear synced learning history?';

  @override
  String get clearSyncedHistoryBody =>
      'This removes article completions and assessment attempts from your account. Progress stored on this device will remain.';

  @override
  String get clearHistoryAction => 'Clear history';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get syncedHistoryCleared => 'Synced learning history was cleared.';

  @override
  String get clearHistoryError =>
      'We couldn’t clear synced history. Try again.';

  @override
  String completedArticlesCount(int count) {
    return 'Completed articles: $count';
  }

  @override
  String assessmentAttemptsCount(int count) {
    return 'Assessment attempts: $count';
  }

  @override
  String get noLearningProgress => 'Your learning progress will appear here.';

  @override
  String get localProgressLabel => 'Saved on this device';

  @override
  String get scoreHistoryLabel => 'Verified score history';

  @override
  String assessmentScorePercent(int score) {
    return '$score%';
  }

  @override
  String get facilitiesTab => 'Facilities';

  @override
  String get mentorsTab => 'Mentors';

  @override
  String get accountTab => 'Account';

  @override
  String get healthEducationBoundary =>
      'Educational information only. This app does not replace professional care.';

  @override
  String get quickLinksHeading => 'Explore';

  @override
  String get quickLinksDescription => 'Choose a section to continue.';

  @override
  String get featuredArticlesHeading => 'Health education';

  @override
  String get viewAllAction => 'View all';

  @override
  String get noFeaturedArticlesTitle => 'No reviewed articles yet';

  @override
  String get noFeaturedArticlesBody =>
      'Published learning resources will appear here when they are ready.';

  @override
  String get homeFaqHeading => 'Frequently asked questions';

  @override
  String get noReviewedFaqsTitle => 'No reviewed questions yet';

  @override
  String get noReviewedFaqsBody =>
      'Answers will appear here after they are reviewed and approved.';

  @override
  String get findVerifiedCare => 'Looking for care?';

  @override
  String get facilitiesIntroduction =>
      'Explore youth-friendly health facilities and services.';

  @override
  String get searchFacilities => 'Search facilities';

  @override
  String get allFacilities => 'All facilities';

  @override
  String get nearbyFilter => 'Nearby';

  @override
  String get campusFilter => 'Campus';

  @override
  String get noVerifiedFacilitiesTitle => 'No verified facilities listed yet';

  @override
  String get facilitiesNotAvailableBody =>
      'Facility information is not available yet. No providers or contact details are listed until they can be verified.';

  @override
  String get mapPreviewTitle => 'Map';

  @override
  String get mapNotAvailableBody =>
      'A map will be available when a verified facility directory is ready.';

  @override
  String get mentorsIntroduction =>
      'Find peer support when verified profiles become available.';

  @override
  String get searchMentors => 'Search mentors';

  @override
  String get allMentors => 'All mentors';

  @override
  String get languageFilter => 'Language';

  @override
  String get noVerifiedMentorsTitle => 'No verified mentor profiles yet';

  @override
  String get noVerifiedMentorsBody =>
      'Mentor profiles and contact options will appear here after identity and safety checks are in place.';

  @override
  String get mentorSafetyTitle => 'Peer support directory';

  @override
  String get mentorSafetyBody =>
      'No people or contact information are displayed until a verification process is available.';

  @override
  String get learningProgressTitle => 'Your learning activity';

  @override
  String get selfAssessmentTitle => 'Self-Assessment';

  @override
  String get selfAssessmentDesc =>
      'Assess your health status and get guided recommendations.';

  @override
  String get learnDesc => 'Explore sexual and reproductive health education.';

  @override
  String get findFacilitiesTitle => 'Find Health Facilities';

  @override
  String get findFacilitiesDesc =>
      'Locate verified youth-friendly health facilities.';

  @override
  String get peerMentorTitle => 'Peer Mentor';

  @override
  String get peerMentorDesc =>
      'Connect with compassionate mentors for guidance.';

  @override
  String get welcomeHeroTitle => 'Welcome to Yegna Health';

  @override
  String get welcomeHeroSubtitle =>
      'Empowering youth to conduct self-assessments, explore health education, and connect with compassionate professionals.';

  @override
  String get confidentialPill => '100% Confidential';

  @override
  String get reviewedPill => 'Reviewed Sources';

  @override
  String get guestReadyPill => 'Open & Free';
}
