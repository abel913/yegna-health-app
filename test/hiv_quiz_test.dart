import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/auth/auth_controller.dart';
import 'package:yegna_health_app/src/learning/hiv_quiz_page.dart';
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
      home: HivQuizPage(
        progressController: progressController,
      ),
    );
  }

  testWidgets(
      'HivQuizPage navigates 4 questions, validates selection, and presents celebration results',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Verify AppBar & Progress
    expect(find.text('HIV Module Quiz'), findsOneWidget);
    expect(find.text('Question 1 of 4'), findsOneWidget);

    // Q1 Question text
    expect(
        find.textContaining('HIV infects and destroys cells'), findsOneWidget);
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

    // Q2: Mode of Transmission
    expect(find.text('Question 2 of 4'), findsOneWidget);
    expect(find.textContaining('mode of HIV transmission'), findsOneWidget);
    await tester.tap(find.text('A & B'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Q3: Emergency PEP
    expect(find.text('Question 3 of 4'), findsOneWidget);
    expect(
        find.textContaining('Post-Exposure Prophylaxis (PEP)'), findsOneWidget);
    await tester.tap(find.text('Within 72 hours (3 days)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Q4: Treatment & U=U
    expect(find.text('Question 4 of 4'), findsOneWidget);
    expect(find.textContaining('Undetectable = Untransmittable / U=U'),
        findsOneWidget);
    expect(find.text('Finish Quiz'), findsOneWidget);
    await tester.tap(find.text('True'));
    await tester.pumpAndSettle();

    // Tap Finish Quiz
    await tester.tap(find.text('Finish Quiz'));
    await tester.pumpAndSettle();

    // Verify Results Screen
    expect(find.text('Great Job!'), findsOneWidget);
    expect(find.text('You scored 4 out of 4 (100%)'), findsOneWidget);
    expect(find.text('Review Answers'), findsOneWidget);
    expect(find.text('Retake Quiz'), findsOneWidget);

    // Tap Review Answers: should open review mode with insights
    await tester.tap(find.text('Review Answers'));
    await tester.pumpAndSettle();
    expect(find.text('Question 1 of 4'), findsOneWidget);
    expect(find.text('Key Clinical Insight'), findsOneWidget);
  });

  testWidgets('HivQuizPage supports Amharic localization', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget(locale: const Locale('am')));
    await tester.pumpAndSettle();

    // Verify Amharic AppBar & Question Progress
    expect(find.text('የኤችአይቪ ትምህርት ፈተና'), findsOneWidget);
    expect(find.text('ጥያቄ 1 ከ 4'), findsOneWidget);
    expect(find.text('እውነት'), findsOneWidget);
    expect(find.text('ሐሰት'), findsOneWidget);
    expect(find.text('ቀጣይ'), findsOneWidget);
  });
}
