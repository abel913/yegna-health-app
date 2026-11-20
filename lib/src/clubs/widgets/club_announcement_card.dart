import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../theme/app_glass_theme.dart';
import '../club_models.dart';

class ClubAnnouncementCard extends StatelessWidget {
  const ClubAnnouncementCard({
    required this.announcement,
    required this.isDark,
    required this.glass,
    required this.l10n,
    super.key,
  });

  final ClubAnnouncement announcement;
  final bool isDark;
  final AppGlassTheme glass;
  final AppLocalizations? l10n;

  @override
  Widget build(BuildContext context) {
    final ann = announcement;
    final isPinned = ann.isPinned;
    final isUrgent = ann.isUrgent;

    final borderColor = isUrgent
        ? const Color(0xFFF43F5E).withValues(alpha: 0.45)
        : isPinned
            ? const Color(0xFFF59E0B).withValues(alpha: 0.45)
            : isDark
                ? const Color(0xFF38BDF8).withValues(alpha: 0.16)
                : Colors.white.withValues(alpha: 0.90);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isUrgent
                ? const Color(0xFFF43F5E).withValues(alpha: isDark ? 0.08 : 0.04)
                : isPinned
                    ? const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.08 : 0.05)
                    : isDark
                        ? const Color(0xFF131D36).withValues(alpha: 0.75)
                        : Colors.white.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 1.3),
            boxShadow: [
              BoxShadow(
                color: isUrgent
                    ? const Color(0x1AF43F5E)
                    : isPinned
                        ? const Color(0x1AF59E0B)
                        : Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (isPinned) ...[
                    _buildPill(
                      label: l10n?.clubPinnedBadge ?? 'Pinned',
                      icon: Icons.push_pin_rounded,
                      color: const Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 6),
                  ],
                  if (isUrgent) ...[
                    _buildPill(
                      label: l10n?.clubUrgentBadge ?? 'Urgent',
                      icon: Icons.priority_high_rounded,
                      color: const Color(0xFFF43F5E),
                    ),
                    const SizedBox(width: 6),
                  ] else if (ann.isVenueChange) ...[
                    _buildPill(
                      label: l10n?.clubVenueChangeBadge ?? 'Venue Change',
                      icon: Icons.pin_drop_rounded,
                      color: const Color(0xFF0284C7),
                    ),
                    const SizedBox(width: 6),
                  ] else if (ann.isEvent) ...[
                    _buildPill(
                      label: l10n?.clubEventBadge ?? 'Event',
                      icon: Icons.event_available_rounded,
                      color: const Color(0xFF8B5CF6),
                    ),
                    const SizedBox(width: 6),
                  ],
                  const Spacer(),
                  Text(
                    ann.formattedDate(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: glass.subtitleText.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                ann.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'PlusJakartaSans',
                  color: glass.titleText,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                ann.content,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 13,
                    color: glass.accentColor.withValues(alpha: 0.85),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${l10n?.clubPostedBy ?? 'Posted by'}: ${ann.authorName}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: glass.subtitleText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPill({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3.5),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
