import 'package:flutter/material.dart';

import '../notifications/notification_controller.dart';
import '../theme/app_glass_theme.dart';
import 'club_controller.dart';
import 'club_models.dart';
import 'widgets/club_contact_launcher.dart';
import 'widgets/club_faculty_mentor_card.dart';
import 'widgets/club_roster_section.dart';
import 'widgets/club_rules_section.dart';
import 'widgets/club_schedule_venue_card.dart';
import 'widgets/club_sheet_actions.dart';
import 'widgets/club_sheet_header.dart';

class ClubDetailSheet extends StatefulWidget {
  const ClubDetailSheet({
    required this.club,
    required this.controller,
    required this.userId,
    this.userEmail,
    this.userName,
    this.notificationController,
    this.onRequireAuth,
    super.key,
  });

  final StudentClub club;
  final ClubController controller;
  final String userId;
  final String? userEmail;
  final String? userName;
  final InAppNotificationController? notificationController;
  final VoidCallback? onRequireAuth;

  static void show(
    BuildContext context, {
    required StudentClub club,
    required ClubController controller,
    required String userId,
    String? userEmail,
    String? userName,
    InAppNotificationController? notificationController,
    VoidCallback? onRequireAuth,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (ctx) => ClubDetailSheet(
        club: club,
        controller: controller,
        userId: userId,
        userEmail: userEmail,
        userName: userName,
        notificationController: notificationController,
        onRequireAuth: onRequireAuth,
      ),
    );
  }

  @override
  State<ClubDetailSheet> createState() => _ClubDetailSheetState();
}

class _ClubDetailSheetState extends State<ClubDetailSheet> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (_, __) {
        final isJoined = widget.controller.isJoined(widget.club.id);
        final liveClub = widget.controller.clubs.cast<StudentClub?>().firstWhere(
              (c) => c != null && c.id == widget.club.id,
              orElse: () => widget.club,
            ) ??
            widget.club;

        final title = isAmharic ? liveClub.nameAm : liveClub.nameEn;
        final schedule =
            isAmharic ? liveClub.meetingScheduleAm : liveClub.meetingScheduleEn;
        final location =
            isAmharic ? liveClub.meetingLocationAm : liveClub.meetingLocationEn;
        final mentorName =
            isAmharic ? liveClub.mentorNameAm : liveClub.mentorNameEn;

        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.90,
            ),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: glass.modalHandle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    children: [
                      ClubSheetHeader(
                        liveClub: liveClub,
                        isJoined: isJoined,
                        isAmharic: isAmharic,
                        isDark: isDark,
                        glass: glass,
                        title: title,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        isAmharic ? liveClub.descriptionAm : liveClub.descriptionEn,
                        style: TextStyle(fontSize: 14, height: 1.5, color: glass.subtitleText),
                      ),
                      const SizedBox(height: 20),
                      ClubScheduleVenueCard(
                        schedule: schedule,
                        location: location,
                        isAmharic: isAmharic,
                        isDark: isDark,
                        glass: glass,
                      ),
                      const SizedBox(height: 16),
                      ClubFacultyMentorCard(
                        mentorName: mentorName,
                        mentorContact: liveClub.mentorContact,
                        isAmharic: isAmharic,
                        isDark: isDark,
                        glass: glass,
                        onContactTap: () => ClubContactLauncher.launch(context, liveClub.mentorContact),
                      ),
                      const SizedBox(height: 20),
                      ClubRulesSection(
                        liveClub: liveClub,
                        isAmharic: isAmharic,
                        isDark: isDark,
                        glass: glass,
                      ),
                      const SizedBox(height: 20),
                      ClubRosterSection(
                        clubId: liveClub.id,
                        controller: widget.controller,
                        isAmharic: isAmharic,
                        isDark: isDark,
                        glass: glass,
                      ),
                      const SizedBox(height: 24),
                      ClubSheetActions(
                        liveClub: liveClub,
                        controller: widget.controller,
                        userId: widget.userId,
                        userEmail: widget.userEmail,
                        userName: widget.userName,
                        notificationController: widget.notificationController,
                        onRequireAuth: widget.onRequireAuth,
                        isJoined: isJoined,
                        isSubmitting: _isSubmitting,
                        isAmharic: isAmharic,
                        onSubmittingChanged: (val) => setState(() => _isSubmitting = val),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
