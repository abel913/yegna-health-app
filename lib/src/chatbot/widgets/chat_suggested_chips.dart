import 'package:flutter/material.dart';

/// Docked horizontal row of frosted glass suggestion pills.
class ChatSuggestedChips extends StatelessWidget {
  const ChatSuggestedChips({
    required this.chips,
    required this.onSelectPrompt,
    required this.isDark,
    super.key,
  });

  final List<String> chips;
  final ValueChanged<String> onSelectPrompt;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (chips.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final chip = chips[index];
          return ActionChip(
            label: Text(
              chip,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color:
                    isDark ? const Color(0xFF38BDF8) : const Color(0xFF005A71),
              ),
            ),
            backgroundColor: isDark
                ? const Color(0xFF0F1E36).withValues(alpha: 0.72)
                : Colors.white.withValues(alpha: 0.85),
            side: BorderSide(
              color: isDark
                  ? const Color(0xFF38BDF8).withValues(alpha: 0.35)
                  : const Color(0xFFBAE6FD),
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            onPressed: () => onSelectPrompt(chip),
          );
        },
      ),
    );
  }
}
