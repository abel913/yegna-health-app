import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../models/mentor.dart';
import 'mentor_launcher_helper.dart';

class MentorScheduleActionRow extends StatelessWidget {
  const MentorScheduleActionRow({
    required this.mentor,
    required this.isDark,
    required this.glass,
    required this.l10n,
    super.key,
  });

  final Mentor mentor;
  final bool isDark;
  final AppGlassTheme glass;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.connectDuringHours,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: glass.subtitleText,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => MentorLauncherHelper.launchCall(
                    context, mentor.phoneNumber, l10n),
                icon: const Icon(Icons.phone_rounded, size: 16),
                label: Text(
                  l10n.callMentorAction,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => MentorLauncherHelper.launchTelegram(
                    context, mentor.telegramHandle, l10n),
                icon: Icon(
                  Icons.send_rounded,
                  size: 15,
                  color:
                      isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                ),
                label: Text(
                  'Telegram',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? const Color(0xFF38BDF8)
                        : const Color(0xFF0284C7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isDark
                        ? const Color(0xFF38BDF8).withValues(alpha: 0.35)
                        : const Color(0xFFBAE6FD),
                    width: 1.1,
                  ),
                  backgroundColor: isDark
                      ? const Color(0xFF0C4A6E).withValues(alpha: 0.3)
                      : const Color(0xFFF0F9FF),
                  padding:
                      const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            if (mentor.hasWhatsapp) ...[
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => MentorLauncherHelper.launchWhatsApp(
                      context, mentor.whatsapp!, l10n),
                  icon: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 15,
                    color: Color(0xFF10B981),
                  ),
                  label: const Text(
                    'WhatsApp',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF10B981),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: const Color(0xFF10B981).withValues(alpha: 0.35),
                      width: 1.1,
                    ),
                    backgroundColor: isDark
                        ? const Color(0xFF064E3B).withValues(alpha: 0.25)
                        : const Color(0xFFECFDF5),
                    padding:
                        const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: glass.subtitleText,
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          child: Text(
            l10n.closeButton,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
