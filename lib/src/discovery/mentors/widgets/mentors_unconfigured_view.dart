import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';

class MentorsUnconfiguredView extends StatelessWidget {
  const MentorsUnconfiguredView({
    required this.l10n,
    required this.glass,
    super.key,
  });

  final AppLocalizations l10n;
  final AppGlassTheme glass;

  @override
  Widget build(BuildContext context) {
    final isDark = glass.isDark;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF131D36).withValues(alpha: 0.70)
                    : Colors.white.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.20)
                      : Colors.white.withValues(alpha: 0.85),
                  width: 1.2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor:
                        const Color(0xFF0284C7).withValues(alpha: 0.15),
                    child: const Icon(Icons.people_alt_outlined,
                        color: Color(0xFF0284C7)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.mentorsIntroduction,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 13.5,
                        color: glass.titleText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF131D36).withValues(alpha: 0.75)
                    : Colors.white.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.22)
                      : Colors.white.withValues(alpha: 0.88),
                  width: 1.4,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor:
                        const Color(0xFF0284C7).withValues(alpha: 0.15),
                    child: const Icon(Icons.people_alt_outlined,
                        size: 25, color: Color(0xFF0284C7)),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.noVerifiedMentorsTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: glass.titleText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.noVerifiedMentorsBody,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13,
                      color: glass.subtitleText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF131D36).withValues(alpha: 0.65)
                    : Colors.white.withValues(alpha: 0.50),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.18)
                      : Colors.white.withValues(alpha: 0.80),
                  width: 1.2,
                ),
              ),
              child: ListTile(
                leading: const Icon(Icons.shield_outlined,
                    color: Color(0xFF0284C7)),
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                title: Text(
                  l10n.mentorSafetyTitle,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: glass.titleText,
                  ),
                ),
                subtitle: Text(
                  l10n.mentorSafetyBody,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12,
                    color: glass.subtitleText,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
