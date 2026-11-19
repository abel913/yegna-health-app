import 'package:flutter/material.dart';

/// Interactive survey option tile with radio circle and checkmark.
class OnboardingSurveyOptionTile extends StatelessWidget {
  const OnboardingSurveyOptionTile({
    required this.code,
    required this.label,
    required this.isSelected,
    required this.onSelect,
    required this.isDark,
    super.key,
  });

  final String code;
  final String label;
  final bool isSelected;
  final ValueChanged<String> onSelect;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onSelect(code),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? const Color(0xFF3F51B5) : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF3F51B5)
                          : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                      width: 1.8,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isDark
                          ? (isSelected ? Colors.white : Colors.white70)
                          : (isSelected ? const Color(0xFF0F172A) : const Color(0xFF334155)),
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
