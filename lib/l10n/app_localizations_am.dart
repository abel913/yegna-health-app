// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Amharic (`am`).
class AppLocalizationsAm extends AppLocalizations {
  AppLocalizationsAm([String locale = 'am']) : super(locale);

  @override
  String get appTitle => 'የእኛ ጤና';

  @override
  String get homeTab => 'መነሻ';

  @override
  String get learnTab => 'እውቀት';

  @override
  String get servicesTab => 'አገልግሎቶች';

  @override
  String get settingsTab => 'ቅንብሮች';

  @override
  String get welcomeTitle => 'ጤናዎ፣ ጉዞዎ';

  @override
  String get welcomeBody => 'በአማርኛ እና በእንግሊዝኛ የጤና ትምህርትና አገልግሎት የሚያገኙበት ቦታ።';

  @override
  String get foundationLabel => 'እንጀምር';

  @override
  String get foundationBody =>
      'የጤና ትምህርትና አገልግሎቶች በዝግጅት ላይ ናቸው። ይህ መተግበሪያ የሕክምና ምክር አይሰጥም።';

  @override
  String get languageTitle => 'ቋንቋ';

  @override
  String get languageDescription => 'በመተግበሪያው የሚጠቀሙበትን ቋንቋ ይምረጡ።';

  @override
  String get englishLanguage => 'እንግሊዝኛ';

  @override
  String get amharicLanguage => 'አማርኛ';

  @override
  String get learnPlaceholder => 'የትምህርት ይዘት በወደፊት ዝማኔ ይታያል።';

  @override
  String get servicesPlaceholder => 'የተረጋገጡ የጤና አገልግሎቶች በወደፊት ዝማኔ ይታያሉ።';

  @override
  String get settingsPlaceholder => 'የቋንቋ ምርጫዎች እዚህ ይገኛሉ።';

  @override
  String get localeChanged => 'ቋንቋው ተቀይሯል';

  @override
  String get selectLanguage => 'ቋንቋ ይምረጡ';

  @override
  String get accountTitle => 'መለያ';

  @override
  String get profile => 'መገለጫ';

  @override
  String get accountGuest => 'የእንግዳ መጠቀሚያ';

  @override
  String accountSignedInAs(String email) {
    return 'እንደ $email ገብተዋል';
  }

  @override
  String get manageAccount => 'መለያዎን ያስተዳድሩ';

  @override
  String get signIn => 'ይግቡ';

  @override
  String get signOut => 'ይውጡ';

  @override
  String get createAccount => 'መለያ ይፍጠሩ';

  @override
  String get registerAction => 'መለያ ይፍጠሩ';

  @override
  String get loginAction => 'ይግቡ';

  @override
  String get forgotPassword => 'የይለፍ ቃል ረሱ?';

  @override
  String get noAccount => 'አዲስ ነዎት? መለያ ይፍጠሩ';

  @override
  String get hasAccount => 'መለያ አለዎት? ይግቡ';

  @override
  String get emailLabel => 'የኢሜይል አድራሻ';

  @override
  String get passwordLabel => 'የይለፍ ቃል';

  @override
  String get newPasswordLabel => 'አዲስ የይለፍ ቃል';

  @override
  String get confirmPasswordLabel => 'የይለፍ ቃሉን ያረጋግጡ';

  @override
  String get displayNameLabel => 'የሚታይ ስም';

  @override
  String get sendRecoveryEmail => 'የመመለሻ ኢሜይል ይላኩ';

  @override
  String get recoveryInstructions => 'ኢሜይልዎን ያስገቡ፤ መለያ ካለ የመመለሻ መመሪያ እንልካለን።';

  @override
  String get recoveryEmailSent =>
      'ከዚህ ኢሜይል ጋር የሚዛመድ መለያ ካለ፣ የይለፍ ቃል መመለሻ መመሪያ ተልኳል።';

  @override
  String get verificationPendingTitle => 'ኢሜይልዎን ይመልከቱ';

