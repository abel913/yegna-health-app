import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'assessment_repository.dart';
import 'hepatitis_quiz_page.dart';
import 'learning_progress_controller.dart';

/// Detailed learning module screen for Module 03: Hepatitis.
///
/// Features authentic optical glass styling matching user reference screenshots:
/// 1. Definition (Liver inflammation, viral A-E & non-viral causes)
/// 2. Sign and symptoms of Hepatitis (General symptoms, Hepatitis B, Hepatitis C, alert callout)
/// 3. Diagnosis of Hepatitis (Serology, LFTs, PCR viral load, ultrasound/elastography)
/// 4. Complication of Hepatitis (Cirrhosis, liver failure, hepatocellular carcinoma, ascites)
/// 5. Management and treatment of Hepatitis (Antivirals, DAA cures, lifestyle, monitoring)
/// 6. Prevention Of Hepatitis (Vaccination, safe injection, barrier protection, water/food hygiene, blood safety)
class HepatitisDetailPage extends StatefulWidget {
  const HepatitisDetailPage({
    required this.progressController,
    this.assessmentRepository,
    this.onOpenQuiz,
    super.key,
  });

  final LearningProgressController progressController;
  final AssessmentRepository? assessmentRepository;
  final VoidCallback? onOpenQuiz;

  @override
  State<HepatitisDetailPage> createState() => _HepatitisDetailPageState();
}

class _HepatitisDetailPageState extends State<HepatitisDetailPage> {
  // Expansion state for the 6 accordion sections.
  final Set<int> _expandedSections = <int>{};

  // Track sections read by user.
  final Set<int> _readSections = <int>{};

