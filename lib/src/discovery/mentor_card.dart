import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import 'mentor_detail_sheet.dart';
import 'mentor_model.dart';

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFBAE6FD).withValues(alpha: 0.65),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0284C7),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
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
                              color: Colors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    mentor.avatarColor.withValues(alpha: 0.3),
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
                              color: mentor.isOnline
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFF59E0B),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              boxShadow: [
                                if (mentor.isOnline)
                                  BoxShadow(
                                    color: const Color(0xFF10B981)
                                        .withValues(alpha: 0.4),
                                    blurRadius: 5,
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
                                  style: const TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF08264A),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (mentor.isVerified) ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.verified_rounded,
                                  size: 16,
                                  color: Color(0xFF0284C7),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            mentor.localizedTitle(isAmharic),
                            style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0284C7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          Text(
                            mentor.localizedOrg(isAmharic),
                            style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 11.5,
                              color: Color(0xFF64748B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                    // Status Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: mentor.isOnline
                            ? const Color(0xFFECFDF5)
                            : const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            mentor.isOnline
                                ? Icons.check_circle_rounded
                                : Icons.schedule_rounded,
                            size: 12,
                            color: mentor.isOnline
                                ? const Color(0xFF059669)
                                : const Color(0xFFD97706),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            mentor.isOnline
                                ? l10n.availableNowBadge
                                : l10n.nextSlotBadge(
                                    mentor.localizedNextSlot(isAmharic)),
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: mentor.isOnline
                                  ? const Color(0xFF059669)
                                  : const Color(0xFFB45309),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Languages Pill
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '🗣️ ${mentor.languages.join(' • ')}',
                          style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF475569),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Contact Pill Row (Phone + Telegram)
                Row(
                  children: [
                    InkWell(
                      onTap: () =>
                          launchCall(context, mentor.phoneNumber, l10n),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFBAE6FD),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.phone_rounded,
                                size: 12, color: Color(0xFF0284C7)),
                            const SizedBox(width: 4),
                            Text(
                              mentor.displayPhoneNumber,
                              style: const TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () =>
                          launchTelegram(context, mentor.telegramHandle, l10n),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF86EFAC),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.send_rounded,
                                size: 11, color: Color(0xFF16A34A)),
                            const SizedBox(width: 4),
                            Text(
                              '@${mentor.telegramHandle}',
                              style: const TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF166534),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Topic Tags
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    for (final topic in mentor.topics)
                      _TopicBadge(topic: topic, l10n: l10n),
                  ],
                ),
                const SizedBox(height: 12),

                // Action Bar: View Profile, Call Mentor, Telegram Chat
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: OutlinedButton.icon(
                        onPressed: onTap ??
                            () => MentorDetailSheet.show(context, mentor),
                        icon: const Icon(Icons.person_outline_rounded,
                            size: 15, color: Color(0xFF0284C7)),
                        label: Text(
                          l10n.viewProfileBtn,
                          style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0284C7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFFBAE6FD), width: 1.2),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: const Color(0xFFF0F9FF),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 4,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            launchCall(context, mentor.phoneNumber, l10n),
                        icon: const Icon(Icons.phone_rounded,
                            size: 15, color: Colors.white),
                        label: Text(
                          l10n.callMentorAction,
                          style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0284C7),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filledTonal(
                      tooltip: l10n.telegramChatAction,
                      onPressed: () =>
                          launchTelegram(context, mentor.telegramHandle, l10n),
                      icon: const Icon(Icons.send_rounded,
                          size: 16, color: Color(0xFF0284C7)),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFE0F2FE),
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopicBadge extends StatelessWidget {
  const _TopicBadge({
    required this.topic,
    required this.l10n,
  });

  final MentorTopic topic;
  final AppLocalizations l10n;

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
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '#$label',
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