  @override
  String verificationPendingBody(String email) {
    return 'የማረጋገጫ አገናኝ ወደ $email ልከናል። ኢሜይልዎን በዚህ መሣሪያ ላይ ከከፈቱ በኋላ ያረጋግጡና ይግቡ።';
  }

  @override
  String get passwordUpdatedTitle => 'የይለፍ ቃሉ ተቀይሯል';

  @override
  String get passwordUpdatedBody => 'የይለፍ ቃልዎ ተቀይሯል። በአዲሱ የይለፍ ቃል ይግቡ።';

  @override
  String get updatePassword => 'የይለፍ ቃል ያዘምኑ';

  @override
  String get saveProfile => 'መገለጫውን ያስቀምጡ';

  @override
  String get profileSaved => 'መገለጫው ተቀምጧል።';

  @override
  String get continueAsGuest => 'እንደ እንግዳ ይቀጥሉ';

  @override
  String get guestAccessDescription => 'ያለ መለያ የህዝብ የጤና ትምህርትን ማየት ይችላሉ።';

  @override
  String get authConfigMissing =>
      'የመለያ አገልግሎቱ ለዚህ የመተግበሪያ ስሪት አልተዋቀረም። የህዝብ ገጾች ግን ይገኛሉ።';

  @override
  String get errorEmailRequired => 'የኢሜይል አድራሻዎን ያስገቡ።';

  @override
  String get errorInvalidEmail => 'ትክክለኛ የኢሜይል አድራሻ ያስገቡ።';

  @override
  String get errorPasswordRequired => 'የይለፍ ቃልዎን ያስገቡ።';

  @override
  String get errorPasswordTooShort => 'የይለፍ ቃሉ ቢያንስ 8 ቁምፊዎች ይኑሩት።';

  @override
  String get errorPasswordMismatch => 'የይለፍ ቃሎቹ አይዛመዱም።';

  @override
  String get errorDisplayNameRequired => 'የሚታይ ስም ያስገቡ።';

  @override
  String get errorDisplayNameTooLong => 'ለሚታየው ስም ከ80 ቁምፊዎች በላይ አይጠቀሙ።';

  @override
  String get errorInvalidCredentials => 'ኢሜይሉ ወይም የይለፍ ቃሉ ትክክል አይደለም።';

  @override
  String get errorEmailNotConfirmed =>
      'ከመግባትዎ በፊት ኢሜይልዎን ያረጋግጡ። የማረጋገጫ አገናኙን ይፈልጉ።';

  @override
  String get errorRegistration =>
      'መለያውን መፍጠር አልተቻለም። ለመግባት ወይም የይለፍ ቃሉን ለመመለስ ይሞክሩ።';

  @override
  String get errorNetwork =>
      'የመለያ አገልግሎቱን ማግኘት አልተቻለም። ግንኙነትዎን ያረጋግጡና እንደገና ይሞክሩ።';

  @override
  String get errorRecoveryExpired => 'ይህ የመመለሻ አገናኝ ጊዜው አልፎበታል። አዲስ ይጠይቁ።';

  @override
  String get errorSessionUnavailable => 'የመግቢያ ጊዜዎ አልቋል። እንደገና ይግቡ።';

  @override
  String get errorUnexpected => 'አንድ ችግር ተፈጥሯል። እባክዎ እንደገና ይሞክሩ።';

  @override
  String get errorTitle => 'የመለያ ጥያቄው አልተሳካም';

  @override
  String get sessionEnded => 'የመግቢያ ጊዜዎ አልቋል። መገለጫዎን ለማየት እንደገና ይግቡ።';

  @override
  String get profileDescription => 'የመገለጫ ዝርዝሮችዎ በገቡት መለያ ብቻ ይታያሉ።';

  @override
  String get passwordRecoveryTitle => 'የይለፍ ቃልዎን ዳግም ያስጀምሩ';

  @override
  String get learningHeading => 'የጤና ትምህርት';

