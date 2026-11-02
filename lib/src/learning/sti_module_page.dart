import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'assessment_repository.dart';
import 'learning_progress_controller.dart';

/// Detailed clinical and educational learning page for Module 02:
/// Sexual transmitted infections (STI).
///
/// Features high-contrast typography, authentic illustrations, dynamic reading progress,
/// and 6 clinical accordion sections:
/// 1. Definition (Pathogens, STI vs. STD distinction, asymptomatic frequency)
/// 2. Signs and Symptoms of STI (Discharge, dysuria, ulcers, silent presentation)
/// 3. Diagnosis of STI (Clinical exam, lab testing, national syndromic management)
/// 4. Complications of STI (PID, infertility, elevated HIV risk, oncogenic HPV)
/// 5. Management and treatment of STI (Curable bacterial vs manageable viral, 4 critical rules)
/// 6. Prevention of STI (Condom barrier protection, fidelity, abstinence, vaccines)
class StiModuleDetailPage extends StatefulWidget {
  const StiModuleDetailPage({
    required this.progressController,
    this.assessmentRepository,
    this.onOpenQuiz,
    super.key,
  });

  final LearningProgressController progressController;
  final AssessmentRepository? assessmentRepository;
  final VoidCallback? onOpenQuiz;

  @override
  State<StiModuleDetailPage> createState() => _StiModuleDetailPageState();
}

class _StiModuleDetailPageState extends State<StiModuleDetailPage> {
  // Expansion state for the 6 accordion sections.
  final Set<int> _expandedSections = <int>{};

  // Track sections read by user (defaults to 4 read matching the reference screenshot).
  final Set<int> _readSections = <int>{1, 2, 4, 5};

