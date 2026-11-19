import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_glass_theme.dart';

class LearnHeaderPill extends StatelessWidget {
  const LearnHeaderPill({
    this.isGridMode = false,
    this.onToggleMode,
    super.key,
  });

  final bool isGridMode;
  final VoidCallback? onToggleMode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E293B).withValues(alpha: 0.75)
                  : Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF38BDF8).withValues(alpha: 0.3)
                    : const Color(0xFFBAE6FD).withValues(alpha: 0.85),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? const Color(0x33000000)
                      : const Color(0x140284C7),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x330284C7),
                        blurRadius: 4,
                        offset: Offset(0, 1.5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 9),
                Text(
                  l10n.learningHeading,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                    color: isDark ? Colors.white : const Color(0xFF08264A),
                  ),
                ),
              ],
            ),
          ),
          if (onToggleMode != null) ...[
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onToggleMode,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B).withValues(alpha: 0.75)
                      : Colors.white.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF38BDF8).withValues(alpha: 0.3)
                        : const Color(0xFFBAE6FD),
                    width: 1.2,
                  ),
                ),
                child: Icon(
                  isGridMode ? Icons.view_carousel_rounded : Icons.grid_view_rounded,
                  size: 16,
                  color: glass.accentColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
