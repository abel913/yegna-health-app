import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../models/mentor.dart';
import 'mentor_detail_cards.dart';
import 'mentor_detail_header.dart';
import 'mentor_direct_contacts_card.dart';
import 'mentor_languages_card.dart';
import 'mentor_metrics_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    final sheetBg = isDark
        ? const Color(0xFF0B132B).withValues(alpha: 0.90)
        : const Color(0xFFF8FAFC).withValues(alpha: 0.90);
    final cardBg = isDark
        ? const Color(0xFF131D36).withValues(alpha: 0.82)
        : Colors.white.withValues(alpha: 0.85);
    final cardBorder = isDark
        ? const Color(0xFF38BDF8).withValues(alpha: 0.22)
        : const Color(0xFFDCEAF5);
    final brandBlue =
        isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);
    final brandNavy =
        isDark ? const Color(0xFFF8FAFC) : const Color(0xFF08264A);
    final slateText =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final bodyText =
        isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);

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
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                    children: [
                      MentorDetailHeader(
                        mentor: mentor,
                        isAmharic: isAmharic,
                        isDark: isDark,
                        brandNavy: brandNavy,
                        brandBlue: brandBlue,
                        slateText: slateText,
                      ),
                      const SizedBox(height: 18),
                      MentorMetricsBar(
                        mentor: mentor,
                        isAmharic: isAmharic,
                        isDark: isDark,
                        cardBg: cardBg,
                        cardBorder: cardBorder,
                        l10n: l10n,
                      ),
                      const SizedBox(height: 18),
                      MentorDirectContactsCard(
                        mentor: mentor,
                        l10n: l10n,
                        isAmharic: isAmharic,
                        isDark: isDark,
                        cardBg: cardBg,
                        brandBlue: brandBlue,
                        brandNavy: brandNavy,
                        slateText: slateText,
                      ),
                      const SizedBox(height: 18),
                      MentorDetailCard(
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
                      MentorDetailCard(
                        title: l10n.specialtiesLabel,
                        icon: Icons.stars_rounded,
                        isDark: isDark,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final topic in mentor.topics)
                              MentorTopicTag(
                                topic: topic,
                                l10n: l10n,
                                isDark: isDark,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      MentorLanguagesCard(
                        languages: mentor.languages,
                        title: l10n.languagesSpokenLabel,
                        isDark: isDark,
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
}
