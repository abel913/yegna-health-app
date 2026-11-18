import 'dart:ui';
import 'package:flutter/material.dart';

import '../notifications/notification_controller.dart';
import '../theme/app_glass_theme.dart';
import 'club_card.dart';
import 'club_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    final glass = context.glassTheme;
    final isDark = glass.isDark;

    return Scaffold(
      backgroundColor: glass.scaffoldBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              color: glass.appBarBackground.withValues(alpha: isDark ? 0.70 : 0.60),
            ),
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF38BDF8).withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.8),
              ),
            ),
            child: Icon(Icons.arrow_back_rounded, size: 18, color: glass.titleText),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAmharic ? 'የተማሪዎች የጤና ክበቦች' : 'Student Health Clubs',
              style: TextStyle(
                fontSize: 17.5,
                fontWeight: FontWeight.w800,
                color: glass.titleText,
                letterSpacing: -0.3,
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
            icon: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                    : Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.8),
                ),
              ),
              child: Icon(Icons.refresh_rounded, size: 18, color: glass.titleText),
            ),
            tooltip: 'Refresh',
            onPressed: () => widget.controller.loadClubs(widget.userId),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Ambient Gradient Canvas
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? const [
                        Color(0xFF070D1E),
                        Color(0xFF0B132B),
                        Color(0xFF0F172A),
                      ]
                    : const [
                        Color(0xFFF0F9FF),
                        Color(0xFFE0F2FE),
                        Color(0xFFF8FAFC),
                      ],
              ),
            ),
          ),

          // Floating Ambient Orbs (Matching Facilities & Mentors Pages)
          Positioned(
            top: 100,
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
            top: 380,
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
                          Color(0x100284C7),
                          Colors.transparent,
                        ]
                      : const [
                          Color(0x650D9488),
                          Color(0x250284C7),
                          Colors.transparent,
                        ],
                ),
              ),
            ),
          ),

          // Decorative Floating Glass Spheres with specular sheen
          Positioned(
            top: 130,
            left: 20,
            child: Container(
              width: 84,
              height: 84,
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
            top: 520,
            right: 24,
            child: Container(
              width: 100,
              height: 100,
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

          // Main Interactive Foreground
          SafeArea(
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) {
                final clubs = widget.controller.clubs;
                final isLoading = widget.controller.isLoading;
                final joinedCount = widget.controller.joinedCount;

                return Column(
                  children: [
                    // Search & Segmented Switcher Controls
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Column(
                        children: [
                          // Frosted Search Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF131D36).withValues(alpha: 0.76)
                                      : Colors.white.withValues(alpha: 0.55),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isDark
                                        ? const Color(0xFF38BDF8).withValues(alpha: 0.22)
                                        : Colors.white.withValues(alpha: 0.85),
                                    width: 1.2,
                                  ),
                                  boxShadow: isDark
                                      ? const [
                                          BoxShadow(
                                            color: Color(0x40000000),
                                            blurRadius: 10,
                                            offset: Offset(0, 4),
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: const Color(0xFF0284C7).withValues(alpha: 0.08),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: widget.controller.setSearchQuery,
                                  style: TextStyle(fontSize: 13.5, color: glass.titleText),
                                  decoration: InputDecoration(
                                    hintText: isAmharic
                                        ? 'ክበብ፣ ርዕስ ወይም አሰልጣኝ ፈልግ...'
                                        : 'Search clubs, topics, mentors...',
                                    hintStyle: TextStyle(
                                      fontSize: 13,
                                      color: glass.subtitleText.withValues(alpha: 0.8),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search_rounded,
                                      size: 20,
                                      color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                                    ),
                                    suffixIcon: _searchController.text.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(Icons.clear_rounded, size: 18),
                                            onPressed: () {
                                              _searchController.clear();
                                              widget.controller.setSearchQuery('');
                                            },
                                          )
                                        : null,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Frosted Segmented Control: Explore All vs My Clubs
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF0F172A).withValues(alpha: 0.70)
                                      : Colors.white.withValues(alpha: 0.50),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isDark
                                        ? const Color(0xFF38BDF8).withValues(alpha: 0.18)
                                        : Colors.white.withValues(alpha: 0.80),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => widget.controller.toggleFilterJoined(false),
                                        borderRadius: BorderRadius.circular(10),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          decoration: BoxDecoration(
                                            color: !widget.controller.showOnlyJoined
                                                ? const Color(0xFF0284C7)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: !widget.controller.showOnlyJoined
                                                ? [
                                                    BoxShadow(
                                                      color: const Color(0xFF0284C7).withValues(alpha: 0.35),
                                                      blurRadius: 8,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ]
                                                : null,
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
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => widget.controller.toggleFilterJoined(true),
                                        borderRadius: BorderRadius.circular(10),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          decoration: BoxDecoration(
                                            color: widget.controller.showOnlyJoined
                                                ? const Color(0xFF0284C7)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: widget.controller.showOnlyJoined
                                                ? [
                                                    BoxShadow(
                                                      color: const Color(0xFF0284C7).withValues(alpha: 0.35),
                                                      blurRadius: 8,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ]
                                                : null,
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
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Horizontal Category Chips
                    SizedBox(
                      height: 48,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        itemCount: ClubCategory.values.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final cat = ClubCategory.values[index];
                          final isSelected = widget.controller.selectedCategory == cat;
                          final catColor = cat.color;

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: InkWell(
                                onTap: () => widget.controller.setCategory(cat),
                                borderRadius: BorderRadius.circular(20),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? (isDark
                                            ? const Color(0xFF38BDF8)
                                            : const Color(0xFF0284C7))
                                        : (isDark
                                            ? const Color(0xFF131D36).withValues(alpha: 0.65)
                                            : Colors.white.withValues(alpha: 0.55)),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.transparent
                                          : (isDark
                                              ? const Color(0xFF38BDF8).withValues(alpha: 0.20)
                                              : Colors.white.withValues(alpha: 0.85)),
                                      width: 1.2,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: (isDark
                                                      ? const Color(0xFF38BDF8)
                                                      : const Color(0xFF0284C7))
                                                  .withValues(alpha: 0.35),
                                              blurRadius: 10,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        cat.icon,
                                        size: 15,
                                        color: isSelected
                                            ? (isDark ? Colors.black : Colors.white)
                                            : catColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        cat.label(isAmharic),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected
                                              ? (isDark ? Colors.black : Colors.white)
                                              : glass.subtitleText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Main Content Area
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : clubs.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                                        child: Container(
                                          padding: const EdgeInsets.all(28),
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? const Color(0xFF131D36).withValues(alpha: 0.70)
                                                : Colors.white.withValues(alpha: 0.55),
                                            borderRadius: BorderRadius.circular(24),
                                            border: Border.all(
                                              color: isDark
                                                  ? const Color(0xFF38BDF8).withValues(alpha: 0.22)
                                                  : Colors.white.withValues(alpha: 0.85),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 64,
                                                height: 64,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.groups_rounded,
                                                  size: 32,
                                                  color: Color(0xFF38BDF8),
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                isAmharic ? 'ምንም ክበብ አልተገኘም' : 'No Clubs Found',
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
                                      ),
                                    ),
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: () => widget.controller.loadClubs(widget.userId),
                                  color: const Color(0xFF0284C7),
                                  child: ListView.builder(
                                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                                    itemCount: clubs.length,
                                    itemBuilder: (context, index) {
                                      final club = clubs[index];
                                      return ClubCard(
                                        club: club,
                                        controller: widget.controller,
                                        userId: widget.userId,
                                        userEmail: widget.userEmail,
                                        userName: widget.userName,
                                        notificationController: widget.notificationController,
                                      );
                                    },
                                  ),
                                ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
