import 'package:flutter/material.dart';

/// Category-specific color palettes and iconography for curriculum modules.
class ModuleCategoryTheme {
  const ModuleCategoryTheme({
    required this.accentColor,
    required this.gradientColors,
    required this.icon,
    required this.displayName,
    required this.tag,
  });

  final Color accentColor;
  final List<Color> gradientColors;
  final IconData icon;
  final String displayName;
  final String tag;

  static ModuleCategoryTheme forCategory(String category) {
    final cat = category.toLowerCase().trim();

    if (cat.contains('puberty') ||
        cat.contains('adolescen') ||
        cat.contains('growth')) {
      return const ModuleCategoryTheme(
        accentColor: Color(0xFF0284C7),
        gradientColors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
        icon: Icons.straighten_rounded,
        displayName: 'Puberty & Growth',
        tag: 'PUBERTY',
      );
    } else if (cat.contains('srh') || cat.contains('reproduct')) {
      return const ModuleCategoryTheme(
        accentColor: Color(0xFFE11D48),
        gradientColors: [Color(0xFFE11D48), Color(0xFFFB7185)],
        icon: Icons.favorite_rounded,
        displayName: 'SRH & Wellness',
        tag: 'SRH',
      );
    } else if (cat.contains('mental') ||
        cat.contains('stress') ||
        cat.contains('psych')) {
      return const ModuleCategoryTheme(
        accentColor: Color(0xFF8B5CF6),
        gradientColors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
        icon: Icons.psychology_rounded,
        displayName: 'Mental Health',
        tag: 'MENTAL HEALTH',
      );
    } else if (cat.contains('sti')) {
      return const ModuleCategoryTheme(
        accentColor: Color(0xFF0D9488),
        gradientColors: [Color(0xFF0D9488), Color(0xFF2DD4BF)],
        icon: Icons.healing_rounded,
        displayName: 'STIs & Care',
        tag: 'STIs',
      );
    } else if (cat.contains('hiv') || cat.contains('aids')) {
      return const ModuleCategoryTheme(
        accentColor: Color(0xFF4F46E5),
        gradientColors: [Color(0xFF4F46E5), Color(0xFF818CF8)],
        icon: Icons.shield_outlined,
        displayName: 'HIV Awareness',
        tag: 'HIV/AIDS',
      );
    } else if (cat.contains('gbv') ||
        cat.contains('violence') ||
        cat.contains('consent')) {
      return const ModuleCategoryTheme(
        accentColor: Color(0xFFDB2777),
        gradientColors: [Color(0xFFDB2777), Color(0xFFF472B6)],
        icon: Icons.gavel_rounded,
        displayName: 'GBV & Rights',
        tag: 'GBV',
      );
    } else if (cat.contains('substance') ||
        cat.contains('addiction') ||
        cat.contains('drug')) {
      return const ModuleCategoryTheme(
        accentColor: Color(0xFFD97706),
        gradientColors: [Color(0xFFD97706), Color(0xFFFBBF24)],
        icon: Icons.spa_rounded,
        displayName: 'Substance Prevention',
        tag: 'SUBSTANCE',
      );
    } else if (cat.contains('hepatitis')) {
      return const ModuleCategoryTheme(
        accentColor: Color(0xFF0284C7),
        gradientColors: [Color(0xFF0284C7), Color(0xFF0D9488)],
        icon: Icons.medical_services_outlined,
        displayName: 'Viral Hepatitis',
        tag: 'HEPATITIS',
      );
    }

    return const ModuleCategoryTheme(
      accentColor: Color(0xFF0284C7),
      gradientColors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
      icon: Icons.menu_book_rounded,
      displayName: 'General Health',
      tag: 'HEALTH',
    );
  }
}
