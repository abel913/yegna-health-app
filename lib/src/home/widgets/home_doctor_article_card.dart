import 'package:flutter/material.dart';

import '../../theme/app_glass_theme.dart';
import 'deep_glass_container.dart';

/// Daily Doctor-Authored Youth Health Article Card
class HomeDoctorArticleCard extends StatelessWidget {
  const HomeDoctorArticleCard({
    required this.badgeText,
    required this.authorText,
    required this.titleText,
    required this.bodyText,
    required this.actionText,
    required this.onTap,
    super.key,
  });

  final String badgeText;
  final String authorText;
  final String titleText;
  final String bodyText;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    return DeepGlassContainer(
      borderRadius: 24,
      padding: const EdgeInsets.all(18),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x250284C7),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.medical_services_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      badgeText,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0C4A6E)
                      : const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF0284C7)
                        : const Color(0xFFBAE6FD),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      size: 12,
                      color: glass.accentColor,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        authorText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? const Color(0xFF38BDF8)
                              : const Color(0xFF0284C7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            titleText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: glass.titleText,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            bodyText,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: glass.subtitleText,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                actionText,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: glass.accentColor,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_rounded,
                size: 15,
                color: glass.accentColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
