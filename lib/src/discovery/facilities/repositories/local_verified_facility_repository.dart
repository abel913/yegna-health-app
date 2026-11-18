import '../models/facility.dart';
import '../models/facility_enums.dart';
import 'facility_repository.dart';
import 'uog_central_facilities_data.dart';
import 'uog_satellite_facilities_data.dart';

class LocalVerifiedFacilityRepository implements FacilityRepository {
  const LocalVerifiedFacilityRepository();

  static const List<Facility> _verifiedFacilities = [
    ...uogCentralFacilities,
    ...uogSatelliteFacilities,
  ];

  @override
  Future<List<Facility>> getFacilities({
    String? query,
    FacilityFilterCategory? category,
  }) async {
    var result = List<Facility>.from(_verifiedFacilities);

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
          result = result
              .where((f) => f.category == FacilityCategory.clinical)
              .toList();
          break;
        case FacilityFilterCategory.counseling:
          result = result
              .where((f) => f.category == FacilityCategory.counseling)
              .toList();
          break;
        case FacilityFilterCategory.academic:
          result = result
              .where((f) => f.category == FacilityCategory.academic)
              .toList();
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
            f.addressEn.toLowerCase().contains(clean) ||
            f.services.any((s) => s.toLowerCase().contains(clean));
        final matchAm = f.nameAm.contains(clean) ||
            f.subCityAm.contains(clean) ||
            (f.buildingAm?.contains(clean) ?? false) ||
            f.addressAm.contains(clean);
        return matchEn || matchAm;
      }).toList();
    }

    return result;
  }
}
