import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/auth/auth_controller.dart';
import 'package:yegna_health_app/src/learning/hepatitis_page.dart';
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
      home: HepatitisDetailPage(
        progressController: progressController,
      ),
    );
  }

  testWidgets(
      'HepatitisDetailPage displays hero card, note, and 6 accordion sections',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Verify AppBar
    expect(find.text('Learning Modules'), findsOneWidget);

    // Verify Hero Card & Title
    expect(find.text('Hepatitis'), findsOneWidget);
    expect(
        find.textContaining(
            'Hepatitis is inflammation of the liver caused by viruses'),
        findsOneWidget);

    // Verify Note Section
    expect(find.text('Note'), findsOneWidget);
    expect(find.byIcon(Icons.lightbulb_outline_rounded), findsWidgets);
    expect(find.textContaining('Hepatitis can be prevented and managed'),
        findsOneWidget);

    // Verify Learning Sections Header & Count Pill
    expect(find.text('Learning Sections'), findsOneWidget);
    expect(find.text('0 / 6 read'), findsOneWidget);

    // Verify All 6 Accordion Section Titles
    expect(find.text('Definition'), findsOneWidget);
    expect(find.text('Sign and symptoms of Hepatitis'), findsOneWidget);
    expect(find.text('Diagnosis of Hepatitis'), findsOneWidget);
    expect(find.text('Complication of Hepatitis'), findsOneWidget);
    expect(find.text('Management and treatment of Hepatitis'), findsOneWidget);
    expect(find.text('Prevention Of Hepatitis'), findsOneWidget);

    // Verify Numerical Badge on Section 1 before expansion
    expect(find.text('1'), findsOneWidget);

    // Expand Section 1: Definition
    await tester.tap(find.text('Definition'));
    await tester.pumpAndSettle();
    expect(
        find.textContaining(
            'general term used to describe inflammation of the liver'),
        findsOneWidget);
    expect(
        find.textContaining(
            'most common types of viral hepatitis are A, B, C, D, and E'),
        findsOneWidget);

    // Dynamic Read Counter updates
    expect(find.text('1 / 6 read'), findsOneWidget);

    // Expand Section 2: Sign and symptoms of Hepatitis
    await tester.tap(find.text('Sign and symptoms of Hepatitis'));
    await tester.pumpAndSettle();
    expect(find.textContaining('fever'), findsOneWidget);
    expect(find.textContaining('jaundice'), findsOneWidget);
    expect(find.text('Hepatitis B'), findsOneWidget);
    expect(
        find.text(
            'Hepatitis B is preventable with a vaccine, but it has no cure.'),
        findsOneWidget);
    expect(find.text('Hepatitis C'), findsOneWidget);
    expect(
        find.textContaining(
            'direct-acting antivirals (DAAs) offering a high cure rate'),
        findsOneWidget);

    // Dynamic Read Counter updates to 2
    expect(find.text('2 / 6 read'), findsOneWidget);

    // Expand Section 3: Diagnosis of Hepatitis
    final section3Finder = find.text('Diagnosis of Hepatitis');
    await tester.ensureVisible(section3Finder);
    await tester.pumpAndSettle();
    await tester.tap(section3Finder);
    await tester.pumpAndSettle();
    expect(
        find.textContaining(
            'combination of blood tests, imaging, and sometimes liver biopsy'),
        findsOneWidget);

    // Expand Section 4: Complication of Hepatitis
    final section4Finder = find.text('Complication of Hepatitis');
    await tester.ensureVisible(section4Finder);
    await tester.pumpAndSettle();
    await tester.tap(section4Finder);
    await tester.pumpAndSettle();
    expect(find.text('Chronic Hepatitis'), findsOneWidget);
    expect(find.text('Cirrhosis'), findsOneWidget);
    expect(find.text('Liver Failure'), findsOneWidget);
    expect(
        find.text('Liver Cancer (Hepatocellular Carcinoma)'), findsOneWidget);
    expect(
        find.textContaining(
            'Chronic Hepatitis B and C: If untreated, viral hepatitis can progress to chronic infection'),
        findsOneWidget);

    // Expand Section 5: Management and treatment of Hepatitis
    final section5Finder = find.text('Management and treatment of Hepatitis');
    await tester.ensureVisible(section5Finder);
    await tester.pumpAndSettle();
    await tester.tap(section5Finder);
    await tester.pumpAndSettle();
    expect(
        find.textContaining(
            'resolve on their own with supportive care, others'),
        findsOneWidget);

    // Expand Section 6: Prevention Of Hepatitis
    final section6Finder = find.text('Prevention Of Hepatitis');
    await tester.ensureVisible(section6Finder);
    await tester.pumpAndSettle();
    await tester.tap(section6Finder);
    await tester.pumpAndSettle();
    expect(find.text('General Preventive Measures for All Types of Hepatitis'),
        findsOneWidget);
    expect(find.textContaining('Good Hygiene Practices'), findsOneWidget);

    // Dynamic Read Counter updates to 6
    expect(find.text('6 / 6 read'), findsOneWidget);

    // Scroll down and mark as completed
    final markBtnFinder = find.text('Mark as Completed');
    await tester.ensureVisible(markBtnFinder);
    await tester.pumpAndSettle();
    await tester.tap(markBtnFinder);
    await tester.pumpAndSettle();

    // Verify completion recorded in controller
    expect(
        progressController.progress?.articles
            .any((a) => a.articleId == 'module-03'),
        isTrue);
  });

  testWidgets('HepatitisDetailPage supports Amharic localization',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget(locale: const Locale('am')));
    await tester.pumpAndSettle();

    expect(find.text('የትምህርት ክፍሎች'), findsWidgets);
    expect(find.text('የጉበት በሽታ (ሄፓታይተስ)'), findsOneWidget);
    expect(find.text('ማስታወሻ'), findsOneWidget);
    expect(find.text('ትርጓሜ (Definition)'), findsOneWidget);
    expect(find.text('የሄፓታይተስ ምልክቶች (Sign and symptoms of Hepatitis)'),
        findsOneWidget);
    expect(find.text('የሄፓታይተስ ምርመራ (Diagnosis of Hepatitis)'), findsOneWidget);
    expect(
        find.text('የሄፓታይተስ ችግሮች (Complication of Hepatitis)'), findsOneWidget);
    expect(
        find.text(
            'የሄፓታይተስ አያያዝ እና ህክምና (Management and treatment of Hepatitis)'),
        findsOneWidget);
    expect(
        find.text('ሄፓታይተስን መከላከል (Prevention Of Hepatitis)'), findsOneWidget);
  });
}
