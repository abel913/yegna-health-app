import 'package:flutter/material.dart';

import '../theme/app_glass_theme.dart';
import 'admin_controller.dart';
import 'content_templates.dart';

class AdminModulesPage extends StatefulWidget {
  const AdminModulesPage({
    required this.controller,
    super.key,
  });

  final AdminController controller;

  @override
  State<AdminModulesPage> createState() => _AdminModulesPageState();
}

class _AdminModulesPageState extends State<AdminModulesPage> {
  void _openModuleEditor([ModuleDraft? initial]) {
    final isEditing = initial != null;
    final idController = TextEditingController(
      text: initial?.id ?? 'module_${DateTime.now().millisecondsSinceEpoch}',
    );
    final titleEnController =
        TextEditingController(text: initial?.titleEn ?? '');
    final titleAmController =
        TextEditingController(text: initial?.titleAm ?? '');
    final descEnController =
        TextEditingController(text: initial?.descriptionEn ?? '');
    final descAmController =
        TextEditingController(text: initial?.descriptionAm ?? '');
    final timeController = TextEditingController(
      text: initial != null ? initial.estimatedReadTimeMinutes.toString() : '6',
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
                  isEditing ? 'Edit Learning Module' : 'Create Learning Module',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: glass.titleText,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.auto_fix_high_rounded, size: 16),
                  label: const Text('Load Template',
                      style: TextStyle(fontSize: 12)),
                  onPressed: () {
                    final t = ContentTemplates.moduleTemplates.first;
                    setDialogState(() {
                      titleEnController.text = t.titleEn;
                      titleAmController.text = t.titleAm;
                      descEnController.text = t.descriptionEn;
                      descAmController.text = t.descriptionAm;
                      timeController.text =
                          t.estimatedReadTimeMinutes.toString();
                    });
                  },
                ),
              ],
            ),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleEnController,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'Module Title (English)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleAmController,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'የሞጁሉ ርዕስ (አማርኛ)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descEnController,
                      maxLines: 2,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'Description / Synopsis (English)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descAmController,
                      maxLines: 2,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'አጭር መግለጫ (አማርኛ)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: timeController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'Estimated Read Time (Minutes)',
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
                  if (titleEnController.text.trim().isEmpty) return;
                  final module = ModuleDraft(
                    id: idController.text.trim(),
                    titleEn: titleEnController.text.trim(),
                    titleAm: titleAmController.text.trim().isNotEmpty
                        ? titleAmController.text.trim()
                        : titleEnController.text.trim(),
                    descriptionEn: descEnController.text.trim(),
                    descriptionAm: descAmController.text.trim().isNotEmpty
                        ? descAmController.text.trim()
                        : descEnController.text.trim(),
                    iconAsset: initial?.iconAsset ??
                        'assets/images/yegna_health_icon.png',
                    estimatedReadTimeMinutes:
                        int.tryParse(timeController.text.trim()) ?? 6,
                    sections: initial?.sections ??
                        ContentTemplates.moduleTemplates.first.sections,
                  );
                  await widget.controller.saveModule(module);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
                child: const Text('Save Module'),
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
          isAmharic ? 'የትምህርት ሞጁሎች ማስተዳደሪያ' : 'Manage Learning Modules',
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
            tooltip: 'Add Module',
            onPressed: () => _openModuleEditor(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final modules = widget.controller.modules;
          if (modules.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.menu_book_rounded,
                      size: 48, color: Color(0xFF38BDF8)),
                  const SizedBox(height: 12),
                  Text(
                    'No modules found.',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: glass.titleText),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Create First Module'),
                    onPressed: () => _openModuleEditor(),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: modules.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final m = modules[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: glass.cardBackground,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: glass.cardBorder, width: 1.2),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.menu_book_rounded,
                          color: Color(0xFF38BDF8), size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAmharic ? m.titleAm : m.titleEn,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: glass.titleText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isAmharic ? m.descriptionAm : m.descriptionEn,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: glass.subtitleText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '⏱ ${m.estimatedReadTimeMinutes} min read • ${m.sections.length} sections',
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
                      onPressed: () => _openModuleEditor(m),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          size: 20, color: Color(0xFFEF4444)),
                      tooltip: 'Delete',
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Module?'),
                            content: Text(
                                'Are you sure you want to remove "${m.titleEn}"?'),
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
                          await widget.controller.deleteModule(m.id);
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
