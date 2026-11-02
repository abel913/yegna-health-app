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
  String get hepatitisHeroDesc =>
      'ሄፓታይተስ በቫይረሶች ወይም በሌሎች ምክንያቶች የሚከሰት የጉበት እብጠት ሲሆን ብዙውን ጊዜ ቀላል ወይም ምንም ምልክት አያሳይም፤ ነገር ግን ካልታከመ ወደ ጉበት ጠባሳ (ሲሮሲስ)፣ የጉበት ሥራ ማቆም ወይም የጉበት ካንሰር ሊያመራ ይችላል። ቅድመ ምርመራ እና ተገቢ ህክምና ወሳኝ ናቸው።';

  @override
  String get hepatitisNoteContent =>
      'ሄፓታይተስ መከላከል እና ማከም የሚቻል ነው—ጥሩ ንፅህናን መጠበቅ፣ አደገኛ ልማዶችን ማስወገድ፣ በተቻለ መጠን መከተብ እና የጉበት ጤናዎን ለመጠበቅ ቀድመው መመርመር ይመከራል።';

  @override
  String get hepatitisSection1Title => 'ትርጓሜ (Definition)';

  @override
  String get hepatitisSection1Desc1 =>
      'ሄፓታይተስ የጉበት እብጠትን ለመግለጽ የሚያገለግል አጠቃላይ የህክምና ቃል ነው። የጉበት እብጠት በተለያዩ ቫይረሶች (ቫይራል ሄፓታይተስ)፣ በኬሚካሎች፣ በመድሃኒቶች፣ በአልኮል፣ በአንዳንድ የዘረመል ችግሮች ወይም የበሽታ መከላከያ ስርዓታችን ጉበትን በስህተት በማጥቃቱ (ኦቶኢሚውን ሄፓታይተስ) ሊከሰት ይችላል።';

  @override
  String get hepatitisSection1Desc2 =>
      'ሄፓታይተስ በቫይረስ እና በቫይረስ ባልሆኑ ምክንያቶች የሚከፈልባቸው በርካታ ዓይነቶች አሉት። በጣም የተለመዱት የቫይረስ ሄፓታይተስ ዓይነቶች A, B, C, D እና E ናቸው። በቫይረስ ምክንያት የማይከሰቱት ደግሞ ኦቶኢሚውን ሄፓታይተስ፣ በአልኮል የሚመጣ ሄፓታይተስ እና በመድሃኒት የሚመጣ ሄፓታይተስ ናቸው።';

  @override
  String get hepatitisSection2Title =>
      'የሄፓታይተስ ምልክቶች (Sign and symptoms of Hepatitis)';

  @override
  String get hepatitisSection2Intro =>
      'በሄፓታይተስ A, B, C, D ወይም E የተያዙ ብዙ ሰዎች ቀላል ምልክቶች ብቻ ያሳያሉ ወይም ምንም ዓይነት ምልክት ላያሳዩ ይችላሉ። ይሁን እንጂ እያንዳንዱ የቫይረስ ዓይነት የከፋ ምልክቶችን ሊያስከትል ይችላል። የሄፓታይተስ A, B እና C ምልክቶች የሚከተሉትን ሊያካትቱ ይችላሉ፦';

  @override
  String get hepatitisSymptom1 => 'ትኩሳት';

  @override
  String get hepatitisSymptom2 => 'የአካል ድካም እና መዛል';

  @override
  String get hepatitisSymptom3 => 'የምግብ ፍላጎት መቀነስ';

  @override
  String get hepatitisSymptom4 => 'ተቅማጥ';

  @override
  String get hepatitisSymptom5 => 'የማቅለሽለሽ ስሜት';

  @override
  String get hepatitisSymptom6 => 'የሆድ ህመም እና አለመመቸት';

  @override
  String get hepatitisSymptom7 =>
      'የሽንት ቀለም መጥቆር እና የአይን ወይም የቆዳ ቢጫ መሆን (Jaundice)';

  @override
  String get hepatitisSection2ChronicNote =>
      'በአንዳንድ ሁኔታዎች ቫይረሱ ወደ ጉበት ጠባሳ (ሲሮሲስ) ወይም ወደ ጉበት ካንሰር የሚያመራ ሥር የሰደደ የጉበት ኢንፌክሽን ሊያስከትል ይችላል። እነዚህ ታካሚዎች ለሞት አደጋ የተጋለጡ ናቸው።';

  @override
  String get hepatitisBTitle => 'ሄፓታይተስ ቢ (Hepatitis B)';

  @override
  String get hepatitisBDesc =>
      'ሄፓታይተስ ቢ በሄፓታይተስ ቢ ቫይረስ (HBV) የሚከሰት እና ጉበትን የሚያጠቃ የቫይረስ ኢንፌክሽን ነው። ከቀላል ህመም እስከ ከባድና ሥር የሰደደ የጉበት ጠባሳ (ሲሮሲስ)፣ የጉበት ሥራ ማቆም ወይም የጉበት ካንሰር ሊያደርስ ይችላል።';

  @override
  String get hepatitisBTransmissionIntro =>
      'ቫይረሱ እንደ ደም፣ የዘር ፈሳሽ እና የሴት ብልት ፈሳሽ ካሉ የበከሉ የሰውነት ፈሳሾች ጋር በሚደረግ ንክኪ የሚተላለፍ ሲሆን በዋናነት የሚከተሉትን ያጠቃልላል፦';

  @override
  String get hepatitisBTransmission1 => 'ያልተጠበቀ የግብረ-ሥጋ ግንኙነት';

  @override
  String get hepatitisBTransmission2 =>
      'መርፌዎችን ወይም ሌሎች የዕፅ መርፌ መሳሪያዎችን በጋራ መጠቀም';

  @override
  String get hepatitisBTransmission3 =>
      'በወሊድ ወቅት በቫይረሱ ከተያዘች እናት ወደ አዲስ ለተወለደው ህፃን';

  @override
  String get hepatitisBTransmission4 => 'በጤና ተቋማት ውስጥ ከተበከለ ደም ጋር የሚኖር ንክኪ';

  @override
  String get hepatitisBAlert =>
      'ሄፓታይተስ ቢ በክትባት መከላከል የሚቻል ሲሆን ነገር ግን እስካሁን ፍቱን ፈውስ የለውም።';

  @override
  String get hepatitisCTitle => 'ሄፓታይተስ ሲ (Hepatitis C)';

  @override
  String get hepatitisCDesc =>
      'ሄፓታይተስ ሲ በሄፓታይተስ ሲ ቫይረስ (HCV) የሚከሰት እና በዋናነት ጉበትን የሚያጠቃ የቫይረስ ኢንፌክሽን ነው። በብዛት የሚተላለፈው በደም ንክኪ ሲሆን በዋናነት፦';

  @override
  String get hepatitisCTransmission1 => 'መርፌዎችን ወይም የዕፅ መጠቀሚያ መሳሪያዎችን በጋራ መጠቀም';

  @override
  String get hepatitisCTransmission2 =>
      'የተበከሉ የደም ውጤቶችን መውሰድ (ምንም እንኳን አሁን ላይ በምርመራ ምክንያት ይህ አነስተኛ ቢሆንም)';

  @override
  String get hepatitisCTransmission3 =>
      'በአንዳንድ ሁኔታዎች በግብረ-ሥጋ ግንኙነት ወይም በወሊድ ወቅት በቫይረሱ ከተያዘች እናት ወደ ልጇ';

  @override
  String get hepatitisCChronicDesc =>
      'ከሄፓታይተስ ቢ በተለየ መልኩ፣ ሄፓታይተስ ሲ አብዛኛውን ጊዜ ሥር የሰደደ (chronic) ይሆናል፤ ይህም ማለት ኢንፌክሽኑ ለዓመታት የሚቆይ ሲሆን ወደ ጉበት ጉዳት፣ የጉበት ጠባሳ (ሲሮሲስ)፣ የጉበት ካንሰር እና የጉበት ሥራ ማቆም ሊያመራ ይችላል። ብዙ የሄፓታይተስ ሲ ተጠቂዎች የጉበት ጉዳቱ እስኪከፋ ድረስ ምንም ምልክት አያሳዩም።';

  @override
  String get hepatitisCTreatmentDesc =>
      'ህክምናው በከፍተኛ ደረጃ የተሻሻለ ሲሆን፣ በቀጥታ የሚሰሩ የፀረ-ቫይረስ መድሃኒቶች (DAAs) ከፍተኛ የመዳን እድል ይሰጣሉ፤ ይህም ሥር የሰደደ ሄፓታይተስ ሲን ከቀድሞው የበለጠ በቀላሉ ማከም የሚቻል አድርጎታል።';

  @override
  String get hepatitisSection3Title => 'የሄፓታይተስ ምርመራ (Diagnosis of Hepatitis)';

  @override
  String get hepatitisSection3Desc =>
      'የሄፓታይተስ ምርመራ የበሽታውን መንስኤ፣ ክብደት እና ተገቢውን ህክምና ለመወሰን የደም ምርመራዎችን፣ የምስል (imaging) ምርመራዎችን እና አንዳንዴም የጉበት ባዮፕሲን (biopsy) ማጣመርን ያካትታል። እያንዳንዱ የሄፓታይተስ ዓይነት የራሱ የሆነ የመመርመሪያ ምልክት ስላለው፣ ትክክለኛውን መንስኤ ለይቶ ማወቅ ውጤታማ ህክምና ለመስጠት ወሳኝ ነው።';

  @override
  String get hepatitisSection4Title =>
      'የሄፓታይተስ ችግሮች (Complication of Hepatitis)';

  @override
  String get hepatitisSection4Intro =>
      'የሄፓታይተስ ችግሮች እንደ ዓይነቱ (A, B, C, ወዘተ)፣ እንደ ኢንፌክሽኑ ክብደት እና ሥር የሰደደ መሆን አለመሆኑ ሊለያዩ ይችላሉ። አንዳንድ የተለመዱ እና ከባድ ችግሮች የሚከተሉትን ያካትታሉ፦';

  @override
  String get hepatitisComp1Title => 'ሥር የሰደደ ሄፓታይተስ (Chronic Hepatitis)';

  @override
  String get hepatitisComp1Desc =>
      'ሥር የሰደደ ሄፓታይተስ ቢ እና ሲ፦ ካልታከመ የቫይረስ ሄፓታይተስ ወደ ሥር የሰደደ ኢንፌክሽን ሊሸጋገር ይችላል፤ ይህም ቫይረሱ በሰውነት ውስጥ ለዓመታት እንዲቆይ በማድረግ ቀጣይነት ያለው የጉበት እብጠት ያስከትላል።';

  @override
  String get hepatitisComp2Title => 'ሲሮሲስ (Cirrhosis)';

  @override
  String get hepatitisComp2Desc =>
      'የጉበት ጠባሳ፦ የረጅም ጊዜ እብጠት ወደ ሲሮሲስ ሊያመራ ይችላል፤ ይህም የጉበት ህዋስ በጠባሳ የሚሸፈንበትና የጉበትን ተግባር የሚያውክ ሁኔታ ነው። ይህ ከሥር የሰደደ ሄፓታይተስ ቢ፣ ሲ ወይም ከአልኮል አጠቃቀም ሊመነጭ ይችላል።';

  @override
  String get hepatitisComp3Title => 'የጉበት ሥራ ማቆም (Liver Failure)';

  @override
  String get hepatitisComp3Desc =>
      'አጣዳፊ ወይም ሥር የሰደደ የጉበት ሥራ ማቆም፦ ከባድ የጉበት ጉዳት ጉበቱ እንደ መርዛማ ንጥረ ነገሮችን ማጣራት እና ፕሮቲን ማምረት ያሉ ወሳኝ ተግባራትን ወደሚያጣበት የጉበት ሥራ ማቆም ደረጃ ሊያደርስ ይችላል። ይህ በድንገት (ለምሳሌ በድንገተኛ ሄፓታይተስ ቢ ወይም ዲ) ወይም በሄፓታይተስ ሲ ምክንያት በረጅም ጊዜ ሂደት ሊከሰት ይችላል።';

  @override
  String get hepatitisComp4Title => 'የጉበት ካንሰር (Hepatocellular Carcinoma)';

  @override
  String get hepatitisComp4Desc =>
      'ሥር የሰደደ ሄፓታይተስ ቢ እና ሲ ቀጣይነት ባለው የጉበት ህዋሳት ጉዳት እና ለውጥ ምክንያት በጊዜ ሂደት የጉበት ካንሰር የመከሰት እድልን ይጨምራሉ።';

  @override
  String get hepatitisSection4Conclusion =>
      'ቀደም ብሎ ማወቅ እና የሄፓታይተስ አያያዝ፣ በተለይም ሥር የሰደዱትን ዓይነቶች፣ እነዚህን ችግሮች ለመከላከል ወይም ለመቆጣጠር ቁልፍ ናቸው።';

  @override
  String get hepatitisSection5Title =>
      'የሄፓታይተስ አያያዝ እና ህክምና (Management and treatment of Hepatitis)';

  @override
  String get hepatitisSection5Desc =>
      'የሄፓታይተስ ህክምና እንደየዓይነቱ እና ክብደቱ ይለያያል። ብዙዎቹ ዓይነቶች (በተለይም ሄፓታይተስ ኤ እና ኢ) በደጋፊ እንክብካቤ በራሳቸው ጊዜ የሚድኑ ሲሆኑ፣ ሌሎች ደግሞ (እንደ ሄፓታይተስ ቢ፣ ሲ እና ሥር የሰደዱ ሁኔታዎች) በፀረ-ቫይረስ መድሃኒቶች፣ በአኗኗር ለውጦች ወይም በበሽታ መከላከያ አፋኝ ህክምናዎች የረጅም ጊዜ ክትትል ያስፈልጋቸዋል። ቀደም ብሎ ማወቅ እና ተገቢ ህክምና ማግኘት የጉበት ጉዳትን እንዲሁም እንደ ሲሮሲስ እና የጉበት ካንሰር ያሉ ችግሮችን ለመከላከል ቁልፍ ናቸው።';

  @override
  String get hepatitisSection6Title =>
      'ሄፓታይተስን መከላከል (Prevention Of Hepatitis)';

  @override
  String get hepatitisSection6Subtitle =>
      'ለሁሉም ዓይነት ሄፓታይተስ አጠቃላይ የመከላከያ እርምጃዎች';

  @override
  String get hepatitisPreventionMeasure1 =>
      'ጥሩ የንፅህና አጠባበቅ፦ ሽንት ቤት ከተጠቀሙ በኋላ፣ ምግብ ከማዘጋጀት እና ከመመገብዎ በፊት እጅዎን በሳሙና እና በውሃ በደንብ ይታጠቡ።';

  @override
  String get hepatitisPreventionMeasure2 =>
      'ከአልኮል እና አደንዛዥ ዕፆች መራቅ፦ ከመጠን በላይ አልኮል እና አደንዛዥ ዕፆችን መጠቀም የጉበት ጉዳትን ያባብሳል።';

  @override
  String get hepatitisPreventionMeasure3 =>
      'ክትባት መከተብ፦ የሄፓታይተስ ኤ እና የሄፓታይተስ ቢ ክትባቶች ደህንነታቸው የተጠበቀና ውጤታማ ናቸው።';

  @override
  String get hepatitisPreventionMeasure4 =>
      'ንፁህ መርፌዎችን መጠቀም እና ደም መመርመር፦ ለአንድ ጊዜ ብቻ የሚያገለግሉ መርፌዎችን መጠቀም እና የደም ውጤቶች መመርመራቸውን ማረጋገጥ።';

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
  String get gbvHeroDesc =>
      'ሥርዓተ-ፆታን መሠረት ያደረገ ጥቃት በፆታ ላይ ተመስርቶ በሰዎች ላይ የሚደርስ ጎጂ ድርጊት ሲሆን፣ በእኩልነት ጉድለት እና በባህላዊ ልማዶች የሚመጣ፣ ለአካላዊ፣ ስነ-ልቦናዊ፣ ማህበራዊ እና ኢኮኖሚያዊ ጉዳቶች የሚዳርግ ነው፤ ሆኖም በመከላከል፣ በድጋፍ አገልግሎቶች እና በህጋዊ ጥበቃ መፍትሄ ሊያገኝ ይችላል።';

  @override
  String get gbvNoteContent =>
      'ሥርዓተ-ፆታን መሠረት ያደረገ ጥቃት መከላከል ይቻላል—አክብሮትን፣ እኩልነትን እና ለተጎጂዎች ፈጣን ድጋፍ መስጠት ደህንነቱ የተጠበቀ ማህበረሰብ ለመገንባት እና የሰውን ክብር ለመጠበቅ ይረዳል።';

  @override
  String get gbvSection1Title => 'ትርጓሜ';

  @override
  String get gbvSection1Desc1 =>
      'ሥርዓተ-ፆታን መሠረት ያደረገ ጥቃት (GBV) በአንድ ግለሰብ ፆታ ላይ ተመስርቶ የሚፈጸም ጎጂ ድርጊትን ያመለክታል። በየትኛውም ሁኔታ ውስጥ ሊከሰት ይችላል፣ ነገር ግን በአብዛኛው ሴቶችን እና ልጃገረዶችን ያጠቃል፣ ምንም እንኳን ወንዶችና ወንዶች ልጆችም ሊያጋጥማቸው ይችላል። GBV የሰብዓዊ መብት ጥሰት እና የፆታ እኩልነትን እንዲሁም ማህበራዊ ፍትህን ለማረጋገጥ ትልቅ እንቅፋት ነው።';

  @override
  String get gbvSection1Desc2 =>
      'በሰብዓዊ ቀውሶች ወቅት ለፆታዊ ጥቃት ምላሽ መስጠት ቅድሚያ የሚሰጠው ጉዳይ ሆኖ ቆይቷል፤ ምክንያቱም ከግጭት ጋር የተያያዘ ጥቃት፣ በተለይም አስገድዶ መድፈር እንደ ጦርነት ስልት መጠቀሙ ዓለም አቀፍ ትኩረት አግኝቷል። ይሁን እንጂ በግጭት እና በተፈጥሮ አደጋ የተጎዱ ሰዎች በቀውስና በመፈናቀል ወቅት እንዲሁም ከተመለሱ በኋላ የተለያዩ የGBV ዓይነቶችን እንደሚያጋጥሟቸው ከጊዜ ወደ ጊዜ ግንዛቤው እያደገ መጥቷል። በተለይም በትዳር ወይም በፍቅር አጋር መካከል የሚፈጸም ጥቃት በሰብዓዊ ድጋፍ መስኮች እንደ ወሳኝ አሳሳቢ ጉዳይ እየታየ ነው። ሥርዓተ-ፆታን መሠረት ያደረገ ጥቃት በተለያዩ መንገዶች ሊገለጽ ይችላል፡-';

  @override
  String get gbvForm1Title => 'አካላዊ ጥቃት';

  @override
  String get gbvForm1Item1Title => 'የቤት ውስጥ ጥቃት (የአጋር ጥቃት):';

  @override
  String get gbvForm1Item1Body =>
      'በትዳር ወይም በፍቅር ግንኙነት ውስጥ የሚፈጸሙ መደብደብ፣ በጥፊ መምታት፣ በእርግጫ መምታት እና ሌሎች አካላዊ ጉዳቶችን ያጠቃልላል።';

  @override
  String get gbvForm1Item2Title => 'ፆታዊ ጥቃት:';

  @override
  String get gbvForm1Item2Body =>
      'አስገድዶ መድፈርን፣ ፆታዊ ትንኮሳን እና ያልተፈለጉ ፆታዊ ድርጊቶችን ያጠቃልላል።';

  @override
  String get gbvForm2Title => 'ስነ-ልቦናዊ / ስሜታዊ ጥቃት';

  @override
  String get gbvForm2Item1Title => 'የቃል ስድብ:';

  @override
  String get gbvForm2Item1Body =>
      'የተጎጂውን በራስ መተማመን እና ክብር የሚያሳንሱ ስድቦች፣ ማስፈራሪያዎች፣ ማዋረድ እና የመቆጣጠር ባህሪዎች።';

  @override
  String get gbvForm2Item2Title => 'ማግለል:';

  @override
  String get gbvForm2Item2Body =>
      'ተጎጂው ከቤተሰብ እና ከጓደኞች ጋር ያለውን ግንኙነት እንዲያቋርጥ ማስገደድ።';

  @override
  String get gbvForm2Item3Title => 'አስገዳጅ ቁጥጥር:';

  @override
  String get gbvForm2Item3Body =>
      'የአንድን ሰው ነፃነት የሚገድብ የቁጥጥር ስልት፣ ለምሳሌ ምን እንደሚለብሱ፣ የት እንደሚሄዱ ወይም ከማን ጋር እንደሚገናኙ መወሰን።';

  @override
  String get gbvForm3Title => 'ፆታዊ ጥቃት እና ብዝበዛ';

  @override
  String get gbvForm3Item1Title => 'አስገድዶ መድፈር:';

  @override
  String get gbvForm3Item1Body => 'ያለ ፈቃድ የሚፈጸም የግብረ ሥጋ ግንኙነት።';

  @override
  String get gbvForm3Item2Title => 'ፆታዊ ትንኮሳ:';

  @override
  String get gbvForm3Item2Body =>
      'ያልተፈለጉ የፆታ ጥያቄዎች ወይም ባህሪያት፣ ብዙውን ጊዜ በስራ ቦታ፣ በትምህርት ቤት ወይም በህዝባዊ ቦታዎች የሚከሰቱ።';

  @override
  String get gbvForm3Item3Title => 'የሰዎች ዝውውር:';

  @override
  String get gbvForm3Item3Body =>
      'ሰዎችን ለፆታዊ ብዝበዛ ወይም ለግዳጅ ስራ በህገ-ወጥ መንገድ ማዘዋወር።';

  @override
  String get gbvForm4Title => 'ኢኮኖሚያዊ ጥቃት';

  @override
  String get gbvForm4Item1Title => 'የገንዘብ ሀብትን መከልከል:';

  @override
  String get gbvForm4Item1Body =>
      'አጋር ገንዘብን ወይም ሀብትን እንዳያገኝ መከልከል፣ የኢኮኖሚ ነፃነታቸውን መቆጣጠር።';

  @override
  String get gbvForm4Item2Title => 'በገንዘብ ጥገኝነት ማስገደድ:';

  @override
  String get gbvForm4Item2Body =>
      'በአንድ ሰው ላይ ስልጣንን ወይም ቁጥጥርን ለማስጠበቅ የገንዘብ ቁጥጥርን መጠቀም።';

  @override
  String get gbvForm5Title => 'ጎጂ ባህላዊ ልማዶች';

  @override
  String get gbvForm5Item1Title => 'የሴቶች ግርዛት (FGM/C):';

  @override
  String get gbvForm5Item1Body =>
      'የሴቶችን የፆታ ስሜት ለመቆጣጠር በሚል የሴቶችን ብልት በከፊል ወይም ሙሉ በሙሉ ያለ ህክምና ምክንያት የማስወገድ ድርጊት።';

  @override
  String get gbvForm5Item2Title => 'ያለዕድሜ ወይም ያለፈቃድ ጋብቻ:';

  @override
  String get gbvForm5Item2Body =>
      'በተለያዩ ባህላዊ ልማዶች ምክንያት ታዳጊ ልጃገረዶችን ወይም ሰዎችን ያለ ፈቃዳቸው ለጋብቻ መዳር።';

  @override
  String get gbvForm5Item3Title => 'የክብር ግድያ:';

  @override
  String get gbvForm5Item3Body =>
      'በቤተሰብ ወይም በማህበረሰብ ላይ ውርደት ወይም ነውር አምጥታለች በሚል ምክንያት በሴቶች ወይም ልጃገረዶች ላይ የሚፈጸም ግድያ።';

  @override
  String get gbvSection2Title => 'ተፈጥሯዊ ፆታ እና ማህበራዊ ፆታ';

  @override
  String get gbvSection2Desc1 =>
      'በተፈጥሯዊ ፆታ (Sex) እና በማህበራዊ ፆታ (Gender) መካከል ያለውን ልዩነት መረዳት የሥርዓተ-ፆታ ጥቃትን ለመከላከል ወሳኝ ነው። ተፈጥሯዊ ፆታ በባዮሎጂያዊ እና አካላዊ መገለጫዎች (ክሮሞሶሞች፣ ሆርሞኖች እና የመራቢያ አካላት) ላይ የተመሰረተ ነው። ማህበራዊ ፆታ ደግሞ ማህበረሰቡ ለወንዶች ወይም ለሴቶች የሰጠውን ሚና፣ ባህሪ እና የሚጠበቁ ተግባራትን ያመለክታል።';

  @override
  String get gbvSection2Desc2 =>
      'የማህበራዊ ፆታ ልማዶች ሰዎች በተፈጥሮ ፆታቸው መሰረት እንዴት እርምጃ መውሰድ፣ መናገር እና መልበስ እንዳለባቸው ይወስናሉ። ያልተመጣጠነ የስልጣን ክፍፍል እና አንዱን ወገን ከሌላው የማስበለጥ አመለካከቶች ጥቃትን እና አድሎን ወደ ማጽደቅ ያመራሉ፤ ይህም ለሥርዓተ-ፆታ ጥቃት መከሰት መሰረት ይሆናል።';

  @override
  String get gbvSection3Title => 'የሥርዓተ-ፆታ ጥቃት የሚያስከትላቸው ጉዳቶች';

  @override
  String get gbvConsequenceBullet1 =>
      'አካላዊ ጉዳት፣ የአካል ጉዳተኝነት፣ ሥር የሰደደ የጤና እክል፣ የስነ-ተዋልዶ ጤና ችግሮች፣ ሞት';

  @override
  String get gbvConsequenceBullet2 =>
      'ስነ-ልቦናዊ ችግሮች፣ ጭንቀት፣ ፍርሃት፣ የብቸኝነት ስሜት፣ ድብርት፣ የአልኮል ወይም እፅ ሱስ፣ ራስን ማጥፋት';

  @override
  String get gbvConsequenceBullet3 =>
      'ኢኮኖሚያዊ እና ማህበራዊ ተፅእኖ፣ በማህበራዊ እና ኢኮኖሚያዊ እንቅስቃሴዎች ውስጥ የመሳተፍ አቅም መቀነስ፣ በማህበረሰብ ደረጃ የሚደርስ መገለል፣ የሴቶችን የገቢ ማመንጨት አቅም መጉዳት፣ ለሌሎች የጥቃት ዓይነቶች ተጋላጭነት መጨመር';

  @override
  String get gbvConsequenceBullet4 =>
      'በሴቶች ቤተሰብ እና ጥገኞች ላይ የሚደርስ ተፅእኖ፣ ፍቺ ወይም የተበታተኑ ቤተሰቦች፣ የቤተሰብን ኢኮኖሚያዊ እና ስሜታዊ እድገት ማወክ፣ የስሜት እና የባህሪ መታወክ';

  @override
  String get gbvConsequenceBullet5 => 'ስሜታዊ መዘዞች፣ ድብርት፣ ውጥረት፣ ዝቅተኛ በራስ መተማመን';

  @override
  String get gbvTableTitle => 'የሥርዓተ-ፆታ ጥቃት (GBV) መዘዞች';

  @override
  String get gbvTableColPhysical => 'አካላዊ የጤና መዘዞች';

  @override
  String get gbvTableColPsychological => 'ስነ-ልቦናዊ የጤና መዘዞች';

  @override
  String get gbvTableColSocial => 'ማህበራዊ እና ኢኮኖሚያዊ መዘዞች';

  @override
  String get gbvTablePhys1 => 'አካላዊ ጉዳት';

  @override
  String get gbvTablePhys2 => 'ኤችአይቪ/ኤድስ';

  @override
  String get gbvTablePhys3 => 'የአባለዘር በሽታዎች (STIs)';

  @override
  String get gbvTablePhys4 => 'ያልተፈለገ እርግዝና';

  @override
  String get gbvTablePhys5 => 'አደገኛ ውርጃ';

  @override
  String get gbvTablePhys6 => 'የማህፀን ፊስቱላ';

  @override
  String get gbvTablePhys7 => 'ሞት';

  @override
  String get gbvTablePsych1 => 'ድብርት (Depression)';

  @override
  String get gbvTablePsych2 => 'ፍርሃት';

  @override
  String get gbvTablePsych3 => 'ራስን መውቀስ';

  @override
  String get gbvTablePsych4 => 'ጭንቀት (Anxiety)';

  @override
  String get gbvTablePsych5 => 'የአእምሮ ህመም';

  @override
  String get gbvTablePsych6 => 'ራስን የማጥፋት ሀሳብ/ድርጊት';

  @override
  String get gbvTableSoc1 => 'ተጎጂውን ተጠያቂ ማድረግ';

  @override
  String get gbvTableSoc2 => 'መገለል (Stigma)';

  @override
  String get gbvTableSoc3 => 'መገፋት';

  @override
  String get gbvTableSoc4 => 'ብቸኝነት';

  @override
  String get gbvTableSoc5 => 'የገቢ ማመንጨት አቅም መቀነስ';

  @override
  String get gbvTableSoc6 => 'የድህነት መጨመር';

  @override
  String get gbvTableSoc7 => 'እንደገና ለጥቃት የመጋለጥ እድል';

  @override
  String get gbvSection4Title => 'የሥርዓተ-ፆታ ጥቃት አያያዝ እና መከላከያ መንገዶች';

  @override
  String get gbvSec4Main1Title => 'አፋጣኝ ምላሽ፡ የGBV አያያዝ';

  @override
  String get gbvSec4Main1Intro =>
      'ጥቃት በሚደርስበት ጊዜ ተጎጂዎችን ለመደገፍ እና ሁኔታውን ለመፍታት አፋጣኝ ጣልቃገብነት አስፈላጊ ነው።';

  @override
  String get gbvSec4SubATitle => 'ደህንነትን እና ጥበቃን መስጠት';

  @override
  String get gbvSec4SubA1Title => 'ደህንነታቸው የተጠበቁ ቦታዎች፡';

  @override
  String get gbvSec4SubA1Body =>
      'የአደጋ ጊዜ መጠለያዎች እና ማዕከላት ለተጎጂዎች ፈጣን መጠጊያ ይሰጣሉ።';

  @override
  String get gbvSec4SubA2Title => 'የነጻ የስልክ መስመሮች እና የአደጋ ጊዜ ምክር፡';

  @override
  String get gbvSec4SubA2Body =>
      'መመሪያን፣ ስሜታዊ ድጋፍን እና የህግ ምክርን የሚሰጡ የድጋፍ አገልግሎቶች።';

  @override
  String get gbvSec4SubA3Title => 'የጥበቃ ትእዛዝ፡';

  @override
  String get gbvSec4SubA3Body =>
      'አጥፊዎች ተጎጂዎችን እንዳያገኙ ወይም እንዳይቀርቡ የሚከለክሉ ህጋዊ እርምጃዎች፤ የተጎጂዎችን ደህንነት ለማረጋገጥ እና አጥፊዎችን ተጠያቂ ለማድረግ የህግ አስከባሪዎች ተሳትፎ።';

  @override
  String get gbvSec4SubA4Title => 'የህክምና እርዳታ፡';

  @override
  String get gbvSec4SubA4Body =>
      'ተጎጂዎች አፋጣኝ የህክምና ክትትል፣ የስነ-ቁስለት ህክምና እና የስነ-ተዋልዶ ጤና አገልግሎቶችን ማግኘታቸውን ማረጋገጥ።';

  @override
  String get gbvSec4SubBTitle => 'ሁሉን አቀፍ የድጋፍ አገልግሎቶች';

  @override
  String get gbvSec4SubB1Title => 'ስነ-ልቦናዊ ድጋፍ፡';

  @override
  String get gbvSec4SubB1Body =>
      'ተጎጂዎች ከደረሰባቸው ስነ-ልቦናዊ ቀውስ እንዲያገግሙ የሚረዳ የምክር እና የስነ-ልቦና ህክምና።';

  @override
  String get gbvSec4SubB2Title => 'የህግ ድጋፍ፡';

  @override
  String get gbvSec4SubB2Body =>
      'የህግ ስርዓቱን ለመረዳት፣ ሪፖርት ለማድረግ እና ፍትህን ለማግኘት የሚደረግ ድጋፍ።';

  @override
  String get gbvSec4SubB3Title => 'ኢኮኖሚያዊ ድጋፍ፡';

  @override
  String get gbvSec4SubB3Body =>
      'የስራ ስልጠናን፣ አነስተኛ ብድርን ወይም የገንዘብ ድጋፍን ጨምሮ የኢኮኖሚ ነፃነትን እንደገና ለመገንባት የሚደረግ እገዛ።';

  @override
  String get gbvSec4Main2Title => 'የሥርዓተ-ፆታ ጥቃትን መከላከል';

  @override
  String get gbvSec4Main2Intro =>
      'የመከላከያ ስልቶች የሚያተኩሩት የጥቃቱን ዋና መንስኤዎች በማስወገድ ጥቃት የማይታገስበትን ማህበረሰብ ለመፍጠር ነው።';

  @override
  String get gbvSec4Sub2ATitle => 'ማህበራዊ አመለካከቶችን እና ልማዶችን መለወጥ';

  @override
  String get gbvSec4Sub2A1Title => 'የህዝብ ግንዛቤ ማስጨበጫ ዘመቻዎች፡';

  @override
  String get gbvSec4Sub2A1Body =>
      'ማህበረሰቡን ስለ ጥቃቱ ጎጂነት ማስተማር፣ የፆታ እኩልነትን ማሳደግ እና የተዛቡ አመለካከቶችን መፈታተን።';

  @override
  String get gbvSec4Sub2A2Title => 'የሚዲያ ቅስቀሳ፡';

  @override
  String get gbvSec4Sub2A2Body =>
      'ስለ ጤናማ ግንኙነቶች እና ለሁሉም ፆታዎች አክብሮት ስለመስጠት ፊልሞችን፣ ማህበራዊ ሚዲያዎችን እና ሌሎች መድረኮችን መጠቀም።';

  @override
  String get gbvSec4Sub2A3Title => 'የትምህርት ቤት ፕሮግራሞች፡';

  @override
  String get gbvSec4Sub2A3Body =>
      'አክብሮትን፣ የፆታ እኩልነትን እና ጤናማ ግንኙነቶችን የሚያበረታቱ የትምህርት መርሃ ግብሮችን መተግበር።';

  @override
  String get gbvSec4Sub2A4Title => 'የማህበረሰብ ውይይቶች፡';

  @override
  String get gbvSec4Sub2A4Body =>
      'ጥቃቱን የሚያባብሱ ባህላዊ ልማዶችን ለመፍታት በተለያዩ ቡድኖች (የማህበረሰብ መሪዎች፣ ወጣቶች፣ ወንዶች እና ሴቶች) መካከል ውይይቶችን ማመቻቸት።';

  @override
  String get gbvSec4Sub2BTitle => 'የህግ እና የፖሊሲ ማሻሻያ';

  @override
  String get gbvSec4Sub2B1Title => 'ህጎችን ማጠናከር፡';

  @override
  String get gbvSec4Sub2B1Body =>
      'በGBV ላይ ያተኮሩ ህጎችን (እንደ የቤት ውስጥ ጥቃት ህጎች፣ የፆታዊ ትንኮሳ ደንቦች እና የሰው ዝውውር መከላከያ ህጎች) ማውጣትና ማስከበር።';

  @override
  String get gbvSec4Sub2B2Title => 'የተጎጂዎችን መብት መደገፍ፡';

  @override
  String get gbvSec4Sub2B2Body =>
      'የጥቃት ሰለባዎች የፍትህ ተደራሽነት እንዲኖራቸው እና በህግ ወይም በማህበረሰብ ስርዓት እንደገና እንዳይበደሉ ማረጋገጥ።';

  @override
  String get gbvSec4Sub2B3Title => 'ለፆታ ጉዳይ ስሜታዊ የሆነ የህግ አስከባሪ አካል፡';

  @override
  String get gbvSec4Sub2B3Body =>
      'ፖሊስ እና ሌሎች የህግ አስከባሪዎች ለGBV ጉዳዮች ተገቢ ምላሽ እንዲሰጡ ማሰልጠን።';

  @override
  String get gbvSec4Sub2CTitle => 'ሴቶችን እና አናሳ ፆታዎችን ማብቃት';

  @override
  String get gbvSec4Sub2C1Title => 'የኢኮኖሚ ማብቃት፡';

  @override
  String get gbvSec4Sub2C1Body =>
      'ሴቶች የትምህርት፣ የስራ እና የገንዘብ ነፃነት እንዲኖራቸው ማድረግ ለጥቃት ያላቸውን ተጋላጭነት ይቀንሳል።';

  @override
  String get gbvSec4Sub2C2Title => 'የአመራር ስልጠና፡';

  @override
  String get gbvSec4Sub2C2Body =>
      'ሴቶች በፖለቲካ፣ በንግድ እና በማህበራዊ ዘርፎች በአመራር ቦታዎች ላይ እንዲሳተፉ ማበረታታት።';

  @override
  String get gbvSec4Sub2C3Title => 'ወንዶች እንደ ደጋፊ አጋሮች፡';

  @override
  String get gbvSec4Sub2C3Body =>
      'ወንዶች እና ወንዶች ልጆች በGBV መከላከያ ጥረቶች ውስጥ እንዲሳተፉ ማድረግ፣ አዎንታዊ የወንድነት ባህሪን እና የጋራ ኃላፊነትን ማጎልበት።';

  @override
  String get gbvSec4Sub2DTitle => 'ማህበረሰብ-ተኮር አቀራረቦች';

  @override
  String get gbvSec4Sub2D1Title => 'የማህበረሰብ ንቅናቄ፡';

  @override
  String get gbvSec4Sub2D1Body =>
      'ለጥቃት ዜሮ መቻቻል እንዲኖር እና ለተጎጂዎች ደጋፊ አካባቢ ለመፍጠር ከማህበረሰብ መሪዎች እና የሃይማኖት አባቶች ጋር መስራት።';

  @override
  String get gbvSec4Sub2D2Title => 'የእርስ በርስ ድጋፍ ቡድኖች፡';

  @override
  String get gbvSec4Sub2D2Body =>
      'ተጎጂዎች እርስ በርስ የሚደጋገፉበት እና ልምዳቸውን የሚጋሩበት መድረኮችን መፍጠር።';

  @override
  String get gbvSec4Sub2ETitle => 'ትምህርት እና ግንዛቤ';

  @override
  String get gbvSec4Sub2E1Title => 'የትምህርት ቤት ሥርዓተ-ትምህርቶች፡';

  @override
  String get gbvSec4Sub2E1Body =>
      'ስለ ፈቃደኝነት፣ ስለ አክብሮት የተሞላበት ግንኙነት እና ስለ ጤናማ ፆታዊነት ወጣቶችን ማስተማር።';

  @override
  String get gbvSec4Sub2E2Title => 'የስራ ቦታ ስልጠና፡';

  @override
  String get gbvSec4Sub2E2Body =>
      'በስራ ቦታ ላይ የሚደርስ ፆታዊ ትንኮሳን እና በደልን ለመከላከል ፖሊሲዎችን እና የስልጠና ፕሮግራሞችን ማዘጋጀት፣ ግልጽ የሪፖርት ማድረጊያ መንገዶች መኖራቸውን ማረጋገጥ።';

  @override
  String get gbvSec4Sub2E3Title => 'የህዝብ ዘመቻዎች፡';

  @override
  String get gbvSec4Sub2E3Body =>
      'ስለ GBV ግንዛቤን ለማሳደግ እና ከፆታ እና ጥቃት ጋር የተያያዙ ጎጂ ልማዶችን ለመፈታተን ሚዲያን መጠቀም።';

  @override
  String get gbvSec4Main3Title => 'የረጅም ጊዜ ስልቶች፡ መዋቅራዊ እና ባህላዊ ሁኔታዎችን መለወጥ';

  @override
  String get gbvSec4Main3Intro =>
      'የሥርዓተ-ፆታ ጥቃትን የሚያስቀጥሉ ማህበራዊ፣ ባህላዊ እና ኢኮኖሚያዊ ምክንያቶችን ለመፍታት የረጅም ጊዜ ጥረቶች ያስፈልጋሉ።';

  @override
  String get gbvSec4Sub3ATitle => 'የፆታ እኩልነት ጉድለትን መፍታት';

  @override
  String get gbvSec4Sub3A1Title => 'የፆታ እኩልነትን ማሳደግ፡';

  @override
  String get gbvSec4Sub3A1Body =>
      'በትምህርት፣ በስራ፣ በጤና አጠባበቅ እና በፖለቲካ ተሳትፎ ላሉ መስኮች ለሁሉም ፆታዎች እኩል መብቶችን ማረጋገጥ።';

  @override
  String get gbvSec4Sub3A2Title => 'የሴቶችን መብት ማጠናከር፡';

  @override
  String get gbvSec4Sub3A2Body =>
      'የንብረት ባለቤትነት፣ ውርስ እና የህዝብ አገልግሎቶችን የማግኘት መብትን ጨምሮ ለሴቶች ህጋዊ እና ማህበራዊ መብቶች መሟገት።';

  @override
  String get gbvSec4Sub3A3Title => 'አድሏዊ አሰራሮችን ማስቆም፡';

  @override
  String get gbvSec4Sub3A3Body =>
      'በአባቶች የበላይነት ማህበራዊ መዋቅር ውስጥ የተመሰረቱ እንደ ያለዕድሜ ጋብቻ፣ ከጥሎሽ ጋር የተያያዙ ጥቃቶች እና የሴቶች ግርዛት የመሳሰሉ ጎጂ ልማዶችን መዋጋት።';

  @override
  String get gbvSec4Sub3BTitle => 'ወንዶችን እና ወንድ ልጆችን ማሳተፍ';

  @override
  String get gbvSec4Sub3B1Title => 'አዎንታዊ የወንድነት ባህሪ፡';

  @override
  String get gbvSec4Sub3B1Body =>
      'ጥቃት አልባ፣ አክብሮት የተሞላበት እና የፆታ እኩልነትን የሚደግፍ የወንድነት ሞዴልን ማስተዋወቅ።';

  @override
  String get gbvSec4Sub3B2Title => 'የጥቃት መከላከያ ፕሮግራሞች፡';

  @override
  String get gbvSec4Sub3B2Body =>
      'ወንዶችንና ወንዶች ልጆችን ስለ ጥቃቱ ጎጂነት እና በGBV ትግል ውስጥ ደጋፊ አጋር የመሆንን አስፈላጊነት ማስተማር።';

  @override
  String get gbvSection4HelpAlert =>
      'እርስዎ ወይም የሚያውቁት ሰው ጥቃት ወይም በደል እያጋጠመዎት ከሆነ ብቻዎን አይደሉም። ደህንነቱ የተጠበቀ እና ሚስጥራዊ የህክምና እና የህግ ድጋፍ አለ። በነጻ የስልክ መስመሮች 952፣ 8335 ወይም 7711 በመደወል አሁኑኑ ያግኙ።';

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

  @override
  String get greetingMorning => 'እንደምን አደሩ';

  @override
  String get greetingAfternoon => 'እንደምን ዋሉ';

  @override
  String get greetingEvening => 'እንደምን አመሹ';

  @override
  String get guestGreetingSubtitle => 'የግል እና አስተማማኝ የወጣቶች ጤና መመሪያዎ';

  @override
  String get guestUser => 'እንግዳ ተጠቃሚ';

  @override
  String get dailyTipBadge => 'የቀኑ የጤና መረጃ';

  @override
  String get dailyTipMythFact => 'እውነታ ወይስ የተሳሳተ አመለካከት';

  @override
  String get dailyTipTitle => 'በጉርምስና ወቅት የሚከሰቱ የሆርሞን ለውጦች';

  @override
  String get dailyTipBody =>
      'የቆዳ ሽፍታና የስሜት መለዋወጥ በእድገት ወቅት የሚከሰቱ የተለመዱ አካላዊ ለውጦች እንጂ የንፅህና ጉድለት አይደሉም።';

  @override
  String get readArticleAction => 'ጽሑፉን ያንብቡ';

  @override
  String get emergencyHelplineTitle => '24/7 ነፃ እና ሚስጥራዊ የስልክ መስመሮች';

  @override
  String get emergencyHelplineSubtitle =>
      'ነፃ መስመር፦ 952 (ጤና ጥበቃ) / 8335 (የወጣቶች መስመር)';

  @override
  String get emergencyHelplineAction => 'እርዳታ ያግኙ';

  @override
  String get emergencySheetTitle => 'አጣዳፊ እርዳታ እና ድጋፍ';

  @override
  String get emergencySheetDisclaimer =>
      'ለአጣዳፊ የጤና እና የአእምሮ ጭንቀት ድንገተኛ አደጋዎች በማንኛውም ጊዜ በነፃ ይደውሉ።';

  @override
  String get emergencyHotline952Name => 'ብሔራዊ የጤና ድንገተኛ አደጋ መስመር';

  @override
  String get emergencyHotline952Desc =>
      'የጤና ጥበቃ ሚኒስቴር 24/7 ነፃ የድንገተኛ የጤና አገልግሎት';

  @override
  String get emergencyHotline8335Name => 'ብሔራዊ የወጣቶች እና የአእምሮ ጤና መስመር';

  @override
  String get emergencyHotline8335Desc =>
      'ሚስጥራዊ የስነ-ተዋልዶ እና የአእምሮ ጤና የምክር አገልግሎት';

  @override
  String get exploreServicesHeading => 'አገልግሎቶችን ያስሱ';

  @override
  String get exploreServicesSubtitle => 'የግል መገምገሚያ፣ የወጣቶች ማዕከላትና የምክር አገልግሎት';

  @override
  String get callNowAction => 'አሁን ይደውሉ';

  @override
  String get pubertyHeroDesc =>
      'የጉርምስና ወቅት ከአካላዊ፣ ከሆርሞንና ከስሜታዊ ለውጦች ጋር የተያያዘ የተፈጥሮ የዕድገት ደረጃ ሲሆን የግል እድገትንና ጤናን ይቀርጻል።';

  @override
  String get pubertyNoteText =>
      'እያንዳንዱ ታዳጊ ጉርምስናን በራሱ የተፈጥሮ ፍጥነት ያሳልፋል—ጥሩ የግል ንጽህናን መጠበቅ፣ የሰውነት ለውጦችን መረዳትና በራስ መተማመን ለጤናማ ሽግግር ወሳኝ ናቸው።';

  @override
  String get pubertySection1Title => 'የጉርምስና እና የታዳጊነት ወቅት ግንዛቤ';

  @override
  String get pubertySection1Subtitle => 'ወደ ጉልምስና የሚደረግ ተፈጥሯዊ ሽግግር';

  @override
  String get pubertySection1Intro =>
      'ጉርምስና የሰውነት ሆርሞኖች እና አካላዊ እድገት በፍጥነት የሚከሰቱበት እና የመራባት አቅም የሚዳብርበት ተፈጥሯዊ የዕድገት ምዕራፍ ነው።';

  @override
  String get pubertySection1Item1 =>
      'የሆርሞን ለውጦች፡ የፒቱታሪ እጢ ሆርሞኖችን በማመንጨት ሰውነት እንዲያድግና ሁለተኛ ደረጃ የፆታ ባህሪያትን እንዲያሳይ ያደርጋል።';

  @override
  String get pubertySection1Item2 =>
      'የዕድሜ ልዩነት፡ ጉርምስና በአብዛኛው በ9 እና በ14 ዓመት መካከል የሚጀምር ሲሆን በሰዎች መካከል የጊዜ ልዩነት መኖሩ የተለመደ ነው።';

  @override
  String get pubertySection1Item3 =>
      'የተፈጥሮ ልዩነቶች፡ ከእኩዮች ጋር በእድገት ፍጥነት መለያየት ሙሉ በሙሉ ተፈጥሯዊና ጤናማ ነው።';

  @override
  String get pubertySection2Title => 'በወንዶች እና በሴቶች ላይ የሚታዩ አካላዊ ለውጦች';

  @override
  String get pubertySection2Subtitle => 'ዋና ዋና የአካል ለውጦች';

  @override
  String get pubertySection2FemaleTitle => 'በሴቶች ላይ የሚታዩ ለውጦች፡';

  @override
  String get pubertySection2FemaleItem1 => 'የጡት ማደግ እና የወገብ መስፋት';

  @override
  String get pubertySection2FemaleItem2 => 'የብብትና የብልት አካባቢ ፀጉር ማብቀል';

  @override
  String get pubertySection2FemaleItem3 =>
      'የወር አበባ መጀመር፣ ማህፀን ለእርግዝና ዝግጁ የሚሆንበት ወርሃዊ ተፈጥሯዊ ዑደት';

  @override
  String get pubertySection2MaleTitle => 'በወንዶች ላይ የሚታዩ ለውጦች፡';

  @override
  String get pubertySection2MaleItem1 => 'የድምፅ መጎርነን (የድምፅ መለወጥ)';

  @override
  String get pubertySection2MaleItem2 =>
      'የፊት፣ የብብት፣ የደረት እና የብልት አካባቢ ፀጉር ማብቀል';

  @override
  String get pubertySection2MaleItem3 =>
      'የዘር ፍሬ እና ብልት ማደግ እንዲሁም በእንቅልፍ ወቅት የሚከሰት የተፈጥሮ የዘር ፈሳሽ መፍሰስ';

  @override
  String get pubertySection3Title => 'ስሜታዊ እና ስነ-ልቦናዊ ለውጦች';

  @override
  String get pubertySection3Subtitle => 'ሀሳቦችንና ስሜቶችን በአግባቡ መምራት';

  @override
  String get pubertySection3Intro =>
      'ከአካላዊ ለውጦች ጎን ለጎን ታዳጊዎች ከፍተኛ የአስተሳሰብ እና የስሜት እድገት ያሳያሉ።';

  @override
  String get pubertySection3Item1 =>
      'የስሜት መዋዠቅ፡ የሆርሞን ለውጦች ከማህበራዊ ሁኔታዎች ጋር ተዳምረው ጊዜያዊ የስሜት መለዋወጥ ሊያስከትሉ ይችላሉ።';

  @override
  String get pubertySection3Item2 =>
      'ማንነትን ማወቅ፡ ራስን መረዳት፣ የግል እሴቶችን መለየት እና የራስን ማንነት መገንባት።';

  @override
  String get pubertySection3Item3 =>
      'ነጻነትን መፈለግ፡ የራስን ውሳኔ የመወሰን እና ነጻ የመሆን ፍላጎት መጨመር።';

  @override
  String get pubertySection3Item4 =>
      'የጓደኞች ተጽዕኖ፡ ጓደኝነት እና ማህበራዊ ግንኙነቶች ለስሜታዊ ድጋፍ ትልቅ ቦታ ይኖራቸዋል።';

  @override
  String get pubertySection4Title => 'በጉርምስና ወቅት የግል ንጽህና እና እንክብካቤ';

  @override
  String get pubertySection4Subtitle => 'ለዕድሜ ልክ ጤና የሚጠቅሙ ዕለታዊ ልማዶች';

  @override
  String get pubertySection4Item1 =>
      'መታጠብ እና የሰውነት ሽታ መከላከል፡ የላብ እጢዎች በከፍተኛ ሁኔታ ስለሚሰሩ በንጹህ ውሃ እና ሳሙና በየቀኑ መታጠብ የሰውነት ሽታን ይከላከላል።';

  @override
  String get pubertySection4Item2 =>
      'የፊትና የቆዳ እንክብካቤ፡ የቅባት መጨመር የፊት ላይ ብጉር ሊያመጣ ስለሚችል ፊትን በቀን ሁለት ጊዜ መታጠብና ብጉርን አለመንካት ይመረጣል።';

  @override
  String get pubertySection4Item3 =>
      'የወር አበባ ንጽህና፡ ሞዴስን በየ4-6 ሰዓቱ መቀየር፣ እጅን በሳሙና መታጠብ እና ያገለገሉ ቁሳቁሶችን በአግባቡ ማስወገድ።';

  @override
  String get pubertySection4Item4 =>
      'ምግብና እንቅልፍ፡ በማደግ ላይ ያለ ሰውነት በቂ እረፍት (8-10 ሰዓታት እንቅልፍ) እና የተመጣጠነ ምግብ ይፈልጋል።';

  @override
  String get pubertyQuizTitle => 'የታዳጊዎች ጤና እና ጉርምስና ጥያቄዎች';

  @override
  String get pubertyQ1Text =>
      'ጉርምስና እያንዳንዱ ሰው በራሱ የተፈጥሮ ፍጥነት የሚያልፍበት ጤናማና ተፈጥሯዊ የዕድገት ደረጃ ነው።';

  @override
  String get pubertyQ1Insight =>
      'ጉርምስና ለሁሉም ሰው በተለያየ ዕድሜ (ከ9 እስከ 14 ዓመት) ይጀምራል፤ በጊዜውና በፍጥነቱ መለያየት ፍጹም ተፈጥሯዊ ነው።';

  @override
  String get pubertyQ2Text =>
      'በወንዶች የጉርምስና ወቅት የሚታየው ጤናማና ተፈጥሯዊ አካላዊ ለውጥ የትኛው ነው?';

  @override
  String get pubertyQ2OptA => 'የድምፅ መጎርነን እና የፊት እንዲሁም የሰውነት ፀጉር ማብቀል';

  @override
  String get pubertyQ2OptB => 'ድንገተኛ የምግብ ፍላጎት ሙሉ በሙሉ መጥፋት';

  @override
  String get pubertyQ2OptC => 'እንቅልፍ ሙሉ በሙሉ ማጣት';

  @override
  String get pubertyQ2OptD => 'የአካል ብቃት እንቅስቃሴ ማድረግ አለመቻል';

  @override
  String get pubertyQ2Insight =>
      'የድምፅ መጎርነን እና የሰውነት ፀጉር ማደግ የወንድ ሆርሞን (ቴስቶስትሮን) መመንጨትና የተፈጥሮ ዕድገት ምልክቶች ናቸው።';

  @override
  String get pubertyQ3Text => 'በወር አበባ ወቅት የሚመከረው ትክክለኛ የንጽህና አጠባበቅ የትኛው ነው?';

  @override
  String get pubertyQ3OptA => 'የንጽህና መጠበቂያ ቁሳቁሶችን በየ 4–6 ሰዓት መቀየር እና እጅን መታጠብ';

  @override
  String get pubertyQ3OptB => 'የወር አበባ እስኪያበቃ ድረስ አለመታጠብ';

  @override
  String get pubertyQ3OptC => 'ያልታጠበ ጨርቅን ደጋግሞ መጠቀም';

  @override
  String get pubertyQ3OptD => 'በዑደቱ ወቅት ውሃ አለመጠጣት';

  @override
  String get pubertyQ3Insight =>
      'የንጽህና መጠበቂያዎችን በየ 4 እስከ 6 ሰዓቱ መቀየርና እጅን በሳሙና መታጠብ ኢንፌክሽንንና አለርጂን ይከላከላል።';

  @override
  String get pubertyQ4Text =>
      'በጉርምስና ወቅት የሚታዩ የስሜት መለዋወጦች የተለመዱ ሲሆኑ በውይይት፣ በአካል ብቃት እንቅስቃሴ እና በበቂ እንቅልፍ ማስተካከል ይቻላል።';

  @override
  String get pubertyQ4Insight =>
      'የሆርሞን ለውጦች የስሜት መዋዠቅ ሊፈጥሩ ይችላሉ፤ ከታመኑ ቤተሰቦች ወይም ጓደኞች ጋር መወያየት መፍትሄ ያመጣል።';

  @override
  String get stiQuizTitle => 'በግብረ-ሥጋ ግንኙነት የሚተላለፉ ኢንፌክሽኖች ጥያቄዎች';

  @override
  String get stiQ1Text =>
      'ብዙ በግብረ-ሥጋ ግንኙነት የሚተላለፉ ኢንፌክሽኖች መጀመሪያ ላይ ምንም ምልክት ላያሳዩ ስለሚችሉ መደበኛ ምርመራ ማድረግ አስፈላጊ ነው።';

  @override
  String get stiQ1Insight =>
      'እንደ ክላሚዲያ እና ጨብጥ ያሉ ኢንፌክሽኖች ብዙ ጊዜ ምልክት አያሳዩም፤ መደበኛ ምርመራ ማድረግ ችግሮች ሳይፈጠሩ ቀድሞ ለማከም ይረዳል።';

  @override
  String get stiQ2Text =>
      'በግብረ-ሥጋ ግንኙነት ወቅት የአባላዘር በሽታዎችን የመተላለፍ እድል በከፍተኛ ደረጃ የሚቀንሰው የትኛው ነው?';

  @override
  String get stiQ2OptA => 'ኮንዶምን በአግባቡ እና ዘወትር መጠቀም';

  @override
  String get stiQ2OptB => 'ከግንኙነት በፊት ቫይታሚን መውሰድ';

  @override
  String get stiQ2OptC => 'ከግንኙነት በኋላ በሙቅ ውሃ ብቻ መታጠብ';

  @override
  String get stiQ2OptD => 'የባህል ሻይ መጠጣት';

  @override
  String get stiQ2Insight =>
      'ኮንዶምን በአግባቡና በተከታታይ መጠቀም የአባላዘር ኢንፌክሽኖች እንዳይተላለፉ አስተማማኝ መከላከያ ይሆናል።';

  @override
  String get stiQ3Text =>
      'በአባላዘር በሽታ ተይዘው ፀረ-ባክቴሪያ (አንቲባዮቲክ) መድኃኒት ከታዘዘልዎት መከተል ያለብዎት ዋነኛ መመሪያ የትኛው ነው?';

  @override
  String get stiQ3OptA => 'በጤና ባለሙያው የታዘዘውን ሙሉ የመድኃኒት መጠን ሳይቋርጡ መጨረስ';

  @override
  String get stiQ3OptB => 'ህመሙ ልክ ሲጠፋ መድኃኒቱን ወዲያው ማቆም';

  @override
  String get stiQ3OptC => 'የቀረውን መድኃኒት ለጓደኛ ማጋራት';

  @override
  String get stiQ3OptD => 'በመጨረሻው ቀን እጥፍ መጠን መውሰድ';

  @override
  String get stiQ3Insight =>
      'መድኃኒትን ቀድሞ ማቆም ባክቴሪያው መድኃኒቱን እንዲላመድ እና በሽታው ተመልሶ እንዲመጣ ያደርጋል፤ ሙሉ መጠኑን መጨረስ ግድ ነው።';

  @override
  String get stiQ4Text =>
      'አንድ ሰው በአባላዘር በሽታ ተመርምሮ ሲታከም በሽታው እንዳይደጋገም የፍቅር አጋሩም አብሮ መታከም አለበት።';

  @override
  String get stiQ4Insight =>
      'አጋርን አብሮ ማከም ኢንፌክሽኑ ተመልሶ እንዳይተላለፍ እና ዘላቂ ጤና እንዲኖር ያደርጋል።';

  @override
  String get hepatitisQuizTitle => 'የሄፓታይተስ ሞጁል ጥያቄዎች';

  @override
  String get hepatitisQ1Text => 'ሄፓታይተስ በዋናነት የትኛውን የሰውነት ክፍል ያጠቃል?';

  @override
  String get hepatitisQ1OptA => 'ጉበት';

  @override
  String get hepatitisQ1OptB => 'ሳንባ';

  @override
  String get hepatitisQ1OptC => 'ልብ';

  @override
  String get hepatitisQ1OptD => 'ኩላሊት';

  @override
  String get hepatitisQ1Insight =>
      'ሄፓታይተስ መርዞችን በማጣራት፣ ምግብ በማዋሃድና ሃይል በማከማቸት ወሳኝ የሆነውን ጉበት የሚያጠቃ እብጠት ነው።';

  @override
  String get hepatitisQ2Text =>
      'ሄፓታይተስ ኤ እና ሄፓታይተስ ኢ በዋናነት በተበከለ ምግብ እና ውሃ ስለሚተላለፉ ንጹህ ውሃ መጠቀም እና እጅን መታጠብ ቁልፍ መከላከያ ናቸው።';

  @override
  String get hepatitisQ2Insight =>
      'ሄፓታይተስ ኤ እና ኢ በምግብ እና በውሃ ይተላለፋሉ፤ እጅን በአግባቡ መታጠብና ንጹህ ውሃ መጠቀም ስርጭቱን ይከላከላል።';

  @override
  String get hepatitisQ3Text => 'ከሄፓታይተስ ቢ ኢንፌክሽን በአስተማማኝ ሁኔታ የሚከላከል የትኛው ነው?';

  @override
  String get hepatitisQ3OptA => 'የሄፓታይተስ ቢ ክትባት መከተብ እና ምርመራ ማድረግ';

  @override
  String get hepatitisQ3OptB => 'ካፌይን ያላቸውን መጠጦች አብዝቶ መጠጣት';

  @override
  String get hepatitisQ3OptC => 'የሰውነት እንቅስቃሴ አለማድረግ';

  @override
  String get hepatitisQ3OptD => 'የህመም ማስታገሻዎችን በየቀኑ መውሰድ';

  @override
  String get hepatitisQ3Insight =>
      'የሄፓታይተስ ቢ ክትባት ዘላቂ የመከላከል አቅም ይሰጣል፤ ስለታማ ቁሳቁሶችን አለመጋራትም በሽታውን ይከላከላል።';

  @override
  String get hepatitisQ4Text =>
      'ዘመናዊ የፀረ-ቫይረስ (DAA) መድኃኒቶች ከ95% በላይ የሚሆኑ የከፋ የሄፓታይተስ ሲ ታማሚዎችን ሙሉ በሙሉ ማዳን ይችላሉ።';

  @override
  String get hepatitisQ4Insight =>
      'የህክምና እድገት ሥር የሰደደውን ሄፓታይተስ ሲ በ8-12 ሳምንታት የጡባዊ መድኃኒት ሙሉ በሙሉ ሊድን የሚችል አድርጎታል።';

  @override
  String get gbvQuizTitle => 'በፆታ ላይ የተመሰረተ ጥቃት ጥያቄዎች';

  @override
  String get gbvQ1Text =>
      'በፆታ ላይ የተመሰረተ ጥቃት (GBV) በአንድ ግለሰብ ላይ በፆታው ምክንያት የሚደርስ አካላዊ፣ ወሲባዊ፣ ስነ-ልቦናዊ እና ኢኮኖሚያዊ ጉዳትን ያካትታል።';

  @override
  String get gbvQ1Insight =>
      'GBV ጫናን፣ ስሜታዊ ጥቃትን፣ አካላዊ ጉዳትን እና የኢኮኖሚ ጥገኝነትን የሚያካትት ሰፊ ማህበራዊና የሰብአዊ መብት ጉዳይ ነው።';

  @override
  String get gbvQ2Text =>
      'ፆታዊ ጥቃት የደረሰበትን ሰው በሚደገፍበት ወቅት ወሳኝ የሆነው አስቸኳይ እርምጃ የትኛው ነው?';

  @override
  String get gbvQ2OptA =>
      'ደህንነታቸውን ማረጋገጥ እና ሚስጥራዊ የህክምና እርዳታ (በ72 ሰዓታት ውስጥ የPEP ህክምና) ማግኘት';

  @override
  String get gbvQ2OptB => 'ለደረሰባቸው ሁኔታ እነሱን ተጠያቂ ማድረግ';

  @override
  String get gbvQ2OptC => 'የግል ታሪካቸውን ለአካባቢው ሰው ማውራት';

  @override
  String get gbvQ2OptD => 'ስሜታቸውን ችላ ብሎ ዝም እንዲሉ መምከር';

  @override
  String get gbvQ2Insight =>
      'አስቸኳይ ደህንነትን መጠበቅ፣ ያለፍርድ ማዳመጥ እና በ72 ሰዓታት ውስጥ የPEP ህክምና ማግኘት ለተጎጂዎች ህይወት አድን ነው።';

  @override
  String get gbvQ3Text =>
      'ወንዶች በማህበረሰቡ ውስጥ በፆታ ላይ የተመሰረተ ጥቃትን ለመከላከል ምን አይነት አዎንታዊ ሚና መጫወት ይችላሉ?';

  @override
  String get gbvQ3OptA => 'የተከበረ ግንኙነትን ማበረታታት፣ የጥቃት ባህልን መቃወም እና ድምጽ መሆን';

  @override
  String get gbvQ3OptB => 'ጥቃት ሲፈጸም እያዩ ዝም ማለት';

  @override
  String get gbvQ3OptC => 'ጎጂ ልማዳዊ ድርጊቶችን ማበረታታት';

  @override
  String get gbvQ3OptD => 'ሴቶች ትምህርት እንዳይማሩ መከልከል';

  @override
  String get gbvQ3Insight =>
      'ወንዶችን ለፆታ እኩልነት አጋርና ግንባር ቀደም ተሟጋች ማድረግ ለሁሉም ሰው አስተማማኝ ማህበረሰብ ይፈጥራል።';

  @override
  String get gbvQ4Text =>
      'በፆታ ላይ የተመሰረተ ጥቃት ሰለባ የሆኑ ሰዎች ለደረሰባቸው ጥቃት ፈጽሞ ተጠያቂ አይደሉም።';

  @override
  String get gbvQ4Insight =>
      'የጥቃቱ ሙሉ ተጠያቂ አጥፊው ብቻ ነው፤ ተጎጂዎችን ተጠያቂ ማድረግ ተጨማሪ ስነ-ልቦናዊ ጉዳት ያስከትላል።';

  @override
  String get srhHeroDesc =>
      'የሥነ-ተዋልዶ ጤና ከመራቢያ አካላት፣ ከግንኙነቶች እና ከመውለድ ጋር በተያያዙ ጉዳዮች ሁሉ ሙሉ አካላዊ፣ አእምሮአዊ እና ማህበራዊ ደህንነት ነው።';

  @override
  String get srhNoteText =>
      'በቂ ግንዛቤ ማግኘት፣ የጋራ መከባበር፣ ግልጽ ውይይት እና የጤና አገልግሎት ማግኘት ለጤናማ ግንኙነትና ለቤተሰብ እቅድ ወሳኝ ናቸው።';

  @override
  String get srhSection1Title => 'የሥነ-ተዋልዶ ጤና ግንዛቤ';

  @override
  String get srhSection1Subtitle => 'አጠቃላይ የጤና እና የደህንነት እይታ';

  @override
  String get srhSection1Intro =>
      'የሥነ-ተዋልዶ ጤና በሽታ አለመኖር ብቻ ሳይሆን ስለ ሰውነት፣ ስለ ግንኙነት እና ስለወደፊት ህይወት በመረጃ ላይ የተመሰረተ ውሳኔ የማድረግ መብት ነው።';

  @override
  String get srhSection1Item1 =>
      'አካላዊ ጤና፡ የመራቢያ አካላትን መንከባከብ፣ ኢንፌክሽኖችን መከላከል እና መደበኛ ምርመራ ማድረግ።';

  @override
  String get srhSection1Item2 =>
      'ስሜታዊ ጤና፡ በራስ መተማመንን መገንባት፣ የሰውነት ገጽታን መውደድ እና በግንኙነት ውስጥ መከባበር።';

  @override
  String get srhSection1Item3 =>
      'ማህበራዊ ደህንነት፡ ከአድሎ፣ ከማግለልና ከፆታ ልዩነት የጸዳ እኩልነትን መጎናጸፍ።';

  @override
  String get srhSection2Title => 'የሥነ-ተዋልዶ አካላት እና አሰራራቸው';

  @override
  String get srhSection2Subtitle => 'የሰውነት ተፈጥሯዊ አሰራር';

  @override
  String get srhSection2Intro =>
      'የሴት እና የወንድ የስነ-ተዋልዶ አካላትን አሰራር መረዳት ሰዎች ጤናቸውን በአግባቡ እንዲጠብቁ ያግዛል።';

  @override
  String get srhSection2Item1 =>
      'የሴት ስነ-ተዋልዶ አካላት፡ እንቁላል እና ሆርሞኖችን (ኢስትሮጅን/ፕሮጄስትሮን) ያመነጫሉ፤ ማህፀን ደግሞ ፅንስ የሚያድግበት ነው።';

  @override
  String get srhSection2Item2 =>
      'የወንድ ስነ-ተዋልዶ አካላት፡ የዘር ፍሬ እና ቴስቶስትሮን ያመነጫሉ፤ ስፐርም በሽንት ቧንቧ በኩል ይጓዛል።';

  @override
  String get srhSection2Item3 =>
      'ፅንስ መፈጠር፡ የወንድ የዘር ፈሳሽ ከበሰለ እንቁላል ጋር ሲገናኝ እርግዝና ይፈጠራል።';

  @override
  String get srhSection3Title => 'የቤተሰብ ምጣኔ እና የወሊድ መከላከያ ዘዴዎች';

  @override
  String get srhSection3Subtitle => 'የህይወት እና የቤተሰብ እቅድን ማሳለጥ';

  @override
  String get srhSection3Intro =>
      'የቤተሰብ ምጣኔ ሰዎች መቼና ስንት ልጆች እንደሚፈልጉ እንዲወስኑ በማድረግ የእናቶችንና የህፃናትን ጤና ይጠብቃል።';

  @override
  String get srhSection3Item1 =>
      'የኮንዶም አጠቃቀም፡ እርግዝናን የሚከላከል ከመሆኑም ባሻገር ከአባላዘር በሽታዎችና ከኤች አይ ቪ ይጠብቃል (ድርብ ጥበቃ)።';

  @override
  String get srhSection3Item2 =>
      'የሆርሞን ዘዴዎች፡ የሚዋጡ ኪኒኖች፣ የመርፌ መድኃኒቶችና የእጅ ውስጥ መከላከያዎች አስተማማኝ ጥበቃ ይሰጣሉ።';

  @override
  String get srhSection3Item3 =>
      'ዘላቂ ዘዴዎች፡ የልጅ ፍላጎታቸውን ላጠናቀቁ ሰዎች የሚደረጉ ቀላል የቀዶ ጥገና ዘዴዎች ናቸው።';

  @override
  String get srhSection3Item4 =>
      'የአስቸኳይ ጊዜ መከላከያ፡ ጥንቃቄ የጎደለው ግንኙነት ከተፈጠረ በኋላ በ 72–120 ሰዓታት ውስጥ ያልተፈለገ እርግዝናን መከላከል ይችላል።';

  @override
  String get srhSection4Title => 'ስምምነት፣ መብቶች እና ጤናማ ግንኙነቶች';

  @override
  String get srhSection4Subtitle => 'መተማመን እና የጋራ መከባበርን መገንባት';

  @override
  String get srhSection4Intro =>
      'ጤናማ ግንኙነቶች የሚገነቡት በግልጽ ውይይት፣ በእኩልነት እና ያለምንም ጫና በሚደረግ የጋራ ስምምነት ነው።';

  @override
  String get srhSection4Item1 =>
      'ስምምነት ማለት፡ ያለ ምንም ማስገደድ፣ በነጻነትና በግልጽ የሚደረግ የሁለትዮሽ ስምምነት ነው።';

  @override
  String get srhSection4Item2 =>
      'የሰውነት ራስን በራስ የማስተዳደር መብት፡ እያንዳንዱ ሰው በገዛ ሰውነቱ እና በስነ-ተዋልዶ ጤናው ላይ የመወሰን ሙሉ መብት አለው።';

  @override
  String get srhSection4Item3 =>
      'ግልጽ ውይይት፡ ከአጋር ጋር ስለ ድንበሮች፣ ስለ ጤና ታሪክ እና ስለ መከላከያ ዘዴዎች መወያየት ግንኙነትን ጤናማ ያደርጋል።';

  @override
  String get srhQuizTitle => 'የሥነ-ተዋልዶ ጤና ጥያቄዎች';

  @override
  String get srhQ1Text =>
      'የሥነ-ተዋልዶ ጤና የአካል፣ የአእምሮ እና የማህበራዊ ደህንነትን የሚያጠቃልል እንጂ በሽታ አለመኖር ብቻ አይደለም።';

  @override
  String get srhQ1Insight =>
      'የዓለም ጤና ድርጅት የሥነ-ተዋልዶ ጤናን የግል መብትንና ምርጫን የሚያከብር ሁለንተናዊ ደህንነት እንደሆነ ይገልጻል።';

  @override
  String get srhQ2Text =>
      'ያልተፈለገ እርግዝናን ከመከላከል በተጨማሪ ከአባላዘር በሽታዎች \'ድርብ ጥበቃ\' የሚሰጠው የትኛው ዘዴ ነው?';

  @override
  String get srhQ2OptA => 'የወንድ ወይም የሴት ኮንዶም';

  @override
  String get srhQ2OptB => 'የሚዋጡ የወሊድ መከላከያ ኪኒኖች ብቻ';

  @override
  String get srhQ2OptC => 'የመርፌ መከላከያዎች ብቻ';

  @override
  String get srhQ2OptD => 'የማህፀን ሉፕ ብቻ';

  @override
  String get srhQ2Insight =>
      'የሆርሞን ዘዴዎች እርግዝናን ብቻ የሚከላከሉ ሲሆን ኮንዶም ግን እርግዝናንና የአባላዘር ኢንፌክሽኖችን በአንድ ላይ ይከላከላል።';

  @override
  String get srhQ3Text =>
      'በማንኛውም ጤናማ ግንኙነት ውስጥ ስምምነት በነጻነት፣ በፍላጎትና በግልጽ የሚሰጥ እንዲሁም በማንኛውም ጊዜ ሊለወጥ የሚችል መሆን አለበት።';

  @override
  String get srhQ3Insight =>
      'ትክክለኛ ስምምነት ያለምንም ማስገደድ የሚደረግ ነው፤ የአጋርን ድንበር ማክበር ለጤናማ ግንኙነት መሰረት ነው።';

  @override
  String get srhQ4Text =>
      'የቤተሰብ ምጣኔ ሰዎች መቼና ስንት ልጆች መውለድ እንዳለባቸው እንዲመርጡ በማድረግ የእናቶችንና የቤተሰብን ደህንነት ያጠናክራል።';

  @override
  String get srhQ4Insight =>
      'የቤተሰብ ምጣኔ ሴቶችን ያበረታል፣ የእናቶች ሞትን ይቀንሳል እንዲሁም ለልጆች ጤናማ እድገት አስተዋጽኦ ያደርጋል።';
}
