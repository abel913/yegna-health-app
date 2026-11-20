import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yegna_health_app/src/assessment/models/assessment_result_data.dart';
import 'package:yegna_health_app/src/assessment/screens/assessment_result_screen.dart';
import 'package:yegna_health_app/src/assessment/services/assessment_result_evaluator.dart';

void main() {
  group('AssessmentResultEvaluator Tests', () {
    test('evaluates section 3 (HIV) with higher risk when multiple yes answers given', () {
      final result = AssessmentResultEvaluator.evaluate(
        sectionNumber: 3,
        sectionTitleEn: 'HIV and STIs Self-Assessment',
        sectionTitleAm: 'የኤችአይቪ እና አባለዘር በሽታዎች ምዘና',
        answers: {
          'q1': 'YES',
          'q2': 'YES',
          'q3': 'YES',
        },
      );

      expect(result.sectionNumber, 3);
      expect(result.tier, AssessmentRiskTier.higherRisk);
      expect(result.headlineEn, 'Higher Risk for HIV Infection');
      expect(result.actionsEn.length, 3);
      expect(result.actionsEn[0], contains('Get tested for HIV immediately'));
      expect(result.keyMessageEn, contains('Having a high-risk score does not mean that you are infected with HIV'));
    });

    test('evaluates section 3 (HIV) with moderate/routine testing when fewer yes answers given', () {
      final result = AssessmentResultEvaluator.evaluate(
        sectionNumber: 3,
        sectionTitleEn: 'HIV and STIs Self-Assessment',
        sectionTitleAm: 'የኤችአይቪ እና አባለዘር በሽታዎች ምዘና',
        answers: {
          'q1': 'NO',
          'q2': 'NO',
        },
      );

      expect(result.tier, AssessmentRiskTier.lowerRisk);
      expect(result.headlineEn, 'Routine HIV Testing Recommended');
    });

    test('evaluates other clinical sections (e.g. contraception) properly', () {
      final result = AssessmentResultEvaluator.evaluate(
        sectionNumber: 4,
        sectionTitleEn: 'Contraception and Family Planning',
        sectionTitleAm: 'የእርግዝና መከላከያ እና የቤተሰብ እቅድ',
        answers: {'q1': 'YES'},
      );

      expect(result.sectionNumber, 4);
      expect(result.headlineEn, contains('Contraception Guidance'));
      expect(result.actionsEn.length, 3);
    });
  });

  group('AssessmentResultScreen Widget Tests', () {
    testWidgets('renders header card, 3 recommended actions, key message, and action buttons', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      bool mentorTapped = false;
      bool serviceTapped = false;

      final data = AssessmentResultEvaluator.evaluate(
        sectionNumber: 3,
        sectionTitleEn: 'HIV and STIs Self-Assessment',
        sectionTitleAm: 'የኤችአይቪ እና አባለዘር በሽታዎች ምዘና',
        answers: {'q1': 'YES', 'q2': 'YES', 'q3': 'YES'},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: AssessmentResultScreen(
            resultData: data,
            onOpenMentors: () => mentorTapped = true,
            onOpenFacilities: () => serviceTapped = true,
          ),
        ),
      );

      // Verify Header
      expect(find.text('Assessment Result'), findsOneWidget);
      expect(find.text('Higher Risk for HIV Infection'), findsOneWidget);

      // Verify Actions Stepper
      expect(find.text('Recommended actions'), findsOneWidget);
      expect(find.text('Get tested for HIV immediately.'), findsOneWidget);
      expect(find.text('Use condoms consistently and correctly.'), findsOneWidget);
      expect(find.text('Actively participate in all peer learning sessions.'), findsOneWidget);

      // Verify Key Message
      expect(find.text('Key message'), findsOneWidget);
      expect(find.textContaining('Having a high-risk score does not mean'), findsOneWidget);

      // Verify Buttons
      expect(find.text('Talk to Mentor'), findsOneWidget);
      expect(find.text('Get Service'), findsOneWidget);

      // Test callbacks
      await tester.tap(find.text('Talk to Mentor'));
      await tester.pump();
      expect(mentorTapped, isTrue);

      await tester.tap(find.text('Get Service'));
      await tester.pump();
      expect(serviceTapped, isTrue);
    });
  });
}
