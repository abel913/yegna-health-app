import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'facility_detail_sheet.dart';
import 'facility_model.dart';
import 'phone_launcher.dart';

class FacilityCard extends StatelessWidget {
  const FacilityCard({
    required this.facility,
    this.onTap,
    super.key,
  });

  final Facility facility;
  final VoidCallback? onTap;

  /// Launches the native phone dialer for the clinic or falls back to clipboard copy.
  static Future<void> launchCall(
    BuildContext context,
    String phone,
    AppLocalizations l10n,
  ) =>
      PhoneLauncher.launchCall(context, phone, l10n);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    final isOpen = facility.isOpenNow;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFBAE6FD).withValues(alpha: 0.65),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0284C7),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap ?? () => FacilityDetailSheet.show(context, facility),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFF7DD3FC),
                          width: 1.2,
                        ),
                      ),
                      child: Icon(
                        facility.type == FacilityType.campusClinic
                            ? Icons.school_rounded
                            : Icons.local_hospital_rounded,
                        color: const Color(0xFF0284C7),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            facility.localizedName(isAmharic),
                            style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF08264A),
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            facility.localizedSubCity(isAmharic),
                            style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 12.5,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Distance pill badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F9FF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFBAE6FD),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.near_me_rounded,
                              size: 11, color: Color(0xFF0284C7)),
                          const SizedBox(width: 4),
                          Text(
                            l10n.distanceKm(
                                facility.distanceKm.toStringAsFixed(1)),
                            style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0284C7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Status row: Open/Closed and closing hour
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
                    const SizedBox(width: 6),
                    Text(
                      isOpen
                          ? '${l10n.openNowStatus} • ${l10n.closesAt('${facility.closingHour}:00')}'
                          : '${l10n.closedStatus} • ${l10n.opensAt('${facility.openingHour}:00')}',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isOpen
                            ? const Color(0xFF059669)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Badges row
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (facility.isYouthFriendly)
                      _BadgePill(
                        label: l10n.verifiedYouthFriendlyBadge,
                        bgColor: const Color(0xFFECFDF5),
                        textColor: const Color(0xFF059669),
                        icon: Icons.verified_rounded,
                      ),
                    if (facility.isFreeForYouth)
                      _BadgePill(
                        label: l10n.freeForYouthBadge,
                        bgColor: const Color(0xFFF0FDF4),
                        textColor: const Color(0xFF16A34A),
                        icon: Icons.check_circle_outline_rounded,
                      ),
                    if (facility.campusNameEn != null)
                      _BadgePill(
                        label: l10n.campusClinicBadge,
                        bgColor: const Color(0xFFEFF6FF),
                        textColor: const Color(0xFF2563EB),
                        icon: Icons.school_outlined,
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Action Bar
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            launchCall(context, facility.phone, l10n),
                        icon: const Icon(Icons.call_outlined,
                            size: 15, color: Color(0xFF0284C7)),
                        label: Text(
                          l10n.callClinicAction,
                          style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFFBAE6FD), width: 1.2),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: const Color(0xFFF0F9FF),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onTap ??
                            () => FacilityDetailSheet.show(context, facility),
                        icon: const Icon(Icons.arrow_forward_rounded,
                            size: 15, color: Colors.white),
                        label: Text(
                          l10n.viewDetailsAction,
                          style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0284C7),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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
    );
  }
}

class _BadgePill extends StatelessWidget {
  const _BadgePill({
    required this.label,
    required this.bgColor,
    required this.textColor,
    required this.icon,
  });

  final String label;
  final Color bgColor;
  final Color textColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 3.5),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
      );
}
