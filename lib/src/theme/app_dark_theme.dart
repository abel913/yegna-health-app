import 'package:flutter/material.dart';

/// Builds the Material 3 dark theme for the Yegna application.
ThemeData buildAppDarkTheme() {
  const darkBg = Color(0xFF0B132B);
  const darkSurface = Color(0xFF1C2541);
  const darkContainer = Color(0xFF1E293B);

  return ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'PlusJakartaSans',
    fontFamilyFallback: const ['NotoSansEthiopic'],
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0284C7),
      brightness: Brightness.dark,
      surface: darkSurface,
    ).copyWith(
      primary: const Color(0xFF38BDF8),
      secondary: const Color(0xFF7DD3FC),
      tertiary: const Color(0xFF34D399),
      surfaceContainerLow: const Color(0xFF0F172A),
      surfaceContainer: darkContainer,
      outlineVariant: const Color(0xFF334155),
    ),
    scaffoldBackgroundColor: darkBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 20,
      iconTheme: IconThemeData(color: Color(0xFFF8FAFC)),
      titleTextStyle: TextStyle(
        color: Color(0xFFF8FAFC),
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    ),
    cardTheme: const CardThemeData(
      color: darkContainer,
      elevation: 0.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        side: BorderSide(color: Color(0x3338BDF8)),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: darkContainer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: Color(0x3338BDF8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: Color(0x3338BDF8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: Color(0xFF38BDF8), width: 1.5),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    ),
    searchBarTheme: SearchBarThemeData(
      elevation: const WidgetStatePropertyAll(0),
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      backgroundColor: const WidgetStatePropertyAll(Color(0xFF1E293B)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      constraints: const BoxConstraints(minHeight: 52),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 76,
      backgroundColor: const Color(0xFF0F172A),
      indicatorColor: const Color(0xFF0369A1),
      elevation: 0,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
            fontSize: 12,
            height: 1.25,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? const Color(0xFF38BDF8)
                : const Color(0xFF94A3B8),
          )),
      iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
            size: 22,
            color: states.contains(WidgetState.selected)
                ? Colors.white
                : const Color(0xFF94A3B8),
          )),
    ),
    useMaterial3: true,
  );
}
