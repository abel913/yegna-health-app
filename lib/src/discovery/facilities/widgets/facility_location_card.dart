import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../facility_launcher.dart';
import '../models/facility.dart';
import 'facility_glass_card.dart';

class FacilityLocationCard extends StatelessWidget {
  const FacilityLocationCard({
    required this.facility,
    required this.isDark,
    required this.isAmharic,
    required this.l10n,
    super.key,
  });

  final Facility facility;
  final bool isDark;
  final bool isAmharic;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final campusText =
        (facility.localizedCampus(isAmharic) ?? facility.subCityEn)
            .replaceAll(RegExp(r'\s+Sub-City', caseSensitive: false), '')
            .trim();
    final buildingText = facility.localizedBuilding(isAmharic);
    final landmarkText = facility.localizedLandmark(isAmharic);
    final addressText = facility.localizedAddress(isAmharic);

    return FacilityGlassContentCard(
      title: isAmharic
          ? 'የግቢው ቦታ እና አቅጣጫ'
          : 'Campus Location & Direction',
      icon: Icons.location_on_outlined,
      accentColor: isDark
          ? const Color(0xFF818CF8)
          : const Color(0xFF4F46E5),
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_rounded,
                size: 16,
                color: isDark
                    ? const Color(0xFF818CF8)
                    : const Color(0xFF4F46E5),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  campusText,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? const Color(0xFFF8FAFC)
                        : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          if (buildingText != null && buildingText.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.apartment_rounded,
                  size: 16,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${l10n.buildingWingLabel}: $buildingText',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13,
                      color: isDark
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF334155),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (landmarkText.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.flag_outlined,
                  size: 16,
                  color: isDark
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFF0284C7),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${l10n.landmarkLabel}: $landmarkText',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12.5,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF475569),
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (addressText.isNotEmpty) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(
                addressText,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 12,
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => FacilityLauncher.launchMapNavigation(
                context,
                latitude: facility.latitude,
                longitude: facility.longitude,
                label: facility.localizedName(isAmharic),
                l10n: l10n,
              ),
              icon: Icon(
                Icons.navigation_rounded,
                size: 16,
                color: isDark
                    ? const Color(0xFF818CF8)
                    : const Color(0xFF4F46E5),
              ),
              label: Text(
                l10n.openInMapsAction,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? const Color(0xFF818CF8)
                      : const Color(0xFF4F46E5),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isDark
                      ? const Color(0xFF818CF8).withValues(alpha: 0.35)
                      : const Color(0xFFC7D2FE),
                  width: 1.2,
                ),
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
