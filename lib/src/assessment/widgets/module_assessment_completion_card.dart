import 'package:flutter/material.dart';

import '../campus_focal_persons_card.dart';

/// Completion card shown at the end of a module assessment with focal person CTA.
class ModuleAssessmentCompletionCard extends StatelessWidget {
  const ModuleAssessmentCompletionCard({
    required this.isDark,
    required this.isAmharic,
    super.key,
  });

  final bool isDark;
  final bool isAmharic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 40),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          isAmharic ? 'ምዘናውን በተሳካ ሁኔታ አጠናቀዋል!' : 'Self-Assessment Complete!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isAmharic
              ? 'ይህ ምዘና ከጎንደር ዩኒቨርሲቲ የተማሪዎች ደህንነት መመሪያ ጋር የተጣጣመ ነው። ሚስጥራዊ ድጋፍ ወይም የጤና ምርመራ ካስፈለገዎት የግቢዎን አስተባባሪ ያግኙ።'
              : 'Thank you for reflecting on your health. Your answers are 100% confidential. Campus focal persons and clinics are available across all UoG campuses for private support.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (ctx) => DraggableScrollableSheet(
                  initialChildSize: 0.75,
                  minChildSize: 0.5,
                  maxChildSize: 0.95,
                  builder: (_, scrollController) => Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: CampusFocalPersonsCard(isAmharic: isAmharic),
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.contact_phone_rounded, size: 18),
            label: Text(
              isAmharic ? 'የግቢ አስተባባሪዎችን እይ' : 'View Campus Focal Persons',
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(isAmharic ? 'ጨርስ' : 'Done'),
          ),
        ),
      ],
    );
  }
}
