import 'package:flutter/material.dart';

import '../../theme/app_glass_theme.dart';
import 'deep_glass_container.dart';

class HomeActionCard extends StatelessWidget {
  const HomeActionCard({
    required this.icon,
    required this.iconGradient,
    required this.title,
    required this.description,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final List<Color> iconGradient;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    return DeepGlassContainer(
      borderRadius: 24,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: iconGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: iconGradient.first.withValues(alpha: 0.40),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : Colors.white.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF38BDF8).withValues(alpha: 0.3)
                        : Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: isDark
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFF0284C7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: glass.titleText,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.3,
                    fontWeight: FontWeight.w400,
                    color: glass.subtitleText,
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