  @override
  String get learningIntroduction =>
      'ለህትመት የተገመገሙ የትምህርት ምንጮችን ይመልከቱ። ይህ መተግበሪያ የባለሙያ እንክብካቤን አይተካም።';

  @override
  String get articlesHeading => 'ጽሑፎች';

  @override
  String get assessmentsHeading => 'ምዘናዎች';

  @override
  String get progressHeading => 'የእኔ ትምህርት';

  @override
  String get searchArticles => 'ጽሑፎችን ይፈልጉ';

  @override
  String get allCategories => 'ሁሉም ምድቦች';

  @override
  String get noReviewedArticles => 'እስካሁን የተገመገሙ ጽሑፎች አልተገኙም።';

  @override
  String get noReviewedAssessments => 'እስካሁን የተገመገሙ ምዘናዎች አልተገኙም።';

  @override
  String get noSearchResults => 'ከፍለጋዎ ጋር የሚዛመድ ጽሑፍ አልተገኘም።';

  @override
  String get learningLoadError =>
      'የትምህርት ይዘቱን መጫን አልተቻለም። ግንኙነትዎን ያረጋግጡና እንደገና ይሞክሩ።';

  @override
  String get educationUnavailable => 'በዚህ የመተግበሪያ ስሪት የትምህርት ይዘት አይገኝም።';

  @override
  String get retryAction => 'እንደገና ይሞክሩ';

  @override
  String staleSavedContentWarning(String date) {
    return 'ይህ የተቀመጠ ቅጂ በ$date መጨረሻ ተፈትሿል። ጊዜው ያለፈበት ወይም የተወገደ ሊሆን ይችላል። በዚህ ላይ ከመመርኮዝዎ በፊት ኢንተርኔት ያገናኙ።';
  }

  @override
  String get sourceReferences => 'ምንጮች';

  @override
  String articleReviewInfo(String date) {
    return 'በ$date ተገምግሟል። የትምህርት መረጃ የሙያዊ ሕክምናን አይተካም።';
  }

  @override
  String get relatedLearning => 'ተዛማጅ ትምህርት';

  @override
  String get markArticleComplete => 'እንዳነበብኩ ምልክት አድርግ';

  @override
  String get articleMarkedComplete => 'ንባቡ በትምህርት ሂደትዎ ተቀምጧል።';

  @override
  String get startAssessment => 'ምዘናውን ጀምር';

  @override
  String questionProgress(int current, int total) {
    return 'ጥያቄ $current ከ $total';
  }

  @override
  String get nextQuestion => 'ቀጣይ ጥያቄ';

  @override
  String get submitAnswers => 'መልሶችን ላክ';

  @override
  String get retakeAssessment => 'ምዘናውን እንደገና ውሰድ';

  @override
  String assessmentResult(int score, int total, int percent) {
    return 'ከ $total ጥያቄዎች $score ትክክል ናቸው ($percent%)';
  }

  @override
  String get answerExplanation => 'ማብራሪያ';

  @override
  String get correctAnswer => 'ትክክለኛው መልስ';

  @override
  String get pendingScore =>
      'መልሶችዎ በዚህ መሣሪያ ላይ ተቀምጠዋል። የተረጋገጠ ውጤት ለማግኘት ኢንተርኔት ያገናኙ።';

  @override
  String get assessmentSubmitError => 'መልሶችዎን መላክ አልተቻለም። ውጤትዎ ገና አልተገኘም።';

  @override
  String get selectAnAnswer => 'ለመቀጠል መልስ ይምረጡ።';

  @override
  String get progressSyncTitle => 'የትምህርት ሂደት ማመሳሰል';

  @override
  String get progressSyncDescription =>
      'የተጠናቀቁ ጽሑፎችንና የምዘና ታሪክን ከገቡበት መለያ ጋር ማመሳሰል ይፈልጉ እንደሆነ ይምረጡ። ማመሳሰል ሲጠፋም የመሣሪያዎ ውስጥ ያለ ሂደት ይቆያል።';

