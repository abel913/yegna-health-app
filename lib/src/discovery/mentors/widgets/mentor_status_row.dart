import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../models/mentor.dart';
import 'mentor_schedule_sheet.dart';

class MentorStatusRow extends StatelessWidget {
  const MentorStatusRow({
    required this.mentor,
    required this.isAmharic,
    required this.isDark,
    required this.glass,
    required this.l10n,
    super.key,
  });

  final Mentor mentor;
  final bool isAmharic;
  final bool isDark;
  final AppGlassTheme glass;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isAvailableNow = mentor.isCurrentlyAvailableNow;

    return Row(
      children: [
        // Status Pill (Clickable -> Opens Schedule Modal)
        InkWell(
          onTap: () => MentorScheduleSheet.show(context, mentor),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
            decoration: BoxDecoration(
              color: isAvailableNow
                  ? (isDark
                      ? const Color(0xFF064E3B).withValues(alpha: 0.55)
                      : const Color(0xFFECFDF5).withValues(alpha: 0.85))
                  : (isDark
                      ? const Color(0xFF78350F).withValues(alpha: 0.55)
                      : const Color(0xFFFFFBEB).withValues(alpha: 0.85)),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isAvailableNow
                    ? (isDark
                        ? const Color(0xFF10B981).withValues(alpha: 0.35)
                        : const Color(0xFFA7F3D0).withValues(alpha: 0.85))
                    : (isDark
                        ? const Color(0xFFF59E0B).withValues(alpha: 0.35)
                        : const Color(0xFFFDE68A).withValues(alpha: 0.85)),
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isAvailableNow
                      ? Icons.check_circle_rounded
                      : Icons.schedule_rounded,
                  size: 12,
                  color: isAvailableNow
                      ? (isDark
                          ? const Color(0xFF34D399)
                          : const Color(0xFF059669))
                      : (isDark
                          ? const Color(0xFFFBBF24)
                          : const Color(0xFFD97706)),
                ),
                const SizedBox(width: 4),
                Text(
                  isAvailableNow
                      ? l10n.availableNowBadge
                      : l10n.nextSlotBadge(
                          mentor.getDynamicNextSlotText(isAmharic)),
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isAvailableNow
                        ? (isDark
                            ? const Color(0xFF34D399)
                            : const Color(0xFF059669))
                        : (isDark
                            ? const Color(0xFFFBBF24)
                            : const Color(0xFFB45309)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Languages Pill
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E293B).withValues(alpha: 0.65)
                  : const Color(0xFFF1F5F9).withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF334155).withValues(alpha: 0.5)
                    : const Color(0xFFE2E8F0).withValues(alpha: 0.8),
                width: 0.8,
              ),
            ),
            child: Text(
              '🗣️ ${mentor.languages.join(' • ')}',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: glass.subtitleText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
