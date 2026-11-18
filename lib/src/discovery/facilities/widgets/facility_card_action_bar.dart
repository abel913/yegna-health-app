import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../facility_detail_sheet.dart';
import '../../facility_launcher.dart';
import '../models/facility.dart';

class FacilityCardActionBar extends StatelessWidget {
  const FacilityCardActionBar({
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
    final primaryPhone = facility.focalPhone ?? facility.phone;

    return Row(
      children: [
        // Direct Call Button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () =>
                FacilityLauncher.launchCall(context, primaryPhone, l10n),
            icon: Icon(
              Icons.call_outlined,
              size: 14,
              color: isDark
                  ? const Color(0xFFF8FAFC)
                  : const Color(0xFF0F172A),
            ),
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
                    ? const Color(0xFF38BDF8).withValues(alpha: 0.3)
                    : const Color(0xFFCBD5E1),
                width: 1.1,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
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
                ? const Color(0xFF0284C7).withValues(alpha: 0.20)
                : const Color(0xFF0284C7).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(11),
            child: InkWell(
              borderRadius: BorderRadius.circular(11),
              onTap: () => FacilityLauncher.launchTelegram(
                  context, facility.telegramHandle!, l10n),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
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
                    Icon(
                      Icons.send_rounded,
                      size: 13,
                      color: isDark
                          ? const Color(0xFF38BDF8)
                          : const Color(0xFF0284C7),
                    ),
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
            onPressed: () => FacilityDetailSheet.show(context, facility),
            icon: const Icon(
              Icons.arrow_forward_rounded,
              size: 13,
              color: Colors.white,
            ),
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
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}