  @override
  String get progressSyncEnable => 'ማመሳሰልን አብራ';

  @override
  String get progressSyncDisable => 'ማመሳሰልን አጥፋ';

  @override
  String get progressSyncEnabled => 'የሂደት ማመሳሰል በርቷል።';

  @override
  String get progressSyncDisabled => 'የሂደት ማመሳሰል ጠፍቷል። በመሣሪያዎ ያለው ሂደት ግን ይገኛል።';

  @override
  String get progressSyncSignInRequired => 'የትምህርት ሂደትን ለማመሳሰል ይግቡ።';

  @override
  String get progressSyncError =>
      'የማመሳሰል ቅንብሩን ማዘመን አልተቻለም። በመሣሪያዎ ያለው ሂደት ይቆያል።';

  @override
  String get clearSyncedHistory => 'የተመሳሰለ ታሪክን አጥፋ';

  @override
  String get clearSyncedHistoryTitle => 'የተመሳሰለው የትምህርት ታሪክ ይጥፋ?';

  @override
  String get clearSyncedHistoryBody =>
      'ይህ የጽሑፍ ማጠናቀቂያዎችንና የምዘና ሙከራዎችን ከመለያዎ ያጠፋል። በዚህ መሣሪያ የተቀመጠው ሂደት ይቆያል።';

  @override
  String get clearHistoryAction => 'ታሪክን አጥፋ';

  @override
  String get cancelAction => 'ሰርዝ';

  @override
  String get syncedHistoryCleared => 'የተመሳሰለው የትምህርት ታሪክ ተጠፍቷል።';

  @override
  String get clearHistoryError => 'የተመሳሰለውን ታሪክ ማጥፋት አልተቻለም። እንደገና ይሞክሩ።';

  @override
  String completedArticlesCount(int count) {
    return 'የተጠናቀቁ ጽሑፎች፦ $count';
  }

  @override
  String assessmentAttemptsCount(int count) {
    return 'የምዘና ሙከራዎች፦ $count';
  }

  @override
  String get noLearningProgress => 'የትምህርት ሂደትዎ እዚህ ይታያል።';

  @override
  String get localProgressLabel => 'በዚህ መሣሪያ ላይ ተቀምጧል';

  @override
  String get scoreHistoryLabel => 'የተረጋገጠ የውጤት ታሪክ';

  @override
  String assessmentScorePercent(int score) {
    return '$score%';
  }

  @override
  String get facilitiesTab => 'የጤና ተቋማት';

  @override
  String get mentorsTab => 'አማካሪዎች';

  @override
  String get accountTab => 'መለያ';

  @override
  String get healthEducationBoundary =>
      'ይህ መተግበሪያ የትምህርት መረጃ ብቻ ያቀርባል፤ የባለሙያ እንክብካቤን አይተካም።';

  @override
  String get quickLinksHeading => 'ይመልከቱ';

  @override
  String get quickLinksDescription => 'ለመቀጠል አንድ ክፍል ይምረጡ።';

  @override
  String get featuredArticlesHeading => 'የጤና ትምህርት';

  @override
  String get viewAllAction => 'ሁሉንም ይመልከቱ';

  @override
  String get noFeaturedArticlesTitle => 'ገና የተገመገሙ ጽሑፎች የሉም';

  @override
  String get noFeaturedArticlesBody => 'የታተሙ የትምህርት መርጃዎች ሲዘጋጁ እዚህ ይታያሉ።';

  @override
  String get homeFaqHeading => 'ብዙ ጊዜ የሚጠየቁ ጥያቄዎች';

  @override
  String get noReviewedFaqsTitle => 'ገና የተገመገሙ ጥያቄዎች የሉም';

  @override
  String get noReviewedFaqsBody => 'መልሶች ከተገመገሙና ከጸደቁ በኋላ እዚህ ይታያሉ።';

  @override
  String get findVerifiedCare => 'የጤና እንክብካቤ ይፈልጋሉ?';

