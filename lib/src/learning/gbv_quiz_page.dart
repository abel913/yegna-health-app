import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'dynamic_quiz_helper.dart';
import 'learning_progress_controller.dart';

typedef _QuizQuestion = QuizQuestionModel;

final List<_QuizQuestion> _kGbvQuizQuestions = [
  // 1. Definition & Scope of GBV (True / False)
  _QuizQuestion(
    id: 'gbv-q1',
    category: (l10n) => l10n.gbvSection1Title,
    questionText: (l10n) => l10n.gbvQ1Text,
    options: [
      (l10n) => l10n.trueOption,
      (l10n) => l10n.falseOption,
    ],
    correctIndex: 0, // True
    insight: (l10n) => l10n.gbvQ1Insight,
  ),
  // 2. Immediate Survivor Care (Multiple Choice)
  _QuizQuestion(
    id: 'gbv-q2',
    category: (l10n) => l10n.gbvSection4Title,
    questionText: (l10n) => l10n.gbvQ2Text,
    options: [
      (l10n) => l10n.gbvQ2OptA,
      (l10n) => l10n.gbvQ2OptB,
      (l10n) => l10n.gbvQ2OptC,
      (l10n) => l10n.gbvQ2OptD,
    ],
    correctIndex:
        0, // OptA: Ensure safety and seek confidential medical care (PEP within 72h)
    insight: (l10n) => l10n.gbvQ2Insight,
  ),
  // 3. Engaging Men and Boys (Multiple Choice)
  _QuizQuestion(
    id: 'gbv-q3',
    category: (l10n) => l10n.gbvSection4Title,
    questionText: (l10n) => l10n.gbvQ3Text,
    options: [
      (l10n) => l10n.gbvQ3OptA,
      (l10n) => l10n.gbvQ3OptB,
      (l10n) => l10n.gbvQ3OptC,
      (l10n) => l10n.gbvQ3OptD,
    ],
    correctIndex:
        0, // OptA: Promote respectful relationships and speak out against abuse
    insight: (l10n) => l10n.gbvQ3Insight,
  ),
  // 4. Zero Tolerance & No Blame (True / False)
  _QuizQuestion(
    id: 'gbv-q4',
    category: (l10n) => l10n.gbvSection3Title,
    questionText: (l10n) => l10n.gbvQ4Text,
    options: [
      (l10n) => l10n.trueOption,
      (l10n) => l10n.falseOption,
    ],
    correctIndex: 0, // True
    insight: (l10n) => l10n.gbvQ4Insight,
  ),
];

/// Interactive Gender-Based Violence (GBV) Module Quiz Screen.
class GbvQuizPage extends StatefulWidget {
  const GbvQuizPage({
    required this.progressController,
    this.questions,
    super.key,
  });

  final LearningProgressController progressController;
  final List<QuizQuestionModel>? questions;

  @override
  State<GbvQuizPage> createState() => _GbvQuizPageState();
}

class _GbvQuizPageState extends State<GbvQuizPage> {
  late List<QuizQuestionModel> _questions;
  int _currentIndex = 0;
  final Map<int, int> _selectedAnswers = {};
  bool _isFinished = false;
  bool _isReviewing = false;

  @override
  void initState() {
    super.initState();
    _questions = widget.questions ?? _kGbvQuizQuestions;
    _loadDynamicQuestions();
  }

  Future<void> _loadDynamicQuestions() async {
    if (widget.questions != null) return;
    final cached = await DynamicQuizHelper.loadFromCache(
      moduleId: 'module-04',
      category: 'gbv',
    );
    if (cached != null && cached.isNotEmpty && mounted) {
      setState(() {
        _questions = cached;
      });
    }
  }

