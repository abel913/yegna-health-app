import 'package:flutter/material.dart';

/// Centralized glassmorphism color palette and styling tokens
/// that adapt dynamically between Light Mode and Advanced Dark Mode.
class AppGlassTheme {
  const AppGlassTheme({
    required this.isDark,
    required this.scaffoldBackground,
    required this.scaffoldGradientColors,
    required this.appBarBackground,
    required this.appBarBorder,
    required this.appBarTitle,
    required this.cardBackground,
    required this.cardBorder,
    required this.cardShadow,
    required this.titleText,
    required this.subtitleText,
    required this.accentColor,
    required this.badgeBackground,
    required this.badgeText,
    required this.divider,
    required this.notchBackground,
    required this.notchBorder,
    required this.notchCradle,
    required this.notchShadow,
    required this.modalBackground,
    required this.modalHandle,
    required this.modalSelectedTile,
    required this.navSelectedColor,
    required this.navUnselectedColor,
    required this.ambientOrbs,
  });

  final bool isDark;
  final Color scaffoldBackground;
  final List<Color> scaffoldGradientColors;
  final Color appBarBackground;
  final Color appBarBorder;
  final Color appBarTitle;
  final Color cardBackground;
  final Color cardBorder;
  final List<BoxShadow> cardShadow;
  final Color titleText;
  final Color subtitleText;
  final Color accentColor;
  final Color badgeBackground;
  final Color badgeText;
  final Color divider;
  final Color notchBackground;
  final Color notchBorder;
  final Color notchCradle;
  final Color notchShadow;
  final Color modalBackground;
  final Color modalHandle;
  final Color modalSelectedTile;
  final Color navSelectedColor;
  final Color navUnselectedColor;
  final List<Color> ambientOrbs;

  factory AppGlassTheme.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return AppGlassTheme(
        isDark: true,
        scaffoldBackground: const Color(0xFF070D1E),
        scaffoldGradientColors: const [
          Color(0xFF070D1E),
          Color(0xFF0B132B),
          Color(0xFF0F172A),
        ],
        appBarBackground: const Color(0xFF0B132B).withValues(alpha: 0.82),
        appBarBorder: const Color(0xFF38BDF8).withValues(alpha: 0.18),
        appBarTitle: const Color(0xFFF8FAFC),
        cardBackground: const Color(0xFF131D36).withValues(alpha: 0.78),
        cardBorder: const Color(0xFF38BDF8).withValues(alpha: 0.22),
        cardShadow: const [
          BoxShadow(
            color: Color(0x60000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Color(0x1A38BDF8),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
        titleText: const Color(0xFFF8FAFC),
        subtitleText: const Color(0xFF94A3B8),
        accentColor: const Color(0xFF38BDF8),
        badgeBackground: const Color(0xFF1E293B),
        badgeText: const Color(0xFF38BDF8),
        divider: const Color(0xFF1E293B),
        notchBackground: const Color(0xFF0B132B).withValues(alpha: 0.94),
        notchBorder: const Color(0xFF38BDF8).withValues(alpha: 0.28),
        notchCradle: const Color(0xFF38BDF8),
        notchShadow: const Color(0x66000000),
        modalBackground: const Color(0xFF0F172A),
        modalHandle: const Color(0xFF334155),
        modalSelectedTile: const Color(0xFF0284C7).withValues(alpha: 0.24),
        navSelectedColor: const Color(0xFF38BDF8),
        navUnselectedColor: const Color(0xFF94A3B8),
        ambientOrbs: const [
          Color(0x240284C7),
          Color(0x1F0369A1),
          Color(0x1F0D9488),
        ],
      );
    }
    return AppGlassTheme(
      isDark: false,
      scaffoldBackground: const Color(0xFFEAF5FD),
      scaffoldGradientColors: const [
        Color(0xFFEAF5FD),
        Color(0xFFF0F8FF),
        Color(0xFFE0F2FE),
      ],
      appBarBackground: Colors.white.withValues(alpha: 0.55),
      appBarBorder: Colors.white.withValues(alpha: 0.85),
      appBarTitle: const Color(0xFF08264A),
      cardBackground: Colors.white,
      cardBorder: const Color(0xFFDCEAF5),
      cardShadow: const [
        BoxShadow(
          color: Color(0x0A005A71),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
      titleText: const Color(0xFF08264A),
      subtitleText: const Color(0xFF64748B),
      accentColor: const Color(0xFF0284C7),
      badgeBackground: const Color(0xFFF0F6FA),
      badgeText: const Color(0xFF005A71),
      divider: const Color(0xFFF1F5F9),
      notchBackground: Colors.white.withValues(alpha: 0.88),
      notchBorder: Colors.white.withValues(alpha: 0.95),
      notchCradle: const Color(0xFFBAE6FD),
      notchShadow: const Color(0x180284C7),
      modalBackground: Colors.white,
      modalHandle: const Color(0xFFCBD5E1),
      modalSelectedTile: const Color(0xFFF0F9FF),
      navSelectedColor: const Color(0xFF0284C7),
      navUnselectedColor: const Color(0xFF64748B),
      ambientOrbs: [
        Colors.white.withValues(alpha: 0.50),
        Colors.white.withValues(alpha: 0.45),
        const Color(0xFFBAE6FD).withValues(alpha: 0.40),
      ],
    );
  }
}

extension AppGlassThemeExtension on BuildContext {
  AppGlassTheme get glassTheme => AppGlassTheme.of(this);
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
