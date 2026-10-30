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
}
