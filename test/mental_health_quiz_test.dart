import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/auth/auth_controller.dart';
import 'package:yegna_health_app/src/learning/learning_progress_controller.dart';
import 'package:yegna_health_app/src/learning/mental_health_quiz_page.dart';
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
      home: MentalHealthQuizPage(
        progressController: progressController,
      ),
    );
  }

  testWidgets(
      'MentalHealthQuizPage navigates 4 questions, validates selection, and presents celebration results',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Verify AppBar & Progress
    expect(find.text('Mental Health & Wellbeing Quiz'), findsOneWidget);
    expect(find.text('Question 1 of 4'), findsOneWidget);

    // Q1 Question text
    expect(
        find.textContaining(
            'Mental health is just as important as physical health'),
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

    // Q2: Healthy Coping Strategies
    expect(find.text('Question 2 of 4'), findsOneWidget);
    expect(find.textContaining('effective way to manage everyday stress'),
        findsOneWidget);
    await tester.tap(find.textContaining('Regular physical exercise'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Q3: Emotions Spectrum Myth-Busting
    expect(find.text('Question 3 of 4'), findsOneWidget);
    expect(find.textContaining('feel happy and positive every single moment'),
        findsOneWidget);
    await tester.tap(find.text('False'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Q4: Seeking Support & Hotlines
    expect(find.text('Question 4 of 4'), findsOneWidget);
    expect(find.textContaining('best course of action'), findsOneWidget);
    await tester.tap(find.textContaining('Reach out to a trusted counselor'));
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
    expect(find.textContaining('fundamental component of total health'),
        findsOneWidget);
  });

  testWidgets('MentalHealthQuizPage supports Amharic localization',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget(locale: const Locale('am')));
    await tester.pumpAndSettle();

    expect(find.text('የአእምሮ ጤና እና ደህንነት ፈተና'), findsOneWidget);
    expect(find.text('ጥያቄ 1 ከ 4'), findsOneWidget);
    expect(find.text('እውነት'), findsOneWidget);
    expect(find.text('ሐሰት'), findsOneWidget);
  });
}
