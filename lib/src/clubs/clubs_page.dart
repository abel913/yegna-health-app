import 'dart:ui';
import 'package:flutter/material.dart';

import '../notifications/notification_controller.dart';
import '../theme/app_glass_theme.dart';
import 'club_card.dart';
import 'club_controller.dart';
import 'widgets/club_ambient_backdrop.dart';
import 'widgets/club_category_chips.dart';
import 'widgets/club_empty_view.dart';
import 'widgets/club_search_segmented_bar.dart';

class ClubsPage extends StatefulWidget {
  const ClubsPage({
    required this.controller,
    required this.userId,
    this.userEmail,
    this.userName,
    this.notificationController,
    this.onRequireAuth,
    super.key,
  });

  final ClubController controller;
  final String userId;
  final String? userEmail;
  final String? userName;
  final InAppNotificationController? notificationController;
  final VoidCallback? onRequireAuth;

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
          icon: Icon(Icons.arrow_back_rounded, size: 20, color: glass.titleText),
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
              ),
            ),
            Text(
              isAmharic ? 'ተሳትፎ፣ የአቻ ድጋፍ እና ጤናማ እድገት' : 'Peer Support, Wellness & Community',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: glass.subtitleText),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, size: 20, color: glass.titleText),
            tooltip: 'Refresh',
            onPressed: () => widget.controller.loadClubs(widget.userId),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          ClubAmbientBackdrop(isDark: isDark),
          SafeArea(
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) {
                final clubs = widget.controller.clubs;
                final isLoading = widget.controller.isLoading;
                final joinedCount = widget.controller.joinedCount;

                return Column(
                  children: [
                    ClubSearchSegmentedBar(
                      searchController: _searchController,
                      controller: widget.controller,
                      isAmharic: isAmharic,
                      isDark: isDark,
                      glass: glass,
                      joinedCount: joinedCount,
                    ),
                    const SizedBox(height: 4),
                    ClubCategoryChips(
                      controller: widget.controller,
                      isAmharic: isAmharic,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : clubs.isEmpty
                              ? ClubEmptyView(
                                  controller: widget.controller,
                                  isAmharic: isAmharic,
                                  isDark: isDark,
                                  glass: glass,
                                )
                              : RefreshIndicator(
                                  onRefresh: () => widget.controller.refreshClubs(widget.userId),
                                  child: ListView.builder(
                                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                                    itemCount: clubs.length,
                                    itemBuilder: (context, idx) => ClubCard(
                                      club: clubs[idx],
                                      controller: widget.controller,
                                      userId: widget.userId,
                                      userEmail: widget.userEmail,
                                      userName: widget.userName,
                                      notificationController: widget.notificationController,
                                      onRequireAuth: widget.onRequireAuth,
                                    ),
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
