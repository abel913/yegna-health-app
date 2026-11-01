import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'facility_card.dart';
import 'facility_map_view.dart';
import 'facility_model.dart';
import 'facility_repository.dart';

enum _ViewMode { list, map }

class FacilitiesPage extends StatefulWidget {
  const FacilitiesPage({
    this.facilityRepository,
    super.key,
  });

  final FacilityRepository? facilityRepository;

  @override
  State<FacilitiesPage> createState() => _FacilitiesPageState();
}

class _FacilitiesPageState extends State<FacilitiesPage> {
  late final FacilityRepository _repository;
  final TextEditingController _searchController = TextEditingController();

  _ViewMode _viewMode = _ViewMode.list;
  FacilityFilterCategory _selectedCategory = FacilityFilterCategory.all;
  List<Facility> _facilities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository =
        widget.facilityRepository ?? const LocalVerifiedFacilityRepository();
    _searchController.addListener(_onSearchChanged);
    _loadFacilities();
  }

  @override
  void didUpdateWidget(FacilitiesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.facilityRepository != oldWidget.facilityRepository) {
      _repository =
          widget.facilityRepository ?? const LocalVerifiedFacilityRepository();
      _loadFacilities();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _loadFacilities();
  }

  Future<void> _loadFacilities() async {
    final query = _searchController.text;
    final results = await _repository.getFacilities(
      query: query,
      category: _selectedCategory,
    );
    if (mounted) {
      setState(() {
        _facilities = results;
        _isLoading = false;
      });
    }
  }

  void _onCategorySelected(FacilityFilterCategory category) {
    setState(() {
      _selectedCategory = category;
    });
    _loadFacilities();
  }

  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _selectedCategory = FacilityFilterCategory.all;
    });
    _loadFacilities();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // If unconfigured or empty initial repository, maintain honest fallback state
    if (!_isLoading &&
        _facilities.isEmpty &&
        _searchController.text.isEmpty &&
        _selectedCategory == FacilityFilterCategory.all &&
        _repository is UnconfiguredFacilityRepository) {
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
                // Top Header Controls
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Introduction Banner
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF0FF),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundColor: Color(0xFFDBF3F8),
                              child: Icon(Icons.local_hospital_outlined,
                                  color: Color(0xFF005A71), size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.facilitiesIntroduction,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Interactive Frosted Search Bar
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
                                  hintText: l10n.searchFacilities,
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

                      // Filter Carousel & View Toggle
                      Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildFilterChip(
                                    label: l10n.allFacilities,
                                    category: FacilityFilterCategory.all,
                                  ),
                                  const SizedBox(width: 6),
                                  _buildFilterChip(
                                    label: l10n.nearbyFilter,
                                    category: FacilityFilterCategory.nearby,
                                  ),
                                  const SizedBox(width: 6),
                                  _buildFilterChip(
                                    label: l10n.campusFilter,
                                    category: FacilityFilterCategory.campus,
                                  ),
                                  const SizedBox(width: 6),
                                  _buildFilterChip(
                                    label: l10n.srhVctFilter,
                                    category: FacilityFilterCategory.srhVct,
                                  ),
                                  const SizedBox(width: 6),
                                  _buildFilterChip(
                                    label: l10n.mentalHealthFilter,
                                    category:
                                        FacilityFilterCategory.mentalHealth,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Segmented List/Map Toggle
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2FE),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFBAE6FD),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildModeButton(
                                  icon: Icons.view_agenda_outlined,
                                  mode: _ViewMode.list,
                                  tooltip: l10n.listViewLabel,
                                ),
                                _buildModeButton(
                                  icon: Icons.map_outlined,
                                  mode: _ViewMode.map,
                                  tooltip: l10n.mapViewLabel,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Main Content View (List View or Map View)
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Color(0xFF0284C7),
                          ),
                        )
                      : _facilities.isEmpty
                          ? _buildNoResultsEmptyState(l10n)
                          : _viewMode == _ViewMode.list
                              ? ListView.builder(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 6, 20, 24),
                                  itemCount: _facilities.length,
                                  itemBuilder: (context, index) => FacilityCard(
                                    facility: _facilities[index],
                                  ),
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 6, 20, 20),
                                  child: FacilityMapView(
                                    facilities: _facilities,
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
    required FacilityFilterCategory category,
  }) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => _onCategorySelected(category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0284C7) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF0284C7) : const Color(0xFFE2E8F0),
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
  }

  Widget _buildModeButton({
    required IconData icon,
    required _ViewMode mode,
    required String tooltip,
  }) {
    final isSelected = _viewMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _viewMode = mode;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0284C7) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected ? Colors.white : const Color(0xFF0284C7),
        ),
      ),
    );
  }

  Widget _buildNoResultsEmptyState(AppLocalizations l10n) => Center(
        child: Padding(
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
                  Icons.search_off_rounded,
                  size: 36,
                  color: Color(0xFF0284C7),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.noVerifiedFacilitiesTitle,
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
                l10n.facilitiesNotAvailableBody,
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
                  child: Icon(Icons.local_hospital_outlined,
                      color: Color(0xFF005A71)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(l10n.facilitiesIntroduction,
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
                    child: Icon(Icons.local_hospital_outlined,
                        size: 25, color: Color(0xFF005A71)),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.noVerifiedFacilitiesTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.facilitiesNotAvailableBody,
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
              leading: const Icon(Icons.map_outlined, color: Color(0xFF005A71)),
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              title: Text(l10n.mapPreviewTitle),
              subtitle: Text(l10n.mapNotAvailableBody),
            ),
          ),
        ],
      );
}
