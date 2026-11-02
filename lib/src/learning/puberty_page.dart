import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'assessment_repository.dart';
import 'learning_progress_controller.dart';
import 'puberty_quiz_page.dart';

/// Detailed educational learning module page for Module 01:
/// Adolescent health & puberty.
///
/// Features authentic optical glass styling matching user reference screenshots:
/// 1. Understanding Puberty & Adolescence (Hormonal triggers, timing, variation)
/// 2. Physical Changes in Females & Males (Growth spurts, voice, hair, menstruation, nocturnal emissions)
/// 3. Emotional & Psychological Changes (Mood shifts, identity, independence, peer relationships)
/// 4. Hygiene & Self-Care during Adolescence (Bathing, skincare, menstrual hygiene, nutrition & sleep)
class PubertyDetailPage extends StatefulWidget {
  const PubertyDetailPage({
    required this.progressController,
    this.assessmentRepository,
    this.onOpenQuiz,
    super.key,
  });

  final LearningProgressController progressController;
  final AssessmentRepository? assessmentRepository;
  final VoidCallback? onOpenQuiz;

  @override
  State<PubertyDetailPage> createState() => _PubertyDetailPageState();
}

class _PubertyDetailPageState extends State<PubertyDetailPage> {
  final Set<int> _expandedSections = {0};
  final Set<int> _readSections = {0};

  Future<void> _markCompleted(
      BuildContext context, AppLocalizations l10n) async {
    final locale = Localizations.localeOf(context).languageCode;
    await widget.progressController.markArticleComplete('module-01', locale);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(l10n.moduleCompletedSuccess),
            ],
          ),
          backgroundColor: const Color(0xFF16A34A),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
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
                  .any((a) => a.articleId == 'module-01') ??
              false;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Hero Card with Illustration & Summary
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
                            'assets/images/learning/module_01_puberty.jpg',
                            height: 195,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        l10n.module01Title,
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
                        l10n.pubertyHeroDesc,
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

                // Note Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF7FD),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFFCFE5F7),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD8EDFB),
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
                          l10n.pubertyNoteText,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF1E3A5F),
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Learning Sections Header
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
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDF0FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l10n.readSectionsCount(_readSections.length, 4),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0369A1),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Section 1: Understanding Puberty & Adolescence
                _PubertyAccordionCard(
                  sectionNumber: 1,
                  title: l10n.pubertySection1Title,
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
                      l10n.pubertySection1Subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.pubertySection1Intro,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _PubertyBulletItem(body: l10n.pubertySection1Item1),
                    const SizedBox(height: 8),
                    _PubertyBulletItem(body: l10n.pubertySection1Item2),
                    const SizedBox(height: 8),
                    _PubertyBulletItem(body: l10n.pubertySection1Item3),
                  ],
                ),

                // Section 2: Physical Changes in Females & Males
                _PubertyAccordionCard(
                  sectionNumber: 2,
                  title: l10n.pubertySection2Title,
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
                      l10n.pubertySection2Subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.pubertySection2FemaleTitle,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _PubertyBulletItem(body: l10n.pubertySection2FemaleItem1),
                    const SizedBox(height: 6),
                    _PubertyBulletItem(body: l10n.pubertySection2FemaleItem2),
                    const SizedBox(height: 6),
                    _PubertyBulletItem(body: l10n.pubertySection2FemaleItem3),
                    const SizedBox(height: 14),
                    Text(
                      l10n.pubertySection2MaleTitle,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _PubertyBulletItem(body: l10n.pubertySection2MaleItem1),
                    const SizedBox(height: 6),
                    _PubertyBulletItem(body: l10n.pubertySection2MaleItem2),
                    const SizedBox(height: 6),
                    _PubertyBulletItem(body: l10n.pubertySection2MaleItem3),
                  ],
                ),

                // Section 3: Emotional & Psychological Changes
                _PubertyAccordionCard(
                  sectionNumber: 3,
                  title: l10n.pubertySection3Title,
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
                      l10n.pubertySection3Subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.pubertySection3Intro,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _PubertyBulletItem(body: l10n.pubertySection3Item1),
                    const SizedBox(height: 8),
                    _PubertyBulletItem(body: l10n.pubertySection3Item2),
                    const SizedBox(height: 8),
                    _PubertyBulletItem(body: l10n.pubertySection3Item3),
                    const SizedBox(height: 8),
                    _PubertyBulletItem(body: l10n.pubertySection3Item4),
                  ],
                ),

                // Section 4: Hygiene & Self-Care during Adolescence
                _PubertyAccordionCard(
                  sectionNumber: 4,
                  title: l10n.pubertySection4Title,
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
                      l10n.pubertySection4Subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _PubertyAlphaBadgeItem(
                        letter: 'A', text: l10n.pubertySection4Item1),
                    _PubertyAlphaBadgeItem(
                        letter: 'B', text: l10n.pubertySection4Item2),
                    _PubertyAlphaBadgeItem(
                        letter: 'C', text: l10n.pubertySection4Item3),
                    _PubertyAlphaBadgeItem(
                        letter: 'D', text: l10n.pubertySection4Item4),
                  ],
                ),
                const SizedBox(height: 24),

                // Completion State and Actions
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
                              builder: (_) => PubertyQuizPage(
                                progressController: widget.progressController,
                              ),
                            ),
                          );
                        },
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

/// Dynamic accordion dropdown card matching the reference screenshot design:
class _PubertyAccordionCard extends StatelessWidget {
  const _PubertyAccordionCard({
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
          color: isExpanded ? const Color(0xFFBAE6FD) : const Color(0xFFE2E8F0),
          width: isExpanded ? 1.4 : 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF005A71).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(20),
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

/// Standard bullet item component.
class _PubertyBulletItem extends StatelessWidget {
  const _PubertyBulletItem({required this.body});

  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 7, right: 10),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Color(0xFF0284C7),
            shape: BoxShape.circle,
          ),
        ),
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

/// Alphabetical circular badge item (A, B, C, D) matching the reference design.
class _PubertyAlphaBadgeItem extends StatelessWidget {
  const _PubertyAlphaBadgeItem({
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
                color: Color(0xFF334155),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
