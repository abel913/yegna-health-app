import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/auth/auth_controller.dart';
import 'package:yegna_health_app/src/learning/gbv_page.dart';
import 'package:yegna_health_app/src/learning/learning_progress_controller.dart';
import 'package:yegna_health_app/src/locale_controller.dart';

import 'support/fake_auth_repository.dart';
import 'support/fake_learning.dart';

void main() {
  late LocaleController localeController;
  late LearningProgressController progressController;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    localeController = LocaleController(preferences);
    await localeController.load();

    final authRepository = FakeAuthRepository();
    final authController = AuthController(authRepository);
    final progressStore = FakeLearningProgressStore();
    progressController = LearningProgressController(
      repository: progressStore,
      authController: authController,
    );
  });

  Widget buildTestWidget({Locale locale = const Locale('en')}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: GenderBasedViolenceDetailPage(
        progressController: progressController,
      ),
    );
  }

  testWidgets(
      'GenderBasedViolenceDetailPage displays hero card, note, and 4 accordion sections',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Verify AppBar
    expect(find.text('Learning Modules'), findsOneWidget);

    // Verify Hero Card & Title
    expect(find.text('Gender-based violence (GBV)'), findsOneWidget);
    expect(
        find.textContaining(
            'Gender-based violence is harmful behavior directed'),
        findsOneWidget);

    // Verify Note Section
    expect(find.text('Note'), findsOneWidget);
    expect(find.byIcon(Icons.lightbulb_outline_rounded), findsOneWidget);
    expect(find.textContaining('GBV is preventable—promoting respect'),
        findsOneWidget);

    // Verify Learning Sections Header & Count Pill
    expect(find.text('Learning Sections'), findsOneWidget);
    expect(find.text('0 / 4 read'), findsOneWidget);

    // Verify 4 Accordion section headers
    expect(find.text('Definition'), findsOneWidget);
    expect(find.text('Sex and Gender'), findsOneWidget);
    expect(find.text('Consequences of gender-based violence'), findsOneWidget);
    expect(
        find.text('Management and Prevention of Gender-Based Violence (GBV)'),
        findsOneWidget);

    // Expand Section 1: Definition
    await tester.tap(find.text('Definition'));
    await tester.pumpAndSettle();

    expect(find.text('1 / 4 read'), findsOneWidget);
    expect(
        find.textContaining(
            'Gender-based violence (GBV) refers to harmful acts directed'),
        findsOneWidget);
    expect(
        find.textContaining(
            'In humanitarian settings, responding to sexual violence'),
        findsOneWidget);
    expect(find.text('Physical Violence'), findsOneWidget);
    expect(
        find.textContaining('Domestic violence (intimate partner violence):',
            findRichText: true),
        findsOneWidget);
    expect(find.text('Psychological/Emotional Violence'), findsOneWidget);
    expect(find.textContaining('Coercive control:', findRichText: true),
        findsOneWidget);
    expect(find.text('Sexual Violence and Exploitation'), findsOneWidget);
    expect(find.text('Economic Violence'), findsOneWidget);
    expect(find.text('Harmful Traditional Practices'), findsOneWidget);
    expect(
        find.textContaining('Female genital mutilation/cutting (FGM/C):',
            findRichText: true),
        findsOneWidget);

    // Expand Section 2: Sex and Gender
    final section2Finder = find.text('Sex and Gender');
    await tester.ensureVisible(section2Finder);
    await tester.pumpAndSettle();
    await tester.tap(section2Finder);
    await tester.pumpAndSettle();

    expect(find.text('2 / 4 read'), findsOneWidget);
    expect(
        find.textContaining(
            'Understanding the distinction between sex and gender is essential'),
        findsOneWidget);

    // Expand Section 3: Consequences of gender-based violence
    final section3Finder = find.text('Consequences of gender-based violence');
    await tester.ensureVisible(section3Finder);
    await tester.pumpAndSettle();
    await tester.tap(section3Finder);
    await tester.pumpAndSettle();

    expect(find.text('3 / 4 read'), findsOneWidget);
    expect(
        find.textContaining('Physical, injury, disability', findRichText: true),
        findsOneWidget);
    expect(find.text('Consequences of GBV'), findsOneWidget);
    expect(find.text('Physical health consequences'), findsOneWidget);
    expect(find.text('Psychological health consequences'), findsOneWidget);
    expect(find.text('Social & Economic consequences'), findsOneWidget);
    expect(find.text('GENDER BASED VIOLENCE'), findsOneWidget);

    // Expand Section 4: Management and Prevention
    final section4Finder =
        find.text('Management and Prevention of Gender-Based Violence (GBV)');
    await tester.ensureVisible(section4Finder);
    await tester.pumpAndSettle();
    await tester.tap(section4Finder);
    await tester.pumpAndSettle();

    expect(find.text('4 / 4 read'), findsOneWidget);
    expect(find.text('Immediate Response: Management of GBV'), findsOneWidget);
    expect(find.text('Providing Safety and Protection'), findsOneWidget);
    expect(find.textContaining('Safe spaces:', findRichText: true),
        findsOneWidget);
    expect(find.text('Preventing GBV'), findsOneWidget);
    expect(find.text('Changing Social Norms and Attitudes'), findsOneWidget);
    expect(find.text('Empowering Women and Gender Minorities'), findsOneWidget);
    expect(find.textContaining('952, 8335, or 7711'), findsOneWidget);

    // Mark as Completed
    final markCompletedFinder = find.text('Mark as Completed');
    await tester.ensureVisible(markCompletedFinder);
    await tester.pumpAndSettle();
    expect(markCompletedFinder, findsOneWidget);
    await tester.tap(markCompletedFinder);
    await tester.pumpAndSettle();

    expect(find.text('Completed'), findsOneWidget);
    expect(
        progressController.progress?.articles
            .any((a) => a.articleId == 'module-04'),
        isTrue);
  });

  testWidgets('GenderBasedViolenceDetailPage supports Amharic localization',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget(locale: const Locale('am')));
    await tester.pumpAndSettle();

    // Verify Amharic AppBar & Title
    expect(find.text('የትምህርት ክፍሎች'), findsWidgets);
    expect(find.text('በጾታ ላይ የተመሰረተ ጥቃት (GBV)'), findsOneWidget);

    // Verify Section Titles
    expect(find.text('ትርጓሜ'), findsOneWidget);
    expect(find.text('ተፈጥሯዊ ፆታ እና ማህበራዊ ፆታ'), findsOneWidget);
    expect(find.text('የሥርዓተ-ፆታ ጥቃት የሚያስከትላቸው ጉዳቶች'), findsOneWidget);
    expect(find.text('የሥርዓተ-ፆታ ጥቃት አያያዝ እና መከላከያ መንገዶች'), findsOneWidget);
  });
}
