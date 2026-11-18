import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../models/mentor.dart';
import 'mentor_avatar_pod.dart';
import 'mentor_card_action_dock.dart';
import 'mentor_card_header.dart';
import 'mentor_detail_sheet.dart';
import 'mentor_launcher_helper.dart';
import 'mentor_status_row.dart';

class MentorCard extends StatelessWidget {
  const MentorCard({
    required this.mentor,
    this.onTap,
    super.key,
  });

  final Mentor mentor;
  final VoidCallback? onTap;

  static Future<void> launchCall(
    BuildContext context,
    String phone,
    AppLocalizations l10n,
  ) =>
      MentorLauncherHelper.launchCall(context, phone, l10n);

  static Future<void> launchTelegram(
    BuildContext context,
    String handle,
    AppLocalizations l10n,
  ) =>
      MentorLauncherHelper.launchTelegram(context, handle, l10n);

  static Future<void> launchWhatsApp(
    BuildContext context,
    String rawInput,
    AppLocalizations l10n,
  ) =>
      MentorLauncherHelper.launchWhatsApp(context, rawInput, l10n);

  static Future<void> launchEmail(
    BuildContext context,
    String email,
    AppLocalizations l10n,
  ) =>
      MentorLauncherHelper.launchEmail(context, email, l10n);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    final glass = context.glassTheme;
    final isDark = glass.isDark;

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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MentorAvatarPod(mentor: mentor, isDark: isDark),
                          const SizedBox(width: 12),
                          Expanded(
                            child: MentorCardHeader(
                              mentor: mentor,
                              isAmharic: isAmharic,
                              glass: glass,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      MentorStatusRow(
                        mentor: mentor,
                        isAmharic: isAmharic,
                        isDark: isDark,
                        glass: glass,
                        l10n: l10n,
                      ),
                      const SizedBox(height: 14),
                      MentorCardActionDock(
                        mentor: mentor,
                        isDark: isDark,
                        l10n: l10n,
                        onTap: onTap,
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
