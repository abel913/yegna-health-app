import 'package:flutter/material.dart';

import '../discovery/mentor_model.dart';
import '../theme/app_glass_theme.dart';
import 'admin_controller.dart';
import 'content_templates.dart';

class AdminMentorsPage extends StatefulWidget {
  const AdminMentorsPage({
    required this.controller,
    super.key,
  });

  final AdminController controller;

  @override
  State<AdminMentorsPage> createState() => _AdminMentorsPageState();
}

class _AdminMentorsPageState extends State<AdminMentorsPage> {
  void _openMentorEditor([Mentor? initial]) {
    final isEditing = initial != null;
    final idController = TextEditingController(
      text: initial?.id ?? 'mentor_${DateTime.now().millisecondsSinceEpoch}',
    );
    final nameEn = TextEditingController(text: initial?.nameEn ?? '');
    final nameAm = TextEditingController(text: initial?.nameAm ?? '');
    final titleEn = TextEditingController(
        text: initial?.titleEn ?? 'Certified Peer Counselor');
    final titleAm =
        TextEditingController(text: initial?.titleAm ?? 'የተረጋገጠ የአቻ አማካሪ');
    final orgEn = TextEditingController(
        text: initial?.organizationEn ?? 'Yegna Youth Network');
    final orgAm = TextEditingController(
        text: initial?.organizationAm ?? 'የእኛ ወጣቶች አውታረ መረብ');
    final phone =
        TextEditingController(text: initial?.phoneNumber ?? '+251911234567');
    final telegram =
        TextEditingController(text: initial?.telegramHandle ?? 'yegna_mentor');
    final hours = TextEditingController(
        text: initial?.workingHoursEn ?? 'Mon – Fri: 8:30 AM – 5:30 PM');

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
                  isEditing ? 'Edit Mentor' : 'Add Peer Mentor',
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
                    final t = ContentTemplates.mentorTemplates.first;
                    setDialogState(() {
                      nameEn.text = t.nameEn;
                      nameAm.text = t.nameAm;
                      titleEn.text = t.titleEn;
                      titleAm.text = t.titleAm;
                      orgEn.text = t.organizationEn;
                      orgAm.text = t.organizationAm;
                      phone.text = t.phoneNumber;
                      telegram.text = t.telegramHandle;
                      hours.text = t.workingHoursEn;
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
                      controller: nameEn,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'Mentor Full Name (English)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameAm,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'የአማካሪው ሙሉ ስም (አማርኛ)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: titleEn,
                            style: TextStyle(
                                fontSize: 13.5, color: glass.titleText),
                            decoration: const InputDecoration(
                              labelText: 'Title / Specialty (English)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: orgEn,
                            style: TextStyle(
                                fontSize: 13.5, color: glass.titleText),
                            decoration: const InputDecoration(
                              labelText: 'Organization',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: phone,
                            style: TextStyle(
                                fontSize: 13.5, color: glass.titleText),
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: telegram,
                            style: TextStyle(
                                fontSize: 13.5, color: glass.titleText),
                            decoration: const InputDecoration(
                              labelText: 'Telegram Handle (@username)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: hours,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'Working Hours',
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
                  if (nameEn.text.trim().isEmpty) return;
                  final mentor = Mentor(
                    id: idController.text.trim(),
                    nameEn: nameEn.text.trim(),
                    nameAm: nameAm.text.trim().isNotEmpty
                        ? nameAm.text.trim()
                        : nameEn.text.trim(),
                    titleEn: titleEn.text.trim(),
                    titleAm: titleAm.text.trim().isNotEmpty
                        ? titleAm.text.trim()
                        : titleEn.text.trim(),
                    organizationEn: orgEn.text.trim(),
                    organizationAm: orgAm.text.trim().isNotEmpty
                        ? orgAm.text.trim()
                        : orgEn.text.trim(),
                    bioEn: initial?.bioEn ??
                        'Certified mentor providing youth reproductive and mental health peer guidance.',
                    bioAm: initial?.bioAm ??
                        'የስነ-ተዋልዶ እና አእምሮ ጤና አቻ የምክር ድጋፍ የሚሰጥ አማካሪ።',
                    isVerified: true,
                    isOnline: true,
                    nextAvailableSlotEn: 'Available Today',
                    nextAvailableSlotAm: 'ዛሬ ክፍት ነው',
                    languages: const ['Amharic', 'English'],
                    topics: const [
                      MentorTopic.mentalHealth,
                      MentorTopic.srhGuidance
                    ],
                    sessionsCount: initial?.sessionsCount ?? 150,
                    experienceYears: initial?.experienceYears ?? 3,
                    initials: nameEn.text.trim().isNotEmpty
                        ? nameEn.text.trim()[0]
                        : 'M',
                    avatarColor: const Color(0xFF0284C7),
                    phoneNumber: phone.text.trim(),
                    displayPhoneNumber: phone.text.trim(),
                    telegramHandle: telegram.text.trim().replaceFirst('@', ''),
                    workingHoursEn: hours.text.trim(),
                    workingHoursAm: hours.text.trim(),
                  );
                  await widget.controller.saveMentor(mentor);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
                child: const Text('Save Mentor'),
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
          isAmharic ? 'የአማካሪዎች ማስተዳደሪያ' : 'Manage Peer Mentors',
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
            tooltip: 'Add Mentor',
            onPressed: () => _openMentorEditor(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final mentors = widget.controller.mentors;
          if (mentors.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.people_alt_rounded,
                      size: 48, color: Color(0xFF38BDF8)),
                  const SizedBox(height: 12),
                  Text(
                    'No mentors registered yet.',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: glass.titleText),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Mentor'),
                    onPressed: () => _openMentorEditor(),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: mentors.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final m = mentors[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: glass.cardBackground,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: glass.cardBorder, width: 1.2),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFF0284C7),
                      child: Text(
                        m.nameEn.isNotEmpty ? m.nameEn[0] : 'M',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAmharic ? m.nameAm : m.nameEn,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: glass.titleText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isAmharic ? m.titleAm : m.titleEn,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: glass.subtitleText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '📞 ${m.phoneNumber} • @${m.telegramHandle}',
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
                      onPressed: () => _openMentorEditor(m),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          size: 20, color: Color(0xFFEF4444)),
                      tooltip: 'Delete',
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Mentor?'),
                            content: Text(
                                'Are you sure you want to remove "${m.nameEn}"?'),
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
                          await widget.controller.deleteMentor(m.id);
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
