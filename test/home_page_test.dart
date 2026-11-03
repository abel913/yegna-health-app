import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/assessment/self_assessment_page.dart';
import 'package:yegna_health_app/src/auth/auth_controller.dart';
import 'package:yegna_health_app/src/auth/auth_models.dart';
import 'package:yegna_health_app/src/home/home_page.dart';

import 'support/fake_auth_repository.dart';
import 'support/fake_learning.dart';

Widget _buildTestHomePage({
  Locale locale = const Locale('en'),
  AuthController? authController,
  VoidCallback? onOpenLearning,
  VoidCallback? onOpenMentors,
  VoidCallback? onOpenFacilities,
  VoidCallback? onOpenAccount,
  ValueChanged<String>? onOpenArticle,
}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Scaffold(
      body: HomePage(
        educationRepository: FakeEducationRepository(),
        locale: locale,
        authController: authController,
        onOpenLearning: onOpenLearning ?? () {},
        onOpenMentors: onOpenMentors ?? () {},
        onOpenFacilities: onOpenFacilities ?? () {},
        onOpenAccount: onOpenAccount ?? () {},
        onOpenArticle: onOpenArticle ?? (_) {},
      ),
    ),
  );
}

void main() {
  testWidgets('HomePage renders dynamic greeting, daily insight, and helpline',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool learningOpened = false;
    bool accountOpened = false;
    bool facilitiesOpened = false;
    bool mentorsOpened = false;

    await tester.pumpWidget(_buildTestHomePage(
      onOpenLearning: () => learningOpened = true,
      onOpenAccount: () => accountOpened = true,
      onOpenFacilities: () => facilitiesOpened = true,
      onOpenMentors: () => mentorsOpened = true,
    ));
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    // 1. Dynamic Greeting Header & Account Button
    expect(find.text(l10n.guestGreetingSubtitle), findsOneWidget);
    expect(find.text(l10n.confidentialPill), findsOneWidget);
    expect(find.text(l10n.reviewedPill), findsOneWidget);
    expect(find.text(l10n.guestReadyPill), findsOneWidget);

    // Tap single account button
    await tester.tap(find.text(l10n.accountTitle).first);
    expect(accountOpened, isTrue);

    // 2. Emergency Helpline Bar removed from Home feed
    expect(find.text(l10n.emergencyHelplineTitle), findsNothing);

    // 3. 2x2 Services Grid Actions
    expect(find.text(l10n.exploreServicesHeading), findsOneWidget);
    expect(find.text(l10n.selfAssessmentTitle), findsOneWidget);
    expect(find.text(l10n.findFacilitiesTitle), findsOneWidget);
    expect(find.text(l10n.peerMentorTitle), findsOneWidget);

    await tester.tap(find.text(l10n.findFacilitiesTitle));
    expect(facilitiesOpened, isTrue);

    await tester.tap(find.text(l10n.peerMentorTitle));
    expect(mentorsOpened, isTrue);

    // 4. Featured Health Topics Carousel with Real Modules and Photos
    expect(find.text(l10n.featuredArticlesHeading), findsOneWidget);
    expect(find.text('MODULE 01'), findsOneWidget);
    expect(find.text(l10n.module01Title), findsOneWidget);

    // Tap module to verify modal sheet opens with real photo & description
    await tester.tap(find.text('MODULE 01'));
    await tester.pumpAndSettle();

    expect(find.text('Explore in Learn Tab'), findsOneWidget);
    await tester.tap(find.text('Explore in Learn Tab'));
    await tester.pumpAndSettle();
    expect(learningOpened, isTrue);

    // 5. Doctor's Daily Article Card (Repositioned to bottom of cards)
    expect(find.text(l10n.doctorDailyArticleBadge), findsOneWidget);
    expect(find.text(l10n.dailyTipMythFact),
        findsNothing); // "Myth vs Fact" removed!
    expect(find.text(l10n.dailyTipTitle), findsOneWidget);

    // Reset learningOpened flag to verify tapping doctor's article does NOT send to learn tab
    learningOpened = false;

    // Tap "Read Full Article" opens Doctor's Article modal without sending to learn tab
    await tester.tap(find.text(l10n.readFullArticleAction));
    await tester.pumpAndSettle();

    // Verify modal is displayed with clinical note, author, advice cards, and close button
    expect(find.text(l10n.doctorArticleSheetTitle), findsOneWidget);
    expect(find.text(l10n.doctorAdviceSkincareTitle), findsOneWidget);
    expect(find.text(l10n.closeArticleAction), findsOneWidget);
    expect(learningOpened, isFalse);

    // Close the sheet
    await tester.tap(find.text(l10n.closeArticleAction));
    await tester.pumpAndSettle();
  });

  testWidgets('HomePage displays authenticated username in greeting',
      (WidgetTester tester) async {
    final fakeRepo = FakeAuthRepository(
      initialSnapshot: const AuthSnapshot(
        user: AuthUser(
          id: 'user_1',
          email: 'selam@example.com',
          displayName: 'Selam',
          emailVerified: true,
        ),
      ),
    );
    final authController = AuthController(fakeRepo);

    await tester.pumpWidget(_buildTestHomePage(
      authController: authController,
    ));
    await tester.pumpAndSettle();

    expect(find.textContaining('Selam!'), findsOneWidget);

    authController.dispose();
  });

  testWidgets('HomePage translates cleanly to Amharic without error',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_buildTestHomePage(
      locale: const Locale('am'),
    ));
    await tester.pumpAndSettle();

    final amharic = await AppLocalizations.delegate.load(const Locale('am'));

    expect(find.text(amharic.guestGreetingSubtitle), findsOneWidget);
    expect(find.text(amharic.doctorDailyArticleBadge), findsOneWidget);
    expect(find.text(amharic.dailyTipMythFact), findsNothing);
    expect(find.text(amharic.emergencyHelplineTitle), findsNothing);
    expect(find.text(amharic.exploreServicesHeading), findsOneWidget);
    expect(find.text(amharic.selfAssessmentTitle), findsOneWidget);
  });

  testWidgets(
      'Explore Services 2x2 cards render without overflow on compact mobile screen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_buildTestHomePage());
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    // Scroll down to Explore Services
    await tester.scrollUntilVisible(
      find.text(l10n.exploreServicesHeading),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.exploreServicesHeading), findsOneWidget);
    expect(find.text(l10n.selfAssessmentTitle), findsOneWidget);
    expect(find.text(l10n.learnTab), findsOneWidget);
    expect(find.text(l10n.findFacilitiesTitle), findsOneWidget);
    expect(find.text(l10n.peerMentorTitle), findsOneWidget);

    // Verify no RenderFlex overflow error occurs
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping Self-Assessment card opens SelfAssessmentPage',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_buildTestHomePage());
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    await tester.tap(find.text(l10n.selfAssessmentTitle));
    await tester.pumpAndSettle();

    expect(find.byType(SelfAssessmentPage), findsOneWidget);
    expect(find.text('Question 1 of 12'), findsOneWidget);
  });
}
