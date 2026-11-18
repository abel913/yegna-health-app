import 'dart:ui';
import 'package:flutter/material.dart';

class ChatDisclaimerBanner extends StatelessWidget {
  const ChatDisclaimerBanner({
    required this.disclaimer,
    required this.isDark,
    required this.onDismiss,
    super.key,
  });

  final String disclaimer;
  final bool isDark;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 6, 14, 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0C192E).withValues(alpha: 0.72)
                  : const Color(0xFFE0F2FE).withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF38BDF8).withValues(alpha: 0.25)
                    : const Color(0xFFBAE6FD),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.health_and_safety_outlined,
                  color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    disclaimer,
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.35,
                      color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0369A1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF0284C7),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onDismiss,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
