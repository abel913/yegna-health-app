import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../models/mentor.dart';
import 'mentor_schedule_sheet.dart';

class MentorScheduleActionPill extends StatelessWidget {
  const MentorScheduleActionPill({
    required this.mentor,
    required this.l10n,
    required this.isDark,
    super.key,
  });

  final Mentor mentor;
  final AppLocalizations l10n;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => MentorScheduleSheet.show(context, mentor),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.5),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? const Color(0xFF38BDF8).withValues(alpha: 0.35)
                : const Color(0xFFBFDBFE),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_rounded,
              size: 16,
              color: isDark
                  ? const Color(0xFF38BDF8)
                  : const Color(0xFF0284C7),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.weeklyAvailabilityTitle,
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
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: isDark
                  ? const Color(0xFF38BDF8)
                  : const Color(0xFF0284C7),
            ),
          ],
        ),
      ),
    );
  }
}
