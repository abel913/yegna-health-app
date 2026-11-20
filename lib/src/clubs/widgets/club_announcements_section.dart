import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../theme/app_glass_theme.dart';
import '../club_models.dart';
import 'club_announcement_card.dart';

class ClubAnnouncementsSection extends StatelessWidget {
  const ClubAnnouncementsSection({
    required this.club,
    required this.isAmharic,
    required this.isDark,
    required this.glass,
    super.key,
  });

  final StudentClub club;
  final bool isAmharic;
  final bool isDark;
  final AppGlassTheme glass;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final announcements = club.announcements;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF6366F1).withValues(alpha: 0.16)
                    : const Color(0xFF6366F1).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.28),
                  width: 1.2,
                ),
              ),
              child: const Icon(
                Icons.campaign_rounded,
                size: 18,
                color: Color(0xFF6366F1),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isAmharic ? 'ማስታወቂያዎች' : 'Announcements & Updates',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                fontFamily: 'PlusJakartaSans',
                color: glass.titleText,
                letterSpacing: -0.2,
              ),
            ),
            const Spacer(),
            if (announcements.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.20 : 0.10),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  '${announcements.length}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF6366F1),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (announcements.isEmpty)
          _buildEmptyCard(context, l10n)
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: announcements.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (ctx, i) => ClubAnnouncementCard(
              announcement: announcements[i],
              isDark: isDark,
              glass: glass,
              l10n: l10n,
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyCard(BuildContext context, AppLocalizations? l10n) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E293B).withValues(alpha: 0.45)
                : Colors.white.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.70),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.mark_chat_unread_outlined,
                size: 22,
                color: glass.subtitleText.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n?.clubNoAnnouncements ?? 'No announcements posted yet.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: glass.titleText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n?.clubNoAnnouncementsDesc ??
                          'Check back for meeting schedules, room changes, and campus events.',
                      style: TextStyle(
                        fontSize: 12,
                        color: glass.subtitleText,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
