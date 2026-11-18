import 'dart:ui';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_glass_theme.dart';
import 'facility_detail_sheet.dart';
import 'facility_launcher.dart';
import 'facility_model.dart';
import 'location_service.dart';

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

  String _getCategoryLabel(
      FacilityCategory category, AppLocalizations l10n) {
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
    final l10n = AppLocalizations.of(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    final isOpen = facility.isOpenNow;
    final catColor = facility.categoryColor;
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    final campusText =
        (facility.localizedCampus(isAmharic) ?? facility.subCityEn)
            .replaceAll(RegExp(r'\s+Sub-City', caseSensitive: false), '')
            .trim();
    final buildingText = facility.localizedBuilding(isAmharic);
    final landmarkText = facility.localizedLandmark(isAmharic);
    final primaryPhone = facility.focalPhone ?? facility.phone;

    String formatHours() {
      final raw = facility.operatingHours.trim().replaceAll(RegExp(r'^[•\s-]+'), '').trim();
      if (raw.isNotEmpty) {
        final lower = raw.toLowerCase();
        if (lower.startsWith('open')) {
          return raw;
        }
        return isOpen ? '${l10n.openNowStatus} • $raw' : '${l10n.closedStatus} • $raw';
      }
      return isOpen
          ? '${l10n.openNowStatus} • ${l10n.closesAt('${facility.closingHour}:00')}'
          : '${l10n.closedStatus} • ${l10n.opensAt('${facility.openingHour}:00')}';
    }

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
                onTap: onTap ?? () => FacilityDetailSheet.show(context, facility),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Category Icon Pod + Title/Campus + Distance Pill
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 50x50 Category Icon Pod with pulse dot (Matching Mentor Avatar Architecture)
                          Stack(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [
                                      catColor.withValues(
                                          alpha: isDark ? 0.35 : 0.22),
                                      catColor.withValues(
                                          alpha: isDark ? 0.18 : 0.08),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: catColor.withValues(
                                        alpha: isDark ? 0.50 : 0.30),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: catColor.withValues(alpha: 0.25),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    facility.categoryIcon,
                                    color: catColor,
                                    size: 26,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 1,
                                right: 1,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: isOpen
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFFF59E0B),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark
                                          ? const Color(0xFF0F172A)
                                          : Colors.white,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      if (isOpen)
                                        BoxShadow(
                                          color: const Color(0xFF10B981)
                                              .withValues(alpha: 0.5),
                                          blurRadius: 6,
                                          spreadRadius: 1,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
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
                                  _getCategoryLabel(facility.category, l10n),
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: catColor,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                // Campus & Building Location
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
                                        buildingText != null &&
                                                buildingText.isNotEmpty
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
                            ),
                          ),
                          // Distance Pill
                          if (isNearest) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3.5),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF0369A1)
                                        .withValues(alpha: 0.55)
                                    : const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF38BDF8)
                                      : const Color(0xFF0284C7),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.stars_rounded,
                                      size: 11,
                                      color: isDark
                                          ? const Color(0xFF38BDF8)
                                          : const Color(0xFF0284C7)),
                                  const SizedBox(width: 3),
                                  Text(
                                    isAmharic ? 'በጣም ቅርብ' : 'Nearest',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: isDark
                                          ? const Color(0xFF38BDF8)
                                          : const Color(0xFF0284C7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                      .withValues(alpha: 0.6)
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF38BDF8)
                                        .withValues(alpha: 0.15)
                                    : Colors.white,
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.near_me_rounded,
                                    size: 11,
                                    color: isDark
                                        ? const Color(0xFF38BDF8)
                                        : const Color(0xFF475569)),
                                const SizedBox(width: 4),
                                Text(
                                  LocationService.formatDistance(
                                      facility.distanceKm, isAmharic),
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? const Color(0xFFE2E8F0)
                                        : const Color(0xFF334155),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Landmark instruction hint (if present)
                      if (landmarkText.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 58),
                          child: Row(
                            children: [
                              Icon(Icons.turn_right_rounded,
                                  size: 13,
                                  color: isDark
                                      ? const Color(0xFF38BDF8)
                                          .withValues(alpha: 0.6)
                                      : const Color(0xFF94A3B8)),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  landmarkText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 11.5,
                                    color: isDark
                                        ? const Color(0xFFCBD5E1)
                                        : const Color(0xFF64748B),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),

                      // Operating Hours & Live Status
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
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
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              formatHours(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: isOpen
                                    ? (isDark
                                        ? const Color(0xFF34D399)
                                        : const Color(0xFF047857))
                                    : (isDark
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF64748B)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Action Bar
                      Row(
                        children: [
                          // Direct Call Button
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => FacilityLauncher.launchCall(
                                  context, primaryPhone, l10n),
                              icon: Icon(Icons.call_outlined,
                                  size: 14,
                                  color: isDark
                                      ? const Color(0xFFF8FAFC)
                                      : const Color(0xFF0F172A)),
                              label: Text(
                                l10n.callActionLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? const Color(0xFFF8FAFC)
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: isDark
                                      ? const Color(0xFF38BDF8)
                                          .withValues(alpha: 0.3)
                                      : const Color(0xFFCBD5E1),
                                  width: 1.1,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                            ),
                          ),

                          // Telegram Button (if handle available)
                          if (facility.telegramHandle != null &&
                              facility.telegramHandle!.trim().isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Material(
                              color: isDark
                                  ? const Color(0xFF0284C7)
                                      .withValues(alpha: 0.20)
                                  : const Color(0xFF0284C7)
                                      .withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(11),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(11),
                                onTap: () => FacilityLauncher.launchTelegram(
                                    context, facility.telegramHandle!, l10n),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 9, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    border: Border.all(
                                      color: const Color(0xFF0284C7)
                                          .withValues(alpha: isDark ? 0.45 : 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.send_rounded,
                                          size: 13,
                                          color: isDark
                                              ? const Color(0xFF38BDF8)
                                              : const Color(0xFF0284C7)),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Telegram',
                                        style: TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w700,
                                          color: isDark
                                              ? const Color(0xFF38BDF8)
                                              : const Color(0xFF0284C7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(width: 8),

                          // Details Button
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  FacilityDetailSheet.show(context, facility),
                              icon: const Icon(Icons.arrow_forward_rounded,
                                  size: 13, color: Colors.white),
                              label: Text(
                                l10n.viewDetailsAction,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark
                                    ? const Color(0xFF0284C7)
                                    : const Color(0xFF0F172A),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
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

