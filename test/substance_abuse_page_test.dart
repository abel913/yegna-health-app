import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/auth/auth_controller.dart';
import 'package:yegna_health_app/src/learning/learning_progress_controller.dart';
import 'package:yegna_health_app/src/learning/substance_abuse_page.dart';
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
      home: SubstanceAbuseDetailPage(
        progressController: progressController,
      ),
    );
  }

  testWidgets(
      'SubstanceAbuseDetailPage displays hero card, note, and 4 accordion sections',
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
    expect(find.text('Substance Abuse'), findsOneWidget);
    expect(find.textContaining('Substance abuse is the harmful use of drugs'),
        findsOneWidget);

    // Verify Note Section
    expect(find.text('Note'), findsOneWidget);
    expect(find.byIcon(Icons.lightbulb_outline_rounded), findsOneWidget);
    expect(find.textContaining('Substance abuse is preventable and treatable'),
        findsOneWidget);

    // Verify Learning Sections Header & Count Pill
    expect(find.text('Learning Sections'), findsOneWidget);
    expect(find.text('0 / 4 read'), findsOneWidget);

    // Verify All 4 Accordion Section Titles
    expect(find.text('Definition of substance abuse'), findsOneWidget);
    expect(find.text('Types of drugs/Substances'), findsOneWidget);
    expect(find.text('Effects of substance abuse'), findsOneWidget);
    expect(find.text('Signs of a Substance Use Problem'), findsOneWidget);

    // Expand Section 1: Definition of substance abuse
    await tester.tap(find.text('Definition of substance abuse'));
    await tester.pumpAndSettle();
    expect(find.textContaining('harmful or hazardous use of psychoactive'),
        findsOneWidget);
    expect(find.textContaining('Substance use disorder (SUD)'), findsOneWidget);

    // Expand Section 2: Types of drugs/Substances
    await tester.tap(find.text('Types of drugs/Substances'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Depressants:'), findsOneWidget);
    expect(find.textContaining('Stimulants:'), findsOneWidget);
    expect(find.textContaining('Opioids:'), findsOneWidget);
    expect(find.textContaining('Hallucinogens:'), findsOneWidget);

    // Expand Section 3: Effects of substance abuse
    final effectsFinder = find.text('Effects of substance abuse');
    await tester.ensureVisible(effectsFinder);
    await tester.pumpAndSettle();
    await tester.tap(effectsFinder);
    await tester.pumpAndSettle();
    expect(find.textContaining('Increased risk of disease'), findsOneWidget);
    expect(find.textContaining('Strained relationships with family'),
        findsOneWidget);

    // Expand Section 4: Signs of a Substance Use Problem
    final signsFinder = find.text('Signs of a Substance Use Problem');
    await tester.ensureVisible(signsFinder);
    await tester.pumpAndSettle();
    await tester.tap(signsFinder);
    await tester.pumpAndSettle();
    expect(find.textContaining('Compulsive cravings:'), findsOneWidget);
    expect(find.textContaining('952 or 8335'), findsOneWidget);

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
            .any((a) => a.articleId == 'module-08'),
        isTrue);
  });

  testWidgets('SubstanceAbuseDetailPage supports Amharic localization',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget(locale: const Locale('am')));
    await tester.pumpAndSettle();

    // Verify Amharic AppBar & Title
    expect(find.text('የትምህርት ክፍሎች'), findsWidgets);
    expect(find.text('የዕፅ ሱስ እና አላግባብ መጠቀም'), findsOneWidget);
    expect(find.text('ማስታወሻ'), findsOneWidget);
    expect(find.text('የዕፅ ሱስ ምንነት እና ትርጓሜ'), findsOneWidget);
    expect(find.text('የእፅ እና ንጥረ ነገሮች ዓይነቶች'), findsOneWidget);
    expect(find.text('የዕፅ ሱስ የሚያስከትላቸው ጉዳቶች'), findsOneWidget);
    expect(find.text('የዕፅ ሱስ ችግር መኖሩን የሚያሳዩ ምልክቶች'), findsOneWidget);
  });
}
