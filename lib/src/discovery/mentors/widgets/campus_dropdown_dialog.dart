import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../models/uog_campus_model.dart';
import 'campus_dropdown_header.dart';
import 'campus_dropdown_item.dart';

class CampusDropdownDialog {
  const CampusDropdownDialog._();

  static void show({
    required BuildContext context,
    required AppLocalizations l10n,
    required AppGlassTheme glass,
    required bool isDark,
    required bool isAmharic,
    required String selectedCampus,
    required ValueChanged<String> onSelected,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss Campus Filter',
      barrierColor: isDark
          ? Colors.black.withValues(alpha: 0.50)
          : Colors.black.withValues(alpha: 0.25),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        final topPadding = MediaQuery.of(context).padding.top + 70.0;

        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, topPadding, 16, 24),
            child: Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                  child: Container(
                    width: 380,
                    constraints: const BoxConstraints(maxWidth: 420),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F172A).withValues(alpha: 0.92)
                          : Colors.white.withValues(alpha: 0.94),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                const Color(0xFF1E293B).withValues(alpha: 0.95),
                                const Color(0xFF0F172A).withValues(alpha: 0.90),
                                const Color(0xFF0284C7).withValues(alpha: 0.12),
                              ]
                            : [
                                Colors.white.withValues(alpha: 0.98),
                                Colors.white.withValues(alpha: 0.88),
                                const Color(0xFFBAE6FD).withValues(alpha: 0.22),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF38BDF8).withValues(alpha: 0.30)
                            : Colors.white.withValues(alpha: 0.95),
                        width: 1.5,
                      ),
                      boxShadow: isDark
                          ? const [
                              BoxShadow(
                                color: Color(0x90000000),
                                blurRadius: 32,
                                offset: Offset(0, 12),
                              ),
                            ]
                          : const [
                              BoxShadow(
                                color: Color(0x200284C7),
                                blurRadius: 32,
                                offset: Offset(0, 12),
                              ),
                              BoxShadow(
                                color: Colors.white,
                                blurRadius: 6,
                                offset: Offset(-1, -1),
                              ),
                            ],
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CampusDropdownHeader(
                          l10n: l10n,
                          glass: glass,
                          isDark: isDark,
                          onClose: () => Navigator.of(dialogContext).pop(),
                        ),
                        const SizedBox(height: 12),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: isDark
                              ? const Color(0xFF334155).withValues(alpha: 0.50)
                              : const Color(0xFFE2E8F0).withValues(alpha: 0.80),
                        ),
                        const SizedBox(height: 8),
                        ...kUogCampuses.map((campus) {
                          return CampusDropdownItem(
                            campus: campus,
                            isSelected: selectedCampus == campus.id,
                            isDark: isDark,
                            isAmharic: isAmharic,
                            glass: glass,
                            onTap: () {
                              Navigator.of(dialogContext).pop();
                              onSelected(campus.id);
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.06),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}
