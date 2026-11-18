import 'package:flutter/material.dart';

class MentorDayScheduleRow extends StatelessWidget {
  const MentorDayScheduleRow({
    required this.isDark,
    required this.weekday,
    required this.isToday,
    required this.dayName,
    required this.dayShort,
    required this.timeRange,
    required this.isActive,
    required this.todayLabel,
    super.key,
  });

  final bool isDark;
  final int weekday;
  final bool isToday;
  final String dayName;
  final String dayShort;
  final String timeRange;
  final bool isActive;
  final String todayLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isToday
            ? (isDark
                ? const Color(0xFF0284C7).withValues(alpha: 0.16)
                : const Color(0xFFE0F2FE).withValues(alpha: 0.7))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isToday
            ? Border.all(
                color: isDark
                    ? const Color(0xFF38BDF8).withValues(alpha: 0.5)
                    : const Color(0xFF7DD3FC),
                width: 1.2,
              )
            : null,
      ),
      child: Row(
        children: [
          // Day Short Capsule (Mo, Tu, etc.)
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isToday
                  ? (isDark ? Colors.white : const Color(0xFF0F172A))
                  : (isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                dayShort,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: isToday
                      ? (isDark ? const Color(0xFF0F172A) : Colors.white)
                      : (isDark
                          ? const Color(0xFFE2E8F0)
                          : const Color(0xFF475569)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Day Full Name
          Text(
            dayName,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 12.5,
              fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
              color: isToday
                  ? (isDark ? Colors.white : const Color(0xFF0F172A))
                  : (isDark
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF334155)),
            ),
          ),

          // "TODAY" Badge if applicable
          if (isToday) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                todayLabel.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],

          const Spacer(),

          // Time Range Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
            decoration: BoxDecoration(
              color: isActive
                  ? (isToday
                      ? (isDark
                          ? const Color(0xFF0284C7).withValues(alpha: 0.3)
                          : Colors.white)
                      : (isDark
                          ? const Color(0xFF334155).withValues(alpha: 0.6)
                          : Colors.white))
                  : (isDark
                      ? const Color(0xFF1E293B).withValues(alpha: 0.3)
                      : const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isActive
                    ? (isToday
                        ? (isDark
                            ? const Color(0xFF38BDF8)
                            : const Color(0xFFBAE6FD))
                        : (isDark
                            ? const Color(0xFF475569)
                            : const Color(0xFFCBD5E1)))
                    : (isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0)),
                width: 0.8,
              ),
            ),
            child: Text(
              timeRange,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive
                    ? (isToday
                        ? (isDark
                            ? const Color(0xFF38BDF8)
                            : const Color(0xFF0284C7))
                        : (isDark
                            ? const Color(0xFFE2E8F0)
                            : const Color(0xFF1E293B)))
                    : const Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
