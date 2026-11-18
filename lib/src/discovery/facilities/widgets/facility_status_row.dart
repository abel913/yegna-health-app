import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../models/facility.dart';

class FacilityStatusRow extends StatelessWidget {
  const FacilityStatusRow({
    required this.facility,
    required this.isDark,
    required this.isAmharic,
    required this.isOpen,
    required this.l10n,
    super.key,
  });

  final Facility facility;
  final bool isDark;
  final bool isAmharic;
  final bool isOpen;
  final AppLocalizations l10n;

  String _formatHours() {
    final raw = facility.operatingHours
        .trim()
        .replaceAll(RegExp(r'^[•\s-]+'), '')
        .trim();
    if (raw.isNotEmpty) {
      final lower = raw.toLowerCase();
      if (lower.startsWith('open')) {
        return raw;
      }
      return isOpen
          ? '${l10n.openNowStatus} • $raw'
          : '${l10n.closedStatus} • $raw';
    }
    return isOpen
        ? '${l10n.openNowStatus} • ${l10n.closesAt('${facility.closingHour}:00')}'
        : '${l10n.closedStatus} • ${l10n.opensAt('${facility.openingHour}:00')}';
  }

  @override
  Widget build(BuildContext context) {
    final landmarkText = facility.localizedLandmark(isAmharic);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (landmarkText.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 58, bottom: 8),
            child: Row(
              children: [
                Icon(
                  Icons.turn_right_rounded,
                  size: 13,
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.6)
                      : const Color(0xFF94A3B8),
                ),
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
                      color: const Color(0xFF10B981).withValues(alpha: 0.4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                _formatHours(),
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
      ],
    );
  }
}
