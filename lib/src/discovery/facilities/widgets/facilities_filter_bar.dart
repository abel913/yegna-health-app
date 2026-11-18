import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../models/facilities_view_mode.dart';
import '../models/facility_enums.dart';
import 'facilities_category_chip.dart';
import 'facilities_mode_toggle_button.dart';

class FacilitiesFilterBar extends StatelessWidget {
  const FacilitiesFilterBar({
    required this.selectedCategory,
    required this.viewMode,
    required this.isDark,
    required this.l10n,
    required this.onCategorySelected,
    required this.onViewModeChanged,
    super.key,
  });

  final FacilityFilterCategory selectedCategory;
  final FacilitiesViewMode viewMode;
  final bool isDark;
  final AppLocalizations l10n;
  final ValueChanged<FacilityFilterCategory> onCategorySelected;
  final ValueChanged<FacilitiesViewMode> onViewModeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FacilitiesCategoryChip(
                  label: l10n.allFacilities,
                  icon: Icons.grid_view_rounded,
                  category: FacilityFilterCategory.all,
                  isSelected: selectedCategory == FacilityFilterCategory.all,
                  isDark: isDark,
                  onTap: () => onCategorySelected(FacilityFilterCategory.all),
                ),
                const SizedBox(width: 6),
                FacilitiesCategoryChip(
                  label: l10n.nearbyFilter,
                  icon: Icons.near_me_rounded,
                  category: FacilityFilterCategory.nearby,
                  isSelected: selectedCategory == FacilityFilterCategory.nearby,
                  isDark: isDark,
                  onTap: () => onCategorySelected(FacilityFilterCategory.nearby),
                ),
                const SizedBox(width: 6),
                FacilitiesCategoryChip(
                  label: l10n.categoryClinical,
                  icon: Icons.medical_services_rounded,
                  category: FacilityFilterCategory.clinical,
                  isSelected: selectedCategory == FacilityFilterCategory.clinical,
                  isDark: isDark,
                  onTap: () => onCategorySelected(FacilityFilterCategory.clinical),
                ),
                const SizedBox(width: 6),
                FacilitiesCategoryChip(
                  label: l10n.categoryCounseling,
                  icon: Icons.volunteer_activism_rounded,
                  category: FacilityFilterCategory.counseling,
                  isSelected:
                      selectedCategory == FacilityFilterCategory.counseling,
                  isDark: isDark,
                  onTap: () =>
                      onCategorySelected(FacilityFilterCategory.counseling),
                ),
                const SizedBox(width: 6),
                FacilitiesCategoryChip(
                  label: l10n.categoryAcademic,
                  icon: Icons.menu_book_rounded,
                  category: FacilityFilterCategory.academic,
                  isSelected: selectedCategory == FacilityFilterCategory.academic,
                  isDark: isDark,
                  onTap: () => onCategorySelected(FacilityFilterCategory.academic),
                ),
                const SizedBox(width: 6),
                FacilitiesCategoryChip(
                  label: l10n.categoryStudentAffairs,
                  icon: Icons.account_balance_rounded,
                  category: FacilityFilterCategory.studentAffairs,
                  isSelected:
                      selectedCategory == FacilityFilterCategory.studentAffairs,
                  isDark: isDark,
                  onTap: () =>
                      onCategorySelected(FacilityFilterCategory.studentAffairs),
                ),
                const SizedBox(width: 6),
                FacilitiesCategoryChip(
                  label: l10n.categorySports,
                  icon: Icons.fitness_center_rounded,
                  category: FacilityFilterCategory.sportsDining,
                  isSelected:
                      selectedCategory == FacilityFilterCategory.sportsDining,
                  isDark: isDark,
                  onTap: () =>
                      onCategorySelected(FacilityFilterCategory.sportsDining),
                ),
                const SizedBox(width: 6),
                FacilitiesCategoryChip(
                  label: l10n.categoryAccessibility,
                  icon: Icons.accessible_forward_rounded,
                  category: FacilityFilterCategory.accessibility,
                  isSelected:
                      selectedCategory == FacilityFilterCategory.accessibility,
                  isDark: isDark,
                  onTap: () =>
                      onCategorySelected(FacilityFilterCategory.accessibility),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        FacilitiesModeToggleButton(
          viewMode: viewMode,
          isDark: isDark,
          l10n: l10n,
          onViewModeChanged: onViewModeChanged,
        ),
      ],
    );
  }
}
