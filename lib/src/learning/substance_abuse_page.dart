import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'assessment_repository.dart';
import 'learning_progress_controller.dart';
import 'substance_abuse_quiz_page.dart';

/// Detailed learning module screen for Module 08: Substance Abuse.
///
/// Features authentic optical styling matching user reference screenshots:
/// 1. Definition of substance abuse (Psychoactive substances & Substance Use Disorder)
/// 2. Types of drugs/Substances (Depressants, Stimulants, Opioids, Hallucinogens)
/// 3. Effects of substance abuse (Physical, mental, academic, legal, social impacts)
/// 4. Signs of a Substance Use Problem (Tolerance, cravings, withdrawal, support resources)
class SubstanceAbuseDetailPage extends StatefulWidget {
  const SubstanceAbuseDetailPage({
    required this.progressController,
    this.assessmentRepository,
    this.onOpenQuiz,
    super.key,
  });

  final LearningProgressController progressController;
  final AssessmentRepository? assessmentRepository;
  final VoidCallback? onOpenQuiz;

  @override
  State<SubstanceAbuseDetailPage> createState() =>
      _SubstanceAbuseDetailPageState();
}

class _SubstanceAbuseDetailPageState extends State<SubstanceAbuseDetailPage> {
  // Expansion state for the 4 accordion sections.
  final Set<int> _expandedSections = <int>{};

  // Track sections read by user.
  final Set<int> _readSections = <int>{};

  Future<void> _markCompleted(
      BuildContext context, AppLocalizations l10n) async {
    final locale = Localizations.localeOf(context).languageCode;
    await widget.progressController.markArticleComplete('module-08', locale);
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
                  .any((a) => a.articleId == 'module-08') ??
              false;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Hero Card with Educational Poster & Summary
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
                            'assets/images/learning/module_08_substance_abuse.png',
                            height: 195,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        l10n.module08Title,
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
                        l10n.substanceHeroDesc,
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
                          l10n.substanceNoteContent,
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
                        l10n.readSectionsCount(_readSections.length, 4),
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

                // Section 1: Definition of substance abuse
                _SubstanceAccordionCard(
                  sectionNumber: 1,
                  title: l10n.substanceDefTitle,
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
                      l10n.substanceDefDesc1,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.substanceDefDesc2,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
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
                            Icons.psychology_outlined,
                            color: Color(0xFF16A34A),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.substanceDefDesc3,
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

                // Section 2: Types of drugs/Substances
                _SubstanceAccordionCard(
                  sectionNumber: 2,
                  title: l10n.substanceTypesTitle,
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
                    _SubstanceNumberedBadgeItem(
                      number: 1,
                      text: l10n.substanceTypeDepressants,
                    ),
                    _SubstanceNumberedBadgeItem(
                      number: 2,
                      text: l10n.substanceTypeStimulants,
                    ),
                    _SubstanceNumberedBadgeItem(
                      number: 3,
                      text: l10n.substanceTypeOpioids,
                    ),
                    _SubstanceNumberedBadgeItem(
                      number: 4,
                      text: l10n.substanceTypeHallucinogens,
                    ),
                  ],
                ),

                // Section 3: Effects of substance abuse
                _SubstanceAccordionCard(
                  sectionNumber: 3,
                  title: l10n.substanceEffectsTitle,
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
                      l10n.substanceEffectsIntro,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SubstanceBulletItem(body: l10n.substanceEffect1),
                    const SizedBox(height: 8),
                    _SubstanceBulletItem(body: l10n.substanceEffect2),
                    const SizedBox(height: 8),
                    _SubstanceBulletItem(body: l10n.substanceEffect3),
                    const SizedBox(height: 8),
                    _SubstanceBulletItem(body: l10n.substanceEffect4),
                    const SizedBox(height: 8),
                    _SubstanceBulletItem(body: l10n.substanceEffect5),
                    const SizedBox(height: 8),
                    _SubstanceBulletItem(body: l10n.substanceEffect6),
                    const SizedBox(height: 8),
                    _SubstanceBulletItem(body: l10n.substanceEffect7),
                  ],
                ),

                // Section 4: Signs of a Substance Use Problem
                _SubstanceAccordionCard(
                  sectionNumber: 4,
                  title: l10n.substanceSignsTitle,
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
                      l10n.substanceSignsIntro,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SubstanceBulletItem(body: l10n.substanceSign1),
                    const SizedBox(height: 8),
                    _SubstanceBulletItem(body: l10n.substanceSign2),
                    const SizedBox(height: 8),
                    _SubstanceBulletItem(body: l10n.substanceSign3),
                    const SizedBox(height: 8),
                    _SubstanceBulletItem(body: l10n.substanceSign4),
                    const SizedBox(height: 8),
                    _SubstanceBulletItem(body: l10n.substanceSign5),
                    const SizedBox(height: 8),
                    _SubstanceBulletItem(body: l10n.substanceSign6),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.support_agent_rounded,
                            color: Color(0xFF16A34A),
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l10n.substanceSignsHelpAlert,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF166534),
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
                const SizedBox(height: 24),

                // Completion State and Return Actions
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
                    icon: const Icon(Icons.quiz_outlined),
                    label: Text(
                      l10n.takeQuizButton,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    onPressed: widget.onOpenQuiz ??
                        () {
                          Navigator.of(context).push<void>(
                            MaterialPageRoute<void>(
                              builder: (_) => SubstanceAbuseQuizPage(
                                progressController: widget.progressController,
                              ),
                            ),
                          );
                        },
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
/// displays solid blue circle with section number if unread, or checkmark if read.
class _SubstanceAccordionCard extends StatelessWidget {
  const _SubstanceAccordionCard({
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

/// Circular badge item with number (1, 2, 3, 4) for substance categories.
class _SubstanceNumberedBadgeItem extends StatelessWidget {
  const _SubstanceNumberedBadgeItem({
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
              color: Color(0xFF0284C7),
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

/// Bullet item for substance abuse effects and warning signs.
class _SubstanceBulletItem extends StatelessWidget {
  const _SubstanceBulletItem({
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
