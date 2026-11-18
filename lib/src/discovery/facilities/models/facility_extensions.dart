import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import 'facility.dart';
import 'facility_enums.dart';

extension FacilityThemeExtension on Facility {
  String localizedCategoryLabel(AppLocalizations l10n) {
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

  IconData get categoryIcon {
    switch (category) {
      case FacilityCategory.clinical:
        return Icons.medical_services_rounded;
      case FacilityCategory.counseling:
        return Icons.volunteer_activism_rounded;
      case FacilityCategory.academic:
        return Icons.menu_book_rounded;
      case FacilityCategory.studentAffairs:
        return Icons.account_balance_rounded;
      case FacilityCategory.sportsDining:
        return Icons.fitness_center_rounded;
      case FacilityCategory.accessibility:
        return Icons.accessible_forward_rounded;
    }
  }

  Color get categoryColor {
    switch (category) {
      case FacilityCategory.clinical:
        return const Color(0xFF0284C7);
      case FacilityCategory.counseling:
        return const Color(0xFF6366F1);
      case FacilityCategory.academic:
        return const Color(0xFF059669);
      case FacilityCategory.studentAffairs:
        return const Color(0xFFD97706);
      case FacilityCategory.sportsDining:
        return const Color(0xFF2563EB);
      case FacilityCategory.accessibility:
        return const Color(0xFF0D9488);
    }
  }

  bool get isOpenNow {
    final lower = operatingHours.toLowerCase().trim();
    if (lower.contains('24/7') ||
        lower.contains('24 hours') ||
        lower.contains('emergency') ||
        lower.startsWith('open now') ||
        (openingHour == 0 && closingHour >= 24)) {
      return true;
    }
    final now = DateTime.now();
    final hour = now.hour;
    return hour >= openingHour && hour < closingHour;
  }
}
