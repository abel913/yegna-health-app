import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'account/app_settings_controller.dart';
import 'account/widgets/account_notifications_modal.dart';
import 'auth/auth_controller.dart';
import 'chatbot/chatbot_repository.dart';
import 'chatbot/yegna_chatbot_fab.dart';
import 'clubs/club_controller.dart';
import 'clubs/club_repository.dart';
import 'clubs/sync_club_repository.dart';
import 'discovery/facility_repository.dart';
import 'discovery/mentor_repository.dart';
import 'learning/assessment_repository.dart';
import 'learning/education_repository.dart';
import 'learning/learning_progress_controller.dart';
import 'learning/screens/learning_progress_page.dart';
import 'locale_controller.dart';
import 'navigation/app_route_navigator.dart';
import 'navigation/app_shell_tab_builder.dart';
import 'navigation/widgets/app_top_bar.dart';
import 'navigation/widgets/scooped_bottom_bar.dart';
import 'notifications/notification_controller.dart';
import 'sync/api_client.dart';
import 'sync/offline_sync_store.dart';
import 'sync/sync_manager.dart';
import 'theme/app_glass_theme.dart';

/// Root Application Shell coordinating bottom navigation, top bar, and tab pages.
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
    this.clubRepository,
    this.clubController,
    this.syncManager,
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
  final ClubRepository? clubRepository;
  final ClubController? clubController;
  final SyncManager? syncManager;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final InAppNotificationController _notificationController;
  late final ClubRepository _clubRepository;
  late final ClubController _clubController;
  int _selectedIndex = 0;
  bool _accountRouteOpen = false;
  bool _recoveryRouteOpen = false;

  @override
  void initState() {
    super.initState();
    _clubRepository = widget.clubRepository ??
        SyncClubRepository(
          store: OfflineSyncStore(),
          localRepository: LocalClubRepository(),
          apiClient: ApiClient(),
        );
    _clubController =
        widget.clubController ?? ClubController(repository: _clubRepository);
    _notificationController =
        widget.notificationController ?? InAppNotificationController();

    if (!_notificationController.isInitialized) {
      _notificationController.load(
        isAmharic: widget.localeController.locale.languageCode == 'am',
        healthTipsEnabled: widget.settingsController?.healthTipsEnabled ?? true,
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
    if (index != _selectedIndex) setState(() => _selectedIndex = index);
  }

  void _handleAuthChange() {
    if (!mounted) return;
    if (!widget.authController.isAuthenticated && _selectedIndex == 4) {
      setState(() => _selectedIndex = 0);
    }
    if (!widget.authController.recoveryRequested ||
        _accountRouteOpen ||
        _recoveryRouteOpen) {
      return;
    }
    _recoveryRouteOpen = true;
    AppRouteNavigator.handleAuthRecovery(
      context: context,
      authController: widget.authController,
      notificationController: _notificationController,
      onComplete: () => _recoveryRouteOpen = false,
    );
  }

  void _openAccount() {
    _accountRouteOpen = true;
    AppRouteNavigator.openAccount(
      context: context,
      authController: widget.authController,
      notificationController: _notificationController,
    ).whenComplete(() {
      _accountRouteOpen = false;
      if (mounted && widget.authController.isAuthenticated) {
        setState(() => _selectedIndex = 4);
      }
    });
  }

  void _openClubs() => AppRouteNavigator.openClubs(
        context: context,
        clubController: _clubController,
        authController: widget.authController,
        notificationController: _notificationController,
      );

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
    final pages = AppShellTabBuilder.buildPages(
      context: context,
      widget: widget,
      onSelectTab: _onDestinationSelected,
      onOpenAccount: _openAccount,
      onOpenClubs: _openClubs,
    );

    return Scaffold(
      backgroundColor: context.glassTheme.scaffoldBackground,
      appBar: AppTopBar(
        notificationController: _notificationController,
        localeController: widget.localeController,
        selectedIndex: _selectedIndex,
        isAuthenticated: widget.authController.isAuthenticated,
        onOpenNotificationSettings: () => showAccountNotificationsModal(
          context,
          AppLocalizations.of(context),
          widget.settingsController ?? AppSettingsController(),
        ),
        onNotificationNavigate: (route) {
          if (route == 'learn') setState(() => _selectedIndex = 3);
        },
        onOpenLearningProgress: _openLearningProgress,
        onSignOut: () => widget.authController.signOut(),
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      floatingActionButton: (_selectedIndex == 0 || _selectedIndex == 3)
          ? YegnaChatbotFab(
              chatbotRepository: widget.chatbotRepository,
              userName: widget.authController.user?.displayName,
            )
          : null,
      bottomNavigationBar: ScoopedBottomBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }
}
