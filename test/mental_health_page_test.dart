import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/auth/auth_controller.dart';
import 'package:yegna_health_app/src/learning/learning_progress_controller.dart';
import 'package:yegna_health_app/src/learning/mental_health_page.dart';
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
      home: MentalHealthDetailPage(
        progressController: progressController,
      ),
    );
  }

  testWidgets(
      'MentalHealthDetailPage displays hero card, note, and 4 accordion sections',
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
    expect(find.text('Mental health & wellbeing'), findsOneWidget);
    expect(
        find.textContaining(
            'Mental health is an essential part of overall health'),
        findsOneWidget);

    // Verify Note Section
    expect(find.text('Note'), findsOneWidget);
    expect(find.byIcon(Icons.lightbulb_outline_rounded), findsOneWidget);
    expect(find.textContaining('Mental health exists on a continuum'),
        findsOneWidget);

    // Verify Learning Sections Header & Count Pill
    expect(find.text('Learning Sections'), findsOneWidget);
    expect(find.text('0 / 4 read'), findsOneWidget);

    // Verify All 4 Accordion Section Titles
    expect(
        find.text('Understanding Mental Health & Wellbeing'), findsOneWidget);
    expect(find.text('Common Challenges in Youth'), findsOneWidget);
    expect(find.text('Positive Coping & Self-Care Strategies'), findsOneWidget);
    expect(find.text('Recognizing Warning Signs & Seeking Support'),
        findsOneWidget);

    // Expand Section 1: Understanding Mental Health & Wellbeing
    await tester.tap(find.text('Understanding Mental Health & Wellbeing'));
    await tester.pumpAndSettle();
    expect(
        find.textContaining(
            'Mental health includes our emotional, psychological'),
        findsOneWidget);
    expect(
        find.textContaining(
            'Mental health is just as important as physical health'),
        findsOneWidget);

    // Expand Section 2: Common Challenges in Youth
    await tester.tap(find.text('Common Challenges in Youth'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Academic stress and burnout'), findsOneWidget);
    expect(find.textContaining('General and social anxiety'), findsOneWidget);

    // Expand Section 3: Positive Coping & Self-Care Strategies
    final section3Finder = find.text('Positive Coping & Self-Care Strategies');
    await tester.ensureVisible(section3Finder);
    await tester.pumpAndSettle();
    await tester.tap(section3Finder);
    await tester.pumpAndSettle();
    expect(find.textContaining('Daily physical movement'), findsOneWidget);
    expect(find.textContaining('Restful sleep hygiene'), findsOneWidget);

    // Expand Section 4: Recognizing Warning Signs & Seeking Support
    final section4Finder =
        find.text('Recognizing Warning Signs & Seeking Support');
    await tester.ensureVisible(section4Finder);
    await tester.pumpAndSettle();
    await tester.tap(section4Finder);
    await tester.pumpAndSettle();
    expect(find.textContaining('Prolonged withdrawal'), findsOneWidget);
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
            .any((a) => a.articleId == 'module-06'),
        isTrue);
  });

  testWidgets('MentalHealthDetailPage supports Amharic localization',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget(locale: const Locale('am')));
    await tester.pumpAndSettle();

    // Verify Amharic AppBar & Title
    expect(find.text('የትምህርት ክፍሎች'), findsWidgets);
    expect(find.text('የአእምሮ ጤና እና ደህንነት'), findsOneWidget);
    expect(find.text('ማስታወሻ'), findsOneWidget);
    expect(find.text('ስለ አእምሮ ጤና እና ደህንነት መረዳት'), findsOneWidget);
    expect(find.text('በወጣቶች ላይ የሚከሰቱ የተለመዱ የአእምሮ ጤና ፈተናዎች'), findsOneWidget);
    expect(find.text('ውጥረትን የመቋቋሚያ እና ራስን የመንከባከቢያ ዘዴዎች'), findsOneWidget);
    expect(find.text('የአእምሮ ጭንቀት ምልክቶችን መገንዘብ እና ድጋፍ መፈለግ'), findsOneWidget);
  });
}
