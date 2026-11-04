import 'package:flutter/material.dart';

import '../theme/app_glass_theme.dart';
import 'admin_controller.dart';
import 'content_templates.dart';

class AdminQuizzesPage extends StatefulWidget {
  const AdminQuizzesPage({
    required this.controller,
    super.key,
  });

  final AdminController controller;

  @override
  State<AdminQuizzesPage> createState() => _AdminQuizzesPageState();
}

class _AdminQuizzesPageState extends State<AdminQuizzesPage> {
  void _openQuestionEditor([QuestionDraft? initial]) {
    final isEditing = initial != null;
    final idController = TextEditingController(
      text: initial?.id ?? 'q_${DateTime.now().millisecondsSinceEpoch}',
    );
    final promptEnController =
        TextEditingController(text: initial?.promptEn ?? '');
    final promptAmController =
        TextEditingController(text: initial?.promptAm ?? '');
    final expEnController =
        TextEditingController(text: initial?.explanationEn ?? '');
    final expAmController =
        TextEditingController(text: initial?.explanationAm ?? '');

    // 4 Options
    final opt1En = TextEditingController(
        text: initial != null && initial.options.isNotEmpty
            ? initial.options[0].labelEn
            : '');
    final opt1Am = TextEditingController(
        text: initial != null && initial.options.isNotEmpty
            ? initial.options[0].labelAm
            : '');

    final opt2En = TextEditingController(
        text: initial != null && initial.options.length > 1
            ? initial.options[1].labelEn
            : '');
    final opt2Am = TextEditingController(
        text: initial != null && initial.options.length > 1
            ? initial.options[1].labelAm
            : '');

    final opt3En = TextEditingController(
        text: initial != null && initial.options.length > 2
            ? initial.options[2].labelEn
            : '');
    final opt3Am = TextEditingController(
        text: initial != null && initial.options.length > 2
            ? initial.options[2].labelAm
            : '');

    final opt4En = TextEditingController(
        text: initial != null && initial.options.length > 3
            ? initial.options[3].labelEn
            : '');
    final opt4Am = TextEditingController(
        text: initial != null && initial.options.length > 3
            ? initial.options[3].labelAm
            : '');

    int correctIndex = 0;
    if (initial != null) {
      final found = initial.options.indexWhere((o) => o.isCorrect);
      if (found >= 0) correctIndex = found;
    }

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final glass = ctx.glassTheme;
          return AlertDialog(
            backgroundColor: glass.modalBackground,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'Edit Question' : 'Add Quiz Question',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: glass.titleText,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.auto_fix_high_rounded, size: 16),
                  label: const Text('Template', style: TextStyle(fontSize: 12)),
                  onPressed: () {
                    final t = ContentTemplates.questionTemplates.first;
                    setDialogState(() {
                      promptEnController.text = t.promptEn;
                      promptAmController.text = t.promptAm;
                      expEnController.text = t.explanationEn;
                      expAmController.text = t.explanationAm;
                      if (t.options.isNotEmpty) {
                        opt1En.text = t.options[0].labelEn;
                        opt1Am.text = t.options[0].labelAm;
                      }
                      if (t.options.length > 1) {
                        opt2En.text = t.options[1].labelEn;
                        opt2Am.text = t.options[1].labelAm;
                      }
                      if (t.options.length > 2) {
                        opt3En.text = t.options[2].labelEn;
                        opt3Am.text = t.options[2].labelAm;
                      }
                      if (t.options.length > 3) {
                        opt4En.text = t.options[3].labelEn;
                        opt4Am.text = t.options[3].labelAm;
                      }
                      correctIndex = 0;
                    });
                  },
                ),
              ],
            ),
            content: SizedBox(
              width: 520,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: promptEnController,
                      maxLines: 2,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'Question Prompt (English)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: promptAmController,
                      maxLines: 2,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'የጥያቄው ፅሁፍ (አማርኛ)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Options (Select radio for correct answer)',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: glass.titleText,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Option 1
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            correctIndex == 0
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: correctIndex == 0
                                ? const Color(0xFF10B981)
                                : glass.subtitleText,
                            size: 22,
                          ),
                          onPressed: () =>
                              setDialogState(() => correctIndex = 0),
                        ),
                        Expanded(
                          child: TextField(
                            controller: opt1En,
                            style:
                                TextStyle(fontSize: 13, color: glass.titleText),
                            decoration: const InputDecoration(
                              labelText: 'Option A (English)',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Option 2
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            correctIndex == 1
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: correctIndex == 1
                                ? const Color(0xFF10B981)
                                : glass.subtitleText,
                            size: 22,
                          ),
                          onPressed: () =>
                              setDialogState(() => correctIndex = 1),
                        ),
                        Expanded(
                          child: TextField(
                            controller: opt2En,
                            style:
                                TextStyle(fontSize: 13, color: glass.titleText),
                            decoration: const InputDecoration(
                              labelText: 'Option B (English)',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Option 3
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            correctIndex == 2
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: correctIndex == 2
                                ? const Color(0xFF10B981)
                                : glass.subtitleText,
                            size: 22,
                          ),
                          onPressed: () =>
                              setDialogState(() => correctIndex = 2),
                        ),
                        Expanded(
                          child: TextField(
                            controller: opt3En,
                            style:
                                TextStyle(fontSize: 13, color: glass.titleText),
                            decoration: const InputDecoration(
                              labelText: 'Option C (English)',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Option 4
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            correctIndex == 3
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: correctIndex == 3
                                ? const Color(0xFF10B981)
                                : glass.subtitleText,
                            size: 22,
                          ),
                          onPressed: () =>
                              setDialogState(() => correctIndex = 3),
                        ),
                        Expanded(
                          child: TextField(
                            controller: opt4En,
                            style:
                                TextStyle(fontSize: 13, color: glass.titleText),
                            decoration: const InputDecoration(
                              labelText: 'Option D (English)',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Explanation
                    TextField(
                      controller: expEnController,
                      maxLines: 2,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'Clinical Feedback / Explanation (English)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: expAmController,
                      maxLines: 2,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'የህክምና ማብራሪያ (አማርኛ)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  if (promptEnController.text.trim().isEmpty) return;

                  final options = [
                    QuestionOptionDraft(
                      id: 'opt_1',
                      labelEn: opt1En.text.trim().isNotEmpty
                          ? opt1En.text.trim()
                          : 'Option A',
                      labelAm: opt1Am.text.trim().isNotEmpty
                          ? opt1Am.text.trim()
                          : opt1En.text.trim(),
                      isCorrect: correctIndex == 0,
                    ),
                    QuestionOptionDraft(
                      id: 'opt_2',
                      labelEn: opt2En.text.trim().isNotEmpty
                          ? opt2En.text.trim()
                          : 'Option B',
                      labelAm: opt2Am.text.trim().isNotEmpty
                          ? opt2Am.text.trim()
                          : opt2En.text.trim(),
                      isCorrect: correctIndex == 1,
                    ),
                    QuestionOptionDraft(
                      id: 'opt_3',
                      labelEn: opt3En.text.trim().isNotEmpty
                          ? opt3En.text.trim()
                          : 'Option C',
                      labelAm: opt3Am.text.trim().isNotEmpty
                          ? opt3Am.text.trim()
                          : opt3En.text.trim(),
                      isCorrect: correctIndex == 2,
                    ),
                    QuestionOptionDraft(
                      id: 'opt_4',
                      labelEn: opt4En.text.trim().isNotEmpty
                          ? opt4En.text.trim()
                          : 'Option D',
                      labelAm: opt4Am.text.trim().isNotEmpty
                          ? opt4Am.text.trim()
                          : opt4En.text.trim(),
                      isCorrect: correctIndex == 3,
                    ),
                  ];

                  final q = QuestionDraft(
                    id: idController.text.trim(),
                    quizId: 'general',
                    promptEn: promptEnController.text.trim(),
                    promptAm: promptAmController.text.trim().isNotEmpty
                        ? promptAmController.text.trim()
                        : promptEnController.text.trim(),
                    options: options,
                    explanationEn: expEnController.text.trim(),
                    explanationAm: expAmController.text.trim().isNotEmpty
                        ? expAmController.text.trim()
                        : expEnController.text.trim(),
                  );

                  await widget.controller.saveQuestion(q);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
                child: const Text('Save Question'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    return Scaffold(
      backgroundColor: glass.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: glass.appBarBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: glass.titleText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isAmharic ? 'የፈተና ጥያቄዎች ባንክ' : 'Quiz & Question Bank',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: glass.titleText,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded,
                color: Color(0xFF38BDF8)),
            tooltip: 'Add Question',
            onPressed: () => _openQuestionEditor(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final questions = widget.controller.questions;
          if (questions.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.quiz_rounded,
                      size: 48, color: Color(0xFF38BDF8)),
                  const SizedBox(height: 12),
                  Text(
                    'No assessment questions found.',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: glass.titleText),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Question'),
                    onPressed: () => _openQuestionEditor(),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: questions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final q = questions[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: glass.cardBackground,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: glass.cardBorder, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF0284C7).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Q${index + 1}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF38BDF8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isAmharic ? q.promptAm : q.promptEn,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: glass.titleText,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          tooltip: 'Edit',
                          onPressed: () => _openQuestionEditor(q),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded,
                              size: 18, color: Color(0xFFEF4444)),
                          tooltip: 'Delete',
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Delete Question?'),
                                content: const Text(
                                    'Are you sure you want to remove this question?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEF4444),
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await widget.controller.deleteQuestion(q.id);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...q.options.map((opt) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(
                              opt.isCorrect
                                  ? Icons.check_circle_rounded
                                  : Icons.circle_outlined,
                              size: 15,
                              color: opt.isCorrect
                                  ? const Color(0xFF10B981)
                                  : glass.subtitleText,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                opt.labelEn,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: opt.isCorrect
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: opt.isCorrect
                                      ? const Color(0xFF10B981)
                                      : glass.subtitleText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    if (q.explanationEn.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: glass.isDark
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '💡 Insight: ${q.explanationEn}',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: glass.subtitleText,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
