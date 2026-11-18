import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../models/uog_campus_model.dart';
import 'campus_dropdown_dialog.dart';
import 'mentors_campus_trigger.dart';
import 'mentors_clear_filter_button.dart';

class MentorsFilterBar extends StatelessWidget {
  const MentorsFilterBar({
    required this.l10n,
    required this.glass,
    required this.isDark,
    required this.isAmharic,
    required this.selectedCampus,
    required this.mentorsCount,
    required this.onCampusSelected,
    required this.onClearFilter,
    super.key,
  });

  final AppLocalizations l10n;
  final AppGlassTheme glass;
  final bool isDark;
  final bool isAmharic;
  final String selectedCampus;
  final int mentorsCount;
  final ValueChanged<String> onCampusSelected;
  final VoidCallback onClearFilter;

  @override
  Widget build(BuildContext context) {
    final activeCampus = kUogCampuses.firstWhere(
      (c) => c.id == selectedCampus,
      orElse: () => kUogCampuses.first,
    );
    final isCampusFiltered = selectedCampus != 'all';
    final label = isCampusFiltered
        ? activeCampus.localizedName(isAmharic)
        : l10n.allCampuses;

    final countText = isAmharic
        ? '$mentorsCount አማካሪዎች'
        : (mentorsCount == 1 ? '1 mentor' : '$mentorsCount mentors');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Row(
        children: [
          MentorsCampusTrigger(
            glass: glass,
            isDark: isDark,
            isCampusFiltered: isCampusFiltered,
            activeCampus: activeCampus,
            label: label,
            onTap: () => CampusDropdownDialog.show(
              context: context,
              l10n: l10n,
              glass: glass,
              isDark: isDark,
              isAmharic: isAmharic,
              selectedCampus: selectedCampus,
              onSelected: onCampusSelected,
            ),
          ),
          if (isCampusFiltered) ...[
            const SizedBox(width: 8),
            MentorsClearFilterButton(
              glass: glass,
              isDark: isDark,
              label: l10n.clearCampusFilter,
              onTap: onClearFilter,
            ),
          ],
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0F172A).withValues(alpha: 0.65)
                  : Colors.white.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF38BDF8).withValues(alpha: 0.18)
                    : const Color(0xFFE2E8F0).withValues(alpha: 0.85),
                width: 1,
              ),
            ),
            child: Text(
              countText,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: glass.subtitleText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
