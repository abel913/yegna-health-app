import 'dart:ui';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_glass_theme.dart';
import 'facility_launcher.dart';
import 'facility_model.dart';

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
    final addressText = facility.localizedAddress(isAmharic);
    final primaryPhone = facility.focalPhone ?? facility.phone;

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
                // Top drag handle & close button (matching Home & Mentors)
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
                      // --- HERO HEADER GLASS CARD ---
                      ClipRRect(
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
                                    // 58x58 Glowing Category Icon Pod with pulse status dot
                                    Stack(
                                      children: [
                                        Container(
                                          width: 58,
                                          height: 58,
                                          decoration: BoxDecoration(
                                            gradient: RadialGradient(
                                              colors: [
                                                catColor.withValues(
                                                    alpha: isDark ? 0.35 : 0.22),
                                                catColor.withValues(
                                                    alpha: isDark ? 0.18 : 0.08),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(18),
                                            border: Border.all(
                                              color: catColor.withValues(
                                                  alpha: isDark ? 0.55 : 0.35),
                                              width: 1.8,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: catColor.withValues(alpha: 0.30),
                                                blurRadius: 14,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Icon(
                                              facility.categoryIcon,
                                              color: catColor,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 1,
                                          right: 1,
                                          child: Container(
                                            width: 14,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              color: isOpen
                                                  ? const Color(0xFF10B981)
                                                  : const Color(0xFFF59E0B),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isDark
                                                    ? const Color(0xFF0F172A)
                                                    : Colors.white,
                                                width: 2.2,
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
                                                  _getCategoryLabel(
                                                      facility.category, l10n),
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
                                // Quick Action Buttons Dock
                                Row(
                                  children: [
                                    // Call button
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () =>
                                            FacilityLauncher.launchCall(
                                                context, primaryPhone, l10n),
                                        icon: const Icon(Icons.call_rounded,
                                            size: 15, color: Colors.white),
                                        label: Text(
                                          l10n.callActionLabel,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF0284C7),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(11),
                                          ),
                                          elevation: 0,
                                        ),
                                      ),
                                    ),
                                    // Telegram button (if available)
                                    if (facility.telegramHandle != null &&
                                        facility.telegramHandle!
                                            .trim()
                                            .isNotEmpty) ...[
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () =>
                                              FacilityLauncher.launchTelegram(
                                                  context,
                                                  facility.telegramHandle!,
                                                  l10n),
                                          icon: Icon(Icons.send_rounded,
                                              size: 14,
                                              color: isDark
                                                  ? const Color(0xFF38BDF8)
                                                  : const Color(0xFF0284C7)),
                                          label: Text(
                                            'Telegram',
                                            style: TextStyle(
                                              fontFamily: 'PlusJakartaSans',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: isDark
                                                  ? const Color(0xFF38BDF8)
                                                  : const Color(0xFF0284C7),
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              color: isDark
                                                  ? const Color(0xFF38BDF8)
                                                      .withValues(alpha: 0.35)
                                                  : const Color(0xFFBAE6FD),
                                              width: 1.2,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(11),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- FOCAL OFFICER GLASS CARD ---
                      if (facility.focalPerson != null &&
                          facility.focalPerson!.trim().isNotEmpty) ...[
                        _GlassContentCard(
                          title: l10n.focalOfficerLabel,
                          icon: Icons.person_pin_rounded,
                          accentColor: isDark
                              ? const Color(0xFF38BDF8)
                              : const Color(0xFF0284C7),
                          isDark: isDark,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF0284C7)
                                              .withValues(alpha: 0.22)
                                          : const Color(0xFFE0F2FE),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isDark
                                            ? const Color(0xFF38BDF8)
                                                .withValues(alpha: 0.4)
                                            : const Color(0xFFBAE6FD),
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.person_rounded,
                                      color: isDark
                                          ? const Color(0xFF38BDF8)
                                          : const Color(0xFF0284C7),
                                      size: 23,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          facility.focalPerson!,
                                          style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w700,
                                            color: isDark
                                                ? const Color(0xFFF8FAFC)
                                                : const Color(0xFF0F172A),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          facility.focalPhone ?? facility.phone,
                                          style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: 12,
                                            color: isDark
                                                ? const Color(0xFF94A3B8)
                                                : const Color(0xFF64748B),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  // Call Officer Button
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () =>
                                          FacilityLauncher.launchCall(
                                              context, primaryPhone, l10n),
                                      icon: const Icon(
                                          Icons.phone_in_talk_rounded,
                                          size: 16,
                                          color: Colors.white),
                                      label: Text(
                                        l10n.contactOfficerAction,
                                        style: const TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isDark
                                            ? const Color(0xFF0284C7)
                                            : const Color(0xFF0284C7),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(11),
                                        ),
                                        elevation: 0,
                                      ),
                                    ),
                                  ),
                                  // Telegram Button (if handle available)
                                  if (facility.telegramHandle != null &&
                                      facility.telegramHandle!
                                          .trim()
                                          .isNotEmpty) ...[
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () =>
                                            FacilityLauncher.launchTelegram(
                                                context,
                                                facility.telegramHandle!,
                                                l10n),
                                        icon: Icon(Icons.send_rounded,
                                            size: 15,
                                            color: isDark
                                                ? const Color(0xFF38BDF8)
                                                : const Color(0xFF0284C7)),
                                        label: Text(
                                          'Telegram',
                                          style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w700,
                                            color: isDark
                                                ? const Color(0xFF38BDF8)
                                                : const Color(0xFF0284C7),
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: isDark
                                                ? const Color(0xFF38BDF8)
                                                    .withValues(alpha: 0.35)
                                                : const Color(0xFFBAE6FD),
                                            width: 1.2,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(11),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],

                      // --- LOCATION, BUILDING & MAP GLASS CARD ---
                      _GlassContentCard(
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
                            // Campus Name
                            Row(
                              children: [
                                Icon(Icons.account_balance_rounded,
                                    size: 16,
                                    color: isDark
                                        ? const Color(0xFF818CF8)
                                        : const Color(0xFF4F46E5)),
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

                            // Specific Building / Wing (if present)
                            if (buildingText != null &&
                                buildingText.trim().isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.apartment_rounded,
                                      size: 16,
                                      color: isDark
                                          ? const Color(0xFF94A3B8)
                                          : const Color(0xFF64748B)),
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

                            // Landmark (if present)
                            if (landmarkText.trim().isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.flag_outlined,
                                      size: 16,
                                      color: isDark
                                          ? const Color(0xFF38BDF8)
                                          : const Color(0xFF0284C7)),
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

                            // Address string
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

                            // Open in Google Maps Turn-by-Turn Navigation Button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    FacilityLauncher.launchMapNavigation(
                                  context,
                                  latitude: facility.latitude,
                                  longitude: facility.longitude,
                                  label: facility.localizedName(isAmharic),
                                  l10n: l10n,
                                ),
                                icon: Icon(Icons.navigation_rounded,
                                    size: 16,
                                    color: isDark
                                        ? const Color(0xFF818CF8)
                                        : const Color(0xFF4F46E5)),
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
                                        ? const Color(0xFF818CF8)
                                            .withValues(alpha: 0.35)
                                        : const Color(0xFFC7D2FE),
                                    width: 1.2,
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 11),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // --- OPERATING HOURS GLASS CARD ---
                      _GlassContentCard(
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
                                  isOpen
                                      ? l10n.openNowStatus
                                      : l10n.closedStatus,
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
                            Builder(
                              builder: (context) {
                                String detailHours = facility.operatingHours.trim().replaceAll(RegExp(r'^[•\s-]+'), '').trim();
                                if (detailHours.isEmpty) {
                                  detailHours = '${facility.openingHour}:00 - ${facility.closingHour}:00';
                                }
                                return Text(
                                  detailHours,
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? const Color(0xFFF1F5F9)
                                        : const Color(0xFF1E293B),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // --- INCLUSIVITY & ACCESSIBILITY GLASS CARD ---
                      if (facility.isWheelchairAccessible ||
                          facility.hasPrivateRoom) ...[
                        _GlassContentCard(
                          title: isAmharic
                              ? 'ተደራሽነት እና ሚስጥራዊነት'
                              : 'Accessibility & Privacy',
                          icon: Icons.verified_user_outlined,
                          accentColor: isDark
                              ? const Color(0xFF2DD4BF)
                              : const Color(0xFF0D9488),
                          isDark: isDark,
                          child: Column(
                            children: [
                              if (facility.isWheelchairAccessible)
                                _GlassFeatureRow(
                                  icon: Icons.accessible_rounded,
                                  iconColor: isDark
                                      ? const Color(0xFF2DD4BF)
                                      : const Color(0xFF0D9488),
                                  title: l10n.wheelchairAccessibleBadge,
                                  subtitle: isAmharic
                                      ? 'ለአካል ጉዳተኞች ምቹ መግቢያ፣ ራምፕ እና በሮች አሉት።'
                                      : 'Wheelchair ramp access and step-free entrances available.',
                                  isDark: isDark,
                                ),
                              if (facility.isWheelchairAccessible &&
                                  facility.hasPrivateRoom)
                                Divider(
                                  height: 18,
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFF1F5F9),
                                ),
                              if (facility.hasPrivateRoom)
                                _GlassFeatureRow(
                                  icon: Icons.lock_outline_rounded,
                                  iconColor: isDark
                                      ? const Color(0xFF818CF8)
                                      : const Color(0xFF6366F1),
                                  title: l10n.privateRoomBadge,
                                  subtitle: isAmharic
                                      ? 'ድምፅ የማይሰማበት የግል እና ሚስጥራዊ የምክር ክፍል አለው።'
                                      : 'Confidential, sound-isolated private room for 1-on-1 counseling.',
                                  isDark: isDark,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],

                      // --- SERVICES OFFERED CHIPS ---
                      if (facility.services.isNotEmpty) ...[
                        _GlassContentCard(
                          title: l10n.servicesOfferedLabel,
                          icon: Icons.medical_services_outlined,
                          accentColor: isDark
                              ? const Color(0xFF38BDF8)
                              : const Color(0xFF0284C7),
                          isDark: isDark,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final s in facility.services)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? catColor.withValues(alpha: 0.20)
                                        : catColor.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: catColor.withValues(
                                          alpha: isDark ? 0.40 : 0.25),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    '#${s.replaceAll('_', ' ')}',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? catColor.withValues(alpha: 0.95)
                                          : catColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],

                      // --- CONFIDENTIALITY POLICY GUARANTEE ---
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF064E3B)
                                      .withValues(alpha: 0.35)
                                  : const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF34D399)
                                        .withValues(alpha: 0.4)
                                    : const Color(0xFF86EFAC),
                                width: 1.1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.shield_outlined,
                                    color: isDark
                                        ? const Color(0xFF34D399)
                                        : const Color(0xFF16A34A),
                                    size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.confidentialityNoticeTitle,
                                        style: TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: isDark
                                              ? const Color(0xFF6EE7B7)
                                              : const Color(0xFF14532D),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        facility.localizedPolicy(isAmharic),
                                        style: TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          fontSize: 12,
                                          color: isDark
                                              ? const Color(0xFFA7F3D0)
                                              : const Color(0xFF166534),
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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

class _GlassContentCard extends StatelessWidget {
  const _GlassContentCard({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.isDark,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Color accentColor;
  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF131D36).withValues(alpha: 0.76)
                : Colors.white.withValues(alpha: 0.70),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF1E293B).withValues(alpha: 0.82),
                      const Color(0xFF0F172A).withValues(alpha: 0.65),
                      const Color(0xFF0284C7).withValues(alpha: 0.12),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.85),
                      Colors.white.withValues(alpha: 0.45),
                      const Color(0xFFBAE6FD).withValues(alpha: 0.18),
                    ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF38BDF8).withValues(alpha: 0.22)
                  : Colors.white.withValues(alpha: 0.95),
              width: 1.2,
            ),
            boxShadow: isDark
                ? const [
                    BoxShadow(
                      color: Color(0x40000000),
                      blurRadius: 14,
                      offset: Offset(0, 5),
                    ),
                  ]
                : const [
                    BoxShadow(
                      color: Color(0x0C0284C7),
                      blurRadius: 14,
                      offset: Offset(0, 5),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: accentColor),
                  const SizedBox(width: 7),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? const Color(0xFFF8FAFC)
                          : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassFeatureRow extends StatelessWidget {
  const _GlassFeatureRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: isDark ? 0.22 : 0.10),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: iconColor.withValues(alpha: isDark ? 0.40 : 0.25),
              width: 1,
            ),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? const Color(0xFFF8FAFC)
                      : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 11.5,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
