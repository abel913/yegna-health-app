import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/onboarding/onboarding_survey_dialog.dart';
import 'package:yegna_health_app/src/onboarding/onboarding_survey_models.dart';
import 'package:yegna_health_app/src/onboarding/onboarding_survey_repository.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestDialog({
    Locale locale = const Locale('en'),
    OnboardingSurveyRepository? repository,
    ValueChanged<OnboardingSurveyAnswers>? onCompleted,
    VoidCallback? onDismissed,
    VoidCallback? onOpenFacilities,
  }) {
    return MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('am')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: OnboardingSurveyDialog(
          repository: repository,
          onCompleted: onCompleted,
          onDismissed: onDismissed,
          onOpenFacilities: onOpenFacilities,
        ),
      ),
    );
  }

  group('OnboardingSurveyDialog Widget Tests', () {
    testWidgets('renders Question 1 in English when locale is en',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestDialog(locale: const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('Q.01'), findsOneWidget);
      expect(find.text('What is your age?'), findsOneWidget);
      expect(find.text('SELECT ONLY 1'), findsOneWidget);
      expect(find.text('18–20'), findsOneWidget);
      expect(find.text('21–24'), findsOneWidget);
      expect(find.text('25–29'), findsOneWidget);
      expect(find.text('30 and above'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('renders Question 1 in Amharic when locale is am',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestDialog(locale: const Locale('am')));
      await tester.pumpAndSettle();

      expect(find.text('ጥያቄ 01'), findsOneWidget);
      expect(find.text('ዕድሜዎ ስንት ነው?'), findsOneWidget);
      expect(find.text('አንዱን ብቻ ይምረጡ'), findsOneWidget);
      expect(find.text('18–20'), findsOneWidget);
      expect(find.text('30 እና ከዚያ በላይ'), findsOneWidget);
      expect(find.text('ቀጣይ'), findsOneWidget);
    });

    testWidgets('steps through Q1 to Q4 with checkmarks and submits',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      OnboardingSurveyAnswers? submittedAnswers;
      await tester.pumpWidget(buildTestDialog(
        locale: const Locale('en'),
        onCompleted: (ans) => submittedAnswers = ans,
      ));
      await tester.pumpAndSettle();

      // Q1: Select 21-24
      await tester.tap(find.text('21–24'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Q2: Year of Study
      expect(find.text('Q.02'), findsOneWidget);
      expect(find.text('What is your current year of study?'), findsOneWidget);
      await tester.tap(find.text('2nd Year'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Q3: Disability / Accessibility
      expect(find.text('Q.03'), findsOneWidget);
      expect(find.text('Do you have a disability or special accessibility need?'),
          findsOneWidget);
      await tester.tap(find.text('None / No disability'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Q4: University of Gondar SRH Awareness
      expect(find.text('Q.04'), findsOneWidget);
      expect(
        find.text(
            'Do you know where to access sexual & reproductive health services at the University of Gondar?'),
        findsOneWidget,
      );
      expect(find.text('Finish'), findsOneWidget);

      await tester.tap(find.text('Yes, I know'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();

      // Verify completion state
      expect(find.text('Thank You!'), findsOneWidget);
      expect(submittedAnswers, isNotNull);
      expect(submittedAnswers!.ageGroup, '21–24');
      expect(submittedAnswers!.yearOfStudy, '2nd Year');
      expect(submittedAnswers!.disabilityNeed, 'NONE');
      expect(submittedAnswers!.knowsGondarSrh, 'YES');
    });

    testWidgets('allows backing up between questions', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestDialog(locale: const Locale('en')));
      await tester.pumpAndSettle();

      // Select Q1 and advance
      await tester.tap(find.text('18–20'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Q.02'), findsOneWidget);

      // Tap Back
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Q.01'), findsOneWidget);
    });

    testWidgets('skips when close button is tapped', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      bool dismissed = false;
      await tester.pumpWidget(buildTestDialog(
        locale: const Locale('en'),
        onDismissed: () => dismissed = true,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(dismissed, isTrue);
    });
  });
}
