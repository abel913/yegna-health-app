import 'package:flutter/material.dart';

import '../../locale_controller.dart';
import '../../theme/app_glass_theme.dart';

/// App bar language selector dropdown button and popup menu.
class AppLanguageDropdown extends StatelessWidget {
  const AppLanguageDropdown({required this.localeController, super.key});

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    final selected = localeController.locale.languageCode;
    final isDark = context.isDark;

    return Center(
      child: PopupMenuButton<String>(
        key: const Key('language_dropdown_button'),
        tooltip: 'Change language',
        position: PopupMenuPosition.under,
        offset: const Offset(0, 8),
        elevation: 12,
        shadowColor: const Color(0x350284C7),
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark
                ? const Color(0xFF38BDF8).withValues(alpha: 0.3)
                : const Color(0xFFBAE6FD),
            width: 1.4,
          ),
        ),
        onSelected: (val) {
          if (val != selected) localeController.setLanguage(val);
        },
        itemBuilder: (context) => [
          _buildItem('en', '🇺🇸', 'English', 'English (US)', 'EN', selected == 'en', isDark),
          _buildItem('am', '🇪🇹', 'አማርኛ', 'Amharic (Ethiopia)', 'አማ', selected == 'am', isDark),
        ],
        child: _buildTrigger(selected, isDark),
      ),
    );
  }

  PopupMenuItem<String> _buildItem(
    String code,
    String flag,
    String title,
    String subtitle,
    String badge,
    bool isSel,
    bool isDark,
  ) {
    return PopupMenuItem<String>(
      value: code,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isSel
                  ? const Color(0xFFE0F2FE)
                  : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSel
                    ? const Color(0xFFBAE6FD)
                    : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
            ),
            alignment: Alignment.center,
            child: Text(flag, style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
            decoration: BoxDecoration(
              color: isSel
                  ? const Color(0xFF0284C7)
                  : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: isSel
                    ? Colors.white
                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
              ),
            ),
          ),
          if (isSel) ...[
            const SizedBox(width: 6),
            const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF0284C7)),
          ],
        ],
      ),
    );
  }

  Widget _buildTrigger(String selected, bool isDark) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF131D36).withValues(alpha: 0.85)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? const Color(0xFF38BDF8).withValues(alpha: 0.3)
              : const Color(0xFFBAE6FD).withValues(alpha: 0.9),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0284C7).withValues(alpha: 0.25)
                  : const Color(0xFFE0F2FE),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.translate_rounded,
              size: 13,
              color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
            ),
          ),
          const SizedBox(width: 7),
          Text(
            selected == 'am' ? '🇪🇹 አማ' : '🇺🇸 EN',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF08264A),
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
          ),
        ],
      ),
    );
  }
}
