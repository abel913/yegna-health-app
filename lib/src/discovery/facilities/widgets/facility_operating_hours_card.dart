import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../models/facility.dart';
import 'facility_glass_card.dart';

class FacilityOperatingHoursCard extends StatelessWidget {
  const FacilityOperatingHoursCard({
    required this.facility,
    required this.isDark,
    required this.isOpen,
    required this.l10n,
    super.key,
  });

  final Facility facility;
  final bool isDark;
  final bool isOpen;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    String detailHours = facility.operatingHours
        .trim()
        .replaceAll(RegExp(r'^[•\s-]+'), '')
        .trim();
    if (detailHours.isEmpty) {
      detailHours = '${facility.openingHour}:00 - ${facility.closingHour}:00';
    }

    return FacilityGlassContentCard(
      title: l10n.operatingHoursLabel,
      icon: Icons.schedule_rounded,
      accentColor: isDark
          ? const Color(0xFF34D399)
          : const Color(0xFF059669),
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isOpen
                      ? const Color(0xFF10B981)
                      : const Color(0xFF94A3B8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (isOpen)
                      BoxShadow(
                        color: const Color(0xFF10B981)
                            .withValues(alpha: 0.4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isOpen ? l10n.openNowStatus : l10n.closedStatus,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isOpen
                      ? (isDark
                          ? const Color(0xFF34D399)
                          : const Color(0xFF059669))
                      : (isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            detailHours,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? const Color(0xFFF1F5F9)
                  : const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