  Future<void> _markCompleted(
      BuildContext context, AppLocalizations l10n) async {
    final locale = Localizations.localeOf(context).languageCode;
    await widget.progressController.markArticleComplete('module-02', locale);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Text(l10n.moduleCompletedSuccess),
          ],
        ),
        backgroundColor: const Color(0xFF00796B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.learningModulesTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF005A71),
            fontSize: 18,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.progressController,
        builder: (context, _) {
          final isCompleted = widget.progressController.progress?.articles
                  .any((a) => a.articleId == 'module-02') ??
              false;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Hero Card with Medical Illustration & Summary
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: const Color(0xFFD6E8F6),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF005A71).withValues(alpha: 0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Center(
                          child: Image.asset(
                            'assets/images/learning/module_02_sti.png',
                            height: 195,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        l10n.module02Title,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF08264A),
                          letterSpacing: -0.3,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.stiHeroDesc,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF475569),
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Note Section
                Row(
                  children: [
                    Container(
                      width: 3.5,
                      height: 18,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.hivNoteTitle,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF08264A),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF5FB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFBAE6FD).withValues(alpha: 0.65),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD0E8F8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lightbulb_outline_rounded,
                          color: Color(0xFF0284C7),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.stiNoteContent,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF1E293B),
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Learning Sections Header with Reading Progress Pill
                Row(
                  children: [
                    Container(
                      width: 3.5,
                      height: 18,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.learningSectionsTitle,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF08264A),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCEEFA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        l10n.readSectionsCount(_readSections.length, 6),
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF005A71),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Section 1: Definition
                _StiAccordionCard(
                  sectionNumber: 1,
                  title: l10n.stiDefinitionTitle,
                  isExpanded: _expandedSections.contains(0),
                  isRead: _readSections.contains(0),
                  onToggle: () {
                    setState(() {
                      _readSections.add(0);
                      if (_expandedSections.contains(0)) {
                        _expandedSections.remove(0);
                      } else {
                        _expandedSections.add(0);
                      }
                    });
                  },
                  children: [
                    Text(
                      l10n.stiDefinitionSubtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.stiDefinitionDesc1,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.stiDefinitionDesc2,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.verified_rounded,
                            color: Color(0xFF16A34A),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.stiDefinitionDesc3,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF166534),
                                height: 1.45,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Section 2: Signs and Symptoms of STI
                _StiAccordionCard(
                  sectionNumber: 2,
                  title: l10n.stiSymptomsTitle,
                  isExpanded: _expandedSections.contains(1),
                  isRead: _readSections.contains(1),
                  onToggle: () {
                    setState(() {
                      _readSections.add(1);
                      if (_expandedSections.contains(1)) {
                        _expandedSections.remove(1);
                      } else {
                        _expandedSections.add(1);
                      }
                    });
                  },
                  children: [
                    Text(
                      l10n.stiSymptomsSubtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.stiSymptomsIntro,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _StiBulletItem(body: l10n.stiSymptom1),
                    const SizedBox(height: 8),
                    _StiBulletItem(body: l10n.stiSymptom2),
                    const SizedBox(height: 8),
                    _StiBulletItem(body: l10n.stiSymptom3),
                    const SizedBox(height: 8),
                    _StiBulletItem(body: l10n.stiSymptom4),
                    const SizedBox(height: 8),
                    _StiBulletItem(body: l10n.stiSymptom5),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFED7AA)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Color(0xFFEA580C),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l10n.stiSymptomsAsymptomaticAlert,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF9A3412),
                                height: 1.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Section 3: Diagnosis of STI
                _StiAccordionCard(
                  sectionNumber: 3,
                  title: l10n.stiDiagnosisTitle,
                  isExpanded: _expandedSections.contains(2),
                  isRead: _readSections.contains(2),
                  onToggle: () {
                    setState(() {
                      _readSections.add(2);
                      if (_expandedSections.contains(2)) {
                        _expandedSections.remove(2);
                      } else {
                        _expandedSections.add(2);
                      }
                    });
                  },
                  children: [
                    Text(
                      l10n.stiDiagnosisSubtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.stiDiagnosisIntro,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _StiBulletItem(body: l10n.stiDiagnosisItem1),
                    const SizedBox(height: 8),
                    _StiBulletItem(body: l10n.stiDiagnosisItem2),
                    const SizedBox(height: 8),
                    _StiBulletItem(body: l10n.stiDiagnosisItem3),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.lock_outline_rounded,
                            color: Color(0xFF16A34A),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.stiDiagnosisYouthFriendly,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF166534),
                                height: 1.45,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Section 4: Complications of STI
                _StiAccordionCard(
                  sectionNumber: 4,
                  title: l10n.stiComplicationsTitle,
                  isExpanded: _expandedSections.contains(3),
                  isRead: _readSections.contains(3),
                  onToggle: () {
                    setState(() {
                      _readSections.add(3);
                      if (_expandedSections.contains(3)) {
                        _expandedSections.remove(3);
                      } else {
                        _expandedSections.add(3);
                      }
                    });
                  },
                  children: [
                    Text(
                      l10n.stiComplicationsSubtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.stiComplicationsIntro,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _StiBulletItem(body: l10n.stiComplication1),
                    const SizedBox(height: 8),
                    _StiBulletItem(body: l10n.stiComplication2),
                    const SizedBox(height: 8),
                    _StiBulletItem(body: l10n.stiComplication3),
                    const SizedBox(height: 8),
                    _StiBulletItem(body: l10n.stiComplication4),
                  ],
                ),

                // Section 5: Management and treatment of STI
                _StiAccordionCard(
                  sectionNumber: 5,
                  title: l10n.stiTreatmentTitle,
                  isExpanded: _expandedSections.contains(4),
                  isRead: _readSections.contains(4),
                  onToggle: () {
                    setState(() {
                      _readSections.add(4);
                      if (_expandedSections.contains(4)) {
                        _expandedSections.remove(4);
                      } else {
                        _expandedSections.add(4);
                      }
                    });
                  },
                  children: [
                    Text(
                      l10n.stiTreatmentSubtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.stiTreatmentDesc1,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.stiTreatmentDesc2,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Important Rules for Effective STI Recovery:',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _StiNumberedRuleItem(
                        number: 1, text: l10n.stiTreatmentRule1),
                    _StiNumberedRuleItem(
                        number: 2, text: l10n.stiTreatmentRule2),
                    _StiNumberedRuleItem(
                        number: 3, text: l10n.stiTreatmentRule3),
                    _StiNumberedRuleItem(
                        number: 4, text: l10n.stiTreatmentRule4),
                  ],
                ),

                // Section 6: Prevention of STI
                _StiAccordionCard(
                  sectionNumber: 6,
                  title: l10n.stiPreventionTitle,
                  isExpanded: _expandedSections.contains(5),
                  isRead: _readSections.contains(5),
                  onToggle: () {
                    setState(() {
                      _readSections.add(5);
                      if (_expandedSections.contains(5)) {
                        _expandedSections.remove(5);
                      } else {
                        _expandedSections.add(5);
                      }
                    });
                  },
                  children: [
                    Text(
                      l10n.stiPreventionSubtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.stiPreventionIntro,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _StiAlphaBadgeItem(
                        letter: 'A', text: l10n.stiPreventionItem1),
                    _StiAlphaBadgeItem(
                        letter: 'B', text: l10n.stiPreventionItem2),
                    _StiAlphaBadgeItem(
                        letter: 'C', text: l10n.stiPreventionItem3),
                    _StiAlphaBadgeItem(
                        letter: 'D', text: l10n.stiPreventionItem4),
                    _StiAlphaBadgeItem(
                        letter: 'E', text: l10n.stiPreventionItem5),
                    _StiAlphaBadgeItem(
                        letter: 'F', text: l10n.stiPreventionItem6),
                  ],
                ),
                const SizedBox(height: 24),

                // Completion State and Quiz Actions
                if (isCompleted)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFA5D6A7),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF2E7D32),
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.completedStatus,
                          style: const TextStyle(
                            color: Color(0xFF1B5E20),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.check_circle_outline_rounded),
                      label: Text(
                        l10n.markCompleted,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      onPressed: () => _markCompleted(context, l10n),
                    ),
                  ),

                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF005A71),
                      side: const BorderSide(
                        color: Color(0xFF005A71),
                        width: 1.4,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: Text(
                      l10n.returnToLesson,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Dynamic accordion dropdown card matching the reference screenshot:
/// shows solid blue badge with section number if unread, or white checkmark if read!
class _StiAccordionCard extends StatelessWidget {
  const _StiAccordionCard({
    required this.sectionNumber,
    required this.title,
    required this.isExpanded,
    required this.isRead,
    required this.onToggle,
    required this.children,
  });

  final int sectionNumber;
  final String title;
  final bool isExpanded;
  final bool isRead;
  final VoidCallback onToggle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD6E4F0),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08003648),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onToggle,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0284C7),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: isRead
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 20,
                            )
                          : Text(
                              '$sectionNumber',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15.5,
                          color: Color(0xFF08264A),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 240),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF005A71),
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 240),
          ),
        ],
      ),
    );
  }
}

/// Alphabetical circular badge item (A, B, C, D, E, F) matching the reference design.
class _StiAlphaBadgeItem extends StatelessWidget {
  const _StiAlphaBadgeItem({
    required this.letter,
    required this.text,
  });

  final String letter;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: Color(0xFF0284C7),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              letter,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFF1E293B),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Numbered badge item for critical medical rules.
class _StiNumberedRuleItem extends StatelessWidget {
  const _StiNumberedRuleItem({
    required this.number,
    required this.text,
  });

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: Color(0xFF005A71),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFF1E293B),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bullet item for STI symptoms and clinical diagnostic modalities.
class _StiBulletItem extends StatelessWidget {
  const _StiBulletItem({
    required this.body,
  });

  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(
            Icons.circle,
            size: 7,
            color: Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            body,
            style: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFF334155),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
