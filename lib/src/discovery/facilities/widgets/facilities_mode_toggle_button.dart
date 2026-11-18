import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../models/facilities_view_mode.dart';

class FacilitiesModeToggleButton extends StatelessWidget {
  const FacilitiesModeToggleButton({
    required this.viewMode,
    required this.isDark,
    required this.l10n,
    required this.onViewModeChanged,
    super.key,
  });

  final FacilitiesViewMode viewMode;
  final bool isDark;
  final AppLocalizations l10n;
  final ValueChanged<FacilitiesViewMode> onViewModeChanged;

  Widget _buildModeButton({
    required IconData icon,
    required FacilitiesViewMode mode,
    required String tooltip,
  }) {
    final isSelected = viewMode == mode;
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () => onViewModeChanged(mode),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF0284C7)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isSelected
                ? Colors.white
                : (isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E293B).withValues(alpha: 0.70)
                : const Color(0xFFE0F2FE).withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF38BDF8).withValues(alpha: 0.22)
                  : Colors.white.withValues(alpha: 0.8),
              width: 1.1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildModeButton(
                icon: Icons.view_agenda_outlined,
                mode: FacilitiesViewMode.list,
                tooltip: l10n.listViewLabel,
              ),
              _buildModeButton(
                icon: Icons.map_outlined,
                mode: FacilitiesViewMode.map,
                tooltip: l10n.mapViewLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
