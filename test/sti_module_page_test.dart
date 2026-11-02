import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/auth/auth_controller.dart';
import 'package:yegna_health_app/src/learning/learning_progress_controller.dart';
import 'package:yegna_health_app/src/learning/sti_module_page.dart';
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
      home: StiModuleDetailPage(
        progressController: progressController,
      ),
    );
  }

  testWidgets(
      'StiModuleDetailPage displays hero card, note, and 6 accordion sections',
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
    expect(find.text('Sexual transmitted infections (STI)'), findsOneWidget);
    expect(find.textContaining('STIs are infections spread mainly through'),
        findsOneWidget);

    // Verify Note Section
    expect(find.text('Note'), findsOneWidget);
    expect(find.byIcon(Icons.lightbulb_outline_rounded), findsOneWidget);
    expect(find.textContaining('Protect yourself by practicing safe sex'),
        findsOneWidget);

    // Verify Learning Sections Header & Count Pill
    expect(find.text('Learning Sections'), findsOneWidget);
    expect(find.text('4 / 6 read'), findsOneWidget);

    // Verify All 6 Accordion Section Titles
    expect(find.text('Definition'), findsOneWidget);
    expect(find.text('Signs and Symptoms of STI'), findsOneWidget);
    expect(find.text('Diagnosis of STI'), findsOneWidget);
    expect(find.text('Complications of STI'), findsOneWidget);
    expect(find.text('Management and treatment of STI'), findsOneWidget);
    expect(find.text('Prevention of STI'), findsOneWidget);

    // Expand Section 1: Definition
    await tester.tap(find.text('Definition'));
    await tester.pumpAndSettle();
    expect(find.textContaining('What are Sexually Transmitted Infections'),
        findsOneWidget);
    expect(find.textContaining('Chlamydia, Gonorrhea, and Syphilis'),
        findsOneWidget);

    // Expand Section 2: Signs and Symptoms of STI
    await tester.tap(find.text('Signs and Symptoms of STI'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Unusual discharge'), findsOneWidget);
    expect(find.textContaining('Silent infections'), findsOneWidget);

    // Expand Section 6: Prevention of STI
    final preventionFinder = find.text('Prevention of STI');
    await tester.ensureVisible(preventionFinder);
    await tester.pumpAndSettle();
    await tester.tap(preventionFinder);
    await tester.pumpAndSettle();
    expect(
        find.textContaining('Consistent & correct condom use'), findsOneWidget);
    expect(find.textContaining('Vaccination'), findsOneWidget);

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
            .any((a) => a.articleId == 'module-02'),
        isTrue);
  });

  testWidgets('StiModuleDetailPage supports Amharic localization',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget(locale: const Locale('am')));
    await tester.pumpAndSettle();

    // Verify Amharic AppBar & Title
    expect(find.text('የትምህርት ክፍሎች'), findsWidgets);
    expect(find.text('በግብረ ሥጋ ግንኙነት የሚተላለፉ ኢንፌክሽኖች (STI)'), findsOneWidget);
    expect(find.text('ማስታወሻ'), findsOneWidget);
    expect(find.text('ትርጓሜ'), findsOneWidget);
    expect(find.text('የ STI ምልክቶች'), findsOneWidget);
    expect(find.text('የ STI ምርመራ'), findsOneWidget);
    expect(find.text('የ STI ውስብስብ የጤና ችግሮች'), findsOneWidget);
    expect(find.text('የ STI አያያዝ እና ሕክምና'), findsOneWidget);
    expect(find.text('የ STI መከላከያ መንገዶች'), findsOneWidget);
  });
}
