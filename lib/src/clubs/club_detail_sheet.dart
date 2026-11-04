import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../notifications/notification_controller.dart';
import '../notifications/notification_models.dart';
import '../theme/app_glass_theme.dart';
import 'club_controller.dart';
import 'club_models.dart';

class ClubDetailSheet extends StatelessWidget {
  const ClubDetailSheet({
    required this.club,
    required this.controller,
    required this.userId,
    this.userEmail,
    this.userName,
    this.notificationController,
    super.key,
  });

  final StudentClub club;
  final ClubController controller;
  final String userId;
  final String? userEmail;
  final String? userName;
  final InAppNotificationController? notificationController;

  static void show(
    BuildContext context, {
    required StudentClub club,
    required ClubController controller,
    required String userId,
    String? userEmail,
    String? userName,
    InAppNotificationController? notificationController,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ClubDetailSheet(
        club: club,
        controller: controller,
        userId: userId,
        userEmail: userEmail,
        userName: userName,
        notificationController: notificationController,
      ),
    );
  }

  Future<void> _contactMentor(BuildContext context, String contact) async {
    final clean = contact.trim();
    Uri? uri;
    if (clean.startsWith('+') ||
        clean.replaceAll(RegExp(r'\D'), '').length >= 9) {
      final normalized = clean.replaceAll(RegExp(r'[\s\-]'), '');
      uri = Uri.parse('tel:$normalized');
    } else if (clean.startsWith('@') || !clean.contains(' ')) {
      final handle = clean.replaceFirst('@', '');
      uri = Uri.parse('https://t.me/$handle');
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
    final isJoined = controller.isJoined(club.id);

    final title = isAmharic ? club.nameAm : club.nameEn;
    final desc = isAmharic ? club.descriptionAm : club.descriptionEn;
    final schedule =
        isAmharic ? club.meetingScheduleAm : club.meetingScheduleEn;
    final location =
        isAmharic ? club.meetingLocationAm : club.meetingLocationEn;
    final mentorName = isAmharic ? club.mentorNameAm : club.mentorNameEn;
    final rules = isAmharic ? club.rulesAm : club.rulesEn;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: glass.modalBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: glass.isDark ? glass.cardBorder : const Color(0xFFBAE6FD),
          width: 1.2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: glass.modalHandle,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                // Category Pill & Capacity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.stars_rounded,
                              size: 16, color: Color(0xFF38BDF8)),
                          const SizedBox(width: 6),
                          Text(
                            club.category.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF38BDF8),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: glass.isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${club.memberCount} ${isAmharic ? "አባላት" : "Members"}'
                        '${club.maxCapacity != null ? " / ${club.maxCapacity}" : ""}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: glass.subtitleText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: glass.titleText,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 14.5,
                    height: 1.5,
                    color: glass.subtitleText,
                  ),
                ),
                const SizedBox(height: 20),

                // Meeting Schedule & Venue Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: glass.isDark
                        ? const Color(0xFF0F172A).withValues(alpha: 0.7)
                        : const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: glass.isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFBAE6FD),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0284C7)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.schedule_rounded,
                                color: Color(0xFF38BDF8), size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isAmharic ? 'የስብሰባ ሰዓት' : 'Meeting Schedule',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: glass.subtitleText,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  schedule,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: glass.titleText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(height: 1, color: glass.divider),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.location_on_rounded,
                                color: Color(0xFF10B981), size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isAmharic ? 'የመሰብሰቢያ ቦታ' : 'Location / Venue',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: glass.subtitleText,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  location,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: glass.titleText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Assigned Mentor Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: glass.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: glass.cardBorder, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: const Color(0xFF0284C7),
                        child: Text(
                          mentorName.isNotEmpty ? mentorName[0] : 'M',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAmharic
                                  ? 'የክበቡ መሪ / አማካሪ'
                                  : 'Club Lead & Mentor',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: glass.subtitleText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              mentorName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: glass.titleText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.phone_in_talk_rounded, size: 20),
                        tooltip: 'Contact Mentor',
                        onPressed: () =>
                            _contactMentor(context, club.mentorContact),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Community Rules Section
                Text(
                  isAmharic ? 'የክበቡ መመሪያዎች' : 'Community Guidelines',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: glass.titleText,
                  ),
                ),
                const SizedBox(height: 10),
                ...rules.map((rule) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(Icons.check_circle_rounded,
                                size: 16, color: Color(0xFF10B981)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              rule,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: glass.subtitleText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 24),

                // Join / Leave Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: isJoined
                      ? OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: const Color(0xFFEF4444)
                                  .withValues(alpha: 0.6),
                              width: 1.4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.exit_to_app_rounded,
                              color: Color(0xFFEF4444)),
                          label: Text(
                            isAmharic ? 'ከክበቡ ውጣ' : 'Leave Club',
                            style: const TextStyle(
                              color: Color(0xFFEF4444),
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          onPressed: () async {
                            final success =
                                await controller.leaveClub(club.id, userId);
                            if (success && context.mounted) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isAmharic
                                      ? 'ከክበቡ በተሳካ ሁኔታ ወጥተዋል'
                                      : 'You have left the club'),
                                ),
                              );
                            }
                          },
                        )
                      : ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0284C7),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.group_add_rounded),
                          label: Text(
                            isAmharic ? 'ክበቡን ተቀላቀል' : 'Join This Club',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          onPressed: () async {
                            final success = await controller.joinClub(
                              club.id,
                              userId,
                              userEmail: userEmail,
                              userName: userName,
                            );
                            if (success && context.mounted) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color(0xFF0F172A),
                                  content: Text(
                                    isAmharic
                                        ? 'እንኳን ወደ $title በደህና መጡ!'
                                        : 'Welcome to $title!',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                              notificationController?.addNotification(
                                InAppNotification(
                                  id: 'club_join_${DateTime.now().millisecondsSinceEpoch}',
                                  title: isAmharic
                                      ? 'ክበቡን ተቀላቅለዋል፡ ${club.nameAm}'
                                      : 'Joined Club: ${club.nameEn}',
                                  message: isAmharic
                                      ? 'አሁን ንቁ የክበቡ አባል ነዎት! ሳምንታዊ ስብሰባ፡ ${club.meetingScheduleAm}'
                                      : 'You are now an active member! Weekly meeting: ${club.meetingScheduleEn}',
                                  timestamp: DateTime.now(),
                                  type: NotificationType.learning,
                                  isRead: false,
                                ),
                              );
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
