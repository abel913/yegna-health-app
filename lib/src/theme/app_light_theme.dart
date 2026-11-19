import 'package:flutter/material.dart';

/// Builds the Material 3 light theme for the Yegna application.
ThemeData buildAppLightTheme() {
  return ThemeData(
    fontFamily: 'PlusJakartaSans',
    fontFamilyFallback: const ['NotoSansEthiopic'],
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF005A71),
      surface: const Color(0xFFFAF8FF),
    ).copyWith(
      primary: const Color(0xFF005A71),
      secondary: const Color(0xFF006398),
      tertiary: const Color(0xFF005F40),
      surfaceContainerLow: const Color(0xFFF2F3FF),
      surfaceContainer: const Color(0xFFEAEDFF),
      outlineVariant: const Color(0xFFDAE2E6),
    ),
    scaffoldBackgroundColor: const Color(0xFFFAF8FF),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFAF8FF),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 20,
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 0.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        side: BorderSide(color: Color(0x1A005A71)),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: Color(0x1F005A71)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: Color(0x1F005A71)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: Color(0xFF005A71), width: 1.5),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    ),
    searchBarTheme: SearchBarThemeData(
      elevation: const WidgetStatePropertyAll(0),
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      backgroundColor: const WidgetStatePropertyAll(Color(0xFFF2F3FF)),
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
      backgroundColor: const Color(0xFFF2F3FF),
      indicatorColor: const Color(0xFFD3F1FF),
      elevation: 0,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
            fontSize: 12,
            height: 1.25,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? const Color(0xFF005A71)
                : const Color(0xFF59666B),
          )),
      iconTheme: const WidgetStatePropertyAll(
        IconThemeData(size: 22),
      ),
    ),
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontSize: 32,
        height: 1.28,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        fontSize: 26,
        height: 1.3,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      ),
      headlineSmall: TextStyle(
        fontSize: 23,
        height: 1.35,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        fontSize: 19,
        height: 1.35,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 1.55),
      bodyMedium: TextStyle(fontSize: 14, height: 1.55),
      bodySmall: TextStyle(fontSize: 12, height: 1.5),
      labelLarge: TextStyle(
        fontSize: 14,
        height: 1.4,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        height: 1.4,
        fontWeight: FontWeight.w600,
      ),
    ),
    useMaterial3: true,
  );
}
