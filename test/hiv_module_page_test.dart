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
      'HivModuleDetailPage displays hero card, note, and 5 accordion sections',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Verify AppBar
    expect(find.text('Learning Modules'), findsOneWidget);

    // Verify Hero Card & Note
    expect(find.text('Human immune virus (HIV)/AIDS'), findsOneWidget);
    expect(find.text('Note'), findsOneWidget);
    expect(find.text('Learning Sections'), findsOneWidget);
    expect(find.text('5 / 5 read'), findsOneWidget);

    // Verify 5 accordion card titles
    expect(find.text('Defination'), findsOneWidget);
    expect(find.text('Mode of transmission'), findsOneWidget);
    expect(find.text('HIV-Prevention'), findsOneWidget);
    expect(find.text('HIV testing'), findsOneWidget);
    expect(find.text('Treatment for HIV positive client'), findsOneWidget);

    // Tap Defination: should expand and show definition text
    final defFinder = find.text('Defination');
    await tester.ensureVisible(defFinder);
    await tester.tap(defFinder);
    await tester.pumpAndSettle();
    expect(find.textContaining('Human Immunodeficiency Virus'), findsOneWidget);

    // Tap HIV-Prevention: should expand and show PEP
    final prevFinder = find.text('HIV-Prevention');
    await tester.ensureVisible(prevFinder);
    await tester.tap(prevFinder);
    await tester.pumpAndSettle();
    expect(
        find.textContaining('Post-exposure prophylaxis (PEP)'), findsOneWidget);
    expect(
        find.textContaining('How to use a condom in 10 steps'), findsOneWidget);

    // Tap HIV testing: should expand and show PITC & VCT
    final hivTestingFinder = find.text('HIV testing');
    await tester.ensureVisible(hivTestingFinder);
    await tester.tap(hivTestingFinder);
    await tester.pumpAndSettle();
    expect(
        find.textContaining('Provider Initiated Testing and Counseling (PITC)',
            findRichText: true),
        findsOneWidget);

    // Tap Mark as Completed: ensure visible first
    final completeBtnFinder = find.text('Mark as Completed');
    await tester.ensureVisible(completeBtnFinder);
    await tester.tap(completeBtnFinder);
    await tester.pumpAndSettle();

    // Button transitions to Completed status badge
    expect(find.text('Completed'), findsOneWidget);
  });

  testWidgets('HivModuleDetailPage supports Amharic localization',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget(locale: const Locale('am')));
    await tester.pumpAndSettle();

    // Check Amharic card titles
    expect(find.text('የትምህርት ክፍሎች'), findsAtLeastNWidgets(1));
    expect(find.text('ማስታወሻ'), findsOneWidget);
    expect(find.text('ትርጓሜ'), findsOneWidget);
    expect(find.text('የመተላለፊያ መንገዶች'), findsOneWidget);
    expect(find.text('የኤችአይቪ መከላከያ መንገዶች'), findsOneWidget);
    expect(find.text('የኤችአይቪ ምርመራ'), findsOneWidget);
    expect(find.text('ኤችአይቪ በደማቸው ለሚገኝባቸው የሚሰጥ ህክምና'), findsOneWidget);
  });
}
