import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';

class MentorsNoResultsView extends StatelessWidget {
  const MentorsNoResultsView({
    required this.l10n,
    required this.glass,
    required this.onResetFilters,
    super.key,
  });

  final AppLocalizations l10n;
  final AppGlassTheme glass;
  final VoidCallback onResetFilters;

  @override
  Widget build(BuildContext context) {
    final isDark = glass.isDark;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF131D36).withValues(alpha: 0.76)
                    : Colors.white.withValues(alpha: 0.55),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF1E293B).withValues(alpha: 0.85),
                          const Color(0xFF0F172A).withValues(alpha: 0.70),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.75),
                          Colors.white.withValues(alpha: 0.35),
                        ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.22)
                      : Colors.white.withValues(alpha: 0.90),
                  width: 1.4,
                ),
                boxShadow: isDark
                    ? const [
                        BoxShadow(
                          color: Color(0x60000000),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ]
                    : const [
                        BoxShadow(
                          color: Color(0x140284C7),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_off_rounded,
                      size: 36,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: onResetFilters,
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: Text(l10n.resetFiltersAction),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