  void _handleOptionSelected(int optionIndex) {
    if (_isFinished && !_isReviewing) return;
    setState(() {
      _selectedAnswers[_currentIndex] = optionIndex;
    });
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
      setState(() {
        _currentIndex++;
      });
    } else {
      _finishQuiz();
    }
  }

  void _handlePrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  Future<void> _finishQuiz() async {
    final locale = Localizations.localeOf(context).languageCode;
    await widget.progressController.markArticleComplete('module-04', locale);

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F9FD),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF005A71),
            size: 24,
          ),
          onPressed: () {
            if (_isReviewing) {
              setState(() {
                _isReviewing = false;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          l10n.gbvQuizTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF005A71),
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: _isFinished && !_isReviewing
            ? _buildCelebrationView(context, l10n)
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
        // Top Header: Progress Pill & Category Tag
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCEEFA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  l10n.questionProgress(_currentIndex + 1, total),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF005A71),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Spacer(),
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFD6E4F0)),
                  ),
                  child: Text(
                    question.category(l10n),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Segmented Progress Bar (4 segments)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: List.generate(total, (i) {
              final isFilled = i <= _currentIndex;
              return Expanded(
                child: Container(
                  height: 4.5,
                  margin: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
                  decoration: BoxDecoration(
                    color: isFilled
                        ? const Color(0xFF0284C7)
                        : const Color(0xFFD6E4F0),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ),

        // Scrollable Question Card & Options
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0xFFD6E8F6),
                      width: 1.4,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A005A71),
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    question.questionText(l10n),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF08264A),
                      height: 1.4,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Answer Options List
                ...List.generate(question.options.length, (optIdx) {
                  final isSelected = selectedOption == optIdx;
                  final letter = String.fromCharCode(65 + optIdx);
                  final isReviewCorrect =
                      _isReviewing && optIdx == question.correctIndex;
                  final isReviewWrong = _isReviewing &&
                      isSelected &&
                      optIdx != question.correctIndex;

                  Color bgColor = Colors.white;
                  Color borderColor = const Color(0xFFD6E8F6);
                  Color textColor = const Color(0xFF1E293B);

                  if (isReviewCorrect) {
                    bgColor = const Color(0xFFF0FDF4);
                    borderColor = const Color(0xFF22C55E);
                    textColor = const Color(0xFF15803D);
                  } else if (isReviewWrong) {
                    bgColor = const Color(0xFFFEF2F2);
                    borderColor = const Color(0xFFEF4444);
                    textColor = const Color(0xFFB91C1C);
                  } else if (isSelected) {
                    bgColor = const Color(0xFFF0F9FF);
                    borderColor = const Color(0xFF0284C7);
                    textColor = const Color(0xFF0369A1);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: _isReviewing
                          ? null
                          : () => _handleOptionSelected(optIdx),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: borderColor,
                            width: isSelected || isReviewCorrect ? 1.8 : 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isReviewCorrect
                                    ? const Color(0xFF16A34A)
                                    : isReviewWrong
                                        ? const Color(0xFFDC2626)
                                        : isSelected
                                            ? const Color(0xFF0284C7)
                                            : const Color(0xFFF1F5F9),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                letter,
                                style: TextStyle(
                                  color: isSelected ||
                                          isReviewCorrect ||
                                          isReviewWrong
                                      ? Colors.white
                                      : const Color(0xFF64748B),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                question.options[optIdx](l10n),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected || isReviewCorrect
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: textColor,
                                  height: 1.35,
                                ),
                              ),
                            ),
                            if (isReviewCorrect)
                              const Icon(Icons.check_circle_rounded,
                                  color: Color(0xFF16A34A), size: 22)
                            else if (isReviewWrong)
                              const Icon(Icons.cancel_rounded,
                                  color: Color(0xFFDC2626), size: 22),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                // Educational Insight in Review Mode
                if (_isReviewing) ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFBBF7D0),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.lightbulb_rounded,
                                color: Color(0xFF16A34A), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              l10n.educationalInsight,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF166534),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          question.insight(l10n),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1E293B),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Bottom Controls Bar
        Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            boxShadow: [
              BoxShadow(
                color: Color(0x0C003648),
                blurRadius: 12,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Circular Back Arrow Button
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFD6E4F0),
                    width: 1.2,
                  ),
                ),
                child: IconButton(
                  style: IconButton.styleFrom(
                    foregroundColor: const Color(0xFF005A71),
                    shape: const CircleBorder(),
                  ),
                  icon: const Icon(Icons.arrow_back_rounded, size: 22),
                  onPressed: _currentIndex > 0 ? _handlePrevious : null,
                ),
              ),
              const SizedBox(width: 14),

              // Large Floating Action Pill
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: selectedOption != null
                        ? const Color(0xFF0284C7)
                        : const Color(0xFF90B9DE),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  onPressed: () => _handleNext(l10n),
                  child: Row(
                    children: [
                      const Spacer(),
                      Text(
                        isLast ? l10n.finishQuizBtn : l10n.nextQuestionBtn,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: selectedOption != null
                              ? const Color(0xFF0284C7)
                              : const Color(0xFF90B9DE),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCelebrationView(BuildContext context, AppLocalizations l10n) {
    final score = _calculateScore();
    final total = _questions.length;
    final percent = ((score / total) * 100).round();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Celebration Trophy & Halo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFBAE6FD),
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.emoji_events_rounded,
                color: Color(0xFF0284C7),
                size: 52,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              l10n.quizScoreCelebration,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF08264A),
              ),
            ),
            const SizedBox(height: 8),

            Text(
              l10n.quizScoreSummary(score, total, percent),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 28),

            // Review Answers Button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                label: Text(
                  l10n.reviewAnswersBtn,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                    _isReviewing = true;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),

            // Retake Quiz Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF005A71),
                  side: const BorderSide(color: Color(0xFF005A71), width: 1.4),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: Text(
                  l10n.retakeQuizBtn,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onPressed: _retakeQuiz,
              ),
            ),
            const SizedBox(height: 12),

            // Tertiary: Return to Lesson
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.returnToLesson,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
