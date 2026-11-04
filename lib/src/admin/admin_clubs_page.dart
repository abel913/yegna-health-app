import 'package:flutter/material.dart';

import '../clubs/club_models.dart';
import '../theme/app_glass_theme.dart';
import 'admin_controller.dart';
import 'content_templates.dart';

class AdminClubsPage extends StatefulWidget {
  const AdminClubsPage({
    required this.controller,
    super.key,
  });

  final AdminController controller;

  @override
  State<AdminClubsPage> createState() => _AdminClubsPageState();
}

class _AdminClubsPageState extends State<AdminClubsPage> {
  void _openClubEditor([StudentClub? initial]) {
    final isEditing = initial != null;
    final idController = TextEditingController(
      text: initial?.id ?? 'club_${DateTime.now().millisecondsSinceEpoch}',
    );
    final nameEn = TextEditingController(text: initial?.nameEn ?? '');
    final nameAm = TextEditingController(text: initial?.nameAm ?? '');
    final descEn = TextEditingController(text: initial?.descriptionEn ?? '');
    final descAm = TextEditingController(text: initial?.descriptionAm ?? '');
    final scheduleEn = TextEditingController(
        text: initial?.meetingScheduleEn ?? 'Every Friday, 4:30 PM');
    final scheduleAm = TextEditingController(
        text: initial?.meetingScheduleAm ?? 'በየሳምንቱ አርብ፡ ከቀኑ 10:30');
    final locationEn = TextEditingController(
        text: initial?.meetingLocationEn ?? 'Campus Hall B');
    final locationAm = TextEditingController(
        text: initial?.meetingLocationAm ?? 'የግቢው አዳራሽ ቢ');
    final mentorNameEn =
        TextEditingController(text: initial?.mentorNameEn ?? 'Sister Hanna');
    final mentorNameAm =
        TextEditingController(text: initial?.mentorNameAm ?? 'ሲስተር ሀና');
    final mentorContact = TextEditingController(
        text: initial?.mentorContact ?? '+251 91 123 4567');
    final capacity =
        TextEditingController(text: initial?.maxCapacity?.toString() ?? '50');

    ClubCategory selectedCategory =
        initial?.category ?? ClubCategory.srhWellness;

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
                  isEditing ? 'Edit Student Club' : 'Create Student Club',
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
                    final t = ContentTemplates.clubTemplates.first;
                    setDialogState(() {
                      nameEn.text = t.nameEn;
                      nameAm.text = t.nameAm;
                      descEn.text = t.descriptionEn;
                      descAm.text = t.descriptionAm;
                      scheduleEn.text = t.meetingScheduleEn;
                      scheduleAm.text = t.meetingScheduleAm;
                      locationEn.text = t.meetingLocationEn;
                      locationAm.text = t.meetingLocationAm;
                      mentorNameEn.text = t.mentorNameEn;
                      mentorNameAm.text = t.mentorNameAm;
                      mentorContact.text = t.mentorContact;
                      capacity.text = t.maxCapacity?.toString() ?? '50';
                      selectedCategory = t.category;
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
                        labelText: 'Club Name (English)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameAm,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'የክበቡ ስም (አማርኛ)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<ClubCategory>(
                      initialValue: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: ClubCategory.values
                          .where((c) => c != ClubCategory.all)
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c.name.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setDialogState(() => selectedCategory = v);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descEn,
                      maxLines: 2,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'Description (English)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descAm,
                      maxLines: 2,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'መግለጫ (አማርኛ)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: scheduleEn,
                            style: TextStyle(
                                fontSize: 13.5, color: glass.titleText),
                            decoration: const InputDecoration(
                              labelText: 'Meeting Schedule (English)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: locationEn,
                            style: TextStyle(
                                fontSize: 13.5, color: glass.titleText),
                            decoration: const InputDecoration(
                              labelText: 'Venue / Online Link',
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
                            controller: mentorNameEn,
                            style: TextStyle(
                                fontSize: 13.5, color: glass.titleText),
                            decoration: const InputDecoration(
                              labelText: 'Assigned Mentor',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: capacity,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontSize: 13.5, color: glass.titleText),
                            decoration: const InputDecoration(
                              labelText: 'Capacity Limit',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
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
                  final club = StudentClub(
                    id: idController.text.trim(),
                    nameEn: nameEn.text.trim(),
                    nameAm: nameAm.text.trim().isNotEmpty
                        ? nameAm.text.trim()
                        : nameEn.text.trim(),
                    descriptionEn: descEn.text.trim(),
                    descriptionAm: descAm.text.trim().isNotEmpty
                        ? descAm.text.trim()
                        : descEn.text.trim(),
                    category: selectedCategory,
                    meetingScheduleEn: scheduleEn.text.trim(),
                    meetingScheduleAm: scheduleAm.text.trim().isNotEmpty
                        ? scheduleAm.text.trim()
                        : scheduleEn.text.trim(),
                    meetingLocationEn: locationEn.text.trim(),
                    meetingLocationAm: locationAm.text.trim().isNotEmpty
                        ? locationAm.text.trim()
                        : locationEn.text.trim(),
                    mentorNameEn: mentorNameEn.text.trim(),
                    mentorNameAm: mentorNameAm.text.trim().isNotEmpty
                        ? mentorNameAm.text.trim()
                        : mentorNameEn.text.trim(),
                    mentorContact: mentorContact.text.trim(),
                    memberCount: initial?.memberCount ?? 0,
                    maxCapacity: int.tryParse(capacity.text.trim()) ?? 50,
                    rulesEn: initial?.rulesEn ??
                        const [
                          'Respect peer privacy.',
                          'Inclusive safe space.',
                          'Support all members.',
                        ],
                    rulesAm: initial?.rulesAm ??
                        const [
                          'ሚስጥራዊነትን መጠበቅ።',
                          'ከፍረጃ ነፃ ቦታ መፍጠር።',
                          'ሁሉንም መደገፍ።',
                        ],
                    createdAt: initial?.createdAt ?? DateTime.now(),
                  );
                  await widget.controller.saveClub(club);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
                child: const Text('Save Club'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showClubRoster(StudentClub club) async {
    final roster = await widget.controller.getClubRoster(club.id);
    if (!mounted) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final glass = ctx.glassTheme;
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.75,
          ),
          decoration: BoxDecoration(
            color: glass.modalBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: glass.cardBorder, width: 1.2),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: glass.modalHandle,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.people_alt_rounded,
                          color: Color(0xFF38BDF8), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Member Roster: ${club.nameEn}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: glass.titleText,
                            ),
                          ),
                          Text(
                            '${roster.length} enrolled student(s)',
                            style: TextStyle(
                              fontSize: 12,
                              color: glass.subtitleText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: glass.divider),
              Expanded(
                child: roster.isEmpty
                    ? Center(
                        child: Text(
                          'No registered members in this club yet.',
                          style: TextStyle(
                            fontSize: 13,
                            color: glass.subtitleText,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: roster.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (ctx, index) {
                          final mem = roster[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF0284C7),
                              child: Text(
                                mem.userName.isNotEmpty ? mem.userName[0] : 'S',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              mem.userName,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: glass.titleText,
                              ),
                            ),
                            subtitle: Text(
                              '${mem.userEmail} • Joined ${mem.joinedAt.month}/${mem.joinedAt.day}/${mem.joinedAt.year}',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: glass.subtitleText,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'ACTIVE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF10B981),
                                ),
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
          isAmharic ? 'የተማሪዎች ክበቦች ማስተዳደሪያ' : 'Manage Student Clubs',
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
            tooltip: 'Add Club',
            onPressed: () => _openClubEditor(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final clubs = widget.controller.clubs;
          if (clubs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.groups_rounded,
                      size: 48, color: Color(0xFF38BDF8)),
                  const SizedBox(height: 12),
                  Text(
                    'No clubs configured yet.',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: glass.titleText),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Create Club'),
                    onPressed: () => _openClubEditor(),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: clubs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final c = clubs[index];
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
                            c.category.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF38BDF8),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '👥 ${c.memberCount} members',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: glass.subtitleText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isAmharic ? c.nameAm : c.nameEn,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: glass.titleText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isAmharic ? c.descriptionAm : c.descriptionEn,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: glass.subtitleText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                          ),
                          icon: const Icon(Icons.people_alt_outlined, size: 16),
                          label: const Text('Roster',
                              style: TextStyle(fontSize: 12)),
                          onPressed: () => _showClubRoster(c),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          tooltip: 'Edit',
                          onPressed: () => _openClubEditor(c),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded,
                              size: 18, color: Color(0xFFEF4444)),
                          tooltip: 'Delete',
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Delete Club?'),
                                content: Text(
                                    'Are you sure you want to remove "${c.nameEn}"?'),
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
                              await widget.controller.deleteClub(c.id);
                            }
                          },
                        ),
                      ],
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
