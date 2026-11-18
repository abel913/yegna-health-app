import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../models/mentor.dart';

class MentorMetricsBar extends StatelessWidget {
  const MentorMetricsBar({
    required this.mentor,
    required this.isAmharic,
    required this.isDark,
    required this.cardBg,
    required this.cardBorder,
    required this.l10n,
    super.key,
  });

  final Mentor mentor;
  final bool isAmharic;
  final bool isDark;
  final Color cardBg;
  final Color cardBorder;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : const Color(0x080284C7),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MetricItem(
            label: isAmharic ? 'ልምድ' : 'Experience',
            value:
                '${mentor.experienceYears} ${isAmharic ? 'ዓመት' : 'Years'}',
            icon: Icons.workspace_premium_outlined,
            isDark: isDark,
          ),
          Container(width: 1, height: 32, color: cardBorder),
          _MetricItem(
            label: l10n.sessionsCountLabel,
            value: '${mentor.sessionsCount}+',
            icon: Icons.forum_outlined,
            isDark: isDark,
          ),
          Container(width: 1, height: 32, color: cardBorder),
          _MetricItem(
            label: isAmharic ? 'ሁኔታ' : 'Status',
            value: mentor.isCurrentlyAvailableNow
                ? l10n.availableNowBadge
                : mentor.getDynamicNextSlotText(isAmharic),
            icon: Icons.schedule_rounded,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Icon(
            icon,
            size: 19,
            color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF08264A),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 11,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ],
      );
}
