import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../theme/app_glass_theme.dart';

/// Frosted glass progress capsule displaying current curriculum completion stats.
class LearnProgressCapsule extends StatelessWidget {
  const LearnProgressCapsule({
    required this.completedCount,
    required this.totalCount,
    this.onTap,
    super.key,
  });

  final int completedCount;
  final int totalCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;
    final ratio = totalCount > 0 ? (completedCount / totalCount).clamp(0.0, 1.0) : 0.0;
    final percent = (ratio * 100).toInt();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF131D36).withValues(alpha: 0.72)
                      : Colors.white.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF38BDF8).withValues(alpha: 0.22)
                        : Colors.white.withValues(alpha: 0.85),
                    width: 1.2,
                  ),
                  boxShadow: glass.cardShadow,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF10B981), Color(0xFF34D399)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x3310B981),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$completedCount of $totalCount Modules Completed',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: glass.titleText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                percent == 100
                                    ? 'Curriculum Completed! 🎉'
                                    : 'Keep learning to unlock health badges',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: glass.subtitleText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981)
                                .withValues(alpha: isDark ? 0.22 : 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF10B981)
                                  .withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '$percent%',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        height: 5,
                        width: double.infinity,
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: ratio,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF0284C7), Color(0xFF10B981)],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
