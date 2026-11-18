import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../models/facility.dart';
import 'facility_detail_action_dock.dart';
import 'facility_detail_category_icon_pod.dart';

class FacilityDetailHeroHeader extends StatelessWidget {
  const FacilityDetailHeroHeader({
    required this.facility,
    required this.isDark,
    required this.isAmharic,
    required this.isOpen,
    required this.catColor,
    required this.glass,
    required this.l10n,
    super.key,
  });

  final Facility facility;
  final bool isDark;
  final bool isAmharic;
  final bool isOpen;
  final Color catColor;
  final AppGlassTheme glass;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final campusText =
        (facility.localizedCampus(isAmharic) ?? facility.subCityEn)
            .replaceAll(RegExp(r'\s+Sub-City', caseSensitive: false), '')
            .trim();

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF131D36).withValues(alpha: 0.78)
                : Colors.white.withValues(alpha: 0.75),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF1E293B).withValues(alpha: 0.85),
                      const Color(0xFF0F172A).withValues(alpha: 0.70),
                      catColor.withValues(alpha: 0.16),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.90),
                      Colors.white.withValues(alpha: 0.50),
                      catColor.withValues(alpha: 0.12),
                    ],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF38BDF8).withValues(alpha: 0.28)
                  : Colors.white.withValues(alpha: 0.95),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? const Color(0x60000000)
                    : const Color(0x150284C7),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FacilityDetailCategoryIconPod(
                    facility: facility,
                    isDark: isDark,
                    isOpen: isOpen,
                    catColor: catColor,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3.5),
                              decoration: BoxDecoration(
                                color: catColor.withValues(
                                    alpha: isDark ? 0.22 : 0.12),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: catColor.withValues(
                                      alpha: isDark ? 0.40 : 0.25),
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                facility.localizedCategoryLabel(l10n),
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: catColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3.5),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                        .withValues(alpha: 0.6)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF38BDF8)
                                          .withValues(alpha: 0.15)
                                      : Colors.white,
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                l10n.distanceKm(facility.distanceKm
                                    .toStringAsFixed(1)),
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? const Color(0xFFE2E8F0)
                                      : const Color(0xFF475569),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Text(
                          facility.localizedName(isAmharic),
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 18.5,
                            fontWeight: FontWeight.w800,
                            color: glass.titleText,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          campusText,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 13,
                            color: glass.subtitleText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FacilityDetailActionDock(
                facility: facility,
                isDark: isDark,
                l10n: l10n,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
