import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'account/app_settings_controller.dart';
import 'assessment/self_assessment_page.dart';
import 'auth/auth_controller.dart';
import 'auth/auth_pages.dart';
import 'discovery/directory_pages.dart';
import 'discovery/facility_repository.dart';
import 'discovery/mentor_repository.dart';
import 'home/home_page.dart';
import 'locale_controller.dart';
import 'learning/assessment_repository.dart';
import 'learning/education_repository.dart';
import 'chatbot/chatbot_repository.dart';
import 'chatbot/composite_chatbot_repository.dart';
import 'chatbot/yegna_chatbot_fab.dart';
import 'learning/learn_pages.dart';
import 'learning/learning_progress_controller.dart';
import 'notifications/notification_center_sheet.dart';
import 'notifications/notification_controller.dart';
import 'theme/app_glass_theme.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    required this.localeController,
    required this.authController,
    required this.educationRepository,
    required this.assessmentRepository,
    required this.progressController,
    this.settingsController,
    this.notificationController,
    this.facilityRepository,
    this.mentorRepository,
    this.chatbotRepository,
    super.key,
  });

  final LocaleController localeController;
  final AuthController authController;
  final AppSettingsController? settingsController;
  final InAppNotificationController? notificationController;
  final EducationRepository educationRepository;
  final AssessmentRepository assessmentRepository;
  final LearningProgressController progressController;
  final FacilityRepository? facilityRepository;
  final MentorRepository? mentorRepository;
  final ChatbotRepository? chatbotRepository;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final InAppNotificationController _notificationController;
  int _selectedIndex = 0;
  int _previousIndex = 0;
  bool _accountRouteOpen = false;
  bool _recoveryRouteOpen = false;

  @override
  void initState() {
    super.initState();
    _notificationController =
        widget.notificationController ?? InAppNotificationController();
    if (!_notificationController.isInitialized) {
      final isAmharic = widget.localeController.locale.languageCode == 'am';
      final healthTipsEnabled =
          widget.settingsController?.healthTipsEnabled ?? true;
      _notificationController.load(
        isAmharic: isAmharic,
        healthTipsEnabled: healthTipsEnabled,
      );
    }
    widget.authController.addListener(_handleAuthChange);
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleAuthChange());
  }

  @override
  void dispose() {
    widget.authController.removeListener(_handleAuthChange);
    super.dispose();
  }

  void _onDestinationSelected(int index) {
    if (index == 4 && !widget.authController.isAuthenticated) {
      _openAccount();
      return;
    }
    if (index != _selectedIndex) {
      setState(() {
        _previousIndex = _selectedIndex;
        _selectedIndex = index;
      });
    }
  }

  IconData _selectedIcon(int index) => switch (index) {
        0 => Icons.home_rounded,
        1 => Icons.local_hospital_rounded,
        2 => Icons.people_alt_rounded,
        3 => Icons.menu_book_rounded,
        _ => Icons.person_rounded,
      };

  void _handleAuthChange() {
    if (!mounted) return;
    if (!widget.authController.isAuthenticated && _selectedIndex == 4) {
      setState(() {
        _previousIndex = _selectedIndex;
        _selectedIndex = 0;
      });
    }
    if (!widget.authController.recoveryRequested ||
        _accountRouteOpen ||
        _recoveryRouteOpen) {
      return;
    }
    _recoveryRouteOpen = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context)
          .push<void>(MaterialPageRoute<void>(
            builder: (_) => AuthPage(
              controller: widget.authController,
              notificationController: _notificationController,
              initialMode: AuthPageMode.newPassword,
            ),
          ))
          .whenComplete(() => _recoveryRouteOpen = false);
    });
  }

  void _openAccount() {
    _accountRouteOpen = true;
    final page = widget.authController.isAuthenticated
        ? ProfilePage(
            controller: widget.authController,
            notificationController: _notificationController,
          )
        : AuthPage(
            controller: widget.authController,
            notificationController: _notificationController,
          );
    Navigator.of(context)
        .push<void>(MaterialPageRoute<void>(builder: (_) => page))
        .whenComplete(() {
      _accountRouteOpen = false;
      if (mounted && widget.authController.isAuthenticated) {
        setState(() {
          _previousIndex = _selectedIndex;
          _selectedIndex = 4;
        });
      }
    });
  }

  void _openArticle(String articleId) {
    Navigator.of(context).push<void>(MaterialPageRoute<void>(
      builder: (_) => ArticlePage(
        articleId: articleId,
        repository: widget.educationRepository,
        progressController: widget.progressController,
        localeController: widget.localeController,
      ),
    ));
  }

  void _openLearningProgress() {
    Navigator.of(context).push<void>(MaterialPageRoute<void>(
      builder: (_) => LearningProgressScreen(
        controller: widget.progressController,
        assessmentRepository: widget.assessmentRepository,
      ),
    ));
  }

  void _openSelfAssessment() {
    Navigator.of(context).push<void>(MaterialPageRoute<void>(
      builder: (_) => SelfAssessmentPage(
        onOpenMentors: () {
          _onDestinationSelected(2);
        },
        onOpenFacilities: () {
          _onDestinationSelected(1);
        },
        onOpenLearning: () {
          _onDestinationSelected(3);
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      HomePage(
        educationRepository: widget.educationRepository,
        authController: widget.authController,
        progressController: widget.progressController,
        assessmentRepository: widget.assessmentRepository,
        locale: Localizations.localeOf(context),
        onOpenLearning: () => _onDestinationSelected(3),
        onOpenMentors: () => _onDestinationSelected(2),
        onOpenFacilities: () => _onDestinationSelected(1),
        onOpenAccount: _openAccount,
        onOpenArticle: _openArticle,
        onOpenSelfAssessment: _openSelfAssessment,
      ),
      FacilitiesPage(
        facilityRepository: widget.facilityRepository,
      ),
      MentorsPage(
        mentorRepository: widget.mentorRepository,
      ),
      LearnPage(
        educationRepository: widget.educationRepository,
        assessmentRepository: widget.assessmentRepository,
        progressController: widget.progressController,
        localeController: widget.localeController,
      ),
      _AccountPage(
        localeController: widget.localeController,
        authController: widget.authController,
        progressController: widget.progressController,
        assessmentRepository: widget.assessmentRepository,
        settingsController:
            widget.settingsController ?? AppSettingsController(),
        onOpenAccount: _openAccount,
        onOpenLearningProgress: _openLearningProgress,
      ),
    ];
    final glass = context.glassTheme;
    final isDark = context.isDark;
    return Scaffold(
      backgroundColor: glass.scaffoldBackground,
      appBar: AppBar(
        titleSpacing: 20,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: glass.appBarBackground,
                border: Border(
                  bottom: BorderSide(
                    color: glass.appBarBorder,
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          _selectedIndex == 4 ? l10n.profile : l10n.appTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: glass.appBarTitle,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: _selectedIndex == 4,
        actions: _selectedIndex == 4
            ? [
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: glass.accentColor),
                  onSelected: (value) {
                    if (value == 'learning') {
                      _openLearningProgress();
                    } else if (value == 'sign_out') {
                      widget.authController.signOut();
                    }
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: 'learning',
                      child: Row(
                        children: [
                          Icon(Icons.school_outlined,
                              size: 20, color: glass.accentColor),
                          const SizedBox(width: 10),
                          Text(l10n.progressHeading),
                        ],
                      ),
                    ),
                    if (widget.authController.isAuthenticated)
                      PopupMenuItem(
                        value: 'sign_out',
                        child: Row(
                          children: [
                            const Icon(Icons.logout_rounded,
                                size: 20, color: Color(0xFFD32F2F)),
                            const SizedBox(width: 10),
                            Text(l10n.signOut,
                                style:
                                    const TextStyle(color: Color(0xFFD32F2F))),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 8),
              ]
            : [
                _NotificationButton(
                  controller: _notificationController,
                  onOpenSettings: () {
                    final l10n = AppLocalizations.of(context);
                    _AccountPage._showNotificationsModal(
                      context,
                      l10n,
                      widget.settingsController ?? AppSettingsController(),
                    );
                  },
                  onNavigate: (route) {
                    if (route == 'learn') {
                      setState(() {
                        _previousIndex = _selectedIndex;
                        _selectedIndex = 1;
                      });
                    }
                  },
                ),
                const SizedBox(width: 8),
                _LanguageDropdown(localeController: widget.localeController),
                const SizedBox(width: 14),
              ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (Widget child, Animation<double> animation) {
            final isForward = _selectedIndex >= _previousIndex;
            final beginOffset =
                isForward ? const Offset(0.06, 0) : const Offset(-0.06, 0);
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: beginOffset,
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
            return Stack(
              alignment: Alignment.topLeft,
              children: <Widget>[
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
          child: KeyedSubtree(
            key: ValueKey<int>(_selectedIndex),
            child: pages[_selectedIndex],
          ),
        ),
      ),
      floatingActionButton: (_selectedIndex == 0 || _selectedIndex == 3)
          ? YegnaChatbotFab(
              chatbotRepository:
                  widget.chatbotRepository ?? CompositeChatbotRepository(),
            )
          : null,
      bottomNavigationBar: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final tabWidth = totalWidth / 5;
            final targetNotchX = (_selectedIndex + 0.5) * tabWidth;
            const circleSize = 50.0;

            return TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: targetNotchX,
                end: targetNotchX,
              ),
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              builder: (context, notchX, child) {
                return SizedBox(
                  height: 72,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // 1. Scooped Notched Bar Background
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _ScoopedNotchBarPainter(
                            notchX: notchX,
                            color: glass.notchBackground,
                            borderColor: glass.notchBorder,
                            cradleBorderColor: glass.notchCradle,
                            shadowColor: glass.notchShadow,
                          ),
                        ),
                      ),

                      // 2. NavigationBar for Taps, Semantics & Descendants
                      Theme(
                        data: Theme.of(context).copyWith(
                          navigationBarTheme: NavigationBarThemeData(
                            indicatorColor: Colors.transparent,
                            labelTextStyle:
                                WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: glass.navSelectedColor,
                                );
                              }
                              return TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: glass.navUnselectedColor,
                              );
                            }),
                            iconTheme:
                                WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return const IconThemeData(
                                  color: Colors.transparent,
                                  size: 26,
                                );
                              }
                              return IconThemeData(
                                color: glass.navUnselectedColor,
                                size: 24,
                              );
                            }),
                          ),
                        ),
                        child: NavigationBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          height: 72,
                          selectedIndex: _selectedIndex,
                          onDestinationSelected: _onDestinationSelected,
                          labelBehavior:
                              NavigationDestinationLabelBehavior.alwaysShow,
                          destinations: [
                            NavigationDestination(
                              icon: const Icon(Icons.home_outlined),
                              selectedIcon:
                                  const SizedBox(width: 26, height: 26),
                              label: l10n.homeTab,
                            ),
                            NavigationDestination(
                              icon: const Icon(Icons.local_hospital_outlined),
                              selectedIcon:
                                  const SizedBox(width: 26, height: 26),
                              label: l10n.facilitiesTab,
                            ),
                            NavigationDestination(
                              icon: const Icon(Icons.people_alt_outlined),
                              selectedIcon:
                                  const SizedBox(width: 26, height: 26),
                              label: l10n.mentorsTab,
                            ),
                            NavigationDestination(
                              icon: const Icon(Icons.menu_book_outlined),
                              selectedIcon:
                                  const SizedBox(width: 26, height: 26),
                              label: l10n.learnTab,
                            ),
                            NavigationDestination(
                              icon: const Icon(Icons.person_outline_rounded),
                              selectedIcon:
                                  const SizedBox(width: 26, height: 26),
                              label: l10n.accountTab,
                            ),
                          ],
                        ),
                      ),

                      // 3. Floating 3D Circular Button Nested in the Scoop
                      Positioned(
                        left: notchX - (circleSize / 2),
                        top: -10,
                        child: IgnorePointer(
                          child: Container(
                            width: circleSize,
                            height: circleSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isDark
                                    ? const [
                                        Color(0xFF0284C7),
                                        Color(0xFF38BDF8),
                                      ]
                                    : const [
                                        Color(0xFF0284C7),
                                        Color(0xFF0369A1),
                                      ],
                              ),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF070D1E)
                                    : Colors.white,
                                width: 2.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? const Color(0x6038BDF8)
                                      : const Color(0x450284C7),
                                  blurRadius: 14,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                _selectedIcon(_selectedIndex),
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ScoopedNotchBarPainter extends CustomPainter {
  const _ScoopedNotchBarPainter({
    required this.notchX,
    required this.color,
    required this.borderColor,
    required this.cradleBorderColor,
    required this.shadowColor,
  });

  final double notchX;
  final Color color;
  final Color borderColor;
  final Color cradleBorderColor;
  final Color shadowColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    const r = 30.0;
    const depth = 22.0;
    const s = 12.0;

    final leftLip = math.max(0.0, notchX - r - s);
    final rightLip = math.min(w, notchX + r + s);

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(leftLip, 0)
      ..cubicTo(
        notchX - r,
        0,
        notchX - r + 3,
        depth,
        notchX,
        depth,
      )
      ..cubicTo(
        notchX + r - 3,
        depth,
        notchX + r,
        0,
        rightLip,
        0,
      )
      ..lineTo(w, 0)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    // 1. Ambient drop shadow
    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawPath(path, shadowPaint);

    // 2. Bar background fill
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // 3. Top edge continuous border
    final borderPath = Path()
      ..moveTo(0, 0)
      ..lineTo(leftLip, 0)
      ..cubicTo(
        notchX - r,
        0,
        notchX - r + 3,
        depth,
        notchX,
        depth,
      )
      ..cubicTo(
        notchX + r - 3,
        depth,
        notchX + r,
        0,
        rightLip,
        0,
      )
      ..lineTo(w, 0);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawPath(borderPath, borderPaint);

    // 4. Half-circle cradle accent contour between icon and text (matching reference)
    final cradleContour = Path()
      ..moveTo(notchX - r + 2, 2)
      ..cubicTo(
        notchX - r + 5,
        depth,
        notchX + r - 5,
        depth,
        notchX + r - 2,
        2,
      );

    final cradlePaint = Paint()
      ..color = cradleBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawPath(cradleContour, cradlePaint);
  }

  @override
  bool shouldRepaint(covariant _ScoopedNotchBarPainter oldDelegate) {
    return oldDelegate.notchX != notchX ||
        oldDelegate.color != color ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.cradleBorderColor != cradleBorderColor;
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({
    required this.controller,
    this.onOpenSettings,
    this.onNavigate,
  });

  final InAppNotificationController controller;
  final VoidCallback? onOpenSettings;
  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final unreadCount = controller.unreadCount;
        return Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF131D36).withValues(alpha: 0.85)
                      : Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF38BDF8).withValues(alpha: 0.3)
                        : const Color(0xFFBAE6FD).withValues(alpha: 0.9),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? const Color(0x30000000)
                          : const Color(0x100284C7),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.notifications_none_rounded,
                    size: 20,
                    color: isDark
                        ? const Color(0xFF38BDF8)
                        : const Color(0xFF005A71),
                  ),
                  padding: EdgeInsets.zero,
                  tooltip: 'Notifications',
                  onPressed: () {
                    NotificationCenterSheet.show(
                      context,
                      controller: controller,
                      onOpenSettings: onOpenSettings,
                      onNavigate: onNavigate,
                    );
                  },
                ),
              ),
              if (unreadCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      unreadCount > 9 ? '9+' : '$unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageDropdown extends StatelessWidget {
  const _LanguageDropdown({required this.localeController});
  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    final selected = localeController.locale.languageCode;
    final isDark = context.isDark;
    return Center(
      child: PopupMenuButton<String>(
        key: const Key('language_dropdown_button'),
        tooltip: 'Change language',
        position: PopupMenuPosition.under,
        offset: const Offset(0, 8),
        elevation: 12,
        shadowColor: const Color(0x350284C7),
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark
                ? const Color(0xFF38BDF8).withValues(alpha: 0.3)
                : const Color(0xFFBAE6FD),
            width: 1.4,
          ),
        ),
        onSelected: (value) {
          if (value != selected) {
            localeController.setLanguage(value);
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            value: 'en',
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: selected == 'en'
                        ? const Color(0xFFE0F2FE)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected == 'en'
                          ? const Color(0xFFBAE6FD)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🇺🇸', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'English',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'English (US)',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: selected == 'en'
                        ? const Color(0xFF0284C7)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'EN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: selected == 'en'
                          ? Colors.white
                          : const Color(0xFF475569),
                    ),
                  ),
                ),
                if (selected == 'en') ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: Color(0xFF0284C7),
                  ),
                ],
              ],
            ),
          ),
          const PopupMenuDivider(height: 1),
          PopupMenuItem<String>(
            value: 'am',
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: selected == 'am'
                        ? const Color(0xFFE0F2FE)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected == 'am'
                          ? const Color(0xFFBAE6FD)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🇪🇹', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'አማርኛ',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Amharic',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: selected == 'am'
                        ? const Color(0xFF0284C7)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'አማ',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: selected == 'am'
                          ? Colors.white
                          : const Color(0xFF475569),
                    ),
                  ),
                ),
                if (selected == 'am') ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: Color(0xFF0284C7),
                  ),
                ],
              ],
            ),
          ),
        ],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 11),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF131D36).withValues(alpha: 0.85)
                    : Colors.white.withValues(alpha: 0.75),
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF1E293B).withValues(alpha: 0.90),
                          const Color(0xFF0F172A).withValues(alpha: 0.70),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.90),
                          const Color(0xFFEDF8FE).withValues(alpha: 0.55),
                        ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38BDF8).withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.95),
                  width: 1.3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? const Color(0x30000000)
                        : const Color(0x180284C7),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0284C7).withValues(alpha: 0.25)
                          : const Color(0xFFE0F2FE),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.translate_rounded,
                      size: 13,
                      color: isDark
                          ? const Color(0xFF38BDF8)
                          : const Color(0xFF0284C7),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    selected == 'am' ? '🇪🇹 አማ' : '🇺🇸 EN',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? const Color(0xFFF8FAFC)
                          : const Color(0xFF08264A),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: isDark
                        ? const Color(0xFF38BDF8)
                        : const Color(0xFF0284C7),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountPage extends StatelessWidget {
  const _AccountPage({
    required this.localeController,
    required this.authController,
    required this.progressController,
    required this.assessmentRepository,
    required this.settingsController,
    required this.onOpenAccount,
    required this.onOpenLearningProgress,
  });

  final LocaleController localeController;
  final AuthController authController;
  final LearningProgressController progressController;
  final AssessmentRepository assessmentRepository;
  final AppSettingsController settingsController;
  final VoidCallback onOpenAccount;
  final VoidCallback onOpenLearningProgress;

  static void _showNotificationsModal(BuildContext context,
      AppLocalizations l10n, AppSettingsController settings) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => ListenableBuilder(
        listenable: settings,
        builder: (ctx, _) {
          final glass = context.glassTheme;
          return Material(
            color: glass.modalBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: glass.modalHandle,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF0284C7).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.notifications_active_outlined,
                            color: Color(0xFF0284C7), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.notificationsModalTitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: glass.titleText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.notificationsModalBody,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: glass.subtitleText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: settings.pushAlertsEnabled,
                    onChanged: (val) => settings.setPushAlerts(val),
                    title: Text(l10n.pushAlertsLabel,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.5,
                            color: glass.titleText)),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: settings.healthTipsEnabled,
                    onChanged: (val) => settings.setHealthTips(val),
                    title: Text(l10n.healthTipsLabel,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.5,
                            color: glass.titleText)),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: settings.assessmentRemindersEnabled,
                    onChanged: (val) => settings.setAssessmentReminders(val),
                    title: Text(l10n.assessmentRemindersLabel,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.5,
                            color: glass.titleText)),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(l10n.closeButton,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPrivacyModal(
      BuildContext context, AppLocalizations l10n, AuthController auth) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final glass = ctx.glassTheme;
        return Container(
          decoration: BoxDecoration(
            color: glass.modalBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: glass.isDark
                ? Border.all(color: glass.cardBorder, width: 1.2)
                : null,
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: glass.modalHandle,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: glass.isDark
                          ? glass.badgeBackground
                          : const Color(0xFF0284C7).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.shield_outlined,
                        color: glass.accentColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.privacyModalTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: glass.titleText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                l10n.privacyModalBody,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: glass.subtitleText,
                ),
              ),
              const SizedBox(height: 20),
              if (auth.isAuthenticated)
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFEF4444),
                    side: const BorderSide(color: Color(0xFFEF4444)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(l10n.signOut),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    auth.signOut();
                  },
                ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: glass.accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    l10n.closeButton,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: glass.isDark ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageModal(BuildContext context, AppLocalizations l10n,
      LocaleController localeCtrl) {
    final current = localeCtrl.locale.languageCode;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final glass = ctx.glassTheme;
        return Material(
          color: glass.modalBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              border: glass.isDark
                  ? Border.all(color: glass.cardBorder, width: 1.2)
                  : null,
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: glass.modalHandle,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.appLanguage,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: glass.titleText,
                  ),
                ),
                const SizedBox(height: 14),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: current == 'en'
                        ? BorderSide(
                            color: glass.isDark
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFFBAE6FD),
                            width: 1.2,
                          )
                        : BorderSide.none,
                  ),
                  tileColor: current == 'en' ? glass.modalSelectedTile : null,
                  leading: Icon(
                    Icons.check_circle_rounded,
                    color: current == 'en'
                        ? glass.accentColor
                        : glass.subtitleText,
                  ),
                  title: Text(
                    'English (US)',
                    style: TextStyle(
                      fontWeight:
                          current == 'en' ? FontWeight.w700 : FontWeight.w500,
                      color: glass.titleText,
                    ),
                  ),
                  onTap: () {
                    localeCtrl.setLanguage('en');
                    Navigator.of(ctx).pop();
                  },
                ),
                const SizedBox(height: 6),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: current == 'am'
                        ? BorderSide(
                            color: glass.isDark
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFFBAE6FD),
                            width: 1.2,
                          )
                        : BorderSide.none,
                  ),
                  tileColor: current == 'am' ? glass.modalSelectedTile : null,
                  leading: Icon(
                    Icons.check_circle_rounded,
                    color: current == 'am'
                        ? glass.accentColor
                        : glass.subtitleText,
                  ),
                  title: Text(
                    'አማርኛ (Amharic)',
                    style: TextStyle(
                      fontWeight:
                          current == 'am' ? FontWeight.w700 : FontWeight.w500,
                      color: glass.titleText,
                    ),
                  ),
                  onTap: () {
                    localeCtrl.setLanguage('am');
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showThemeModal(BuildContext context, AppLocalizations l10n,
      AppSettingsController settings) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ListenableBuilder(
        listenable: settings,
        builder: (ctx, _) {
          final glass = ctx.glassTheme;
          final isLight = settings.themeMode == ThemeMode.light;
          final isDark = settings.themeMode == ThemeMode.dark;

          return Material(
            color: glass.modalBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration: BoxDecoration(
                border: glass.isDark
                    ? Border.all(color: glass.cardBorder, width: 1.2)
                    : null,
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: glass.modalHandle,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.themeDialogTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: glass.titleText,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Only Light and Dark Options (System Default removed per requirement)
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: isLight
                          ? BorderSide(
                              color: glass.isDark
                                  ? const Color(0xFF38BDF8)
                                  : const Color(0xFFBAE6FD),
                              width: 1.2,
                            )
                          : BorderSide.none,
                    ),
                    tileColor: isLight ? glass.modalSelectedTile : null,
                    leading: Icon(
                      Icons.wb_sunny_rounded,
                      color: isLight ? glass.accentColor : glass.subtitleText,
                    ),
                    title: Text(
                      l10n.lightTheme,
                      style: TextStyle(
                        fontWeight: isLight ? FontWeight.w700 : FontWeight.w500,
                        color: glass.titleText,
                      ),
                    ),
                    trailing: isLight
                        ? Icon(Icons.check, color: glass.accentColor)
                        : null,
                    onTap: () {
                      settings.setThemeMode(ThemeMode.light);
                      Navigator.of(ctx).pop();
                    },
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: isDark
                          ? const BorderSide(
                              color: Color(0xFF38BDF8),
                              width: 1.2,
                            )
                          : BorderSide.none,
                    ),
                    tileColor: isDark ? glass.modalSelectedTile : null,
                    leading: Icon(
                      Icons.nightlight_round,
                      color: isDark ? glass.accentColor : glass.subtitleText,
                    ),
                    title: Text(
                      l10n.darkTheme,
                      style: TextStyle(
                        fontWeight: isDark ? FontWeight.w700 : FontWeight.w500,
                        color: glass.titleText,
                      ),
                    ),
                    trailing: isDark
                        ? Icon(Icons.check, color: glass.accentColor)
                        : null,
                    onTap: () {
                      settings.setThemeMode(ThemeMode.dark);
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showTextSizeModal(BuildContext context, AppLocalizations l10n,
      AppSettingsController settings) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ListenableBuilder(
        listenable: settings,
        builder: (ctx, _) {
          final glass = ctx.glassTheme;
          return Material(
            color: glass.modalBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration: BoxDecoration(
                border: glass.isDark
                    ? Border.all(color: glass.cardBorder, width: 1.2)
                    : null,
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: glass.modalHandle,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.textSizeDialogTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: glass.titleText,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: settings.textScale == AppTextScale.small
                          ? BorderSide(
                              color: glass.isDark
                                  ? const Color(0xFF38BDF8)
                                  : const Color(0xFFBAE6FD),
                              width: 1.2,
                            )
                          : BorderSide.none,
                    ),
                    tileColor: settings.textScale == AppTextScale.small
                        ? glass.modalSelectedTile
                        : null,
                    title: Text(
                      l10n.smallTextSize,
                      style: TextStyle(
                        fontWeight: settings.textScale == AppTextScale.small
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: glass.titleText,
                      ),
                    ),
                    trailing: settings.textScale == AppTextScale.small
                        ? Icon(Icons.check, color: glass.accentColor)
                        : null,
                    onTap: () {
                      settings.setTextScale(AppTextScale.small);
                      Navigator.of(ctx).pop();
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: settings.textScale == AppTextScale.normal
                          ? BorderSide(
                              color: glass.isDark
                                  ? const Color(0xFF38BDF8)
                                  : const Color(0xFFBAE6FD),
                              width: 1.2,
                            )
                          : BorderSide.none,
                    ),
                    tileColor: settings.textScale == AppTextScale.normal
                        ? glass.modalSelectedTile
                        : null,
                    title: Text(
                      l10n.defaultTextSize,
                      style: TextStyle(
                        fontWeight: settings.textScale == AppTextScale.normal
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: glass.titleText,
                      ),
                    ),
                    trailing: settings.textScale == AppTextScale.normal
                        ? Icon(Icons.check, color: glass.accentColor)
                        : null,
                    onTap: () {
                      settings.setTextScale(AppTextScale.normal);
                      Navigator.of(ctx).pop();
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: settings.textScale == AppTextScale.large
                          ? BorderSide(
                              color: glass.isDark
                                  ? const Color(0xFF38BDF8)
                                  : const Color(0xFFBAE6FD),
                              width: 1.2,
                            )
                          : BorderSide.none,
                    ),
                    tileColor: settings.textScale == AppTextScale.large
                        ? glass.modalSelectedTile
                        : null,
                    title: Text(
                      l10n.largeTextSize,
                      style: TextStyle(
                        fontWeight: settings.textScale == AppTextScale.large
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: glass.titleText,
                      ),
                    ),
                    trailing: settings.textScale == AppTextScale.large
                        ? Icon(Icons.check, color: glass.accentColor)
                        : null,
                    onTap: () {
                      settings.setTextScale(AppTextScale.large);
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSupportModal(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final glass = ctx.glassTheme;
        return Container(
          decoration: BoxDecoration(
            color: glass.modalBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: glass.isDark
                ? Border.all(color: glass.cardBorder, width: 1.2)
                : null,
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: glass.modalHandle,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: glass.isDark
                          ? glass.badgeBackground
                          : const Color(0xFF0284C7).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.support_agent_rounded,
                        color: glass.accentColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.supportCenterTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: glass.titleText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                l10n.supportCenterBody,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: glass.subtitleText,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: glass.isDark
                      ? const Color(0xFF131D36)
                      : const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: glass.isDark
                        ? glass.cardBorder
                        : const Color(0xFFBAE6FD),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.phone_in_talk_rounded, color: glass.accentColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Emergency Hotlines: 952 / 8335 (Toll-Free)',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: glass.titleText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: glass.accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    l10n.closeButton,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: glass.isDark ? Colors.black : Colors.white,
                    ),
                  ),
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
    return ListenableBuilder(
      listenable: settingsController,
      builder: (context, _) {
        final glass = context.glassTheme;
        final l10n = AppLocalizations.of(context);
        final selectedLanguage = localeController.locale.languageCode;
        final user = authController.user;

        final themeBadge = switch (settingsController.themeMode) {
          ThemeMode.system => l10n.systemTheme,
          ThemeMode.light => l10n.lightTheme,
          ThemeMode.dark => l10n.darkTheme,
        };

        final textSizeBadge = switch (settingsController.textScale) {
          AppTextScale.small => l10n.smallTextSize,
          AppTextScale.normal => l10n.defaultTextSize,
          AppTextScale.large => l10n.largeTextSize,
        };

        final rawName = user?.displayName;
        final displayName = (rawName != null && rawName.trim().isNotEmpty)
            ? rawName.trim()
            : (user != null && user.email.isNotEmpty
                ? user.email.split('@').first
                : (authController.isAuthenticated
                    ? 'abebebe'
                    : l10n.accountGuest));

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Avatar & Display Name
              Center(
                child: Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: glass.isDark
                        ? const Color(0xFF131D36)
                        : const Color(0xFFF0F9FF),
                    border: Border.all(
                      color: glass.isDark
                          ? const Color(0xFF38BDF8)
                          : const Color(0xFF7DD3FC),
                      width: 3.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: glass.isDark
                            ? const Color(0x3338BDF8)
                            : const Color(0x120284C7),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person,
                    size: 58,
                    color: glass.isDark
                        ? const Color(0xFF38BDF8)
                        : const Color(0xFF0284C7),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: glass.titleText,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Guest Mode Promotional Banner
              if (!authController.isAuthenticated) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: glass.isDark
                          ? const [Color(0xFF0F172A), Color(0xFF1E293B)]
                          : const [Color(0xFFE0F2FE), Color(0xFFF0F9FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: glass.isDark
                          ? glass.cardBorder
                          : const Color(0xFFBAE6FD),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: glass.isDark
                            ? const Color(0x33000000)
                            : const Color(0x0C0284C7),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: glass.isDark
                                  ? const Color(0xFF0284C7)
                                  : const Color(0xFF0284C7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.cloud_sync_rounded,
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.guestSignInPromoTitle,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: glass.titleText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.guestSignInPromoBody,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: glass.subtitleText,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: glass.accentColor,
                            foregroundColor:
                                glass.isDark ? Colors.black : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.login_rounded, size: 18),
                          label: Text(
                            l10n.guestSignInAction,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          onPressed: onOpenAccount,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // 2. Card 1: View Profile & Notifications
              Container(
                decoration: BoxDecoration(
                  color: glass.cardBackground,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: glass.cardBorder, width: 1.2),
                  boxShadow: glass.cardShadow,
                ),
                child: Column(
                  children: [
                    _AccountTile(
                      icon: Icons.person_outline_rounded,
                      title: l10n.viewProfile,
                      subtitle: l10n.viewProfileSubtitle,
                      onTap: onOpenAccount,
                    ),
                    Divider(
                      height: 1,
                      indent: 72,
                      endIndent: 16,
                      color: glass.divider,
                    ),
                    _AccountTile(
                      icon: Icons.notifications_none_rounded,
                      title: l10n.notifications,
                      subtitle: l10n.notificationsSubtitle,
                      onTap: () => _showNotificationsModal(
                          context, l10n, settingsController),
                    ),
                  ],
                ),
              ),

              // 3. Section Heading: ACCOUNT SETTINGS
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 24, 6, 12),
                child: Text(
                  l10n.accountSettingsHeader,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: glass.isDark
                        ? const Color(0xFF38BDF8)
                        : const Color(0xFF005A71),
                    letterSpacing: 0.8,
                  ),
                ),
              ),

              // 4. Card 2: Account Settings
              Container(
                decoration: BoxDecoration(
                  color: glass.cardBackground,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: glass.cardBorder, width: 1.2),
                  boxShadow: glass.cardShadow,
                ),
                child: Column(
                  children: [
                    _AccountTile(
                      icon: Icons.shield_outlined,
                      title: l10n.privacyAndSecurity,
                      subtitle: l10n.privacySubtitle,
                      onTap: () =>
                          _showPrivacyModal(context, l10n, authController),
                    ),
                    Divider(
                      height: 1,
                      indent: 72,
                      endIndent: 16,
                      color: glass.divider,
                    ),
                    _AccountTile(
                      icon: Icons.language_rounded,
                      title: l10n.appLanguage,
                      subtitle: l10n.appLanguageSubtitle,
                      badgeText: selectedLanguage == 'am'
                          ? l10n.amharicLanguage
                          : l10n.englishLanguage,
                      onTap: () =>
                          _showLanguageModal(context, l10n, localeController),
                    ),
                    Divider(
                      height: 1,
                      indent: 72,
                      endIndent: 16,
                      color: glass.divider,
                    ),
                    _AccountTile(
                      icon: Icons.palette_outlined,
                      title: l10n.appTheme,
                      subtitle: l10n.appThemeSubtitle,
                      badgeText: themeBadge,
                      onTap: () =>
                          _showThemeModal(context, l10n, settingsController),
                    ),
                    Divider(
                      height: 1,
                      indent: 72,
                      endIndent: 16,
                      color: glass.divider,
                    ),
                    _AccountTile(
                      icon: Icons.text_fields_rounded,
                      title: l10n.textSize,
                      subtitle: l10n.textSizeSubtitle,
                      badgeText: textSizeBadge,
                      onTap: () =>
                          _showTextSizeModal(context, l10n, settingsController),
                    ),
                    Divider(
                      height: 1,
                      indent: 72,
                      endIndent: 16,
                      color: glass.divider,
                    ),
                    _AccountTile(
                      icon: Icons.help_outline_rounded,
                      title: l10n.supportCenter,
                      subtitle: l10n.supportCenterSubtitle,
                      onTap: () => _showSupportModal(context, l10n),
                    ),
                  ],
                ),
              ),

              // 5. Version Info
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    l10n.appVersion,
                    style: TextStyle(
                      color: glass.subtitleText,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badgeText,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? badgeText;

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: glass.isDark
                ? const Color(0xFF0F172A)
                : const Color(0xFF0284C7),
            borderRadius: BorderRadius.circular(12),
            border: glass.isDark
                ? Border.all(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.35),
                  )
                : null,
          ),
          child: Icon(
            icon,
            color: glass.isDark ? const Color(0xFF38BDF8) : Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: glass.titleText,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: glass.subtitleText,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badgeText != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: glass.badgeBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: glass.isDark
                      ? Border.all(
                          color:
                              const Color(0xFF38BDF8).withValues(alpha: 0.25),
                        )
                      : null,
                ),
                child: Text(
                  badgeText!,
                  style: TextStyle(
                    color: glass.badgeText,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: glass.badgeBackground,
                shape: BoxShape.circle,
                border: glass.isDark
                    ? Border.all(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.25),
                      )
                    : null,
              ),
              child: Icon(
                Icons.chevron_right_rounded,
                color: glass.badgeText,
                size: 20,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
