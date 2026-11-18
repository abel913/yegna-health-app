import '../models/facility.dart';
import '../models/facility_enums.dart';

abstract class FacilityRepository {
  Future<List<Facility>> getFacilities({
    String? query,
    FacilityFilterCategory? category,
  });
}

class UnconfiguredFacilityRepository implements FacilityRepository {
  const UnconfiguredFacilityRepository();

  @override
  Future<List<Facility>> getFacilities({
    String? query,
    FacilityFilterCategory? category,
  }) async =>
      const [];
}
