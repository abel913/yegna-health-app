import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' hide Path;

import '../../../../l10n/app_localizations.dart';
import '../../location_service.dart';
import '../models/facility.dart';
import '../models/facility_enums.dart';

class FacilitiesLocationHelper {
  const FacilitiesLocationHelper._();

  static List<Facility> applyDistances({
    required List<Facility> facilities,
    required LatLng userLocation,
    required LocationService locationService,
    required FacilityFilterCategory selectedCategory,
  }) {
    var results = facilities.map((f) {
      final dist = locationService.calculateDistanceKm(
        userLocation,
        LatLng(f.latitude, f.longitude),
      );
      final rounded = double.parse(dist.toStringAsFixed(1));
      return f.copyWith(distanceKm: rounded);
    }).toList();

    if (selectedCategory == FacilityFilterCategory.nearby) {
      results.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }
    return results;
  }

  static void showLocationFeedback(BuildContext context, bool success) {
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? (isAmharic
                  ? 'የእርስዎ ወቅታዊ መገኛ ተገኝቷል'
                  : 'Live GPS location acquired. Facilities sorted by proximity.')
              : l10n.locationPermissionDenied,
        ),
        backgroundColor:
            success ? const Color(0xFF0284C7) : const Color(0xFFE11D48),
        duration: Duration(seconds: success ? 2 : 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
