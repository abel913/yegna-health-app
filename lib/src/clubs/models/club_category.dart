import 'package:flutter/material.dart';

enum ClubCategory {
  all,
  mentalHealth,
  srhWellness,
  antiSubstance,
  firstAid,
  girlsHygiene,
  peerLeadership,
}

extension ClubCategoryPresentation on ClubCategory {
  String label(bool isAmharic) {
    return switch (this) {
      ClubCategory.all => isAmharic ? 'ሁሉም' : 'All',
      ClubCategory.mentalHealth => isAmharic ? 'አእምሮ ጤና' : 'Mental Health',
      ClubCategory.srhWellness => isAmharic ? 'ስነ-ተዋልዶ' : 'SRH Wellness',
      ClubCategory.antiSubstance => isAmharic ? 'ከሱስ ነፃ' : 'Anti-Substance',
      ClubCategory.firstAid => isAmharic ? 'የመጀመሪያ እርዳታ' : 'First Aid',
      ClubCategory.girlsHygiene => isAmharic ? 'የሴቶች ንፅህና' : 'Girls\' Hygiene',
      ClubCategory.peerLeadership => isAmharic ? 'የአቻ አመራር' : 'Peer Leadership',
    };
  }

  IconData get icon {
    return switch (this) {
      ClubCategory.all => Icons.grid_view_rounded,
      ClubCategory.mentalHealth => Icons.psychology_rounded,
      ClubCategory.srhWellness => Icons.favorite_rounded,
      ClubCategory.antiSubstance => Icons.health_and_safety_rounded,
      ClubCategory.firstAid => Icons.medical_services_rounded,
      ClubCategory.girlsHygiene => Icons.spa_rounded,
      ClubCategory.peerLeadership => Icons.groups_rounded,
    };
  }

  Color get color {
    return switch (this) {
      ClubCategory.all => const Color(0xFF0284C7),
      ClubCategory.mentalHealth => const Color(0xFF6366F1),
      ClubCategory.srhWellness => const Color(0xFFF43F5E),
      ClubCategory.antiSubstance => const Color(0xFFF59E0B),
      ClubCategory.firstAid => const Color(0xFF10B981),
      ClubCategory.girlsHygiene => const Color(0xFFEC4899),
      ClubCategory.peerLeadership => const Color(0xFF0284C7),
    };
  }

  List<Color> get gradientColors {
    return switch (this) {
      ClubCategory.all => const [Color(0xFF0284C7), Color(0xFF38BDF8)],
      ClubCategory.mentalHealth => const [Color(0xFF4F46E5), Color(0xFF818CF8)],
      ClubCategory.srhWellness => const [Color(0xFFE11D48), Color(0xFFFB7185)],
      ClubCategory.antiSubstance => const [Color(0xFFD97706), Color(0xFFFBBF24)],
      ClubCategory.firstAid => const [Color(0xFF059669), Color(0xFF34D399)],
      ClubCategory.girlsHygiene => const [Color(0xFFDB2777), Color(0xFFF472B6)],
      ClubCategory.peerLeadership => const [Color(0xFF0284C7), Color(0xFF38BDF8)],
    };
  }
}
