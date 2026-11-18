import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../../location_service.dart';
import '../models/facilities_view_mode.dart';
import '../models/facility_enums.dart';
import '../repositories/facility_repository.dart';
import '../widgets/facilities_ambient_backdrop.dart';
import '../widgets/facilities_empty_views.dart';
import '../widgets/facilities_filter_bar.dart';
import '../widgets/facilities_search_bar.dart';
import '../widgets/facility_card.dart';
import '../widgets/facility_map_view.dart';
import 'facilities_page_flow_mixin.dart';

class FacilitiesPage extends StatefulWidget {
  const FacilitiesPage({
    this.facilityRepository,
    this.locationService,
    this.initialLocation,
    this.tileProvider,
    this.mapController,
    super.key,
  });

  final FacilityRepository? facilityRepository;
  final LocationService? locationService;
  final LatLng? initialLocation;
  final TileProvider? tileProvider;
  final MapController? mapController;

  @override
  State<FacilitiesPage> createState() => _FacilitiesPageState();
}

class _FacilitiesPageState extends State<FacilitiesPage>
    with FacilitiesPageFlowMixin {
  @override
  void initState() {
    super.initState();
    setupFlow();
  }

  @override
  void didUpdateWidget(FacilitiesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    didUpdateFlow(oldWidget);
  }

  @override
  void dispose() {
    disposeFlow();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    if (!isLoading &&
        facilities.isEmpty &&
        searchController.text.isEmpty &&
        selectedCategory == FacilityFilterCategory.all &&
        repository is UnconfiguredFacilityRepository) {
      return FacilitiesEmptyViews.buildEmptyPresentationState(
        l10n: l10n,
        isDark: isDark,
      );
    }

    return FacilitiesAmbientBackdrop(
      glass: glass,
      isDark: isDark,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final contentWidth = constraints.maxWidth > 720 ? 680.0 : 560.0;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FacilitiesSearchBar(
                          controller: searchController,
                          isDark: isDark,
                          glass: glass,
                          l10n: l10n,
                        ),
                        const SizedBox(height: 10),
                        FacilitiesFilterBar(
                          selectedCategory: selectedCategory,
                          viewMode: viewMode,
                          isDark: isDark,
                          l10n: l10n,
                          onCategorySelected: onCategorySelected,
                          onViewModeChanged: (mode) =>
                              setState(() => viewMode = mode),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: isDark
                                  ? const Color(0xFF38BDF8)
                                  : const Color(0xFF0284C7),
                            ),
                          )
                        : facilities.isEmpty
                            ? FacilitiesEmptyViews.buildNoResultsState(
                                l10n: l10n,
                                isDark: isDark,
                                onResetFilters: resetFilters,
                              )
                            : viewMode == FacilitiesViewMode.list
                                ? RefreshIndicator(
                                    onRefresh: handleRefresh,
                                    color: isDark
                                        ? const Color(0xFF38BDF8)
                                        : const Color(0xFF0284C7),
                                    child: ListView.builder(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 6, 20, 24),
                                      itemCount: facilities.length,
                                      itemBuilder: (context, index) =>
                                          FacilityCard(
                                        facility: facilities[index],
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 6, 20, 20),
                                    child: FacilityMapView(
                                      facilities: facilities,
                                      userLocation: userLocation,
                                      onLocateMeRequested: () =>
                                          fetchUserLocation(
                                              showFeedback: true),
                                      tileProvider: widget.tileProvider,
                                      mapController: widget.mapController,
                                    ),
                                  ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
