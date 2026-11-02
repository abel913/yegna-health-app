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
  String get learningHeading => 'የትምህርት ክፍሎች';

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

  @override
  String get learningModulesTitle => 'የትምህርት ክፍሎች';

  @override
  String get moreButton => 'ተጨማሪ';

  @override
  String get takeQuizButton => 'ፈተናውን ውሰዱ';

  @override
  String moduleLabel(String number) {
    return 'ክፍል $number';
  }

  @override
  String get module01Title => 'የወጣቶች ጤና እና የጉርምስና ወቅት';

  @override
  String get module01Desc =>
      'ይህ ክፍል በጉርምስና ወቅት ስለሚከሰቱ አካላዊ እና ስሜታዊ ለውጦች፣ የግል ንጽሕና እና በራስ መተማመን ያብራራል።';

  @override
  String get module02Title => 'በግብረ ሥጋ ግንኙነት የሚተላለፉ ኢንፌክሽኖች (STI)';

  @override
  String get module02Desc =>
      'ይህ ክፍል በግብረ ሥጋ ግንኙነት ስለሚተላለፉ ኢንፌክሽኖች፣ ምልክቶቻቸው፣ እንዴት እንደሚመረመሩ፣ እንደሚታከሙ እና እንደሚከላከሉ ያብራራል።';

  @override
  String get module03Title => 'የጉበት በሽታ (ሄፓታይተስ)';

  @override
  String get module03Desc =>
      'ይህ ክፍል ስለ ሄፓታይተስ፣ መንስኤዎቹ፣ ዓይነቶቹ፣ ምልክቶቹ እና የጉበት ጤናን እንዴት እንደሚጎዳ ያስተዋውቃል።';

  @override
  String get module04Title => 'በጾታ ላይ የተመሰረተ ጥቃት (GBV)';

  @override
  String get module04Desc =>
      'ይህ ክፍል በጾታ ላይ የተመሰረተ ጥቃትን፣ ዓይነቶቹን፣ መንስኤዎቹን እና በግለሰቦችና በማህበረሰብ ላይ የሚያደርሰውን ተፅዕኖ ይመረምራል።';

  @override
  String get module05Title => 'የሥነ-ተዋልዶ ጤና (SRH)';

  @override
  String get module05Desc =>
      'ይህ ክፍል ግለሰቦች ከሥነ-ተዋልዶ፣ ግንኙነቶች እና ተዋልዶ ጤና ጋር የተያያዙ ጉዳዮችን በሚገባ እንዲረዱ ያግዛል።';

  @override
  String get module06Title => 'የአእምሮ ጤና እና ደህንነት';

  @override
  String get module06Desc =>
      'ይህ ክፍል ስለ አእምሮ ጤና፣ ውጥረትን ስለመቆጣጠር፣ ጭንቀትን ስለማሸነፍ እና አስተማማኝ ድጋፍ ስለማግኘት ያብራራል።';

  @override
  String get module07Title => 'የኤችአይቪ/ኤድስ ቫይረስ (HIV/AIDS)';

  @override
  String get module07Desc =>
      'ይህ የትምህርት ክፍል ስለ ኤችአይቪ/ኤድስ ምንነት፣ እንዴት እንደሚተላለፍ፣ የመከላከያ መንገዶች እና ስለ ህክምናው መሰረታዊ ግንዛቤ ይሰጣል።';

  @override
  String get module08Title => 'የዕፅ ሱስ እና አላግባብ መጠቀም';

  @override
  String get module08Desc =>
      'ይህ የትምህርት ክፍል የተለያዩ የዕፅ ዓይነቶችን፣ በአእምሮ እና በባህሪ ላይ የሚያሳድሩትን ተፅዕኖ እና ጤናማ የአኗኗር ዘይቤን ስለመከተል ያስረዳል።';

  @override
  String get completedStatus => 'ተጠናቋል';

  @override
  String get hivHeroDesc =>
      'የኤችአይቪ/ኤድስ ቫይረስ የበሽታ መከላከያ ሥርዓትን የሚያዳክም ቫይረስ ሲሆን፣ በዋናነት ጥንቃቄ በጎደለው የግብረ-ሥጋ ግንኙነት፣ በደም ንክኪ እና ከእናት ወደ ልጅ ይተላለፋል፤ ነገር ግን በጥንቃቄ እርምጃዎች መከላከል እና ቀደም ብሎ በመመርመርና በህክምና (ART) በሚገባ መቆጣጠር ይቻላል።';

  @override
  String get hivNoteTitle => 'ማስታወሻ';

  @override
  String get hivNoteContent =>
      'ኤችአይቪን መከላከል እና መቆጣጠር ይቻላል—ደህንነታቸው የተጠበቁ ባህሪያትን ይለማመዱ፣ ቀድመው ይመረመሩ፣ እና ጤናማ ሕይወት ለመምራትና ሌሎችን ለመጠበቅ ሕክምና (ART) ይጀምሩ።';

  @override
  String get stiHeroDesc =>
      'በግብረ ሥጋ ግንኙነት የሚተላለፉ ኢንፌክሽኖች (STIs) በዋነኝነት የሚተላለፉት ጥንቃቄ በጎደለው የግብረ ሥጋ ግንኙነት ሲሆን ምንም ምልክት ላያሳዩ ይችላሉ፤ ነገር ግን ካልታከሙ ከባድ የጤና ጉዳቶችን ሊያስከትሉ ይችላሉ። በቅድመ ምርመራና ተገቢ ሕክምና በብቃት መቆጣጠር ይቻላል።';

  @override
  String get stiNoteContent =>
      'ደህንነቱ የተጠበቀ የግብረ ሥጋ ግንኙነት በማድረግ፣ አዘውትረው በመመርመር እና አስቀድመው የህክምና እርዳታ በማግኘት ራስዎን ይጠብቁ፤ የጤና ሁኔታዎን ማወቅ ችግሮችን ለመከላከል እና ሌሎችንም ለመጠበቅ ይረዳል።';

  @override
  String get stiDefinitionTitle => 'ትርጓሜ';

  @override
  String get stiDefinitionSubtitle =>
      'በግብረ ሥጋ ግንኙነት የሚተላለፉ ኢንፌክሽኖች (STIs) ምንድን ናቸው?';

  @override
  String get stiDefinitionDesc1 =>
      'በግብረ ሥጋ ግንኙነት የሚተላለፉ ኢንፌክሽኖች (STIs) በዋነኝነት በግብረ ሥጋ ግንኙነት (በሴት ብልት፣ በአፍ ወይም በፊንጢጣ) ከአንድ ሰው ወደ ሌላ ሰው የሚተላለፉ ኢንፌክሽኖች ናቸው። እነዚህም በባክቴሪያ፣ በቫይረስ ወይም በጥገኛ ተውሳኮች የሚከሰቱ ናቸው።';

  @override
  String get stiDefinitionDesc2 =>
      'የተለመዱ የባክቴሪያ STIs ክላሚዲያ፣ ጨብጥ (ጎኖርያ) እና ቂጥኝ (ሲፊሊስ) ናቸው። የተለመዱ የቫይረስ STIs ደግሞ የሰው ፓፒሎማቫይረስ (HPV)፣ ሄርፒስ (HSV)፣ ሄፓታይተስ ቢ እና ኤችአይቪ ናቸው። የተለመደው የጥገኛ ተውሳክ ኢንፌክሽን ትሪኮሞኒያሲስ ነው።';

  @override
  String get stiDefinitionDesc3 =>
      'ብዙ ሰዎች የኢንፌክሽን እና የበሽታ ልዩነትን ይደባለቃሉ። ኢንፌክሽን (STI) በሽታ አምጪው በሰውነት ውስጥ መኖሩን የሚያመለክት ሲሆን ብዙውን ጊዜ ምንም የሚታይ ምልክት አያሳይም። ኢንፌክሽኑ የሕመም ምልክቶች ወይም የሰውነት ጉዳት ሲያስከትል ወደ በሽታነት (STD) ይቀየራል። ብዙ STIs ድምፅ-አልባ ቢሆኑም ወደ ሌሎች ሊተላለፉ ይችላሉ።';

  @override
  String get stiSymptomsTitle => 'የ STI ምልክቶች';

  @override
  String get stiSymptomsSubtitle => 'የተለመዱ ምልክቶች እና ምልክት አልባ ሁኔታዎች';

  @override
  String get stiSymptomsIntro =>
      'ምልክቶቹ እንደ ኢንፌክሽኑ ዓይነት እና እንደ ጾታ ሊለያዩ ይችላሉ፣ ነገር ግን በብዛት የሚከተሉትን ያካትታሉ፦';

  @override
  String get stiSymptom1 =>
      'ያልተለመደ ፈሳሽ፦ ከብልት ወይም ከፊንጢጣ የሚወጣ ወፍራም፣ ቀጭን፣ ቢጫ፣ አረንጓዴ ወይም መጥፎ ጠረን ያለው ፈሳሽ።';

  @override
  String get stiSymptom2 =>
      'የሕመም ወይም የማቃጠል ስሜት፦ በሽንት ወይም በግብረ ሥጋ ግንኙነት ወቅት የሚሰማ የማቃጠል ወይም የሕመም ስሜት።';

  @override
  String get stiSymptom3 =>
      'ቁስለት፣ እብጠት ወይም ኪንታሮት፦ በብልት፣ በጉሮሮ፣ በአፍ ወይም በፊንጢጣ ዙሪያ የሚታዩ የሚያሳምሙ ወይም የማያሳምሙ ቁስሎች፣ አረፋዎች ወይም እብጠቶች።';

  @override
  String get stiSymptom4 =>
      'ማሳከክ እና መቅላት፦ በብልት እና በዙሪያው አካባቢ የሚሰማ የማያቋርጥ ማሳከክ፣ መቅላት ወይም እብጠት።';

  @override
  String get stiSymptom5 =>
      'የሆድ ወይም የወገብ ሕመም፦ የታችኛው የሆድ ክፍል ሕመም፣ የወር አበባ ባልሆነ ጊዜ የሚታይ ደም መፍሰስ፣ ወይም ከግንኙነት በኋላ ደም መፍሰስ።';

  @override
  String get stiSymptomsAsymptomaticAlert =>
      'ድምፅ-አልባ ኢንፌክሽኖች፦ እስከ 70% የሚሆኑ ሴቶች እና ብዙ ወንዶች በክላሚዲያ ወይም በጨብጥ ሲያዙ ምንም ዓይነት የሚታይ ምልክት አያሳዩም። ትክክለኛውን ሁኔታ ለማወቅ ክሊኒካዊ ምርመራ ብቸኛው መንገድ ነው።';

  @override
  String get stiDiagnosisTitle => 'የ STI ምርመራ';

  @override
  String get stiDiagnosisSubtitle => 'የጤና ባለሙያዎች STIን እንዴት ይመረምራሉ';

  @override
  String get stiDiagnosisIntro =>
      'ቀደም ብሎ መመርመር ፈጣን ፈውስን ያረጋግጣል እና ዘላቂ የመራቢያ አካላት ጉዳትን ይከላከላል። የጤና ባለሙያዎች የሚከተሉትን ይጠቀማሉ፦';

  @override
  String get stiDiagnosisItem1 =>
      'ክሊኒካዊ የአካል ምርመራ፦ በሰለጠነ የጤና ባለሙያ የሚደረግ ሚስጥራዊ እና አክብሮት የተሞላበት የአካል ምርመራ።';

  @override
  String get stiDiagnosisItem2 =>
      'የላቦራቶሪ ምርመራዎች፦ የደም ምርመራ (ለቂጥኝ፣ ኤችአይቪ፣ ሄፓታይተስ ቢ)፣ የሽንት ናሙና፣ እና ከፈሳሽ ወይም ከቁስለት የሚወሰድ ናሙና።';

  @override
  String get stiDiagnosisItem3 =>
      'የህመም ምልክት ተኮር አያያዝ (ሲንድሮሚክ ማኔጅመንት)፦ በኢትዮጵያ የመጀመሪያ ደረጃ ጤና ጣቢያዎች የጤና ባለሙያዎች የላቦራቶሪ ውጤቶችን ለቀናት ሳይጠብቁ በምልክቶች ላይ ተመስርተው በመጀመሪያው ቀን ህክምና ይሰጣሉ።';

  @override
  String get stiDiagnosisYouthFriendly =>
      'ለወጣቶች ምቹ የሆኑ የጤና ማዕከላት ፍጹም ሚስጥራዊ እና ከስጋት ነጻ የሆነ የምክር፣ የምርመራ እና የእንክብካቤ አገልግሎት ይሰጣሉ።';

  @override
  String get stiComplicationsTitle => 'የ STI ውስብስብ የጤና ችግሮች';

  @override
  String get stiComplicationsSubtitle =>
      'ያልታከሙ የ STI ኢንፌክሽኖች የሚያስከትሉት ከባድ አደጋዎች';

  @override
  String get stiComplicationsIntro =>
      'STIs ሳይታከሙ ወይም በአግባቡ ሳይታከሙ ሲቀሩ ከባድ እና ዘላቂ የጤና ችግሮችን ያስከትላሉ፦';

  @override
  String get stiComplication1 =>
      'መሃንነት እና የዳሌ እብጠት (PID)፦ ያልታከመ ክላሚዲያ ወይም ጨብጥ በሴቶች ላይ የማህፀን ቱቦ ጠባሳን እና መካንነትን ያስከትላል፤ በወንዶች ላይም የዘር ፍሬ እብጠት እና መካንነት ያመጣል።';

  @override
  String get stiComplication2 =>
      'ከፍተኛ የኤችአይቪ ተጋላጭነት፦ በብልት ላይ ያሉ ቁስሎች እና እብጠቶች በኤችአይቪ የመያዝ ወይም የማስተላለፍ እድልን ከ3 እስከ 5 እጥፍ ይጨምራሉ።';

  @override
  String get stiComplication3 =>
      'ከእናት ወደ ልጅ መተላለፍ፦ ነፍሰጡር እናቶች ያልታከመ STI ካለባቸው ኢንፌክሽኑን ወደ ልጃቸው ሊያስተላልፉ ይችላሉ፤ ይህም ውርጃ፣ የሞተ ልጅ መወለድ፣ ያለጊዜው መወለድ እና የጨቅላ ሕጻናት የአይን ኢንፌክሽን ሊያስከትል ይችላል።';

  @override
  String get stiComplication4 =>
      'የማህፀን በር ካንሰር፦ ከፍተኛ ተጋላጭነት ባላቸው የ HPV ዝርያዎች የሚከሰቱ ዘላቂ ኢንፌክሽኖች ለሴቶች የማህፀን በር ካንሰር ዋነኛ መንስኤ ናቸው።';

  @override
  String get stiTreatmentTitle => 'የ STI አያያዝ እና ሕክምና';

  @override
  String get stiTreatmentSubtitle => 'የሕክምና ዘዴዎች እና ለማገገም አስፈላጊ መመሪያዎች';

  @override
  String get stiTreatmentDesc1 =>
      'የባክቴሪያ እና የጥገኛ ተውሳክ STIs (ክላሚዲያ፣ ጨብጥ፣ ቂጥኝ፣ ትሪኮሞኒያሲስ) በታዘዙ አንቲባዮቲኮች ሙሉ በሙሉ ይድናሉ።';

  @override
  String get stiTreatmentDesc2 =>
      'የቫይረስ STIs (ሄርፒስ፣ HPV፣ ኤችአይቪ፣ ሄፓታይተስ ቢ) በአንቲባዮቲክስ አይድኑም፤ ነገር ግን ዘመናዊ የፀረ-ቫይረስ መድሃኒቶች ምልክቶችን ለመቆጣጠር እና ችግሮችን ለመከላከል ይረዳሉ።';

  @override
  String get stiTreatmentRule1 =>
      'ሁሉንም መድሃኒቶች ጨርሰው ይውሰዱ፦ ምልክቶቹ ቀድመው ቢጠፉም እንኳ የታዘዘውን ሙሉ መድሃኒት ይጨርሱ። መድሃኒት አለመጨረስ ባክቴሪያዎች መድሃኒትን እንዲላመዱ ያደርጋል።';

  @override
  String get stiTreatmentRule2 =>
      'የፍቅር አጋርዎን አብረው ያሳክሙ፦ በሽታው እርስ በእርስ እንዳይተላለፍ ሁለቱም አጋሮች በአንድ ጊዜ ህክምና ማግኘት አለባቸው።';

  @override
  String get stiTreatmentRule3 =>
      'በህክምና ወቅት ግንኙነት አያድርጉ፦ ሁለቱም አጋሮች መድሃኒቱን ጨርሰው ምልክቶች ሙሉ በሙሉ እስኪጠፉ ድረስ ከግብረ ሥጋ ግንኙነት ይቆጠቡ።';

  @override
  String get stiTreatmentRule4 =>
      'በራስዎ መድሃኒት አይውሰዱ፦ ያለ ሐኪም ትዕዛዝ ከተለመዱ ፋርማሲዎች መድሃኒት ገዝተው አይውሰዱ፤ የተሳሳተ መድሃኒት በሽታውን ሊያባብሰው ይችላል።';

  @override
  String get stiPreventionTitle => 'የ STI መከላከያ መንገዶች';

  @override
  String get stiPreventionSubtitle => 'ራስን እና የፍቅር አጋርን ለመጠበቅ የሚረዱ ተግባራዊ መንገዶች';

  @override
  String get stiPreventionIntro =>
      'ከ STIs ራስን ለመጠበቅ ተግባራዊ እና ቀጣይነት ያላቸው ጥንቃቄዎችን ማድረግ ያስፈልጋል፦';

  @override
  String get stiPreventionItem1 =>
      'ኮንዶምን ዘወትርና በትክክል መጠቀም፦ የላቴክስ እና የፖሊዩረቴን የወንድ እና የሴት ኮንዶሞች በትክክል ጥቅም ላይ ሲውሉ ከብዙዎቹ STIs ከፍተኛ ጥበቃ ያደርጋሉ።';

  @override
  String get stiPreventionItem2 =>
      'የጋራ ታማኝነት፦ ሁለቱም ከተመረመሩ በኋላ ላልተያዘ አንድ የፍቅር አጋር ብቻ ታማኝ መሆን።';

  @override
  String get stiPreventionItem3 =>
      'ከግንኙነት መታቀብ፦ ከግብረ ሥጋ ግንኙነት መታቀብ ከ STIs ለመጠበቅ 100% አስተማማኝ ብቸኛው መንገድ ነው።';

  @override
  String get stiPreventionItem4 =>
      'ክትባት መከተብ፦ የማህፀን በር ካንሰርን የሚከላከለው የ HPV ክትባት እና የሄፓታይተስ ቢ ክትባቶች ደህንነታቸው የተጠበቀና ውጤታማ ናቸው።';

  @override
  String get stiPreventionItem5 =>
      'መደበኛ ምርመራ ማድረግ፦ አዲስ ግንኙነት ከመጀመርዎ በፊት እና በግብረ ሥጋ ግንኙነት ንቁ ከሆኑ በየዓመቱ መመርመር።';

  @override
  String get stiPreventionItem6 =>
      'ከአልኮል እና ከአደንዛዥ ዕፅ መራቅ፦ ስካር ውሳኔ የመስጠት አቅምን ስለሚያዳክም ጥንቃቄ የጎደለው ግንኙነት ውስጥ የመግባት እድልን ይጨምራል።';

  @override
  String get substanceHeroDesc =>
      'የዕፅ ሱስ ማለት ጤናን፣ ባህሪን እና ማህበራዊ ግንኙነቶችን የሚጎዳ ጎጂ የመድሃኒት ወይም የአልኮል አጠቃቀም ሲሆን ወደ አካላዊ እና አእምሯዊ ችግሮች፣ ጥገኝነት እና በወቅቱ ካልተፈታ ወደ ከባድ የህይወት አደጋዎች ይመራል።';

  @override
  String get substanceNoteContent =>
      'የዕፅ ሱስ መከላከል እና መታከም የሚችል ነው—ቀደምት ምልክቶችን መገንዘብ እና እርዳታ መፈለግ ጤናዎን፣ ግንኙነትዎን እና የወደፊት ህይወትዎን ሊጠብቅ ይችላል።';

  @override
  String get substanceDefTitle => 'የዕፅ ሱስ ምንነት እና ትርጓሜ';

  @override
  String get substanceDefDesc1 =>
      'የዕፅ ሱስ ማለት አልኮልን እና ህገ-ወጥ እፆችን ጨምሮ በአእምሮ ላይ ተፅዕኖ የሚያሳድሩ ንጥረ ነገሮችን ከመጠን በላይ እና ጎጂ በሆነ መንገድ በግዴታ የመጠቀም ልምድ ነው። ይህ ባህሪ በግለሰብ ጤና፣ ማህበራዊ ግንኙነት እና ሀላፊነቶች ላይ ከፍተኛ አሉታዊ ተፅዕኖ ያሳድራል። ወደ አካላዊ እና ስነ-ልቦናዊ ጥገኝነት፣ የመላመድ እና መድሃኒቱን ሲያቆሙ ወደሚከሰቱ የህመም ስሜቶች ይመራል።';

  @override
  String get substanceDefDesc2 =>
      'በአእምሮ ላይ ተፅዕኖ የሚያሳድሩ ንጥረ ነገሮች (ሳይኮአክቲቭ) የአእምሮን አሰራር በመቀየር በስሜት፣ በንቃት፣ በአስተሳሰብ ወይም በባህሪ ላይ ለውጥ የሚያመጡ ናቸው። በብዛት ጥቅም ላይ የሚውሉት አልኮል፣ ካፌይን፣ ኒኮቲን፣ ማሪዋና (ካናቢስ) እና የተወሰኑ የህመም ማስታገሻ መድሃኒቶችን ያካትታሉ።';

  @override
  String get substanceDefDesc3 =>
      'የዕፅ አጠቃቀም ችግር (SUD) የአንድን ሰው አእምሮ እና ባህሪ የሚጎዳ የአእምሮ ጤና እክል ሲሆን ይህም ሰውዬው ህጋዊ ወይም ህገ-ወጥ እፆችን፣ አልኮልን ወይም መድሃኒቶችን እንዳይቆጣጠር ያደርገዋል።';

  @override
  String get substanceTypesTitle => 'የእፅ እና ንጥረ ነገሮች ዓይነቶች';

  @override
  String get substanceTypeDepressants =>
      'አእምሮን የሚያዘገዩ (ዲፕሬሰንትስ)፦ በማህበረሰቡ ውስጥ በብዛት የሚገኙት ዲፕሬሰንትስ ናቸው። አልኮል፣ ማስታገሻዎች እና እንቅልፍ አምጪ መድሃኒቶች።';

  @override
  String get substanceTypeStimulants =>
      'አነቃቂዎች (ስቲሙላንትስ)፦ ጉልበትን፣ ንቃትን እና እንቅልፍ ማጣትን ይጨምራሉ። እንደ ኒኮቲን (ሲጋራ)፣ ኮኬይን፣ አምፌታሚን እና ካፌይን።';

  @override
  String get substanceTypeOpioids =>
      'ኦፒዮይድስ (ህመም ማስታገሻዎች)፦ የደስታ ወይም የርካታ ስሜትን የሚፈጥሩ እና ከፍተኛ የህመም ማስታገሻ ውጤት ያላቸው ናቸው። ሄሮይን፣ ሞርፊን፣ ኦፒየም፣ ሜታዶን እና ኮዲን ያለበት የሳል ሽሮፕ።';

  @override
  String get substanceTypeHallucinogens =>
      'ቅዠት አምጪዎች (ሃሉሲኖጅንስ)፦ አንድ ሰው ጊዜን በተለየ መንገድ እንዲገነዘብ፣ ከአካባቢው የተነጠለ ስሜት እንዲሰማው ወይም ምናባዊ ነገሮችን እንዲያይ ያደርጋሉ።';

  @override
  String get substanceEffectsTitle => 'የዕፅ ሱስ የሚያስከትላቸው ጉዳቶች';

  @override
  String get substanceEffectsIntro =>
      'የዕፅ ሱስ በአንድ ሰው ህይወት ውስጥ ወደ ከባድ ችግሮች ወይም ጭንቀት የሚመራ የእፅ ወይም የአልኮል አጠቃቀም ልምድ ነው። ይህም በተለያዩ መንገዶች ይገለጻል፦';

  @override
  String get substanceEffect1 =>
      'ለበሽታዎች የመጋለጥ እድል መጨመር (የጉበት በሽታ፣ የልብ ህመም፣ የመተንፈሻ አካላት ችግር፣ ኤችአይቪ)';

  @override
  String get substanceEffect2 => 'የአእምሮ ጤና መታወክ፣ ለጭንቀት እና ድብርት የመጋለጥ እድል መጨመር።';

  @override
  String get substanceEffect3 => 'በእፅ አጠቃቀም ምክንያት ትምህርት ወይም ስራ መቅረት።';

  @override
  String get substanceEffect4 =>
      'በእፅ ተፅዕኖ ስር ሆነው አደገኛ እንቅስቃሴዎች ውስጥ መሳተፍ (ለምሳሌ መኪና መንዳት)።';

  @override
  String get substanceEffect5 => 'ከእፅ አጠቃቀም ጋር የተያያዙ ህጋዊ ችግሮች እና ቅጣቶች ማጋጠም።';

  @override
  String get substanceEffect6 =>
      'ከቤተሰብ እና ከጓደኞች ጋር የሚኖር ግንኙነት መበላሸት እና አለመግባባት።';

  @override
  String get substanceEffect7 =>
      'የዕፅ ሱስ ህገ-ወጥ እፆችን (እንደ ሄሮይን፣ ኮኬይን) እንዲሁም የታዘዙ መድሃኒቶችን አላግባብ መጠቀምን ያካትታል።';

  @override
  String get substanceSignsTitle => 'የዕፅ ሱስ ችግር መኖሩን የሚያሳዩ ምልክቶች';

  @override
  String get substanceSignsIntro =>
      'የባህሪ እና የአካላዊ ለውጦችን ቀድሞ መገንዘብ ግለሰቦች ከባድ ችግሮች ከመከሰታቸው በፊት ወቅታዊ እርዳታ እንዲያገኙ ይረዳል፦';

  @override
  String get substanceSign1 =>
      'የግዴታ ፍላጎት፦ ንጥረ ነገሩን በየቀኑ ወይም በቀን ውስጥ ብዙ ጊዜ ለመጠቀም የሚሰማ ከፍተኛ ጉጉት።';

  @override
  String get substanceSign2 =>
      'የመላመድ ሁኔታ፦ መጀመሪያ የተገኘውን ስሜት ለማግኘት ከጊዜ ወደ ጊዜ መጠኑን መጨመር ማስፈለግ።';

  @override
  String get substanceSign3 =>
      'መድሃኒቱን ሲያቆሙ የሚከሰት ህመም፦ እፁን ለማቆም ሲሞክሩ መንቀጥቀጥ፣ ላብ፣ ጭንቀት ወይም ማቅለሽለሽ ማጋጠም።';

  @override
  String get substanceSign4 =>
      'ሀላፊነትን መዘንጋት፦ በትምህርት፣ በስራ ወይም በቤተሰብ ውስጥ ያሉ ሀላፊነቶችን መወጣት አለመቻል።';

  @override
  String get substanceSign5 =>
      'ፍላጎቶችን መተው፦ ቀደም ሲል ያስደስቱ የነበሩ ስፖርቶችን፣ የትርፍ ጊዜ ማሳለፊያዎችን እና ማህበራዊ ግንኙነቶችን መተው።';

  @override
  String get substanceSign6 =>
      'ማህበራዊ መገለል እና ድብቅነት፦ ከቤተሰብ መራቅ፣ እፅን በሚስጥር መጠቀም እና ድንገተኛ የስሜት መለዋወጥ ማሳየት።';

  @override
  String get substanceSignsHelpAlert =>
      'የዕፅ አጠቃቀም ችግር የሚታከም የጤና ሁኔታ እንጂ የሞራል ድክመት አይደለም። የወጣቶች አማካሪዎች፣ የጤና ማዕከላት እና ነፃ የስልክ መስመሮች (952 ወይም 8335) ሚስጥራዊ እና ሩህሩህ ድጋፍ ይሰጣሉ።';

  @override
  String get substanceQuizTitle => 'የአደንዛዥ ዕፅ ሱስ ፈተና';

  @override
  String get substanceQ1Text =>
      'የዕፅ ሱስ ወይም የአደንዛዥ ዕፅ ሱሰኝነት የፈቃድ ደካማነት ወይም የሞራል ውድቀት ሳይሆን ህክምና የሚደረግለት የአዕምሮ እና የባህሪ የህክምና ሁኔታ ነው?';

  @override
  String get substanceQ1Insight =>
      'የዕፅ ሱሰኝነት በአዕምሮ ኬሚስትሪ እና ሽልማት መቀበያ መንገዶች ላይ ለውጥ ያመጣል። በህክምና ባለሙያዎች ዘንድ እውቅና የተሰጠው ሲሆን በህክምና፣ በምክር እና በማህበራዊ ድጋፍ ማገገም ይቻላል።';

  @override
  String get substanceQ2Text =>
      'ማዕከላዊ የነርቭ ሥርዓትን፣ የልብ ምትን እና የአዕምሮ እንቅስቃሴን የሚያዘገየው የዕፅ ክፍል የትኛው ነው (እንደ አልኮል እና ማረጋጊያ መድሃኒቶች)?';

  @override
  String get substanceQ2OptA => 'አዘግይ/አረጋጊዎች (Depressants)';

  @override
  String get substanceQ2OptB => 'አነቃቂዎች (Stimulants)';

  @override
  String get substanceQ2OptC => 'ቅዠት አምጪዎች (Hallucinogens)';

  @override
  String get substanceQ2OptD => 'ቫይታሚኖች (Vitamins)';

  @override
  String get substanceQ2Insight =>
      'አዘግይ/አረጋጊዎች የነርቭ መልእክቶችን እና የልብ ምትን በማዘግየት ንቃትን ይቀንሳሉ፤ በተቃራኒው አነቃቂዎች የነርቭ ስርዓትን ያፋጥናሉ።';

  @override
  String get substanceQ3Text =>
      'አንድ ሰው አልኮልን ወይም አደንዛዥ ዕፆችን አዘውትሮ ሲጠቀም \"ቶለራንስ (መላመድ)\" ማለት ምን ማለት ነው?';

  @override
  String get substanceQ3OptA =>
      'የመጀመሪያውን ስሜት ለማግኘት በጊዜ ሂደት መጠኑን በከፍተኛ ሁኔታ መጨመር ማስፈለጉ';

  @override
  String get substanceQ3OptB => 'ዕፁ ከአንድ አጠቃቀም በኋላ ከሰውነት ሙሉ በሙሉ መወገዱ';

  @override
  String get substanceQ3OptC => 'ሰውየው ያለ ምንም ምልክት ወዲያውኑ መጠቀም ማቆም መቻሉ';

  @override
  String get substanceQ3OptD => 'ለማንኛውም ኬሚካል ተፈጥሯዊ የመከላከል አቅም መኖር';

  @override
  String get substanceQ3Insight =>
      'መላመድ (Tolerance) የሚከሰተው የአዕምሮ ህዋሳት ከአደንዛዥ ዕፁ ጋር ሲላመዱ ሲሆን ይህም ተጠቃሚው የቀድሞውን ስሜት ለማግኘት መጠኑን እንዲጨምር ያደርገዋል።';

  @override
  String get substanceQ4Text =>
      'የአደንዛዥ ዕፅ ሱስ መከላከል እና ማከም የሚቻል ሲሆን ነፃ የጤና ስልክ መስመሮችን (952 ወይም 8335) መደወል ወጣቶችን ከሚስጥራዊ የባለሙያ ድጋፍ ጋር ያገናኛል?';

  @override
  String get substanceQ4Insight =>
      'በጊዜ የሚደረግ ድጋፍ ህይወትን ይታደጋል። ነፃ የጤና ስልክ መስመሮች (952 ወይም 8335) ወጣቶችን ከተቆረቋሪ ባለሙያዎች፣ ከወጣቶች ማዕከላት እና ከማገገሚያ መመሪያዎች ጋር ያገናኛሉ።';

  @override
  String get mentalHealthHeroDesc =>
      'የአእምሮ ጤና ከአጠቃላይ ጤና ጋር በእጅጉ የተቆራኘ ሲሆን ስሜታዊ፣ ስነ-ልቦናዊ እና ማህበራዊ ደህንነትን ያካትታል። በህይወት ዘመናችን ሁሉ እንዴት እንደምናስብ፣ እንደምንሰማ፣ ውጥረትን እንደምንቆጣጠር፣ ከሌሎች ጋር እንደምንገናኝ እና ውሳኔ እንደምንሰጥ ይወስናል።';

  @override
  String get mentalHealthNoteContent =>
      'የአእምሮ ጤና ሊንከባከብ እና ሊድን የሚችል ነው—በአስቸጋሪ ጊዜያት ድጋፍ መፈለግ የጥንካሬ እና የድፍረት ምልክት እንጂ የድክመት ምልክት አይደለም።';

  @override
  String get mentalHealthSection1Title => 'ስለ አእምሮ ጤና እና ደህንነት መረዳት';

  @override
  String get mentalHealthSection1Desc1 =>
      'የአእምሮ ጤና ስሜታዊ፣ ስነ-ልቦናዊ እና ማህበራዊ ደህንነታችንን ያጠቃልላል። የዕለት ተዕለት ፈተናዎችን እንዴት እንደምንወጣ፣ ከቤተሰብ እና ከጓደኞች ጋር ያለንን ግንኙነት እና ጤናማ የአኗኗር ውሳኔዎችን እንዴት እንደምንወስን ይወስናል።';

  @override
  String get mentalHealthSection1Desc2 =>
      'ጥሩ የአእምሮ ጤና ማለት ሁልጊዜ ደስተኛ መሆን ማለት አይደለም። ይልቁንም ሀዘንን፣ ንዴትን፣ ጭንቀትን እና ደስታን ሚዛናዊ በሆነ መንገድ የመቋቋም ስሜታዊ ብርታት ማዳበር ማለት ነው።';

  @override
  String get mentalHealthSection1Alert =>
      'የአእምሮ ጤና ልክ እንደ አካላዊ ጤና እኩል አስፈላጊ ነው። አእምሮ እና አካል በጥብቅ የተሳሰሩ ናቸው፦ ያልተቋረጠ አካላዊ ህመም ስሜትን ይጎዳል፣ ሥር የሰደደ ውጥረትም በቀጥታ የአካል ህመምን ያስከትላል።';

  @override
  String get mentalHealthSection2Title => 'በወጣቶች ላይ የሚከሰቱ የተለመዱ የአእምሮ ጤና ፈተናዎች';

  @override
  String get mentalHealthSection2Intro =>
      'ወጣቶች በህይወት የሽግግር ወቅት፣ በአካላዊ ለውጦች እና በማህበራዊ ጫናዎች ውስጥ ያልፋሉ። የተለመዱ ፈተናዎች የሚከተሉትን ያካትታሉ፦';

  @override
  String get mentalHealthChallenge1 =>
      'የትምህርት ጭንቀት እና ድካም፦ ስለ ውጤት፣ ፈተናዎች እና ስለ ወደፊት ህይወት የሚሰማ ከልክ ያለፈ ፍርሃትና ጭንቀት።';

  @override
  String get mentalHealthChallenge2 =>
      'አጠቃላይ እና ማህበራዊ ጭንቀት፦ በማህበራዊ ግንኙነቶች ውስጥ የማያቋርጥ ፍርሃት፣ የሌሎችን ትችት መፍራት እና የማያቋርጥ የፍርሃት ስሜት።';

  @override
  String get mentalHealthChallenge3 =>
      'የድብርት ስሜት እና የከፋ ሀዘን፦ ተስፋ የመቁረጥ፣ የባዶነት ስሜት፣ በሚወዷቸው እንቅስቃሴዎች ላይ ፍላጎት ማጣት እና የጉልበት ማነስ።';

  @override
  String get mentalHealthChallenge4 =>
      'የእኩዮች ጫና እና የኢንተርኔት ትንኮሳ፦ ወደ ጎጂ ባህሪያት እንዲገቡ የሚደረግ ጫና ወይም በማህበራዊ ሚዲያ የሚደርስ ትንኮሳ።';

  @override
  String get mentalHealthSection3Title => 'ውጥረትን የመቋቋሚያ እና ራስን የመንከባከቢያ ዘዴዎች';

  @override
  String get mentalHealthSection3Intro =>
      'የዕለት ተዕለት ጤናማ ልምዶችን ማዳበር ከአእምሮ ውጥረት ይጠብቃል እንዲሁም ስሜታዊ ጥንካሬን ይገነባል፦';

  @override
  String get mentalHealthStrategy1 =>
      'የዕለት ተዕለት አካላዊ እንቅስቃሴ፦ በቀን ለ 30 ደቂቃ በእግር መጓዝ፣ ሩጫ ወይም ስፖርት መስራት ስሜትን የሚያነቃቁ ሆርሞኖችን (ኢንዶርፊን) ያመነጫል።';

  @override
  String get mentalHealthStrategy2 =>
      'በቂ እና ጤናማ እንቅልፍ፦ በቀን ከ 7 እስከ 9 ሰዓታት መተኛት ስሜትን፣ ትውስታን እና ትኩረትን ያረጋጋል።';

  @override
  String get mentalHealthStrategy3 =>
      'የአተነፋፈስ እና የመረጋጋት ልምምድ፦ በጥልቀት መተንፈስ፣ ጸጥታን መለማመድ እና ማሰላሰል በውጥረት ወቅት የነርቭ ስርዓትን ያረጋጋሉ።';

  @override
  String get mentalHealthStrategy4 =>
      'ስሜትን የመግለጫ መንገዶች፦ ስሜትን በማስታወሻ ላይ መጻፍ፣ ስነ-ጥበብ፣ ሙዚቃ ወይም ጸሎት ስሜትን ለማስተንፈስ ይረዳሉ።';

  @override
  String get mentalHealthStrategy5 =>
      'ጤናማ ወሰን ማበጀት፦ አቅም በላይ ለሆኑ ጥያቄዎች \'አይሆንም\' ማለት እና አድካሚ የማህበራዊ ሚዲያ አጠቃቀምን መገደብ።';

  @override
  String get mentalHealthSection4Title => 'የአእምሮ ጭንቀት ምልክቶችን መገንዘብ እና ድጋፍ መፈለግ';

  @override
  String get mentalHealthSection4Intro =>
      'ውጥረት ወይም ሀዘን የባለሙያ ድጋፍ የሚያስፈልገው ደረጃ ላይ መድረሱን ማወቅ አስፈላጊ ነው፦';

  @override
  String get mentalHealthSign1 =>
      'ከማህበራዊ ህይወት መራቅ፦ ለሳምንታት ከጓደኞች፣ ከቤተሰብ እና ከማህበራዊ እንቅስቃሴዎች ሙሉ በሙሉ መገለል።';

  @override
  String get mentalHealthSign2 =>
      'ከፍተኛ የስሜት መለዋወጥ፦ ድንገተኛ የባህሪ ለውጥ፣ ያልተለመደ የቁጣ ፍንዳታ ወይም ከፍተኛ የተስፋ መቁረጥ ስሜት።';

  @override
  String get mentalHealthSign3 =>
      'የእንቅልፍ ወይም የምግብ ፍላጎት ለውጥ፦ ከፍተኛ እንቅልፍ ማጣት፣ ቀኑን ሙሉ መተኛት ወይም ከፍተኛ የክብደት ለውጥ።';

  @override
  String get mentalHealthSign4 =>
      'ወደ አደንዛዥ እፆች ማዘንበል፦ ከአስቸጋሪ ስሜቶች ለማምለጥ በአልኮል፣ በጫት ወይም በእፆች ላይ ጥገኛ መሆን።';

  @override
  String get mentalHealthSign5 =>
      'ራስን የመጉዳት ሀሳቦች፦ የመጥፋት፣ ራስን የመጉዳት ወይም የከፋ የተስፋ መቁረጥ ሀሳቦች ማሰላሰል።';

  @override
  String get mentalHealthHelpAlert =>
      'የስሜት ህመምን ብቻዎን መሸከም አይኖርብዎትም። ከተረጋገጡ የወጣቶች አማካሪዎች ጋር መነጋገር ወይም በነፃ የስልክ መስመሮች (952 ወይም 8335) መደወል ፍጹም ሚስጥራዊ እና ሩህሩህ ድጋፍ ይሰጥዎታል።';

  @override
  String get mentalHealthQuizTitle => 'የአእምሮ ጤና እና ደህንነት ፈተና';

  @override
  String get mentalHealthQ1Text =>
      'የአእምሮ ጤና ልክ እንደ አካላዊ ጤና እኩል አስፈላጊ ሲሆን የስሜት ቀውስ ማጋጠም የጤና ሁኔታ እንጂ የግል ድክመት አይደለም?';

  @override
  String get mentalHealthQ1Insight =>
      'የአእምሮ ጤና የአጠቃላይ ጤና መሰረት ነው። በስሜት ቀውስ ወቅት ድጋፍ መፈለግ ለጤና የሚወሰድ ሃላፊነት የተሞላበት የጀግንነት እርምጃ ነው።';

  @override
  String get mentalHealthQ2Text =>
      'የዕለት ተዕለት ውጥረትን እና የስሜት ጫናን ለመቆጣጠር ጤናማ እና ውጤታማ የሆነው መንገድ የትኛው ነው?';

  @override
  String get mentalHealthQ2OptA =>
      'መደበኛ የአካል ብቃት እንቅስቃሴ ማድረግ፣ በጥልቀት መተንፈስ እና ከ 7-9 ሰዓት መተኛት';

  @override
  String get mentalHealthQ2OptB => 'ክፍል ውስጥ ብቻውን ተዘግቶ መቆየት እና ከማንም ጋር አለመነጋገር';

  @override
  String get mentalHealthQ2OptC => 'ከስሜት ለማምለጥ አልኮል ወይም እፅ መጠቀም';

  @override
  String get mentalHealthQ2OptD => 'ምግብ አለመብላት እና ሌሊቱን ሙሉ ባለመተኛት ማሳለፍ';

  @override
  String get mentalHealthQ2Insight =>
      'የአካል ብቃት እንቅስቃሴ ስሜትን የሚያሻሽሉ ሆርሞኖችን ያመነጫል፣ በቂ እንቅልፍ እና ጥልቅ አተነፋፈስም የነርቭ ስርዓትን ያረጋጋሉ።';

  @override
  String get mentalHealthQ3Text =>
      'ጥሩ የአእምሮ ጤና ማለት በህይወትዎ ውስጥ በሁሉም ቅጽበት ደስተኛ እና ቀናተኛ መሆን አለብዎት ማለት ነው?';

  @override
  String get mentalHealthQ3Insight =>
      'ጥሩ የአእምሮ ጤና ሁሉንም የሰው ልጅ ስሜቶች (ሀዘንን፣ ብስጭትን እና ጭንቀትን ጨምሮ) መለማመድ እና እነሱን ለማስተናገድ ጤናማ ዘዴዎች እንዲኖሩን ማድረግ ነው።';

  @override
  String get mentalHealthQ4Text =>
      'እርስዎ ወይም ጓደኛዎ ለሳምንታት በከባድ ሀዘን ወይም ጭንቀት ከተዋጡ የተሻለው እርምጃ ምንድነው?';

  @override
  String get mentalHealthQ4OptA =>
      'የሚተማመኑትን አማካሪ፣ የወጣቶች አሰልጣኝ ማነጋገር ወይም በነፃ መስመሮች 952 / 8335 መደወል';

  @override
  String get mentalHealthQ4OptB =>
      'ሙሉ በሙሉ በሚስጥር መያዝ እና በራሱ ጊዜ ይጠፋል ብሎ ተስፋ ማድረግ';

  @override
  String get mentalHealthQ4OptC => 'ጓደኛውን በሀዘኑ ማሾፍ እና መተቸት';

  @override
  String get mentalHealthQ4OptD => 'ትምህርትን መተው እና ምግብ አለመብላት';

  @override
  String get mentalHealthQ4Insight =>
      'ከወጣቶች አማካሪዎች ጋር ቀድሞ መነጋገር ወይም በነፃ የስልክ መስመሮች (952 ወይም 8335) መደወል ሚስጥራዊ እና ህይወት አድን ድጋፍ ይሰጣል።';

  @override
  String get learningSectionsTitle => 'የትምህርት ክፍሎች';

  @override
  String readSectionsCount(int count, int total) {
    return '$count / $total ተነቧል';
  }

  @override
  String get hivDefinitionTitle => 'ትርጓሜ';

  @override
  String get hivDefinitionSubtitle =>
      'ኤችአይቪ/ኤድስ ምንድን ነው እና የሰውነትን በሽታ የመከላከል አቅም እንዴት ይጎዳል';

  @override
  String get hivDefinitionDesc1 =>
      'ኤችአይቪ (የሰውነት በሽታ መከላከያ አቅም ማነስ ቫይረስ) በሰውነታችን ውስጥ ኢንፌክሽኖችን ለመዋጋት የሚረዱትን የሲዲ4 (CD4) ነጭ የደም ሴሎችን የሚያጠቃ ቫይረስ ነው።';

  @override
  String get hivDefinitionDesc2 =>
      'ተገቢው ህክምና ካልተደረገለት ኤችአይቪ የሲዲ4 ሴሎችን ቀስ በቀስ በማውደም ወደ ኤድስ (የተገኘ የበሽታ መከላከያ አቅም ማጣት ደረጃ) ሊሸጋገር ይችላል።';

  @override
  String get hivDefinitionDesc3 =>
      'በዘመናዊ የፀረ-ኤችአይቪ ህክምና (ART) አማካኝነት ቫይረሱን በደም ውስጥ እንዳይታወቅ በማድረግ ጤናማ እና ረጅም ዕድሜ መኖር ይቻላል (የማይታወቅ = የማይተላለፍ ወይም U=U)።';

  @override
  String get hivTransmissionTitle => 'የመተላለፊያ መንገዶች';

  @override
  String get hivTransmissionSubtitle =>
      'ቫይረሱ እንዴት ይተላለፋል እና የተሳሳቱ ግንዛቤዎች ማስተካከያ';

  @override
  String get hivTransmissionIntro =>
      'ኤችአይቪ የሚተላለፈው ቫይረሱ በደሙ ውስጥ ካለ ሰው የሰውነት ፈሳሾች ጋር በሚኖር ቀጥተኛ ንክኪ ነው፦';

  @override
  String get hivTransmissionItem1 =>
      'ጥንቃቄ የጎደለው የግብረ-ሥጋ ግንኙነት (ያለ ኮንዶም የሚደረግ ግንኙነት)።';

  @override
  String get hivTransmissionItem2 =>
      'የተበከሉ መርፌዎችን፣ ምላጮችን እና ስለታም የመበሻ ቁሳቁሶችን በጋራ መጠቀም።';

  @override
  String get hivTransmissionItem3 =>
      'ከእናት ወደ ልጅ በእርግዝና፣ በወሊድ ወይም በማጥባት ወቅት (በቅድመ-ወሊድ PMTCT ክትትል ሙሉ በሙሉ መከላከል ይቻላል)።';

  @override
  String get hivTransmissionItem4 =>
      'ያልተመረመረ ደም በመውሰድ (በሆስፒታሎች ጥብቅ ምርመራ ምክንያት እጅግ በጣም ያልተለመደ ነው)።';

  @override
  String get hivNotTransmittedTitle => 'ኤችአይቪ በማይተላለፍባቸው መንገዶች፦';

  @override
  String get hivNotTransmittedDesc =>
      'ኤችአይቪ ከሰውነት ውጭ ሊቆይ አይችልም። በእጅ መጨባበጥ፣ ማቀፍ፣ ሳል፣ ማስነጠስ፣ መጸዳጃ ቤት ወይም የምግብ ዕቃዎችን በጋራ በመጠቀም እንዲሁም በወባ ትንኝ ንክሻ ፈጽሞ አይተላለፍም።';

  @override
  String get hivPreventionTitle => 'የኤችአይቪ መከላከያ መንገዶች';

  @override
  String get hivPreventionIntro =>
      'ራስን ከኤችአይቪ መጠበቅ ቫይረሱ እንዴት እንደሚተላለፍ ከመረዳት ይጀምራል። አንዳንድ የኤችአይቪ መከላከያ ዘዴዎች እንደሚከተለው ተብራርተዋል፦';

  @override
  String get hivMethodA => 'ከጋብቻ በፊት ከግብረ-ሥጋ ግንኙነት መታቀብ (ግንኙነት አለማድረግ)';

  @override
  String get hivMethodB => 'ከተመረመሩ በኋላ ለአንድ የፍቅር አጋር ብቻ ታማኝ መሆን።';

  @override
  String get hivMethodC =>
      'በማንኛውም ጊዜ በሚደረግ የግብረ-ሥጋ ግንኙነት ኮንዶምን ዘወትርና በትክክል መጠቀም።';

  @override
  String get hivMethodD =>
      'ስለታም ቁሳቁሶችን ከሌሎች ሰዎች ጋር አለመጋራት እንዲሁም በአግባቡ መጠቀምና ማስወገድ።';

  @override
  String get hivAdditionalPreventionIntro =>
      'ከላይ ከተጠቀሱት የመከላከያ ዘዴዎች በተጨማሪ የሚከተሉትም ኤችአይቪን ለመከላከል ያገለግላሉ፦';

  @override
  String get hivMethodE =>
      'ቫይረሱ ወደ ፅንሱ እንዳይተላለፍ ኤችአይቪ በደማቸው ለሚገኝ ነፍሰጡር እናቶች የፀረ-ኤችአይቪ ህክምና መስጠት።';

  @override
  String get hivMethodF =>
      'የቅድመ-ተጋላጭነት መከላከያ መድሃኒት (PrEP) - ለኤችአይቪ ከፍተኛ ተጋላጭ ለሆኑ ሰዎች የሚሰጥ ሲሆን ለቫይረሱ ከመጋለጣቸው በፊት ይሰጣል።';

  @override
  String get prepDesc =>
      'የቅድመ-ተጋላጭነት መከላከያ መድሃኒት (PrEP) የኤችአይቪ ኢንፌክሽን ተጋላጭነትን ለመቀነስ የሚወሰድ መድሃኒት ነው። PrEP የሚከላከለው ከኤችአይቪ ብቻ ስለሆነ፣ ከሌሎች አባለዘር በሽታዎች ለመከላከል የኮንዶም አጠቃቀም አሁንም አስፈላጊ ነው። ለኤችአይቪ ከፍተኛ ተጋላጭ ለሆኑ ሰዎች ይሰጣል። ይህ አገልግሎት በጤና ጣቢያዎችና በሆስፒታሎች ባሉ የመንግስት ጤና ተቋማት ውስጥ ይገኛል።';

  @override
  String get watchOnYouTube => 'በዩቲዩብ ይመልከቱ';

  @override
  String get cinemaMode => 'ሲኒማ እይታ';

  @override
  String get playInline => 'በመተግበሪያው ውስጥ ይመልከቱ';

  @override
  String get closePlayer => 'ቪዲዮውን ዝጋ';

  @override
  String get playingInApp => 'በመተግበሪያው ውስጥ እየተጫወተ ነው';

  @override
  String get returnToLesson => 'ወደ ትምህርቱ ተመለስ';

  @override
  String get hivQuizTitle => 'የኤችአይቪ ትምህርት ፈተና';

  @override
  String get nextQuestionBtn => 'ቀጣይ';

  @override
  String get finishQuizBtn => 'ፈተናውን ጨርስ';

  @override
  String get retakeQuizBtn => 'እንደገና ፈትን';

  @override
  String get reviewAnswersBtn => 'መልሶችን ከልስ';

  @override
  String get quizScoreCelebration => 'እጅግ በጣም ጥሩ!';

  @override
  String quizScoreSummary(int score, int total, int percent) {
    return 'ከ $total ጥያቄዎች $score በትክክል መልሰዋል ($percent%)';
  }

  @override
  String get selectAnOptionHint => 'እባክዎን ለመቀጠል መልስ ይምረጡ';

  @override
  String get educationalInsight => 'ጠቃሚ የህክምና መረጃ';

  @override
  String get trueOption => 'እውነት';

  @override
  String get falseOption => 'ሐሰት';

  @override
  String get hivQ1Text =>
      'ኤችአይቪ የሰውነትን በሽታ የመከላከል አቅም (ሲዲ4 ሴሎችን) በማጥቃት ሌሎች ኢንፌክሽኖችን ለመዋጋት አስቸጋሪ ያደርጋል?';

  @override
  String get hivQ1Insight =>
      'ኤችአይቪ የሲዲ4 ነጭ የደም ሴሎችን ያጠቃል። ያለ ፀረ-ኤችአይቪ ህክምና ሰውነት ኢንፌክሽኖችን መዋጋት ይሳነዋል።';

  @override
  String get hivQ2Text => 'ከሚከተሉት ውስጥ ስለ ኤችአይቪ መተላለፊያ መንገዶች ትክክል የሆነው የትኛው ነው?';

  @override
  String get hivQ2OptA => 'ጥንቃቄ የጎደለው የግብረ-ሥጋ ግንኙነት';

  @override
  String get hivQ2OptB => 'ኤችአይቪ በደሟ ያለ እናት ወደ ፅንስ ወይም ህፃን';

  @override
  String get hivQ2OptC => 'አብሮ መመገብ';

  @override
  String get hivQ2OptD => 'ሀ እና ለ';

  @override
  String get hivQ2Insight =>
      'ኤችአይቪ የሚተላለፈው በግብረ-ሥጋ ግንኙነት እና ከእናት ወደ ልጅ ነው፤ ነገር ግን ምግብ በመጋራት ፈጽሞ አይተላለፍም።';

  @override
  String get hivQ3Text =>
      'ኤችአይቪ በወባ ትንኝ ንክሻ፣ በማቀፍ ወይም መጸዳጃ ቤቶችን በጋራ በመጠቀም ሊተላለፍ ይችላል?';

  @override
  String get hivQ3Insight =>
      'ኤችአይቪ ከሰውነት ፈሳሽ ውጭ ወይም በነፍሳት ውስጥ መኖር አይችልም። ማህበራዊ ግንኙነቶች ፍጹም ደህና ናቸው።';

  @override
  String get hivQ4Text =>
      'ለኤችአይቪ ከተጋለጡ በኋላ ድንገተኛ መከላከያ መድሃኒት (PEP) በስንት ሰዓታት ውስጥ መጀመር አለበት?';

  @override
  String get hivQ4OptA => 'በ24 ሰዓታት ውስጥ ብቻ';

  @override
  String get hivQ4OptB => 'በ72 ሰዓታት (3 ቀናት) ውስጥ';

  @override
  String get hivQ4OptC => 'በ1 ወር ውስጥ';

  @override
  String get hivQ4OptD => 'PEP የሚወሰደው ከመጋለጥ በፊት ብቻ ነው';

  @override
  String get hivQ4Insight =>
      'PEP ለቫይረሱ ከተጋለጡ በኋላ በ72 ሰዓታት ውስጥ መጀመር ያለበት የድንገተኛ ጊዜ መድሃኒት ነው።';

  @override
  String get hivQ5Text =>
      'ከላቴክስ ኮንዶም ጋር በደህና ጥቅም ላይ ሊውሉ የሚችሉ ማለስለሻዎች የትኞቹ ናቸው?';

  @override
  String get hivQ5OptA => 'የፔትሮሊየም ቅባት (ቫዝሊን) እና የህጻናት ዘይት';

  @override
  String get hivQ5OptB => 'የሰውነት ሎሽን እና ቅቤ';

  @override
  String get hivQ5OptC => 'በውሃ ወይም በሲሊኮን የተሰሩ ማለስለሻዎች ብቻ';

  @override
  String get hivQ5OptD => 'የማብሰያ ዘይቶች';

  @override
  String get hivQ5Insight =>
      'በዘይት የተሰሩ ቅባቶች የላቴክስ ኮንዶምን ስለሚያዳክሙ በውሃ ወይም በሲሊኮን የተሰሩ ማለስለሻዎችን ብቻ ይጠቀሙ።';

  @override
  String get hivQ6Text =>
      'ኤችአይቪ በደማቸው ያለባቸው ሰዎች የ ART ህክምና ወስደው የቫይረሱ መጠን እንዳይታወቅ ሲሆን (Undetectable) ቫይረሱ በግብረ-ሥጋ ግንኙነት አይተላለፍም (U=U)።';

  @override
  String get hivQ6Insight =>
      'የተረጋገጠ ሳይንሳዊ ማስረጃ እንደሚያሳየው የማይታወቅ = የማይተላለፍ (U=U) ነው። ART መውሰድ ጤናን ከመጠበቅ ባለፈ ቫይረሱ እንዳይተላለፍ ያደርጋል።';

  @override
  String get moduleComingSoon => 'ሙሉ የትምህርት ክፍሎች እና ፈተናዎች ለቀጣዩ ደረጃ እየተዘጋጁ ነው።';

  @override
  String get watchVideo => 'ቪዲዮ ይመልከቱ';

  @override
  String get waysToPreventHiv => 'የኤችአይቪ መከላከያ መንገዶች';

  @override
  String get hivTesting => 'የኤችአይቪ ምርመራ';

  @override
  String get treatmentForHivPositive => 'ኤችአይቪ በደማቸው ለሚገኝባቸው የሚሰጥ ህክምና';

  @override
  String get pepTitle =>
      'ድህረ-ተጋላጭነት መከላከያ መድሃኒት (PEP) -ለኤችአይቪ ተጋላጭ ለሆኑ ሰዎች የሚሰጥ።';

  @override
  String get pepDesc =>
      'PEP ማለት ከኤችአይቪ ቫይረስ ጋር ንክኪ ከተፈጠረ በኋላ ቫይረሱ በሰውነት ውስጥ እንዳይሰራጭ የሚሰጥ ድንገተኛ መከላከያ ነው። PEP መውሰድ ያለበት ተጋላጭነቱ በተፈጠረ በ72 ሰዓታት (3 ቀናት) ውስጥ ነው።';

  @override
  String get condomStepsTitle =>
      'ኮንዶምን በአስር ደረጃዎች የመጠቀም ዘዴ - ዕድሜያቸው ከ18 ዓመት በላይ ለሆኑ';

  @override
  String get condomStepsSubtitle =>
      'ኮንዶም እንዳይቀደድ ወይም እንዳይወልቅ የሚከተሉትን 10 ደረጃዎች ይከተሉ። ቪዲዮው እነዚህን ደረጃዎች ያሳያል።';

  @override
  String get condomStep1 => 'የአገልግሎት ማብቂያ ቀኑን ያረጋግጡ። ጊዜው ያለፈበትን ኮንዶም አይጠቀሙ።';

  @override
  String get condomStep2 => 'ፓኬቱን በጣቶችዎ ይጫኑ። በውስጡ የአየር ግፊት ካልተሰማዎት አይጠቀሙበት።';

  @override
  String get condomStep3 =>
      'የኮንዶሙን ፓኬት ከዳር በኩል በእጅዎ ይቅደዱ እና ኮንዶሙን ያውጡ። ኮንዶሙ እንዳይቀደድ በጥርሶችዎ ወይም በስለት ነገሮች አይክፈቱ።';

  @override
  String get condomStep4 => 'ኮንዶሙ ወደ የትኛው አቅጣጫ እንደሚዘረጋ ይለዩ።';

  @override
  String get condomStep5 => 'አየር ለማስወጣት የኮንዶሙን የላይኛውን ጫፍ ቆንጠጥ አድርገው ይያዙ።';

  @override
  String get condomStep6 => 'የኮንዶሙን ጫፍ እንደያዙ በብልቱ ጫፍ ላይ ያስቀምጡት።';

  @override
  String get condomStep7 => 'ኮንዶሙን እስከ ብልቱ ስር ድረስ ወደ ታች ይዘርጉት።';

  @override
  String get condomStep8 => 'ግንኙነት ያድርጉ።';

  @override
  String get condomStep9 => 'ብልቱ እንደቆመ የኮንዶሙን ስር አጥብቀው በመያዝ ያውጡ።';

  @override
  String get condomStep10 => 'ኮንዶሙን ከብልት ላይ አውልቀው በአግባቡ በቆሻሻ መጣያ ውስጥ ያስወግዱ።';

  @override
  String get hivTestingDesc =>
      'የኤችአይቪ ምርመራ አገልግሎት የምክር፣ የምርመራ እንዲሁም ከተገቢው የኤችአይቪ መከላከያ፣ ህክምና እና ክብካቤ ጋር የማስተሳሰር ሙሉ አገልግሎትን ያጠቃልላል። የሚከተሉት የኤችአይቪ ምርመራ ዘዴዎች ናቸው።';

  @override
  String get pitcTitle => 'በጤና ባለሙያ የሚመከር ምርመራ እና ምክር (PITC)፦ ';

  @override
  String get pitcDesc =>
      'ወደ ጤና ተቋም በሚደረግ ጉብኝት ወቅት በጤና ባለሙያ የሚመከር እና የሚሰጥ የኤችአይቪ ምርመራ እና የምክር አገልግሎት ነው።';

  @override
  String get vctTitle => 'በፈቃደኝነት ላይ የተመሰረተ የምክር እና ምርመራ አገልግሎት (VCT)፦ ';

  @override
  String get vctDesc =>
      'ግለሰቦች የኤችአይቪ የጤና ሁኔታቸውን ለማወቅ በራሳቸው ፍላጎት የሚያደርጉት ምርመራ ነው።';

  @override
  String get artDesc1 =>
      'ኤችአይቪ በደማቸው የሚገኝባቸው ሰዎች የፀረ-ኤችአይቪ መድሃኒት (ART) በተቻለ ፍጥነት መጀመር አለባቸው። ይህ መድሃኒት ቫይረሱ በሰውነታቸው ውስጥ እንዳይባዛ ያደርጋል። አንድ ሰው ART ሲወስድ የቫይረሱ መጠን ይቀንሳል እንዲሁም የበሽታ መከላከል አቅማቸው ይጠነክራል።';

  @override
  String get artDesc2 =>
      'ህፃናትን፣ ወጣቶችን እና አዋቂዎችን ጨምሮ ቫይረሱ ያለባቸው ሰዎች በሙሉ ውጤቱን ባወቁ ቅጽበት ህክምናውን መጀመር አለባቸው። ህክምናውን ቀድሞ መጀመር ረጅም እድሜ እንዲኖሩ፣ ጤናማ እንዲሆኑ እና ቫይረሱ ወደ ሌሎች እንዳይተላለፍ ይረዳል። ሌሎች ተጓዳኝ በሽታዎችንም ይከላከላል።';

  @override
  String get artDesc3 =>
      'የ ART አገልግሎት እንደ ጤና ጣቢያ እና ሆስፒታል ባሉ የመንግስት ጤና ተቋማት ውስጥ በነጻ ይሰጣል።';

  @override
  String get markCompleted => 'እንደተጠናቀቀ ምልክት አድርግ';

  @override
  String get moduleCompletedSuccess => 'የትምህርት ክፍሉ በተሳካ ሁኔታ ተጠናቋል!';

  @override
  String get videoDialogTitle => 'ትምህርታዊ ቪዲዮ';

  @override
  String get lubricantsVideoDesc =>
      'የኮንዶም ጥንቃቄ ማሳያ፡- የፔትሮሊየም ቅባት (ቫዝሊን)፣ የህጻናት ዘይትና የሰውነት ሎሽኖች የላቴክስ ኮንዶምን ስለሚያዳክሙና ስለሚቀዱ ፈጽሞ መጠቀም የለብንም። በውሃ ወይም በሲሊኮን የተሰሩ ማለስለሻዎችን ብቻ ይጠቀሙ።';

  @override
  String get counsellingVideoDesc =>
      'ትክክለኛ የኮንዶም አጠቃቀም፣ ተገቢውን መጠን መምረጥ እንዲሁም ከአባለዘር በሽታዎች እና ካልታቀደ እርግዝና ለመከላከል የሚያስችል የባለሙያ ማሳያ እና ምክር።';

  @override
  String get closeButton => 'ዝጋ';

  @override
  String get viewProfile => 'መገለጫ ይመልከቱ';

  @override
  String get viewProfileSubtitle => 'ማንነት • ዕድሜ';

  @override
  String get notifications => 'ማሳወቂያዎች';

  @override
  String get notificationsSubtitle => 'ምርጫዎች • ማሳወቂያዎች';

  @override
  String get accountSettingsHeader => 'የመለያ ቅንብሮች';

  @override
  String get privacyAndSecurity => 'ግላዊነት እና ደህንነት';

  @override
  String get privacySubtitle => 'የይለፍ ቃል • ግላዊነት • ደህንነት';

  @override
  String get appLanguage => 'የመተግበሪያ ቋንቋ';

  @override
  String get appLanguageSubtitle => 'ቋንቋዎን ይምረጡ';

  @override
  String get appTheme => 'የገጽታ ቀለም';

  @override
  String get appThemeSubtitle => 'ቀላል ወይም ጨለማ';

  @override
  String get textSize => 'የጽሑፍ መጠን';

  @override
  String get textSizeSubtitle => 'ማሳያ • ንባብ • መጠን';

  @override
  String get supportCenter => 'የድጋፍ ማዕከል';

  @override
  String get supportCenterSubtitle => 'እርዳታ • አድራሻ • ድጋፍ';

  @override
  String get lightTheme => 'ቀላል';

  @override
  String get darkTheme => 'ጨለማ';

  @override
  String get defaultTextSize => 'መደበኛ';

  @override
  String get smallTextSize => 'ትንሽ';

  @override
  String get largeTextSize => 'ትልቅ';

  @override
  String get appVersion => 'ስሪት 1.0.0';

  @override
  String get supportCenterTitle => 'የድጋፍ እና የእርዳታ መስመር';

  @override
  String get supportCenterBody =>
      'ስለ ስነ-ተዋልዶ ጤና ጥያቄ ካለዎት ወይም ሚስጥራዊ የአቻ ድጋፍ ከፈለጉ የተረጋገጡ የወጣቶች ማዕከላትን እና ብሔራዊ የጤና መስመሮችን (ለምሳሌ 952 ወይም 8335) ያግኙ። የእኛ ጤና አጠቃላይ ትምህርት የሚሰጥ ሲሆን የአስቸኳይ የህክምና ክብካቤን አይተካም።';

  @override
  String get notificationsModalTitle => 'የማሳወቂያ ቅንብሮች';

  @override
  String get notificationsModalBody =>
      'የማሳወቂያ ምርጫዎችን፣ የዕለት ተዕለት የትምህርት ማስታወሻዎችን እና የጤና ምክሮችን እዚህ ያዘጋጁ።';

  @override
  String get privacyModalTitle => 'የግላዊነት እና ደህንነት ቅንብሮች';

  @override
  String get privacyModalBody =>
      'የጤና ትምህርት እና የእንቅስቃሴ መረጃዎችዎ በመሳሪያዎ ላይ በከፍተኛ ጥበቃና ምስጠራ የተጠበቁ ናቸው። የይለፍ ቃልዎን በማንኛውም ጊዜ መቀየር ይችላሉ።';

  @override
  String get themeDialogTitle => 'የመተግበሪያ ገጽታ ይምረጡ';

  @override
  String get textSizeDialogTitle => 'የጽሑፍ መጠን ይምረጡ';

  @override
  String get srhVctFilter => 'ስነ-ተዋልዶ እና ምርመራ';

  @override
  String get mentalHealthFilter => 'የአእምሮ ጤና';

  @override
  String get listViewLabel => 'ዝርዝር';

  @override
  String get mapViewLabel => 'ካርታ';

  @override
  String get openNowStatus => 'አሁን ክፍት ነው';

  @override
  String get closedStatus => 'ዝግ ነው';

  @override
  String get verifiedYouthFriendlyBadge => 'የተረጋገጠ የወጣቶች ማዕከል';

  @override
  String get freeForYouthBadge => 'ነፃ አገልግሎት';

  @override
  String get callClinicAction => 'ደውል';

  @override
  String get directionsAction => 'አቅጣጫ';

  @override
  String get viewDetailsAction => 'ዝርዝር ይመልከቱ';

  @override
  String get confidentialityNoticeTitle => 'የወጣቶች ሚስጥራዊነት ዋስትና';

  @override
  String get landmarkLabel => 'መለያ ቦታ';

  @override
  String get operatingHoursLabel => 'የስራ ሰዓታት';

  @override
  String get servicesOfferedLabel => 'የሚሰጡ አገልግሎቶች';

  @override
  String get resetFiltersAction => 'ማጣሪያዎችን አጽዳ';

  @override
  String get copiedToClipboard => 'ስልክ ቁጥሩ ተቀድቷል';

  @override
  String get campusClinicBadge => 'የካምፓስ ክሊኒክ';

  @override
  String distanceKm(String distance) {
    return '$distance ኪ.ሜ ርቀት';
  }

  @override
  String closesAt(String time) {
    return 'በ$time ይዘጋል';
  }

  @override
  String opensAt(String time) {
    return 'በ$time ይከፈታል';
  }

  @override
  String get onlineNowFilter => 'መስመር ላይ';

  @override
  String get pubertyFilter => 'ጉርምስና';

  @override
  String get substanceFilter => 'ጤናማ አኗኗር';

  @override
  String get availableNowBadge => 'አሁን ይገኛሉ';

  @override
  String nextSlotBadge(String time) {
    return 'ቀጣይ፡ $time';
  }

  @override
  String get verifiedPeerBadge => 'የተረጋገጠ አቻ አማካሪ';

  @override
  String get chatConfidentialAction => 'በሚስጥር አውራ';

  @override
  String get viewProfileBtn => 'መገለጫ ይመልከቱ';

  @override
  String get safeguardingTitle => 'የደህንነት እና የሚስጥራዊነት ዋስትና';

  @override
  String experienceMetrics(int years, int sessions) {
    return '$years ዓመት ልምድ • $sessions+ ውይይቶች';
  }

  @override
  String get sessionsCountLabel => 'ውይይቶች';

  @override
  String get languagesSpokenLabel => 'የሚናገሯቸው ቋንቋዎች';

  @override
  String get specialtiesLabel => 'የልዩ ትኩረት መስኮች';

  @override
  String startChatPrompt(String name) {
    return 'ከ$name ጋር ሚስጥራዊ ውይይት ጀምር';
  }

  @override
  String get emergencyDisclaimer =>
      'አቻ አማካሪዎች አጠቃላይ ድጋፍ እና ማዳመጥ ይሰጣሉ። ለከፍተኛ ጭንቀት ወይም ለህክምና ድንገተኛ አደጋ እባክዎን ወዲያውኑ ወደ 952 ወይም 8335 ነፃ የስልክ መስመሮች ይደውሉ።';

  @override
  String get sendPeerMessage => 'መልእክት ላክ';

  @override
  String get peerChatComingSoon =>
      'የቀጥታ ስም-አልባ ውይይት ተጀምሯል። አማካሪዎ በቅርብ ደቂቃዎች ውስጥ ምላሽ ይሰጥዎታል።';

  @override
  String get languageAll => 'ሁሉም ቋንቋዎች';
}
