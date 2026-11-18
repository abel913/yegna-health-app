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

class _AdminClubsPageState extends State<AdminClubsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  final _memberSearchController = TextEditingController();

  ClubCategory _selectedCategory = ClubCategory.all;
  String _statusFilter = 'all'; // all, active, inactive, nearCapacity
  String _sortBy = 'members'; // members, name, capacity, newest
  String? _rosterClubFilter; // null = all clubs

  List<ClubMembership> _allMemberships = [];
  bool _isLoadingMembers = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMemberships();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _memberSearchController.dispose();
    super.dispose();
  }

  Future<void> _loadMemberships() async {
    setState(() => _isLoadingMembers = true);
    try {
      final members = await widget.controller.getAllClubMemberships();
      if (mounted) {
        setState(() {
          _allMemberships = members;
          _isLoadingMembers = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingMembers = false);
      }
    }
  }

  String _categoryLabel(ClubCategory category, bool isAmharic) {
    return switch (category) {
      ClubCategory.all => isAmharic ? 'ሁሉም' : 'All',
      ClubCategory.mentalHealth => isAmharic ? 'አእምሮ ጤና' : 'Mental Health',
      ClubCategory.srhWellness => isAmharic ? 'ስነ-ተዋልዶ' : 'SRH Wellness',
      ClubCategory.antiSubstance => isAmharic ? 'ከሱስ ነፃ' : 'Anti-Substance',
      ClubCategory.firstAid => isAmharic ? 'የመጀመሪያ እርዳታ' : 'First Aid',
      ClubCategory.girlsHygiene => isAmharic ? 'የሴቶች ንፅህና' : 'Girls\' Hygiene',
      ClubCategory.peerLeadership => isAmharic ? 'የአቻ አመራር' : 'Peer Leadership',
    };
  }

  IconData _categoryIcon(ClubCategory category) {
    return switch (category) {
      ClubCategory.all => Icons.grid_view_rounded,
      ClubCategory.mentalHealth => Icons.psychology_rounded,
      ClubCategory.srhWellness => Icons.favorite_rounded,
      ClubCategory.antiSubstance => Icons.health_and_safety_rounded,
      ClubCategory.firstAid => Icons.medical_services_rounded,
      ClubCategory.girlsHygiene => Icons.spa_rounded,
      ClubCategory.peerLeadership => Icons.groups_rounded,
    };
  }

  Color _categoryColor(ClubCategory category) {
    return switch (category) {
      ClubCategory.all => const Color(0xFF0284C7),
      ClubCategory.mentalHealth => const Color(0xFF38BDF8),
      ClubCategory.srhWellness => const Color(0xFFEC4899),
      ClubCategory.antiSubstance => const Color(0xFF10B981),
      ClubCategory.firstAid => const Color(0xFFEF4444),
      ClubCategory.girlsHygiene => const Color(0xFF8B5CF6),
      ClubCategory.peerLeadership => const Color(0xFFF59E0B),
    };
  }

  // --- CLUB CREATION & EDITING ---
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
        text: initial?.meetingLocationEn ?? 'Youth Center Hall A');
    final locationAm = TextEditingController(
        text: initial?.meetingLocationAm ?? 'የወጣቶች ማዕከል አዳራሽ ሀ');
    final mentorNameEn =
        TextEditingController(text: initial?.mentorNameEn ?? 'Sister Hanna');
    final mentorNameAm =
        TextEditingController(text: initial?.mentorNameAm ?? 'ሲስተር ሀና');
    final mentorContact = TextEditingController(
        text: initial?.mentorContact ?? '+251 91 123 4567');
    final capacity =
        TextEditingController(text: initial?.maxCapacity?.toString() ?? '50');
    final tagsController =
        TextEditingController(text: initial?.tags.join(', ') ?? 'Wellness, Peer Support');

    ClubCategory selectedCategory =
        initial?.category ?? ClubCategory.srhWellness;
    bool isActive = initial?.isActive ?? true;

    final ruleControllers = (initial?.rulesEn ?? [
      'Maintain 100% confidentiality and respect peer privacy.',
      'Create an inclusive, judgment-free safe space.',
      'Active participation and support for all members.',
    ]).map((r) => TextEditingController(text: r)).toList();
    final rulesAmList = List<String>.from(initial?.rulesAm ?? [
      '100% ሚስጥራዊነትን መጠበቅ እና የአቻዎችን ግላዊነት ማክበር።',
      'ከፍረጃ ነፃ የሆነ እና ሁሉን አቀፍ አስተማማኝ ቦታ መፍጠር።',
      'ንቁ ተሳትፎ እና ለሁሉም አባላት እርስ በእርስ ድጋፍ መስጠት።',
    ]);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final glass = ctx.glassTheme;
          final isAmharic =
              Localizations.localeOf(context).languageCode == 'am';

          return AlertDialog(
            backgroundColor: glass.modalBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: glass.cardBorder, width: 1.2),
            ),
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            actionsPadding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isEditing
                            ? Icons.edit_note_rounded
                            : Icons.add_circle_outline_rounded,
                        color: const Color(0xFF38BDF8),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isEditing
                          ? (isAmharic ? 'ክበቡን ያሻሽሉ' : 'Edit Student Club')
                          : (isAmharic ? 'አዲስ ክበብ ይፍጠሩ' : 'Create Student Club'),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: glass.titleText,
                      ),
                    ),
                  ],
                ),
                PopupMenuButton<StudentClub>(
                  tooltip: 'Load Preset Template',
                  icon: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_fix_high_rounded,
                            size: 14, color: Color(0xFF38BDF8)),
                        const SizedBox(width: 4),
                        Text(
                          isAmharic ? 'አብነቶች' : 'Template',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF38BDF8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (ctx) => ContentTemplates.clubTemplates
                      .map(
                        (t) => PopupMenuItem<StudentClub>(
                          value: t,
                          child: Text(t.nameEn,
                              style: const TextStyle(fontSize: 13)),
                        ),
                      )
                      .toList(),
                  onSelected: (t) {
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
                      tagsController.text = t.tags.join(', ');
                      ruleControllers.clear();
                      for (final r in t.rulesEn) {
                        ruleControllers.add(TextEditingController(text: r));
                      }
                      rulesAmList.clear();
                      rulesAmList.addAll(t.rulesAm);
                    });
                  },
                ),
              ],
            ),
            content: SizedBox(
              width: 580,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.75,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    const Divider(height: 1),
                    const SizedBox(height: 14),

                    // Active Switch
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: glass.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: glass.cardBorder),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isAmharic ? 'የክበቡ ሁኔታ' : 'Club Active Status',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: glass.titleText,
                                ),
                              ),
                              Text(
                                isActive
                                    ? (isAmharic
                                        ? 'ተማሪዎች መቀላቀል ይችላሉ'
                                        : 'Visible and open for student registration')
                                    : (isAmharic
                                        ? 'ጊዜያዊ ምዝገባ ታግዷል'
                                        : 'Paused / Hidden from new signups'),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: glass.subtitleText,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: isActive,
                            activeTrackColor:
                                const Color(0xFF10B981).withValues(alpha: 0.5),
                            activeThumbColor: const Color(0xFF10B981),
                            onChanged: (v) =>
                                setDialogState(() => isActive = v),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Section: Basic Info
                    Text(
                      isAmharic ? 'መሰረታዊ መረጃ' : 'IDENTIFICATION & CATEGORY',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF38BDF8),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameEn,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: InputDecoration(
                        labelText: 'Club Name (English) *',
                        prefixIcon: const Icon(Icons.groups_rounded, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameAm,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: InputDecoration(
                        labelText: 'የክበቡ ስም (አማርኛ) *',
                        prefixIcon: const Icon(Icons.translate_rounded, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<ClubCategory>(
                      initialValue: selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category *',
                        prefixIcon: Icon(_categoryIcon(selectedCategory),
                            size: 20, color: _categoryColor(selectedCategory)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: ClubCategory.values
                          .where((c) => c != ClubCategory.all)
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Row(
                                children: [
                                  Icon(_categoryIcon(c),
                                      size: 16, color: _categoryColor(c)),
                                  const SizedBox(width: 8),
                                  Text(_categoryLabel(c, isAmharic)),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setDialogState(() => selectedCategory = v);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Section: Descriptions
                    Text(
                      isAmharic ? 'የክበቡ መግለጫ እና አላማ' : 'CLUB PURPOSE & MISSION',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF38BDF8),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descEn,
                      maxLines: 2,
                      style: TextStyle(fontSize: 13, color: glass.titleText),
                      decoration: InputDecoration(
                        labelText: 'Description (English)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descAm,
                      maxLines: 2,
                      style: TextStyle(fontSize: 13, color: glass.titleText),
                      decoration: InputDecoration(
                        labelText: 'መግለጫ (አማርኛ)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section: Schedule & Location
                    Text(
                      isAmharic ? 'የስብሰባ ጊዜ እና ቦታ' : 'LOGISTICS & SCHEDULE',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF38BDF8),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: scheduleEn,
                            style: TextStyle(
                                fontSize: 13, color: glass.titleText),
                            decoration: InputDecoration(
                              labelText: 'Schedule (EN)',
                              prefixIcon:
                                  const Icon(Icons.schedule_rounded, size: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: scheduleAm,
                            style: TextStyle(
                                fontSize: 13, color: glass.titleText),
                            decoration: InputDecoration(
                              labelText: 'የስብሰባ ጊዜ (አማርኛ)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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
                            controller: locationEn,
                            style: TextStyle(
                                fontSize: 13, color: glass.titleText),
                            decoration: InputDecoration(
                              labelText: 'Venue / Link (EN)',
                              prefixIcon: const Icon(
                                  Icons.location_on_outlined,
                                  size: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: locationAm,
                            style: TextStyle(
                                fontSize: 13, color: glass.titleText),
                            decoration: InputDecoration(
                              labelText: 'የስብሰባ ቦታ (አማርኛ)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Section: Mentor / Counselor Supervision & Direct Phone
                    Row(
                      children: [
                        const Icon(Icons.phone_in_talk_rounded,
                            size: 14, color: Color(0xFF38BDF8)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            isAmharic
                                ? 'የአማካሪ መረጃ እና የቀጥታ ስልክ ቁጥር'
                                : 'COUNSELOR SUPERVISION & DIRECT PHONE',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF38BDF8),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: mentorNameEn,
                            style: TextStyle(
                                fontSize: 13, color: glass.titleText),
                            decoration: InputDecoration(
                              labelText: isAmharic
                                  ? 'የአማካሪ ስም (እንግሊዝኛ) *'
                                  : 'Counselor Name (EN) *',
                              prefixIcon: const Icon(Icons.person_pin_rounded,
                                  size: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: mentorNameAm,
                            style: TextStyle(
                                fontSize: 13, color: glass.titleText),
                            decoration: InputDecoration(
                              labelText: isAmharic
                                  ? 'የአማካሪው ስም (አማርኛ)'
                                  : 'Counselor Name (Amharic)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: mentorContact,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                                fontSize: 13, color: glass.titleText),
                            decoration: InputDecoration(
                              labelText: isAmharic
                                  ? 'የአማካሪው ስልክ ቁጥር *'
                                  : 'Counselor Phone Number (e.g. +251 91 123 4567) *',
                              hintText: '+251 91 123 4567',
                              helperText: isAmharic
                                  ? 'ተማሪዎች በቀጥታ የሚደውሉበት ስልክ'
                                  : 'Direct phone number for student counseling',
                              prefixIcon:
                                  const Icon(Icons.phone_in_talk_rounded,
                                      size: 18, color: Color(0xFF0284C7)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: capacity,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontSize: 13, color: glass.titleText),
                            decoration: InputDecoration(
                              labelText: isAmharic ? 'ከፍተኛ አቅም' : 'Max Capacity',
                              prefixIcon: const Icon(
                                  Icons.pie_chart_outline_rounded,
                                  size: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: tagsController,
                      style: TextStyle(fontSize: 13, color: glass.titleText),
                      decoration: InputDecoration(
                        labelText: 'Tags (comma separated)',
                        prefixIcon: const Icon(Icons.tag_rounded, size: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section: Community Guidelines & Safe Space Rules
                    Row(
                      children: [
                        const Icon(Icons.verified_user_outlined,
                            size: 14, color: Color(0xFF38BDF8)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            isAmharic
                                ? 'የማህበረሰብ መመሪያዎች *'
                                : 'COMMUNITY GUIDELINES & RULES *',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF38BDF8),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.add_circle_outline_rounded,
                              size: 15),
                          label: Text(isAmharic ? 'መመሪያ ጨምር' : 'Add Guideline',
                              style: const TextStyle(fontSize: 11.5)),
                          onPressed: () {
                            setDialogState(() {
                              ruleControllers.add(TextEditingController(
                                  text: 'Respect peer privacy and safe communication.'));
                              rulesAmList.add('የአቻዎችን ሚስጥራዊነት መጠበቅ።');
                            });
                          },
                        ),
                      ],
                    ),
                    Text(
                      isAmharic
                          ? 'ተማሪዎች ክበቡን ከመቀላቀላቸው በፊት እነዚህን መመሪያዎች ያያሉ'
                          : 'Displayed with checkmarks in the student club sheet before joining',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: glass.subtitleText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...List.generate(ruleControllers.length, (idx) {
                      return Padding(
                        key: ValueKey(ruleControllers[idx]),
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 11,
                              backgroundColor: const Color(0xFF0284C7),
                              child: Text('${idx + 1}',
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: ruleControllers[idx],
                                style: TextStyle(
                                    fontSize: 12.5, color: glass.titleText),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: isAmharic
                                      ? 'የክበቡ መመሪያ ወይም ቃል-ኪዳን...'
                                      : 'Enter safe space rule or pledge...',
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded,
                                  size: 16, color: Color(0xFFEF4444)),
                              onPressed: () {
                                if (ruleControllers.length > 1) {
                                  setDialogState(() {
                                    final removed = ruleControllers.removeAt(idx);
                                    removed.dispose();
                                    if (idx < rulesAmList.length) {
                                      rulesAmList.removeAt(idx);
                                    }
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  isAmharic ? 'ሰርዝ' : 'Cancel',
                  style: TextStyle(color: glass.subtitleText),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.save_rounded, size: 18),
                label: Text(
                  isEditing
                      ? (isAmharic ? 'አሻሽል' : 'Update Club')
                      : (isAmharic ? 'ክበብ ፍጠር' : 'Create Club'),
                ),
                onPressed: () async {
                  if (nameEn.text.trim().isEmpty) return;

                  final rawTags = tagsController.text
                      .split(',')
                      .map((t) => t.trim())
                      .where((t) => t.isNotEmpty)
                      .toList();

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
                    rulesEn: ruleControllers
                        .map((c) => c.text.trim())
                        .where((t) => t.isNotEmpty)
                        .toList(),
                    rulesAm: rulesAmList,
                    isActive: isActive,
                    tags: rawTags,
                    createdAt: initial?.createdAt ?? DateTime.now(),
                  );

                  await widget.controller.saveClub(club);
                  await _loadMemberships();

                  if (ctx.mounted) {
                    Navigator.of(ctx).pop();
                  }
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isAmharic
                              ? '"${club.nameAm}" በተሳካ ሁኔታ ተቀምጧል!'
                              : '"${club.nameEn}" saved successfully!',
                        ),
                        backgroundColor: const Color(0xFF10B981),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // --- CLUB ROSTER INSPECTOR MODAL ---
  void _showClubRoster(StudentClub club) async {
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    final roster = await widget.controller.getClubRoster(club.id);
    if (!mounted) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final glass = ctx.glassTheme;
            final count = roster.length;
            final capacity = club.maxCapacity ?? 50;
            final percent = (count / capacity).clamp(0.0, 1.0);

            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(ctx).size.height * 0.85,
              ),
              decoration: BoxDecoration(
                color: glass.modalBackground,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(color: glass.cardBorder, width: 1.2),
              ),
              child: Column(
                children: [
                  // Handle
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

                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: _categoryColor(club.category)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(_categoryIcon(club.category),
                              color: _categoryColor(club.category), size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isAmharic ? club.nameAm : club.nameEn,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: glass.titleText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_categoryLabel(club.category, isAmharic)} • Mentor: ${isAmharic ? club.mentorNameAm : club.mentorNameEn}',
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

                  // Capacity Saturation Progress Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: glass.cardBackground,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: glass.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isAmharic
                                    ? 'የአባላት ሙላት መጠን'
                                    : 'Enrollment Capacity',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: glass.titleText,
                                ),
                              ),
                              Text(
                                '$count / $capacity (${(percent * 100).toStringAsFixed(1)}%)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: percent >= 1.0
                                      ? const Color(0xFFEF4444)
                                      : (percent >= 0.8
                                          ? const Color(0xFFF59E0B)
                                          : const Color(0xFF10B981)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: percent,
                              minHeight: 7,
                              backgroundColor: glass.divider,
                              valueColor: AlwaysStoppedAnimation(
                                percent >= 1.0
                                    ? const Color(0xFFEF4444)
                                    : (percent >= 0.8
                                        ? const Color(0xFFF59E0B)
                                        : const Color(0xFF10B981)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Divider(height: 1, color: glass.divider),

                  // Members List
                  Expanded(
                    child: roster.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.people_outline_rounded,
                                    size: 40, color: glass.subtitleText),
                                const SizedBox(height: 8),
                                Text(
                                  isAmharic
                                      ? 'እስካሁን ምንም ተማሪ አልተመዘገበም'
                                      : 'No registered members in this club yet.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: glass.subtitleText,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: roster.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (ctx, index) {
                              final mem = roster[index];
                              final isLead = mem.role == 'lead';

                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: glass.cardBackground,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: glass.cardBorder),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: isLead
                                          ? const Color(0xFFF59E0B)
                                          : const Color(0xFF0284C7),
                                      child: Text(
                                        mem.userName.isNotEmpty
                                            ? mem.userName[0].toUpperCase()
                                            : 'S',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                mem.userName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13.5,
                                                  color: glass.titleText,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: isLead
                                                      ? const Color(0xFFF59E0B)
                                                          .withValues(alpha: 0.15)
                                                      : const Color(0xFF10B981)
                                                          .withValues(alpha: 0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  isLead
                                                      ? (isAmharic
                                                          ? 'የክበብ መሪ'
                                                          : 'CLUB LEAD')
                                                      : (isAmharic
                                                          ? 'አባል'
                                                          : 'MEMBER'),
                                                  style: TextStyle(
                                                    fontSize: 9.5,
                                                    fontWeight: FontWeight.w800,
                                                    color: isLead
                                                        ? const Color(0xFFF59E0B)
                                                        : const Color(0xFF10B981),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${mem.userEmail} • Joined ${mem.joinedAt.month}/${mem.joinedAt.day}/${mem.joinedAt.year}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: glass.subtitleText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      icon: Icon(Icons.more_vert_rounded,
                                          color: glass.subtitleText, size: 20),
                                      itemBuilder: (ctx) => [
                                        PopupMenuItem(
                                          value: isLead ? 'member' : 'lead',
                                          child: Text(
                                            isLead
                                                ? (isAmharic
                                                    ? 'ወደ መደበኛ አባል ቀይር'
                                                    : 'Change to Member')
                                                : (isAmharic
                                                    ? 'ወደ ክበብ መሪነት አሳድግ'
                                                    : 'Promote to Club Lead'),
                                            style:
                                                const TextStyle(fontSize: 12.5),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'remove',
                                          child: Text(
                                            isAmharic
                                                ? 'ከክበብ አስወግድ'
                                                : 'Remove from Club',
                                            style: const TextStyle(
                                              fontSize: 12.5,
                                              color: Color(0xFFEF4444),
                                            ),
                                          ),
                                        ),
                                      ],
                                      onSelected: (action) async {
                                        if (action == 'remove') {
                                          await widget.controller
                                              .removeClubMember(
                                                  club.id, mem.userId);
                                          roster.removeWhere((m) =>
                                              m.userId == mem.userId);
                                          await _loadMemberships();
                                          setSheetState(() {});
                                        } else {
                                          await widget.controller
                                              .updateClubMemberRole(
                                                  club.id, mem.userId, action);
                                          final idx = roster.indexWhere((m) =>
                                              m.userId == mem.userId);
                                          if (idx >= 0) {
                                            roster[idx] = roster[idx]
                                                .copyWith(role: action);
                                          }
                                          await _loadMemberships();
                                          setSheetState(() {});
                                        }
                                      },
                                    ),
                                  ],
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
      },
    );
  }

  // --- STATS HEADER WIDGET ---
  Widget _buildExecutiveStats(List<StudentClub> clubs, bool isAmharic) {
    final glass = context.glassTheme;
    final totalClubs = clubs.length;
    final activeClubs = clubs.where((c) => c.isActive).length;
    final totalEnrollments = _allMemberships.length;
    final uniqueStudents =
        _allMemberships.map((m) => m.userId).toSet().length;

    int totalCapacity = 0;
    for (final c in clubs) {
      totalCapacity += c.maxCapacity ?? 50;
    }
    final occupancyPercent = totalCapacity > 0
        ? ((totalEnrollments / totalCapacity) * 100).toStringAsFixed(1)
        : '0.0';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: glass.isDark
              ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
              : [const Color(0xFFE0F2FE), const Color(0xFFBAE6FD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF0284C7).withValues(alpha: 0.3),
          width: 1.2,
        ),
        boxShadow: glass.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.analytics_rounded,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAmharic
                            ? 'የክበቦች አጠቃላይ ስታቲስቲክስ'
                            : 'CLUBS ENGAGEMENT INTELLIGENCE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: glass.isDark
                              ? const Color(0xFF38BDF8)
                              : const Color(0xFF0369A1),
                          letterSpacing: 0.6,
                        ),
                      ),
                      Text(
                        isAmharic
                            ? 'የአባላት ተሳትፎ እና የክበብ አቅም መቆጣጠሪያ'
                            : 'Real-time enrollment, capacity & rosters',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: glass.titleText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 20),
                tooltip: 'Refresh Analytics',
                onPressed: () {
                  widget.controller.loadDashboard();
                  _loadMemberships();
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildStatPill(
                icon: Icons.groups_rounded,
                label: isAmharic ? 'ክበቦች' : 'Total Clubs',
                value: '$totalClubs ($activeClubs On)',
                color: const Color(0xFF0284C7),
              ),
              const SizedBox(width: 8),
              _buildStatPill(
                icon: Icons.assignment_ind_rounded,
                label: isAmharic ? 'ምዝገባዎች' : 'Enrollments',
                value: '$totalEnrollments',
                color: const Color(0xFF10B981),
              ),
              const SizedBox(width: 8),
              _buildStatPill(
                icon: Icons.person_rounded,
                label: isAmharic ? 'ተማሪዎች' : 'Students',
                value: '$uniqueStudents',
                color: const Color(0xFF8B5CF6),
              ),
              const SizedBox(width: 8),
              _buildStatPill(
                icon: Icons.pie_chart_rounded,
                label: isAmharic ? 'ሙላት %' : 'Occupancy',
                value: '$occupancyPercent%',
                color: const Color(0xFFF59E0B),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final glass = context.glassTheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: glass.isDark
              ? const Color(0xFF0B132B).withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w900,
                color: glass.titleText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: glass.subtitleText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: CLUBS DIRECTORY ---
  Widget _buildClubsDirectoryTab(List<StudentClub> clubs, bool isAmharic) {
    final glass = context.glassTheme;

    // Filter by category
    var list = List<StudentClub>.from(clubs);
    if (_selectedCategory != ClubCategory.all) {
      list = list.where((c) => c.category == _selectedCategory).toList();
    }

    // Filter by search query
    final q = _searchController.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((c) {
        final en = c.nameEn.toLowerCase();
        final am = c.nameAm.toLowerCase();
        final desc = c.descriptionEn.toLowerCase();
        final mentor = c.mentorNameEn.toLowerCase();
        final loc = c.meetingLocationEn.toLowerCase();
        final tags = c.tags.join(' ').toLowerCase();
        return en.contains(q) ||
            am.contains(q) ||
            desc.contains(q) ||
            mentor.contains(q) ||
            loc.contains(q) ||
            tags.contains(q);
      }).toList();
    }

    // Filter by status
    if (_statusFilter == 'active') {
      list = list.where((c) => c.isActive).toList();
    } else if (_statusFilter == 'inactive') {
      list = list.where((c) => !c.isActive).toList();
    } else if (_statusFilter == 'nearCapacity') {
      list = list.where((c) => c.isNearCapacity || c.isAtCapacity).toList();
    }

    // Sort
    if (_sortBy == 'members') {
      list.sort((a, b) => b.memberCount.compareTo(a.memberCount));
    } else if (_sortBy == 'name') {
      list.sort((a, b) => a.nameEn.compareTo(b.nameEn));
    } else if (_sortBy == 'capacity') {
      list.sort(
          (a, b) => b.capacityUtilization.compareTo(a.capacityUtilization));
    } else if (_sortBy == 'newest') {
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return Column(
      children: [
        // Search & Category Filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: glass.cardBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: glass.cardBorder),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: TextStyle(fontSize: 13.5, color: glass.titleText),
              decoration: InputDecoration(
                hintText: isAmharic
                    ? 'ክበብ፣ አማካሪ ወይም መለያ ፈልግ...'
                    : 'Search clubs, mentors, venues, tags...',
                hintStyle:
                    TextStyle(fontSize: 13, color: glass.subtitleText),
                prefixIcon: Icon(Icons.search_rounded,
                    size: 20, color: glass.subtitleText),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),

        // Horizontal Category Chips
        SizedBox(
          height: 38,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: ClubCategory.values.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (ctx, idx) {
              final cat = ClubCategory.values[idx];
              final isSel = _selectedCategory == cat;
              final catColor = _categoryColor(cat);

              return InkWell(
                onTap: () => setState(() => _selectedCategory = cat),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSel
                        ? catColor
                        : catColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSel ? catColor : catColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _categoryIcon(cat),
                        size: 14,
                        color: isSel ? Colors.white : catColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _categoryLabel(cat, isAmharic),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSel ? Colors.white : catColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),

        // Status & Sort Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                '${list.length} ${isAmharic ? "ክበቦች ተገኝተዋል" : "clubs found"}',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: glass.subtitleText,
                ),
              ),
              const Spacer(),
              DropdownButton<String>(
                value: _statusFilter,
                underline: const SizedBox(),
                style: TextStyle(fontSize: 12, color: glass.titleText),
                items: [
                  DropdownMenuItem(
                      value: 'all',
                      child: Text(isAmharic ? 'ሁሉንም ሁኔታ' : 'All Status')),
                  DropdownMenuItem(
                      value: 'active',
                      child: Text(isAmharic ? 'ንቁ ብቻ' : 'Active Only')),
                  DropdownMenuItem(
                      value: 'inactive',
                      child: Text(isAmharic ? 'የታገዱ' : 'Paused Only')),
                  DropdownMenuItem(
                      value: 'nearCapacity',
                      child: Text(isAmharic ? 'ሙላት የደረሱ' : 'Near Limit')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _statusFilter = v);
                },
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: _sortBy,
                underline: const SizedBox(),
                style: TextStyle(fontSize: 12, color: glass.titleText),
                items: [
                  DropdownMenuItem(
                      value: 'members',
                      child: Text(isAmharic ? 'በአባላት ብዛት' : 'Most Members')),
                  DropdownMenuItem(
                      value: 'name',
                      child: Text(isAmharic ? 'በስም' : 'Alphabetical')),
                  DropdownMenuItem(
                      value: 'capacity',
                      child: Text(isAmharic ? 'በሙላት %' : 'Capacity %')),
                  DropdownMenuItem(
                      value: 'newest',
                      child: Text(isAmharic ? 'አዲስ የተጨመሩ' : 'Newest')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _sortBy = v);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),

        // Clubs List
        Expanded(
          child: list.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.groups_rounded,
                            size: 40, color: Color(0xFF38BDF8)),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isAmharic ? 'ምንም ክበብ አልተገኘም' : 'No Clubs Found',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: glass.titleText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isAmharic
                            ? 'የተለየ ፍለጋ ይሞክሩ ወይም አዲስ ክበብ ያክሉ።'
                            : 'Try adjusting filters or create a new student club.',
                        style: TextStyle(
                            fontSize: 12, color: glass.subtitleText),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0284C7),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(
                            isAmharic ? 'አዲስ ክበብ ጨምር' : 'Create Club'),
                        onPressed: () => _openClubEditor(),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (ctx, index) {
                    final c = list[index];
                    final catColor = _categoryColor(c.category);
                    final maxCap = c.maxCapacity ?? 50;
                    final occupancy = (c.memberCount / maxCap).clamp(0.0, 1.0);

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: glass.cardBackground,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: c.isActive
                              ? glass.cardBorder
                              : Colors.red.withValues(alpha: 0.3),
                          width: 1.2,
                        ),
                        boxShadow: glass.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: Category Pill & Active Status Switch
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: catColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(_categoryIcon(c.category),
                                        size: 13, color: catColor),
                                    const SizedBox(width: 5),
                                    Text(
                                      _categoryLabel(c.category, isAmharic),
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w800,
                                        color: catColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: c.isActive
                                      ? const Color(0xFF10B981)
                                          .withValues(alpha: 0.15)
                                      : const Color(0xFFEF4444)
                                          .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  c.isActive
                                      ? (isAmharic ? 'ንቁ' : 'ACTIVE')
                                      : (isAmharic ? 'የታገደ' : 'PAUSED'),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: c.isActive
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFFEF4444),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Switch(
                                value: c.isActive,
                                activeTrackColor: const Color(0xFF10B981)
                                    .withValues(alpha: 0.5),
                                activeThumbColor: const Color(0xFF10B981),
                                onChanged: (val) async {
                                  await widget.controller
                                      .toggleClubActive(c.id);
                                  await _loadMemberships();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Club Names
                          Text(
                            isAmharic ? c.nameAm : c.nameEn,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: glass.titleText,
                            ),
                          ),
                          if (c.nameEn != c.nameAm)
                            Text(
                              isAmharic ? c.nameEn : c.nameAm,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: glass.subtitleText,
                              ),
                            ),
                          const SizedBox(height: 6),

                          // Description
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

                          // Schedule, Location, Mentor Badges
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              _buildMetaBadge(
                                icon: Icons.schedule_rounded,
                                label: isAmharic
                                    ? c.meetingScheduleAm
                                    : c.meetingScheduleEn,
                              ),
                              _buildMetaBadge(
                                icon: Icons.location_on_outlined,
                                label: isAmharic
                                    ? c.meetingLocationAm
                                    : c.meetingLocationEn,
                              ),
                              _buildMetaBadge(
                                icon: Icons.person_outline_rounded,
                                label: isAmharic
                                    ? c.mentorNameAm
                                    : c.mentorNameEn,
                              ),
                              if (c.mentorContact.isNotEmpty)
                                _buildMetaBadge(
                                  icon: Icons.phone_in_talk_rounded,
                                  label: c.mentorContact,
                                ),
                              if (c.rulesEn.isNotEmpty)
                                _buildMetaBadge(
                                  icon: Icons.verified_user_outlined,
                                  label:
                                      '${c.rulesEn.length} ${isAmharic ? "መመሪያዎች" : "Guidelines"}',
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Capacity Progress Meter
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${c.memberCount} / $maxCap ${isAmharic ? "አባላት" : "members"}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: glass.titleText,
                                ),
                              ),
                              Text(
                                '${(occupancy * 100).toStringAsFixed(1)}% full',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: occupancy >= 1.0
                                      ? const Color(0xFFEF4444)
                                      : (occupancy >= 0.8
                                          ? const Color(0xFFF59E0B)
                                          : const Color(0xFF10B981)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: occupancy,
                              minHeight: 6,
                              backgroundColor: glass.divider,
                              valueColor: AlwaysStoppedAnimation(
                                occupancy >= 1.0
                                    ? const Color(0xFFEF4444)
                                    : (occupancy >= 0.8
                                        ? const Color(0xFFF59E0B)
                                        : const Color(0xFF10B981)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Actions Row
                          Row(
                            children: [
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  side: BorderSide(
                                      color: const Color(0xFF0284C7)
                                          .withValues(alpha: 0.4)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(Icons.people_alt_outlined,
                                    size: 16, color: Color(0xFF0284C7)),
                                label: Text(
                                  '${isAmharic ? "አባላት" : "Roster"} (${c.memberCount})',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0284C7),
                                  ),
                                ),
                                onPressed: () => _showClubRoster(c),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                tooltip: 'Edit Club',
                                onPressed: () => _openClubEditor(c),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded,
                                    size: 20, color: Color(0xFFEF4444)),
                                tooltip: 'Delete Club',
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (cctx) => AlertDialog(
                                      backgroundColor: glass.modalBackground,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      title: Text(
                                        isAmharic
                                            ? 'ክበቡን ማስወገድ ይፈልጋሉ?'
                                            : 'Delete Student Club?',
                                        style: TextStyle(
                                            color: glass.titleText,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      content: Text(
                                        isAmharic
                                            ? 'ይህ እርምጃ "${c.nameAm}"ን እና የተመዘገቡ ${c.memberCount} አባላትን መረጃ እስከመጨረሻው ያጠፋል።'
                                            : 'Are you sure you want to delete "${c.nameEn}"? This will also remove all ${c.memberCount} student enrollments and cannot be undone.',
                                        style: TextStyle(
                                            color: glass.subtitleText,
                                            fontSize: 13),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(cctx).pop(false),
                                          child: Text(
                                              isAmharic ? 'ይቅር' : 'Cancel'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFEF4444),
                                            foregroundColor: Colors.white,
                                          ),
                                          onPressed: () =>
                                              Navigator.of(cctx).pop(true),
                                          child: Text(isAmharic
                                              ? 'አስወግድ'
                                              : 'Delete Club'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await widget.controller.deleteClub(c.id);
                                    await _loadMemberships();
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMetaBadge({required IconData icon, required String label}) {
    final glass = context.glassTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: glass.divider.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: glass.subtitleText),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: glass.subtitleText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: MEMBER ROSTERS (CROSS-CLUB) ---
  Widget _buildMemberRostersTab(List<StudentClub> clubs, bool isAmharic) {
    final glass = context.glassTheme;

    // Filter by club selector
    var list = List<ClubMembership>.from(_allMemberships);
    if (_rosterClubFilter != null && _rosterClubFilter!.isNotEmpty) {
      list = list.where((m) => m.clubId == _rosterClubFilter).toList();
    }

    // Filter by member search
    final q = _memberSearchController.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((m) {
        return m.userName.toLowerCase().contains(q) ||
            m.userEmail.toLowerCase().contains(q);
      }).toList();
    }

    final clubMap = {for (final c in clubs) c.id: c};

    return Column(
      children: [
        // Club Filter & Search Field
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: glass.cardBackground,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: glass.cardBorder),
                  ),
                  child: TextField(
                    controller: _memberSearchController,
                    onChanged: (_) => setState(() {}),
                    style: TextStyle(fontSize: 13, color: glass.titleText),
                    decoration: InputDecoration(
                      hintText: isAmharic
                          ? 'ተማሪ በስም ወይም ኢሜይል ፈልግ...'
                          : 'Search student name or email...',
                      hintStyle:
                          TextStyle(fontSize: 12.5, color: glass.subtitleText),
                      prefixIcon: Icon(Icons.search_rounded,
                          size: 18, color: glass.subtitleText),
                      suffixIcon: _memberSearchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 16),
                              onPressed: () {
                                _memberSearchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: glass.cardBackground,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: glass.cardBorder),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: _rosterClubFilter,
                      isExpanded: true,
                      style: TextStyle(fontSize: 12, color: glass.titleText),
                      hint: Text(
                        isAmharic ? 'ሁሉም ክበቦች' : 'All Clubs',
                        style: TextStyle(
                            fontSize: 12, color: glass.subtitleText),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(
                            isAmharic ? 'ሁሉም ክበቦች' : 'All Clubs',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        ...clubs.map(
                          (c) => DropdownMenuItem<String?>(
                            value: c.id,
                            child: Text(
                              isAmharic ? c.nameAm : c.nameEn,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (v) =>
                          setState(() => _rosterClubFilter = v),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Roster Summary Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Text(
                '${list.length} ${isAmharic ? "የተመዘገቡ ተማሪዎች" : "enrolled student(s)"}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: glass.subtitleText,
                ),
              ),
              const Spacer(),
              if (_isLoadingMembers)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),

        // Enrolled Students List
        Expanded(
          child: list.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.badge_outlined,
                          size: 40, color: glass.subtitleText),
                      const SizedBox(height: 8),
                      Text(
                        isAmharic
                            ? 'ምንም የተመዘገበ ተማሪ አልተገኘም'
                            : 'No student memberships found.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: glass.titleText,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, index) {
                    final mem = list[index];
                    final club = clubMap[mem.clubId];
                    final isLead = mem.role == 'lead';
                    final catColor = club != null
                        ? _categoryColor(club.category)
                        : const Color(0xFF0284C7);

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: glass.cardBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: glass.cardBorder),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: isLead
                                ? const Color(0xFFF59E0B)
                                : const Color(0xFF0284C7),
                            child: Text(
                              mem.userName.isNotEmpty
                                  ? mem.userName[0].toUpperCase()
                                  : 'S',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      mem.userName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: glass.titleText,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isLead
                                            ? const Color(0xFFF59E0B)
                                                .withValues(alpha: 0.15)
                                            : const Color(0xFF10B981)
                                                .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        isLead
                                            ? (isAmharic
                                                ? 'የክበብ መሪ'
                                                : 'LEAD')
                                            : (isAmharic
                                                ? 'አባል'
                                                : 'MEMBER'),
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w800,
                                          color: isLead
                                              ? const Color(0xFFF59E0B)
                                              : const Color(0xFF10B981),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  mem.userEmail,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: glass.subtitleText,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: catColor.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        club != null
                                            ? (isAmharic
                                                ? club.nameAm
                                                : club.nameEn)
                                            : mem.clubId,
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w700,
                                          color: catColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Joined ${mem.joinedAt.month}/${mem.joinedAt.day}/${mem.joinedAt.year}',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        color: glass.subtitleText,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert_rounded,
                                color: glass.subtitleText, size: 20),
                            itemBuilder: (ctx) => [
                              PopupMenuItem(
                                value: isLead ? 'member' : 'lead',
                                child: Text(
                                  isLead
                                      ? (isAmharic
                                          ? 'ወደ መደበኛ አባል ቀይር'
                                          : 'Change to Member')
                                      : (isAmharic
                                          ? 'ወደ ክበብ መሪነት አሳድግ'
                                          : 'Promote to Lead'),
                                  style: const TextStyle(fontSize: 12.5),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'remove',
                                child: Text(
                                  isAmharic
                                      ? 'ከክበቡ አስወግድ'
                                      : 'Remove from Club',
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: Color(0xFFEF4444),
                                  ),
                                ),
                              ),
                            ],
                            onSelected: (action) async {
                              if (action == 'remove') {
                                await widget.controller.removeClubMember(
                                    mem.clubId, mem.userId);
                                await _loadMemberships();
                              } else {
                                await widget.controller.updateClubMemberRole(
                                    mem.clubId, mem.userId, action);
                                await _loadMemberships();
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // --- TAB 3: DEEP ANALYTICS & STATS ---
  Widget _buildAnalyticsTab(List<StudentClub> clubs, bool isAmharic) {
    final glass = context.glassTheme;
    final totalClubs = clubs.length;
    final totalEnrollments = _allMemberships.length;
    final uniqueStudents =
        _allMemberships.map((m) => m.userId).toSet().length;

    int totalCapacity = 0;
    for (final c in clubs) {
      totalCapacity += c.maxCapacity ?? 50;
    }
    final remainingSlots = (totalCapacity - totalEnrollments).clamp(0, 99999);

    // Category distribution counts
    final categoryCounts = <ClubCategory, int>{};
    for (final cat in ClubCategory.values) {
      if (cat != ClubCategory.all) {
        categoryCounts[cat] = 0;
      }
    }
    for (final mem in _allMemberships) {
      final target = clubs.cast<StudentClub?>().firstWhere(
            (c) => c != null && c.id == mem.clubId,
            orElse: () => null,
          );
      if (target != null) {
        categoryCounts[target.category] =
            (categoryCounts[target.category] ?? 0) + 1;
      }
    }

    // Leaderboard of clubs
    final sortedClubs = List<StudentClub>.from(clubs)
      ..sort((a, b) => b.memberCount.compareTo(a.memberCount));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        // Capacity vs Enrolled Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: glass.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: glass.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isAmharic
                    ? 'የክበቦች አቅም እና ሙላት ንፅፅር'
                    : 'SYSTEM CAPACITY & UTILIZATION',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF38BDF8),
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$totalClubs ${isAmharic ? "ክበቦች በስራ ላይ" : "registered clubs"} • $uniqueStudents ${isAmharic ? "ልዩ ተማሪዎች ተመዝግበዋል" : "unique active students"}',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: glass.subtitleText,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$totalEnrollments',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: glass.titleText,
                        ),
                      ),
                      Text(
                        isAmharic ? 'የተመዘገቡ ተማሪዎች' : 'Filled Seats',
                        style: TextStyle(
                            fontSize: 11.5, color: glass.subtitleText),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$remainingSlots',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF10B981),
                        ),
                      ),
                      Text(
                        isAmharic ? 'ክፍት ቦታዎች' : 'Remaining Slots',
                        style: TextStyle(
                            fontSize: 11.5, color: glass.subtitleText),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: totalCapacity > 0
                      ? (totalEnrollments / totalCapacity).clamp(0.0, 1.0)
                      : 0.0,
                  minHeight: 10,
                  backgroundColor: glass.divider,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF0284C7)),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${isAmharic ? "ጠቅላላ አቅም" : "Total Capacity"}: $totalCapacity',
                    style: TextStyle(
                        fontSize: 11.5, color: glass.subtitleText),
                  ),
                  Text(
                    '${totalCapacity > 0 ? ((totalEnrollments / totalCapacity) * 100).toStringAsFixed(1) : 0}% ${isAmharic ? "ሙላት" : "Saturation"}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF38BDF8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Category Breakdown Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: glass.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: glass.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isAmharic
                    ? 'የምድብ ስርጭት እና ፍላጎት'
                    : 'CATEGORY ENROLLMENT DISTRIBUTION',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF38BDF8),
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 14),
              ...ClubCategory.values
                  .where((c) => c != ClubCategory.all)
                  .map((cat) {
                final count = categoryCounts[cat] ?? 0;
                final clubsInCat =
                    clubs.where((c) => c.category == cat).length;
                final catColor = _categoryColor(cat);
                final percent = totalEnrollments > 0
                    ? (count / totalEnrollments).clamp(0.0, 1.0)
                    : 0.0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(_categoryIcon(cat),
                              size: 14, color: catColor),
                          const SizedBox(width: 6),
                          Text(
                            _categoryLabel(cat, isAmharic),
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: glass.titleText,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$count ${isAmharic ? "ተማሪዎች" : "members"} • $clubsInCat ${isAmharic ? "ክበቦች" : "clubs"}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: glass.subtitleText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percent,
                          minHeight: 6,
                          backgroundColor: glass.divider,
                          valueColor: AlwaysStoppedAnimation(catColor),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Club Popularity Leaderboard
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: glass.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: glass.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isAmharic
                    ? 'ከፍተኛ ተሳትፎ ያላቸው ክበቦች'
                    : 'CLUB ENGAGEMENT LEADERBOARD',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF38BDF8),
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 14),
              ...List.generate(sortedClubs.length, (idx) {
                final c = sortedClubs[idx];
                final maxCap = c.maxCapacity ?? 50;
                final rankColor = idx == 0
                    ? const Color(0xFFF59E0B)
                    : (idx == 1
                        ? const Color(0xFF94A3B8)
                        : (idx == 2
                            ? const Color(0xFFD97706)
                            : const Color(0xFF0284C7)));

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: rankColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '#${idx + 1}',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                              color: rankColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAmharic ? c.nameAm : c.nameEn,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: glass.titleText,
                              ),
                            ),
                            Text(
                              '${_categoryLabel(c.category, isAmharic)} • Mentor: ${isAmharic ? c.mentorNameAm : c.mentorNameEn}',
                              style: TextStyle(
                                fontSize: 11,
                                color: glass.subtitleText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${c.memberCount} members',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: glass.titleText,
                            ),
                          ),
                          Text(
                            '${((c.memberCount / maxCap) * 100).toStringAsFixed(0)}% full',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: glass.subtitleText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAmharic
                  ? 'የተማሪዎች ክበቦች ቁጥጥር ማዕከል'
                  : 'Student Clubs Control Center',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: glass.titleText,
              ),
            ),
            Text(
              isAmharic
                  ? 'አስተዳደር፣ የአባላት ዝርዝር እና ስታቲስቲክስ'
                  : 'Governance, Rosters & Live Analytics',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF38BDF8),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded,
                color: Color(0xFF38BDF8)),
            tooltip: 'Add Club',
            onPressed: () => _openClubEditor(),
          ),
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: glass.titleText),
            tooltip: 'Refresh',
            onPressed: () {
              widget.controller.loadDashboard();
              _loadMemberships();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: glass.isDark
                  ? const Color(0xFF0F172A)
                  : const Color(0xFFE2E8F0).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color(0xFF0284C7),
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: glass.subtitleText,
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              tabs: [
                Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.groups_rounded, size: 16),
                      const SizedBox(width: 6),
                      Text(isAmharic ? 'ክበቦች' : 'Clubs'),
                    ],
                  ),
                ),
                Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.badge_rounded, size: 16),
                      const SizedBox(width: 6),
                      Text(
                          '${isAmharic ? "አባላት" : "Rosters"} (${_allMemberships.length})'),
                    ],
                  ),
                ),
                Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.analytics_rounded, size: 16),
                      const SizedBox(width: 6),
                      Text(isAmharic ? 'ስታቲስቲክስ' : 'Analytics'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final clubs = widget.controller.clubs;

          return Column(
            children: [
              _buildExecutiveStats(clubs, isAmharic),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildClubsDirectoryTab(clubs, isAmharic),
                    _buildMemberRostersTab(clubs, isAmharic),
                    _buildAnalyticsTab(clubs, isAmharic),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
