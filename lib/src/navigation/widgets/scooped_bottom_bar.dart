import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_glass_theme.dart';
import 'scooped_notch_painter.dart';

/// Deep Glass Scooped Bottom Navigation Bar with floating 3D active icon cradle.
class ScoopedBottomBar extends StatelessWidget {
  const ScoopedBottomBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static IconData selectedIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home_rounded;
      case 1:
        return Icons.local_hospital_rounded;
      case 2:
        return Icons.people_alt_rounded;
      case 3:
        return Icons.menu_book_rounded;
      case 4:
        return Icons.person_rounded;
      default:
        return Icons.home_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isDark = context.isDark;
    final l10n = AppLocalizations.of(context);
    const circleSize = 48.0;

    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final step = totalWidth / 5;
          final targetNotchX = (selectedIndex * step) + (step / 2);

          return TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: targetNotchX, end: targetNotchX),
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            builder: (context, notchX, child) {
              return SizedBox(
                height: 80,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CustomPaint(
                      size: Size(totalWidth, 80),
                      painter: ScoopedNotchBarPainter(
                        notchX: notchX,
                        color: glass.notchBackground,
                        borderColor: glass.notchBorder,
                        cradleBorderColor: glass.notchCradle,
                        shadowColor: glass.notchShadow,
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        navigationBarTheme: NavigationBarThemeData(
                          backgroundColor: Colors.transparent,
                          indicatorColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                          labelTextStyle: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: glass.navSelectedColor,
                              );
                            }
                            return TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: glass.navUnselectedColor,
                            );
                          }),
                          iconTheme: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return const IconThemeData(
                                color: Colors.transparent,
                                size: 26,
                              );
                            }
                            return IconThemeData(
                              color: glass.navUnselectedColor,
                              size: 24,
                            );
                          }),
                        ),
                      ),
                      child: NavigationBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        height: 72,
                        selectedIndex: selectedIndex,
                        onDestinationSelected: onDestinationSelected,
                        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                        destinations: [
                          NavigationDestination(
                            icon: const Icon(Icons.home_outlined),
                            selectedIcon: const SizedBox(width: 26, height: 26),
                            label: l10n.homeTab,
                          ),
                          NavigationDestination(
                            icon: const Icon(Icons.local_hospital_outlined),
                            selectedIcon: const SizedBox(width: 26, height: 26),
                            label: l10n.facilitiesTab,
                          ),
                          NavigationDestination(
                            icon: const Icon(Icons.people_alt_outlined),
                            selectedIcon: const SizedBox(width: 26, height: 26),
                            label: l10n.mentorsTab,
                          ),
                          NavigationDestination(
                            icon: const Icon(Icons.menu_book_outlined),
                            selectedIcon: const SizedBox(width: 26, height: 26),
                            label: l10n.learnTab,
                          ),
                          NavigationDestination(
                            icon: const Icon(Icons.person_outline_rounded),
                            selectedIcon: const SizedBox(width: 26, height: 26),
                            label: l10n.accountTab,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: notchX - (circleSize / 2),
                      top: -10,
                      child: IgnorePointer(
                        child: Container(
                          width: circleSize,
                          height: circleSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? const [Color(0xFF0284C7), Color(0xFF38BDF8)]
                                  : const [Color(0xFF0284C7), Color(0xFF0369A1)],
                            ),
                            border: Border.all(
                              color: isDark ? const Color(0xFF070D1E) : Colors.white,
                              width: 2.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? const Color(0x6038BDF8)
                                    : const Color(0x450284C7),
                                blurRadius: 14,
                                spreadRadius: 1,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              selectedIcon(selectedIndex),
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
