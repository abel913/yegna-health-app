import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../auth_models.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.user, super.key});
  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.70),
                width: 2.0,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x350284C7),
                  blurRadius: 16,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user.email,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF08264A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.profileDescription,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF4A6277),
            ),
          ),
        ],
      ),
    );
  }
}
