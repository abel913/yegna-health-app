import 'package:flutter/material.dart';

import '../notifications/notification_controller.dart';
import '../theme/app_glass_theme.dart';
import 'club_controller.dart';
import 'club_detail_sheet.dart';
import 'club_models.dart';

class ClubsPage extends StatefulWidget {
  const ClubsPage({
    required this.controller,
    required this.userId,
    this.userEmail,
    this.userName,
    this.notificationController,
    super.key,
  });

  final ClubController controller;
  final String userId;
  final String? userEmail;
  final String? userName;
  final InAppNotificationController? notificationController;

  @override
  State<ClubsPage> createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.loadClubs(widget.userId);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    final glass = context.glassTheme;

    return Scaffold(
      backgroundColor: glass.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: glass.appBarBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: glass.titleText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAmharic ? 'የተማሪዎች የጤና ክበቦች' : 'Student Health Clubs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: glass.titleText,
              ),
            ),
            Text(
              isAmharic
                  ? 'ተሳትፎ፣ የአቻ ድጋፍ እና ጤናማ እድገት'
                  : 'Peer Support, Wellness & Community',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: glass.subtitleText,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: glass.titleText),
            tooltip: 'Refresh',
            onPressed: () => widget.controller.loadClubs(widget.userId),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final clubs = widget.controller.clubs;
          final isLoading = widget.controller.isLoading;
          final joinedCount = widget.controller.joinedCount;

          return Column(
            children: [
              // Search & Segmented Controls Container
              Container(
                color: glass.appBarBackground,
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Column(
                  children: [
                    // Search Field
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: glass.isDark
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: glass.isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: widget.controller.setSearchQuery,
                        style:
                            TextStyle(fontSize: 13.5, color: glass.titleText),
                        decoration: InputDecoration(
                          hintText: isAmharic
                              ? 'ክበብ፣ ርዕስ ወይም አሰልጣኝ ፈልግ...'
                              : 'Search clubs, topics, mentors...',
                          hintStyle: TextStyle(
                              fontSize: 13, color: glass.subtitleText),
                          prefixIcon: Icon(Icons.search_rounded,
                              size: 20, color: glass.subtitleText),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon:
                                      const Icon(Icons.clear_rounded, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    widget.controller.setSearchQuery('');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Segmented Filter: All vs My Clubs
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () =>
                                widget.controller.toggleFilterJoined(false),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: !widget.controller.showOnlyJoined
                                    ? const Color(0xFF0284C7)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: !widget.controller.showOnlyJoined
                                      ? Colors.transparent
                                      : (glass.isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFE2E8F0)),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  isAmharic ? 'ሁሉንም አስስ' : 'Explore All',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: !widget.controller.showOnlyJoined
                                        ? Colors.white
                                        : glass.subtitleText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () =>
                                widget.controller.toggleFilterJoined(true),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: widget.controller.showOnlyJoined
                                    ? const Color(0xFF0284C7)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: widget.controller.showOnlyJoined
                                      ? Colors.transparent
                                      : (glass.isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFE2E8F0)),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.stars_rounded,
                                      size: 15,
                                      color: widget.controller.showOnlyJoined
                                          ? Colors.white
                                          : const Color(0xFF38BDF8),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${isAmharic ? "የእኔ ክበቦች" : "My Clubs"} ($joinedCount)',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: widget.controller.showOnlyJoined
                                            ? Colors.white
                                            : glass.subtitleText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Category Horizontal Chips
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  itemCount: ClubCategory.values.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = ClubCategory.values[index];
                    final isSelected =
                        widget.controller.selectedCategory == cat;
                    return InkWell(
                      onTap: () => widget.controller.setCategory(cat),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (glass.isDark
                                  ? const Color(0xFF38BDF8)
                                  : const Color(0xFF0284C7))
                              : glass.cardBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : (glass.isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFE2E8F0)),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _categoryIcon(cat),
                              size: 15,
                              color: isSelected
                                  ? (glass.isDark ? Colors.black : Colors.white)
                                  : (glass.isDark
                                      ? const Color(0xFF38BDF8)
                                      : const Color(0xFF0284C7)),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _categoryLabel(cat, isAmharic),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? (glass.isDark
                                        ? Colors.black
                                        : Colors.white)
                                    : glass.subtitleText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Main List / Content Area
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : clubs.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0284C7)
                                          .withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.groups_rounded,
                                        size: 32, color: Color(0xFF38BDF8)),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    isAmharic
                                        ? 'ምንም ክበብ አልተገኘም'
                                        : 'No Clubs Found',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: glass.titleText,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    widget.controller.showOnlyJoined
                                        ? (isAmharic
                                            ? 'እስካሁን ምንም ክበብ አልተቀላቀሉም። ከላይ "ሁሉንም አስስ" የሚለውን በመንካት ክበቦችን ይቀላቀሉ።'
                                            : 'You haven\'t joined any clubs yet. Tap "Explore All" to discover and register.')
                                        : (isAmharic
                                            ? 'የተለየ ቁልፍ ቃል ወይም ምድብ ይሞክሩ።'
                                            : 'Try adjusting your search or category filters.'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: glass.subtitleText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () =>
                                widget.controller.loadClubs(widget.userId),
                            color: const Color(0xFF0284C7),
                            child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                            itemCount: clubs.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final club = clubs[index];
                              final isJoined =
                                  widget.controller.isJoined(club.id);
                              final title =
                                  isAmharic ? club.nameAm : club.nameEn;
                              final desc = isAmharic
                                  ? club.descriptionAm
                                  : club.descriptionEn;
                              final schedule = isAmharic
                                  ? club.meetingScheduleAm
                                  : club.meetingScheduleEn;
                              final mentorName = isAmharic
                                  ? club.mentorNameAm
                                  : club.mentorNameEn;

                              return InkWell(
                                onTap: () => ClubDetailSheet.show(
                                  context,
                                  club: club,
                                  controller: widget.controller,
                                  userId: widget.userId,
                                  userEmail: widget.userEmail,
                                  userName: widget.userName,
                                  notificationController:
                                      widget.notificationController,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: glass.cardBackground,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isJoined
                                          ? const Color(0xFF10B981)
                                              .withValues(alpha: 0.5)
                                          : glass.cardBorder,
                                      width: isJoined ? 1.4 : 1.2,
                                    ),
                                    boxShadow: glass.cardShadow,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Top Badges Row
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 9, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF0284C7)
                                                  .withValues(alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                    _categoryIcon(
                                                        club.category),
                                                    size: 13,
                                                    color: const Color(
                                                        0xFF38BDF8)),
                                                const SizedBox(width: 5),
                                                Text(
                                                  _categoryLabel(
                                                      club.category, isAmharic),
                                                  style: const TextStyle(
                                                    fontSize: 10.5,
                                                    fontWeight: FontWeight.w800,
                                                    color: Color(0xFF38BDF8),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (isJoined)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 3),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF10B981)
                                                    .withValues(alpha: 0.15),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                      Icons
                                                          .check_circle_rounded,
                                                      size: 13,
                                                      color: Color(0xFF10B981)),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    isAmharic
                                                        ? 'አባል ነዎት'
                                                        : 'Joined ✓',
                                                    style: const TextStyle(
                                                      fontSize: 10.5,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Color(0xFF10B981),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),

                                      // Title
                                      Text(
                                        title,
                                        style: TextStyle(
                                          fontSize: 16.5,
                                          fontWeight: FontWeight.w800,
                                          color: glass.titleText,
                                        ),
                                      ),
                                      const SizedBox(height: 6),

                                      // Description
                                      Text(
                                        desc,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          height: 1.4,
                                          color: glass.subtitleText,
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      // Schedule & Mentor Row
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 7),
                                        decoration: BoxDecoration(
                                          color: glass.isDark
                                              ? const Color(0xFF0F172A)
                                              : const Color(0xFFF1F5F9),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.schedule_rounded,
                                                size: 14,
                                                color: Color(0xFF0284C7)),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                schedule,
                                                style: TextStyle(
                                                  fontSize: 11.5,
                                                  fontWeight: FontWeight.w700,
                                                  color: glass.titleText,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(Icons.person_rounded,
                                                size: 14,
                                                color: Color(0xFF10B981)),
                                            const SizedBox(width: 4),
                                            Text(
                                              mentorName,
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w700,
                                                color: glass.subtitleText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      // Member Count & Join Trigger Row
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '👥 ${club.memberCount} ${isAmharic ? "አባላት" : "members"}'
                                            '${club.maxCapacity != null ? " / ${club.maxCapacity}" : ""}',
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w600,
                                              color: glass.subtitleText,
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isJoined
                                                  ? const Color(0xFF10B981)
                                                  : const Color(0xFF0284C7),
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            icon: Icon(
                                              isJoined
                                                  ? Icons.check_rounded
                                                  : Icons.add_rounded,
                                              size: 16,
                                            ),
                                            label: Text(
                                              isJoined
                                                  ? (isAmharic
                                                      ? 'ተቀላቅለዋል'
                                                      : 'Joined')
                                                  : (isAmharic
                                                      ? 'ተቀላቀል'
                                                      : 'Join'),
                                              style: const TextStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            onPressed: () =>
                                                ClubDetailSheet.show(
                                              context,
                                              club: club,
                                              controller: widget.controller,
                                              userId: widget.userId,
                                              userEmail: widget.userEmail,
                                              userName: widget.userName,
                                              notificationController:
                                                  widget.notificationController,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}
