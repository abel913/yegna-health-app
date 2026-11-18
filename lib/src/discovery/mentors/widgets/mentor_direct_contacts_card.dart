import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../l10n/app_localizations.dart';
import '../models/mentor.dart';
import 'mentor_confidentiality_badge.dart';
import 'mentor_contact_channel_row.dart';
import 'mentor_contacts_header.dart';
import 'mentor_launcher_helper.dart';
import 'mentor_schedule_action_pill.dart';

class MentorDirectContactsCard extends StatelessWidget {
  const MentorDirectContactsCard({
    required this.mentor,
    required this.l10n,
    required this.isAmharic,
    required this.isDark,
    required this.cardBg,
    required this.brandBlue,
    required this.brandNavy,
    required this.slateText,
    super.key,
  });

  final Mentor mentor;
  final AppLocalizations l10n;
  final bool isAmharic;
  final bool isDark;
  final Color cardBg;
  final Color brandBlue;
  final Color brandNavy;
  final Color slateText;

  static Future<void> _launchSms(
    BuildContext context,
    String phone,
    AppLocalizations l10n,
  ) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('sms:$cleanPhone');
    final messenger = ScaffoldMessenger.maybeOf(context);
    try {
      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await Clipboard.setData(ClipboardData(text: cleanPhone));
        messenger?.showSnackBar(
          SnackBar(
            content: Text('${l10n.copyPhoneSuccess} ($cleanPhone)'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: cleanPhone));
      messenger?.showSnackBar(
        SnackBar(
          content: Text('${l10n.copyPhoneSuccess} ($cleanPhone)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFBAE6FD),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : const Color(0x0C0284C7),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MentorContactsHeader(
            mentor: mentor,
            l10n: l10n,
            isAmharic: isAmharic,
            isDark: isDark,
            brandBlue: brandBlue,
            brandNavy: brandNavy,
            slateText: slateText,
          ),
          const SizedBox(height: 10),
          MentorScheduleActionPill(
            mentor: mentor,
            l10n: l10n,
            isDark: isDark,
          ),
          const SizedBox(height: 14),
          MentorContactChannelRow(
            icon: Icons.send_rounded,
            iconBgColor: const Color(0xFF229ED9),
            title: l10n.telegramChatAction,
            subtitle: '@${mentor.cleanTelegramHandle}',
            subtitleColor: brandBlue,
            copyTooltip: l10n.copyHandleSuccess,
            copyContent: '@${mentor.cleanTelegramHandle}',
            actionLabel: l10n.telegramChatAction,
            actionBgColor: const Color(0xFF0284C7),
            onAction: () => MentorLauncherHelper.launchTelegram(
                context, mentor.telegramHandle, l10n),
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          if (mentor.hasWhatsapp) ...[
            MentorContactChannelRow(
              icon: Icons.chat_bubble_rounded,
              iconBgColor: const Color(0xFF25D366),
              title: l10n.whatsappChatAction,
              subtitle: mentor.whatsapp!,
              subtitleColor: isDark
                  ? const Color(0xFFF8FAFC)
                  : const Color(0xFF08264A),
              copyTooltip: l10n.copyWhatsappSuccess,
              copyContent: mentor.whatsapp!,
              actionLabel: l10n.whatsappChatAction,
              actionBgColor: const Color(0xFF08264A),
              onAction: () => MentorLauncherHelper.launchWhatsApp(
                  context, mentor.whatsapp!, l10n),
              isDark: isDark,
            ),
            const SizedBox(height: 10),
          ],
          MentorVoiceContactChannelRow(
            mentor: mentor,
            l10n: l10n,
            isAmharic: isAmharic,
            isDark: isDark,
            onSms: () => _launchSms(context, mentor.phoneNumber, l10n),
          ),
          const SizedBox(height: 10),
          if (mentor.hasEmail) ...[
            MentorContactChannelRow(
              icon: Icons.mail_outline_rounded,
              iconBgColor: const Color(0xFF0F172A),
              title: l10n.emailConsultationHeading,
              subtitle: mentor.email!,
              subtitleColor: slateText,
              copyTooltip: l10n.copyEmailSuccess,
              copyContent: mentor.email!,
              actionLabel: l10n.sendEmailAction,
              actionBgColor: const Color(0xFF08264A),
              onAction: () => MentorLauncherHelper.launchEmail(
                  context, mentor.email!, l10n),
              isDark: isDark,
            ),
            const SizedBox(height: 10),
          ],
          MentorConfidentialityBadge(
            isAmharic: isAmharic,
            isDark: isDark,
            brandBlue: brandBlue,
            slateText: slateText,
          ),
        ],
      ),
    );
  }
}
