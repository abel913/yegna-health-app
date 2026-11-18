import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../facility_launcher.dart';
import '../models/facility.dart';

class FacilityDetailActionDock extends StatelessWidget {
  const FacilityDetailActionDock({
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
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () =>
                FacilityLauncher.launchCall(context, primaryPhone, l10n),
            icon: const Icon(Icons.call_rounded, size: 15, color: Colors.white),
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
              icon: Icon(
                Icons.send_rounded,
                size: 14,
                color: isDark
                    ? const Color(0xFF38BDF8)
                    : const Color(0xFF0284C7),
              ),
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
    );
  }
}
