import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart' hide Path;

import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/discovery/facilities_page.dart';
import 'package:yegna_health_app/src/discovery/facility_detail_sheet.dart';
import 'package:yegna_health_app/src/discovery/facility_map_view.dart';
import 'package:yegna_health_app/src/discovery/facility_model.dart';
import 'package:yegna_health_app/src/discovery/facility_repository.dart';
import 'package:yegna_health_app/src/discovery/location_service.dart';

Widget _buildTestApp({
  required FacilityRepository repository,
  LocationService? locationService,
  LatLng? initialLocation,
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
        body: FacilitiesPage(
          facilityRepository: repository,
          locationService: locationService,
          initialLocation: initialLocation,
        ),
      ),
    );

void main() {
  group('FacilityRepository', () {
    test('LocalVerifiedFacilityRepository returns 10 verified UoG facilities',
        () async {
      const repo = LocalVerifiedFacilityRepository();
      final all = await repo.getFacilities();
      expect(all.length, 10);

      final clinicalOnly = await repo.getFacilities(
        category: FacilityFilterCategory.clinical,
      );
      expect(clinicalOnly.length, 5);

      final counselingOnly = await repo.getFacilities(
        category: FacilityFilterCategory.counseling,
      );
      expect(counselingOnly.length, 5);
      expect(counselingOnly.first.id, 'uog_maraki_guidance_center');

      final searchResult = await repo.getFacilities(query: 'Maraki');
      expect(searchResult.length, 2);
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
      expect(find.text(en.searchFacilities), findsOneWidget);

      // Check UoG facility card presence
      expect(find.text('UoG Maraki Student Health Center'), findsOneWidget);
      expect(find.text(en.viewDetailsAction), findsWidgets);
      final detailsBtn = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, en.viewDetailsAction).first,
      );
      expect(detailsBtn.style?.backgroundColor?.resolve({}),
          const Color(0xFF0284C7));
      expect(
          find.text(
              'UoG Comprehensive Specialized Hospital (GCMS) Adolescent Clinic'),
          findsOneWidget);

      // Filter by Counseling
      final counselingChip = find.text(en.categoryCounseling).first;
      await tester.ensureVisible(counselingChip);
      await tester.tap(counselingChip);
      await tester.pumpAndSettle();

      expect(find.text('UoG Maraki Student Health Center'), findsNothing);
      expect(
          find.text('UoG Maraki Guidance & Psychological Counseling Center'),
          findsOneWidget);

      // Switch to Map View
      await tester.tap(find.byIcon(Icons.map_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(FlutterMap), findsOneWidget);
      expect(find.byType(FacilityMapView), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.byIcon(Icons.remove_rounded), findsOneWidget);
      expect(find.byIcon(Icons.my_location_rounded), findsOneWidget);
      expect(find.text(en.directionsAction), findsOneWidget);

      // Tap Zoom In and Zoom Out
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.remove_rounded));
      await tester.pumpAndSettle();

      // Switch back to List View
      await tester.tap(find.byIcon(Icons.view_agenda_outlined));
      await tester.pumpAndSettle();

      // Open Facility Detail Sheet
      await tester.tap(find.text(en.viewDetailsAction).first);
      await tester.pumpAndSettle();

      expect(find.byType(FacilityDetailSheet), findsOneWidget);
      expect(find.text(en.openInMapsAction), findsOneWidget);

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

      expect(find.text('የጎንደር ዩኒቨርሲቲ ማራኪ የተማሪዎች ጤና ጣቢያ'), findsOneWidget);
    });

    testWidgets(
        'calculates live distances and sorts by proximity on Nearby filter',
        (tester) async {
      const repo = LocalVerifiedFacilityRepository();
      // Fixed user location right at UoG Maraki Student Health Center (12.6075, 37.4589)
      const marakiCoords = LatLng(12.6075, 37.4589);
      const fakeLocationService =
          FakeLocationService(fixedLocation: marakiCoords);

      await tester.pumpWidget(
        _buildTestApp(
          repository: repo,
          locationService: fakeLocationService,
        ),
      );
      await tester.pumpAndSettle();

      final en = await AppLocalizations.delegate.load(const Locale('en'));

      // Tap "Nearby" filter
      await tester.tap(find.text(en.nearbyFilter));
      await tester.pumpAndSettle();

      // UoG Maraki Student Health Center should be 0m away and at the top
      expect(find.text('0m'), findsOneWidget);
      expect(
        find.text(
            'Live GPS location acquired. Facilities sorted by proximity.'),
        findsOneWidget,
      );

      // Switch to Map view and verify pulsing user location marker
      await tester.tap(find.byIcon(Icons.map_outlined));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
          find.byKey(const ValueKey('user_location_marker')), findsOneWidget);
    });

    testWidgets('handles location denial gracefully without crashing',
        (tester) async {
      const repo = LocalVerifiedFacilityRepository();
      const fakeLocationService = FakeLocationService(fixedLocation: null);

      await tester.pumpWidget(
        _buildTestApp(
          repository: repo,
          locationService: fakeLocationService,
        ),
      );
      await tester.pumpAndSettle();

      final en = await AppLocalizations.delegate.load(const Locale('en'));

      // Tap "Nearby" filter
      await tester.tap(find.text(en.nearbyFilter));
      await tester.pumpAndSettle();

      // Expect informative snackbar
      expect(find.text(en.locationPermissionDenied), findsOneWidget);
      // List still displays verified facilities
      expect(find.text('UoG Maraki Student Health Center'), findsOneWidget);
    });
  });
}
