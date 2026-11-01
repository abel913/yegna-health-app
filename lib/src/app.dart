import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'auth/auth_controller.dart';
import 'auth/auth_pages.dart';
import 'discovery/directory_pages.dart';
import 'home/home_page.dart';
import 'locale_controller.dart';
import 'learning/assessment_repository.dart';
import 'learning/education_repository.dart';
import 'learning/learn_pages.dart';
import 'learning/learning_progress_controller.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    required this.localeController,
    required this.authController,
    required this.educationRepository,
    required this.assessmentRepository,
    required this.progressController,
    super.key,
  });

  final LocaleController localeController;
  final AuthController authController;
  final EducationRepository educationRepository;
  final AssessmentRepository assessmentRepository;
  final LearningProgressController progressController;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  int _previousIndex = 0;
  bool _accountRouteOpen = false;
  bool _recoveryRouteOpen = false;

  @override
  void initState() {
    super.initState();
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
              initialMode: AuthPageMode.newPassword,
            ),
          ))
          .whenComplete(() => _recoveryRouteOpen = false);
    });
  }

  void _openAccount() {
    _accountRouteOpen = true;
    final page = widget.authController.isAuthenticated
        ? ProfilePage(controller: widget.authController)
        : AuthPage(controller: widget.authController);
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      HomePage(
        educationRepository: widget.educationRepository,
        locale: Localizations.localeOf(context),
        onOpenLearning: () => _onDestinationSelected(3),
        onOpenMentors: () => _onDestinationSelected(2),
        onOpenFacilities: () => _onDestinationSelected(1),
        onOpenAccount: _openAccount,
        onOpenArticle: _openArticle,
      ),
      const FacilitiesPage(),
      const MentorsPage(),
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
        onOpenAccount: _openAccount,
        onOpenLearningProgress: _openLearningProgress,
      ),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFEAF5FD),
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
                color: Colors.white.withValues(alpha: 0.55),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.85),
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          l10n.appTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF08264A),
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          const _NotificationButton(),
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
                            color: Colors.white.withValues(alpha: 0.88),
                            borderColor: Colors.white.withValues(alpha: 0.95),
                            cradleBorderColor: const Color(0xFFBAE6FD),
                            shadowColor: const Color(0x180284C7),
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
                                return const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0284C7),
                                );
                              }
                              return const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
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
                              return const IconThemeData(
                                color: Color(0xFF64748B),
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
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF0284C7),
                                  Color(0xFF0369A1),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.white,
                                width: 2.2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x450284C7),
                                  blurRadius: 14,
                                  spreadRadius: 1,
                                  offset: Offset(0, 4),
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
  const _NotificationButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFBAE6FD).withValues(alpha: 0.9),
                width: 1.2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x100284C7),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                size: 20,
                color: Color(0xFF005A71),
              ),
              padding: EdgeInsets.zero,
              tooltip: 'Notifications',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('2 updates available for learning modules'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
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
              child: const Text(
                '2',
                style: TextStyle(
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
  }
}

class _LanguageDropdown extends StatelessWidget {
  const _LanguageDropdown({required this.localeController});
  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    final selected = localeController.locale.languageCode;
    return Center(
      child: PopupMenuButton<String>(
        key: const Key('language_dropdown_button'),
        tooltip: 'Change language',
        position: PopupMenuPosition.under,
        offset: const Offset(0, 8),
        elevation: 12,
        shadowColor: const Color(0x350284C7),
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color(0xFFBAE6FD),
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
                color: Colors.white.withValues(alpha: 0.75),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.90),
                    const Color(0xFFEDF8FE).withValues(alpha: 0.55),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.95),
                  width: 1.3,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x180284C7),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0F2FE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.translate_rounded,
                      size: 13,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    selected == 'am' ? '🇪🇹 አማ' : '🇺🇸 EN',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0369A1),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: Color(0xFF0284C7),
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
    required this.onOpenAccount,
    required this.onOpenLearningProgress,
  });

  final LocaleController localeController;
  final AuthController authController;
  final LearningProgressController progressController;
  final AssessmentRepository assessmentRepository;
  final VoidCallback onOpenAccount;
  final VoidCallback onOpenLearningProgress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedLanguage = localeController.locale.languageCode;
    final user = authController.user;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      children: [
        Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFDBF3F8),
              child: Icon(
                authController.isAuthenticated
                    ? Icons.account_circle_outlined
                    : Icons.person_outline,
                color: const Color(0xFF005A71),
              ),
            ),
            title: Text(authController.isAuthenticated
                ? l10n.profile
                : l10n.accountTitle),
            subtitle: Text(authController.isAuthenticated
                ? l10n.accountSignedInAs(user?.email ?? '')
                : l10n.guestAccessDescription),
            trailing: const Icon(Icons.chevron_right),
            onTap: onOpenAccount,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: ListTile(
            leading: const Icon(Icons.school_outlined),
            title: Text(l10n.progressHeading),
            subtitle: Text(l10n.learningIntroduction),
            trailing: const Icon(Icons.chevron_right),
            onTap: onOpenLearningProgress,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.languageTitle,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(l10n.languageDescription),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedLanguage,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                        value: 'en', child: Text(l10n.englishLanguage)),
                    DropdownMenuItem(
                        value: 'am', child: Text(l10n.amharicLanguage)),
                  ],
                  onChanged: (value) {
                    if (value != null) localeController.setLanguage(value);
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        ListenableBuilder(
          listenable: progressController,
          builder: (context, _) => Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.learningProgressTitle,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (progressController.isLoading)
                    const LinearProgressIndicator()
                  else ...[
                    Text(l10n.completedArticlesCount(
                        progressController.progress?.articles.length ?? 0)),
                    const SizedBox(height: 4),
                    Text(l10n.assessmentAttemptsCount(
                        progressController.progress?.attempts.length ?? 0)),
                  ],
                  const SizedBox(height: 8),
                  Text(l10n.localProgressLabel,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
