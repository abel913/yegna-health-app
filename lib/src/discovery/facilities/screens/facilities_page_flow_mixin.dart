import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' hide Path;

import '../../location_service.dart';
import '../../sync_facility_repository.dart';
import '../models/facilities_view_mode.dart';
import '../models/facility.dart';
import '../models/facility_enums.dart';
import '../repositories/dynamic_facility_repository.dart';
import '../repositories/facility_repository.dart';
import '../repositories/local_verified_facility_repository.dart';
import 'facilities_location_helper.dart';
import 'facilities_page.dart';

mixin FacilitiesPageFlowMixin on State<FacilitiesPage> {
  late FacilityRepository repository;
  late LocationService locationService;
  final TextEditingController searchController = TextEditingController();

  FacilitiesViewMode viewMode = FacilitiesViewMode.list;
  FacilityFilterCategory selectedCategory = FacilityFilterCategory.all;
  List<Facility> facilities = [];
  bool isLoading = true;
  bool isRefreshing = false;
  LatLng? userLocation;
  bool isLocating = false;

  void setupFlow() {
    repository =
        widget.facilityRepository ?? const LocalVerifiedFacilityRepository();
    locationService =
        widget.locationService ?? const GeolocatorLocationService();
    userLocation = widget.initialLocation;
    searchController.addListener(_onSearchChanged);
    _setupRepositoryListener();
    loadFacilities();
  }

  void _setupRepositoryListener() {
    final repo = repository;
    if (repo is Listenable) {
      (repo as Listenable).addListener(_onRepositoryUpdated);
    } else if (repo is DynamicFacilityRepository) {
      final fallback = repo.fallback;
      if (fallback is Listenable) {
        (fallback as Listenable).addListener(_onRepositoryUpdated);
      }
    }
  }

  void _removeRepositoryListener() {
    final repo = repository;
    if (repo is Listenable) {
      (repo as Listenable).removeListener(_onRepositoryUpdated);
    } else if (repo is DynamicFacilityRepository) {
      final fallback = repo.fallback;
      if (fallback is Listenable) {
        (fallback as Listenable).removeListener(_onRepositoryUpdated);
      }
    }
  }

  void _onRepositoryUpdated() {
    if (mounted) loadFacilities();
  }

  void didUpdateFlow(FacilitiesPage oldWidget) {
    if (widget.facilityRepository != oldWidget.facilityRepository ||
        widget.locationService != oldWidget.locationService ||
        widget.initialLocation != oldWidget.initialLocation) {
      _removeRepositoryListener();
      repository =
          widget.facilityRepository ?? const LocalVerifiedFacilityRepository();
      locationService =
          widget.locationService ?? const GeolocatorLocationService();
      if (widget.initialLocation != null) userLocation = widget.initialLocation;
      _setupRepositoryListener();
      loadFacilities();
    }
  }

  void disposeFlow() {
    _removeRepositoryListener();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
  }

  void _onSearchChanged() => loadFacilities();

  Future<void> handleRefresh() async {
    if (isRefreshing) return;
    setState(() => isRefreshing = true);
    try {
      final repo = repository;
      if (repo is SyncFacilityRepository) {
        await repo.refreshFacilities(
          query: searchController.text,
          category: selectedCategory,
        );
      } else if (repo is DynamicFacilityRepository) {
        await repo.refreshFacilities(
          query: searchController.text,
          category: selectedCategory,
        );
      }
      await loadFacilities();
    } finally {
      if (mounted) setState(() => isRefreshing = false);
    }
  }

  Future<void> loadFacilities() async {
    var results = await repository.getFacilities(
      query: searchController.text,
      category: selectedCategory,
    );

    if (userLocation != null) {
      results = FacilitiesLocationHelper.applyDistances(
        facilities: results,
        userLocation: userLocation!,
        locationService: locationService,
        selectedCategory: selectedCategory,
      );
    }

    if (mounted) {
      setState(() {
        facilities = results;
        isLoading = false;
      });
    }
  }

  Future<void> onCategorySelected(FacilityFilterCategory category) async {
    setState(() => selectedCategory = category);
    if (category == FacilityFilterCategory.nearby && userLocation == null) {
      await fetchUserLocation(showFeedback: true);
    } else {
      loadFacilities();
    }
  }

  Future<LatLng?> fetchUserLocation({bool showFeedback = false}) async {
    if (isLocating) return userLocation;
    setState(() => isLocating = true);

    try {
      final loc = await locationService.getCurrentLocation();
      if (!mounted) return loc;

      setState(() {
        userLocation = loc;
        isLocating = false;
      });

      await loadFacilities();
      if (showFeedback && mounted) {
        FacilitiesLocationHelper.showLocationFeedback(context, loc != null);
      }
      return loc;
    } catch (_) {
      if (mounted) setState(() => isLocating = false);
      return null;
    }
  }

  void resetFilters() {
    searchController.clear();
    setState(() => selectedCategory = FacilityFilterCategory.all);
    loadFacilities();
  }
}
