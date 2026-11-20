import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_glass_theme.dart';
import '../notification_controller.dart';

/// Glassmorphic category filter chips for the notification center.
class NotificationCategoryFilterChips extends StatelessWidget {
  const NotificationCategoryFilterChips({
    required this.selectedFilter,
    required this.onSelectFilter,
    required this.unreadCount,
    required this.urgentCount,
    required this.isDark,
    required this.glass,
    super.key,
  });

  final NotificationFilter selectedFilter;
  final ValueChanged<NotificationFilter> onSelectFilter;
  final int unreadCount;
  final int urgentCount;
  final bool isDark;
  final AppGlassTheme glass;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final filters = [
      _FilterItem(
        filter: NotificationFilter.all,
        label: l10n.notificationFilterAll,
        icon: Icons.all_inclusive_rounded,
      ),
      _FilterItem(
        filter: NotificationFilter.unread,
        label: l10n.notificationFilterUnread,
        badgeCount: unreadCount,
        icon: Icons.mark_email_unread_rounded,
      ),
      _FilterItem(
        filter: NotificationFilter.urgent,
        label: l10n.notificationFilterUrgent,
        badgeCount: urgentCount,
        icon: Icons.local_fire_department_rounded,
        isUrgent: true,
      ),
      _FilterItem(
        filter: NotificationFilter.clubs,
        label: l10n.notificationFilterClubs,
        icon: Icons.campaign_rounded,
      ),
      _FilterItem(
        filter: NotificationFilter.tips,
        label: l10n.notificationFilterTips,
        icon: Icons.lightbulb_rounded,
      ),
      _FilterItem(
        filter: NotificationFilter.learning,
        label: l10n.notificationFilterLearning,
        icon: Icons.school_rounded,
      ),
    ];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final item = filters[i];
          final isSelected = selectedFilter == item.filter;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => onSelectFilter(item.filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (item.isUrgent
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF6366F1))
                      : (isDark
                          ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                          : Colors.white.withValues(alpha: 0.8)),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? (item.isUrgent
                            ? const Color(0xFFF87171)
                            : const Color(0xFF818CF8))
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : const Color(0xFFE2E8F0)),
                    width: isSelected ? 1.4 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: (item.isUrgent
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFF6366F1))
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      size: 14,
                      color: isSelected
                          ? Colors.white
                          : (item.isUrgent
                              ? const Color(0xFFEF4444)
                              : glass.subtitleText),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (item.isUrgent
                                ? const Color(0xFFEF4444)
                                : glass.titleText),
                      ),
                    ),
                    if (item.badgeCount != null && item.badgeCount! > 0) ...[
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.25)
                              : (item.isUrgent
                                  ? const Color(0xFFEF4444).withValues(alpha: 0.15)
                                  : const Color(0xFF6366F1).withValues(alpha: 0.12)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${item.badgeCount}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: isSelected
                                ? Colors.white
                                : (item.isUrgent
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFF6366F1)),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FilterItem {
  const _FilterItem({
    required this.filter,
    required this.label,
    required this.icon,
    this.badgeCount,
    this.isUrgent = false,
  });

  final NotificationFilter filter;
  final String label;
  final IconData icon;
  final int? badgeCount;
  final bool isUrgent;
}
