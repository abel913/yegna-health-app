import 'package:flutter/material.dart';

import '../../learning/assessment_repository.dart';
import '../../learning/data/bundled_learning_modules.dart';
import '../../learning/education_repository.dart';
import '../../learning/learning_progress_controller.dart';
import '../../learning/models/learning_module_item.dart';
import '../../learning/screens/learning_module_navigator.dart';
import '../../learning/sync_education_repository.dart';
import 'home_learning_module_modal.dart';
import 'home_learning_module_tile.dart';

class HomeLearningCarousel extends StatelessWidget {
  const HomeLearningCarousel({
    required this.locale,
    required this.onOpenLearning,
    this.educationRepository,
    this.progressController,
    this.assessmentRepository,
    super.key,
  });

  final Locale locale;
  final VoidCallback onOpenLearning;
  final EducationRepository? educationRepository;
  final LearningProgressController? progressController;
  final AssessmentRepository? assessmentRepository;

  void _handleModuleTap(BuildContext context, LearningModuleItem module) {
    final isAmharic = locale.languageCode == 'am';
    final isCompleted = progressController?.progress?.articles
            .any((a) => a.articleId == module.id) ??
        false;
    HomeLearningModuleModal.show(
      context,
      module: module,
      isAmharic: isAmharic,
      isCompleted: isCompleted,
      onOpenLearning: onOpenLearning,
      onOpenDetail: progressController != null
          ? () => LearningModuleNavigator.openModule(
                context: context,
                module: module,
                progressController: progressController!,
                assessmentRepository: assessmentRepository,
                onOpenDynamicQuiz: onOpenLearning,
              )
          : null,
    );
  }

  Widget _buildCarousel(BuildContext context, Set<String> completedIds) {
    final isAmharic = locale.languageCode == 'am';
    final repo = educationRepository;

    Widget buildFuture() {
      return FutureBuilder<List<LearningModuleItem>>(
        future: (repo is SyncEducationRepository)
            ? repo.getCurriculumModuleItems()
            : null,
        initialData: kLearningModules,
        builder: (context, snapshot) {
          final modules = snapshot.data ?? kLearningModules;
          return SizedBox(
            height: 255,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: modules.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final module = modules[index];
                final isCompleted = completedIds.contains(module.id);
                return HomeLearningModuleTile(
                  module: module,
                  isCompleted: isCompleted,
                  isAmharic: isAmharic,
                  onTap: () => _handleModuleTap(context, module),
                );
              },
            ),
          );
        },
      );
    }

    if (repo is Listenable) {
      return ListenableBuilder(
        listenable: repo as Listenable,
        builder: (context, _) => buildFuture(),
      );
    }

    return buildFuture();
  }

  @override
  Widget build(BuildContext context) {
    if (progressController != null) {
      return ListenableBuilder(
        listenable: progressController!,
        builder: (context, _) {
          final completed = progressController?.progress?.articles
                  .map((a) => a.articleId)
                  .toSet() ??
              const <String>{};
          return _buildCarousel(context, completed);
        },
      );
    }

    return _buildCarousel(context, const {});
  }
}
