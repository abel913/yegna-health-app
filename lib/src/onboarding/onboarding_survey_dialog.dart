import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'onboarding_survey_models.dart';
import 'onboarding_survey_repository.dart';

/// Interactive stacked-card modal dialog presenting baseline assessment questions
/// dynamically fetched from the database / admin portal, faithfully styled after
/// the user's reference mockup.
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

  List<DynamicSurveyQuestion> _questions = OnboardingSurveyRepository.defaultQuestions;
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
    final questions = await _repo.getSurveyQuestions();
    if (mounted && questions.isNotEmpty) {
      setState(() {
        _questions = questions;
      });
    }
  }

  DynamicSurveyQuestion? get _currentQuestion =>
      _questions.isNotEmpty && _currentIndex < _questions.length
          ? _questions[_currentIndex]
          : null;

  void _next() {
    if (_isSubmitting) return;
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _submit();
    }
  }

  void _back() {
    if (_isSubmitting) return;
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
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
    setState(() {
      _isSubmitting = true;
    });

    // Extract backwards-compatible legacy fields if present
    String age = '21–24';
    String year = '1st Year';
    String disability = 'NONE';
    String gondarSrh = 'NOT_SURE';

    for (final q in _questions) {
      final answer = _selectedAnswers[q.id];
      if (answer == null) continue;
      final t = q.titleEn.toLowerCase();
      if (t.contains('age')) {
        age = answer;
      } else if (t.contains('year of study')) {
        year = answer;
      } else if (t.contains('disability') || t.contains('accessibility')) {
        disability = answer;
      } else if (t.contains('gondar') || t.contains('srh')) {
        gondarSrh = answer;
      }
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
      await _repo.saveAnswers(
        answers,
        userId: widget.userId,
        authToken: widget.authToken,
      );
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
    return _selectedAnswers.containsKey(q.id) &&
        (_selectedAnswers[q.id]?.isNotEmpty ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Stacked card layer 3 (furthest back)
              Positioned.fill(
                child: Transform.rotate(
                  angle: -0.045,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                          : Colors.white.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Stacked card layer 2 (middle layer)
              Positioned.fill(
                child: Transform.rotate(
                  angle: 0.032,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF334155).withValues(alpha: 0.85)
                          : Colors.white.withValues(alpha: 0.82),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Stacked card layer 1 (foreground main card)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFF1F5F9),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.45 : 0.16),
                      blurRadius: 32,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.04, 0),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  ),
                  child: _isSubmitted
                      ? _buildCompletionCard(context, l10n, isDark)
                      : _buildQuestionCard(context, l10n, isDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(
      BuildContext context, AppLocalizations l10n, bool isDark) {
    final q = _currentQuestion;
    if (q == null) return const SizedBox.shrink();

    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    final total = _questions.length;

    return Column(
      key: ValueKey<int>(_currentIndex),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: Progress segmented dashes + (✕) Close button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Dynamic Segmented Dashes
            Expanded(
              child: Row(
                children: List.generate(total, (index) {
                  final isPassed = index <= _currentIndex;
                  return Expanded(
                    child: Container(
                      height: 4.5,
                      margin: EdgeInsets.only(right: index < total - 1 ? 6 : 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        gradient: isPassed
                            ? const LinearGradient(
                                colors: [Color(0xFFFF7A59), Color(0xFFFF5252)],
                              )
                            : null,
                        color: isPassed
                            ? null
                            : (isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFE2E8F0)),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Top Right Close/Skip Icon Button
            InkWell(
              onTap: _skip,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: isDark ? Colors.white70 : const Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Monospace Question Counter: Q.01 .. Q.0N
        Text(
          l10n.onboardingSurveyQuestionNumber('0${_currentIndex + 1}'),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            fontFamily: 'monospace',
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 8),

        // Main Question Heading (English or Amharic)
        Text(
          q.localizedTitle(isAmharic),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            height: 1.3,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),

        // Subtitle: SELECT ONLY 1 / SELECT ALL THAT APPLY
        Text(
          q.type == 'MULTI_CHOICE'
              ? 'SELECT ALL THAT APPLY'
              : l10n.onboardingSurveySelectOnlyOne,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            fontFamily: 'monospace',
            color: Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 10),

        // Dynamic Options List
        ...q.options.map((opt) {
          final isSelected = _selectedAnswers[q.id] == opt.value;
          return _optionRow(
            code: opt.value,
            label: opt.localizedLabel(isAmharic),
            isSelected: isSelected,
            onSelect: (v) {
              setState(() {
                _selectedAnswers[q.id] = v;
              });
            },
            isDark: isDark,
          );
        }),
        const SizedBox(height: 24),

        // Bottom Navigation Bar: [Back] ... [Next / Finish]
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button
            TextButton(
              onPressed: _currentIndex > 0 ? _back : null,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF64748B),
                disabledForegroundColor: Colors.transparent,
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Text(_currentIndex > 0 ? l10n.onboardingSurveyBack : ''),
            ),

            // Next / Finish Button (High-contrast rounded black pill)
            ElevatedButton(
              onPressed: _canProceed() && !_isSubmitting ? _next : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark ? Colors.white : const Color(0xFF0F172A),
                foregroundColor:
                    isDark ? const Color(0xFF0F172A) : Colors.white,
                disabledBackgroundColor:
                    isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                disabledForegroundColor:
                    isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isSubmitting && _currentIndex == total - 1
                  ? SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: isDark ? const Color(0xFF0F172A) : Colors.white,
                      ),
                    )
                  : Text(
                      _currentIndex == total - 1
                          ? l10n.onboardingSurveyFinish
                          : l10n.onboardingSurveyNext,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _optionRow({
    required String code,
    required String label,
    required bool isSelected,
    required ValueChanged<String> onSelect,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onSelect(code),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              children: [
                // Radio indicator: Filled solid indigo circle with checkmark when selected
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? const Color(0xFF3F51B5) // Indigo/purple accent
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF3F51B5)
                          : (isDark
                              ? const Color(0xFF64748B)
                              : const Color(0xFF94A3B8)),
                      width: 1.8,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 12),

                // Option Label
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isDark
                          ? (isSelected ? Colors.white : Colors.white70)
                          : (isSelected
                              ? const Color(0xFF0F172A)
                              : const Color(0xFF334155)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionCard(
      BuildContext context, AppLocalizations l10n, bool isDark) {
    final knowsGondar = _selectedAnswers.values.any((v) => v == 'YES');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            size: 38,
            color: Color(0xFF10B981),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.onboardingSurveyCompletedTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.onboardingSurveyCompletedBody,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.4,
            color: isDark ? Colors.white70 : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 20),

        // If they did not know where Gondar SRH services are, show shortcut to campus map
        if (!knowsGondar && widget.onOpenFacilities != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_hospital_rounded,
                  color: Color(0xFF00897B),
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.onboardingSurveyViewGondarClinic,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    widget.onOpenFacilities?.call();
                  },
                  child: const Icon(Icons.arrow_forward_rounded, size: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Close / Continue to Home button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
              foregroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              l10n.homeTab,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
