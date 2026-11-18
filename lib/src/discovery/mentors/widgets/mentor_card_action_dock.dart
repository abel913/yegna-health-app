import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../models/mentor.dart';
import 'mentor_detail_sheet.dart';
import 'mentor_dock_button.dart';
import 'mentor_launcher_helper.dart';
import 'mentor_schedule_sheet.dart';

class MentorCardActionDock extends StatelessWidget {
  const MentorCardActionDock({
    required this.mentor,
    required this.isDark,
    required this.l10n,
    this.onTap,
    super.key,
  });

  final Mentor mentor;
  final bool isDark;
  final AppLocalizations l10n;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Primary Action: View Profile Icon Button
        MentorDockButton(
          bgColor: isDark
              ? const Color(0xFF0C4A6E).withValues(alpha: 0.75)
              : const Color(0xFFE0F2FE).withValues(alpha: 0.95),
          borderColor: isDark
              ? const Color(0xFF38BDF8).withValues(alpha: 0.45)
              : const Color(0xFF7DD3FC),
          tooltip: l10n.viewProfileBtn,
          onTap: onTap ?? () => MentorDetailSheet.show(context, mentor),
          boxShadow: [
            BoxShadow(
              color: (isDark
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFF0284C7))
                  .withValues(alpha: 0.12),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          icon: Icon(
            Icons.person_rounded,
            size: 20,
            color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 8),

        // Quick Action: Weekly Schedule Modal
        MentorDockButton(
          bgColor: isDark
              ? const Color(0xFF1E293B).withValues(alpha: 0.85)
              : const Color(0xFFF1F5F9).withValues(alpha: 0.95),
          borderColor: isDark
              ? const Color(0xFF475569)
              : const Color(0xFFCBD5E1),
          tooltip: l10n.weeklyAvailabilityTitle,
          onTap: () => MentorScheduleSheet.show(context, mentor),
          icon: Icon(
            Icons.calendar_month_rounded,
            size: 18,
            color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 8),

        // Quick Action: Direct Phone Call
        MentorDockButton(
          bgColor: const Color(0xFF0284C7),
          tooltip: l10n.callMentorAction,
          onTap: () =>
              MentorLauncherHelper.launchCall(context, mentor.phoneNumber, l10n),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0284C7).withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          icon: const Icon(
            Icons.phone_rounded,
            size: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),

        // Quick Action: Telegram Message
        MentorDockButton(
          bgColor: isDark
              ? const Color(0xFF0C4A6E).withValues(alpha: 0.75)
              : const Color(0xFFE0F2FE).withValues(alpha: 0.85),
          borderColor: isDark
              ? const Color(0xFF0284C7).withValues(alpha: 0.4)
              : const Color(0xFFBAE6FD).withValues(alpha: 0.8),
          tooltip: l10n.telegramChatAction,
          onTap: () => MentorLauncherHelper.launchTelegram(
              context, mentor.telegramHandle, l10n),
          icon: Icon(
            Icons.send_rounded,
            size: 18,
            color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
          ),
        ),

        // Quick Action: WhatsApp Chat (if available)
        if (mentor.hasWhatsapp) ...[
          const SizedBox(width: 8),
          MentorDockButton(
            bgColor: isDark
                ? const Color(0xFF064E3B).withValues(alpha: 0.75)
                : const Color(0xFFDCFCE7).withValues(alpha: 0.85),
            borderColor: isDark
                ? const Color(0xFF059669).withValues(alpha: 0.4)
                : const Color(0xFFA7F3D0).withValues(alpha: 0.8),
            tooltip: l10n.whatsappChatAction,
            onTap: () => MentorLauncherHelper.launchWhatsApp(
                context, mentor.whatsapp!, l10n),
            icon: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 18,
              color:
                  isDark ? const Color(0xFF34D399) : const Color(0xFF16A34A),
            ),
          ),
        ],
      ],
    );
  }
}
