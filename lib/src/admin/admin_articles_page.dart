import 'package:flutter/material.dart';

import '../theme/app_glass_theme.dart';
import 'admin_controller.dart';
import 'content_templates.dart';

class AdminArticlesPage extends StatefulWidget {
  const AdminArticlesPage({
    required this.controller,
    super.key,
  });

  final AdminController controller;

  @override
  State<AdminArticlesPage> createState() => _AdminArticlesPageState();
}

class _AdminArticlesPageState extends State<AdminArticlesPage> {
  void _openArticleEditor([ArticleDraft? initial]) {
    final isEditing = initial != null;
    final idController = TextEditingController(
      text: initial?.id ?? 'art_${DateTime.now().millisecondsSinceEpoch}',
    );
    final titleEn = TextEditingController(text: initial?.titleEn ?? '');
    final titleAm = TextEditingController(text: initial?.titleAm ?? '');
    final summaryEn = TextEditingController(text: initial?.summaryEn ?? '');
    final summaryAm = TextEditingController(text: initial?.summaryAm ?? '');
    final bodyEn = TextEditingController(text: initial?.bodyMarkdownEn ?? '');
    final bodyAm = TextEditingController(text: initial?.bodyMarkdownAm ?? '');
    final author = TextEditingController(
      text: initial?.authorName ?? 'Dr. Hanna Bekele, MD',
    );
    final category = TextEditingController(
      text: initial?.category ?? 'Adolescent Health',
    );

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
                  isEditing ? 'Edit Article' : 'Post Health Article',
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
                    final t = ContentTemplates.articleTemplates.first;
                    setDialogState(() {
                      titleEn.text = t.titleEn;
                      titleAm.text = t.titleAm;
                      summaryEn.text = t.summaryEn;
                      summaryAm.text = t.summaryAm;
                      bodyEn.text = t.bodyMarkdownEn;
                      bodyAm.text = t.bodyMarkdownAm;
                      author.text = t.authorName;
                      category.text = t.category;
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
                  children: [
                    TextField(
                      controller: titleEn,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'Article Title (English)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: titleAm,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'የፅሁፉ ርዕስ (አማርኛ)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: author,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'Author / Clinical Reviewer',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: summaryEn,
                      maxLines: 2,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'Summary / Excerpt (English)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: summaryAm,
                      maxLines: 2,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'አጭር መግለጫ (አማርኛ)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: bodyEn,
                      maxLines: 4,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'Body Markdown (English)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: bodyAm,
                      maxLines: 4,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'ሙሉ ይዘት ማርክዳውን (አማርኛ)',
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
                  if (titleEn.text.trim().isEmpty) return;
                  final article = ArticleDraft(
                    id: idController.text.trim(),
                    titleEn: titleEn.text.trim(),
                    titleAm: titleAm.text.trim().isNotEmpty
                        ? titleAm.text.trim()
                        : titleEn.text.trim(),
                    summaryEn: summaryEn.text.trim(),
                    summaryAm: summaryAm.text.trim().isNotEmpty
                        ? summaryAm.text.trim()
                        : summaryEn.text.trim(),
                    bodyMarkdownEn: bodyEn.text.trim(),
                    bodyMarkdownAm: bodyAm.text.trim().isNotEmpty
                        ? bodyAm.text.trim()
                        : bodyEn.text.trim(),
                    authorName: author.text.trim(),
                    category: category.text.trim(),
                    sources: const ['MOH Ethiopia Adolescent Guidelines'],
                  );
                  await widget.controller.saveArticle(article);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
                child: const Text('Publish Article'),
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
          isAmharic ? 'የጤና ፅሁፎች ማስተዳደሪያ' : 'Manage Health Articles',
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
            tooltip: 'Post Article',
            onPressed: () => _openArticleEditor(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final articles = widget.controller.articles;
          if (articles.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.article_rounded,
                      size: 48, color: Color(0xFF38BDF8)),
                  const SizedBox(height: 12),
                  Text(
                    'No articles published yet.',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: glass.titleText),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Post Article'),
                    onPressed: () => _openArticleEditor(),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: articles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final a = articles[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: glass.cardBackground,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: glass.cardBorder, width: 1.2),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.article_rounded,
                          color: Color(0xFF10B981), size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAmharic ? a.titleAm : a.titleEn,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: glass.titleText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isAmharic ? a.summaryAm : a.summaryEn,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: glass.subtitleText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '✍️ ${a.authorName} • ${a.category}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0284C7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      tooltip: 'Edit',
                      onPressed: () => _openArticleEditor(a),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          size: 20, color: Color(0xFFEF4444)),
                      tooltip: 'Delete',
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Article?'),
                            content: Text(
                                'Are you sure you want to remove "${a.titleEn}"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF4444),
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await widget.controller.deleteArticle(a.id);
                        }
                      },
                    ),
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
