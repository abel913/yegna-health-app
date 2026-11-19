import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_glass_theme.dart';
import 'home_doctor_advice_tile.dart';
import 'home_doctor_sheet_actions.dart';
import 'home_doctor_sheet_header.dart';

class HomeDoctorArticleSheet {
  const HomeDoctorArticleSheet._();

  static void show(
    BuildContext context, {
    required AppLocalizations l10n,
    required VoidCallback onOpenMentors,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final glass = ctx.glassTheme;
        final isDark = glass.isDark;

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0F172A).withValues(alpha: 0.96)
                  : Colors.white.withValues(alpha: 0.96),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              border: isDark
                  ? Border.all(color: glass.cardBorder, width: 1.2)
                  : null,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x30000000),
                  blurRadius: 28,
                  offset: Offset(0, -6),
                ),
              ],
            ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.88,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          color: glass.modalHandle,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 22),
                        color: glass.subtitleText,
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(22, 6, 22, 32),
                    children: [
                      HomeDoctorSheetHeader(l10n: l10n),
                      const SizedBox(height: 18),
                      Text(
                        l10n.dailyTipTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: glass.titleText,
                          height: 1.3,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        l10n.doctorArticleFullText,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.65,
                          color: isDark
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF1E3A54),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 18,
                            decoration: BoxDecoration(
                              color: glass.accentColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.doctorArticleSheetTitle,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: glass.titleText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      HomeDoctorAdviceTile(
                        icon: Icons.clean_hands_rounded,
                        iconColor: const Color(0xFF0D9488),
                        title: l10n.doctorAdviceSkincareTitle,
                        description: l10n.doctorAdviceSkincareDesc,
                      ),
                      const SizedBox(height: 10),
                      HomeDoctorAdviceTile(
                        icon: Icons.spa_rounded,
                        iconColor: const Color(0xFF6366F1),
                        title: l10n.doctorAdviceEmotionalTitle,
                        description: l10n.doctorAdviceEmotionalDesc,
                      ),
                      const SizedBox(height: 10),
                      HomeDoctorAdviceTile(
                        icon: Icons.local_hospital_rounded,
                        iconColor: const Color(0xFFE11D48),
                        title: l10n.doctorAdviceClinicalTitle,
                        description: l10n.doctorAdviceClinicalDesc,
                      ),
                      const SizedBox(height: 24),
                      HomeDoctorSheetActions(
                        l10n: l10n,
                        onOpenMentors: () {
                          Navigator.of(ctx).pop();
                          onOpenMentors();
                        },
                        onClose: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