  @override
  String get facilitiesIntroduction =>
      'ለወጣቶች ምቹ የሆኑ የጤና ተቋማትንና አገልግሎቶችን ይመልከቱ።';

  @override
  String get searchFacilities => 'የጤና ተቋማትን ይፈልጉ';

  @override
  String get allFacilities => 'ሁሉም ተቋማት';

  @override
  String get nearbyFilter => 'በአቅራቢያ';

  @override
  String get campusFilter => 'ግቢ';

  @override
  String get noVerifiedFacilitiesTitle => 'ገና የተረጋገጡ ተቋማት አልተዘረዘሩም';

  @override
  String get facilitiesNotAvailableBody =>
      'የተቋማት መረጃ ገና የለም። እስኪረጋገጡ ድረስ አገልግሎት ሰጪዎችን ወይም የመገኛ መረጃን አናሳይም።';

  @override
  String get mapPreviewTitle => 'ካርታ';

  @override
  String get mapNotAvailableBody => 'የተረጋገጠ የተቋማት ዝርዝር ሲኖር ካርታ ይቀርባል።';

  @override
  String get mentorsIntroduction => 'የተረጋገጡ መገለጫዎች ሲኖሩ የእኩዮች ድጋፍ ያግኙ።';

  @override
  String get searchMentors => 'አማካሪዎችን ይፈልጉ';

  @override
  String get allMentors => 'ሁሉም አማካሪዎች';

  @override
  String get languageFilter => 'ቋንቋ';

  @override
  String get noVerifiedMentorsTitle => 'ገና የተረጋገጡ የአማካሪ መገለጫዎች የሉም';

  @override
  String get noVerifiedMentorsBody =>
      'የአማካሪዎች መገለጫና የመገናኛ አማራጮች የሚታዩት የማንነትና የደህንነት ማረጋገጫ ሂደት ከተዘጋጀ በኋላ ነው።';

  @override
  String get mentorSafetyTitle => 'የእኩዮች ድጋፍ ዝርዝር';

  @override
  String get mentorSafetyBody =>
      'የማረጋገጫ ሂደት እስኪኖር ድረስ ሰዎችን ወይም የመገኛ መረጃን አናሳይም።';

  @override
  String get learningProgressTitle => 'የትምህርት እንቅስቃሴዎ';

  @override
  String get selfAssessmentTitle => 'ራስን መገምገም';

  @override
  String get selfAssessmentDesc => 'የጤና ሁኔታዎን ይገምግሙና ተገቢውን መመሪያ ያግኙ።';

  @override
  String get learnDesc => 'ስለ ስነ-ተዋልዶ እና አጠቃላይ የጤና ትምህርት በዝርዝር ይማሩ።';

  @override
  String get findFacilitiesTitle => 'የጤና ተቋማት';

  @override
  String get findFacilitiesDesc => 'በአቅራቢያዎ የሚገኙ አስተማማኝ የጤና ተቋማትን ያግኙ።';

  @override
  String get peerMentorTitle => 'የአቻ አማካሪ';

  @override
  String get peerMentorDesc => 'ከአስተማማኝ አማካሪዎች ጋር ለምክርና ድጋፍ ይገናኙ።';

  @override
  String get welcomeHeroTitle => 'እንኳን ወደ የእኛ ጤና በደህና መጡ';

  @override
  String get welcomeHeroSubtitle =>
      'ወጣቶች ራሳቸውን እንዲገመግሙ፣ ስለ ስነ-ተዋልዶ ጤና እንዲማሩ እና ከተረጋገጡ የጤና ባለሙያዎች ጋር እንዲገናኙ የሚያግዝ መተግበሪያ።';

  @override
  String get confidentialPill => '100% ሚስጥራዊ';

  @override
  String get reviewedPill => 'የተረጋገጠ ይዘት';

  @override
  String get guestReadyPill => 'ያለ ክፍያ ክፍት';
}
