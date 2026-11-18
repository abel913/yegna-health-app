import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../l10n/app_localizations.dart';
import '../models/mentor.dart';
import 'mentor_launcher_helper.dart';

class MentorVoiceContactChannelRow extends StatelessWidget {
  const MentorVoiceContactChannelRow({
    required this.mentor,
    required this.l10n,
    required this.isAmharic,
    required this.isDark,
    required this.onSms,
    super.key,
  });

  final Mentor mentor;
  final AppLocalizations l10n;
  final bool isAmharic;
  final bool isDark;
  final VoidCallback onSms;

  @override
  Widget build(BuildContext context) {
    final rowBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final rowBorder =
        isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final titleColor =
        isDark ? const Color(0xFFF8FAFC) : const Color(0xFF08264A);
    final brandBlue =
        isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: rowBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: rowBorder, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.phone_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isAmharic ? 'የስልክ ጥሪ' : 'Voice Call',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  mentor.displayPhoneNumber,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: brandBlue,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 30,
            height: 32,
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: l10n.copyPhoneSuccess,
              icon: Icon(Icons.copy_rounded, size: 16, color: brandBlue),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: mentor.phoneNumber));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '${l10n.copyPhoneSuccess} (${mentor.phoneNumber})'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: 30,
            height: 32,
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: l10n.sendSmsAction,
              icon: Icon(Icons.sms_rounded, size: 16, color: brandBlue),
              onPressed: onSms,
            ),
          ),
          const SizedBox(width: 4),
          ElevatedButton(
            onPressed: () =>
                MentorLauncherHelper.launchCall(context, mentor.phoneNumber, l10n),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: const Size(0, 34),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(
              l10n.callMentorAction,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
