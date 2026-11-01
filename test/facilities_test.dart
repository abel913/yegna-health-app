import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/discovery/facilities_page.dart';
import 'package:yegna_health_app/src/discovery/facility_detail_sheet.dart';
import 'package:yegna_health_app/src/discovery/facility_model.dart';
import 'package:yegna_health_app/src/discovery/facility_repository.dart';

Widget _buildTestApp({
  required FacilityRepository repository,
  Locale locale = const Locale('en'),
}) =>
    MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: FacilitiesPage(facilityRepository: repository),
      ),
    );

void main() {
  group('FacilityRepository', () {
    test('LocalVerifiedFacilityRepository returns 5 verified facilities',
        () async {
      const repo = LocalVerifiedFacilityRepository();
      final all = await repo.getFacilities();
      expect(all.length, 5);

      final campusOnly = await repo.getFacilities(
        category: FacilityFilterCategory.campus,
      );
      expect(campusOnly.length, 2);
      expect(campusOnly.every((f) => f.campusNameEn != null), isTrue);

      final searchResult = await repo.getFacilities(query: 'Sidist Kilo');
      expect(searchResult.length, 1);
      expect(searchResult.first.id, 'aau_sidist_kilo_clinic');
    });

    test('UnconfiguredFacilityRepository returns empty list', () async {
      const repo = UnconfiguredFacilityRepository();
      final list = await repo.getFacilities();
      expect(list, isEmpty);
    });
  });

  group('FacilitiesPage Widget Tests', () {
    testWidgets('renders verified facility cards and allows search and filter',
        (tester) async {
      const repo = LocalVerifiedFacilityRepository();
      await tester.pumpWidget(_buildTestApp(repository: repo));
      await tester.pumpAndSettle();

      final en = await AppLocalizations.delegate.load(const Locale('en'));

      // Check header and search bar
      expect(find.text(en.facilitiesIntroduction), findsOneWidget);
      expect(find.text(en.searchFacilities), findsOneWidget);

      // Check facility card presence
      expect(find.text('Arada Youth-Friendly Health Center'), findsOneWidget);
      expect(
          find.text('AAU Student Health Clinic (Sidist Kilo)'), findsOneWidget);

      // Filter by Campus
      await tester.tap(find.text(en.campusFilter));
      await tester.pumpAndSettle();

      expect(find.text('Arada Youth-Friendly Health Center'), findsNothing);
      expect(
          find.text('AAU Student Health Clinic (Sidist Kilo)'), findsOneWidget);

      // Switch to Map View
      await tester.tap(find.byIcon(Icons.map_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(CustomPaint), findsWidgets);

      // Switch back to List View
      await tester.tap(find.byIcon(Icons.view_agenda_outlined));
      await tester.pumpAndSettle();

      // Open Facility Detail Sheet
      await tester.tap(find.text(en.viewDetailsAction).first);
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(FacilityDetailSheet),
          matching: find.text(en.callClinicAction),
        ),
        findsOneWidget,
      );
      await tester.scrollUntilVisible(
        find.text(en.confidentialityNoticeTitle),
        300,
        scrollable: find.byType(Scrollable).last,
      );
      expect(find.text(en.confidentialityNoticeTitle), findsOneWidget);
      expect(find.text(en.operatingHoursLabel), findsOneWidget);
    });

    testWidgets('unconfigured repository displays honest empty state',
        (tester) async {
      const repo = UnconfiguredFacilityRepository();
      await tester.pumpWidget(_buildTestApp(repository: repo));
      await tester.pumpAndSettle();

      final en = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(en.noVerifiedFacilitiesTitle), findsOneWidget);
      expect(find.text(en.facilitiesNotAvailableBody), findsOneWidget);
    });

    testWidgets('renders properly in Amharic locale', (tester) async {
      const repo = LocalVerifiedFacilityRepository();
      await tester.pumpWidget(
        _buildTestApp(repository: repo, locale: const Locale('am')),
      );
      await tester.pumpAndSettle();

      final am = await AppLocalizations.delegate.load(const Locale('am'));
      expect(find.text(am.facilitiesIntroduction), findsOneWidget);
      expect(find.text('የአራዳ ወጣቶች ተስማሚ ጤና ጣቢያ'), findsOneWidget);
    });
  });
}
