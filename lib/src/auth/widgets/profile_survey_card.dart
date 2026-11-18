import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../onboarding/onboarding_survey_dialog.dart';
import '../../onboarding/onboarding_survey_repository.dart';
import '../auth_models.dart';

class ProfileSurveyCard extends StatelessWidget {
  const ProfileSurveyCard({
    required this.user,
    required this.onSurveyCompleted,
    super.key,
  });

  final AuthUser user;
  final VoidCallback onSurveyCompleted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder<bool>(
      future: OnboardingSurveyRepository().isCompleted(user: user),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            const SizedBox(height: 12),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: 'Dismiss Survey',
                    barrierColor: Colors.black.withValues(alpha: 0.38),
                    transitionDuration: const Duration(milliseconds: 320),
                    pageBuilder: (dialogCtx, anim1, anim2) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                        child: OnboardingSurveyDialog(
                          userId: user.id,
                          onCompleted: (_) => onSurveyCompleted(),
                        ),
                      );
                    },
                    transitionBuilder: (dialogCtx, anim, _, child) {
                      return ScaleTransition(
                        scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
                        child: FadeTransition(opacity: anim, child: child),
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.20),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.assignment_outlined,
                          color: Color(0xFF0284C7),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.onboardingSurveySubtitle,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF08264A),
                              ),
                            ),
                            Text(
                              l10n.onboardingSurveyTitle,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Color(0xFF0284C7),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
