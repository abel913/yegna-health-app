import 'package:flutter/material.dart';

import '../../notifications/notification_controller.dart';
import '../club_controller.dart';
import '../club_detail_sheet.dart';
import '../club_models.dart';
import 'club_auth_required_dialog.dart';

class ClubCardActions extends StatelessWidget {
  const ClubCardActions({
    required this.club,
    required this.controller,
    required this.userId,
    this.userEmail,
    this.userName,
    this.notificationController,
    this.onRequireAuth,
    required this.isJoined,
    required this.isDark,
    required this.isAmharic,
    required this.title,
    required this.onContactTap,
    super.key,
  });

  final StudentClub club;
  final ClubController controller;
  final String userId;
  final String? userEmail;
  final String? userName;
  final InAppNotificationController? notificationController;
  final VoidCallback? onRequireAuth;
  final bool isJoined;
  final bool isDark;
  final bool isAmharic;
  final String title;
  final VoidCallback onContactTap;

  void _openDetails(BuildContext context) {
    ClubDetailSheet.show(
      context,
      club: club,
      controller: controller,
      userId: userId,
      userEmail: userEmail,
      userName: userName,
      notificationController: notificationController,
      onRequireAuth: onRequireAuth,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Details Action Button
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
              side: BorderSide(
                color: isDark
                    ? const Color(0xFF38BDF8).withValues(alpha: 0.35)
                    : const Color(0xFF0284C7).withValues(alpha: 0.30),
                width: 1.2,
              ),
              padding: const EdgeInsets.symmetric(vertical: 9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              visualDensity: VisualDensity.compact,
            ),
            icon: const Icon(Icons.info_outline_rounded, size: 16),
            label: Text(
              isAmharic ? 'ዝርዝር' : 'Details',
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
            ),
            onPressed: () => _openDetails(context),
          ),
        ),
        const SizedBox(width: 8),

        // Join / Joined Button
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: isJoined
                  ? const Color(0xFF10B981)
                  : const Color(0xFF0284C7),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              visualDensity: VisualDensity.compact,
            ),
            icon: Icon(
              isJoined ? Icons.check_rounded : Icons.add_rounded,
              size: 16,
            ),
            label: Text(
              isJoined
                  ? (isAmharic ? 'ተቀላቅለዋል' : 'Joined')
                  : (isAmharic ? 'ተቀላቀል' : 'Join'),
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
            ),
            onPressed: () async {
              final isGuest = userId.isEmpty || userId == 'guest_explorer';
              if (!isJoined) {
                if (isGuest) {
                  await showClubAuthRequiredDialog(
                    context,
                    onSignIn: onRequireAuth,
                  );
                  return;
                }
                final success = await controller.joinClub(
                  club.id,
                  userId,
                  userEmail: userEmail,
                  userName: userName,
                );
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        isAmharic
                            ? 'እንኳን ወደ $title በደህና መጡ! አባል ሆነዋል።'
                            : 'Welcome to $title! You are now an active member.',
                      ),
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  );
                }
              } else {
                _openDetails(context);
              }
            },
          ),
        ),

        // Quick Contact Action Pod
        if (club.mentorContact.isNotEmpty) ...[
          const SizedBox(width: 8),
          InkWell(
            onTap: onContactTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.35),
                  width: 1.2,
                ),
              ),
              child: Icon(
                club.mentorContact.startsWith('@')
                    ? Icons.near_me_rounded
                    : Icons.call_rounded,
                size: 17,
                color: const Color(0xFF0284C7),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
