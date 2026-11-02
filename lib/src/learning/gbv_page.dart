import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'assessment_repository.dart';
import 'learning_progress_controller.dart';

/// Detailed learning module screen for Module 04: Gender-based violence (GBV).
///
/// Features authentic optical styling matching user reference screenshots:
/// 1. Definition (Physical, Psychological, Sexual, Economic violence, Harmful traditional practices)
/// 2. Sex and Gender (Biological characteristics vs. social constructs, power imbalances)
/// 3. Consequences of gender-based violence (Physical, psychological, social & economic impacts)
/// 4. Management and Prevention of Gender-Based Violence (GBV) (Survivor-centered care, 72h PEP, helplines 952/8335/7711)
class GenderBasedViolenceDetailPage extends StatefulWidget {
  const GenderBasedViolenceDetailPage({
    required this.progressController,
    this.assessmentRepository,
    this.onOpenQuiz,
    super.key,
  });

  final LearningProgressController progressController;
  final AssessmentRepository? assessmentRepository;
  final VoidCallback? onOpenQuiz;

  @override
  State<GenderBasedViolenceDetailPage> createState() =>
      _GenderBasedViolenceDetailPageState();
}

class _GenderBasedViolenceDetailPageState
    extends State<GenderBasedViolenceDetailPage> {
  // Expansion state for the 4 accordion sections.
  final Set<int> _expandedSections = <int>{};

  // Track sections read by user.
  final Set<int> _readSections = <int>{};

  Future<void> _markCompleted(
      BuildContext context, AppLocalizations l10n) async {
    final locale = Localizations.localeOf(context).languageCode;
    await widget.progressController.markArticleComplete('module-04', locale);
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

  void _toggleSection(int sectionIndex) {
    setState(() {
      if (_expandedSections.contains(sectionIndex)) {
        _expandedSections.remove(sectionIndex);
      } else {
        _expandedSections.add(sectionIndex);
        _readSections.add(sectionIndex);
      }
    });
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
      body: AnimatedBuilder(
        animation: widget.progressController,
        builder: (context, _) {
          final isCompleted = widget.progressController.progress?.articles
                  .any((a) => a.articleId == 'module-04') ??
              false;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Hero Card with Clinical Illustration & Synopsis
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
                            'assets/images/learning/module_04_gbv.png',
                            height: 195,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        l10n.module04Title,
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
                        l10n.gbvHeroDesc,
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
                          l10n.gbvNoteContent,
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
                const SizedBox(height: 22),

                // 3. Learning Sections Header with dynamic reading count badge
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
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        l10n.readSectionsCount(_readSections.length, 4),
                        style: const TextStyle(
                          color: Color(0xFF0284C7),
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 4. Section 1 Accordion: Definition
                _GbvAccordionCard(
                  sectionNumber: 1,
                  title: l10n.gbvSection1Title,
                  isExpanded: _expandedSections.contains(1),
                  isRead: _readSections.contains(1),
                  onToggle: () => _toggleSection(1),
                  children: [
                    Text(
                      l10n.gbvSection1Desc1,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.gbvSection1Desc2,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 1: Physical Violence
                    _GbvNumberedCategory(
                      number: 1,
                      title: l10n.gbvForm1Title,
                      items: [
                        _GbvBulletItem(
                          boldPrefix: l10n.gbvForm1Item1Title,
                          body: l10n.gbvForm1Item1Body,
                        ),
                        _GbvBulletItem(
                          boldPrefix: l10n.gbvForm1Item2Title,
                          body: l10n.gbvForm1Item2Body,
                        ),
                      ],
                    ),

                    // 2: Psychological/Emotional Violence
                    _GbvNumberedCategory(
                      number: 2,
                      title: l10n.gbvForm2Title,
                      items: [
                        _GbvBulletItem(
                          boldPrefix: l10n.gbvForm2Item1Title,
                          body: l10n.gbvForm2Item1Body,
                        ),
                        _GbvBulletItem(
                          boldPrefix: l10n.gbvForm2Item2Title,
                          body: l10n.gbvForm2Item2Body,
                        ),
                        _GbvBulletItem(
                          boldPrefix: l10n.gbvForm2Item3Title,
                          body: l10n.gbvForm2Item3Body,
                        ),
                      ],
                    ),

                    // 3: Sexual Violence and Exploitation
                    _GbvNumberedCategory(
                      number: 3,
                      title: l10n.gbvForm3Title,
                      items: [
                        _GbvBulletItem(
                          boldPrefix: l10n.gbvForm3Item1Title,
                          body: l10n.gbvForm3Item1Body,
                        ),
                        _GbvBulletItem(
                          boldPrefix: l10n.gbvForm3Item2Title,
                          body: l10n.gbvForm3Item2Body,
                        ),
                        _GbvBulletItem(
                          boldPrefix: l10n.gbvForm3Item3Title,
                          body: l10n.gbvForm3Item3Body,
                        ),
                      ],
                    ),

                    // 4: Economic Violence
                    _GbvNumberedCategory(
                      number: 4,
                      title: l10n.gbvForm4Title,
                      items: [
                        _GbvBulletItem(
                          boldPrefix: l10n.gbvForm4Item1Title,
                          body: l10n.gbvForm4Item1Body,
                        ),
                        _GbvBulletItem(
                          boldPrefix: l10n.gbvForm4Item2Title,
                          body: l10n.gbvForm4Item2Body,
                        ),
                      ],
                    ),

                    // 5: Harmful Traditional Practices
                    _GbvNumberedCategory(
                      number: 5,
                      title: l10n.gbvForm5Title,
                      items: [
                        _GbvBulletItem(
                          boldPrefix: l10n.gbvForm5Item1Title,
                          body: l10n.gbvForm5Item1Body,
                        ),
                        _GbvBulletItem(
                          boldPrefix: l10n.gbvForm5Item2Title,
                          body: l10n.gbvForm5Item2Body,
                        ),
                        _GbvBulletItem(
                          boldPrefix: l10n.gbvForm5Item3Title,
                          body: l10n.gbvForm5Item3Body,
                        ),
                      ],
                    ),
                  ],
                ),

                // 5. Section 2 Accordion: Sex and Gender
                _GbvAccordionCard(
                  sectionNumber: 2,
                  title: l10n.gbvSection2Title,
                  isExpanded: _expandedSections.contains(2),
                  isRead: _readSections.contains(2),
                  onToggle: () => _toggleSection(2),
                  children: [
                    Text(
                      l10n.gbvSection2Desc1,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.gbvSection2Desc2,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                  ],
                ),

                // 6. Section 3 Accordion: Consequences of gender-based violence
                _GbvAccordionCard(
                  sectionNumber: 3,
                  title: l10n.gbvSection3Title,
                  isExpanded: _expandedSections.contains(3),
                  isRead: _readSections.contains(3),
                  onToggle: () => _toggleSection(3),
                  children: [
                    _GbvBulletItem(
                      boldPrefix: '',
                      body: l10n.gbvConsequenceBullet1,
                    ),
                    _GbvBulletItem(
                      boldPrefix: '',
                      body: l10n.gbvConsequenceBullet2,
                    ),
                    _GbvBulletItem(
                      boldPrefix: '',
                      body: l10n.gbvConsequenceBullet3,
                    ),
                    _GbvBulletItem(
                      boldPrefix: '',
                      body: l10n.gbvConsequenceBullet4,
                    ),
                    _GbvBulletItem(
                      boldPrefix: '',
                      body: l10n.gbvConsequenceBullet5,
                    ),
                    const SizedBox(height: 16),
                    _GbvConsequencesTable(l10n: l10n),
                  ],
                ),

                // 7. Section 4 Accordion: Management and Prevention of Gender-Based Violence (GBV)
                _GbvAccordionCard(
                  sectionNumber: 4,
                  title: l10n.gbvSection4Title,
                  isExpanded: _expandedSections.contains(4),
                  isRead: _readSections.contains(4),
                  onToggle: () => _toggleSection(4),
                  children: [
                    // Main 1: Immediate Response: Management of GBV
                    _GbvNumberedCategory(
                      number: 1,
                      title: l10n.gbvSec4Main1Title,
                      items: [
                        Text(
                          l10n.gbvSec4Main1Intro,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF334155),
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Sub A: Providing Safety and Protection
                        _GbvLetterSubcategory(
                          letter: 'A',
                          title: l10n.gbvSec4SubATitle,
                          items: [
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4SubA1Title,
                              body: l10n.gbvSec4SubA1Body,
                            ),
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4SubA2Title,
                              body: l10n.gbvSec4SubA2Body,
                            ),
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4SubA3Title,
                              body: l10n.gbvSec4SubA3Body,
                            ),
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4SubA4Title,
                              body: l10n.gbvSec4SubA4Body,
                            ),
                          ],
                        ),

                        // Sub B: Comprehensive Support Services
                        _GbvLetterSubcategory(
                          letter: 'B',
                          title: l10n.gbvSec4SubBTitle,
                          items: [
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4SubB1Title,
                              body: l10n.gbvSec4SubB1Body,
                            ),
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4SubB2Title,
                              body: l10n.gbvSec4SubB2Body,
                            ),
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4SubB3Title,
                              body: l10n.gbvSec4SubB3Body,
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Main 2: Preventing GBV
                    _GbvNumberedCategory(
                      number: 2,
                      title: l10n.gbvSec4Main2Title,
                      items: [
                        Text(
                          l10n.gbvSec4Main2Intro,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF334155),
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Sub 2A: Changing Social Norms and Attitudes
                        _GbvLetterSubcategory(
                          letter: 'A',
                          title: l10n.gbvSec4Sub2ATitle,
                          items: [
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub2A1Title,
                              body: l10n.gbvSec4Sub2A1Body,
                            ),
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub2A2Title,
                              body: l10n.gbvSec4Sub2A2Body,
                            ),
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub2A3Title,
                              body: l10n.gbvSec4Sub2A3Body,
                            ),
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub2A4Title,
                              body: l10n.gbvSec4Sub2A4Body,
                            ),
                          ],
                        ),

                        // Sub 2B: Legal and Policy Reform
                        _GbvLetterSubcategory(
                          letter: 'B',
                          title: l10n.gbvSec4Sub2BTitle,
                          items: [
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub2B1Title,
                              body: l10n.gbvSec4Sub2B1Body,
                            ),
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub2B2Title,
                              body: l10n.gbvSec4Sub2B2Body,
                            ),
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub2B3Title,
                              body: l10n.gbvSec4Sub2B3Body,
                            ),
                          ],
                        ),

                        // Sub 2C: Empowering Women and Gender Minorities
                        _GbvLetterSubcategory(
                          letter: 'C',
                          title: l10n.gbvSec4Sub2CTitle,
                          items: [
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub2C1Title,
                              body: l10n.gbvSec4Sub2C1Body,
                            ),
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub2C2Title,
                              body: l10n.gbvSec4Sub2C2Body,
                            ),
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub2C3Title,
                              body: l10n.gbvSec4Sub2C3Body,
                            ),
                          ],
                        ),

                        // Sub 2D: Community-based Approaches
                        _GbvLetterSubcategory(
                          letter: 'D',
                          title: l10n.gbvSec4Sub2DTitle,
                          items: [
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub2D1Title,
                              body: l10n.gbvSec4Sub2D1Body,
                            ),
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub2D2Title,
                              body: l10n.gbvSec4Sub2D2Body,
                            ),
                          ],
                        ),

                        // Sub 2E: Education and Awareness
                        _GbvLetterSubcategory(
                          letter: 'E',
                          title: l10n.gbvSec4Sub2ETitle,
                          items: [
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub2E1Title,
                              body: l10n.gbvSec4Sub2E1Body,
                            ),
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub2E2Title,
                              body: l10n.gbvSec4Sub2E2Body,
                            ),
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub2E3Title,
                              body: l10n.gbvSec4Sub2E3Body,
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Main 3: Long-Term Strategies: Changing Structural and Cultural Factors
                    _GbvNumberedCategory(
                      number: 3,
                      title: l10n.gbvSec4Main3Title,
                      items: [
                        Text(
                          l10n.gbvSec4Main3Intro,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF334155),
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Sub 3A: Addressing Gender Inequality
                        _GbvLetterSubcategory(
                          letter: 'A',
                          title: l10n.gbvSec4Sub3ATitle,
                          items: [
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub3A1Title,
                              body: l10n.gbvSec4Sub3A1Body,
                            ),
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub3A2Title,
                              body: l10n.gbvSec4Sub3A2Body,
                            ),
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub3A3Title,
                              body: l10n.gbvSec4Sub3A3Body,
                            ),
                          ],
                        ),

                        // Sub 3B: Engaging Men and Boys
                        _GbvLetterSubcategory(
                          letter: 'B',
                          title: l10n.gbvSec4Sub3BTitle,
                          items: [
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub3B1Title,
                              body: l10n.gbvSec4Sub3B1Body,
                            ),
                            _GbvBulletItem(
                              boldPrefix: l10n.gbvSec4Sub3B2Title,
                              body: l10n.gbvSec4Sub3B2Body,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFCA5A5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.support_agent_rounded,
                            color: Color(0xFFDC2626),
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l10n.gbvSection4HelpAlert,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF991B1B),
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
                const SizedBox(height: 24),

                // 8. Bottom Action Button: Mark as Completed (or Completed banner)
                if (isCompleted)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(14),
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
                          size: 20,
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
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Dynamic accordion dropdown card matching the reference design:
/// shows solid blue badge with section number if unread, or checkmark if read.
class _GbvAccordionCard extends StatelessWidget {
  const _GbvAccordionCard({
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
          color: isExpanded ? const Color(0xFF0284C7) : const Color(0xFFDCE8F2),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Dynamic Badge: Checkmark if read, Numbered circle if unread
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
                              size: 19,
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
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF08264A),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: const Color(0xFF005A71),
                      size: 24,
                    ),
                  ],
                ),
                if (isExpanded) ...[
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFFEDF2F7), height: 1),
                  const SizedBox(height: 12),
                  ...children,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Numbered category item matching reference design (1, 2, 3, etc. in a blue circular badge).
