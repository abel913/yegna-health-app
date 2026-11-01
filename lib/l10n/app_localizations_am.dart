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
}
