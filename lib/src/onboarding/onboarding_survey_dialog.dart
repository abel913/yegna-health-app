import 'package:flutter/material.dart';

import 'onboarding_survey_models.dart';
import 'onboarding_survey_repository.dart';
import 'widgets/onboarding_completion_card.dart';
import 'widgets/onboarding_question_card.dart';
import 'widgets/onboarding_stacked_card_shell.dart';

/// Interactive stacked-card modal dialog presenting baseline assessment questions.
class OnboardingSurveyDialog extends StatefulWidget {
  const OnboardingSurveyDialog({
    this.repository,
    this.userId,
    this.authToken,
    this.onCompleted,
    this.onDismissed,
    this.onOpenFacilities,
    super.key,
  });

  final OnboardingSurveyRepository? repository;
  final String? userId;
  final String? authToken;
  final ValueChanged<OnboardingSurveyAnswers>? onCompleted;
  final VoidCallback? onDismissed;
  final VoidCallback? onOpenFacilities;

  @override
  State<OnboardingSurveyDialog> createState() => _OnboardingSurveyDialogState();
}

class _OnboardingSurveyDialogState extends State<OnboardingSurveyDialog> {
  late final OnboardingSurveyRepository _repo;
  List<DynamicSurveyQuestion> _questions =
      OnboardingSurveyRepository.defaultQuestions.take(4).toList();
  int _currentIndex = 0;
  final Map<String, String> _selectedAnswers = {};
  bool _isSubmitted = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _repo = widget.repository ?? OnboardingSurveyRepository();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await _repo.getBaselineSurveyQuestions();
    if (mounted && questions.isNotEmpty) {
      setState(() => _questions = questions.take(4).toList());
    }
  }

  DynamicSurveyQuestion? get _currentQuestion =>
      _questions.isNotEmpty && _currentIndex < _questions.length
          ? _questions[_currentIndex]
          : null;

  void _next() {
    if (_isSubmitting) return;
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _submit();
    }
  }

  void _back() {
    if (_isSubmitting) return;
    if (_currentIndex > 0) setState(() => _currentIndex--);
  }

  Future<void> _skip() async {
    if (_isSubmitting) return;
    await _repo.skipForNow(userId: widget.userId);
    if (mounted) {
      widget.onDismissed?.call();
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future<void> _submit() async {
    if (_isSubmitting || _isSubmitted) return;
    setState(() => _isSubmitting = true);

    String age = '21–24';
    String year = '1st Year';
    String disability = 'NONE';
    String gondarSrh = 'NOT_SURE';

    for (final q in _questions) {
      final answer = _selectedAnswers[q.id];
      if (answer == null) continue;
      final t = q.titleEn.toLowerCase();
      if (t.contains('age')) age = answer;
      if (t.contains('year of study')) year = answer;
      if (t.contains('disability') || t.contains('accessibility')) disability = answer;
      if (t.contains('gondar') || t.contains('srh')) gondarSrh = answer;
    }

    final answers = OnboardingSurveyAnswers(
      ageGroup: age,
      yearOfStudy: year,
      disabilityNeed: disability,
      knowsGondarSrh: gondarSrh,
      dynamicAnswers: Map.unmodifiable(_selectedAnswers),
      completedAt: DateTime.now(),
    );

    try {
      await _repo.saveAnswers(answers, userId: widget.userId, authToken: widget.authToken);
      widget.onCompleted?.call(answers);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _isSubmitted = true;
        });
      }
    }
  }

  bool _canProceed() {
    final q = _currentQuestion;
    if (q == null) return false;
    if (!q.isRequired) return true;
    return _selectedAnswers.containsKey(q.id) && (_selectedAnswers[q.id]?.isNotEmpty ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final q = _currentQuestion;

    return OnboardingStackedCardShell(
      isDark: isDark,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        child: _isSubmitted
            ? OnboardingCompletionCard(
                isDark: isDark,
                knowsGondar: _selectedAnswers.values.any((v) => v == 'YES'),
                onOpenFacilities: widget.onOpenFacilities,
              )
            : (q == null
                ? const SizedBox.shrink()
                : OnboardingQuestionCard(
                    question: q,
                    currentIndex: _currentIndex,
                    totalQuestions: _questions.length,
                    selectedAnswers: _selectedAnswers,
                    isSubmitting: _isSubmitting,
                    canProceed: _canProceed(),
                    isDark: isDark,
                    onSelectAnswer: (id, val) => setState(() => _selectedAnswers[id] = val),
                    onNext: _next,
                    onBack: _back,
                    onSkip: _skip,
                  )),
      ),
    );
  }
}
