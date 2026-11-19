import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'src/account/app_settings_controller.dart';
import 'src/app.dart';
import 'src/auth/auth_controller.dart';
import 'src/bootstrap/app_bootstrap.dart';
import 'src/chatbot/chatbot_repository.dart';
import 'src/chatbot/composite_chatbot_repository.dart';
import 'src/discovery/facility_repository.dart';
import 'src/discovery/mentor_repository.dart';
import 'src/learning/assessment_repository.dart';
import 'src/learning/education_repository.dart';
import 'src/learning/learning_progress_controller.dart';
import 'src/learning/progress_repository.dart';
import 'src/locale_controller.dart';
import 'src/notifications/notification_controller.dart';
import 'src/sync/sync_manager.dart';
import 'src/theme/app_dark_theme.dart';
import 'src/theme/app_light_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bootstrap = await bootstrapApp();

  runApp(YegnaHealthApp(
    localeController: bootstrap.localeController,
    authController: bootstrap.authController,
    settingsController: bootstrap.settingsController,
    notificationController: bootstrap.notificationController,
    chatbotRepository: bootstrap.chatbotRepository,
    educationRepository: bootstrap.educationRepository,
    assessmentRepository: bootstrap.assessmentRepository,
    progressStore: bootstrap.progressStore,
    facilityRepository: bootstrap.facilityRepository,
    mentorRepository: bootstrap.mentorRepository,
    syncManager: bootstrap.syncManager,
  ));
}

/// Root widget of the Yegna Health Application.
class YegnaHealthApp extends StatefulWidget {
  const YegnaHealthApp({
    required this.localeController,
    required this.authController,
    this.settingsController,
    this.notificationController,
    this.educationRepository,
    this.assessmentRepository,
    this.progressStore,
    this.facilityRepository,
    this.mentorRepository,
    this.chatbotRepository,
    this.syncManager,
    super.key,
  });

  final LocaleController localeController;
  final AuthController authController;
  final AppSettingsController? settingsController;
  final InAppNotificationController? notificationController;
  final EducationRepository? educationRepository;
  final AssessmentRepository? assessmentRepository;
  final LearningProgressStore? progressStore;
  final FacilityRepository? facilityRepository;
  final MentorRepository? mentorRepository;
  final ChatbotRepository? chatbotRepository;
  final SyncManager? syncManager;

  @override
  State<YegnaHealthApp> createState() => _YegnaHealthAppState();
}

class _YegnaHealthAppState extends State<YegnaHealthApp> {
  late final AppSettingsController _settingsController;
  late final InAppNotificationController _notificationController;
  late final LearningProgressController _progressController;
  late final EducationRepository _educationRepository;
  late final AssessmentRepository _assessmentRepository;
  late final FacilityRepository _facilityRepository;
  late final MentorRepository _mentorRepository;
  late final ChatbotRepository _chatbotRepository;

  @override
  void initState() {
    super.initState();
    _settingsController = widget.settingsController ?? AppSettingsController();
    _notificationController =
        widget.notificationController ?? InAppNotificationController();
    _educationRepository =
        widget.educationRepository ?? const UnconfiguredEducationRepository();
    _assessmentRepository =
        widget.assessmentRepository ?? const UnconfiguredAssessmentRepository();
    _facilityRepository =
        widget.facilityRepository ?? const UnconfiguredFacilityRepository();
    _mentorRepository =
        widget.mentorRepository ?? const UnconfiguredMentorRepository();
    _chatbotRepository =
        widget.chatbotRepository ?? CompositeChatbotRepository();
    _progressController = LearningProgressController(
      repository: widget.progressStore ?? ProgressRepository(null),
      authController: widget.authController,
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Listenable.merge([
          widget.localeController,
          widget.authController,
          _progressController,
          _settingsController,
        ]),
        builder: (context, _) => MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          locale: widget.localeController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler:
                  TextScaler.linear(_settingsController.textScaleFactor),
            ),
            child: child!,
          ),
          themeMode: _settingsController.themeMode,
          theme: buildAppLightTheme(),
          darkTheme: buildAppDarkTheme(),
          home: AppShell(
            localeController: widget.localeController,
            authController: widget.authController,
            settingsController: _settingsController,
            notificationController: _notificationController,
            educationRepository: _educationRepository,
            assessmentRepository: _assessmentRepository,
            progressController: _progressController,
            facilityRepository: _facilityRepository,
            mentorRepository: _mentorRepository,
            chatbotRepository: _chatbotRepository,
            syncManager: widget.syncManager,
          ),
        ),
      );
}
