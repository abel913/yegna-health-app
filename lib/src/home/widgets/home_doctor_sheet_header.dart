import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_glass_theme.dart';

class HomeDoctorSheetHeader extends StatelessWidget {
  const HomeDoctorSheetHeader({
    required this.l10n,
    super.key,
  });

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            glass.accentColor.withValues(alpha: 0.08),
            const Color(0xFF0EA5E9).withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? glass.cardBorder
              : const Color(0xFFBAE6FD).withValues(alpha: 0.8),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x250284C7),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.medical_services_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        l10n.doctorArticleAuthor,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: glass.titleText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.verified_rounded,
                      size: 16,
                      color: glass.accentColor,
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${l10n.doctorArticleDate} • ${l10n.doctorArticleReadTime}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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
    );
  }
}
