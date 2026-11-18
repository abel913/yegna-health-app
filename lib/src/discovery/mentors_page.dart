import 'dart:ui';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_glass_theme.dart';
import 'mentor_card.dart';
import 'mentor_model.dart';
import 'mentor_repository.dart';
import 'sync_mentor_repository.dart';
import 'uog_campus_model.dart';

class MentorsPage extends StatefulWidget {
  const MentorsPage({
    this.mentorRepository,
    super.key,
  });

  final MentorRepository? mentorRepository;

  @override
  State<MentorsPage> createState() => _MentorsPageState();
}

class _MentorsPageState extends State<MentorsPage> {
  late final MentorRepository _repository;
  final TextEditingController _searchController = TextEditingController();

  List<Mentor> _mentors = [];
  bool _isLoading = true;
  String _selectedCampus = 'all';

  @override
  void initState() {
    super.initState();
    _repository =
        widget.mentorRepository ?? const LocalVerifiedMentorRepository();
    _searchController.addListener(_onSearchChanged);
    _setupRepositoryListener();
    _loadMentors();
  }

  void _setupRepositoryListener() {
    final repo = _repository;
    if (repo is Listenable) {
      (repo as Listenable).addListener(_onRepositoryUpdated);
    }
  }

  void _removeRepositoryListener() {
    final repo = _repository;
    if (repo is Listenable) {
      (repo as Listenable).removeListener(_onRepositoryUpdated);
    }
  }

  void _onRepositoryUpdated() {
    if (mounted) {
      _loadMentors();
    }
  }

