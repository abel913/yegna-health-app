import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../../facility_detail_sheet.dart';
import '../models/facility.dart';
import 'facility_card_action_bar.dart';
import 'facility_card_header.dart';
import 'facility_category_icon_pod.dart';
import 'facility_distance_pill.dart';
import 'facility_status_row.dart';

class FacilityCard extends StatelessWidget {
  const FacilityCard({
    required this.facility,
    this.onTap,
    this.isNearest = false,
    super.key,
  });

  final Facility facility;
  final VoidCallback? onTap;
  final bool isNearest;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    final isOpen = facility.isOpenNow;
    final catColor = facility.categoryColor;
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF131D36).withValues(alpha: 0.76)
                  : Colors.white.withValues(alpha: 0.50),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF1E293B).withValues(alpha: 0.85),
                        const Color(0xFF0F172A).withValues(alpha: 0.70),
                        const Color(0xFF0284C7).withValues(alpha: 0.16),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.75),
                        Colors.white.withValues(alpha: 0.35),
                        const Color(0xFFBAE6FD).withValues(alpha: 0.18),
                      ],
                stops: const [0.0, 0.65, 1.0],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF38BDF8).withValues(alpha: 0.24)
                    : Colors.white.withValues(alpha: 0.90),
                width: 1.4,
              ),
              boxShadow: isDark
                  ? const [
                      BoxShadow(
                        color: Color(0x60000000),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Color(0x1F38BDF8),
                        blurRadius: 6,
                        offset: Offset(-1, -1),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.14),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        blurRadius: 6,
                        offset: const Offset(-2, -2),
                      ),
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(22),
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: onTap ??
                    () => FacilityDetailSheet.show(context, facility),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FacilityCategoryIconPod(
                            facility: facility,
                            isDark: isDark,
                            isOpen: isOpen,
                            catColor: catColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FacilityCardHeader(
                              facility: facility,
                              isDark: isDark,
                              isAmharic: isAmharic,
                              catColor: catColor,
                              glass: glass,
                              l10n: l10n,
                            ),
                          ),
                          FacilityDistancePill(
                            facility: facility,
                            isDark: isDark,
                            isAmharic: isAmharic,
                            isNearest: isNearest,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      FacilityStatusRow(
                        facility: facility,
                        isDark: isDark,
                        isAmharic: isAmharic,
                        isOpen: isOpen,
                        l10n: l10n,
                      ),
                      const SizedBox(height: 14),
                      FacilityCardActionBar(
                        facility: facility,
                        isDark: isDark,
                        l10n: l10n,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
