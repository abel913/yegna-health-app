import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_glass_theme.dart';
import 'mentor_card.dart';
import 'mentor_model.dart';
import 'mentor_schedule_sheet.dart';

class MentorDetailSheet extends StatelessWidget {
  const MentorDetailSheet({
    required this.mentor,
    super.key,
  });

  final Mentor mentor;

  static void show(BuildContext context, Mentor mentor) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MentorDetailSheet(mentor: mentor),
    );
  }

  static String _formatDisplayName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return trimmed;
    return trimmed.split(RegExp(r'\s+')).map((part) {
      if (part.isEmpty) return part;
      if (part == part.toLowerCase()) {
        return part[0].toUpperCase() + part.substring(1);
      }
      return part;
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    // Brand Colors: Blue, White, and Black/Deep Navy
    final sheetBg = isDark
        ? const Color(0xFF0B132B).withValues(alpha: 0.90)
        : const Color(0xFFF8FAFC).withValues(alpha: 0.90);
    final cardBg = isDark
        ? const Color(0xFF131D36).withValues(alpha: 0.82)
        : Colors.white.withValues(alpha: 0.85);
    final cardBorder = isDark
        ? const Color(0xFF38BDF8).withValues(alpha: 0.22)
        : const Color(0xFFDCEAF5);
    final brandBlue = isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);
    final brandNavy = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF08264A);
    final slateText = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final bodyText = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            decoration: BoxDecoration(
              color: sheetBg,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.35)
                      : Colors.white.withValues(alpha: 0.95),
                  width: 1.5,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.6)
                      : const Color(0x330284C7),
                  blurRadius: 28,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                children: [
                  // Hero Profile Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  mentor.avatarColor.withValues(alpha: 0.85),
                                  mentor.avatarColor,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark ? const Color(0xFF38BDF8) : Colors.white,
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: mentor.avatarColor.withValues(alpha: 0.35),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                mentor.initials,
                                style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: mentor.isCurrentlyAvailableNow
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFF59E0B),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? const Color(0xFF0B132B) : Colors.white,
                                  width: 2.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _formatDisplayName(mentor.localizedName(isAmharic)),
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 21,
                                      fontWeight: FontWeight.w800,
                                      color: brandNavy,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ),
                                if (mentor.isVerified)
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF0284C7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      size: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              mentor.localizedTitle(isAmharic),
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: brandBlue,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              mentor.localizedOrg(isAmharic),
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 12,
                                color: slateText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 3.5),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFF0F9FF),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF334155)
                                      : const Color(0xFFBAE6FD),
                                  width: 0.9,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.location_on_rounded,
                                      size: 12, color: brandBlue),
                                  const SizedBox(width: 4),
                                  Text(
                                    mentor.localizedCampus(isAmharic),
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? const Color(0xFF38BDF8)
                                          : const Color(0xFF0369A1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Metrics Bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: cardBorder),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.3)
                              : const Color(0x080284C7),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _MetricItem(
                          label: isAmharic ? 'ልምድ' : 'Experience',
                          value:
                              '${mentor.experienceYears} ${isAmharic ? 'ዓመት' : 'Years'}',
                          icon: Icons.workspace_premium_outlined,
                          isDark: isDark,
                        ),
                        Container(
                          width: 1,
                          height: 32,
                          color: cardBorder,
                        ),
                        _MetricItem(
                          label: l10n.sessionsCountLabel,
                          value: '${mentor.sessionsCount}+',
                          icon: Icons.forum_outlined,
                          isDark: isDark,
                        ),
                        Container(
                          width: 1,
                          height: 32,
                          color: cardBorder,
                        ),
                        _MetricItem(
                          label: isAmharic ? 'ሁኔታ' : 'Status',
                          value: mentor.isCurrentlyAvailableNow
                              ? l10n.availableNowBadge
                              : mentor.getDynamicNextSlotText(isAmharic),
                          icon: Icons.schedule_rounded,
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Direct Contacts & Communication Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFBAE6FD),
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
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.connect_without_contact_rounded,
                                color: brandBlue,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.directContactsHeading,
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: brandNavy,
                                    ),
                                  ),
                                  Text(
                                    l10n.workingHoursLabel(mentor
                                        .localizedWorkingHours(isAmharic)),
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 11.5,
                                      color: slateText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Weekly Schedule Popup Action Pill
                        InkWell(
                          onTap: () =>
                              MentorScheduleSheet.show(context, mentor),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8.5),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF38BDF8)
                                        .withValues(alpha: 0.35)
                                    : const Color(0xFFBFDBFE),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 16,
                                  color: isDark
                                      ? const Color(0xFF38BDF8)
                                      : const Color(0xFF0284C7),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    l10n.weeklyAvailabilityTitle,
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? const Color(0xFF38BDF8)
                                          : const Color(0xFF0284C7),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 18,
                                  color: isDark
                                      ? const Color(0xFF38BDF8)
                                      : const Color(0xFF0284C7),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Channel 1: Telegram Direct
                        _ContactChannelRow(
                          icon: Icons.send_rounded,
                          iconBgColor: const Color(0xFF229ED9),
                          title: l10n.telegramChatAction,
                          subtitle: '@${mentor.cleanTelegramHandle}',
                          subtitleColor: brandBlue,
                          copyTooltip: l10n.copyHandleSuccess,
                          copyContent: '@${mentor.cleanTelegramHandle}',
                          actionLabel: l10n.telegramChatAction,
                          actionBgColor: const Color(0xFF0284C7),
                          onAction: () => MentorCard.launchTelegram(
                              context, mentor.telegramHandle, l10n),
                          isDark: isDark,
                        ),
                        const SizedBox(height: 10),

                        // Channel 2: WhatsApp (if configured)
                        if (mentor.hasWhatsapp) ...[
                          _ContactChannelRow(
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
                            onAction: () => MentorCard.launchWhatsApp(
                                context, mentor.whatsapp!, l10n),
                            isDark: isDark,
                          ),
                          const SizedBox(height: 10),
                        ],

                        // Channel 3: Voice Call & SMS
                        _VoiceContactChannelRow(
                          mentor: mentor,
                          l10n: l10n,
                          isAmharic: isAmharic,
                          isDark: isDark,
                          onSms: () => _launchSms(
                              context, mentor.phoneNumber, l10n),
                        ),
                        const SizedBox(height: 10),

                        // Channel 4: Email Consultation (if configured)
                        if (mentor.hasEmail) ...[
                          _ContactChannelRow(
                            icon: Icons.mail_outline_rounded,
                            iconBgColor: const Color(0xFF0F172A),
                            title: l10n.emailConsultationHeading,
                            subtitle: mentor.email!,
                            subtitleColor: slateText,
                            copyTooltip: l10n.copyEmailSuccess,
                            copyContent: mentor.email!,
                            actionLabel: l10n.sendEmailAction,
                            actionBgColor: const Color(0xFF08264A),
                            onAction: () => MentorCard.launchEmail(
                                context, mentor.email!, l10n),
                            isDark: isDark,
                          ),
                          const SizedBox(height: 10),
                        ],

                        // Confidentiality Guarantee Footer
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.lock_outline_rounded,
                                  size: 13, color: brandBlue),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  isAmharic
                                      ? 'ውይይትዎ 100% ሚስጥራዊ እና በወጣቶች ደህንነት መመሪያ የተጠበቀ ነው።'
                                      : 'All communications are 100% private & youth-safeguarded.',
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 11,
                                    color: slateText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Bio / About Counselor
                  _DetailCard(
                    title: isAmharic ? 'ስለ አማካሪው' : 'About Counselor',
                    icon: Icons.badge_outlined,
                    isDark: isDark,
                    child: Text(
                      mentor.localizedBio(isAmharic),
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 13.5,
                        color: bodyText,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Focus Areas & Topics
                  _DetailCard(
                    title: l10n.specialtiesLabel,
                    icon: Icons.stars_rounded,
                    isDark: isDark,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final topic in mentor.topics)
                          _TopicTag(topic: topic, l10n: l10n, isDark: isDark),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Languages Spoken
                  _DetailCard(
                    title: l10n.languagesSpokenLabel,
                    icon: Icons.translate_rounded,
                    isDark: isDark,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        for (final lang in mentor.languages)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              lang,
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? const Color(0xFFF8FAFC)
                                    : const Color(0xFF334155),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);
  }

  static Future<void> _launchSms(
      BuildContext context, String phone, AppLocalizations l10n) async {
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
}

/// A streamlined, single-line contact channel row eliminating clutter
class _ContactChannelRow extends StatelessWidget {
  const _ContactChannelRow({
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.subtitleColor,
    required this.copyTooltip,
    required this.copyContent,
    required this.actionLabel,
    required this.actionBgColor,
    required this.onAction,
    required this.isDark,
  });

  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final Color subtitleColor;
  final String copyTooltip;
  final String copyContent;
  final String actionLabel;
  final Color actionBgColor;
  final VoidCallback onAction;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final rowBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final rowBorder = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final titleColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF08264A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: rowBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: rowBorder, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: subtitleColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: copyTooltip,
              icon: Icon(
                Icons.copy_rounded,
                size: 16,
                color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: copyContent));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$copyTooltip ($copyContent)'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 4),
          ElevatedButton(
            onPressed: onAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: actionBgColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: const Size(0, 34),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Voice call & SMS channel with ample room preventing line wrapping
class _VoiceContactChannelRow extends StatelessWidget {
  const _VoiceContactChannelRow({
    required this.mentor,
    required this.l10n,
    required this.isAmharic,
    required this.isDark,
    required this.onSms,
  });

  final Mentor mentor;
  final AppLocalizations l10n;
  final bool isAmharic;
  final bool isDark;
  final VoidCallback onSms;

  @override
  Widget build(BuildContext context) {
    final rowBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final rowBorder = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final titleColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF08264A);
    final brandBlue = isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: rowBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: rowBorder, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.phone_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isAmharic ? 'የስልክ ጥሪ' : 'Voice Call',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  mentor.displayPhoneNumber,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: brandBlue,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 30,
            height: 32,
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: l10n.copyPhoneSuccess,
              icon: Icon(Icons.copy_rounded, size: 16, color: brandBlue),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: mentor.phoneNumber));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${l10n.copyPhoneSuccess} (${mentor.phoneNumber})'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: 30,
            height: 32,
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: l10n.sendSmsAction,
              icon: Icon(Icons.sms_rounded, size: 16, color: brandBlue),
              onPressed: onSms,
            ),
          ),
          const SizedBox(width: 4),
          ElevatedButton(
            onPressed: () =>
                MentorCard.launchCall(context, mentor.phoneNumber, l10n),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: const Size(0, 34),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(
              l10n.callMentorAction,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Icon(
            icon,
            size: 19,
            color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF08264A),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 11,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ],
      );
}

class _TopicTag extends StatelessWidget {
  const _TopicTag({
    required this.topic,
    required this.l10n,
    required this.isDark,
  });

  final MentorTopic topic;
  final AppLocalizations l10n;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;

    switch (topic) {
      case MentorTopic.mentalHealth:
        label = l10n.mentalHealthFilter;
        color = const Color(0xFF2563EB);
        break;
      case MentorTopic.srhGuidance:
        label = l10n.srhVctFilter;
        color = const Color(0xFF0D9488);
        break;
      case MentorTopic.puberty:
        label = l10n.pubertyFilter;
        color = const Color(0xFF7C3AED);
        break;
      case MentorTopic.substanceAbuse:
        label = l10n.substanceFilter;
        color = const Color(0xFFD97706);
        break;
      case MentorTopic.all:
        label = l10n.allMentors;
        color = const Color(0xFF0284C7);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? color.withValues(alpha: 0.2) : color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.4 : 0.25),
        ),
      ),
      child: Text(
        '#$label',
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isDark ? color.withValues(alpha: 0.9) : color,
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.title,
    required this.icon,
    required this.isDark,
    required this.child,
  });

  final String title;
  final IconData icon;
  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF131D36) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : const Color(0x080284C7),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF08264A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      );
}
