import '../../sync_facility_repository.dart';
import '../models/facility.dart';
import '../models/facility_enums.dart';
import 'facility_repository.dart';
import 'local_verified_facility_repository.dart';

class DynamicFacilityRepository implements FacilityRepository {
  const DynamicFacilityRepository({
    this.customFacilitiesProvider,
    this.fallback = const LocalVerifiedFacilityRepository(),
  });

  final Future<List<Facility>> Function()? customFacilitiesProvider;
  final FacilityRepository fallback;

  @override
  Future<List<Facility>> getFacilities({
    String? query,
    FacilityFilterCategory? category,
  }) async {
    final base = await fallback.getFacilities(query: query, category: category);
    if (fallback is UnconfiguredFacilityRepository) {
      return base;
    }
    if (customFacilitiesProvider == null) return base;
    try {
      final custom = await customFacilitiesProvider!();
      final ids = base.map((f) => f.id).toSet();
      final extras = custom.where((f) => !ids.contains(f.id)).toList();
      return [...base, ...extras];
    } catch (_) {
      return base;
    }
  }

  Future<List<Facility>> refreshFacilities({
    String? query,
    FacilityFilterCategory? category,
  }) async {
    final fb = fallback;
    List<Facility> base;
    if (fb is SyncFacilityRepository) {
      base = await fb.refreshFacilities(query: query, category: category);
    } else {
      base = await fb.getFacilities(query: query, category: category);
    }
    if (customFacilitiesProvider == null) return base;
    try {
      final custom = await customFacilitiesProvider!();
      final ids = base.map((f) => f.id).toSet();
      final extras = custom.where((f) => !ids.contains(f.id)).toList();
      return [...base, ...extras];
    } catch (_) {
      return base;
    }
  }
}
