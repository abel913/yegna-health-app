import 'dart:async';

import '../sync/api_client.dart';
import '../sync/offline_sync_store.dart';
import 'facility_model.dart';
import 'facility_repository.dart';

/// Offline-first facility repository that serves immediately from persistent
/// cache or bundled seed data, while revalidating against the Node.js backend.
class SyncFacilityRepository implements FacilityRepository {
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

    // 2. If no cache yet, fall back to bundled verified clinics and seed cache
    if (cached == null || cached.isEmpty) {
      cached = await _fallback.getFacilities();
      if (cached.isNotEmpty) {
        // Seed offline cache for future instant offline reads
        unawaited(_store.saveFacilities(cached));
      }
    }

    // 3. Stale-While-Revalidate: Trigger background fetch if client is available
    if (_apiClient != null) {
      unawaited(_revalidateInBackground());
    }

    // 4. Apply category and query filtering
    var result = List<Facility>.from(cached);

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
                  f.services.any((s) => s.toLowerCase().contains('mental')))
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
            f.addressEn.toLowerCase().contains(clean) ||
            f.services.any((s) => s.toLowerCase().contains(clean));
        final matchAm = f.nameAm.contains(clean) ||
            f.subCityAm.contains(clean) ||
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
      if (remoteList != null && remoteList.isNotEmpty) {
        final facilities =
            remoteList.map(OfflineSyncStore.facilityFromMap).toList();
        await _store.saveFacilities(facilities);
      }
    } catch (_) {
      // Offline or network error: silently ignored in background
    }
  }
}
