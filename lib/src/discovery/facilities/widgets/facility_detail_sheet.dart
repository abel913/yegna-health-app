import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../models/facility.dart';
import 'facility_confidentiality_card.dart';
import 'facility_detail_hero_header.dart';
import 'facility_focal_person_card.dart';
import 'facility_inclusivity_and_services.dart';
import 'facility_location_card.dart';
import 'facility_operating_hours_card.dart';

class FacilityDetailSheet extends StatelessWidget {
  const FacilityDetailSheet({
    required this.facility,
    super.key,
  });

  final Facility facility;

  static void show(BuildContext context, Facility facility) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FacilityDetailSheet(facility: facility),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    final isOpen = facility.isOpenNow;
    final catColor = facility.categoryColor;
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.96,
      builder: (context, scrollController) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF070D1E).withValues(alpha: 0.94)
                  : const Color(0xFFF8FAFC).withValues(alpha: 0.95),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.35)
                      : Colors.white.withValues(alpha: 0.95),
                  width: 1.5,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.6)
                      : const Color(0x330284C7),
                  blurRadius: 28,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 4.5,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 22),
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
                    children: [
                      FacilityDetailHeroHeader(
                        facility: facility,
                        isDark: isDark,
                        isAmharic: isAmharic,
                        isOpen: isOpen,
                        catColor: catColor,
                        glass: glass,
                        l10n: l10n,
                      ),
                      const SizedBox(height: 16),
                      FacilityFocalPersonCard(
                        facility: facility,
                        isDark: isDark,
                        l10n: l10n,
                      ),
                      FacilityLocationCard(
                        facility: facility,
                        isDark: isDark,
                        isAmharic: isAmharic,
                        l10n: l10n,
                      ),
                      const SizedBox(height: 14),
                      FacilityOperatingHoursCard(
                        facility: facility,
                        isDark: isDark,
                        isOpen: isOpen,
                        l10n: l10n,
                      ),
                      const SizedBox(height: 14),
                      FacilityInclusivityAndServices(
                        facility: facility,
                        isDark: isDark,
                        isAmharic: isAmharic,
                        catColor: catColor,
                        l10n: l10n,
                      ),
                      FacilityConfidentialityCard(
                        facility: facility,
                        isDark: isDark,
                        isAmharic: isAmharic,
                        l10n: l10n,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
