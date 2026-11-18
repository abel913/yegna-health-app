import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../models/mentor.dart';
import 'mentor_live_status_banner.dart';
import 'mentor_schedule_action_row.dart';
import 'mentor_schedule_header.dart';
import 'mentor_schedule_matrix.dart';

class MentorScheduleSheet extends StatelessWidget {
  const MentorScheduleSheet({
    required this.mentor,
    super.key,
  });

  final Mentor mentor;

  static Future<void> show(BuildContext context, Mentor mentor) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => MentorScheduleSheet(mentor: mentor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glass = AppGlassTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.6 : 0.18),
            blurRadius: 30,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MentorScheduleHeader(
                mentor: mentor,
                isAmharic: isAmharic,
                isDark: isDark,
                glass: glass,
              ),
              const SizedBox(height: 16),
              MentorLiveStatusBanner(
                mentor: mentor,
                isAmharic: isAmharic,
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              MentorScheduleMatrix(
                mentor: mentor,
                isAmharic: isAmharic,
                isDark: isDark,
                glass: glass,
                l10n: l10n,
              ),
              const SizedBox(height: 16),
              MentorScheduleActionRow(
                mentor: mentor,
                isDark: isDark,
                glass: glass,
                l10n: l10n,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
