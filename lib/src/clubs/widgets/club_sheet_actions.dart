import 'package:flutter/material.dart';

import '../../notifications/notification_controller.dart';
import '../../notifications/notification_models.dart';
import '../club_controller.dart';
import '../club_models.dart';
import 'club_auth_required_dialog.dart';

class ClubSheetActions extends StatelessWidget {
  const ClubSheetActions({
    required this.liveClub,
    required this.controller,
    required this.userId,
    this.userEmail,
    this.userName,
    this.notificationController,
    this.onRequireAuth,
    required this.isJoined,
    required this.isSubmitting,
    required this.isAmharic,
    required this.onSubmittingChanged,
    super.key,
  });

  final StudentClub liveClub;
  final ClubController controller;
  final String userId;
  final String? userEmail;
  final String? userName;
  final InAppNotificationController? notificationController;
  final VoidCallback? onRequireAuth;
  final bool isJoined;
  final bool isSubmitting;
  final bool isAmharic;
  final ValueChanged<bool> onSubmittingChanged;

  @override
  Widget build(BuildContext context) {
    final title = isAmharic ? liveClub.nameAm : liveClub.nameEn;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isJoined
              ? const Color(0xFFEF4444)
              : (liveClub.isAtCapacity
                  ? const Color(0xFF64748B)
                  : const Color(0xFF0284C7)),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        onPressed: (isSubmitting || (!isJoined && liveClub.isAtCapacity))
            ? null
            : () async {
                final isGuest = userId.isEmpty || userId == 'guest_explorer';
                if (!isJoined && isGuest) {
                  Navigator.of(context).pop();
                  await showClubAuthRequiredDialog(
                    context,
                    onSignIn: onRequireAuth,
                  );
                  return;
                }

                onSubmittingChanged(true);
                if (isJoined) {
                  final ok = await controller.leaveClub(liveClub.id, userId);
                  onSubmittingChanged(false);
                  if (ok && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          isAmharic
                              ? 'ከ$title ክበብ ወጥተዋል።'
                              : 'You have left $title.',
                        ),
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                } else {
                  final ok = await controller.joinClub(
                    liveClub.id,
                    userId,
                    userEmail: userEmail,
                    userName: userName,
                  );
                  onSubmittingChanged(false);
                  if (ok && context.mounted) {
                    notificationController?.addNotification(
                      InAppNotification(
                        id: 'club_join_${liveClub.id}',
                        title: isAmharic
                            ? 'ወደ ${liveClub.nameAm} ተቀላቅለዋል!'
                            : 'Joined ${liveClub.nameEn}!',
                        message: isAmharic
                            ? 'እንኳን ደህና መጡ! ስብሰባዎች በ${liveClub.meetingLocationAm} ይካሄዳሉ።'
                            : 'Welcome! Meetings take place at ${liveClub.meetingLocationEn}.',
                        type: NotificationType.system,
                        timestamp: DateTime.now(),
                      ),
                    );

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
                    Navigator.of(context).pop();
                  }
                }
              },
        child: isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                isJoined
                    ? (isAmharic ? 'ከክበቡ ውጣ (Leave Club)' : 'Leave Club')
                    : (liveClub.isAtCapacity
                        ? (isAmharic ? 'ክበቡ ተሞልቷል' : 'Club Full')
                        : (isAmharic ? 'ክበቡን ተቀላቀል' : 'Join This Club')),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}
