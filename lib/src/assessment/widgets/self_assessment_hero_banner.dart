import 'package:flutter/material.dart';

/// Top header card introducing the University of Gondar SRHR Self-Assessment suite.
class SelfAssessmentHeroBanner extends StatelessWidget {
  const SelfAssessmentHeroBanner({
    required this.isDark,
    required this.isAmharic,
    super.key,
  });

  final bool isDark;
  final bool isAmharic;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
              : [const Color(0xFF004D5A), const Color(0xFF00796B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_rounded, color: Colors.white, size: 14),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    isAmharic ? 'የጎንደር ዩኒቨርሲቲ ይፋዊ መጠይቅ' : 'Official University of Gondar Tool',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isAmharic ? 'የጾታዊ እና ስነ-ተዋልዶ ጤና ራስን መመዘኛ' : 'SRHR Self-Assessment Suite',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isAmharic
                ? 'በጎንደር ዩኒቨርሲቲ የጾታ እና ማህበራዊ አካታችነት ዳይሬክቶሬት የተዘጋጀ 8 ክፍሎች ያሉት ክሊኒካዊ ምዘና። መልሶችዎ 100% ሚስጥራዊ ናቸው።'
                : 'Official clinical instrument by UoG Directorate of Gender & Social Inclusion. 50 questions across 8 sections. 100% confidential.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline_rounded, color: Colors.white70, size: 14),
                const SizedBox(width: 8),
                Text(
                  isAmharic ? 'ምንም የግል መታወቂያ አይቀመጥም (Zero-PII)' : 'Anonymous & Zero-PII Protected',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
