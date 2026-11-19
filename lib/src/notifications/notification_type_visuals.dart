import 'package:flutter/material.dart';

import 'notification_models.dart';

/// Presentation visuals (icon and gradient) for each [NotificationType].
extension NotificationTypeVisuals on NotificationType {
  IconData get icon {
    switch (this) {
      case NotificationType.welcome:
        return Icons.waving_hand_rounded;
      case NotificationType.account:
        return Icons.celebration_rounded;
      case NotificationType.learning:
        return Icons.school_rounded;
      case NotificationType.healthTip:
        return Icons.lightbulb_rounded;
      case NotificationType.system:
        return Icons.info_outline_rounded;
    }
  }

  LinearGradient get gradient {
    switch (this) {
      case NotificationType.welcome:
        return const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case NotificationType.account:
        return const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case NotificationType.learning:
        return const LinearGradient(
          colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case NotificationType.healthTip:
        return const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case NotificationType.system:
        return const LinearGradient(
          colors: [Color(0xFF007A78), Color(0xFF005A71)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}
