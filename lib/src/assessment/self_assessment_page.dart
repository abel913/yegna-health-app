import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

import 'self_assessment_models.dart';

class SelfAssessmentPage extends StatefulWidget {
  const SelfAssessmentPage({
    super.key,
    this.onOpenMentors,
    this.onOpenFacilities,
    this.onOpenLearning,
  });

  final VoidCallback? onOpenMentors;
  final VoidCallback? onOpenFacilities;
  final VoidCallback? onOpenLearning;

  @override
  State<SelfAssessmentPage> createState() => _SelfAssessmentPageState();
}

class _SelfAssessmentPageState extends State<SelfAssessmentPage> {
  int _currentIndex = 0;
  final Map<String, bool> _answers = {};
  bool _isCompleted = false;
  late final List<SelfAssessmentQuestionItem> _questions;

  @override
  void initState() {
    super.initState();
    _questions = getSelfAssessmentQuestions();
  }

  void _selectAnswer(bool value) {
    setState(() {
      final currentQuestion = _questions[_currentIndex];
      _answers[currentQuestion.id] = value;
    });
  }

  void _onNext(AppLocalizations l10n) {
    final currentQuestion = _questions[_currentIndex];
    if (!_answers.containsKey(currentQuestion.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectAnswerPrompt),
          backgroundColor: const Color(0xFF0284C7),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      setState(() {
        _isCompleted = true;
      });
    }
  }

