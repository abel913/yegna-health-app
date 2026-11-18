import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../models/facility.dart';
import 'map_preview_card_actions.dart';

class FacilityPreviewCard extends StatelessWidget {
  const FacilityPreviewCard({
    required this.facility,
    required this.isAmharic,
    required this.l10n,
    super.key,
  });

  final Facility facility;
  final bool isAmharic;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final campus = (facility.localizedCampus(isAmharic) ?? facility.subCityEn)
        .replaceAll(RegExp(r'\s+Sub-City', caseSensitive: false), '')
        .trim();
    final building = facility.localizedBuilding(isAmharic);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF131D36).withValues(alpha: 0.82)
                : Colors.white.withValues(alpha: 0.85),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF1E293B).withValues(alpha: 0.88),
                      const Color(0xFF0F172A).withValues(alpha: 0.75),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.90),
                      Colors.white.withValues(alpha: 0.60),
                    ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: isDark
                ? const [
                    BoxShadow(
                      color: Color(0x60000000),
                      blurRadius: 22,
                      offset: Offset(0, 8),
                    ),
                  ]
                : const [
                    BoxShadow(
                      color: Color(0x2E0284C7),
                      blurRadius: 22,
                      offset: Offset(0, 8),
                    ),
                  ],
            border: Border.all(
              color: isDark
                  ? const Color(0xFF38BDF8).withValues(alpha: 0.28)
                  : Colors.white,
              width: 1.4,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          facility.localizedName(isAmharic),
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? const Color(0xFFF8FAFC)
                                : const Color(0xFF08264A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          building != null ? '$campus • $building' : campus,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                          : const Color(0xFFF0F9FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF38BDF8).withValues(alpha: 0.2)
                            : const Color(0xFFBAE6FD),
                      ),
                    ),
                    child: Text(
                      l10n.distanceKm(facility.distanceKm.toStringAsFixed(1)),
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? const Color(0xFF38BDF8)
                            : const Color(0xFF0284C7),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FacilityPreviewCardActions(
                facility: facility,
                isAmharic: isAmharic,
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
