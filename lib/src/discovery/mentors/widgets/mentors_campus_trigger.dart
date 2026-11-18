import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../theme/app_glass_theme.dart';
import '../models/uog_campus_model.dart';

class MentorsCampusTrigger extends StatelessWidget {
  const MentorsCampusTrigger({
    required this.glass,
    required this.isDark,
    required this.isCampusFiltered,
    required this.activeCampus,
    required this.label,
    required this.onTap,
    super.key,
  });

  final AppGlassTheme glass;
  final bool isDark;
  final bool isCampusFiltered;
  final UogCampus activeCampus;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const Key('uog_campus_dropdown_trigger'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? (isCampusFiltered
                        ? const Color(0xFF0369A1).withValues(alpha: 0.28)
                        : const Color(0xFF1E293B).withValues(alpha: 0.75))
                    : (isCampusFiltered
                        ? const Color(0xFFE0F2FE).withValues(alpha: 0.85)
                        : Colors.white.withValues(alpha: 0.70)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF1E293B).withValues(alpha: 0.85),
                          const Color(0xFF0F172A).withValues(alpha: 0.65),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.85),
                          Colors.white.withValues(alpha: 0.45),
                        ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCampusFiltered
                      ? (isDark
                          ? const Color(0xFF38BDF8)
                          : const Color(0xFF0284C7))
                      : (isDark
                          ? const Color(0xFF38BDF8).withValues(alpha: 0.22)
                          : Colors.white.withValues(alpha: 0.90)),
                  width: isCampusFiltered ? 1.5 : 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? const Color(0x40000000)
                        : const Color(0x100284C7),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isCampusFiltered
                        ? activeCampus.icon
                        : Icons.account_balance_rounded,
                    size: 16,
                    color: isCampusFiltered
                        ? glass.accentColor
                        : glass.subtitleText,
                  ),
                  const SizedBox(width: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 165),
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: isCampusFiltered
                            ? (isDark
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFF0284C7))
                            : glass.titleText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: isCampusFiltered
                        ? glass.accentColor
                        : glass.subtitleText,
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
