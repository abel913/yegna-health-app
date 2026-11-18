import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../models/facility.dart';
import 'facility_glass_card.dart';

class FacilityInclusivityAndServices extends StatelessWidget {
  const FacilityInclusivityAndServices({
    required this.facility,
    required this.isDark,
    required this.isAmharic,
    required this.catColor,
    required this.l10n,
    super.key,
  });

  final Facility facility;
  final bool isDark;
  final bool isAmharic;
  final Color catColor;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (facility.isWheelchairAccessible || facility.hasPrivateRoom) ...[
          FacilityGlassContentCard(
            title: isAmharic
                ? 'ተደራሽነት እና ሚስጥራዊነት'
                : 'Accessibility & Privacy',
            icon: Icons.verified_user_outlined,
            accentColor: isDark
                ? const Color(0xFF2DD4BF)
                : const Color(0xFF0D9488),
            isDark: isDark,
            child: Column(
              children: [
                if (facility.isWheelchairAccessible)
                  FacilityGlassFeatureRow(
                    icon: Icons.accessible_rounded,
                    iconColor: isDark
                        ? const Color(0xFF2DD4BF)
                        : const Color(0xFF0D9488),
                    title: l10n.wheelchairAccessibleBadge,
                    subtitle: isAmharic
                        ? 'ለአካል ጉዳተኞች ምቹ መግቢያ፣ ራምፕ እና በሮች አሉት።'
                        : 'Wheelchair ramp access and step-free entrances available.',
                    isDark: isDark,
                  ),
                if (facility.isWheelchairAccessible &&
                    facility.hasPrivateRoom)
                  Divider(
                    height: 18,
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                  ),
                if (facility.hasPrivateRoom)
                  FacilityGlassFeatureRow(
                    icon: Icons.lock_outline_rounded,
                    iconColor: isDark
                        ? const Color(0xFF818CF8)
                        : const Color(0xFF6366F1),
                    title: l10n.privateRoomBadge,
                    subtitle: isAmharic
                        ? 'ድምፅ የማይሰማበት የግል እና ሚስጥራዊ የምክር ክፍል አለው።'
                        : 'Confidential, sound-isolated private room for 1-on-1 counseling.',
                    isDark: isDark,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
        if (facility.services.isNotEmpty) ...[
          FacilityGlassContentCard(
            title: l10n.servicesOfferedLabel,
            icon: Icons.medical_services_outlined,
            accentColor: isDark
                ? const Color(0xFF38BDF8)
                : const Color(0xFF0284C7),
            isDark: isDark,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in facility.services)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark
                          ? catColor.withValues(alpha: 0.20)
                          : catColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: catColor.withValues(
                            alpha: isDark ? 0.40 : 0.25),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '#${s.replaceAll('_', ' ')}',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? catColor.withValues(alpha: 0.95)
                            : catColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}
