import 'package:flutter/material.dart';

import '../onboarding/onboarding_survey_models.dart';
import '../onboarding/onboarding_survey_repository.dart';
import 'campus_focal_persons_card.dart';

/// Reusable stacked-card modal dialog presenting University of Gondar
/// module-specific self-assessments (e.g., HIV & STIs, Contraception, Mental Health, GBV).
/// Matches the exact visual stacked-card language of the onboarding survey (Image 1).
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
      setState(() {
        _currentIndex++;
      });
    } else {
      setState(() {
        _isCompleted = true;
      });
      widget.onCompleted?.call();
    }
  }

  void _back() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: _buildCardContainer(
            theme: theme,
            isDark: isDark,
            isAmharic: isAmharic,
          ),
        ),
      ),
    );
  }

  Widget _buildCardContainer({
    required ThemeData theme,
    required bool isDark,
    required bool isAmharic,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(26, 22, 26, 26),
      child: _isLoading
          ? const SizedBox(
              height: 260,
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            )
          : _isCompleted
              ? _buildCompletionCard(theme, isDark, isAmharic)
              : _buildQuestionCard(theme, isDark, isAmharic),
    );
  }

  Widget _buildQuestionCard(ThemeData theme, bool isDark, bool isAmharic) {
    final question = _currentQuestion;
    if (question == null) {
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

    final total = _questions.length;
    final currentQNumber = _currentIndex + 1;
    final selectedOption = _selectedAnswers[question.id];
    final hasSelection = selectedOption != null && selectedOption.isNotEmpty;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. TOP HEADER: Segmented Progress Bar & Close Button
          Row(
            children: [
              Expanded(
                child: Row(
                  children: List.generate(total, (idx) {
                    final isCurrent = idx == _currentIndex;
                    final isDone = idx < _currentIndex;
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(right: idx < total - 1 ? 6 : 0),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? const Color(0xFFFF5252)
                              : isDone
                                  ? const Color(0xFF10B981)
                                  : (isDark
                                      ? Colors.white.withValues(alpha: 0.15)
                                      : const Color(0xFFE2E8F0)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 14),
              Material(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFF1F5F9),
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding: EdgeInsets.all(7),
                    child: Icon(Icons.close_rounded, size: 18, color: Color(0xFF64748B)),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 2. SECTION BADGE & QUESTION NUMBER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isAmharic ? widget.titleAm : widget.titleEn,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0284C7),
                  ),
                ),
              ),
              Text(
                'Q.${currentQNumber.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 3. QUESTION PROMPT
          Text(
            question.localizedTitle(isAmharic),
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              height: 1.35,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 8),

          // 4. INSTRUCTION
          Text(
            isAmharic ? 'አንድ አማራጭ ብቻ ይምረጡ' : 'SELECT ONLY 1',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              letterSpacing: 1.1,
            ),
          ),

          const SizedBox(height: 18),

          // 5. CHOICES
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: question.options.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, optIdx) {
              final opt = question.options[optIdx];
              final isSelected = selectedOption == opt.value;

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedAnswers[question.id] = opt.value;
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark
                              ? const Color(0xFF0284C7).withValues(alpha: 0.15)
                              : const Color(0xFFF0F9FF))
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.04)
                              : const Color(0xFFF8FAFC)),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF0284C7)
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : const Color(0xFFE2E8F0)),
                        width: isSelected ? 1.8 : 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF0284C7)
                                  : const Color(0xFF94A3B8),
                              width: 2,
                            ),
                            color: isSelected
                                ? const Color(0xFF0284C7)
                                : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Center(
                                  child: Icon(Icons.check, size: 14, color: Colors.white),
                                )
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            opt.localizedLabel(isAmharic),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected
                                  ? (isDark ? Colors.white : const Color(0xFF0284C7))
                                  : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // 6. ACTION FOOTER: Back (if applicable) & Next / Submit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentIndex > 0)
                TextButton(
                  onPressed: _back,
                  child: Text(
                    isAmharic ? 'ተመለስ' : 'Back',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
              ElevatedButton(
                onPressed: hasSelection ? _next : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasSelection
                      ? const Color(0xFF0284C7)
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                  foregroundColor: Colors.white,
                  disabledForegroundColor: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: hasSelection ? 2 : 0,
                ),
                child: Text(
                  currentQNumber == total
                      ? (isAmharic ? 'አጠናቅቅ' : 'Complete')
                      : (isAmharic ? 'ቀጣይ' : 'Next'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionCard(ThemeData theme, bool isDark, bool isAmharic) {
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