  Future<void> _markCompleted(
      BuildContext context, AppLocalizations l10n) async {
    final locale = Localizations.localeOf(context).languageCode;
    await widget.progressController.markArticleComplete('module-03', locale);
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
      body: AnimatedBuilder(
        animation: widget.progressController,
        builder: (context, _) {
          final isCompleted = widget.progressController.progress?.articles
                  .any((a) => a.articleId == 'module-03') ??
              false;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Hero Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0xFFD6E8F6),
                      width: 1.4,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x08003648),
                        blurRadius: 18,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Illustration
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(
                            maxHeight: 180,
                            maxWidth: 320,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/learning/module_03_hepatitis.png',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Container(
                                height: 140,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F1F8),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.health_and_safety_rounded,
                                    size: 56,
                                    color: Color(0xFF0284C7),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Title
                      Text(
                        l10n.module03Title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF08264A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Overview description
                      Text(
                        l10n.hepatitisHeroDesc,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF475569),
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // 2. Note Section
                Row(
                  children: [
                    Container(
                      width: 3.5,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.hivNoteTitle,
                      style: const TextStyle(
                        fontSize: 16,
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
                    color: const Color(0xFFF0F7FD),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFFD6E4F0),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFDCEEFA),
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
                          l10n.hepatitisNoteContent,
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
                const SizedBox(height: 22),

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
                _HepatitisAccordionCard(
                  sectionNumber: 1,
                  title: l10n.hepatitisSection1Title,
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
                      l10n.hepatitisSection1Desc1,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.hepatitisSection1Desc2,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 2: Sign and symptoms of Hepatitis
                _HepatitisAccordionCard(
                  sectionNumber: 2,
                  title: l10n.hepatitisSection2Title,
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
                      l10n.hepatitisSection2Intro,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _HepatitisBulletItem(body: l10n.hepatitisSymptom1),
                    const SizedBox(height: 6),
                    _HepatitisBulletItem(body: l10n.hepatitisSymptom2),
                    const SizedBox(height: 6),
                    _HepatitisBulletItem(body: l10n.hepatitisSymptom3),
                    const SizedBox(height: 6),
                    _HepatitisBulletItem(body: l10n.hepatitisSymptom4),
                    const SizedBox(height: 6),
                    _HepatitisBulletItem(body: l10n.hepatitisSymptom5),
                    const SizedBox(height: 6),
                    _HepatitisBulletItem(body: l10n.hepatitisSymptom6),
                    const SizedBox(height: 6),
                    _HepatitisBulletItem(body: l10n.hepatitisSymptom7),
                    const SizedBox(height: 14),

                    // Chronic infection & cancer warning paragraph
                    Text(
                      l10n.hepatitisSection2ChronicNote,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Subheading: Hepatitis B
                    Text(
                      l10n.hepatitisBTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF08264A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.hepatitisBDesc,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.hepatitisBTransmissionIntro,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _HepatitisBulletItem(body: l10n.hepatitisBTransmission1),
                    const SizedBox(height: 6),
                    _HepatitisBulletItem(body: l10n.hepatitisBTransmission2),
                    const SizedBox(height: 6),
                    _HepatitisBulletItem(body: l10n.hepatitisBTransmission3),
                    const SizedBox(height: 6),
                    _HepatitisBulletItem(body: l10n.hepatitisBTransmission4),
                    const SizedBox(height: 14),

                    // Highlight Alert Card: Hepatitis B Vaccine / No Cure
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F7FD),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFBAE6FD),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lightbulb_outline_rounded,
                            color: Color(0xFF0284C7),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l10n.hepatitisBAlert,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0369A1),
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Subheading: Hepatitis C
                    Text(
                      l10n.hepatitisCTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF08264A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.hepatitisCDesc,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _HepatitisBulletItem(body: l10n.hepatitisCTransmission1),
                    const SizedBox(height: 6),
                    _HepatitisBulletItem(body: l10n.hepatitisCTransmission2),
                    const SizedBox(height: 6),
                    _HepatitisBulletItem(body: l10n.hepatitisCTransmission3),
                    const SizedBox(height: 14),

                    Text(
                      l10n.hepatitisCChronicDesc,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.hepatitisCTreatmentDesc,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 3: Diagnosis of Hepatitis
                _HepatitisAccordionCard(
                  sectionNumber: 3,
                  title: l10n.hepatitisSection3Title,
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
                      l10n.hepatitisSection3Desc,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 4: Complication of Hepatitis
                _HepatitisAccordionCard(
                  sectionNumber: 4,
                  title: l10n.hepatitisSection4Title,
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
                      l10n.hepatitisSection4Intro,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _HepatitisNumberedHeaderItem(
                      number: 1,
                      title: l10n.hepatitisComp1Title,
                      bulletText: l10n.hepatitisComp1Desc,
                    ),
                    _HepatitisNumberedHeaderItem(
                      number: 2,
                      title: l10n.hepatitisComp2Title,
                      bulletText: l10n.hepatitisComp2Desc,
                    ),
                    _HepatitisNumberedHeaderItem(
                      number: 3,
                      title: l10n.hepatitisComp3Title,
                      bulletText: l10n.hepatitisComp3Desc,
                    ),
                    _HepatitisNumberedHeaderItem(
                      number: 4,
                      title: l10n.hepatitisComp4Title,
                      bulletText: l10n.hepatitisComp4Desc,
                    ),
                    Text(
                      l10n.hepatitisSection4Conclusion,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 5: Management and treatment of Hepatitis
                _HepatitisAccordionCard(
                  sectionNumber: 5,
                  title: l10n.hepatitisSection5Title,
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
                      l10n.hepatitisSection5Desc,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Section 6: Prevention Of Hepatitis
                _HepatitisAccordionCard(
                  sectionNumber: 6,
                  title: l10n.hepatitisSection6Title,
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
                      l10n.hepatitisSection6Subtitle,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF08264A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _HepatitisBulletItem(
                        body: l10n.hepatitisPreventionMeasure1),
                    const SizedBox(height: 8),
                    _HepatitisBulletItem(
                        body: l10n.hepatitisPreventionMeasure2),
                    const SizedBox(height: 8),
                    _HepatitisBulletItem(
                        body: l10n.hepatitisPreventionMeasure3),
                    const SizedBox(height: 8),
                    _HepatitisBulletItem(
                        body: l10n.hepatitisPreventionMeasure4),
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
                              builder: (_) => HepatitisQuizPage(
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

/// Custom Accordion Card matching the optical-glass design of the reference app.
class _HepatitisAccordionCard extends StatelessWidget {
  const _HepatitisAccordionCard({
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isExpanded ? const Color(0xFFBAE6FD) : const Color(0xFFE2EAF2),
          width: 1.3,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x04003648),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    // Dynamic Badge: Number when unread, Checkmark when read
                    Container(
                      width: 38,
                      height: 38,
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
                                fontSize: 15,
                              ),
                            ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF08264A),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: const Color(0xFF0284C7),
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Bullet item for hepatitis symptoms, complications, and treatment steps.
class _HepatitisBulletItem extends StatelessWidget {
  const _HepatitisBulletItem({
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

/// Numbered header item for complication sections (1, 2, 3, 4 with bold title & bullet).
class _HepatitisNumberedHeaderItem extends StatelessWidget {
  const _HepatitisNumberedHeaderItem({
    required this.number,
    required this.title,
    required this.bulletText,
  });

  final int number;
  final String title;
  final String bulletText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF08264A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _HepatitisBulletItem(body: bulletText),
        ],
      ),
    );
  }
}
