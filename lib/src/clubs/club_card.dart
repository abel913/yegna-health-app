import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../notifications/notification_controller.dart';
import '../theme/app_glass_theme.dart';
import 'club_controller.dart';
import 'club_detail_sheet.dart';
import 'club_models.dart';

class ClubCard extends StatelessWidget {
  const ClubCard({
    required this.club,
    required this.controller,
    required this.userId,
    this.userEmail,
    this.userName,
    this.notificationController,
    this.onTap,
    this.onRequireAuth,
    super.key,
  });

  final StudentClub club;
  final ClubController controller;
  final String userId;
  final String? userEmail;
  final String? userName;
  final InAppNotificationController? notificationController;
  final VoidCallback? onTap;
  final VoidCallback? onRequireAuth;

  Future<void> _handleQuickContact(BuildContext context, String contact) async {
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
    final isJoined = controller.isJoined(club.id);

    final title = isAmharic ? club.nameAm : club.nameEn;
    final desc = isAmharic ? club.descriptionAm : club.descriptionEn;
    final schedule = isAmharic ? club.meetingScheduleAm : club.meetingScheduleEn;
    final venue = isAmharic ? club.meetingLocationAm : club.meetingLocationEn;
    final mentorName = isAmharic ? club.mentorNameAm : club.mentorNameEn;

    final catColor = club.category.color;
    final catGradients = club.category.gradientColors;

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
                        catColor.withValues(alpha: 0.16),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.75),
                        Colors.white.withValues(alpha: 0.35),
                        catColor.withValues(alpha: 0.12),
                      ],
                stops: const [0.0, 0.65, 1.0],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isJoined
                    ? const Color(0xFF10B981).withValues(alpha: 0.55)
                    : (isDark
                        ? const Color(0xFF38BDF8).withValues(alpha: 0.24)
                        : Colors.white.withValues(alpha: 0.90)),
                width: isJoined ? 1.6 : 1.4,
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
                onTap: onTap ??
                    () => ClubDetailSheet.show(
                          context,
                          club: club,
                          controller: controller,
                          userId: userId,
                          userEmail: userEmail,
                          userName: userName,
                          notificationController: notificationController,
                          onRequireAuth: onRequireAuth,
                        ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Category Icon Pod + Title + Badges
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 50x50 Category Icon Pod with pulse dot
                          Stack(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: catGradients,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.25)
                                        : Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: catColor.withValues(alpha: 0.35),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    club.category.icon,
                                    size: 26,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -1,
                                top: -1,
                                child: Container(
                                  width: 13,
                                  height: 13,
                                  decoration: BoxDecoration(
                                    color: isJoined
                                        ? const Color(0xFF10B981)
                                        : (club.isActive
                                            ? const Color(0xFF38BDF8)
                                            : const Color(0xFF94A3B8)),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark
                                          ? const Color(0xFF0F172A)
                                          : Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),

                          // Title and Category Subtitle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        title,
                                        style: TextStyle(
                                          fontSize: 16.5,
                                          fontWeight: FontWeight.w800,
                                          color: glass.titleText,
                                          letterSpacing: -0.3,
                                          height: 1.25,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isJoined) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981)
                                              .withValues(alpha: 0.16),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: const Color(0xFF10B981)
                                                .withValues(alpha: 0.4),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.check_circle_rounded,
                                              size: 11,
                                              color: Color(0xFF10B981),
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              isAmharic
                                                  ? 'አባል ነዎት'
                                                  : 'Joined ✓',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFF10B981),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 5),

                                // Category Pill
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2.5),
                                      decoration: BoxDecoration(
                                        color: catColor.withValues(alpha: 0.14),
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            club.category.icon,
                                            size: 11,
                                            color: catColor,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            club.category.label(isAmharic),
                                            style: TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w800,
                                              color: catColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '• $mentorName',
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: glass.subtitleText,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Description Snippet
                      Text(
                        desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: glass.subtitleText,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Frosted Meeting Schedule & Venue Card
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 11, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0F172A).withValues(alpha: 0.70)
                              : const Color(0xFFF1F5F9).withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.schedule_rounded,
                              size: 14,
                              color: Color(0xFF0284C7),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                schedule,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: glass.titleText,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.location_on_rounded,
                              size: 14,
                              color: Color(0xFF10B981),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                venue,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: glass.subtitleText,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Capacity Indicator & Member Progress Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                '👥 ${club.memberCount} ${isAmharic ? "አባላት" : "members"}'
                                '${club.maxCapacity != null ? " / ${club.maxCapacity}" : ""}',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: glass.subtitleText,
                                ),
                              ),
                              if (club.isAtCapacity) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF4444)
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    isAmharic ? 'ተሞልቷል' : 'Full',
                                    style: const TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFFEF4444),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (club.maxCapacity != null &&
                              club.maxCapacity! > 0)
                            SizedBox(
                              width: 72,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: club.capacityUtilization,
                                  minHeight: 5,
                                  backgroundColor: isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFE2E8F0),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    club.isAtCapacity
                                        ? const Color(0xFFEF4444)
                                        : (club.isNearCapacity
                                            ? const Color(0xFFF59E0B)
                                            : const Color(0xFF10B981)),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Action Dock
                      Row(
                        children: [
                          // Details Action Button
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: isDark
                                    ? const Color(0xFF38BDF8)
                                    : const Color(0xFF0284C7),
                                side: BorderSide(
                                  color: isDark
                                      ? const Color(0xFF38BDF8)
                                          .withValues(alpha: 0.35)
                                      : const Color(0xFF0284C7)
                                          .withValues(alpha: 0.30),
                                  width: 1.2,
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                              icon: const Icon(
                                Icons.info_outline_rounded,
                                size: 16,
                              ),
                              label: Text(
                                isAmharic ? 'ዝርዝር' : 'Details',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              onPressed: () => ClubDetailSheet.show(
                                context,
                                club: club,
                                controller: controller,
                                userId: userId,
                                userEmail: userEmail,
                                userName: userName,
                                notificationController: notificationController,
                              ),
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                              icon: Icon(
                                isJoined
                                    ? Icons.check_rounded
                                    : Icons.add_rounded,
                                size: 16,
                              ),
                              label: Text(
                                isJoined
                                    ? (isAmharic ? 'ተቀላቅለዋል' : 'Joined')
                                    : (isAmharic ? 'ተቀላቀል' : 'Join'),
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              onPressed: () async {
                                final isGuest =
                                    userId.isEmpty || userId == 'guest_explorer';
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
                                        backgroundColor:
                                            const Color(0xFF10B981),
                                      ),
                                    );
                                  }
                                } else {
                                  ClubDetailSheet.show(
                                    context,
                                    club: club,
                                    controller: controller,
                                    userId: userId,
                                    userEmail: userEmail,
                                    userName: userName,
                                    notificationController:
                                        notificationController,
                                    onRequireAuth: onRequireAuth,
                                  );
                                }
                              },
                            ),
                          ),

                          // Quick Contact Action Pod (If mentor contact available)
                          if (club.mentorContact.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => _handleQuickContact(
                                  context, club.mentorContact),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0284C7)
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF38BDF8)
                                        .withValues(alpha: 0.35),
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

/// Modal dialog prompting guest users to create an account or sign in
/// before joining a student club chapter.
Future<void> showClubAuthRequiredDialog(
  BuildContext context, {
  VoidCallback? onSignIn,
}) async {
  final l10n = AppLocalizations.of(context);
  final glass = context.glassTheme;
  final isDark = glass.isDark;

  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: isDark
              ? const Color(0xFF38BDF8).withValues(alpha: 0.25)
              : const Color(0xFFBAE6FD),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.30),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.lock_person_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            l10n.clubAuthRequiredTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.clubAuthRequiredDesc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          style: TextButton.styleFrom(
            foregroundColor:
                isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
          child: Text(
            l10n.clubMaybeLater,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.of(ctx).pop();
            if (onSignIn != null) {
              onSignIn();
            }
          },
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF0284C7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          icon: const Icon(Icons.login_rounded, size: 16),
          label: Text(
            l10n.clubSignInAction,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}
