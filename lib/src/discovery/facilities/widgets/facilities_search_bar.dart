import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';

class FacilitiesSearchBar extends StatelessWidget {
  const FacilitiesSearchBar({
    required this.controller,
    required this.isDark,
    required this.glass,
    required this.l10n,
    super.key,
  });

  final TextEditingController controller;
  final bool isDark;
  final AppGlassTheme glass;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF131D36).withValues(alpha: 0.76)
                : Colors.white.withValues(alpha: 0.55),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF1E293B).withValues(alpha: 0.82),
                      const Color(0xFF0F172A).withValues(alpha: 0.65),
                      const Color(0xFF0284C7).withValues(alpha: 0.12),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.78),
                      Colors.white.withValues(alpha: 0.35),
                      const Color(0xFFBAE6FD).withValues(alpha: 0.18),
                    ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF38BDF8).withValues(alpha: 0.24)
                  : Colors.white.withValues(alpha: 0.90),
              width: 1.4,
            ),
            boxShadow: isDark
                ? const [
                    BoxShadow(
                      color: Color(0x50000000),
                      blurRadius: 18,
                      offset: Offset(0, 6),
                    ),
                  ]
                : const [
                    BoxShadow(
                      color: Color(0x120284C7),
                      blurRadius: 18,
                      offset: Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 4,
                      offset: Offset(-1, -1),
                    ),
                  ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(
                Icons.search_rounded,
                color: glass.accentColor,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: l10n.searchFacilities,
                    hintStyle: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14,
                      color: glass.subtitleText,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 14,
                    color: glass.titleText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (controller.text.isNotEmpty)
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: glass.subtitleText,
                  ),
                  onPressed: () => controller.clear(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
