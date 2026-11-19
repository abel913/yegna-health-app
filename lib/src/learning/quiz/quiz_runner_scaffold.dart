import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../dynamic_quiz_helper.dart';
import '../learning_progress_controller.dart';
import 'quiz_bottom_bar.dart';
import 'quiz_header_bar.dart';
import 'quiz_question_card.dart';
import 'quiz_results_card.dart';

class QuizRunnerScaffold extends StatefulWidget {
  const QuizRunnerScaffold({
    required this.title,
    required this.moduleId,
    required this.category,
    required this.defaultQuestions,
    required this.progressController,
    this.questions,
    super.key,
  });

  final String Function(AppLocalizations) title;
  final String moduleId;
  final String category;
  final List<QuizQuestionModel> defaultQuestions;
  final LearningProgressController progressController;
  final List<QuizQuestionModel>? questions;

  @override
  State<QuizRunnerScaffold> createState() => _QuizRunnerScaffoldState();
}

class _QuizRunnerScaffoldState extends State<QuizRunnerScaffold> {
  late List<QuizQuestionModel> _questions;
  int _currentIndex = 0;
  final Map<int, int> _selectedAnswers = {};
  bool _isFinished = false;
  bool _isReviewing = false;

  @override
  void initState() {
    super.initState();
    _questions = widget.questions ?? widget.defaultQuestions;
    _loadDynamicQuestions();
  }

  Future<void> _loadDynamicQuestions() async {
    if (widget.questions != null) return;
    final cached = await DynamicQuizHelper.loadFromCache(
      moduleId: widget.moduleId,
      category: widget.category,
    );
    if (cached != null && cached.isNotEmpty && mounted) {
      setState(() => _questions = cached);
    }
  }

  void _handleOptionSelected(int optionIndex) {
    if (_isFinished && !_isReviewing) return;
    setState(() => _selectedAnswers[_currentIndex] = optionIndex);
  }

  void _handleNext(AppLocalizations l10n) {
    if (!_selectedAnswers.containsKey(_currentIndex)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectAnOptionHint),
          backgroundColor: const Color(0xFF0284C7),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _finishQuiz();
    }
  }

  void _handlePrevious() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  Future<void> _finishQuiz() async {
    final locale = Localizations.localeOf(context).languageCode;
    await widget.progressController.markArticleComplete(widget.moduleId, locale);
    if (!mounted) return;
    setState(() {
      _isFinished = true;
      _isReviewing = false;
    });
  }

  void _retakeQuiz() {
    setState(() {
      _currentIndex = 0;
      _selectedAnswers.clear();
      _isFinished = false;
      _isReviewing = false;
    });
  }

  int _calculateScore() {
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i].correctIndex) {
        score++;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FD),
      appBar: QuizRunnerAppBar(
        titleText: widget.title(l10n),
        onBack: () {
          if (_isReviewing) {
            setState(() => _isReviewing = false);
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      body: SafeArea(
        child: _isFinished && !_isReviewing
            ? QuizResultsCard(
                score: _calculateScore(),
                total: _questions.length,
                l10n: l10n,
                onReview: () => setState(() {
                  _currentIndex = 0;
                  _isReviewing = true;
                }),
                onRetake: _retakeQuiz,
                onReturn: () => Navigator.of(context).pop(),
              )
            : _buildQuestionView(context, l10n),
      ),
    );
  }

  Widget _buildQuestionView(BuildContext context, AppLocalizations l10n) {
    final question = _questions[_currentIndex];
    final selectedOption = _selectedAnswers[_currentIndex];
    final total = _questions.length;
    final isLast = _currentIndex == total - 1;

    return Column(
      children: [
        QuizHeaderBar(
          currentIndex: _currentIndex,
          total: total,
          categoryText: question.category(l10n),
          l10n: l10n,
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: QuizQuestionCard(
              question: question,
              selectedOption: selectedOption,
              isReviewing: _isReviewing,
              l10n: l10n,
              onOptionSelected: _handleOptionSelected,
            ),
          ),
        ),
        QuizBottomBar(
          currentIndex: _currentIndex,
          isLast: isLast,
          hasSelectedOption: selectedOption != null,
          l10n: l10n,
          onPrevious: _handlePrevious,
          onNext: () => _handleNext(l10n),
        ),
      ],
    );
  }
}
