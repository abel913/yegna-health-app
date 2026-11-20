import 'package:flutter/material.dart';

import '../module_assessment_dialog.dart';
import '../screens/assessment_result_screen.dart';
import 'assessment_result_evaluator.dart';

/// Helper for transitioning cleanly from the question dialog to the result screen.
class AssessmentFlowNavigator {
  const AssessmentFlowNavigator._();

  static void openResult({
    required BuildContext context,
    required int sectionNumber,
    required String titleEn,
    required String titleAm,
    required String sectionKey,
    required String moduleKey,
    required Map<String, String> answers,
    VoidCallback? onCompleted,
    VoidCallback? onOpenMentors,
    VoidCallback? onOpenFacilities,
  }) {
    final resultData = AssessmentResultEvaluator.evaluate(
      sectionNumber: sectionNumber,
      sectionTitleEn: titleEn,
      sectionTitleAm: titleAm,
      answers: answers,
    );

    Navigator.of(context).pop();
    onCompleted?.call();

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AssessmentResultScreen(
          resultData: resultData,
          onOpenMentors: onOpenMentors,
          onOpenFacilities: onOpenFacilities,
          onRetake: () {
            Navigator.of(context).pop();
            ModuleAssessmentDialog.show(
              context,
              sectionNumber: sectionNumber,
              sectionKey: sectionKey,
              moduleKey: moduleKey,
              titleEn: titleEn,
              titleAm: titleAm,
              onOpenMentors: onOpenMentors,
              onOpenFacilities: onOpenFacilities,
              onCompleted: onCompleted,
            );
          },
        ),
      ),
    );
  }
}