class _GbvNumberedCategory extends StatelessWidget {
  const _GbvNumberedCategory({
    required this.number,
    required this.title,
    required this.items,
  });

  final int number;
  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF08264A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items,
        ],
      ),
    );
  }
}

/// Bullet item with dark bold prefix and clean body text.
class _GbvBulletItem extends StatelessWidget {
  const _GbvBulletItem({
    required this.boldPrefix,
    required this.body,
  });

  final String boldPrefix;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(
              Icons.circle,
              size: 6,
              color: Color(0xFF0284C7),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF334155),
                  height: 1.5,
                ),
                children: [
                  if (boldPrefix.isNotEmpty)
                    TextSpan(
                      text: '$boldPrefix ',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF08264A),
                      ),
                    ),
                  TextSpan(text: body),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Subcategory with letter badge (A, B, C, D, E in solid blue circle).
class _GbvLetterSubcategory extends StatelessWidget {
  const _GbvLetterSubcategory({
    required this.letter,
    required this.title,
    required this.items,
  });

  final String letter;
  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
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
                    fontSize: 12.5,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF08264A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items,
        ],
      ),
    );
  }
}

/// Styled consequence table matching the reference poster graphic.
class _GbvConsequencesTable extends StatelessWidget {
  const _GbvConsequencesTable({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final rows = [
      [l10n.gbvTablePhys1, l10n.gbvTablePsych1, l10n.gbvTableSoc1],
      [l10n.gbvTablePhys2, l10n.gbvTablePsych2, l10n.gbvTableSoc2],
      [l10n.gbvTablePhys3, l10n.gbvTablePsych3, l10n.gbvTableSoc3],
      [l10n.gbvTablePhys4, l10n.gbvTablePsych4, l10n.gbvTableSoc4],
      [l10n.gbvTablePhys5, l10n.gbvTablePsych5, l10n.gbvTableSoc5],
      [l10n.gbvTablePhys6, l10n.gbvTablePsych6, l10n.gbvTableSoc6],
      [l10n.gbvTablePhys7, '—', l10n.gbvTableSoc7],
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F7F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2D9C8),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              l10n.gbvTableTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E3A8A),
                letterSpacing: -0.2,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Structured 3-column table
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Table(
              border: TableBorder.all(
                color: const Color(0xFFCBD5E1),
                width: 0.9,
              ),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1.15),
              },
              children: [
                // Header Row
                TableRow(
                  decoration: const BoxDecoration(
                    color: Color(0xFF581C87),
                  ),
                  children: [
                    _buildHeaderCell(l10n.gbvTableColPhysical),
                    _buildHeaderCell(l10n.gbvTableColPsychological),
                    _buildHeaderCell(l10n.gbvTableColSocial),
                  ],
                ),
                // Data Rows
                for (var i = 0; i < rows.length; i++)
                  TableRow(
                    decoration: BoxDecoration(
                      color: i.isEven ? Colors.white : const Color(0xFFF8FAFC),
                    ),
                    children: [
                      _buildDataCell(rows[i][0]),
                      _buildDataCell(rows[i][1]),
                      _buildDataCell(rows[i][2]),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Footer Badge
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: const Color(0xFF0284C7),
                  width: 1,
                ),
              ),
              child: const Text(
                'GENDER BASED VIOLENCE',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0284C7),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.25,
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11.5,
          color: Color(0xFF1E293B),
          fontWeight: FontWeight.w500,
          height: 1.3,
        ),
      ),
    );
  }
}
