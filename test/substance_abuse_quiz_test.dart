import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/auth/auth_controller.dart';
import 'package:yegna_health_app/src/learning/learning_progress_controller.dart';
import 'package:yegna_health_app/src/learning/substance_abuse_quiz_page.dart';
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
      home: SubstanceAbuseQuizPage(
        progressController: progressController,
      ),
    );
  }

  testWidgets(
      'SubstanceAbuseQuizPage navigates 4 questions, validates selection, and presents celebration results',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Verify AppBar & Progress
    expect(find.text('Substance Abuse Quiz'), findsOneWidget);
    expect(find.text('Question 1 of 4'), findsOneWidget);

    // Q1 Question text
    expect(
        find.textContaining('treatable medical condition affecting the brain'),
        findsOneWidget);
    expect(find.text('True'), findsOneWidget);
    expect(find.text('False'), findsOneWidget);

    // Try tapping Next without selecting: should show hint snackbar
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Please select an answer to continue'), findsOneWidget);

    // Dismiss SnackBar
    ScaffoldMessenger.of(tester.element(find.byType(Scaffold)))
        .hideCurrentSnackBar();
    await tester.pumpAndSettle();

    // Select True for Q1 and proceed
    await tester.tap(find.text('True'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Q2: Substance Categories
    expect(find.text('Question 2 of 4'), findsOneWidget);
    expect(find.textContaining('slows down central nervous system function'),
        findsOneWidget);
    await tester.tap(find.text('Depressants'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Q3: Tolerance & Dependency
    expect(find.text('Question 3 of 4'), findsOneWidget);
    expect(find.textContaining('developing "tolerance" mean'), findsOneWidget);
    await tester.tap(find.textContaining('needs increasingly larger amounts'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Q4: Support Pathways & Hotlines
    expect(find.text('Question 4 of 4'), findsOneWidget);
    expect(
        find.textContaining('free national health hotlines'), findsOneWidget);
    await tester.tap(find.text('True'));
    await tester.pumpAndSettle();

    // Finish Quiz
    expect(find.text('Finish Quiz'), findsOneWidget);
    await tester.tap(find.text('Finish Quiz'));
    await tester.pumpAndSettle();

    // Verify Results Screen: Great Job! You scored 4 out of 4 (100%)
    expect(find.text('Great Job!'), findsOneWidget);
    expect(find.text('You scored 4 out of 4 (100%)'), findsOneWidget);
    expect(find.text('Review Answers'), findsOneWidget);
    expect(find.text('Return to Lesson'), findsOneWidget);

    // Enter Review Mode
    await tester.tap(find.text('Review Answers'));
    await tester.pumpAndSettle();

    // Verify Review Mode shows Key Clinical Insight
    expect(find.text('Key Clinical Insight'), findsOneWidget);
    expect(
        find.textContaining('alter brain chemistry and neural reward pathways'),
        findsOneWidget);
  });

  testWidgets('SubstanceAbuseQuizPage supports Amharic localization',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget(locale: const Locale('am')));
    await tester.pumpAndSettle();

    expect(find.text('የአደንዛዥ ዕፅ ሱስ ፈተና'), findsOneWidget);
    expect(find.text('ጥያቄ 1 ከ 4'), findsOneWidget);
    expect(find.text('እውነት'), findsOneWidget);
    expect(find.text('ሐሰት'), findsOneWidget);
  });
}
