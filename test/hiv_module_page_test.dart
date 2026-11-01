import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/auth/auth_controller.dart';
import 'package:yegna_health_app/src/learning/hiv_module_page.dart';
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
      home: HivModuleDetailPage(
        progressController: progressController,
      ),
    );
  }

  testWidgets(
      'HivModuleDetailPage displays 3 accordion sections and toggles expansion',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Verify AppBar
    expect(find.text('Learning Modules'), findsOneWidget);

    // Verify 3 accordion card titles
    expect(find.text('Ways to prevent HIV'), findsOneWidget);
    expect(find.text('HIV testing'), findsOneWidget);
    expect(find.text('Treatment for HIV positive client'), findsOneWidget);

    // Section 1 is expanded initially: check PEP title and 10 steps title
    expect(
        find.textContaining('Post-exposure prophylaxis (PEP)'), findsOneWidget);
    expect(
        find.textContaining('How to use a condom in 10 steps'), findsOneWidget);

    // Section 2 is collapsed initially: ensure visible and expand it
    final hivTestingFinder = find.text('HIV testing');
    await tester.ensureVisible(hivTestingFinder);
    await tester.pumpAndSettle();
    await tester.tap(hivTestingFinder);
    await tester.pumpAndSettle();

    // Should now find PITC and VCT
    expect(
        find.textContaining('Provider Initiated Testing and Counseling (PITC)'),
        findsOneWidget);
    expect(find.textContaining('Voluntary Counseling and Testing (VCT)'),
        findsOneWidget);

    // Section 3 is collapsed initially: ensure visible and expand it
    final treatmentFinder = find.text('Treatment for HIV positive client');
    await tester.ensureVisible(treatmentFinder);
    await tester.pumpAndSettle();
    await tester.tap(treatmentFinder);
    await tester.pumpAndSettle();

    // Should now find ART details
    expect(
        find.textContaining('antiretroviral therapy, or ART'), findsOneWidget);

    // Tap Mark as Completed: ensure visible first
    final completeBtnFinder = find.text('Mark as Completed');
    await tester.ensureVisible(completeBtnFinder);
    await tester.pumpAndSettle();
    await tester.tap(completeBtnFinder);
    await tester.pumpAndSettle();

    // Button transitions to Completed status badge
    expect(find.text('Completed'), findsOneWidget);
  });

  testWidgets('HivModuleDetailPage supports Amharic localization',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget(locale: const Locale('am')));
    await tester.pumpAndSettle();

    // Check Amharic card titles
    expect(find.text('የትምህርት ክፍሎች'), findsOneWidget);
    expect(find.text('የኤችአይቪ መከላከያ መንገዶች'), findsOneWidget);
    expect(find.text('የኤችአይቪ ምርመራ'), findsOneWidget);
    expect(find.text('ኤችአይቪ በደማቸው ለሚገኝባቸው የሚሰጥ ህክምና'), findsOneWidget);

    // Check Amharic PEP text
    expect(find.textContaining('ድህረ-ተጋላጭነት መከላከያ መድሃኒት (PEP)'), findsOneWidget);
  });
}
