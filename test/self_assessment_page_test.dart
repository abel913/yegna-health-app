import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/assessment/campus_focal_persons_card.dart';
import 'package:yegna_health_app/src/assessment/module_assessment_dialog.dart';
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
        'renders University of Gondar 8-Section Suite and Focal Persons Directory',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Header Banner
      expect(find.text('SRHR Self-Assessment Hub'), findsOneWidget);
      expect(find.text('Official University of Gondar Tool'), findsOneWidget);
      expect(find.text('SRHR Self-Assessment Suite'), findsOneWidget);
      expect(find.text('Anonymous & Zero-PII Protected'), findsOneWidget);

      // Section counts
      expect(find.text('Assessment Sections (8 Total)'), findsOneWidget);
      expect(find.text('50 Questions'), findsOneWidget);

      // Specific sections
      expect(find.text('Personal and General Information'), findsOneWidget);
      expect(find.text('Sexual Behaviour and Health Risks'), findsOneWidget);
      expect(find.text('HIV and STIs Self-Assessment'), findsOneWidget);
      expect(find.text('Contraception and Family Planning'), findsOneWidget);

      // Campus Focal Persons Directory is not embedded on the main self-assessment page
      expect(find.byType(CampusFocalPersonsCard), findsNothing);
      expect(find.text('University of Gondar Campus Focal Persons'), findsNothing);
    });

    testWidgets('tapping a section card opens ModuleAssessmentDialog',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap Section 1 card
      await tester.tap(find.text('Personal and General Information'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(ModuleAssessmentDialog), findsOneWidget);
    });

    testWidgets('renders in Amharic locale correctly', (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestWidget(locale: const Locale('am')));
      await tester.pumpAndSettle();

      expect(find.text('የስነ-ተዋልዶ ጤና ምዘና ማዕከል'), findsOneWidget);
      expect(find.text('የጎንደር ዩኒቨርሲቲ ይፋዊ መጠይቅ'), findsOneWidget);
      expect(find.text('የጾታዊ እና ስነ-ተዋልዶ ጤና ራስን መመዘኛ'), findsOneWidget);
      expect(find.text('የምዘና ክፍሎች (8 ክፍሎች)'), findsOneWidget);
      expect(find.text('50 ጥያቄዎች'), findsOneWidget);
    });
  });
}
