import 'package:flutter/material.dart';

/// Displayed when no assessment questions are found for a selected section.
class ModuleAssessmentEmptyView extends StatelessWidget {
  const ModuleAssessmentEmptyView({required this.isAmharic, super.key});

  final bool isAmharic;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.info_outline_rounded, size: 48, color: Colors.amber),
        const SizedBox(height: 14),
        Text(
          isAmharic
              ? 'ምንም የዚህ ክፍል ጥያቄዎች አልተገኙም'
              : 'No questions currently available for this section.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(isAmharic ? 'ዝጋ' : 'Close'),
        ),
      ],
    );
  }
}