  @override
  void didUpdateWidget(MentorsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mentorRepository != oldWidget.mentorRepository) {
      _removeRepositoryListener();
      _repository =
          widget.mentorRepository ?? const LocalVerifiedMentorRepository();
      _setupRepositoryListener();
      _loadMentors();
    }
  }

  @override
  void dispose() {
    _removeRepositoryListener();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _loadMentors();
  }

  Future<void> _loadMentors({bool forceRefresh = false}) async {
    final query = _searchController.text;
    final campus = _selectedCampus == 'all' ? null : _selectedCampus;
    List<Mentor> results;
    final repo = _repository;
    if (forceRefresh && repo is SyncMentorRepository) {
      results = await repo.refreshMentors(
        query: query,
        campus: campus,
      );
    } else {
      results = await _repository.getMentors(
        query: query,
        campus: campus,
      );
    }
    if (mounted) {
      setState(() {
        _mentors = results;
        _isLoading = false;
      });
    }
  }

  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _selectedCampus = 'all';
    });
    _loadMentors();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final glass = context.glassTheme;
    final isDark = glass.isDark;
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    // If unconfigured or empty initial repository, maintain honest fallback state
    if (!_isLoading &&
        _mentors.isEmpty &&
        _searchController.text.isEmpty &&
        _selectedCampus == 'all' &&
        _repository is UnconfiguredMentorRepository) {
      return _buildEmptyPresentationState(l10n, glass);
    }

    return Stack(
      children: [
        // Luminous Ambient Mesh (Vibrant Orbs for Optical Glass Refraction)
        Positioned(
          top: -40,
          left: -30,
          child: Container(
            width: 360,
            height: 360,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDark
                    ? const [
                        Color(0x350284C7),
                        Color(0x1838BDF8),
                        Colors.transparent,
                      ]
                    : const [
                        Color(0x950284C7),
                        Color(0x5038BDF8),
                        Colors.transparent,
                      ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 140,
          right: -60,
          child: Container(
            width: 380,
            height: 380,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDark
                    ? const [
                        Color(0x3006B6D4),
                        Color(0x150EA5E9),
                        Colors.transparent,
                      ]
                    : const [
                        Color(0x8806B6D4),
                        Color(0x450EA5E9),
                        Colors.transparent,
                      ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 420,
          left: -50,
          child: Container(
            width: 340,
            height: 340,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDark
                    ? const [
                        Color(0x286366F1),
                        Color(0x1238BDF8),
                        Colors.transparent,
                      ]
                    : const [
                        Color(0x806366F1),
                        Color(0x3538BDF8),
                        Colors.transparent,
                      ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          right: -40,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDark
                    ? const [
                        Color(0x250D9488),
                        Color(0x1014B8A6),
                        Colors.transparent,
                      ]
                    : const [
                        Color(0x750D9488),
                        Color(0x3014B8A6),
                        Colors.transparent,
                      ],
              ),
            ),
          ),
        ),

        // Interactive Content
        LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = constraints.maxWidth > 720 ? 680.0 : 560.0;
            final activeCampus = kUogCampuses.firstWhere(
              (c) => c.id == _selectedCampus,
              orElse: () => kUogCampuses.first,
            );
            final isCampusFiltered = _selectedCampus != 'all';

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header & Search Area
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF131D36).withValues(alpha: 0.76)
                                  : Colors.white.withValues(alpha: 0.55),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isDark
                                    ? [
                                        const Color(0xFF1E293B).withValues(alpha: 0.82),
                                        const Color(0xFF0F172A).withValues(alpha: 0.65),
                                        const Color(0xFF0284C7).withValues(alpha: 0.12),
                                      ]
                                    : [
                                        Colors.white.withValues(alpha: 0.78),
                                        Colors.white.withValues(alpha: 0.35),
                                        const Color(0xFFBAE6FD).withValues(alpha: 0.18),
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF38BDF8).withValues(alpha: 0.24)
                                    : Colors.white.withValues(alpha: 0.90),
                                width: 1.4,
                              ),
                              boxShadow: isDark
                                  ? const [
                                      BoxShadow(
                                        color: Color(0x50000000),
                                        blurRadius: 18,
                                        offset: Offset(0, 6),
                                      ),
                                    ]
                                  : const [
                                      BoxShadow(
                                        color: Color(0x120284C7),
                                        blurRadius: 18,
                                        offset: Offset(0, 6),
                                      ),
                                      BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 4,
                                        offset: Offset(-1, -1),
                                      ),
                                    ],
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 14),
                                Icon(Icons.search_rounded,
                                    color: glass.accentColor, size: 22),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText: l10n.searchMentors,
                                      hintStyle: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 14,
                                        color: glass.subtitleText,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 14,
                                      color: glass.titleText,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (_searchController.text.isNotEmpty)
                                  IconButton(
                                    icon: Icon(Icons.close_rounded,
                                        size: 18, color: glass.subtitleText),
                                    onPressed: () {
                                      _searchController.clear();
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Glassmorphic UoG Campus Dropdown Filter Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                      child: Row(
                        children: [
                          _buildCampusDropdownTrigger(
                            context: context,
                            l10n: l10n,
                            glass: glass,
                            isDark: isDark,
                            isAmharic: isAmharic,
                            activeCampus: activeCampus,
                            isCampusFiltered: isCampusFiltered,
                          ),
                          if (isCampusFiltered) ...[
                            const SizedBox(width: 8),
                            _buildClearFilterButton(l10n, glass, isDark),
                          ],
                          const Spacer(),
                          _buildMentorsCountBadge(glass, isDark, isAmharic),
                        ],
                      ),
                    ),

                    // Main Mentors List
                    Expanded(
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: glass.accentColor,
                              ),
                            )
                          : _mentors.isEmpty
                              ? _buildNoResultsEmptyState(l10n, glass)
                              : RefreshIndicator(
                                  onRefresh: () => _loadMentors(forceRefresh: true),
                                  color: glass.accentColor,
                                  child: ListView.builder(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 6, 20, 24),
                                    itemCount: _mentors.length,
                                    itemBuilder: (context, index) => MentorCard(
                                      mentor: _mentors[index],
                                    ),
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCampusDropdownTrigger({
    required BuildContext context,
    required AppLocalizations l10n,
    required AppGlassTheme glass,
    required bool isDark,
    required bool isAmharic,
    required UogCampus activeCampus,
    required bool isCampusFiltered,
  }) {
    final label = isCampusFiltered
        ? activeCampus.localizedName(isAmharic)
        : l10n.allCampuses;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const Key('uog_campus_dropdown_trigger'),
        onTap: () =>
            _openCampusDropdown(context, l10n, glass, isDark, isAmharic),
        borderRadius: BorderRadius.circular(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? (isCampusFiltered
                        ? const Color(0xFF0369A1).withValues(alpha: 0.28)
                        : const Color(0xFF1E293B).withValues(alpha: 0.75))
                    : (isCampusFiltered
                        ? const Color(0xFFE0F2FE).withValues(alpha: 0.85)
                        : Colors.white.withValues(alpha: 0.70)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF1E293B).withValues(alpha: 0.85),
                          const Color(0xFF0F172A).withValues(alpha: 0.65),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.85),
                          Colors.white.withValues(alpha: 0.45),
                        ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCampusFiltered
                      ? (isDark
                          ? const Color(0xFF38BDF8)
                          : const Color(0xFF0284C7))
                      : (isDark
                          ? const Color(0xFF38BDF8).withValues(alpha: 0.22)
                          : Colors.white.withValues(alpha: 0.90)),
                  width: isCampusFiltered ? 1.5 : 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? const Color(0x40000000)
                        : const Color(0x100284C7),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isCampusFiltered
                        ? activeCampus.icon
                        : Icons.account_balance_rounded,
                    size: 16,
                    color: isCampusFiltered
                        ? glass.accentColor
                        : glass.subtitleText,
                  ),
                  const SizedBox(width: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 165),
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: isCampusFiltered
                            ? (isDark
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFF0284C7))
                            : glass.titleText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: isCampusFiltered
                        ? glass.accentColor
                        : glass.subtitleText,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClearFilterButton(
    AppLocalizations l10n,
    AppGlassTheme glass,
    bool isDark,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const Key('uog_campus_clear_filter'),
        onTap: () {
          setState(() {
            _selectedCampus = 'all';
          });
          _loadMentors();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF334155).withValues(alpha: 0.60)
                : const Color(0xFFF1F5F9).withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0),
              width: 0.9,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.close_rounded, size: 14, color: glass.subtitleText),
              const SizedBox(width: 4),
              Text(
                l10n.clearCampusFilter,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: glass.subtitleText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMentorsCountBadge(
    AppGlassTheme glass,
    bool isDark,
    bool isAmharic,
  ) {
    final count = _mentors.length;
    final countText = isAmharic
        ? '$count አማካሪዎች'
        : (count == 1 ? '1 mentor' : '$count mentors');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0F172A).withValues(alpha: 0.65)
            : Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? const Color(0xFF38BDF8).withValues(alpha: 0.18)
              : const Color(0xFFE2E8F0).withValues(alpha: 0.85),
          width: 1,
        ),
      ),
      child: Text(
        countText,
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: glass.subtitleText,
        ),
      ),
    );
  }

  void _openCampusDropdown(
    BuildContext context,
    AppLocalizations l10n,
    AppGlassTheme glass,
    bool isDark,
    bool isAmharic,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss Campus Filter',
      barrierColor: isDark
          ? Colors.black.withValues(alpha: 0.50)
          : Colors.black.withValues(alpha: 0.25),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        final topPadding = MediaQuery.of(context).padding.top + 70.0;

        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, topPadding, 16, 24),
            child: Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                  child: Container(
                    width: 380,
                    constraints: const BoxConstraints(maxWidth: 420),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F172A).withValues(alpha: 0.92)
                          : Colors.white.withValues(alpha: 0.94),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                const Color(0xFF1E293B).withValues(alpha: 0.95),
                                const Color(0xFF0F172A).withValues(alpha: 0.90),
                                const Color(0xFF0284C7).withValues(alpha: 0.12),
                              ]
                            : [
                                Colors.white.withValues(alpha: 0.98),
                                Colors.white.withValues(alpha: 0.88),
                                const Color(0xFFBAE6FD).withValues(alpha: 0.22),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF38BDF8).withValues(alpha: 0.30)
                            : Colors.white.withValues(alpha: 0.95),
                        width: 1.5,
                      ),
                      boxShadow: isDark
                          ? const [
                              BoxShadow(
                                color: Color(0x90000000),
                                blurRadius: 32,
                                offset: Offset(0, 12),
                              ),
                            ]
                          : const [
                              BoxShadow(
                                color: Color(0x200284C7),
                                blurRadius: 32,
                                offset: Offset(0, 12),
                              ),
                              BoxShadow(
                                color: Colors.white,
                                blurRadius: 6,
                                offset: Offset(-1, -1),
                              ),
                            ],
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // --- COMPACT HEADER ---
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0284C7)
                                        .withValues(alpha: 0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.school_rounded,
                                  color: Colors.white,
                                  size: 19,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.uogCampusesTitle,
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: glass.titleText,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    l10n.uogCampusesSubtitle,
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 11,
                                      color: glass.subtitleText,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(dialogContext).pop(),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFF1F5F9),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 16,
                                    color: glass.subtitleText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Divider(
                          height: 1,
                          thickness: 1,
                          color: isDark
                              ? const Color(0xFF334155).withValues(alpha: 0.50)
                              : const Color(0xFFE2E8F0).withValues(alpha: 0.80),
                        ),
                        const SizedBox(height: 8),

                        // --- CLEAN SINGLE-LINE CAMPUS ITEMS (NO SUBTITLES) ---
                        ...kUogCampuses.map((campus) {
                          final isSelected = _selectedCampus == campus.id;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                key: Key('campus_option_${campus.id}'),
                                onTap: () {
                                  Navigator.of(dialogContext).pop();
                                  setState(() {
                                    _selectedCampus = campus.id;
                                  });
                                  _loadMentors();
                                },
                                borderRadius: BorderRadius.circular(14),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 160),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 9.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? (isDark
                                            ? const Color(0xFF1E293B)
                                            : const Color(0xFFE2E8F0)
                                                .withValues(alpha: 0.75))
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(14),
                                    border: isSelected
                                        ? Border.all(
                                            color: isDark
                                                ? const Color(0xFF38BDF8)
                                                    .withValues(alpha: 0.40)
                                                : const Color(0xFF0284C7)
                                                    .withValues(alpha: 0.30),
                                            width: 1.2,
                                          )
                                        : null,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? (isDark
                                                  ? const Color(0xFF38BDF8)
                                                      .withValues(alpha: 0.18)
                                                  : const Color(0xFF0284C7)
                                                      .withValues(alpha: 0.12))
                                              : (isDark
                                                  ? const Color(0xFF1E293B)
                                                      .withValues(alpha: 0.60)
                                                  : const Color(0xFFF1F5F9)),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            campus.icon,
                                            size: 17,
                                            color: isSelected
                                                ? glass.accentColor
                                                : (isDark
                                                    ? const Color(0xFF94A3B8)
                                                    : const Color(0xFF475569)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          campus.localizedName(isAmharic),
                                          style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: 14,
                                            fontWeight: isSelected
                                                ? FontWeight.w800
                                                : FontWeight.w600,
                                            color: isSelected
                                                ? (isDark
                                                    ? const Color(0xFF38BDF8)
                                                    : const Color(0xFF0284C7))
                                                : glass.titleText,
                                            letterSpacing: -0.2,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (isSelected)
                                        Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? const Color(0xFF38BDF8)
                                                : const Color(0xFF0284C7),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.check_rounded,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.06),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildNoResultsEmptyState(
      AppLocalizations l10n, AppGlassTheme glass) {
    final isDark = glass.isDark;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF131D36).withValues(alpha: 0.76)
                    : Colors.white.withValues(alpha: 0.55),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF1E293B).withValues(alpha: 0.85),
                          const Color(0xFF0F172A).withValues(alpha: 0.70),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.75),
                          Colors.white.withValues(alpha: 0.35),
                        ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.22)
                      : Colors.white.withValues(alpha: 0.90),
                  width: 1.4,
                ),
                boxShadow: isDark
                    ? const [
                        BoxShadow(
                          color: Color(0x60000000),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ]
                    : const [
                        BoxShadow(
                          color: Color(0x140284C7),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_off_rounded,
                      size: 36,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noVerifiedMentorsTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: glass.titleText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.noVerifiedMentorsBody,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13,
                      color: glass.subtitleText,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _resetFilters,
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: Text(l10n.resetFiltersAction),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyPresentationState(
      AppLocalizations l10n, AppGlassTheme glass) {
    final isDark = glass.isDark;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF131D36).withValues(alpha: 0.70)
                    : Colors.white.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.20)
                      : Colors.white.withValues(alpha: 0.85),
                  width: 1.2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor:
                        const Color(0xFF0284C7).withValues(alpha: 0.15),
                    child: const Icon(Icons.people_alt_outlined,
                        color: Color(0xFF0284C7)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.mentorsIntroduction,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 13.5,
                        color: glass.titleText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF131D36).withValues(alpha: 0.75)
                    : Colors.white.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.22)
                      : Colors.white.withValues(alpha: 0.88),
                  width: 1.4,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor:
                        const Color(0xFF0284C7).withValues(alpha: 0.15),
                    child: const Icon(Icons.people_alt_outlined,
                        size: 25, color: Color(0xFF0284C7)),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.noVerifiedMentorsTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: glass.titleText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.noVerifiedMentorsBody,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13,
                      color: glass.subtitleText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF131D36).withValues(alpha: 0.65)
                    : Colors.white.withValues(alpha: 0.50),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.18)
                      : Colors.white.withValues(alpha: 0.80),
                  width: 1.2,
                ),
              ),
              child: ListTile(
                leading: const Icon(Icons.shield_outlined,
                    color: Color(0xFF0284C7)),
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                title: Text(
                  l10n.mentorSafetyTitle,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: glass.titleText,
                  ),
                ),
                subtitle: Text(
                  l10n.mentorSafetyBody,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12,
                    color: glass.subtitleText,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
