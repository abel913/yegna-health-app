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
      'Connect confidentially with certified youth peer counselors for free guidance.';

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
  String get stiHeroDesc =>
      'STIs are infections spread mainly through unprotected sexual contact; they may show no symptoms but can cause serious health complications if untreated, and can be managed effectively with early diagnosis and proper treatment.';

  @override
  String get stiNoteContent =>
      'Protect yourself by practicing safe sex, getting tested regularly, and seeking medical care early knowing your status helps prevent complications and protects others.';

  @override
  String get stiDefinitionTitle => 'Definition';

  @override
  String get stiDefinitionSubtitle =>
      'What are Sexually Transmitted Infections (STIs)?';

  @override
  String get stiDefinitionDesc1 =>
      'Sexually Transmitted Infections (STIs) are infections passed from person to person primarily through sexual contact (vaginal, oral, or anal intercourse). They are caused by bacteria, viruses, or parasites.';

  @override
  String get stiDefinitionDesc2 =>
      'Common bacterial STIs include Chlamydia, Gonorrhea, and Syphilis. Common viral STIs include HPV (Human Papillomavirus), Herpes (HSV), Hepatitis B, and HIV. Common parasitic STIs include Trichomoniasis.';

  @override
  String get stiDefinitionDesc3 =>
      'An infection (STI) means a pathogen is present in the body, often without causing symptoms. It becomes a disease (STD) when the infection causes noticeable damage or illness. Many STIs are silent but still contagious.';

  @override
  String get stiSymptomsTitle => 'Signs and Symptoms of STI';

  @override
  String get stiSymptomsSubtitle =>
      'Recognizing common signs and asymptomatic cases';

  @override
  String get stiSymptomsIntro =>
      'Symptoms can vary depending on the specific infection and gender, but commonly include:';

  @override
  String get stiSymptom1 =>
      'Unusual discharge: Thick, watery, yellow, green, or foul-smelling discharge from the penis, vagina, or anus.';

  @override
  String get stiSymptom2 =>
      'Pain or burning sensation: Discomfort or burning pain during urination (dysuria) or during sexual intercourse.';

  @override
  String get stiSymptom3 =>
      'Sores, bumps, or blisters: Painful or painless blisters, ulcers, warts, or lesions on the genitals, groin, mouth, or anus.';

  @override
  String get stiSymptom4 =>
      'Itching and irritation: Persistent itching, redness, or swelling around the genital and perineal areas.';

  @override
  String get stiSymptom5 =>
      'Abdominal or pelvic pain: Lower belly pain, unexpected bleeding between menstrual periods, or bleeding after intercourse.';

  @override
  String get stiSymptomsAsymptomaticAlert =>
      'Silent infections: Up to 70% of women and many men with STIs like chlamydia or gonorrhea experience NO noticeable symptoms. Regular clinical testing is the only reliable way to confirm status.';

  @override
  String get stiDiagnosisTitle => 'Diagnosis of STI';

  @override
  String get stiDiagnosisSubtitle =>
      'How healthcare providers detect and evaluate STIs';

  @override
  String get stiDiagnosisIntro =>
      'Early diagnosis ensures quick cure and prevents irreversible reproductive damage. Healthcare providers use:';

  @override
  String get stiDiagnosisItem1 =>
      'Clinical examination: Confidential, private, and respectful physical assessment by a trained health professional.';

  @override
  String get stiDiagnosisItem2 =>
      'Laboratory tests: Blood tests (for Syphilis, HIV, Hepatitis B), urine samples, and swabs from fluid or sores.';

  @override
  String get stiDiagnosisItem3 =>
      'National syndromic management: In primary health clinics across Ethiopia, healthcare workers follow national guidelines to treat symptoms immediately on the first visit without waiting days for lab results.';

  @override
  String get stiDiagnosisYouthFriendly =>
      'Youth-friendly centers provide completely confidential, stigma-free counseling, tests, and care for adolescents and youth.';

  @override
  String get stiComplicationsTitle => 'Complications of STI';

  @override
  String get stiComplicationsSubtitle =>
      'Serious risks of leaving STIs untreated';

  @override
  String get stiComplicationsIntro =>
      'When left untreated or improperly treated, STIs can lead to severe and lasting health consequences:';

  @override
  String get stiComplication1 =>
      'Infertility & PID: Untreated chlamydia or gonorrhea can cause Pelvic Inflammatory Disease (PID) in women, leading to scarring of fallopian tubes, chronic pain, life-threatening ectopic pregnancy, or infertility. In men, it can cause painful epididymitis and infertility.';

  @override
  String get stiComplication2 =>
      'Higher HIV risk: Open genital sores and mucosal inflammation from STIs multiply the risk of contracting or transmitting HIV by 3 to 5 times.';

  @override
  String get stiComplication3 =>
      'Mother-to-child transmission: Pregnant mothers with untreated STIs can pass infections to their babies, leading to miscarriage, stillbirth, premature birth, low birth weight, and newborn eye infections.';

  @override
  String get stiComplication4 =>
      'Cervical & other cancers: Persistent infections with high-risk HPV strains are the primary cause of cervical cancer in women.';

  @override
  String get stiTreatmentTitle => 'Management and treatment of STI';

  @override
  String get stiTreatmentSubtitle =>
      'Medical therapies and critical rules for recovery';

  @override
  String get stiTreatmentDesc1 =>
      'Bacterial and parasitic STIs (Chlamydia, Gonorrhea, Syphilis, Trichomoniasis) are fully curable with specific prescription antibiotics or antiparasitics.';

  @override
  String get stiTreatmentDesc2 =>
      'Viral STIs (Herpes, HPV, HIV, Hepatitis B) cannot be cured with antibiotics, but modern antiviral medications effectively manage symptoms, reduce recurrences, and prevent complications.';

  @override
  String get stiTreatmentRule1 =>
      'Finish all medication: Always complete the full prescribed course, even if symptoms vanish early. Incomplete treatment creates antibiotic-resistant strains.';

  @override
  String get stiTreatmentRule2 =>
      'Treat sexual partners simultaneously: Both partners must receive treatment at the same time to prevent passing the infection back and forth (ping-pong effect).';

  @override
  String get stiTreatmentRule3 =>
      'Abstain during treatment: Refrain from all sexual intercourse until both partners finish all medicines and clinical symptoms are completely gone.';

  @override
  String get stiTreatmentRule4 =>
      'Never self-medicate: Do not take leftover pills or buy random antibiotics from pharmacies without a medical diagnosis, as wrong medications can make infections worse.';

  @override
  String get stiPreventionTitle => 'Prevention of STI';

  @override
  String get stiPreventionSubtitle =>
      'Effective ways to protect yourself and your partner';

  @override
  String get stiPreventionIntro =>
      'Protecting yourself from STIs requires practical, consistent safe behaviors:';

  @override
  String get stiPreventionItem1 =>
      'Consistent & correct condom use: Latex and polyurethane male and female condoms provide highly effective barrier protection against most STIs when used properly every single time.';

  @override
  String get stiPreventionItem2 =>
      'Mutual fidelity: Being in a faithful relationship with one uninfected partner after both have been tested.';

  @override
  String get stiPreventionItem3 =>
      'Abstinence: Choosing not to engage in sexual intercourse is the only 100% foolproof way to prevent STIs.';

  @override
  String get stiPreventionItem4 =>
      'Vaccination: Vaccines against HPV (protects against cervical cancer) and Hepatitis B are safe, highly effective, and available.';

  @override
  String get stiPreventionItem5 =>
      'Regular checkups & screening: Getting tested before starting a new sexual relationship and getting screened annually if sexually active.';

  @override
  String get stiPreventionItem6 =>
      'Avoid alcohol and substance abuse: Intoxication impairs judgment and significantly reduces the use of protection.';

  @override
  String get hepatitisHeroDesc =>
      'Hepatitis is inflammation of the liver caused by viruses or other factors, often showing mild or no symptoms but potentially leading to serious complications like cirrhosis, liver failure, or cancer if untreated; early diagnosis and proper management are essential.';

  @override
  String get hepatitisNoteContent =>
      'Hepatitis can be prevented and managed—practice good hygiene, avoid risky behaviors, get vaccinated where possible, and seek early testing to protect your liver health.';

  @override
  String get hepatitisSection1Title => 'Definition';

  @override
  String get hepatitisSection1Desc1 =>
      'Hepatitis is a general term used to describe inflammation of the liver. Liver inflammation can be caused by several viruses (viral hepatitis), chemicals, drugs, alcohol, certain genetic disorders or by an overactive immune system that mistakenly attacks the liver, called autoimmune hepatitis.';

  @override
  String get hepatitisSection1Desc2 =>
      'There are several types of hepatitis, which are categorized as viral hepatitis and non-viral hepatitis. The most common types of viral hepatitis are A, B, C, D, and E. Then there are non-viral causes of hepatitis, such as autoimmune hepatitis, alcoholic hepatitis, and drug-induced hepatitis.';

  @override
  String get hepatitisSection2Title => 'Sign and symptoms of Hepatitis';

  @override
  String get hepatitisSection2Intro =>
      'Many people with hepatitis A, B, C, D or E exhibit only mild symptoms or no symptoms at all. Each form of the virus, however, can cause more severe symptoms. Symptoms of hepatitis A, B and C may include: -';

  @override
  String get hepatitisSymptom1 => 'fever';

  @override
  String get hepatitisSymptom2 => 'malaise';

  @override
  String get hepatitisSymptom3 => 'loss of appetite';

  @override
  String get hepatitisSymptom4 => 'diarrhea';

  @override
  String get hepatitisSymptom5 => 'nausea';

  @override
  String get hepatitisSymptom6 => 'abdominal discomfort';

  @override
  String get hepatitisSymptom7 =>
      'dark-colored urine and jaundice (a yellowing of the skin and whites of the eyes).';

  @override
  String get hepatitisSection2ChronicNote =>
      'In some cases, the virus can also cause a chronic liver infection that can later develop into cirrhosis (a scarring of the liver) or liver cancer. These patients are at risk of death.';

  @override
  String get hepatitisBTitle => 'Hepatitis B';

  @override
  String get hepatitisBDesc =>
      'Hepatitis B is a viral infection that affects the liver, caused by the Hepatitis B virus (HBV). It can range from a mild illness to a serious, long-term (chronic) condition that can lead to liver cirrhosis, liver failure, or liver cancer.';

  @override
  String get hepatitisBTransmissionIntro =>
      'The virus is transmitted through contact with infectious body fluids, such as blood, semen, and vaginal fluids, commonly through:';

  @override
  String get hepatitisBTransmission1 => 'Unprotected sexual contact';

  @override
  String get hepatitisBTransmission2 =>
      'Sharing needles or other drug paraphernalia';

  @override
  String get hepatitisBTransmission3 =>
      'From an infected mother to her newborn during childbirth';

  @override
  String get hepatitisBTransmission4 =>
      'Exposure to contaminated blood in healthcare settings';

  @override
  String get hepatitisBAlert =>
      'Hepatitis B is preventable with a vaccine, but it has no cure.';

  @override
  String get hepatitisCTitle => 'Hepatitis C';

  @override
  String get hepatitisCDesc =>
      'Hepatitis C is a viral infection caused by the Hepatitis C virus (HCV), primarily affecting the liver. It is most commonly spread through blood-to-blood contact, often through:';

  @override
  String get hepatitisCTransmission1 =>
      'Sharing needles or other drug equipment';

  @override
  String get hepatitisCTransmission2 =>
      'Receiving contaminated blood products (though this is less common now due to screening)';

  @override
  String get hepatitisCTransmission3 =>
      'In some cases, through sexual contact or from an infected mother to her baby during childbirth.';

  @override
  String get hepatitisCChronicDesc =>
      'Unlike Hepatitis B, Hepatitis C often becomes chronic, meaning the infection persists for years and can lead to liver damage, cirrhosis, liver cancer, and even liver failure. Many people with Hepatitis C don\'t show symptoms until liver damage is severe.';

  @override
  String get hepatitisCTreatmentDesc =>
      'Treatment has evolved significantly, with direct-acting antivirals (DAAs) offering a high cure rate, making chronic Hepatitis C much more manageable now than in the past.';

  @override
  String get hepatitisSection3Title => 'Diagnosis of Hepatitis';

  @override
  String get hepatitisSection3Desc =>
      'The diagnosis of hepatitis involves a combination of blood tests, imaging, and sometimes liver biopsy to determine the cause, severity, and appropriate treatment of the disease. Each type of hepatitis has its own set of diagnostic markers, so identifying the specific cause is essential for effective management.';

  @override
  String get hepatitisSection4Title => 'Complication of Hepatitis';

  @override
  String get hepatitisSection4Intro =>
      'Complications of hepatitis can vary depending on the type (A, B, C, etc.), the severity of the infection, and whether it becomes chronic. Some common and serious complications include:';

  @override
  String get hepatitisComp1Title => 'Chronic Hepatitis';

  @override
  String get hepatitisComp1Desc =>
      'Chronic Hepatitis B and C: If untreated, viral hepatitis can progress to chronic infection, where the virus remains in the body for years, leading to ongoing liver inflammation.';

  @override
  String get hepatitisComp2Title => 'Cirrhosis';

  @override
  String get hepatitisComp2Desc =>
      'Liver Scarring: Long-term inflammation can cause cirrhosis, a condition where the liver tissue becomes scarred, impairing liver function. This can result from chronic Hepatitis B, C, or alcohol use.';

  @override
  String get hepatitisComp3Title => 'Liver Failure';

  @override
  String get hepatitisComp3Desc =>
      'Acute or Chronic Liver Failure: Severe liver damage can lead to liver failure, where the liver loses its ability to perform vital functions such as detoxification and protein production. It can occur acutely (e.g., in acute Hepatitis B or D) or chronically in cases of Hepatitis C.';

  @override
  String get hepatitisComp4Title => 'Liver Cancer (Hepatocellular Carcinoma)';

  @override
  String get hepatitisComp4Desc =>
      'Chronic Hepatitis B and C increase the risk of developing liver cancer over time due to ongoing liver cell damage and mutations.';

  @override
  String get hepatitisSection4Conclusion =>
      'Early diagnosis and management of hepatitis, particularly chronic forms, are key to preventing or managing these complications.';

  @override
  String get hepatitisSection5Title => 'Management and treatment of Hepatitis';

  @override
  String get hepatitisSection5Desc =>
      'The treatment of hepatitis varies based on its type and severity. While many forms (especially Hepatitis A and E) resolve on their own with supportive care, others (like Hepatitis B, C, and chronic conditions) require long-term management with antiviral drugs, lifestyle changes, or immunosuppressive therapies. Early diagnosis and appropriate treatment are key to preventing liver damage and complications such as cirrhosis and liver cancer.';

  @override
  String get hepatitisSection6Title => 'Prevention Of Hepatitis';

  @override
  String get hepatitisSection6Subtitle =>
      'General Preventive Measures for All Types of Hepatitis';

  @override
  String get hepatitisPreventionMeasure1 =>
      'Good Hygiene Practices: Wash hands thoroughly with soap and water after using the bathroom, handling food, and before eating.';

  @override
  String get hepatitisPreventionMeasure2 =>
      'Avoid alcohol and drugs: Excessive alcohol use and drug abuse can exacerbate liver damage.';

  @override
  String get hepatitisPreventionMeasure3 =>
      'Vaccination: Vaccines against Hepatitis A and Hepatitis B are safe, highly effective, and available.';

  @override
  String get hepatitisPreventionMeasure4 =>
      'Safe needles & blood screening: Always use sterile single-use needles and ensure medical blood products are rigorously screened.';

  @override
  String get substanceHeroDesc =>
      'Substance abuse is the harmful use of drugs or alcohol that affects health, behavior, and relationships, leading to physical and mental problems, dependency, and serious life consequences if not addressed early.';

  @override
  String get substanceNoteContent =>
      'Substance abuse is preventable and treatable—recognizing early signs and seeking help can protect your health, relationships, and future.';

  @override
  String get substanceDefTitle => 'Definition of substance abuse';

  @override
  String get substanceDefDesc1 =>
      'Substance abuse refers to the harmful or hazardous use of psychoactive substances, including alcohol and illicit drugs, characterized by a compulsive pattern of consumption. This behavior often leads to significant adverse consequences in various aspects of an individual\'s life, such as health, relationships, and social responsibilities. It can result in physical and psychological dependence, tolerance, and withdrawal symptoms.';

  @override
  String get substanceDefDesc2 =>
      'Psychoactive substance is a drug or other substance that affects how the brain works and causes changes in mood, awareness, thoughts, feelings, or behavior. The commonly used psychoactive substances include alcohol, caffeine, nicotine, marijuana, and certain pain medicines.';

  @override
  String get substanceDefDesc3 =>
      'Substance use disorder (SUD) is a mental disorder that affects a person\'s brain and behavior, leading to a person\'s inability to control their use of substances such as legal or illegal drugs, alcohol, or medications. A substance use disorder involves using too much alcohol, tobacco or other drugs.';

  @override
  String get substanceTypesTitle => 'Types of drugs/Substances';

  @override
  String get substanceTypeDepressants =>
      'Depressants: - the most commonly found types of drugs in society are depressants. Alcohol, Sedatives/hypnotics.';

  @override
  String get substanceTypeStimulants =>
      'Stimulants: - Increase energy, alertness, and wakefulness. Such as Nicotine, Cocaine, Amphetamines and Caffeine.';

  @override
  String get substanceTypeOpioids =>
      'Opioids: - These are pain-killing drugs that increase feelings of happiness or euphoria and create a tranquilizing effect. Heroin, morphine, opium, buprenorphine, methadone, pethidine and Cough syrup with codeine.';

  @override
  String get substanceTypeHallucinogens =>
      'Hallucinogens: - They can also cause a person to perceive time differently, feel detached from their surroundings, or feel deeply insightful.';

  @override
  String get substanceEffectsTitle => 'Effects of substance abuse';

  @override
  String get substanceEffectsIntro =>
      'Substance abuse refers to a pattern of using drugs or alcohol that leads to significant problems or distress in an individual\'s life. This can manifest in various ways, including:';

  @override
  String get substanceEffect1 =>
      'Increased risk of disease (Liver diseases, heart diseases, respiratory problems, HIV)';

  @override
  String get substanceEffect2 =>
      'Mental health disorder increased risk of anxiety, depression etc.';

  @override
  String get substanceEffect3 => 'Missing work or school due to substance use.';

  @override
  String get substanceEffect4 =>
      'Engaging in dangerous activities while under the influence, such as driving.';

  @override
  String get substanceEffect5 =>
      'Experiencing legal issues related to substance use.';

  @override
  String get substanceEffect6 =>
      'Strained relationships with family and friends due to ongoing substance use.';

  @override
  String get substanceEffect7 =>
      'Substance abuse can involve both illegal drugs (like heroin, cocaine, and methamphetamine) and the misuse of prescription drugs or legal substances.';

  @override
  String get substanceSignsTitle => 'Signs of a Substance Use Problem';

  @override
  String get substanceSignsIntro =>
      'Recognizing early behavioral and physical indicators helps individuals get timely care before severe complications arise:';

  @override
  String get substanceSign1 =>
      'Compulsive cravings: Intense urges to consume the substance daily or multiple times a day.';

  @override
  String get substanceSign2 =>
      'Developing tolerance: Needing larger amounts over time to produce the initial desired effect.';

  @override
  String get substanceSign3 =>
      'Withdrawal symptoms: Experiencing restlessness, tremors, sweating, anxiety, or nausea when attempting to stop.';

  @override
  String get substanceSign4 =>
      'Neglecting responsibilities: Falling behind in school performance, missing work shifts, or ignoring family duties.';

  @override
  String get substanceSign5 =>
      'Abandoning interests: Giving up sports, creative hobbies, and social activities once enjoyed.';

  @override
  String get substanceSign6 =>
      'Social withdrawal and secretive behavior: Withdrawing from family gatherings, hiding substance use, or drastic personality shifts.';

  @override
  String get substanceSignsHelpAlert =>
      'Substance use disorder is a treatable health condition, not a sign of moral weakness. Youth mentors, counseling facilities, and national toll-free hotlines (952 or 8335) provide confidential, compassionate assistance.';

  @override
  String get substanceQuizTitle => 'Substance Abuse Quiz';

  @override
  String get substanceQ1Text =>
      'Is substance use disorder (SUD) a treatable medical condition affecting the brain and behavior, rather than a failure of willpower or personal morality?';

  @override
  String get substanceQ1Insight =>
      'Substance use disorders alter brain chemistry and neural reward pathways. Recognized by medical authorities worldwide, recovery is achievable through evidence-based treatment, counseling, and social support.';

  @override
  String get substanceQ2Text =>
      'Which category of substances slows down central nervous system function, heart rate, and brain activity (such as alcohol and sedatives)?';

  @override
  String get substanceQ2OptA => 'Depressants';

  @override
  String get substanceQ2OptB => 'Stimulants';

  @override
  String get substanceQ2OptC => 'Hallucinogens';

  @override
  String get substanceQ2OptD => 'Vitamins';

  @override
  String get substanceQ2Insight =>
      'Depressants slow down neural messaging and heart rate, leading to reduced alertness and relaxation. In contrast, stimulants speed up the nervous system.';

  @override
  String get substanceQ3Text =>
      'What does developing \"tolerance\" mean when someone regularly consumes drugs or alcohol?';

  @override
  String get substanceQ3OptA =>
      'The body needs increasingly larger amounts over time to produce the initial desired effect';

  @override
  String get substanceQ3OptB =>
      'The substance permanently leaves the body after a single use';

  @override
  String get substanceQ3OptC =>
      'The person can immediately stop taking the substance with zero symptoms';

  @override
  String get substanceQ3OptD =>
      'Having a complete natural immunity to all chemicals';

  @override
  String get substanceQ3Insight =>
      'Tolerance occurs when cells and brain receptors adapt to regular substance exposure, leading people to consume higher doses to feel the original impact.';

  @override
  String get substanceQ4Text =>
      'Substance abuse is both preventable and treatable, and free national health hotlines (952 or 8335) provide confidential, judgment-free support?';

  @override
  String get substanceQ4Insight =>
      'Early intervention saves lives. Confidential health hotlines (952 or 8335) connect youth with empathetic professionals, referrals to youth-friendly centers, and recovery guidance.';

  @override
  String get mentalHealthHeroDesc =>
      'Mental health is an essential part of overall health, encompassing emotional, psychological, and social wellbeing. It influences how we think, feel, manage stress, connect with others, and make decisions throughout life.';

  @override
  String get mentalHealthNoteContent =>
      'Mental health exists on a continuum and can be nurtured and healed—seeking support during tough times is a sign of courage and strength, not weakness.';

  @override
  String get mentalHealthSection1Title =>
      'Understanding Mental Health & Wellbeing';

  @override
  String get mentalHealthSection1Desc1 =>
      'Mental health includes our emotional, psychological, and social wellbeing. It affects how we handle daily challenges, relate to friends and family, and make healthy lifestyle choices.';

  @override
  String get mentalHealthSection1Desc2 =>
      'Good mental health does not mean feeling happy every moment. It means having the emotional resilience to navigate sadness, anger, stress, and joy in balanced, constructive ways.';

  @override
  String get mentalHealthSection1Alert =>
      'Mental health is just as important as physical health. The mind and body are deeply interconnected: prolonged physical illness impacts emotional health, and chronic stress directly triggers physical ailments.';

  @override
  String get mentalHealthSection2Title => 'Common Challenges in Youth';

  @override
  String get mentalHealthSection2Intro =>
      'Young people experience intense transitions, biological changes, and social pressures. Common challenges include:';

  @override
  String get mentalHealthChallenge1 =>
      'Academic stress and burnout: Overwhelming anxiety about school grades, examinations, and future expectations.';

  @override
  String get mentalHealthChallenge2 =>
      'General and social anxiety: Persistent, excessive worry about social situations, fear of judgment, or constant nervousness.';

  @override
  String get mentalHealthChallenge3 =>
      'Depressive mood and sadness: Ongoing feelings of hopelessness, emptiness, loss of interest in favorite activities, and low energy.';

  @override
  String get mentalHealthChallenge4 =>
      'Peer pressure and cyberbullying: Pressure to conform to unhealthy behaviors, fear of missing out (FOMO), or online harassment.';

  @override
  String get mentalHealthSection3Title =>
      'Positive Coping & Self-Care Strategies';

  @override
  String get mentalHealthSection3Intro =>
      'Building daily mental wellness practices helps protect against stress and strengthens emotional resilience:';

  @override
  String get mentalHealthStrategy1 =>
      'Daily physical movement: 30 minutes of walking, jogging, dancing, or sports naturally releases endorphins that boost mood and reduce tension.';

  @override
  String get mentalHealthStrategy2 =>
      'Restful sleep hygiene: Consistent 7–9 hours of sleep per night stabilizes mood, memory, and cognitive focus.';

  @override
  String get mentalHealthStrategy3 =>
      'Mindful breathing and relaxation: Deep belly breathing, quiet reflection, and grounding exercises calm the nervous system when overwhelmed.';

  @override
  String get mentalHealthStrategy4 =>
      'Expressive outlets: Journaling feelings, creating art, music, or prayer and meditation provide safe emotional release.';

  @override
  String get mentalHealthStrategy5 =>
      'Healthy boundaries: Learning to say \'no\' to overwhelming requests and limiting excessive, draining social media use.';

  @override
  String get mentalHealthSection4Title =>
      'Recognizing Warning Signs & Seeking Support';

  @override
  String get mentalHealthSection4Intro =>
      'It is important to recognize when stress or sadness has crossed into a health challenge that needs outside support:';

  @override
  String get mentalHealthSign1 =>
      'Prolonged withdrawal: Isolating completely from friends, family, and social activities for weeks.';

  @override
  String get mentalHealthSign2 =>
      'Extreme mood shifts: Sudden, drastic fluctuations in personality, explosive anger, or extreme hopelessness.';

  @override
  String get mentalHealthSign3 =>
      'Changes in sleeping or eating: Severe insomnia, sleeping all day, or major appetite and weight changes.';

  @override
  String get mentalHealthSign4 =>
      'Turning to substances: Relying on alcohol, khat, or drugs to escape difficult feelings.';

  @override
  String get mentalHealthSign5 =>
      'Thoughts of self-harm: Persistent thoughts of wanting to disappear, hurting oneself, or despair.';

  @override
  String get mentalHealthHelpAlert =>
      'You never have to carry emotional pain alone. Talking to a verified peer counselor, school counselor, or calling toll-free national health lines (952 or 8335) connects you with compassionate, 100% confidential support.';

  @override
  String get mentalHealthQuizTitle => 'Mental Health & Wellbeing Quiz';

  @override
  String get mentalHealthQ1Text =>
      'Mental health is just as important as physical health, and experiencing emotional struggles is a medical condition, not a sign of personal weakness?';

  @override
  String get mentalHealthQ1Insight =>
      'Mental health is a fundamental component of total health. Seeking support for emotional distress is a responsible, courageous step toward wellbeing.';

  @override
  String get mentalHealthQ2Text =>
      'Which of the following is a healthy, effective way to manage everyday stress and emotional overwhelm?';

  @override
  String get mentalHealthQ2OptA =>
      'Regular physical exercise, mindful breathing, and getting 7–9 hours of sleep';

  @override
  String get mentalHealthQ2OptB =>
      'Isolating yourself in your room and avoiding talking to anyone';

  @override
  String get mentalHealthQ2OptC =>
      'Using alcohol or drugs to numb difficult emotions';

  @override
  String get mentalHealthQ2OptD => 'Skipping meals and staying awake all night';

  @override
  String get mentalHealthQ2Insight =>
      'Physical activity releases mood-lifting endorphins, while adequate sleep and deep breathing reset the autonomic nervous system.';

  @override
  String get mentalHealthQ3Text =>
      'Does good mental health mean you should feel happy and positive every single moment of your life?';

  @override
  String get mentalHealthQ3Insight =>
      'Good mental health involves experiencing the full range of human emotions (including sadness, frustration, and grief) and having healthy tools to process them.';

  @override
  String get mentalHealthQ4Text =>
      'If you or a friend are feeling overwhelmed by sadness or anxiety for several weeks, what is the best course of action?';

  @override
  String get mentalHealthQ4OptA =>
      'Reach out to a trusted counselor, youth mentor, or call toll-free hotlines 952 / 8335';

  @override
  String get mentalHealthQ4OptB =>
      'Keep it completely secret and hope it goes away on its own';

  @override
  String get mentalHealthQ4OptC => 'Criticize the friend for feeling sad';

  @override
  String get mentalHealthQ4OptD => 'Ignore school and stop eating';

  @override
  String get mentalHealthQ4Insight =>
      'Early conversations with peer mentors, counselors, or calling national hotlines (952 or 8335) provide confidential, life-saving support.';

  @override
  String get gbvHeroDesc =>
      'Gender-based violence is harmful behavior directed at individuals based on gender, caused by inequality and cultural norms, leading to serious physical, psychological, social, and economic consequences, but it can be addressed through prevention, support services, and legal protection.';

  @override
  String get gbvNoteContent =>
      'GBV is preventable—promoting respect, equality, and early support for survivors helps build safer communities and protects human dignity.';

  @override
  String get gbvSection1Title => 'Definition';

  @override
  String get gbvSection1Desc1 =>
      'Gender-based violence (GBV) refers to harmful acts directed at an individual based on their gender. It can occur in any context, but it most often affects women and girls, though men and boys can also experience it. GBV is a violation of human rights and a major barrier to achieving gender equality and social justice.';

  @override
  String get gbvSection1Desc2 =>
      'In humanitarian settings, responding to sexual violence has been a priority because conflict-related violence, in particular rape as a tactic of war, has received international attention. However, there is growing recognition that populations affected by conflict and natural disaster experience various forms of GBV during crisis and displacement, and during and following return. In particular, intimate partner violence is increasingly recognized as a critical concern in humanitarian settings. Gender based violence can manifest in various forms, including:';

  @override
  String get gbvForm1Title => 'Physical Violence';

  @override
  String get gbvForm1Item1Title =>
      'Domestic violence (intimate partner violence):';

  @override
  String get gbvForm1Item1Body =>
      'Includes hitting, slapping, kicking, and other forms of physical abuse within intimate relationships.';

  @override
  String get gbvForm1Item2Title => 'Sexual violence:';

  @override
  String get gbvForm1Item2Body =>
      'Forced or coerced sexual acts, including rape, sexual assault, and harassment.';

  @override
  String get gbvForm2Title => 'Psychological/Emotional Violence';

  @override
  String get gbvForm2Item1Title => 'Verbal abuse:';

  @override
  String get gbvForm2Item1Body =>
      'Insults, threats, humiliation, and controlling behaviors that undermine the victim\'s sense of self-worth.';

  @override
  String get gbvForm2Item2Title => 'Isolation:';

  @override
  String get gbvForm2Item2Body =>
      'Forcing a victim to cut ties with family and friends.';

  @override
  String get gbvForm2Item3Title => 'Coercive control:';

  @override
  String get gbvForm2Item3Body =>
      'A pattern of controlling behavior that limits a person’s freedom, such as dictating what they wear, where they go, or who they interact with.';

  @override
  String get gbvForm3Title => 'Sexual Violence and Exploitation';

  @override
  String get gbvForm3Item1Title => 'Rape:';

  @override
  String get gbvForm3Item1Body => 'Non-consensual sexual intercourse.';

  @override
  String get gbvForm3Item2Title => 'Sexual harassment:';

  @override
  String get gbvForm3Item2Body =>
      'Unwanted sexual advances or behavior, often in the workplace, school, or public spaces.';

  @override
  String get gbvForm3Item3Title => 'Trafficking:';

  @override
  String get gbvForm3Item3Body =>
      'The illegal trade of people for sexual exploitation or forced labor.';

  @override
  String get gbvForm4Title => 'Economic Violence';

  @override
  String get gbvForm4Item1Title => 'Withholding financial resources:';

  @override
  String get gbvForm4Item1Body =>
      'Preventing a partner from accessing money or resources, controlling their economic independence.';

  @override
  String get gbvForm4Item2Title => 'Coercion through financial dependence:';

  @override
  String get gbvForm4Item2Body =>
      'Using financial control as a way to maintain power over someone.';

  @override
  String get gbvForm5Title => 'Harmful Traditional Practices';

  @override
  String get gbvForm5Item1Title => 'Female genital mutilation/cutting (FGM/C):';

  @override
  String get gbvForm5Item1Body =>
      'The practice of partially or completely removing the female genitalia for non-medical reasons, often as a means of controlling women\'s sexuality.';

  @override
  String get gbvForm5Item2Title => 'Early or forced marriage:';

  @override
  String get gbvForm5Item2Body =>
      'Marrying off young girls or individuals without their consent, often as a result of cultural practices.';

  @override
  String get gbvForm5Item3Title => 'Honor killings:';

  @override
  String get gbvForm5Item3Body =>
      'The killing of a family member, typically a woman or girl, for bringing perceived dishonor or shame upon the family or community.';

  @override
  String get gbvSection2Title => 'Sex and Gender';

  @override
  String get gbvSection2Desc1 =>
      'Understanding the distinction between sex and gender is essential for addressing gender-based violence. Sex refers to biological and physiological characteristics, such as chromosomes, hormones, and reproductive organs. Gender refers to the socially constructed roles, behaviors, expressions, and identities that society considers appropriate for men, women, and gender-diverse individuals.';

  @override
  String get gbvSection2Desc2 =>
      'Gender norms dictate how individuals are expected to act, speak, dress, and interact based on their assigned sex. When rigid patriarchal expectations grant unequal power, authority, or entitlement to one group over another, it creates a systemic imbalance that justifies or normalizes violence and discrimination.';

  @override
  String get gbvSection3Title => 'Consequences of gender-based violence';

  @override
  String get gbvConsequenceBullet1 =>
      'Physical, injury, disability, chronic health problem, sexual and reproductive health problems, death';

  @override
  String get gbvConsequenceBullet2 =>
      'Psychological, anxiety, fear, loneliness depression, alcohol or drug use suicide';

  @override
  String get gbvConsequenceBullet3 =>
      'Economic and social impact, reduced ability to participate in social and economic activities, social stigma at community level, negative impact on women income generating power, increased vulnerability to other types of gender-based violence';

  @override
  String get gbvConsequenceBullet4 =>
      'The impact on women family and dependents, divorce, or broken families, jeopardize family\'s economic and emotional development, emotional and behavioral disturbances';

  @override
  String get gbvConsequenceBullet5 =>
      'Emotional Consequences, Depression stress, low self esteem';

  @override
  String get gbvTableTitle => 'Consequences of GBV';

  @override
  String get gbvTableColPhysical => 'Physical health consequences';

  @override
  String get gbvTableColPsychological => 'Psychological health consequences';

  @override
  String get gbvTableColSocial => 'Social & Economic consequences';

  @override
  String get gbvTablePhys1 => 'Physical injury';

  @override
  String get gbvTablePhys2 => 'HIV/AIDS';

  @override
  String get gbvTablePhys3 => 'STIs';

  @override
  String get gbvTablePhys4 => 'Unwanted pregnancy';

  @override
  String get gbvTablePhys5 => 'Unsafe abortion';

  @override
  String get gbvTablePhys6 => 'Fistula';

  @override
  String get gbvTablePhys7 => 'Death';

  @override
  String get gbvTablePsych1 => 'Depression';

  @override
  String get gbvTablePsych2 => 'Fear';

  @override
  String get gbvTablePsych3 => 'Self-blame';

  @override
  String get gbvTablePsych4 => 'Anxiety';

  @override
  String get gbvTablePsych5 => 'Mental illness';

  @override
  String get gbvTablePsych6 => 'Suicidal thoughts/actions';

  @override
  String get gbvTableSoc1 => 'Victim-blaming';

  @override
  String get gbvTableSoc2 => 'Stigmatisation';

  @override
  String get gbvTableSoc3 => 'Rejection';

  @override
  String get gbvTableSoc4 => 'Isolation';

  @override
  String get gbvTableSoc5 => 'Decreased earning capacity/contribution';

  @override
  String get gbvTableSoc6 => 'Increased poverty';

  @override
  String get gbvTableSoc7 => 'Risk of re-victimization';

  @override
  String get gbvSection4Title =>
      'Management and Prevention of Gender-Based Violence (GBV)';

  @override
  String get gbvSec4Main1Title => 'Immediate Response: Management of GBV';

  @override
  String get gbvSec4Main1Intro =>
      'When GBV occurs, immediate intervention is necessary to support survivors and address the situation.';

  @override
  String get gbvSec4SubATitle => 'Providing Safety and Protection';

  @override
  String get gbvSec4SubA1Title => 'Safe spaces:';

  @override
  String get gbvSec4SubA1Body =>
      'Shelters and crisis centers provide immediate refuge for survivors.';

  @override
  String get gbvSec4SubA2Title => 'Hotlines and crisis counseling:';

  @override
  String get gbvSec4SubA2Body =>
      'support services to offer guidance, emotional support, and legal advice.';

  @override
  String get gbvSec4SubA3Title => 'Protection orders:';

  @override
  String get gbvSec4SubA3Body =>
      'Legal measures to prevent abusers from contacting or approaching survivors. In some cases, law enforcement involvement may be necessary to ensure the safety of survivors and hold perpetrators accountable.';

  @override
  String get gbvSec4SubA4Title => 'Medical care:';

  @override
  String get gbvSec4SubA4Body =>
      'Ensuring that survivors receive prompt medical attention, including trauma care and sexual health services.';

  @override
  String get gbvSec4SubBTitle => 'Comprehensive Support Services';

  @override
  String get gbvSec4SubB1Title => 'Psychosocial support:';

  @override
  String get gbvSec4SubB1Body =>
      'Counseling and therapy to help survivors heal from trauma.';

  @override
  String get gbvSec4SubB2Title => 'Legal aid:';

  @override
  String get gbvSec4SubB2Body =>
      'Support to navigate the legal system, file reports, and pursue justice.';

  @override
  String get gbvSec4SubB3Title => 'Economic support:';

  @override
  String get gbvSec4SubB3Body =>
      'Assistance in rebuilding financial independence, including job training, micro-loans, or cash support.';

  @override
  String get gbvSec4Main2Title => 'Preventing GBV';

  @override
  String get gbvSec4Main2Intro =>
      'Prevention strategies focus on addressing the root causes of violence and working toward a society where GBV is not tolerated.';

  @override
  String get gbvSec4Sub2ATitle => 'Changing Social Norms and Attitudes';

  @override
  String get gbvSec4Sub2A1Title => 'Public awareness campaigns:';

  @override
  String get gbvSec4Sub2A1Body =>
      'Educating communities on the harmful effects of GBV, promoting gender equality, and challenging stereotypes.';

  @override
  String get gbvSec4Sub2A2Title => 'Media advocacy:';

  @override
  String get gbvSec4Sub2A2Body =>
      'Using films, social media, and other platforms to spread messages about healthy relationships and the importance of respect for all genders.';

  @override
  String get gbvSec4Sub2A3Title => 'School programs:';

  @override
  String get gbvSec4Sub2A3Body =>
      'Implementing educational curricula that promote respect, gender equality, and healthy relationships.';

  @override
  String get gbvSec4Sub2A4Title => 'Community dialogues:';

  @override
  String get gbvSec4Sub2A4Body =>
      'Facilitating conversations between different groups (e.g., community leaders, youth, men, and women) to address the cultural norms that perpetuate violence.';

  @override
  String get gbvSec4Sub2BTitle => 'Legal and Policy Reform';

  @override
  String get gbvSec4Sub2B1Title => 'Strengthening laws:';

  @override
  String get gbvSec4Sub2B1Body =>
      'Enacting and enforcing laws that specifically address GBV, such as domestic violence laws, sexual harassment regulations, and anti-human trafficking laws.';

  @override
  String get gbvSec4Sub2B2Title => 'Supporting survivors\' rights:';

  @override
  String get gbvSec4Sub2B2Body =>
      'Ensuring that survivors of GBV have access to justice and are not revictimized by legal or societal systems.';

  @override
  String get gbvSec4Sub2B3Title => 'Gender-sensitive law enforcement:';

  @override
  String get gbvSec4Sub2B3Body =>
      'Training police and other law enforcement officers on how to respond appropriately to GBV cases, including sensitivity to gender issues and survivor trauma.';

  @override
  String get gbvSec4Sub2CTitle => 'Empowering Women and Gender Minorities';

  @override
  String get gbvSec4Sub2C1Title => 'Economic empowerment:';

  @override
  String get gbvSec4Sub2C1Body =>
      'Providing women and marginalized genders with access to education, employment, and financial independence reduces their vulnerability to abuse.';

  @override
  String get gbvSec4Sub2C2Title => 'Leadership training:';

  @override
  String get gbvSec4Sub2C2Body =>
      'Encouraging the participation of women and gender minorities in leadership positions in politics, business, and social spheres to create role models and disrupt patriarchal structures.';

  @override
  String get gbvSec4Sub2C3Title => 'Men as allies:';

  @override
  String get gbvSec4Sub2C3Body =>
      'Engaging men and boys in GBV prevention efforts, emphasizing positive masculinity, healthy relationships, and shared responsibility in addressing violence.';

  @override
  String get gbvSec4Sub2DTitle => 'Community-based Approaches';

  @override
  String get gbvSec4Sub2D1Title => 'Community mobilization:';

  @override
  String get gbvSec4Sub2D1Body =>
      'Working with community leaders, religious figures, and local organizations to promote zero-tolerance for GBV and to create a supportive environment for survivors.';

  @override
  String get gbvSec4Sub2D2Title => 'Self-help groups and peer support:';

  @override
  String get gbvSec4Sub2D2Body =>
      'Creating spaces where survivors can support each other and share their experiences, empowering individuals to speak out and seek help.';

  @override
  String get gbvSec4Sub2ETitle => 'Education and Awareness';

  @override
  String get gbvSec4Sub2E1Title => 'School curricula:';

  @override
  String get gbvSec4Sub2E1Body =>
      'Educating young people about consent, respectful relationships, and healthy sexuality.';

  @override
  String get gbvSec4Sub2E2Title => 'Workplace training:';

  @override
  String get gbvSec4Sub2E2Body =>
      'Developing policies and training programs to prevent sexual harassment and abuse in the workplace, ensuring there are clear reporting channels.';

  @override
  String get gbvSec4Sub2E3Title => 'Public campaigns:';

  @override
  String get gbvSec4Sub2E3Body =>
      'Using media to raise awareness about GBV and challenge harmful norms related to gender and violence.';

  @override
  String get gbvSec4Main3Title =>
      'Long-Term Strategies: Changing Structural and Cultural Factors';

  @override
  String get gbvSec4Main3Intro =>
      'Long-term efforts are required to address the underlying social, cultural, and economic factors that sustain GBV.';

  @override
  String get gbvSec4Sub3ATitle => 'Addressing Gender Inequality';

  @override
  String get gbvSec4Sub3A1Title => 'Promote gender equality:';

  @override
  String get gbvSec4Sub3A1Body =>
      'Ensure equal rights for all genders in areas such as education, employment, healthcare, and political participation.';

  @override
  String get gbvSec4Sub3A2Title => 'Strengthen women\'s rights:';

  @override
  String get gbvSec4Sub3A2Body =>
      'Advocate for women\'s legal and social rights, including property rights, inheritance, and access to public services.';

  @override
  String get gbvSec4Sub3A3Title => 'End discriminatory practices:';

  @override
  String get gbvSec4Sub3A3Body =>
      'Combat harmful traditional practices like child marriage, dowry-related violence, and FGM, often rooted in patriarchal social structures.';

  @override
  String get gbvSec4Sub3BTitle => 'Engaging Men and Boys';

  @override
  String get gbvSec4Sub3B1Title => 'Positive masculinity:';

  @override
  String get gbvSec4Sub3B1Body =>
      'Promote a model of masculinity that is non-violent, respectful, and supportive of gender equality.';

  @override
  String get gbvSec4Sub3B2Title => 'Anti-violence programs:';

  @override
  String get gbvSec4Sub3B2Body =>
      'Educate boys and men about the harmful effects of violence and the importance of being allies in the fight against GBV.';

  @override
  String get gbvSection4HelpAlert =>
      'If you or someone you know is experiencing violence or abuse, you are not alone. Safe, confidential medical and legal support is available. Call the national toll-free emergency lines 952, 8335, or 7711 immediately.';

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
  String get hivPreventionIntro =>
      'Protecting yourself from HIV begins with understanding how the virus is spread. Some of HIV prevention methods are discussed as follows:';

  @override
  String get hivMethodA =>
      'Abstinence from sex (not having sex), before marriage';

  @override
  String get hivMethodB =>
      'Being faithful (Decide to one sexual partner) after testing.';

  @override
  String get hivMethodC =>
      'Consistent and correct use of condom every time you have sex.';

  @override
  String get hivMethodD =>
      'Not sharing sharp objects with other people and Proper use and removal of sharp objects.';

  @override
  String get hivAdditionalPreventionIntro =>
      'In addition to above mentioned prevention methods, the following are also used to prevent HIV.';

  @override
  String get hivMethodE =>
      'Provision of anti-HIV treatment for pregnant women living with HIV to avoid transmission to fetus.';

  @override
  String get hivMethodF =>
      'Pre-Exposure Prophylaxis- Given for people at high risk of acquiring HIV and it is given before exposure to HIV.';

  @override
  String get prepDesc =>
      'pre-exposure prophylaxis (PrEP) is HIV medicine taken to prevent the chances of getting HIV infection.. Since PrEP only protects against HIV, condom use is still important for the protection against other STI. It will be provided to people at substantial risk (high risk) of acquiring HIV. This service is available at public health facilities like Health center and Hospital.';

  @override
  String get watchOnYouTube => 'Watch on YouTube';

  @override
  String get cinemaMode => 'Cinema View';

  @override
  String get playInline => 'Play in App';

  @override
  String get closePlayer => 'Close Player';

  @override
  String get playingInApp => 'Playing in App';

  @override
  String get returnToLesson => 'Return to Lesson';

  @override
  String get hivQuizTitle => 'HIV Module Quiz';

  @override
  String get nextQuestionBtn => 'Next';

  @override
  String get finishQuizBtn => 'Finish Quiz';

  @override
  String get retakeQuizBtn => 'Retake Quiz';

  @override
  String get reviewAnswersBtn => 'Review Answers';

  @override
  String get quizScoreCelebration => 'Great Job!';

  @override
  String quizScoreSummary(int score, int total, int percent) {
    return 'You scored $score out of $total ($percent%)';
  }

  @override
  String get selectAnOptionHint => 'Please select an answer to continue';

  @override
  String get educationalInsight => 'Key Clinical Insight';

  @override
  String get trueOption => 'True';

  @override
  String get falseOption => 'False';

  @override
  String get hivQ1Text =>
      'HIV infects and destroys cells of human immune system, making it hard to fight other diseases?';

  @override
  String get hivQ1Insight =>
      'HIV targets CD4 white blood cells. Without ART treatment, the body loses its natural defenses against opportunistic infections.';

  @override
  String get hivQ2Text =>
      'Which of the following is/are correct about mode of HIV transmission?';

  @override
  String get hivQ2OptA => 'Unprotected sexual practice';

  @override
  String get hivQ2OptB => 'HIV positive mother to their fetus or child';

  @override
  String get hivQ2OptC => 'Eating together';

  @override
  String get hivQ2OptD => 'A & B';

  @override
  String get hivQ2Insight =>
      'HIV spreads through specific body fluids (unprotected sex and mother-to-child), but cannot be spread through casual contact like sharing food.';

  @override
  String get hivQ3Text =>
      'Can HIV be transmitted through mosquito or insect bites, hugging, or sharing toilet seats?';

  @override
  String get hivQ3Insight =>
      'HIV cannot survive outside human fluids or inside insects. Casual social contact is completely safe.';

  @override
  String get hivQ4Text =>
      'Within how many hours must Post-Exposure Prophylaxis (PEP) be started after possible exposure to HIV?';

  @override
  String get hivQ4OptA => 'Within 24 hours only';

  @override
  String get hivQ4OptB => 'Within 72 hours (3 days)';

  @override
  String get hivQ4OptC => 'Within 1 month';

  @override
  String get hivQ4OptD => 'PEP is only taken before exposure';

  @override
  String get hivQ4Insight =>
      'PEP is an emergency medication course that must begin strictly within 72 hours of potential exposure to prevent infection.';

  @override
  String get hivQ5Text =>
      'Which of the following lubricants are safe to use with latex condoms?';

  @override
  String get hivQ5OptA => 'Petroleum jelly (Vaseline) and baby oils';

  @override
  String get hivQ5OptB => 'Body lotions and butter';

  @override
  String get hivQ5OptC => 'Water-based or silicone-based lubricants only';

  @override
  String get hivQ5OptD => 'Household cooking oils';

  @override
  String get hivQ5Insight =>
      'Oil-based lubricants weaken and tear latex condoms in under a minute. Only water-based or silicone lubricants are safe.';

  @override
  String get hivQ6Text =>
      'When a person with HIV takes ART and reaches an undetectable viral load, they cannot transmit the virus sexually (Undetectable = Untransmittable / U=U).';

  @override
  String get hivQ6Insight =>
      'Decades of evidence confirm Undetectable = Untransmittable (U=U). Regular ART adherence keeps people healthy and prevents transmission.';

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

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get guestGreetingSubtitle =>
      'Your safe space for confidential youth health';

  @override
  String get guestUser => 'Guest Explorer';

  @override
  String get dailyTipBadge => 'Daily Insight';

  @override
  String get dailyTipMythFact => 'Myth vs Fact';

  @override
  String get dailyTipTitle => 'Hormonal changes during puberty';

  @override
  String get dailyTipBody =>
      'Acne and mood shifts are normal bodily adjustments during growth, not signs of poor hygiene.';

  @override
  String get readArticleAction => 'Explore Article';

  @override
  String get emergencyHelplineTitle => '24/7 Confidential Helplines';

  @override
  String get emergencyHelplineSubtitle =>
      'Toll-free: 952 (Health) / 8335 (Youth Line)';

  @override
  String get emergencyHelplineAction => 'Call / Help';

  @override
  String get emergencySheetTitle => 'Urgent Help & Support';

  @override
  String get emergencySheetDisclaimer =>
      'For immediate clinical emergencies or acute crisis, call toll-free numbers anytime.';

  @override
  String get emergencyHotline952Name => 'National Health Emergency Hotline';

  @override
  String get emergencyHotline952Desc =>
      'Ministry of Health 24/7 free hotline for acute health concerns';

  @override
  String get emergencyHotline8335Name => 'National Youth & Mental Health Line';

  @override
  String get emergencyHotline8335Desc =>
      'Confidential counseling for reproductive health and emotional distress';

  @override
  String get exploreServicesHeading => 'Explore Services';

  @override
  String get exploreServicesSubtitle =>
      'Private tools, peer support, and verified clinics';

  @override
  String get callNowAction => 'Call Now';

  @override
  String get pubertyHeroDesc =>
      'Puberty is a natural transition from childhood into adulthood, characterized by physical, hormonal, and emotional changes that shape personal growth and health.';

  @override
  String get pubertyNoteText =>
      'Every adolescent experiences puberty at their own unique pace—practicing good hygiene, understanding bodily changes, and embracing self-confidence helps ensure a healthy transition.';

  @override
  String get pubertySection1Title => 'Understanding Puberty & Adolescence';

  @override
  String get pubertySection1Subtitle => 'The Natural Transition to Adulthood';

  @override
  String get pubertySection1Intro =>
      'Puberty is the developmental stage where the body undergoes rapid hormonal and biological changes, enabling physical maturity and reproductive capability.';

  @override
  String get pubertySection1Item1 =>
      'Hormonal triggers: The pituitary gland releases hormones that signal the body to grow and develop secondary sexual characteristics.';

  @override
  String get pubertySection1Item2 =>
      'Individual timing: Puberty typically begins between ages 9 and 14, varying naturally among individuals.';

  @override
  String get pubertySection1Item3 =>
      'Normal variation: Growing at different rates than peers is completely normal and healthy.';

  @override
  String get pubertySection2Title => 'Physical Changes in Females & Males';

  @override
  String get pubertySection2Subtitle => 'Key Physical Milestones';

  @override
  String get pubertySection2FemaleTitle => 'Changes in Females:';

  @override
  String get pubertySection2FemaleItem1 =>
      'Breast development and widening of hips';

  @override
  String get pubertySection2FemaleItem2 =>
      'Growth of body hair (underarms and pubic area)';

  @override
  String get pubertySection2FemaleItem3 =>
      'Onset of menstruation (menarche), the monthly cycle preparing the uterus for potential pregnancy';

  @override
  String get pubertySection2MaleTitle => 'Changes in Males:';

  @override
  String get pubertySection2MaleItem1 =>
      'Deepening of the voice (voice cracks and lower pitch)';

  @override
  String get pubertySection2MaleItem2 =>
      'Growth of facial, underarm, chest, and pubic hair';

  @override
  String get pubertySection2MaleItem3 =>
      'Growth of testicles and penis, along with nocturnal emissions (\'wet dreams\'), a normal involuntary release of semen during sleep';

  @override
  String get pubertySection3Title => 'Emotional & Psychological Changes';

  @override
  String get pubertySection3Subtitle => 'Navigating Thoughts and Emotions';

  @override
  String get pubertySection3Intro =>
      'Alongside physical transformations, teenagers experience significant cognitive and emotional growth.';

  @override
  String get pubertySection3Item1 =>
      'Mood shifts: Fluctuating hormones combined with social adjustments can cause temporary mood swings.';

  @override
  String get pubertySection3Item2 =>
      'Identity search: Developing self-awareness, exploring personal values, and discovering individuality.';

  @override
  String get pubertySection3Item3 =>
      'Desire for independence: Transitioning toward greater personal autonomy and decision-making.';

  @override
  String get pubertySection3Item4 =>
      'Peer influence: Friendships and social groups become central to emotional support and communication.';

  @override
  String get pubertySection4Title => 'Hygiene & Self-Care during Adolescence';

  @override
  String get pubertySection4Subtitle => 'Daily Habits for Lifelong Health';

  @override
  String get pubertySection4Item1 =>
      'Bathing and deodorants: Sweat glands become more active; daily washing with clean water and mild soap prevents body odor.';

  @override
  String get pubertySection4Item2 =>
      'Skin and face care: Increased oil production can cause acne; wash the face twice daily and avoid squeezing pimples.';

  @override
  String get pubertySection4Item3 =>
      'Menstrual hygiene: Change sanitary pads or clean supplies every 4–6 hours, wash hands before and after, and dispose of materials safely.';

  @override
  String get pubertySection4Item4 =>
      'Nutrition and sleep: Growing bodies require 8–10 hours of restful sleep each night and a balanced diet rich in vitamins and iron.';

  @override
  String get pubertyQuizTitle => 'Adolescent Health & Puberty Quiz';

  @override
  String get pubertyQ1Text =>
      'Puberty is a natural biological transition where each person grows and develops at their own unique, normal pace.';

  @override
  String get pubertyQ1Insight =>
      'Puberty begins at different times for everyone, usually between ages 9 and 14. Variance in timing and growth rate is completely normal.';

  @override
  String get pubertyQ2Text =>
      'What is a normal and healthy physical change that occurs during male puberty?';

  @override
  String get pubertyQ2OptA =>
      'Deepening of the voice and growth of facial/body hair';

  @override
  String get pubertyQ2OptB => 'Sudden complete loss of appetite';

  @override
  String get pubertyQ2OptC => 'Permanent loss of sleep';

  @override
  String get pubertyQ2OptD => 'Inability to run or exercise';

  @override
  String get pubertyQ2Insight =>
      'Voice deepening, growth spurts, and hair development are classic signs of testosterone production and healthy male pubertal development.';

  @override
  String get pubertyQ3Text =>
      'What is the recommended hygiene practice during menstruation?';

  @override
  String get pubertyQ3OptA =>
      'Change sanitary products regularly (every 4–6 hours) and wash hands';

  @override
  String get pubertyQ3OptB => 'Avoid bathing until the cycle ends';

  @override
  String get pubertyQ3OptC => 'Use unwashed cloths repeatedly without drying';

  @override
  String get pubertyQ3OptD => 'Avoid drinking water throughout the cycle';

  @override
  String get pubertyQ3Insight =>
      'Regularly changing sanitary supplies every 4 to 6 hours and practicing good hand hygiene prevents irritation and bacterial infections.';

  @override
  String get pubertyQ4Text =>
      'Emotional changes and mood shifts during adolescence are common and can be managed through open communication, exercise, and adequate sleep.';

  @override
  String get pubertyQ4Insight =>
      'Hormonal shifts and expanding social worlds make emotional fluctuations normal. Talking to trusted friends or family helps navigate these feelings.';

  @override
  String get stiQuizTitle => 'Sexually Transmitted Infections Quiz';

  @override
  String get stiQ1Text =>
      'Many sexually transmitted infections (STIs) may show no noticeable symptoms at first, which is why regular screening and testing are essential.';

  @override
  String get stiQ1Insight =>
      'Asymptomatic infections are common with STIs like chlamydia and gonorrhea. Regular testing allows prompt treatment before complications occur.';

  @override
  String get stiQ2Text =>
      'Which of the following is an effective method for reducing the risk of transmitting most STIs during sexual activity?';

  @override
  String get stiQ2OptA =>
      'Consistent and correct use of male or female condoms';

  @override
  String get stiQ2OptB => 'Taking vitamins immediately before contact';

  @override
  String get stiQ2OptC => 'Washing with hot water after intercourse only';

  @override
  String get stiQ2OptD => 'Relying on herbal teas';

  @override
  String get stiQ2Insight =>
      'Condoms provide a physical barrier that drastically lowers the risk of STI transmission when used correctly every time.';

  @override
  String get stiQ3Text =>
      'If you test positive for a bacterial STI and start antibiotics, what is the most important instruction to follow?';

  @override
  String get stiQ3OptA =>
      'Complete the entire course of medication as prescribed by the healthcare worker';

  @override
  String get stiQ3OptB => 'Stop medication the moment pain disappears';

  @override
  String get stiQ3OptC => 'Share the remaining pills with friends';

  @override
  String get stiQ3OptD => 'Double the dose on the final day';

  @override
  String get stiQ3Insight =>
      'Stopping antibiotics early can lead to bacterial resistance and reinfection. Always complete the entire prescribed treatment course.';

  @override
  String get stiQ4Text =>
      'When someone is diagnosed and treated for an STI, it is vital that sexual partners are also notified and treated to prevent reinfection.';

  @override
  String get stiQ4Insight =>
      'Treating partners simultaneously breaks the cycle of transmission and protects both individuals from repeated health complications.';

  @override
  String get hepatitisQuizTitle => 'Hepatitis Module Quiz';

  @override
  String get hepatitisQ1Text =>
      'Hepatitis primarily affects which vital organ in the human body?';

  @override
  String get hepatitisQ1OptA => 'Liver';

  @override
  String get hepatitisQ1OptB => 'Lungs';

  @override
  String get hepatitisQ1OptC => 'Heart';

  @override
  String get hepatitisQ1OptD => 'Kidneys';

  @override
  String get hepatitisQ1Insight =>
      'Hepatitis is an inflammation of the liver, which performs vital roles like filtering toxins, aiding digestion, and storing energy.';

  @override
  String get hepatitisQ2Text =>
      'Hepatitis A and Hepatitis E are primarily spread through contaminated food and water, making clean water and hand hygiene key defenses.';

  @override
  String get hepatitisQ2Insight =>
      'Hepatitis A and E spread via the fecal-oral route. Thorough handwashing and safe drinking water effectively stop transmission.';

  @override
  String get hepatitisQ3Text =>
      'Which safe and effective preventive measure protects against Hepatitis B infection?';

  @override
  String get hepatitisQ3OptA => 'Hepatitis B vaccination and screening';

  @override
  String get hepatitisQ3OptB => 'Drinking caffeinated beverages';

  @override
  String get hepatitisQ3OptC => 'Avoiding regular exercise';

  @override
  String get hepatitisQ3OptD => 'Taking painkillers daily';

  @override
  String get hepatitisQ3Insight =>
      'The Hepatitis B vaccine provides long-lasting immunity. Avoiding needle-sharing and safe sexual practices also prevent transmission.';

  @override
  String get hepatitisQ4Text =>
      'Modern direct-acting antiviral (DAA) medications can successfully cure more than 95% of chronic Hepatitis C infections.';

  @override
  String get hepatitisQ4Insight =>
      'Advances in medicine have made chronic Hepatitis C a curable condition with an oral medication course lasting 8 to 12 weeks.';

  @override
  String get gbvQuizTitle => 'Gender-Based Violence Quiz';

  @override
  String get gbvQ1Text =>
      'Gender-based violence (GBV) includes physical, sexual, psychological, and economic harm directed at an individual based on their gender.';

  @override
  String get gbvQ1Insight =>
      'GBV encompasses all forms of coercive control, emotional abuse, physical harm, and economic deprivation rooted in unequal gender norms.';

  @override
  String get gbvQ2Text =>
      'What is a vital immediate step when supporting a survivor who has experienced sexual violence?';

  @override
  String get gbvQ2OptA =>
      'Ensure their safety and seek confidential medical care (including PEP within 72 hours)';

  @override
  String get gbvQ2OptB => 'Blame them for being in the situation';

  @override
  String get gbvQ2OptC => 'Disclose their private story to neighborhood groups';

  @override
  String get gbvQ2OptD => 'Ignore their feelings and tell them to stay silent';

  @override
  String get gbvQ2Insight =>
      'Immediate safety, non-judgmental empathy, and clinical care—including post-exposure prophylaxis (PEP) within 72 hours—are crucial for survivors.';

  @override
  String get gbvQ3Text =>
      'What role can men and boys play in preventing gender-based violence in our communities?';

  @override
  String get gbvQ3OptA =>
      'Promote respectful relationships, reject violent norms, and speak out against abuse';

  @override
  String get gbvQ3OptB => 'Remain silent when witnessing harassment';

  @override
  String get gbvQ3OptC => 'Enforce rigid traditional inequalities';

  @override
  String get gbvQ3OptD => 'Discourage girls from attending school';

  @override
  String get gbvQ3Insight =>
      'Engaging men and boys as allies and champions for gender equality creates safer, more supportive communities for everyone.';

  @override
  String get gbvQ4Text =>
      'Survivors of GBV are never to blame for the violence committed against them.';

  @override
  String get gbvQ4Insight =>
      'Responsibility for violence rests solely on the perpetrator. Blaming survivors causes secondary trauma and deters people from seeking help.';

  @override
  String get srhHeroDesc =>
      'Sexual and Reproductive Health is a state of physical, mental, and social well-being in all matters relating to the reproductive system, relationships, and fertility.';

  @override
  String get srhNoteText =>
      'Informed decisions, mutual respect, open communication, and access to healthcare ensure healthy relationships and empowered family planning.';

  @override
  String get srhSection1Title => 'Understanding Sexual & Reproductive Health';

  @override
  String get srhSection1Subtitle => 'A Holistic View of Wellbeing';

  @override
  String get srhSection1Intro =>
      'SRH is not just about avoiding disease; it is the right to make informed choices about your body, sexuality, and future.';

  @override
  String get srhSection1Item1 =>
      'Physical health: Caring for reproductive organs, preventing infections, and accessing routine checkups.';

  @override
  String get srhSection1Item2 =>
      'Emotional health: Developing positive self-esteem, healthy body image, and respect in intimate relationships.';

  @override
  String get srhSection1Item3 =>
      'Social wellbeing: Experiencing equality, free from stigma, coercion, or gender discrimination.';

  @override
  String get srhSection2Title => 'Anatomy & Reproductive Systems';

  @override
  String get srhSection2Subtitle => 'How the Human Body Functions';

  @override
  String get srhSection2Intro =>
      'Understanding how female and male reproductive systems work empowers individuals to care for their bodily health.';

  @override
  String get srhSection2Item1 =>
      'Female anatomy: Ovaries produce eggs and hormones (estrogen/progesterone); fallopian tubes guide eggs to the uterus where a baby can develop.';

  @override
  String get srhSection2Item2 =>
      'Male anatomy: Testicles produce sperm and testosterone; sperm travels through the vas deferens and urethra.';

  @override
  String get srhSection2Item3 =>
      'Conception: Fertilization occurs when a sperm cell joins with a mature egg, initiating pregnancy.';

  @override
  String get srhSection3Title => 'Family Planning & Contraceptive Methods';

  @override
  String get srhSection3Subtitle => 'Empowering Family and Life Planning';

  @override
  String get srhSection3Intro =>
      'Family planning allows individuals and couples to decide if and when to have children, promoting maternal and child health.';

  @override
  String get srhSection3Item1 =>
      'Barrier methods: Male and female condoms prevent pregnancy and provide essential protection against STIs and HIV (dual protection).';

  @override
  String get srhSection3Item2 =>
      'Hormonal methods: Pills, injections, implants, and IUDs offer reliable pregnancy prevention by regulating ovulation and cervical mucus.';

  @override
  String get srhSection3Item3 =>
      'Permanent methods: Vasectomy and tubal ligation are voluntary surgical procedures for individuals who have completed their family size.';

  @override
  String get srhSection3Item4 =>
      'Emergency contraception: Can prevent unintended pregnancy when taken within 72 to 120 hours following unprotected intercourse.';

  @override
  String get srhSection4Title => 'Consent, Rights & Healthy Relationships';

  @override
  String get srhSection4Subtitle => 'Building Trust and Mutual Respect';

  @override
  String get srhSection4Intro =>
      'Healthy relationships are built on communication, equality, and uncoerced consent.';

  @override
  String get srhSection4Item1 =>
      'What is consent: An active, freely given, reversible, and informed agreement between partners.';

  @override
  String get srhSection4Item2 =>
      'Bodily autonomy: Everyone has the fundamental right to make decisions regarding their own body and reproductive health.';

  @override
  String get srhSection4Item3 =>
      'Effective communication: Talking openly with partners about boundaries, health history, and contraception leads to safer relationships.';

  @override
  String get srhQuizTitle => 'Sexual & Reproductive Health Quiz';

  @override
  String get srhQ1Text =>
      'Sexual and Reproductive Health includes physical, emotional, and social well-being, not merely the absence of disease.';

  @override
  String get srhQ1Insight =>
      'The World Health Organization recognizes SRH as a positive, holistic state of wellbeing that respects individual rights and choices.';

  @override
  String get srhQ2Text =>
      'Which family planning method provides \'dual protection\' by preventing both unintended pregnancy AND sexually transmitted infections?';

  @override
  String get srhQ2OptA => 'External or internal condoms';

  @override
  String get srhQ2OptB => 'Daily oral contraceptive pills alone';

  @override
  String get srhQ2OptC => 'Injectable hormones alone';

  @override
  String get srhQ2OptD => 'Intrauterine devices (IUDs) alone';

  @override
  String get srhQ2Insight =>
      'While hormonal methods prevent pregnancy effectively, only barrier methods like condoms protect against STIs and HIV simultaneously.';

  @override
  String get srhQ3Text =>
      'Consent in any healthy relationship must be freely given, enthusiastic, informed, and can be changed or withdrawn at any time.';

  @override
  String get srhQ3Insight =>
      'True consent requires freedom of choice without pressure or fear. Respecting partner boundaries is fundamental to healthy relationships.';

  @override
  String get srhQ4Text =>
      'Family planning enables individuals and couples to choose if, when, and how many children to have, supporting maternal and family well-being.';

  @override
  String get srhQ4Insight =>
      'Family planning empowers women and families, reduces maternal complications, and supports healthy child development and financial stability.';

  @override
  String get locationPermissionDenied =>
      'Location permission is required to calculate real-time distance and show nearby facilities.';

  @override
  String get locationDisabled =>
      'Location services are turned off on this device. Please turn on GPS.';

  @override
  String get calculatingDistance => 'Determining your location...';

  @override
  String get callMentorAction => 'Call Mentor';

  @override
  String get telegramChatAction => 'Chat on Telegram';

  @override
  String get directContactsHeading => 'Direct Contact Channels';

  @override
  String workingHoursLabel(String hours) {
    return 'Available Hours: $hours';
  }

  @override
  String get copyHandleSuccess => 'Telegram username copied to clipboard';

  @override
  String get copyPhoneSuccess => 'Phone number copied to clipboard';

  @override
  String get sendSmsAction => 'Send SMS';

  @override
  String get phoneCallUnavailable =>
      'Unable to launch phone dialer on this device';

  @override
  String get telegramUnavailable => 'Unable to open Telegram link';

  @override
  String callHotlineAction(String number) {
    return 'Call $number';
  }

  @override
  String get chatbotTitle => 'Yegna Health Assistant';

  @override
  String get chatbotSubtitle => 'Confidential youth health guidance';

  @override
  String get chatbotDisclaimer =>
      'Educational health assistant only, not a doctor. For clinical emergencies, call 952 or 8335.';

  @override
  String get chatbotInputHint => 'Ask about health, modules, or clinics...';

  @override
  String get chatbotWelcomeMessage =>
      'Hello! I am your private Yegna Health Assistant. Ask me anything about puberty, HIV/AIDS, STIs, reproductive health, mental health, or finding youth-friendly clinics in Ethiopia.';

  @override
  String get chatbotSuggestedHiv => 'How to prevent HIV?';

  @override
  String get chatbotSuggestedPuberty => 'Normal puberty changes';

  @override
  String get chatbotSuggestedClinics => 'Where can I get tested?';

  @override
  String get chatbotSuggestedContraception => 'Emergency contraception';

  @override
  String get chatbotEmergencyAlert =>
      'Immediate emergency help is available. Call 952 (Health Emergency) or 8335 (Youth Helpline) now for free confidential care.';

  @override
  String get chatbotEmergencyTitle => 'Emergency Helpline Alert';

  @override
  String get chatbotEmergencyCall952 => 'Call 952 (Health)';

  @override
  String get chatbotEmergencyCall8335 => 'Call 8335 (Youth)';

  @override
  String get chatbotClearChat => 'Clear conversation';

  @override
  String get chatbotTyping => 'Yegna Assistant is typing...';

  @override
  String get askYegnaFabTooltip => 'Ask Yegna Health Assistant';

  @override
  String get askYegnaFabLabel => 'Ask AI';

  @override
  String get selfAssessmentHeading => 'Self-Assessment';

  @override
  String selfAssessmentQuestionProgress(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get yesOption => 'Yes';

  @override
  String get noOption => 'No';

  @override
  String get nextQuestionAction => 'Next';

  @override
  String get viewResultsAction => 'View Results';

  @override
  String get retakeAssessmentAction => 'Retake Assessment';

  @override
  String get selectAnswerPrompt => 'Please select Yes or No to proceed';

  @override
  String get assessmentResultHeader => 'Assessment Result';

  @override
  String get higherRiskTitle => 'Higher Risk for HIV Infection';

  @override
  String get moderateRiskTitle => 'Moderate Risk for Exposure';

  @override
  String get lowerRiskTitle => 'Lower Risk Profile';

  @override
  String get recommendedActionsHeader => 'Recommended actions';

  @override
  String get keyMessageHeader => 'Key message';

  @override
  String get highRiskKeyMessage =>
      'Having a high-risk score does not mean that you are infected with HIV. However, if risky behaviors continue, there is a possibility of acquiring HIV infection. Therefore, make strong efforts to reduce your level of HIV exposure risk.';

  @override
  String get moderateRiskKeyMessage =>
      'Having moderate risk factors indicates that certain behaviors or situations may expose you to HIV or STIs. Adopting preventive practices like regular testing and consistent condom use protects your health.';

  @override
  String get lowerRiskKeyMessage =>
      'Your responses indicate lower exposure risk. Continue practicing protective behaviors, staying informed, and taking routine health checkups to keep yourself and your partner safe.';

  @override
  String get talkToMentorAction => 'Talk to Mentor';

  @override
  String get talkToMentorSubtitle =>
      'Connect confidentially with a certified youth mentor';

  @override
  String get getServiceAction => 'Get Service';

  @override
  String get getServiceSubtitle =>
      'Find verified youth-friendly health facilities';

  @override
  String get assessmentEducationalDisclaimer =>
      'Educational self-assessment only. Not a medical diagnosis. For clinical testing and professional care, visit a verified youth clinic.';

  @override
  String get restartAssessmentDialogTitle => 'Restart Assessment?';

  @override
  String get restartAssessmentDialogBody =>
      'Your current responses will be reset. Are you sure you want to start from the beginning?';

  @override
  String get restartAction => 'Restart';

  @override
  String get whyThisMattersLabel => 'Why this matters';

  @override
  String riskScoreLabel(int score, int maxScore) {
    return 'Risk Score: $score / $maxScore';
  }

  @override
  String get categoryPartnersRelationships => 'Partners & Relationships';

  @override
  String get categoryProtectionPractices => 'Protection Practices';

  @override
  String get categoryClinicalSymptoms => 'Clinical Symptoms';

  @override
  String get categoryHealthHistory => 'Health History';

  @override
  String get categoryBloodSafety => 'Blood & Instrument Safety';

  @override
  String get categorySubstanceRisk => 'Substance & Behavioral Risk';

  @override
  String get categorySafetySupport => 'Safety & Support';

  @override
  String get categoryTestingPrevention => 'Testing & Prevention';

  @override
  String get assessmentQ1Text =>
      'Have you had more than one sexual partner in the last 12 months?';

  @override
  String get assessmentQ1Why =>
      'Multiple partners without consistent barrier protection increases exposure to asymptomatic viral transmission.';

  @override
  String get assessmentQ2Text =>
      'Have you engaged in sexual activity in exchange for money, gifts, housing, or other benefits (transactional sex) in the last 12 months?';

  @override
  String get assessmentQ2Why =>
      'Transactional encounters often involve power imbalances that can make negotiating consistent condom use difficult.';

  @override
  String get assessmentQ3Text =>
      'Have you had sexual intercourse without using a condom consistently and correctly in the last 6 months?';

  @override
  String get assessmentQ3Why =>
      'Consistent and correct latex condom usage provides over 95% protection against HIV and substantially reduces other STIs.';

  @override
  String get assessmentQ4Text =>
      'Have you had sexual intercourse with a partner whose HIV status was unknown to you, or who has unsuppressed viral levels?';

  @override
  String get assessmentQ4Why =>
      'Knowing partner status is essential. Effective ART suppresses HIV (U=U), but unsuppressed or unknown statuses carry transmission risk.';

  @override
  String get assessmentQ5Text =>
      'In the past 6 months, have you noticed unusual genital discharge, sores, burning during urination, or pelvic pain?';

  @override
  String get assessmentQ5Why =>
      'Untreated STIs cause mucosal ulcerations, increasing biological susceptibility to HIV transmission by 3 to 5 times.';

  @override
  String get assessmentQ6Text =>
      'Have you or any of your partners ever been diagnosed with or treated for a sexually transmitted infection (STI)?';

  @override
  String get assessmentQ6Why =>
      'A past STI indicates previous unprotected exposure and potential risk of reinfection if both partners were not treated simultaneously.';

  @override
  String get assessmentQ7Text =>
      'Have you received tattoos, body piercings, or traditional skin cuts using equipment that might not have been sterile?';

  @override
  String get assessmentQ7Why =>
      'Direct blood contact via non-sterile instruments can transmit bloodborne viruses including Hepatitis B, C, and HIV.';

  @override
  String get assessmentQ8Text =>
      'Have you ever shared needles, syringes, or injection equipment with another person?';

  @override
  String get assessmentQ8Why =>
      'Sharing injection equipment carries one of the highest direct risks for rapid HIV and Hepatitis transmission.';

  @override
  String get assessmentQ9Text =>
      'Do you frequently consume alcohol, khat, or substances before sex, making condom use harder to remember or negotiate?';

  @override
  String get assessmentQ9Why =>
      'Substances impair decision-making and are the primary behavioral factor in unplanned condomless sexual activity.';

  @override
  String get assessmentQ10Text =>
      'Have you ever experienced forced sexual contact, coercion, or non-consensual sexual activity?';

  @override
  String get assessmentQ10Why =>
      'Non-consensual encounters carry high trauma and exposure risk. Emergency PEP is available within 72 hours alongside crisis counseling.';

  @override
  String get assessmentQ11Text =>
      'Have you experienced chronic unexplained fever, severe fatigue, drenching night sweats, or rapid weight loss?';

  @override
  String get assessmentQ11Why =>
      'These systemic warning symptoms require prompt professional evaluation to check for infections, tuberculosis, or HIV.';

  @override
  String get assessmentQ12Text =>
      'Has it been more than 6 months since your last HIV and sexual health test (or have you never been tested)?';

  @override
  String get assessmentQ12Why =>
      'HIV can be asymptomatic for years. Routine testing every 3 to 6 months provides peace of mind and early life-saving care.';

  @override
  String get highRiskAction1 =>
      'Get tested for HIV immediately at a youth-friendly clinic.';

  @override
  String get highRiskAction2 =>
      'Use condoms consistently and correctly every time.';

  @override
  String get highRiskAction3 =>
      'Actively participate in all peer learning sessions and talk to a mentor.';

  @override
  String get highRiskAction4 =>
      'Ask a clinician about PrEP (Pre-Exposure Prophylaxis) for ongoing protection.';

  @override
  String get modRiskAction1 =>
      'Schedule a routine HIV and STI screening test soon.';

  @override
  String get modRiskAction2 =>
      'Ensure consistent barrier protection (condoms) in all sexual encounters.';

  @override
  String get modRiskAction3 =>
      'Explore our learning modules and discuss testing with your partner.';

  @override
  String get lowRiskAction1 =>
      'Continue practicing safe behaviors and mutual open communication.';

  @override
  String get lowRiskAction2 =>
      'Maintain annual or bi-annual routine health checkups.';

  @override
  String get lowRiskAction3 =>
      'Share reliable health facts with friends and peers in your community.';

  @override
  String get systemTheme => 'System Default';

  @override
  String get pushAlertsLabel => 'Push Alerts & Reminders';

  @override
  String get healthTipsLabel => 'Daily Health Education Tips';

  @override
  String get assessmentRemindersLabel => 'Self-Assessment Checkup Reminders';

  @override
  String get guestSignInPromoTitle => 'Save your learning journey';

  @override
  String get guestSignInPromoBody =>
      'Sign in or create a free account to back up quiz scores, access certificates, and sync across devices.';

  @override
  String get guestSignInAction => 'Sign in / Register';

  @override
  String get copyResponseAction => 'Copy';

  @override
  String get responseCopiedMessage => 'Response copied to clipboard';

  @override
  String get newChatAction => 'New chat';

  @override
  String get chatHistoryTitle => 'Chat History';

  @override
  String get noChatHistory => 'No conversations yet';

  @override
  String get noChatHistorySubtitle =>
      'Your health questions and guidance will be saved here.';

  @override
  String get deleteChatAction => 'Delete chat';

  @override
  String get deleteChatConfirmTitle => 'Delete Conversation?';

  @override
  String get deleteChatConfirmMessage =>
      'Are you sure you want to delete this chat history?';

  @override
  String get clearAllChatsAction => 'Clear all chats';

  @override
  String get clearAllChatsConfirmTitle => 'Clear Chat History?';

  @override
  String get clearAllChatsConfirmMessage =>
      'This will permanently delete all your previous conversations.';

  @override
  String get chatHistoryToday => 'Today';

  @override
  String get chatHistoryYesterday => 'Yesterday';

  @override
  String get chatHistoryPreviousDays => 'Previous 7 days';

  @override
  String get chatHistoryOlder => 'Older';

  @override
  String get activeChatBadge => 'Active';
}
