import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../facility_detail_sheet.dart';
import '../models/facility.dart';
import 'map_directions_launcher.dart';

class FacilityPreviewCardActions extends StatelessWidget {
  const FacilityPreviewCardActions({
    required this.facility,
    required this.isAmharic,
    required this.isDark,
    required this.l10n,
    super.key,
  });

  final Facility facility;
  final bool isAmharic;
  final bool isDark;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => FacilityDetailSheet.show(context, facility),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isDark
                    ? const Color(0xFF38BDF8).withValues(alpha: 0.3)
                    : const Color(0xFFBAE6FD),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            child: Text(
              l10n.viewDetailsAction,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? const Color(0xFF38BDF8)
                    : const Color(0xFF0284C7),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => MapDirectionsLauncher.launch(
              context,
              facility: facility,
              isAmharic: isAmharic,
              l10n: l10n,
            ),
            icon: const Icon(Icons.navigation_rounded,
                size: 14, color: Colors.white),
            label: Text(
              l10n.directionsAction,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }
}
