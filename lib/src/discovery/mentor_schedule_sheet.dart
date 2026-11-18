import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_glass_theme.dart';
import 'mentor_card.dart';
import 'mentor_model.dart';

class MentorScheduleSheet extends StatelessWidget {
  const MentorScheduleSheet({
    required this.mentor,
    super.key,
  });

  final Mentor mentor;

  static Future<void> show(BuildContext context, Mentor mentor) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => MentorScheduleSheet(mentor: mentor),
    );
  }

  String _getDayName(int weekday, AppLocalizations l10n) {
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

  String _getDayShort(int weekday) {
    const shorts = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    if (weekday >= 1 && weekday <= 7) return shorts[weekday - 1];
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glass = AppGlassTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    final now = DateTime.now();
    final todayWeekday = now.weekday; // 1 = Monday, 7 = Sunday
    final isCurrentlyOnline = mentor.isCurrentlyAvailableNow;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.6 : 0.18),
            blurRadius: 30,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Grab Handle
              Center(
                child: Container(
                  width: 44,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Header: Mentor Name & Campus + Close Button
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          mentor.avatarColor.withValues(alpha: 0.85),
                          mentor.avatarColor,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        mentor.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mentor.localizedName(isAmharic),
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${mentor.localizedCampus(isAmharic)} • ${mentor.localizedTitle(isAmharic)}',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 11.5,
                            color: glass.subtitleText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: glass.subtitleText, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Live Real-Time Availability Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: isCurrentlyOnline
                      ? (isDark
                          ? const Color(0xFF064E3B).withValues(alpha: 0.45)
                          : const Color(0xFFECFDF5))
                      : (isDark
                          ? const Color(0xFF78350F).withValues(alpha: 0.4)
                          : const Color(0xFFFFFBEB)),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isCurrentlyOnline
                        ? (isDark ? const Color(0xFF10B981).withValues(alpha: 0.35) : const Color(0xFFA7F3D0))
                        : (isDark ? const Color(0xFFF59E0B).withValues(alpha: 0.35) : const Color(0xFFFDE68A)),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCurrentlyOnline ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                        boxShadow: [
                          BoxShadow(
                            color: (isCurrentlyOnline ? const Color(0xFF10B981) : const Color(0xFFF59E0B))
                                .withValues(alpha: 0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        mentor.getCurrentStatusText(isAmharic),
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: isCurrentlyOnline
                              ? (isDark ? const Color(0xFF34D399) : const Color(0xFF065F46))
                              : (isDark ? const Color(0xFFFBBF24) : const Color(0xFF92400E)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Weekly Availability Hours Header
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

              // 7-Day Weekly Schedule Matrix (Monday to Sunday)
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  children: [
                    for (int dayIndex = 1; dayIndex <= 7; dayIndex++)
                      _buildDayScheduleRow(
                        context: context,
                        isDark: isDark,
                        weekday: dayIndex,
                        isToday: dayIndex == todayWeekday,
                        dayName: _getDayName(dayIndex, l10n),
                        dayShort: _getDayShort(dayIndex),
                        timeRange: mentor.formatTimeRange(dayIndex, isAmharic),
                        isActive: mentor.isDayActive(dayIndex),
                        todayLabel: l10n.todayLabel,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Direct Connect Channels Section
              Text(
                l10n.connectDuringHours,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: glass.subtitleText,
                ),
              ),
              const SizedBox(height: 10),

              // Quick Action Buttons Row: Call, Telegram, WhatsApp
              Row(
                children: [
                  // Call Action Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => MentorCard.launchCall(context, mentor.phoneNumber, l10n),
                      icon: const Icon(Icons.phone_rounded, size: 16),
                      label: Text(
                        l10n.callMentorAction,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Telegram Action Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => MentorCard.launchTelegram(context, mentor.telegramHandle, l10n),
                      icon: Icon(
                        Icons.send_rounded,
                        size: 15,
                        color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                      ),
                      label: Text(
                        'Telegram',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDark
                              ? const Color(0xFF38BDF8).withValues(alpha: 0.35)
                              : const Color(0xFFBAE6FD),
                          width: 1.1,
                        ),
                        backgroundColor: isDark
                            ? const Color(0xFF0C4A6E).withValues(alpha: 0.3)
                            : const Color(0xFFF0F9FF),
                        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),

                  // WhatsApp Action Button (if mentor has WhatsApp)
                  if (mentor.hasWhatsapp) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => MentorCard.launchWhatsApp(context, mentor.whatsapp!, l10n),
                        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 15, color: Color(0xFF10B981)),
                        label: const Text(
                          'WhatsApp',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF10B981),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: const Color(0xFF10B981).withValues(alpha: 0.35),
                            width: 1.1,
                          ),
                          backgroundColor: isDark
                              ? const Color(0xFF064E3B).withValues(alpha: 0.25)
                              : const Color(0xFFECFDF5),
                          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),

              // Close Button
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: glass.subtitleText,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(
                  l10n.closeButton,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayScheduleRow({
    required BuildContext context,
    required bool isDark,
    required int weekday,
    required bool isToday,
    required String dayName,
    required String dayShort,
    required String timeRange,
    required bool isActive,
    required String todayLabel,
  }) {
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
                color: isDark ? const Color(0xFF38BDF8).withValues(alpha: 0.5) : const Color(0xFF7DD3FC),
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
                  : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
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
                      : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF475569)),
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
                  : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
            ),
          ),

          // "TODAY" Badge if applicable
          if (isToday) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
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

          // Time Range Badge (e.g. 8:30 AM – 5:30 PM or Closed / Off)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
            decoration: BoxDecoration(
              color: isActive
                  ? (isToday
                      ? (isDark ? const Color(0xFF0284C7).withValues(alpha: 0.3) : Colors.white)
                      : (isDark ? const Color(0xFF334155).withValues(alpha: 0.6) : Colors.white))
                  : (isDark ? const Color(0xFF1E293B).withValues(alpha: 0.3) : const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isActive
                    ? (isToday
                        ? (isDark ? const Color(0xFF38BDF8) : const Color(0xFFBAE6FD))
                        : (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)))
                    : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
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
                        ? (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7))
                        : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B)))
                    : const Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
