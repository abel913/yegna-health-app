import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_glass_theme.dart';
import 'mentor_detail_sheet.dart';
import 'mentor_model.dart';
import 'mentor_schedule_sheet.dart';

class MentorCard extends StatelessWidget {
  const MentorCard({
    required this.mentor,
    this.onTap,
    super.key,
  });

  final Mentor mentor;
  final VoidCallback? onTap;

  static Future<void> launchCall(
      BuildContext context, String phone, AppLocalizations l10n) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
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

  static Future<void> launchTelegram(
      BuildContext context, String handle, AppLocalizations l10n) async {
    final cleanHandle = handle.replaceAll('@', '').trim();
    final uri = Uri.parse('https://t.me/$cleanHandle');
    final messenger = ScaffoldMessenger.maybeOf(context);
    try {
      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await Clipboard.setData(ClipboardData(text: '@$cleanHandle'));
        messenger?.showSnackBar(
          SnackBar(
            content: Text('${l10n.copyHandleSuccess} (@$cleanHandle)'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: '@$cleanHandle'));
      messenger?.showSnackBar(
        SnackBar(
          content: Text('${l10n.copyHandleSuccess} (@$cleanHandle)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  static Future<void> launchWhatsApp(
      BuildContext context, String rawInput, AppLocalizations l10n) async {
    var cleanDigits = rawInput.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanDigits.startsWith('09')) {
      cleanDigits = '251${cleanDigits.substring(1)}';
    } else if (cleanDigits.startsWith('9') && cleanDigits.length == 9) {
      cleanDigits = '251$cleanDigits';
    }

    final Uri uri;
    if (cleanDigits.length >= 7) {
      uri = Uri.parse('https://wa.me/$cleanDigits');
    } else {
      final text = Uri.encodeComponent(rawInput.trim());
      uri = Uri.parse('https://wa.me/?text=Hello%20$text');
    }

    final messenger = ScaffoldMessenger.maybeOf(context);
    try {
      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await Clipboard.setData(ClipboardData(text: rawInput));
        messenger?.showSnackBar(
          SnackBar(
            content: Text('${l10n.copyWhatsappSuccess} ($rawInput)'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: rawInput));
      messenger?.showSnackBar(
        SnackBar(
          content: Text('${l10n.copyWhatsappSuccess} ($rawInput)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  static Future<void> launchEmail(
      BuildContext context, String email, AppLocalizations l10n) async {
    final cleanEmail = email.trim();
    final uri = Uri.parse('mailto:$cleanEmail');
    final messenger = ScaffoldMessenger.maybeOf(context);
    try {
      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await Clipboard.setData(ClipboardData(text: cleanEmail));
        messenger?.showSnackBar(
          SnackBar(
            content: Text('${l10n.copyEmailSuccess} ($cleanEmail)'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: cleanEmail));
      messenger?.showSnackBar(
        SnackBar(
          content: Text('${l10n.copyEmailSuccess} ($cleanEmail)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    final glass = context.glassTheme;
    final isDark = glass.isDark;
    final isAvailableNow = mentor.isCurrentlyAvailableNow;

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
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF1E293B).withValues(alpha: 0.85),
                        const Color(0xFF0F172A).withValues(alpha: 0.70),
                        const Color(0xFF0284C7).withValues(alpha: 0.16),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.75),
                        Colors.white.withValues(alpha: 0.35),
                        const Color(0xFFBAE6FD).withValues(alpha: 0.18),
                      ],
                stops: const [0.0, 0.65, 1.0],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF38BDF8).withValues(alpha: 0.24)
                    : Colors.white.withValues(alpha: 0.90),
                width: 1.5,
              ),
              boxShadow: isDark
                  ? const [
                      BoxShadow(
                        color: Color(0x60000000),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Color(0x1F38BDF8),
                        blurRadius: 6,
                        offset: Offset(-1, -1),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.14),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        blurRadius: 6,
                        offset: const Offset(-2, -2),
                      ),
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(22),
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: onTap ?? () => MentorDetailSheet.show(context, mentor),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row: Avatar + Name/Org + Verified Badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      mentor.avatarColor.withValues(alpha: 0.8),
                                      mentor.avatarColor,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDark
                                        ? const Color(0xFF38BDF8)
                                            .withValues(alpha: 0.6)
                                        : Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: mentor.avatarColor
                                          .withValues(alpha: 0.35),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    mentor.initials,
                                    style: const TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 1,
                                right: 1,
                                child: Container(
                                  width: 13,
                                  height: 13,
                                  decoration: BoxDecoration(
                                    color: isAvailableNow
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFFF59E0B),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark
                                          ? const Color(0xFF0F172A)
                                          : Colors.white,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      if (isAvailableNow)
                                        BoxShadow(
                                          color: const Color(0xFF10B981)
                                              .withValues(alpha: 0.5),
                                          blurRadius: 6,
                                          spreadRadius: 1,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        mentor.localizedName(isAmharic),
                                        style: TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: glass.titleText,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (mentor.isVerified) ...[
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.verified_rounded,
                                        size: 16,
                                        color: isDark
                                            ? const Color(0xFF38BDF8)
                                            : const Color(0xFF0284C7),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  mentor.localizedTitle(isAmharic),
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? const Color(0xFF38BDF8)
                                        : const Color(0xFF0284C7),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  mentor.localizedOrg(isAmharic),
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 11.5,
                                    color: glass.subtitleText,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2.5),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF312E81)
                                            .withValues(alpha: 0.55)
                                        : const Color(0xFFEEF2FF)
                                            .withValues(alpha: 0.75),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isDark
                                          ? const Color(0xFF6366F1)
                                              .withValues(alpha: 0.35)
                                          : const Color(0xFFC7D2FE)
                                              .withValues(alpha: 0.85),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 11,
                                        color: isDark
                                            ? const Color(0xFFA5B4FC)
                                            : const Color(0xFF4F46E5),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        mentor.localizedCampus(isAmharic),
                                        style: TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: isDark
                                              ? const Color(0xFFC7D2FE)
                                              : const Color(0xFF4338CA),
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
                      const SizedBox(height: 12),

                      // Status & Languages Row
                      Row(
                        children: [
                          // Status Pill (Clickable -> Opens Schedule Modal)
                          InkWell(
                            onTap: () =>
                                MentorScheduleSheet.show(context, mentor),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3.5),
                              decoration: BoxDecoration(
                                color: isAvailableNow
                                    ? (isDark
                                        ? const Color(0xFF064E3B)
                                            .withValues(alpha: 0.55)
                                        : const Color(0xFFECFDF5)
                                            .withValues(alpha: 0.85))
                                    : (isDark
                                        ? const Color(0xFF78350F)
                                            .withValues(alpha: 0.55)
                                        : const Color(0xFFFFFBEB)
                                            .withValues(alpha: 0.85)),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isAvailableNow
                                      ? (isDark
                                          ? const Color(0xFF10B981)
                                              .withValues(alpha: 0.35)
                                          : const Color(0xFFA7F3D0)
                                              .withValues(alpha: 0.85))
                                      : (isDark
                                          ? const Color(0xFFF59E0B)
                                              .withValues(alpha: 0.35)
                                          : const Color(0xFFFDE68A)
                                              .withValues(alpha: 0.85)),
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isAvailableNow
                                        ? Icons.check_circle_rounded
                                        : Icons.schedule_rounded,
                                    size: 12,
                                    color: isAvailableNow
                                        ? (isDark
                                            ? const Color(0xFF34D399)
                                            : const Color(0xFF059669))
                                        : (isDark
                                            ? const Color(0xFFFBBF24)
                                            : const Color(0xFFD97706)),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isAvailableNow
                                        ? l10n.availableNowBadge
                                        : l10n.nextSlotBadge(
                                            mentor.getDynamicNextSlotText(isAmharic)),
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: isAvailableNow
                                          ? (isDark
                                              ? const Color(0xFF34D399)
                                              : const Color(0xFF059669))
                                          : (isDark
                                              ? const Color(0xFFFBBF24)
                                              : const Color(0xFFB45309)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Languages Pill
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3.5),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                        .withValues(alpha: 0.65)
                                    : const Color(0xFFF1F5F9)
                                        .withValues(alpha: 0.75),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF334155)
                                          .withValues(alpha: 0.5)
                                      : const Color(0xFFE2E8F0)
                                          .withValues(alpha: 0.8),
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                '🗣️ ${mentor.languages.join(' • ')}',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: glass.subtitleText,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Action Bar: Prominent View Profile + Quick Action Dock (Call, Telegram, WhatsApp)
                      Row(
                        children: [
                          // Primary Action: View Profile Icon Button (High Visibility)
                          Material(
                            color: isDark
                                ? const Color(0xFF0C4A6E).withValues(alpha: 0.75)
                                : const Color(0xFFE0F2FE).withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: onTap ??
                                  () => MentorDetailSheet.show(context, mentor),
                              child: Tooltip(
                                message: l10n.viewProfileBtn,
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDark
                                          ? const Color(0xFF38BDF8)
                                              .withValues(alpha: 0.45)
                                          : const Color(0xFF7DD3FC),
                                      width: 1.2,
                                    ),
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
                                  ),
                                  child: Icon(
                                    Icons.person_rounded,
                                    size: 20,
                                    color: isDark
                                        ? const Color(0xFF38BDF8)
                                        : const Color(0xFF0284C7),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Quick Action: Weekly Schedule Modal
                          Material(
                            color: isDark
                                ? const Color(0xFF1E293B).withValues(alpha: 0.85)
                                : const Color(0xFFF1F5F9).withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () =>
                                  MentorScheduleSheet.show(context, mentor),
                              child: Tooltip(
                                message: l10n.weeklyAvailabilityTitle,
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDark
                                          ? const Color(0xFF475569)
                                          : const Color(0xFFCBD5E1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.calendar_month_rounded,
                                    size: 18,
                                    color: isDark
                                        ? const Color(0xFF38BDF8)
                                        : const Color(0xFF0284C7),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Quick Action: Direct Phone Call
                          Material(
                            color: const Color(0xFF0284C7),
                            borderRadius: BorderRadius.circular(12),
                            elevation: 0,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () =>
                                  launchCall(context, mentor.phoneNumber, l10n),
                              child: Tooltip(
                                message: l10n.callMentorAction,
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF0284C7)
                                            .withValues(alpha: 0.35),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.phone_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Quick Action: Telegram Message
                          Material(
                            color: isDark
                                ? const Color(0xFF0C4A6E).withValues(alpha: 0.75)
                                : const Color(0xFFE0F2FE).withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => launchTelegram(
                                  context, mentor.telegramHandle, l10n),
                              child: Tooltip(
                                message: l10n.telegramChatAction,
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDark
                                          ? const Color(0xFF0284C7)
                                              .withValues(alpha: 0.4)
                                          : const Color(0xFFBAE6FD)
                                              .withValues(alpha: 0.8),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.send_rounded,
                                    size: 18,
                                    color: isDark
                                        ? const Color(0xFF38BDF8)
                                        : const Color(0xFF0284C7),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Quick Action: WhatsApp Chat (if available)
                          if (mentor.hasWhatsapp) ...[
                            const SizedBox(width: 8),
                            Material(
                              color: isDark
                                  ? const Color(0xFF064E3B)
                                      .withValues(alpha: 0.75)
                                  : const Color(0xFFDCFCE7)
                                      .withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => launchWhatsApp(
                                    context, mentor.whatsapp!, l10n),
                                child: Tooltip(
                                  message: l10n.whatsappChatAction,
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isDark
                                            ? const Color(0xFF059669)
                                                .withValues(alpha: 0.4)
                                            : const Color(0xFFA7F3D0)
                                                .withValues(alpha: 0.8),
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      size: 18,
                                      color: isDark
                                          ? const Color(0xFF34D399)
                                          : const Color(0xFF16A34A),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
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

