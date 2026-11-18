import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../models/mentor.dart';
import 'mentor_day_schedule_row.dart';

class MentorScheduleMatrix extends StatelessWidget {
  const MentorScheduleMatrix({
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

  static String getDayName(int weekday, AppLocalizations l10n) {
    switch (weekday) {
      case 1:
        return l10n.monday;
      case 2:
        return l10n.tuesday;
      case 3:
        return l10n.wednesday;
      case 4:
        return l10n.thursday;
      case 5:
        return l10n.friday;
      case 6:
        return l10n.saturday;
      case 7:
        return l10n.sunday;
      default:
        return '';
    }
  }

  static String getDayShort(int weekday) {
    const shorts = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    if (weekday >= 1 && weekday <= 7) return shorts[weekday - 1];
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayWeekday = now.weekday;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_view_week_rounded,
              size: 17,
              color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
            ),
            const SizedBox(width: 6),
            Text(
              l10n.weeklyHoursTitle,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                mentor.localizedWorkingHours(isAmharic),
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: glass.subtitleText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E293B).withValues(alpha: 0.5)
                : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            children: [
              for (int dayIndex = 1; dayIndex <= 7; dayIndex++)
                MentorDayScheduleRow(
                  isDark: isDark,
                  weekday: dayIndex,
                  isToday: dayIndex == todayWeekday,
                  dayName: getDayName(dayIndex, l10n),
                  dayShort: getDayShort(dayIndex),
                  timeRange: mentor.formatTimeRange(dayIndex, isAmharic),
                  isActive: mentor.isDayActive(dayIndex),
                  todayLabel: l10n.todayLabel,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
