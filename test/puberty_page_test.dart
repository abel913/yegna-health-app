import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/auth/auth_controller.dart';
import 'package:yegna_health_app/src/learning/learning_progress_controller.dart';
import 'package:yegna_health_app/src/learning/puberty_page.dart';
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
      home: PubertyDetailPage(
        progressController: progressController,
      ),
    );
  }

  testWidgets(
      'PubertyDetailPage displays hero card, note, and 4 accordion sections',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Verify AppBar
    expect(find.text('Learning Modules'), findsOneWidget);

    // Verify Hero card & Note
    expect(find.text('Adolescent health & puberty'), findsOneWidget);
    expect(find.text('Note'), findsOneWidget);

    // Verify sections count (first section is opened by default)
    expect(find.text('1 / 4 read'), findsOneWidget);

    // Tap Section 2 to expand
    final sec2Finder = find.text('Physical Changes in Females & Males');
    expect(sec2Finder, findsOneWidget);
    await tester.tap(sec2Finder);
    await tester.pumpAndSettle();

    expect(find.text('2 / 4 read'), findsOneWidget);

    // Mark as completed
    final markCompletedBtn = find.text('Mark as Completed');
    expect(markCompletedBtn, findsOneWidget);
    await tester.ensureVisible(markCompletedBtn);
    await tester.pumpAndSettle();
    await tester.tap(markCompletedBtn);
    await tester.pumpAndSettle();

    expect(find.text('Completed'), findsOneWidget);
  });
}
