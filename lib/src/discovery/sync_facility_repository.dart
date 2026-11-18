import 'dart:async';
import 'package:flutter/foundation.dart';

import '../sync/api_client.dart';
import '../sync/offline_sync_store.dart';
import 'facility_model.dart';
import 'facility_repository.dart';

/// Offline-first facility repository that serves immediately from persistent
/// cache or bundled seed data, while revalidating against the Node.js backend.
class SyncFacilityRepository extends ChangeNotifier
    implements FacilityRepository {
  SyncFacilityRepository({
    required OfflineSyncStore store,
    ApiClient? apiClient,
    FacilityRepository fallback = const LocalVerifiedFacilityRepository(),
  })  : _store = store,
        _apiClient = apiClient,
        _fallback = fallback;

  final OfflineSyncStore _store;
  final ApiClient? _apiClient;
  final FacilityRepository _fallback;

  @override
  Future<List<Facility>> getFacilities({
    String? query,
    FacilityFilterCategory? category,
  }) async {
    // 1. Retrieve from local persistent cache
    List<Facility>? cached = await _store.getCachedFacilities();

    // 2. If no cache yet and has never synced from backend, fall back to bundled verified clinics
    if (cached == null && !(await _store.hasSynced('facilities'))) {
      cached = await _fallback.getFacilities();
      if (cached.isNotEmpty) {
        // Seed offline cache for future instant offline reads
        unawaited(_store.saveFacilities(cached));
      }
    }
    cached ??= [];

    // 3. Stale-While-Revalidate: Trigger background fetch if client is available
    if (_apiClient != null) {
      unawaited(_revalidateInBackground());
    }

    // 4. Apply category and query filtering
    return _applyFilters(cached, query: query, category: category);
  }

  /// Forces an immediate network fetch from the backend and updates the cache.
  Future<List<Facility>> refreshFacilities({
    String? query,
    FacilityFilterCategory? category,
  }) async {
    if (_apiClient != null) {
      try {
        final remoteList = await _apiClient.fetchFacilities();
        if (remoteList != null) {
          final facilities =
              remoteList.map(OfflineSyncStore.facilityFromMap).toList();
          await _store.saveFacilities(facilities);
          notifyListeners();
          return _applyFilters(facilities, query: query, category: category);
        }
      } catch (_) {
        // Fall back to cache on network error
      }
    }
    return getFacilities(query: query, category: category);
  }

  List<Facility> _applyFilters(
    List<Facility> input, {
    String? query,
    FacilityFilterCategory? category,
  }) {
    var result = List<Facility>.from(input);

    if (category != null && category != FacilityFilterCategory.all) {
      switch (category) {
        case FacilityFilterCategory.nearby:
          result.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
          break;
        case FacilityFilterCategory.campus:
          result = result.where((f) => f.campusNameEn != null).toList();
          break;
        case FacilityFilterCategory.srhVct:
          result = result
              .where((f) =>
                  f.services.any((s) => s.contains('SRH') || s.contains('VCT')))
              .toList();
          break;
        case FacilityFilterCategory.mentalHealth:
          result = result
              .where((f) =>
                  f.services.any((s) => s.toLowerCase().contains('mental')) ||
                  f.category == FacilityCategory.counseling)
              .toList();
          break;
        case FacilityFilterCategory.clinical:
          result =
              result.where((f) => f.category == FacilityCategory.clinical).toList();
          break;
        case FacilityFilterCategory.counseling:
          result = result
              .where((f) => f.category == FacilityCategory.counseling)
              .toList();
          break;
        case FacilityFilterCategory.academic:
          result =
              result.where((f) => f.category == FacilityCategory.academic).toList();
          break;
        case FacilityFilterCategory.studentAffairs:
          result = result
              .where((f) => f.category == FacilityCategory.studentAffairs)
              .toList();
          break;
        case FacilityFilterCategory.sportsDining:
          result = result
              .where((f) => f.category == FacilityCategory.sportsDining)
              .toList();
          break;
        case FacilityFilterCategory.accessibility:
          result = result
              .where((f) =>
                  f.category == FacilityCategory.accessibility ||
                  f.isWheelchairAccessible)
              .toList();
          break;
        case FacilityFilterCategory.all:
          break;
      }
    }

    if (query != null && query.trim().isNotEmpty) {
      final clean = query.trim().toLowerCase();
      result = result.where((f) {
        final matchEn = f.nameEn.toLowerCase().contains(clean) ||
            f.subCityEn.toLowerCase().contains(clean) ||
            (f.buildingEn?.toLowerCase().contains(clean) ?? false) ||
            (f.landmarkEn.toLowerCase().contains(clean)) ||
            (f.focalPerson?.toLowerCase().contains(clean) ?? false) ||
            f.addressEn.toLowerCase().contains(clean) ||
            f.services.any((s) => s.toLowerCase().contains(clean));
        final matchAm = f.nameAm.contains(clean) ||
            f.subCityAm.contains(clean) ||
            (f.buildingAm?.contains(clean) ?? false) ||
            (f.landmarkAm.contains(clean)) ||
            (f.focalPerson?.contains(clean) ?? false) ||
            f.addressAm.contains(clean);
        return matchEn || matchAm;
      }).toList();
    }

    return result;
  }

  /// Silently fetches fresh facilities from backend and updates local cache.
  Future<void> _revalidateInBackground() async {
    try {
      final remoteList = await _apiClient?.fetchFacilities();
      if (remoteList != null) {
        final facilities =
            remoteList.map(OfflineSyncStore.facilityFromMap).toList();
        await _store.saveFacilities(facilities);
        notifyListeners();
      }
    } catch (_) {
      // Offline or network error: silently ignored in background
    }
  }
}
