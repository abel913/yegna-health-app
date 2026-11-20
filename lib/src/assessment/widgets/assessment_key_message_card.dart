import 'package:flutter/material.dart';

/// Supportive counseling narrative card with quotation accent.
class AssessmentKeyMessageCard extends StatelessWidget {
  const AssessmentKeyMessageCard({
    required this.message,
    required this.isDark,
    required this.isAmharic,
    super.key,
  });

  final String message;
  final bool isDark;
  final bool isAmharic;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '”',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                  color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isAmharic ? 'ዋና መልእክት' : 'Key message',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.55,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}
