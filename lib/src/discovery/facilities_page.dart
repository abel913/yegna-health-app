import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;

import '../../l10n/app_localizations.dart';
import '../theme/app_glass_theme.dart';
import 'facility_card.dart';
import 'facility_map_view.dart';
import 'facility_model.dart';
import 'facility_repository.dart';
import 'location_service.dart';
import 'sync_facility_repository.dart';

enum _ViewMode { list, map }

class FacilitiesPage extends StatefulWidget {
  const FacilitiesPage({
    this.facilityRepository,
    this.locationService,
    this.initialLocation,
    this.tileProvider,
    this.mapController,
    super.key,
  });

  final FacilityRepository? facilityRepository;
  final LocationService? locationService;
  final LatLng? initialLocation;
  final TileProvider? tileProvider;
  final MapController? mapController;

  @override
  State<FacilitiesPage> createState() => _FacilitiesPageState();
}

class _FacilitiesPageState extends State<FacilitiesPage> {
  late final FacilityRepository _repository;
  late final LocationService _locationService;
  final TextEditingController _searchController = TextEditingController();

  _ViewMode _viewMode = _ViewMode.list;
  FacilityFilterCategory _selectedCategory = FacilityFilterCategory.all;
  List<Facility> _facilities = [];
  bool _isLoading = true;
  LatLng? _userLocation;
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    _repository =
        widget.facilityRepository ?? const LocalVerifiedFacilityRepository();
    _locationService =
        widget.locationService ?? const GeolocatorLocationService();
    _userLocation = widget.initialLocation;
    _searchController.addListener(_onSearchChanged);
    _setupRepositoryListener();
    _loadFacilities();
  }

  void _setupRepositoryListener() {
    final repo = _repository;
    if (repo is Listenable) {
      (repo as Listenable).addListener(_onRepositoryUpdated);
    } else if (repo is DynamicFacilityRepository) {
      final fallback = repo.fallback;
      if (fallback is Listenable) {
        (fallback as Listenable).addListener(_onRepositoryUpdated);
      }
    }
  }

  void _removeRepositoryListener() {
    final repo = _repository;
    if (repo is Listenable) {
      (repo as Listenable).removeListener(_onRepositoryUpdated);
    } else if (repo is DynamicFacilityRepository) {
      final fallback = repo.fallback;
      if (fallback is Listenable) {
        (fallback as Listenable).removeListener(_onRepositoryUpdated);
      }
    }
  }

  void _onRepositoryUpdated() {
    if (mounted) {
      _loadFacilities();
    }
  }

  @override
  void didUpdateWidget(FacilitiesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.facilityRepository != oldWidget.facilityRepository ||
        widget.locationService != oldWidget.locationService ||
        widget.initialLocation != oldWidget.initialLocation) {
      _removeRepositoryListener();
      _repository =
          widget.facilityRepository ?? const LocalVerifiedFacilityRepository();
      _locationService =
          widget.locationService ?? const GeolocatorLocationService();
      if (widget.initialLocation != null) {
        _userLocation = widget.initialLocation;
      }
      _setupRepositoryListener();
      _loadFacilities();
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
    _loadFacilities();
  }

  Future<void> _handleRefresh() async {
    final repo = _repository;
    if (repo is SyncFacilityRepository) {
      await repo.refreshFacilities(
        query: _searchController.text,
        category: _selectedCategory,
      );
    } else if (repo is DynamicFacilityRepository) {
      await repo.refreshFacilities(
        query: _searchController.text,
        category: _selectedCategory,
      );
    }
    await _loadFacilities();
  }

  Future<void> _loadFacilities() async {
    final query = _searchController.text;
    var results = await _repository.getFacilities(
      query: query,
      category: _selectedCategory,
    );

    if (_userLocation != null) {
      results = results.map((f) {
        final dist = _locationService.calculateDistanceKm(
          _userLocation!,
          LatLng(f.latitude, f.longitude),
        );
        final rounded = double.parse(dist.toStringAsFixed(1));
        return f.copyWith(distanceKm: rounded);
      }).toList();

      if (_selectedCategory == FacilityFilterCategory.nearby) {
        results.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      }
    }

    if (mounted) {
      setState(() {
        _facilities = results;
        _isLoading = false;
      });
    }
  }

  Future<void> _onCategorySelected(FacilityFilterCategory category) async {
    setState(() {
      _selectedCategory = category;
    });

    if (category == FacilityFilterCategory.nearby && _userLocation == null) {
      await _fetchUserLocation(showFeedback: true);
    } else {
      _loadFacilities();
    }
  }

  Future<LatLng?> _fetchUserLocation({bool showFeedback = false}) async {
    if (_isLocating) return _userLocation;
    setState(() {
      _isLocating = true;
    });

    try {
      final loc = await _locationService.getCurrentLocation();
      if (!mounted) return loc;

      setState(() {
        _userLocation = loc;
        _isLocating = false;
      });

      if (loc != null) {
        await _loadFacilities();
        if (showFeedback && mounted) {
          final isAmharic =
              Localizations.localeOf(context).languageCode == 'am';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isAmharic
                  ? 'የእርስዎ ወቅታዊ መገኛ ተገኝቷል'
                  : 'Live GPS location acquired. Facilities sorted by proximity.'),
              backgroundColor: const Color(0xFF0284C7),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      } else {
        if (showFeedback && mounted) {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.locationPermissionDenied),
              backgroundColor: const Color(0xFFE11D48),
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
        await _loadFacilities();
      }
      return loc;
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLocating = false;
        });
      }
      return null;
    }
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
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    // If unconfigured or empty initial repository, maintain honest fallback state
    if (!_isLoading &&
        _facilities.isEmpty &&
        _searchController.text.isEmpty &&
        _selectedCategory == FacilityFilterCategory.all &&
        _repository is UnconfiguredFacilityRepository) {
      return _buildEmptyPresentationState(l10n, isDark);
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: glass.scaffoldGradientColors,
        ),
      ),
      child: Stack(
        children: [
          // Luminous Ambient Mesh (Exact Refraction Orbs matching Home & Mentors)
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

          // Decorative Floating Glass Spheres with specular sheen
          Positioned(
            top: 70,
            left: 20,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.25)
                      : Colors.white.withValues(alpha: 0.50),
                  width: 2,
                ),
                gradient: RadialGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF38BDF8).withValues(alpha: 0.12),
                          Colors.transparent,
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.35),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 480,
            right: 26,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.20)
                      : Colors.white.withValues(alpha: 0.45),
                  width: 2,
                ),
                gradient: RadialGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF38BDF8).withValues(alpha: 0.10),
                          Colors.transparent,
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.30),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                ),
              ),
            ),
          ),

        // Main Interactive Layout
        LayoutBuilder(
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
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Interactive Frosted Glass Search Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF131D36)
                                          .withValues(alpha: 0.76)
                                      : Colors.white.withValues(alpha: 0.55),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: isDark
                                        ? [
                                            const Color(0xFF1E293B)
                                                .withValues(alpha: 0.82),
                                            const Color(0xFF0F172A)
                                                .withValues(alpha: 0.65),
                                            const Color(0xFF0284C7)
                                                .withValues(alpha: 0.12),
                                          ]
                                        : [
                                            Colors.white.withValues(alpha: 0.78),
                                            Colors.white.withValues(alpha: 0.35),
                                            const Color(0xFFBAE6FD)
                                                .withValues(alpha: 0.18),
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isDark
                                        ? const Color(0xFF38BDF8)
                                            .withValues(alpha: 0.24)
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
                                    Icon(
                                      Icons.search_rounded,
                                      color: glass.accentColor,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: _searchController,
                                        decoration: InputDecoration(
                                          hintText: l10n.searchFacilities,
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
                                            size: 18,
                                            color: glass.subtitleText),
                                        onPressed: () {
                                          _searchController.clear();
                                        },
                                      ),
                                  ],
                                ),
                              ),
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
                                        icon: Icons.grid_view_rounded,
                                        category: FacilityFilterCategory.all,
                                        isDark: isDark,
                                      ),
                                      const SizedBox(width: 6),
                                      _buildFilterChip(
                                        label: l10n.nearbyFilter,
                                        icon: Icons.near_me_rounded,
                                        category: FacilityFilterCategory.nearby,
                                        isDark: isDark,
                                      ),
                                      const SizedBox(width: 6),
                                      _buildFilterChip(
                                        label: l10n.categoryClinical,
                                        icon: Icons.medical_services_rounded,
                                        category:
                                            FacilityFilterCategory.clinical,
                                        isDark: isDark,
                                      ),
                                      const SizedBox(width: 6),
                                      _buildFilterChip(
                                        label: l10n.categoryCounseling,
                                        icon: Icons.volunteer_activism_rounded,
                                        category:
                                            FacilityFilterCategory.counseling,
                                        isDark: isDark,
                                      ),
                                      const SizedBox(width: 6),
                                      _buildFilterChip(
                                        label: l10n.categoryAcademic,
                                        icon: Icons.menu_book_rounded,
                                        category:
                                            FacilityFilterCategory.academic,
                                        isDark: isDark,
                                      ),
                                      const SizedBox(width: 6),
                                      _buildFilterChip(
                                        label: l10n.categoryStudentAffairs,
                                        icon: Icons.account_balance_rounded,
                                        category: FacilityFilterCategory
                                            .studentAffairs,
                                        isDark: isDark,
                                      ),
                                      const SizedBox(width: 6),
                                      _buildFilterChip(
                                        label: l10n.categorySports,
                                        icon: Icons.fitness_center_rounded,
                                        category: FacilityFilterCategory
                                            .sportsDining,
                                        isDark: isDark,
                                      ),
                                      const SizedBox(width: 6),
                                      _buildFilterChip(
                                        label: l10n.categoryAccessibility,
                                        icon: Icons.accessible_forward_rounded,
                                        category: FacilityFilterCategory
                                            .accessibility,
                                        isDark: isDark,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Segmented List/Map Toggle
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF1E293B)
                                              .withValues(alpha: 0.70)
                                          : const Color(0xFFE0F2FE)
                                              .withValues(alpha: 0.65),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: isDark
                                            ? const Color(0xFF38BDF8)
                                                .withValues(alpha: 0.22)
                                            : Colors.white
                                                .withValues(alpha: 0.8),
                                        width: 1.1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildModeButton(
                                          icon: Icons.view_agenda_outlined,
                                          mode: _ViewMode.list,
                                          tooltip: l10n.listViewLabel,
                                          isDark: isDark,
                                        ),
                                        _buildModeButton(
                                          icon: Icons.map_outlined,
                                          mode: _ViewMode.map,
                                          tooltip: l10n.mapViewLabel,
                                          isDark: isDark,
                                        ),
                                      ],
                                    ),
                                  ),
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
                          ? Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: isDark
                                    ? const Color(0xFF38BDF8)
                                    : const Color(0xFF0284C7),
                              ),
                            )
                          : _facilities.isEmpty
                              ? _buildNoResultsEmptyState(l10n, isDark)
                              : _viewMode == _ViewMode.list
                                  ? RefreshIndicator(
                                      onRefresh: _handleRefresh,
                                      color: isDark
                                          ? const Color(0xFF38BDF8)
                                          : const Color(0xFF0284C7),
                                      child: ListView.builder(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 6, 20, 24),
                                        itemCount: _facilities.length,
                                        itemBuilder: (context, index) =>
                                            FacilityCard(
                                          facility: _facilities[index],
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 6, 20, 20),
                                      child: FacilityMapView(
                                        facilities: _facilities,
                                        userLocation: _userLocation,
                                        onLocateMeRequested: () =>
                                            _fetchUserLocation(
                                                showFeedback: true),
                                        tileProvider: widget.tileProvider,
                                        mapController: widget.mapController,
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
    ),
  );
}

  Widget _buildFilterChip({
    required String label,
    required FacilityFilterCategory category,
    required bool isDark,
    IconData? icon,
  }) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => _onCategorySelected(category),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6.5),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFF0284C7))
                  : (isDark
                      ? const Color(0xFF131D36).withValues(alpha: 0.65)
                      : Colors.white.withValues(alpha: 0.55)),
              gradient: isSelected
                  ? (isDark
                      ? const LinearGradient(
                          colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                        )
                      : const LinearGradient(
                          colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                        ))
                  : null,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? (isDark
                        ? const Color(0xFF7DD3FC)
                        : const Color(0xFF0284C7))
                    : (isDark
                        ? const Color(0xFF38BDF8).withValues(alpha: 0.20)
                        : Colors.white.withValues(alpha: 0.85)),
                width: 1.1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: isDark
                            ? const Color(0x5538BDF8)
                            : const Color(0x330284C7),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 13,
                    color: isSelected
                        ? (isDark ? const Color(0xFF070D1E) : Colors.white)
                        : (isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B)),
                  ),
                  const SizedBox(width: 5),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected
                        ? (isDark ? const Color(0xFF070D1E) : Colors.white)
                        : (isDark
                            ? const Color(0xFFF1F5F9)
                            : const Color(0xFF334155)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton({
    required IconData icon,
    required _ViewMode mode,
    required String tooltip,
    required bool isDark,
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
          color: isSelected
              ? (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected
              ? (isDark ? const Color(0xFF070D1E) : Colors.white)
              : (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7)),
        ),
      ),
    );
  }

  Widget _buildNoResultsEmptyState(AppLocalizations l10n, bool isDark) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF131D36).withValues(alpha: 0.70)
                      : Colors.white.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF38BDF8).withValues(alpha: 0.22)
                        : Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE0F2FE),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.search_off_rounded,
                        size: 40,
                        color: isDark
                            ? const Color(0xFF38BDF8)
                            : const Color(0xFF0284C7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noVerifiedFacilitiesTitle,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? const Color(0xFFF8FAFC)
                            : const Color(0xFF08264A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.facilitiesNotAvailableBody,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 13,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: _resetFilters,
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: Text(l10n.resetFiltersAction),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? const Color(0xFF38BDF8)
                            : const Color(0xFF0284C7),
                        foregroundColor:
                            isDark ? const Color(0xFF070D1E) : Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildEmptyPresentationState(AppLocalizations l10n, bool isDark) =>
      Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_hospital_outlined,
                  size: 40,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.noVerifiedFacilitiesTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? const Color(0xFFF8FAFC)
                      : const Color(0xFF08264A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.facilitiesNotAvailableBody,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 13,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
}
