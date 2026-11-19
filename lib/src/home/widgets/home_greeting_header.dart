import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../auth/auth_controller.dart';
import '../../theme/app_glass_theme.dart';
import 'deep_glass_container.dart';
import 'home_feature_badge.dart';

/// Dynamic Greeting Header in Deep Glass (Single clean Account CTA & no duplicates)
class HomeGreetingHeader extends StatelessWidget {
  const HomeGreetingHeader({
    required this.greeting,
    required this.onOpenAccount,
    this.authController,
    super.key,
  });

  final String greeting;
  final VoidCallback onOpenAccount;
  final AuthController? authController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = authController;

    if (auth != null) {
      return ListenableBuilder(
        listenable: auth,
        builder: (context, _) {
          final user = auth.user;
          final isAuthed = auth.isAuthenticated;
          final displayName =
              (isAuthed && user != null && user.displayName.trim().isNotEmpty)
                  ? user.displayName.trim()
                  : null;
          return _buildContent(context, displayName, l10n);
        },
      );
    }

    return _buildContent(context, null, l10n);
  }

  Widget _buildContent(
    BuildContext context,
    String? displayName,
    AppLocalizations l10n,
  ) {
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    final titleText = displayName != null && displayName.isNotEmpty
        ? '$greeting, $displayName! 👋'
        : '$greeting! 👋';

    return DeepGlassContainer(
      borderRadius: 28,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildBrandBadge(glass, isDark),
              const SizedBox(width: 8),
              _buildAccountButton(l10n),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            titleText,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: glass.titleText,
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.guestGreetingSubtitle,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: glass.subtitleText,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              HomeFeatureBadge(
                icon: Icons.shield_outlined,
                text: l10n.confidentialPill,
              ),
              HomeFeatureBadge(
                icon: Icons.auto_stories_outlined,
                text: l10n.reviewedPill,
              ),
              HomeFeatureBadge(
                icon: Icons.check_circle_outline_rounded,
                text: l10n.guestReadyPill,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBrandBadge(AppGlassTheme glass, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF38BDF8).withValues(alpha: 0.3) : const Color(0xFFBAE6FD),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_rounded, size: 15, color: glass.accentColor),
          const SizedBox(width: 5),
          Text(
            'Yegna Health',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0369A1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountButton(AppLocalizations l10n) {
    return Flexible(
      child: InkWell(
        onTap: onOpenAccount,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  l10n.accountTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_rounded, size: 13, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
