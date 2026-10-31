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

  void _handleAuthChange() {
    if (!mounted ||
        !widget.authController.recoveryRequested ||
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
        .whenComplete(() => _accountRouteOpen = false);
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

  String _title(AppLocalizations l10n) => switch (_selectedIndex) {
        0 => l10n.homeTab,
        1 => l10n.facilitiesTab,
        2 => l10n.mentorsTab,
        3 => l10n.learnTab,
        _ => l10n.accountTab,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      HomePage(
        educationRepository: widget.educationRepository,
        locale: Localizations.localeOf(context),
        onOpenLearning: () => setState(() => _selectedIndex = 3),
        onOpenMentors: () => setState(() => _selectedIndex = 2),
        onOpenFacilities: () => setState(() => _selectedIndex = 1),
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
        onOpenAccount: _openAccount,
        onOpenLearning: () => setState(() => _selectedIndex = 3),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.appTitle,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.7,
                    )),
            Text(_title(l10n),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
          ],
        ),
        actions: [
          _LanguageSegment(localeController: widget.localeController),
          IconButton(
            tooltip: l10n.accountTitle,
            onPressed: _openAccount,
            icon: const Icon(Icons.account_circle_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            for (var index = 0; index < pages.length; index++)
              TickerMode(enabled: index == _selectedIndex, child: pages[index]),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: l10n.homeTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.local_hospital_outlined),
            selectedIcon: const Icon(Icons.local_hospital_rounded),
            label: l10n.facilitiesTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_alt_outlined),
            selectedIcon: const Icon(Icons.people_alt_rounded),
            label: l10n.mentorsTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book_rounded),
            label: l10n.learnTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: l10n.accountTab,
          ),
        ],
      ),
    );
  }
}

class _LanguageSegment extends StatelessWidget {
  const _LanguageSegment({required this.localeController});
  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    final selected = localeController.locale.languageCode;
    return Center(
      child: SegmentedButton<String>(
        showSelectedIcon: false,
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          textStyle: WidgetStatePropertyAll(
            Theme.of(context).textTheme.labelSmall,
          ),
        ),
        segments: const [
          ButtonSegment(value: 'am', label: Text('አማ')),
          ButtonSegment(value: 'en', label: Text('EN')),
        ],
        selected: {selected},
        onSelectionChanged: (selection) {
          if (selection.isNotEmpty) {
            localeController.setLanguage(selection.first);
          }
        },
      ),
    );
  }
}

class _AccountPage extends StatelessWidget {
  const _AccountPage({
    required this.localeController,
    required this.authController,
    required this.progressController,
    required this.onOpenAccount,
    required this.onOpenLearning,
  });

  final LocaleController localeController;
  final AuthController authController;
  final LearningProgressController progressController;
  final VoidCallback onOpenAccount;
  final VoidCallback onOpenLearning;

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
            onTap: onOpenLearning,
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
