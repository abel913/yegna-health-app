import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../models/facility.dart';
import '../models/facility_enums.dart';

class FacilityCardHeader extends StatelessWidget {
  const FacilityCardHeader({
    required this.facility,
    required this.isDark,
    required this.isAmharic,
    required this.catColor,
    required this.glass,
    required this.l10n,
    super.key,
  });

  final Facility facility;
  final bool isDark;
  final bool isAmharic;
  final Color catColor;
  final AppGlassTheme glass;
  final AppLocalizations l10n;

  String _getCategoryLabel(FacilityCategory category) {
    switch (category) {
      case FacilityCategory.clinical:
        return l10n.categoryClinical;
      case FacilityCategory.counseling:
        return l10n.categoryCounseling;
      case FacilityCategory.academic:
        return l10n.categoryAcademic;
      case FacilityCategory.studentAffairs:
        return l10n.categoryStudentAffairs;
      case FacilityCategory.sportsDining:
        return l10n.categorySports;
      case FacilityCategory.accessibility:
        return l10n.categoryAccessibility;
    }
  }

  @override
  Widget build(BuildContext context) {
    final campusText =
        (facility.localizedCampus(isAmharic) ?? facility.subCityEn)
            .replaceAll(RegExp(r'\s+Sub-City', caseSensitive: false), '')
            .trim();
    final buildingText = facility.localizedBuilding(isAmharic);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                facility.localizedName(isAmharic),
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: glass.titleText,
                  height: 1.25,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (facility.isVerified) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.verified_rounded,
                size: 16,
                color: isDark
                    ? const Color(0xFF38BDF8)
                    : const Color(0xFF0284C7),
              ),
            ],
          ],
        ),
        const SizedBox(height: 3),
        Text(
          _getCategoryLabel(facility.category),
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: catColor,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 12,
              color: glass.subtitleText,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                buildingText != null && buildingText.isNotEmpty
                    ? '$campusText • $buildingText'
                    : campusText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 11.5,
                  color: glass.subtitleText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
