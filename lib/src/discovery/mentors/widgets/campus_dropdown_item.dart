import 'package:flutter/material.dart';

import '../../../theme/app_glass_theme.dart';
import '../models/uog_campus_model.dart';

class CampusDropdownItem extends StatelessWidget {
  const CampusDropdownItem({
    required this.campus,
    required this.isSelected,
    required this.isDark,
    required this.isAmharic,
    required this.glass,
    required this.onTap,
    super.key,
  });

  final UogCampus campus;
  final bool isSelected;
  final bool isDark;
  final bool isAmharic;
  final AppGlassTheme glass;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: Key('campus_option_${campus.id}'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 9.5,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0).withValues(alpha: 0.75))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: isSelected
                  ? Border.all(
                      color: isDark
                          ? const Color(0xFF38BDF8).withValues(alpha: 0.40)
                          : const Color(0xFF0284C7).withValues(alpha: 0.30),
                      width: 1.2,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark
                            ? const Color(0xFF38BDF8).withValues(alpha: 0.18)
                            : const Color(0xFF0284C7).withValues(alpha: 0.12))
                        : (isDark
                            ? const Color(0xFF1E293B).withValues(alpha: 0.60)
                            : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      campus.icon,
                      size: 17,
                      color: isSelected
                          ? glass.accentColor
                          : (isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF475569)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    campus.localizedName(isAmharic),
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected
                          ? (isDark
                              ? const Color(0xFF38BDF8)
                              : const Color(0xFF0284C7))
                          : glass.titleText,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF38BDF8)
                          : const Color(0xFF0284C7),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_rounded,
                        size: 15,
                        color: Colors.white,
                      ),
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
