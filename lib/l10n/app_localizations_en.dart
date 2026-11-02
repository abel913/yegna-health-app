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
  String get learningHeading => 'Learning Modules';

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

  @override
  String get learningModulesTitle => 'Learning Modules';

  @override
  String get moreButton => 'More';

  @override
  String get takeQuizButton => 'Take Quiz';

  @override
  String moduleLabel(String number) {
    return 'MODULE $number';
  }

  @override
  String get module01Title => 'Adolescent health & puberty';

  @override
  String get module01Desc =>
      'This module covers physical and emotional changes during puberty, personal hygiene, and growing body confidence.';

  @override
  String get module02Title => 'Sexual transmitted infections (STI)';

  @override
  String get module02Desc =>
      'This module explains Sexually Transmitted Infections, including what they are, their signs and symptoms, how they are diagnosed, treated, and prevented.';

  @override
  String get module03Title => 'Hepatitis';

  @override
  String get module03Desc =>
      'This module introduces Hepatitis, focusing on its causes, types, symptoms, and how it affects liver health.';

  @override
  String get module04Title => 'Gender-based violence (GBV)';

  @override
  String get module04Desc =>
      'This module addresses Gender-Based Violence, helping learners understand its forms, causes, and impact on individuals and society.';

  @override
  String get module05Title => 'Sexual and reproductive health (SRH)';

  @override
  String get module05Desc =>
      'This module focuses on helping individuals understand their well-being in relation to sexuality, relationships, and reproduction.';

  @override
  String get module06Title => 'Mental health & wellbeing';

  @override
  String get module06Desc =>
      'This module explores mental well-being, stress management, overcoming anxiety, and finding safe support.';

  @override
  String get module07Title => 'Human immune virus (HIV)/AIDS';

  @override
  String get module07Desc =>
      'This module provides essential knowledge about HIV/AIDS, including what it is, how it spreads, how to prevent it, and how it can be treated.';

  @override
  String get module08Title => 'Substance Abuse';

  @override
  String get module08Desc =>
      'This module explores by helping you understand different types of substances, how they affect the brain and behavior, and how to maintain a healthy lifestyle.';

  @override
  String get completedStatus => 'Completed';

  @override
  String get hivHeroDesc =>
      'HIV/AIDS is a virus that weakens the immune system, spreads mainly through unsafe sex, blood, and mother-to-child, but can be prevented with safe practices and managed effectively with early testing and treatment (ART).';

  @override
  String get hivNoteTitle => 'Note';

  @override
  String get hivNoteContent =>
      'HIV can be prevented and managed—practice safe behaviors, get tested early, and start treatment (ART) to live a healthy life and protect others.';

  @override
  String get learningSectionsTitle => 'Learning Sections';

  @override
  String readSectionsCount(int count, int total) {
    return '$count / $total read';
  }

  @override
  String get hivDefinitionTitle => 'Defination';

  @override
  String get hivDefinitionSubtitle =>
      'What is HIV/AIDS and how it affects the immune system';

  @override
  String get hivDefinitionDesc1 =>
      'HIV (Human Immunodeficiency Virus) is a virus that attacks the body’s immune system, specifically the CD4 white blood cells (T cells) that fight off infections.';

  @override
  String get hivDefinitionDesc2 =>
      'Without treatment, HIV can gradually destroy CD4 cells over time and advance to AIDS (Acquired Immunodeficiency Syndrome), which is the most advanced clinical stage of HIV infection.';

  @override
  String get hivDefinitionDesc3 =>
      'With modern antiretroviral therapy (ART), people living with HIV suppress the virus to undetectable levels (Undetectable = Untransmittable or U=U), stay healthy, and live long, normal lives.';

  @override
  String get hivTransmissionTitle => 'Mode of transmission';

  @override
  String get hivTransmissionSubtitle =>
      'How the virus spreads and debunking common myths';

  @override
  String get hivTransmissionIntro =>
      'HIV is transmitted through contact with specific body fluids from someone with a detectable viral load:';

  @override
  String get hivTransmissionItem1 =>
      'Unprotected sexual intercourse (vaginal or anal sex without condoms).';

  @override
  String get hivTransmissionItem2 =>
      'Sharing contaminated needles, syringes, tattoo needles, or sharp piercing instruments.';

  @override
  String get hivTransmissionItem3 =>
      'Mother-to-child transmission during pregnancy, childbirth, or breastfeeding (largely preventable through PMTCT care).';

  @override
  String get hivTransmissionItem4 =>
      'Transfusion of unscreened blood (extremely rare due to universal laboratory screening).';

  @override
  String get hivNotTransmittedTitle => 'How HIV is NOT transmitted:';

  @override
  String get hivNotTransmittedDesc =>
      'HIV cannot survive outside the human body. It is NOT spread through shaking hands, hugging, coughing, sneezing, sharing food or toilets, swimming pools, or mosquito/insect bites.';

  @override
  String get hivPreventionTitle => 'HIV-Prevention';

  @override
  String get moduleComingSoon =>
      'Full module content and interactive quizzes will be configured in the next step.';

  @override
  String get watchVideo => 'Watch video';

  @override
  String get waysToPreventHiv => 'Ways to prevent HIV';

  @override
  String get hivTesting => 'HIV testing';

  @override
  String get treatmentForHivPositive => 'Treatment for HIV positive client';

  @override
  String get pepTitle =>
      'Post-exposure prophylaxis (PEP) -Given for people exposed to HIV.';

  @override
  String get pepDesc =>
      'PEP stands for post-exposure prophylaxis. The word “prophylaxis” means to prevent or control the spread of an infection or disease. PEP means taking HIV medicines within 72 hours (3 days) after a possible exposure to HIV to prevent HIV.';

  @override
  String get condomStepsTitle =>
      'How to use a condom in 10 steps- for age greater than 18';

  @override
  String get condomStepsSubtitle =>
      'Follow the 10 steps below to avoid condom breakage or slippage. The how to put on a condom video shows these steps.';

  @override
  String get condomStep1 =>
      'Check the expiry date. Do not use expired condoms.';

  @override
  String get condomStep2 =>
      'Press the package between your fingers. Do not use if there is no resistance from air inside.';

  @override
  String get condomStep3 =>
      'Tear open the condom package from the corner and remove the condom. Do not use teeth or sharp objects to open as this can damage the condom.';

  @override
  String get condomStep4 => 'Identify which way the condom unrolls.';

  @override
  String get condomStep5 =>
      'Pinch the receptor tip of the condom to remove air.';

  @override
  String get condomStep6 =>
      'Place the condom on the head of the penis while still pinching the condom receptor tip.';

  @override
  String get condomStep7 => 'Unroll the condom to the base of the shaft.';

  @override
  String get condomStep8 => 'Insert the penis into vagina.';

  @override
  String get condomStep9 =>
      'Pull out while still erect, holding the base of the condom firmly.';

  @override
  String get condomStep10 => 'Remove the condom from the penis and discard.';

  @override
  String get hivTestingDesc =>
      'HIV testing services refer to the full range of services that include HIV testing, counseling and linkage to appropriate HIV prevention, treatment and care. The following are HIV testing methods.';

  @override
  String get pitcTitle => 'Provider Initiated Testing and Counseling (PITC): ';

  @override
  String get pitcDesc =>
      'This refers to HIV testing, and counseling recommended by a provider during a visit to a health care facility.';

  @override
  String get vctTitle => 'Voluntary Counseling and Testing (VCT): ';

  @override
  String get vctDesc =>
      'VCT is initiated by clients seeking to know their HIV status.';

  @override
  String get artDesc1 =>
      'People with HIV need to start taking special medicine called antiretroviral therapy, or ART, as soon as they can. This medicine helps slow down the HIV virus in their bodies. When someone takes ART, the amount of virus goes down, and their immune system gets stronger.';

  @override
  String get artDesc2 =>
      'Everyone, including children, Adolescents and adults, who have HIV should begin this treatment right after they find out they have the virus. Starting treatment early can help people live longer, stay healthier, and reduce the chances of passing HIV to others. It also helps prevent other illnesses and makes life better for those living with HIV.';

  @override
  String get artDesc3 =>
      'ART service is available in public health facilities like Health center and Hospital.';

  @override
  String get markCompleted => 'Mark as Completed';

  @override
  String get moduleCompletedSuccess => 'Module marked as completed!';

  @override
  String get videoDialogTitle => 'Educational Video';

  @override
  String get lubricantsVideoDesc =>
      'Demonstration on condom safety: Petroleum jelly, baby oils, and body lotions weaken latex and cause condom failure. Only water-based or silicone lubricants are safe to use with condoms.';

  @override
  String get counsellingVideoDesc =>
      'Demonstration and clinical counseling on proper condom usage, correct sizing, and dual protection against STIs and unintended pregnancy.';

  @override
  String get closeButton => 'Close';

  @override
  String get viewProfile => 'View Profile';

  @override
  String get viewProfileSubtitle => 'Identity • Age';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsSubtitle => 'Preferences • Alerts';

  @override
  String get accountSettingsHeader => 'ACCOUNT SETTINGS';

  @override
  String get privacyAndSecurity => 'Privacy & Security';

  @override
  String get privacySubtitle => 'Password • Privacy • Security';

  @override
  String get appLanguage => 'App Language';

  @override
  String get appLanguageSubtitle => 'Choose your language';

  @override
  String get appTheme => 'App Theme';

  @override
  String get appThemeSubtitle => 'Light or dark';

  @override
  String get textSize => 'Text Size';

  @override
  String get textSizeSubtitle => 'Display • Reading • Size';

  @override
  String get supportCenter => 'Support Center';

  @override
  String get supportCenterSubtitle => 'Help • Contact • Support';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get defaultTextSize => 'Default';

  @override
  String get smallTextSize => 'Small';

  @override
  String get largeTextSize => 'Large';

  @override
  String get appVersion => 'Version 1.0.0';

  @override
  String get supportCenterTitle => 'Support & Helpline';

  @override
  String get supportCenterBody =>
      'If you have questions about sexual and reproductive health or need confidential peer assistance, reach out to verified youth centers and national health hotlines (such as 952 or 8335). Yegna Health provides general education and does not replace emergency medical care.';

  @override
  String get notificationsModalTitle => 'Notification Settings';

  @override
  String get notificationsModalBody =>
      'Configure alert preferences, daily learning reminders, and health tips.';

  @override
  String get privacyModalTitle => 'Privacy & Security Settings';

  @override
  String get privacyModalBody =>
      'Your health exploration and progress records are securely stored on this device with industry-standard PKCE tokens and encryption. You can change your password anytime.';

  @override
  String get themeDialogTitle => 'Choose App Theme';

  @override
  String get textSizeDialogTitle => 'Choose Text Size';

  @override
  String get srhVctFilter => 'SRH & VCT';

  @override
  String get mentalHealthFilter => 'Mental Health';

  @override
  String get listViewLabel => 'List';

  @override
  String get mapViewLabel => 'Map';

  @override
  String get openNowStatus => 'Open Now';

  @override
  String get closedStatus => 'Closed';

  @override
  String get verifiedYouthFriendlyBadge => 'Verified Youth-Friendly';

  @override
  String get freeForYouthBadge => 'Free Services';

  @override
  String get callClinicAction => 'Call Clinic';

  @override
  String get directionsAction => 'Directions';

  @override
  String get viewDetailsAction => 'View Details';

  @override
  String get confidentialityNoticeTitle => 'Youth Confidentiality Guarantee';

  @override
  String get landmarkLabel => 'Landmark';

  @override
  String get operatingHoursLabel => 'Operating Hours';

  @override
  String get servicesOfferedLabel => 'Available Services';

  @override
  String get resetFiltersAction => 'Reset Filters';

  @override
  String get copiedToClipboard => 'Phone number copied to clipboard';

  @override
  String get campusClinicBadge => 'Campus Clinic';

  @override
  String distanceKm(String distance) {
    return '$distance km away';
  }

  @override
  String closesAt(String time) {
    return 'Closes at $time';
  }

  @override
  String opensAt(String time) {
    return 'Opens at $time';
  }

  @override
  String get onlineNowFilter => 'Online';

  @override
  String get pubertyFilter => 'Puberty';

  @override
  String get substanceFilter => 'Healthy Lifestyle';

  @override
  String get availableNowBadge => 'Available Now';

  @override
  String nextSlotBadge(String time) {
    return 'Next: $time';
  }

  @override
  String get verifiedPeerBadge => 'Verified Peer Counselor';

  @override
  String get chatConfidentialAction => 'Chat Confidential';

  @override
  String get viewProfileBtn => 'View Profile';

  @override
  String get safeguardingTitle => 'Safeguarding & Confidentiality';

  @override
  String experienceMetrics(int years, int sessions) {
    return '$years yrs exp • $sessions+ sessions';
  }

  @override
  String get sessionsCountLabel => 'Sessions';

  @override
  String get languagesSpokenLabel => 'Languages Spoken';

  @override
  String get specialtiesLabel => 'Focus Areas';

  @override
  String startChatPrompt(String name) {
    return 'Start confidential conversation with $name';
  }

  @override
  String get emergencyDisclaimer =>
      'Peer mentors provide general guidance and active listening. In severe emotional distress or medical emergency, please call toll-free hotlines 952 or 8335 immediately.';

  @override
  String get sendPeerMessage => 'Send Message';

  @override
  String get peerChatComingSoon =>
      'Live anonymous messaging session initialized. Your counselor will respond within moments.';

  @override
  String get languageAll => 'All Languages';
}