  void _onPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  Future<void> _confirmRestart(AppLocalizations l10n) async {
    if (_answers.isEmpty && !_isCompleted) {
      return;
    }
    final shouldRestart = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.restartAssessmentDialogTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Text(l10n.restartAssessmentDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancelAction),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(l10n.restartAction),
          ),
        ],
      ),
    );

    if (shouldRestart == true) {
      _restartAssessment();
    }
  }

  void _restartAssessment() {
    setState(() {
      _currentIndex = 0;
      _answers.clear();
      _isCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final evaluation = evaluateAssessment(_questions, _answers);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () {
            if (_isCompleted) {
              _restartAssessment();
            } else if (_currentIndex > 0) {
              _onPrevious();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          l10n.selfAssessmentHeading,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 19,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
        centerTitle: true,
        actions: [
          // Notification bell with red badge "2" matching screenshot
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded,
                    color: Color(0xFF0F172A)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.chatbotDisclaimer),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Refresh/Restart icon button matching screenshot
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0F172A)),
            tooltip: l10n.retakeAssessmentAction,
            onPressed: () => _confirmRestart(l10n),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: _isCompleted
            ? _buildResultView(l10n, evaluation)
            : _buildQuestionView(l10n),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // QUESTION VIEW (Screenshots 1 & 2)
  // ---------------------------------------------------------------------------
  Widget _buildQuestionView(AppLocalizations l10n) {
    final currentQuestion = _questions[_currentIndex];
    final selectedAnswer = _answers[currentQuestion.id];
    final hasSelected = selectedAnswer != null;
    final isLast = _currentIndex == _questions.length - 1;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  // 1. Question Counter Pill (e.g. "Question 1 of 12")
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l10n.selfAssessmentQuestionProgress(
                              _currentIndex + 1, _questions.length),
                          style: const TextStyle(
                            color: Color(0xFF0284C7),
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Category Tag Pill
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Text(
                            currentQuestion.category(l10n),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF475569),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 2. Segmented Progress Bar (12 segments matching screenshots)
                  Row(
                    children: List.generate(_questions.length, (index) {
                      final isFilled = index <= _currentIndex;
                      return Expanded(
                        child: Container(
                          height: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: isFilled
                                ? const Color(0xFF0284C7)
                                : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // 3. Question Card (White rounded card with shadow)
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x08000000),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentQuestion.title(l10n),
                          style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 18.5,
                            fontWeight: FontWeight.w700,
                            height: 1.45,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // "Why this matters" educational tip card
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.lightbulb_outline_rounded,
                                color: Color(0xFF0284C7),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.whyThisMattersLabel,
                                      style: const TextStyle(
                                        color: Color(0xFF0284C7),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      currentQuestion.why(l10n),
                                      style: const TextStyle(
                                        color: Color(0xFF475569),
                                        fontSize: 13,
                                        height: 1.4,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 4. Option: Yes
                  _buildOptionCard(
                    label: l10n.yesOption,
                    isSelected: selectedAnswer == true,
                    onTap: () => _selectAnswer(true),
                  ),
                  const SizedBox(height: 14),

                  // 5. Option: No
                  _buildOptionCard(
                    label: l10n.noOption,
                    isSelected: selectedAnswer == false,
                    onTap: () => _selectAnswer(false),
                  ),
                ],
              ),
            ),

            // 6. Bottom Navigation Controls (Screenshot 1 & 2)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                children: [
                  // Circular Back Button
                  InkWell(
                    onTap: _currentIndex > 0 ? _onPrevious : null,
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: _currentIndex > 0
                              ? const Color(0xFFE2E8F0)
                              : const Color(0xFFF1F5F9),
                          width: 1.5,
                        ),
                        boxShadow: _currentIndex > 0
                            ? const [
                                BoxShadow(
                                  color: Color(0x0C000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: _currentIndex > 0
                            ? const Color(0xFF0284C7)
                            : const Color(0xFFCBD5E1),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Stadium Pill "Next" / "View Results" Button
                  Expanded(
                    child: InkWell(
                      onTap: () => _onNext(l10n),
                      borderRadius: BorderRadius.circular(32),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 54,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          gradient: hasSelected
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF38BDF8),
                                    Color(0xFF0284C7)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : const LinearGradient(
                                  colors: [
                                    Color(0xFF93C5FD),
                                    Color(0xFF60A5FA)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          boxShadow: hasSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF0284C7)
                                        .withValues(alpha: 0.35),
                                    blurRadius: 14,
                                    offset: const Offset(0, 6),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                isLast
                                    ? l10n.viewResultsAction
                                    : l10n.nextQuestionAction,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Embedded white circle with arrow forward icon matching screenshot
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                color: Color(0xFF0284C7),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Option Card (Yes / No)
  Widget _buildOptionCard({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F9FF) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF0284C7) : const Color(0xFFE2E8F0),
            width: isSelected ? 2.0 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0x180284C7)
                  : const Color(0x06000000),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Circular Radio / Checkmark Icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFF0284C7) : Colors.white,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0284C7)
                      : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      size: 18, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF0284C7)
                      : const Color(0xFF0F172A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // RESULT VIEW (Screenshots 3 & 4)
  // ---------------------------------------------------------------------------
  Widget _buildResultView(
      AppLocalizations l10n, SelfAssessmentEvaluation evaluation) {
    final (
      resultTitle,
      keyMessage,
      badgeColor,
      badgeIcon,
      badgeBorderColor,
      actions,
    ) = _getResultConfiguration(l10n, evaluation.tier);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
          children: [
            // 1. Assessment Result Card (Matching Screenshot 3)
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 18,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Circular Result Icon
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: badgeColor,
                          border:
                              Border.all(color: badgeBorderColor, width: 1.5),
                        ),
                        child:
                            Icon(badgeIcon, color: badgeBorderColor, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.assessmentResultHeader,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              resultTitle,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                                height: 1.25,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Risk score pill & visual bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          l10n.riskScoreLabel(
                              evaluation.score, evaluation.maxScore),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF334155),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${evaluation.answeredYesCount} / ${evaluation.totalQuestions} Yes',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: evaluation.scoreRatio.clamp(0.05, 1.0),
                      minHeight: 8,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(badgeBorderColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Recommended Actions Section (Vertical Stepper / Timeline)
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.recommendedActionsHeader,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Connected Vertical Stepper matching Screenshot 3
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: List.generate(actions.length, (index) {
                  final actionText = actions[index];
                  final isLastItem = index == actions.length - 1;

                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Blue Circle Step Badge
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF0284C7),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Action Text
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                actionText,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                  height: 1.45,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (!isLastItem)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 15, top: 4, bottom: 4),
                            width: 2,
                            height: 24,
                            color: const Color(0xFFBAE6FD),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),

            // 3. Key Message Card (Matching Screenshot 3)
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        '““',
                        style: TextStyle(
                          color: Color(0xFF0284C7),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.keyMessageHeader,
                        style: const TextStyle(
                          color: Color(0xFF0284C7),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    keyMessage,
                    style: const TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. Action Cards: "Talk to Mentor" & "Get Service" (Screenshot 4)
            Row(
              children: [
                Expanded(
                  child: _buildActionDestinationCard(
                    icon: Icons.support_agent_rounded,
                    iconBgColor: const Color(0xFFFDF2F8),
                    iconColor: const Color(0xFFDB2777),
                    title: l10n.talkToMentorAction,
                    subtitle: l10n.talkToMentorSubtitle,
                    onTap: () {
                      if (widget.onOpenMentors != null) {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                        widget.onOpenMentors!.call();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildActionDestinationCard(
                    icon: Icons.local_hospital_rounded,
                    iconBgColor: const Color(0xFFF0FDF4),
                    iconColor: const Color(0xFF16A34A),
                    title: l10n.getServiceAction,
                    subtitle: l10n.getServiceSubtitle,
                    onTap: () {
                      if (widget.onOpenFacilities != null) {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                        widget.onOpenFacilities!.call();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // 5. Retake Assessment Button
            OutlinedButton.icon(
              onPressed: _restartAssessment,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(l10n.retakeAssessmentAction),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0284C7),
                side: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 16),

            // 6. Educational Disclaimer Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.verified_user_outlined,
                    color: Color(0xFF64748B),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.assessmentEducationalDisclaimer,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Result card helper
  Widget _buildActionDestinationCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                color: Color(0xFF64748B),
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tier configuration mapping
  (
    String title,
    String message,
    Color bg,
    IconData icon,
    Color border,
    List<String> actions,
  ) _getResultConfiguration(AppLocalizations l10n, RiskTier tier) {
    switch (tier) {
      case RiskTier.higherRisk:
        return (
          l10n.higherRiskTitle,
          l10n.highRiskKeyMessage,
          const Color(0xFFFEF3C7),
          Icons.info_outline_rounded,
          const Color(0xFFB45309),
          [
            l10n.highRiskAction1,
            l10n.highRiskAction2,
            l10n.highRiskAction3,
            l10n.highRiskAction4,
          ],
        );
      case RiskTier.moderateRisk:
        return (
          l10n.moderateRiskTitle,
          l10n.moderateRiskKeyMessage,
          const Color(0xFFFEF9C3),
          Icons.shield_outlined,
          const Color(0xFFCA8A04),
          [
            l10n.modRiskAction1,
            l10n.modRiskAction2,
            l10n.modRiskAction3,
          ],
        );
      case RiskTier.lowerRisk:
        return (
          l10n.lowerRiskTitle,
          l10n.lowerRiskKeyMessage,
          const Color(0xFFDCFCE7),
          Icons.verified_user_rounded,
          const Color(0xFF16A34A),
          [
            l10n.lowRiskAction1,
            l10n.lowRiskAction2,
            l10n.lowRiskAction3,
          ],
        );
    }
  }
}
