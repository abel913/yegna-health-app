import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/main.dart';
import 'package:yegna_health_app/src/auth/auth_controller.dart';
import 'package:yegna_health_app/src/locale_controller.dart';
import 'package:yegna_health_app/src/learning/assessment_repository.dart';
import 'package:yegna_health_app/src/learning/learning_models.dart';
import 'package:yegna_health_app/src/learning/learning_progress_controller.dart';
import 'package:yegna_health_app/src/learning/learn_pages.dart';

import 'support/fake_auth_repository.dart';
import 'support/fake_learning.dart';

void main() {
  Future<_Harness> createHarness({bool signedIn = false}) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final localeController = LocaleController(preferences);
    await localeController.load();
    final authRepository = FakeAuthRepository();
    final authController = AuthController(authRepository);
    if (signedIn) {
      await authController.signIn(
        email: 'learner@example.org',
        password: 'test-password',
      );
    }
    final education = FakeEducationRepository();
    final assessments = FakeAssessmentRepository();
    final progressStore = FakeLearningProgressStore();
    return _Harness(
      localeController: localeController,
      authController: authController,
      education: education,
      assessments: assessments,
      progressStore: progressStore,
    );
  }

  Future<void> pumpHarness(WidgetTester tester, _Harness harness) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(YegnaHealthApp(
      localeController: harness.localeController,
      authController: harness.authController,
      educationRepository: harness.education,
      assessmentRepository: harness.assessments,
      progressStore: harness.progressStore,
    ));
    await tester.pumpAndSettle();
  }

  testWidgets(
      'Learn navigation opens articles and switching locale keeps article',
      (tester) async {
    final harness = await createHarness();
    await pumpHarness(tester, harness);
    var l10n = AppLocalizations.of(tester.element(find.byType(NavigationBar)));

    await tester.tap(find.text(l10n.learnTab).last);
    await tester.pumpAndSettle();
    expect(find.text(l10n.learningHeading), findsOneWidget);
    expect(find.text(l10n.moreButton).first, findsOneWidget);

    await tester.tap(find.text(l10n.moreButton).first);
    await tester.pumpAndSettle();
    expect(find.text('Test article body.'), findsOneWidget);

    await tester.tap(find.byTooltip(l10n.selectLanguage));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.amharicLanguage).last);
    await tester.pumpAndSettle();
    l10n = AppLocalizations.of(tester.element(find.byType(ArticlePage)));
    expect(find.text('የሙከራ ጽሑፍ'), findsOneWidget);
    expect(find.text('የሙከራ ጽሑፍ አካል።'), findsOneWidget);

    await tester.tap(find.text(l10n.markArticleComplete));
    await tester.pumpAndSettle();
    expect(find.text(l10n.articleMarkedComplete), findsOneWidget);
    expect((await harness.progressStore.load(null)).articles, hasLength(1));
    await tester.pumpWidget(const SizedBox.shrink());
    harness.authController.dispose();
    harness.localeController.dispose();
  });

  testWidgets('assessment interaction requires answers and shows server result',
      (tester) async {
    final harness = await createHarness();
    await pumpHarness(tester, harness);
    final l10n =
        AppLocalizations.of(tester.element(find.byType(NavigationBar)));
    await tester.tap(find.text(l10n.learnTab).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.takeQuizButton).first);
    await tester.pumpAndSettle();

    expect(find.text('Test question one?'), findsOneWidget);
    await tester.tap(find.text(l10n.nextQuestion));
    await tester.pumpAndSettle();
    expect(find.text(l10n.selectAnAnswer), findsOneWidget);

    await tester.tap(find.text('Choice one'));
    await tester.tap(find.text(l10n.nextQuestion));
    await tester.pumpAndSettle();
    expect(find.text('Test question two?'), findsOneWidget);
    await tester.tap(find.text('Choice four'));
    await tester.tap(find.text(l10n.submitAnswers));
    await tester.pumpAndSettle();

    expect(find.text(l10n.assessmentResult(1, 2, 50)), findsOneWidget);
    expect(find.text('${l10n.correctAnswer}: Choice three'), findsOneWidget);
    expect(find.text('Test explanation.'), findsNWidgets(2));
    expect(harness.assessments.submissionCount, 1);

    await tester.tap(find.text(l10n.retakeAssessment));
    await tester.pumpAndSettle();
    expect(find.text('Test question one?'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    harness.authController.dispose();
    harness.localeController.dispose();
  });

  testWidgets('guest progress remains local and cannot enable cloud sync',
      (tester) async {
    final harness = await createHarness();
    final progressController = LearningProgressController(
      repository: harness.progressStore,
      authController: harness.authController,
    );
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: LearningProgressScreen(
        controller: progressController,
        assessmentRepository: harness.assessments,
      ),
    ));
    await tester.pumpAndSettle();
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    expect(find.text(l10n.progressSyncSignInRequired), findsOneWidget);
    expect(harness.progressStore.lastSyncChoice, isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    progressController.dispose();
    harness.authController.dispose();
    harness.localeController.dispose();
  });

  testWidgets('signed-in learner can enable sync and clear cloud history',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final harness = await createHarness(signedIn: true);
    await pumpHarness(tester, harness);
    final l10n =
        AppLocalizations.of(tester.element(find.byType(NavigationBar)));
    await tester.tap(find.text(l10n.accountTab).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.progressHeading));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();
    expect(harness.progressStore.lastSyncChoice, isTrue);
    expect(find.text(l10n.progressSyncEnabled), findsOneWidget);

    final clearHistoryButton =
        find.widgetWithText(OutlinedButton, l10n.clearSyncedHistory);
    await tester.ensureVisible(clearHistoryButton);
    await tester.tap(clearHistoryButton);
    await tester.pumpAndSettle();
    expect(find.text(l10n.clearSyncedHistoryTitle), findsOneWidget);
    await tester.tap(find.text(l10n.clearHistoryAction));
    await tester.pumpAndSettle();
    expect(harness.progressStore.clearCalls, 1);
    expect(find.text(l10n.syncedHistoryCleared), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    harness.authController.dispose();
    harness.localeController.dispose();
  });

  testWidgets('interrupted guest submission can be retried after restart',
      (tester) async {
    final harness = await createHarness();
    const requestId = 'saved-request';
    const versionId = 'saved-version';
    harness.assessments.pending.add(const PendingAssessmentSubmission(
      requestId: requestId,
      versionId: versionId,
      locale: 'en',
      answers: [],
      syncProgress: false,
    ));
    expect(await harness.assessments.pendingSubmissions(), hasLength(1));
    harness.assessments.retryResult = const AssessmentSubmission.completed(
      AssessmentResult(
        score: 1,
        totalQuestions: 2,
        details: [],
        synchronized: false,
      ),
      requestId: requestId,
    );
    final progressController = LearningProgressController(
      repository: harness.progressStore,
      authController: harness.authController,
    );
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: LearningProgressScreen(
        controller: progressController,
        assessmentRepository: harness.assessments,
      ),
    ));
    await tester.pumpAndSettle();
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.scrollUntilVisible(
      find.text(l10n.pendingScore),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text(l10n.pendingScore), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(l10n.retryAction),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text(l10n.retryAction));
    await tester.pumpAndSettle();
    expect(find.text(l10n.pendingScore), findsNothing);
    final attempts = (await harness.progressStore.load(null)).attempts;
    expect(attempts, hasLength(1));
    expect(attempts.single.requestId, requestId);
    expect(attempts.single.versionId, versionId);

    await tester.pumpWidget(const SizedBox.shrink());
    progressController.dispose();
    harness.authController.dispose();
    harness.localeController.dispose();
  });
}

class _Harness {
  const _Harness({
    required this.localeController,
    required this.authController,
    required this.education,
    required this.assessments,
    required this.progressStore,
  });

  final LocaleController localeController;
  final AuthController authController;
  final FakeEducationRepository education;
  final FakeAssessmentRepository assessments;
  final FakeLearningProgressStore progressStore;
}
