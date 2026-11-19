import 'package:flutter/material.dart';

import '../onboarding/onboarding_survey_models.dart';
import '../onboarding/onboarding_survey_repository.dart';
import 'widgets/module_assessment_completion_card.dart';
import 'widgets/module_assessment_question_view.dart';

/// Reusable stacked-card modal dialog presenting University of Gondar module assessments.
class ModuleAssessmentDialog extends StatefulWidget {
  const ModuleAssessmentDialog({
    required this.sectionNumber,
    required this.sectionKey,
    required this.moduleKey,
    required this.titleEn,
    required this.titleAm,
    this.fallbackQuestions = const [],
    this.repository,
    this.onCompleted,
    super.key,
  });

  final int sectionNumber;
  final String sectionKey;
  final String moduleKey;
  final String titleEn;
  final String titleAm;
  final List<DynamicSurveyQuestion> fallbackQuestions;
  final OnboardingSurveyRepository? repository;
  final VoidCallback? onCompleted;

  static Future<void> show(
    BuildContext context, {
    required int sectionNumber,
    required String sectionKey,
    required String moduleKey,
    required String titleEn,
    required String titleAm,
    List<DynamicSurveyQuestion> fallbackQuestions = const [],
    VoidCallback? onCompleted,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => ModuleAssessmentDialog(
        sectionNumber: sectionNumber,
        sectionKey: sectionKey,
        moduleKey: moduleKey,
        titleEn: titleEn,
        titleAm: titleAm,
        fallbackQuestions: fallbackQuestions,
        onCompleted: onCompleted,
      ),
    );
  }

  @override
  State<ModuleAssessmentDialog> createState() => _ModuleAssessmentDialogState();
}

class _ModuleAssessmentDialogState extends State<ModuleAssessmentDialog> {
  late final OnboardingSurveyRepository _repo;
  List<DynamicSurveyQuestion> _questions = [];
  int _currentIndex = 0;
  final Map<String, String> _selectedAnswers = {};
  bool _isLoading = true;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _repo = widget.repository ?? OnboardingSurveyRepository();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() => _isLoading = true);
    final loaded = await _repo.getSurveyQuestions(
      sectionNumber: widget.sectionNumber,
      moduleKey: widget.moduleKey,
    );

    if (mounted) {
      setState(() {
        if (loaded.isNotEmpty) {
          _questions = loaded;
        } else if (widget.fallbackQuestions.isNotEmpty) {
          _questions = widget.fallbackQuestions;
        }
        _isLoading = false;
      });
    }
  }

  DynamicSurveyQuestion? get _currentQuestion =>
      _questions.isNotEmpty && _currentIndex < _questions.length
          ? _questions[_currentIndex]
          : null;

  void _next() {
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      setState(() => _isCompleted = true);
      widget.onCompleted?.call();
    }
  }

  void _back() {
    if (_currentIndex > 0) setState(() => _currentIndex--);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(26, 22, 26, 26),
            child: _isLoading
                ? const SizedBox(
                    height: 260,
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
                  )
                : _isCompleted
                    ? ModuleAssessmentCompletionCard(isDark: isDark, isAmharic: isAmharic)
                    : _buildContent(isDark, isAmharic),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isDark, bool isAmharic) {
    final question = _currentQuestion;
    if (question == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.info_outline_rounded, size: 48, color: Colors.amber),
          const SizedBox(height: 14),
          Text(
            isAmharic ? 'ምንም የዚህ ክፍል ጥያቄዎች አልተገኙም' : 'No questions currently available for this section.',
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

    return ModuleAssessmentQuestionView(
      question: question,
      currentIndex: _currentIndex,
      totalQuestions: _questions.length,
      selectedOption: _selectedAnswers[question.id],
      titleEn: widget.titleEn,
      titleAm: widget.titleAm,
      isDark: isDark,
      isAmharic: isAmharic,
      onSelectOption: (val) => setState(() => _selectedAnswers[question.id] = val),
      onNext: _next,
      onBack: _back,
      onClose: () => Navigator.of(context).pop(),
    );
  }
}
