import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../notifications/notification_controller.dart';
import '../theme/app_glass_theme.dart';
import 'club_controller.dart';
import 'club_detail_sheet.dart';
import 'club_models.dart';
import 'widgets/club_capacity_bar.dart';
import 'widgets/club_card_actions.dart';
import 'widgets/club_card_header.dart';
import 'widgets/club_schedule_venue_row.dart';

export 'widgets/club_auth_required_dialog.dart';

class ClubCard extends StatelessWidget {
  const ClubCard({
    required this.club,
    required this.controller,
    required this.userId,
    this.userEmail,
    this.userName,
    this.notificationController,
    this.onTap,
    this.onRequireAuth,
    super.key,
  });

  final StudentClub club;
  final ClubController controller;
  final String userId;
  final String? userEmail;
  final String? userName;
  final InAppNotificationController? notificationController;
  final VoidCallback? onTap;
  final VoidCallback? onRequireAuth;

  Future<void> _handleQuickContact(BuildContext context, String contact) async {
    final clean = contact.trim();
    Uri? uri;
    if (clean.startsWith('+') ||
        clean.replaceAll(RegExp(r'\D'), '').length >= 9) {
      uri = Uri.parse('tel:${clean.replaceAll(RegExp(r'[\s\-]'), '')}');
    } else if (clean.startsWith('@') || !clean.contains(' ')) {
      uri = Uri.parse('https://t.me/${clean.replaceFirst('@', '')}');
    }

    if (uri != null) {
      try {
        final launched =
            await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!launched && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Contact: $contact')),
          );
        }
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Contact: $contact')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    final glass = context.glassTheme;
    final isDark = glass.isDark;
    final isJoined = controller.isJoined(club.id);

    final title = isAmharic ? club.nameAm : club.nameEn;
    final desc = isAmharic ? club.descriptionAm : club.descriptionEn;
    final schedule = isAmharic ? club.meetingScheduleAm : club.meetingScheduleEn;
    final venue = isAmharic ? club.meetingLocationAm : club.meetingLocationEn;
    final mentorName = isAmharic ? club.mentorNameAm : club.mentorNameEn;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF131D36).withValues(alpha: 0.76)
                  : Colors.white.withValues(alpha: 0.50),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isJoined
                    ? const Color(0xFF10B981).withValues(alpha: 0.55)
                    : (isDark
                        ? const Color(0xFF38BDF8).withValues(alpha: 0.24)
                        : Colors.white.withValues(alpha: 0.90)),
                width: isJoined ? 1.6 : 1.4,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(22),
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: onTap ??
                    () => ClubDetailSheet.show(
                          context,
                          club: club,
                          controller: controller,
                          userId: userId,
                          userEmail: userEmail,
                          userName: userName,
                          notificationController: notificationController,
                          onRequireAuth: onRequireAuth,
                        ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClubCardHeader(
                        club: club,
                        title: title,
                        mentorName: mentorName,
                        isAmharic: isAmharic,
                        glass: glass,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, height: 1.4, color: glass.subtitleText),
                      ),
                      const SizedBox(height: 12),
                      ClubScheduleVenueRow(
                        schedule: schedule,
                        venue: venue,
                        isDark: isDark,
                        glass: glass,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '👥 ${club.memberCount} ${isAmharic ? "አባላት" : "members"}',
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: glass.subtitleText),
                          ),
                          ClubCapacityBar(club: club, isDark: isDark),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClubCardActions(
                        club: club,
                        controller: controller,
                        userId: userId,
                        userEmail: userEmail,
                        userName: userName,
                        notificationController: notificationController,
                        onRequireAuth: onRequireAuth,
                        isJoined: isJoined,
                        isDark: isDark,
                        isAmharic: isAmharic,
                        title: title,
                        onContactTap: () => _handleQuickContact(context, club.mentorContact),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
