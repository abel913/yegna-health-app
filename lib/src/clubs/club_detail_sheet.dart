import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../notifications/notification_controller.dart';
import '../notifications/notification_models.dart';
import '../theme/app_glass_theme.dart';
import 'club_card.dart';
import 'club_controller.dart';
import 'club_models.dart';

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
        final desc = isAmharic ? liveClub.descriptionAm : liveClub.descriptionEn;
        final schedule =
            isAmharic ? liveClub.meetingScheduleAm : liveClub.meetingScheduleEn;
        final location =
            isAmharic ? liveClub.meetingLocationAm : liveClub.meetingLocationEn;
        final mentorName =
            isAmharic ? liveClub.mentorNameAm : liveClub.mentorNameEn;
        final rules = isAmharic ? liveClub.rulesAm : liveClub.rulesEn;

        final catColor = liveClub.category.color;
        final catGradients = liveClub.category.gradientColors;

        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.90,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0F172A).withValues(alpha: 0.92)
                    : Colors.white.withValues(alpha: 0.92),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? const [
                          Color(0xFF1E293B),
                          Color(0xFF0F172A),
                        ]
                      : const [
                          Colors.white,
                          Color(0xFFF0F9FF),
                        ],
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.28)
                      : Colors.white.withValues(alpha: 0.95),
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x60000000),
                    blurRadius: 30,
                    offset: Offset(0, -10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Glass Drag handle
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 6),
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),

                  // Scrollable Body
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      children: [
                        // Category Pill & Capacity Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: catColor.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: catColor.withValues(alpha: 0.35),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(liveClub.category.icon,
                                      size: 15, color: catColor),
                                  const SizedBox(width: 6),
                                  Text(
                                    liveClub.category.label(isAmharic).toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: catColor,
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
                                color: isJoined
                                    ? const Color(0xFF10B981).withValues(alpha: 0.16)
                                    : (isDark
                                        ? const Color(0xFF1E293B)
                                        : const Color(0xFFE2E8F0)),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isJoined
                                      ? const Color(0xFF10B981).withValues(alpha: 0.4)
                                      : Colors.transparent,
                                ),
                              ),
                              child: Text(
                                isJoined
                                    ? (isAmharic ? '✓ ተቀላቅለዋል' : '✓ Active Member')
                                    : '${liveClub.memberCount} ${isAmharic ? "አባላት" : "members"}'
                                        '${liveClub.maxCapacity != null ? " / ${liveClub.maxCapacity}" : ""}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isJoined
                                      ? const Color(0xFF10B981)
                                      : glass.subtitleText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Header Hero Row: Icon Pod + Title
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: catGradients,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.25)
                                      : Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: catColor.withValues(alpha: 0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  liveClub.category.icon,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w900,
                                      color: glass.titleText,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${liveClub.category.label(isAmharic)} • ${isAmharic ? "ክበብ" : "Club"}',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: catColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Description
                        Text(
                          desc,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: glass.subtitleText,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Frosted Schedule & Venue Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF131D36).withValues(alpha: 0.70)
                                : Colors.white.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF38BDF8).withValues(alpha: 0.20)
                                  : Colors.white.withValues(alpha: 0.90),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0284C7).withValues(alpha: 0.08),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.schedule_rounded,
                                      color: Color(0xFF0284C7),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isAmharic ? 'የስብሰባ መርሃ-ግብር' : 'Meeting Schedule',
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
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: glass.titleText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Divider(
                                height: 1,
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFE2E8F0),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.location_on_rounded,
                                      color: Color(0xFF10B981),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
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
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
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
                        const SizedBox(height: 16),

                        // Assigned Faculty Mentor Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF131D36).withValues(alpha: 0.70)
                                : Colors.white.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF38BDF8).withValues(alpha: 0.20)
                                  : Colors.white.withValues(alpha: 0.90),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0284C7).withValues(alpha: 0.08),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Center(
                                  child: Text(
                                    mentorName.isNotEmpty
                                        ? mentorName[0].toUpperCase()
                                        : 'C',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isAmharic ? 'የክበቡ መሪ / አማካሪ' : 'Club Lead & Mentor',
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
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w800,
                                        color: glass.titleText,
                                      ),
                                    ),
                                    if (liveClub.mentorContact.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        liveClub.mentorContact,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF0284C7),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              if (liveClub.mentorContact.isNotEmpty)
                                IconButton.filledTonal(
                                  style: IconButton.styleFrom(
                                    backgroundColor: const Color(0xFF0284C7).withValues(alpha: 0.15),
                                    foregroundColor: const Color(0xFF0284C7),
                                  ),
                                  icon: Icon(
                                    liveClub.mentorContact.startsWith('@')
                                        ? Icons.near_me_rounded
                                        : Icons.phone_in_talk_rounded,
                                    size: 20,
                                  ),
                                  tooltip: 'Contact Mentor',
                                  onPressed: () => _contactMentor(context, liveClub.mentorContact),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Community Rules & Guidelines Section
                        Text(
                          isAmharic ? 'የክበቡ መመሪያዎች' : 'Community Guidelines',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: glass.titleText,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF131D36).withValues(alpha: 0.70)
                                : Colors.white.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF38BDF8).withValues(alpha: 0.20)
                                  : Colors.white.withValues(alpha: 0.90),
                              width: 1.2,
                            ),
                          ),
                          child: Column(
                            children: rules.map((rule) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 2),
                                      child: Icon(
                                        Icons.check_circle_rounded,
                                        size: 16,
                                        color: Color(0xFF10B981),
                                      ),
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
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Join / Leave Button & State
                        if (isJoined) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF10B981).withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF10B981),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isAmharic
                                      ? 'የክበቡ ንቁ አባል ነዎት ✓'
                                      : 'You Are an Active Member ✓',
                                  style: const TextStyle(
                                    color: Color(0xFF10B981),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: const Color(0xFFEF4444).withValues(alpha: 0.6),
                                  width: 1.4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: _isSubmitting
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFFEF4444),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.exit_to_app_rounded,
                                      color: Color(0xFFEF4444),
                                    ),
                              label: Text(
                                isAmharic ? 'ከክበቡ ውጣ' : 'Leave Club',
                                style: const TextStyle(
                                  color: Color(0xFFEF4444),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              onPressed: _isSubmitting
                                  ? null
                                  : () async {
                                      setState(() => _isSubmitting = true);
                                      final success = await widget.controller
                                          .leaveClub(liveClub.id, widget.userId);
                                      if (!mounted) return;
                                      setState(() => _isSubmitting = false);
                                      if (success && context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            content: Text(isAmharic
                                                ? 'ከክበቡ በተሳካ ሁኔታ ወጥተዋል'
                                                : 'You have left the club'),
                                          ),
                                        );
                                      }
                                    },
                            ),
                          ),
                        ] else ...[
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0284C7),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: _isSubmitting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.group_add_rounded),
                              label: Text(
                                _isSubmitting
                                    ? (isAmharic ? 'በመመዝገብ ላይ...' : 'Joining...')
                                    : (isAmharic ? 'ክበቡን ተቀላቀል' : 'Join This Club'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                              onPressed: _isSubmitting
                                  ? null
                                  : () async {
                                      final isGuest = widget.userId.isEmpty ||
                                          widget.userId == 'guest_explorer';
                                      if (isGuest) {
                                        await showClubAuthRequiredDialog(
                                          context,
                                          onSignIn: widget.onRequireAuth,
                                        );
                                        return;
                                      }
                                      setState(() => _isSubmitting = true);
                                      final success = await widget.controller.joinClub(
                                        liveClub.id,
                                        widget.userId,
                                        userEmail: widget.userEmail,
                                        userName: widget.userName,
                                      );

                                      if (!mounted) return;
                                      setState(() => _isSubmitting = false);
                                      if (!context.mounted) return;
                                      if (success) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: const Color(0xFF0F172A),
                                            content: Text(
                                              isAmharic
                                                  ? 'እንኳን ወደ $title በደህና መጡ!'
                                                  : 'Welcome to $title! You are now an active member.',
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        );
                                        widget.notificationController?.addNotification(
                                          InAppNotification(
                                            id: 'club_join_${DateTime.now().millisecondsSinceEpoch}',
                                            title: isAmharic
                                                ? 'ክበቡን ተቀላቅለዋል፡ ${liveClub.nameAm}'
                                                : 'Joined Club: ${liveClub.nameEn}',
                                            message: isAmharic
                                                ? 'አሁን ንቁ የክበቡ አባል ነዎት! ሳምንታዊ ስብሰባ፡ ${liveClub.meetingScheduleAm}'
                                                : 'You are now an active member! Weekly meeting: ${liveClub.meetingScheduleEn}',
                                            timestamp: DateTime.now(),
                                            type: NotificationType.learning,
                                            isRead: false,
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: const Color(0xFFEF4444),
                                            content: Text(
                                              isAmharic
                                                  ? 'ክበቡን መቀላቀል አልተቻለም (የአባላት ሙላት ደርሶ ሊሆን ይችላል)'
                                                  : 'Unable to join club (it may have reached maximum capacity).',
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
