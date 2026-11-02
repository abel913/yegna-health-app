import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/assessment/self_assessment_page.dart';

void main() {
  Widget buildTestWidget({
    Locale locale = const Locale('en'),
    VoidCallback? onOpenMentors,
    VoidCallback? onOpenFacilities,
    VoidCallback? onOpenLearning,
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
      home: SelfAssessmentPage(
        onOpenMentors: onOpenMentors,
        onOpenFacilities: onOpenFacilities,
        onOpenLearning: onOpenLearning,
      ),
    );
  }

  group('SelfAssessmentPage Widget Tests', () {
    testWidgets(
        'renders Question 1 of 12 with segmented progress bar and options',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Self-Assessment'), findsOneWidget);
      expect(find.text('Question 1 of 12'), findsOneWidget);
      expect(find.text('Partners & Relationships'), findsOneWidget);
      expect(
        find.text(
            'Have you had more than one sexual partner in the last 12 months?'),
        findsOneWidget,
      );
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Why this matters'), findsOneWidget);
    });

    testWidgets('shows prompt when Next is tapped without answer selection',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap Next without selecting Yes or No
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('Please select Yes or No to proceed'), findsOneWidget);
      // Still on Question 1
      expect(find.text('Question 1 of 12'), findsOneWidget);
    });

    testWidgets(
        'advances to Question 2 when an answer is selected and Next is tapped',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap Yes
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      // Tap Next
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('Question 2 of 12'), findsOneWidget);
      expect(
        find.text(
          'Have you engaged in sexual activity in exchange for money, gifts, housing, or other benefits (transactional sex) in the last 12 months?',
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'navigates back to previous question using circular back button',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Advance to Question 2
      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Question 2 of 12'), findsOneWidget);

      // Tap back button in bottom controls
      final backButtons = find.byIcon(Icons.arrow_back_rounded);
      expect(backButtons, findsWidgets);
      await tester.tap(backButtons.last);
      await tester.pumpAndSettle();

      expect(find.text('Question 1 of 12'), findsOneWidget);
    });

    testWidgets(
        'completing all 12 questions with high-risk answers displays Result screen',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 1800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      bool mentorOpened = false;
      bool facilitiesOpened = false;

      await tester.pumpWidget(buildTestWidget(
        onOpenMentors: () => mentorOpened = true,
        onOpenFacilities: () => facilitiesOpened = true,
      ));
      await tester.pumpAndSettle();

      // Answer all 12 questions with 'Yes'
      for (int i = 1; i <= 12; i++) {
        await tester.tap(find.text('Yes'));
        await tester.pumpAndSettle();

        if (i < 12) {
          await tester.tap(find.text('Next'));
          await tester.pumpAndSettle();
        } else {
          expect(find.text('View Results'), findsOneWidget);
          await tester.tap(find.text('View Results'));
          await tester.pumpAndSettle();
        }
      }

      // Verify Result screen elements
      expect(find.text('Assessment Result'), findsOneWidget);
      expect(find.text('Higher Risk for HIV Infection'), findsOneWidget);
      expect(find.text('Recommended actions'), findsOneWidget);
      expect(
          find.text(
              'Get tested for HIV immediately at a youth-friendly clinic.'),
          findsOneWidget);
      expect(find.text('Use condoms consistently and correctly every time.'),
          findsOneWidget);
      expect(find.text('Key message'), findsOneWidget);
      expect(
        find.text(
          'Having a high-risk score does not mean that you are infected with HIV. However, if risky behaviors continue, there is a possibility of acquiring HIV infection. Therefore, make strong efforts to reduce your level of HIV exposure risk.',
        ),
        findsOneWidget,
      );

      // Verify bottom action cards
      expect(find.text('Talk to Mentor'), findsOneWidget);
      expect(find.text('Get Service'), findsOneWidget);

      // Tap Talk to Mentor
      await tester.scrollUntilVisible(find.text('Talk to Mentor'), 200);
      await tester.tap(find.text('Talk to Mentor'));
      await tester.pumpAndSettle();
      expect(mentorOpened, isTrue);

      // Tap Get Service
      await tester.tap(find.text('Get Service'));
      await tester.pumpAndSettle();
      expect(facilitiesOpened, isTrue);

      // Tap Retake
      await tester.scrollUntilVisible(find.text('Retake Assessment'), 200);
      expect(find.text('Retake Assessment'), findsOneWidget);
      await tester.tap(find.text('Retake Assessment'));
      await tester.pumpAndSettle();

      // Returns to Question 1
      expect(find.text('Question 1 of 12'), findsOneWidget);
    });

    testWidgets('all No answers results in Lower Risk Profile', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 1100));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Answer all 12 questions with 'No'
      for (int i = 1; i <= 12; i++) {
        await tester.tap(find.text('No'));
        await tester.pumpAndSettle();

        if (i < 12) {
          await tester.tap(find.text('Next'));
          await tester.pumpAndSettle();
        } else {
          await tester.tap(find.text('View Results'));
          await tester.pumpAndSettle();
        }
      }

      expect(find.text('Assessment Result'), findsOneWidget);
      expect(find.text('Lower Risk Profile'), findsOneWidget);
      expect(
          find.text(
              'Continue practicing safe behaviors and mutual open communication.'),
          findsOneWidget);
    });

    testWidgets('renders in Amharic locale correctly', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestWidget(locale: const Locale('am')));
      await tester.pumpAndSettle();

      expect(find.text('የራስ-ምርመራ'), findsOneWidget);
      expect(find.text('ጥያቄ 1 ከ 12'), findsOneWidget);
      expect(find.text('ግንኙነቶች እና አጋሮች'), findsOneWidget);
      expect(
        find.text('ባለፉት 12 ወራት ውስጥ ከአንድ በላይ የግብረ-ስጋ ግንኙነት አጋር ነበረዎት?'),
        findsOneWidget,
      );
      expect(find.text('አዎ'), findsOneWidget);
      expect(find.text('አይደለም'), findsOneWidget);
      expect(find.text('ቀጣይ'), findsOneWidget);
      expect(find.text('ይህ ለምን አስፈለገ?'), findsOneWidget);
    });
  });
}
