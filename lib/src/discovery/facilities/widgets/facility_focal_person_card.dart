import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../facility_launcher.dart';
import '../models/facility.dart';
import 'facility_glass_card.dart';

class FacilityFocalPersonCard extends StatelessWidget {
  const FacilityFocalPersonCard({
    required this.facility,
    required this.isDark,
    required this.l10n,
    super.key,
  });

  final Facility facility;
  final bool isDark;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    if (facility.focalPerson == null ||
        facility.focalPerson!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final primaryPhone = facility.focalPhone ?? facility.phone;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: FacilityGlassContentCard(
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
                        ? const Color(0xFF0284C7).withValues(alpha: 0.22)
                        : const Color(0xFFE0F2FE),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF38BDF8).withValues(alpha: 0.4)
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        FacilityLauncher.launchCall(context, primaryPhone, l10n),
                    icon: const Icon(Icons.phone_in_talk_rounded,
                        size: 16, color: Colors.white),
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
                      backgroundColor: const Color(0xFF0284C7),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                if (facility.telegramHandle != null &&
                    facility.telegramHandle!.trim().isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => FacilityLauncher.launchTelegram(
                          context, facility.telegramHandle!, l10n),
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
                              ? const Color(0xFF38BDF8).withValues(alpha: 0.35)
                              : const Color(0xFFBAE6FD),
                          width: 1.2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
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
    );
  }
}
