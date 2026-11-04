import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'mentor_card.dart';
import 'mentor_model.dart';
import 'mentor_repository.dart';

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

  MentorTopic _selectedTopic = MentorTopic.all;
  bool _onlineOnly = false;
  String _selectedLanguage = 'All';
  List<Mentor> _mentors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository =
        widget.mentorRepository ?? const LocalVerifiedMentorRepository();
    _searchController.addListener(_onSearchChanged);
    _loadMentors();
  }

  @override
  void didUpdateWidget(MentorsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mentorRepository != oldWidget.mentorRepository) {
      _repository =
          widget.mentorRepository ?? const LocalVerifiedMentorRepository();
      _loadMentors();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _loadMentors();
  }

  Future<void> _loadMentors() async {
    final query = _searchController.text;
    final results = await _repository.getMentors(
      query: query,
      topic: _selectedTopic,
      language: _selectedLanguage == 'All' ? null : _selectedLanguage,
      onlineOnly: _onlineOnly ? true : null,
    );
    if (mounted) {
      setState(() {
        _mentors = results;
        _isLoading = false;
      });
    }
  }

  void _onTopicSelected(MentorTopic topic) {
    setState(() {
      _selectedTopic = topic;
    });
    _loadMentors();
  }

  void _toggleOnlineFilter() {
    setState(() {
      _onlineOnly = !_onlineOnly;
    });
    _loadMentors();
  }

  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _selectedTopic = MentorTopic.all;
      _onlineOnly = false;
      _selectedLanguage = 'All';
    });
    _loadMentors();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // If unconfigured or empty initial repository, maintain honest fallback state
    if (!_isLoading &&
        _mentors.isEmpty &&
        _searchController.text.isEmpty &&
        _selectedTopic == MentorTopic.all &&
        !_onlineOnly &&
        _repository is UnconfiguredMentorRepository) {
      return _buildEmptyPresentationState(l10n);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth > 720 ? 680.0 : 560.0;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header & Search Area
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Interactive Search Input
                      Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFBAE6FD),
                            width: 1.2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0A0284C7),
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 14),
                            const Icon(Icons.search_rounded,
                                color: Color(0xFF0284C7), size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: l10n.searchMentors,
                                  hintStyle: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 14,
                                    color: Colors.grey.shade400,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 14,
                                  color: Color(0xFF08264A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (_searchController.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.close_rounded,
                                    size: 18, color: Colors.grey),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Filter Carousel
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Row(
                          children: [
                            _buildFilterChip(
                              label: l10n.allMentors,
                              isSelected: _selectedTopic == MentorTopic.all &&
                                  !_onlineOnly,
                              onTap: () {
                                setState(() {
                                  _selectedTopic = MentorTopic.all;
                                  _onlineOnly = false;
                                });
                                _loadMentors();
                              },
                            ),
                            const SizedBox(width: 6),
                            _buildFilterChip(
                              label: '🟢 ${l10n.onlineNowFilter}',
                              isSelected: _onlineOnly,
                              onTap: _toggleOnlineFilter,
                            ),
                            const SizedBox(width: 6),
                            _buildFilterChip(
                              label: l10n.mentalHealthFilter,
                              isSelected:
                                  _selectedTopic == MentorTopic.mentalHealth,
                              onTap: () =>
                                  _onTopicSelected(MentorTopic.mentalHealth),
                            ),
                            const SizedBox(width: 6),
                            _buildFilterChip(
                              label: l10n.srhVctFilter,
                              isSelected:
                                  _selectedTopic == MentorTopic.srhGuidance,
                              onTap: () =>
                                  _onTopicSelected(MentorTopic.srhGuidance),
                            ),
                            const SizedBox(width: 6),
                            _buildFilterChip(
                              label: l10n.pubertyFilter,
                              isSelected: _selectedTopic == MentorTopic.puberty,
                              onTap: () =>
                                  _onTopicSelected(MentorTopic.puberty),
                            ),
                            const SizedBox(width: 6),
                            _buildFilterChip(
                              label: l10n.substanceFilter,
                              isSelected:
                                  _selectedTopic == MentorTopic.substanceAbuse,
                              onTap: () =>
                                  _onTopicSelected(MentorTopic.substanceAbuse),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Mentors List
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Color(0xFF0284C7),
                          ),
                        )
                      : _mentors.isEmpty
                          ? _buildNoResultsEmptyState(l10n)
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                              itemCount: _mentors.length,
                              itemBuilder: (context, index) => MentorCard(
                                mentor: _mentors[index],
                              ),
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0284C7) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF0284C7)
                  : const Color(0xFFE2E8F0),
              width: 1.1,
            ),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color(0x330284C7),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                const Icon(Icons.check, size: 14, color: Colors.white),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildNoResultsEmptyState(AppLocalizations l10n) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F2FE),
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
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF08264A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.noVerifiedMentorsBody,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 13,
                  color: Color(0xFF64748B),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildEmptyPresentationState(AppLocalizations l10n) => ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF0FF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFFDBF3F8),
                  child:
                      Icon(Icons.people_alt_outlined, color: Color(0xFF005A71)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(l10n.mentorsIntroduction,
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFFE4E9FF),
                    child: Icon(Icons.people_alt_outlined,
                        size: 25, color: Color(0xFF005A71)),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.noVerifiedMentorsTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.noVerifiedMentorsBody,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: ListTile(
              leading:
                  const Icon(Icons.shield_outlined, color: Color(0xFF005A71)),
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              title: Text(l10n.mentorSafetyTitle),
              subtitle: Text(l10n.mentorSafetyBody),
            ),
          ),
        ],
      );
}
