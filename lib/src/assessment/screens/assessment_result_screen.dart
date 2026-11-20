import 'package:flutter/material.dart';

import '../models/assessment_result_data.dart';
import '../widgets/assessment_action_shortcuts.dart';
import '../widgets/assessment_actions_stepper.dart';
import '../widgets/assessment_key_message_card.dart';
import '../widgets/assessment_result_header_card.dart';

/// Clinical self-assessment results screen with tailored counseling and direct CTAs.
class AssessmentResultScreen extends StatelessWidget {
  const AssessmentResultScreen({
    required this.resultData,
    this.onOpenMentors,
    this.onOpenFacilities,
    this.onRetake,
    super.key,
  });

  final AssessmentResultData resultData;
  final VoidCallback? onOpenMentors;
  final VoidCallback? onOpenFacilities;
  final VoidCallback? onRetake;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAmharic ? 'የራስ-ምዘና ውጤት' : 'Self-Assessment',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded, size: 22),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 22),
            onPressed: onRetake ?? () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AssessmentResultHeaderCard(
                  resultData: resultData,
                  isDark: isDark,
                  isAmharic: isAmharic,
                ),
                const SizedBox(height: 24),
                AssessmentActionsStepper(
                  actions: resultData.localizedActions(isAmharic),
                  isDark: isDark,
                  isAmharic: isAmharic,
                ),
                const SizedBox(height: 24),
                AssessmentKeyMessageCard(
                  message: resultData.localizedKeyMessage(isAmharic),
                  isDark: isDark,
                  isAmharic: isAmharic,
                ),
                const SizedBox(height: 24),
                AssessmentActionShortcuts(
                  onOpenMentors: onOpenMentors,
                  onOpenFacilities: onOpenFacilities,
                  isDark: isDark,
                  isAmharic: isAmharic,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      isAmharic ? 'ወደ ምዘና ማዕከል ተመለስ' : 'Return to Assessment Hub',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
