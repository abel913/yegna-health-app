import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'l10n/app_localizations.dart';
import 'src/account/app_settings_controller.dart';
import 'src/app.dart';
import 'src/auth/auth_controller.dart';
import 'src/auth/auth_repository.dart';
import 'src/auth/secure_auth_storage.dart';
import 'src/auth/supabase_auth_repository.dart';
import 'src/chatbot/chatbot_repository.dart';
import 'src/chatbot/composite_chatbot_repository.dart';
import 'src/chatbot/supabase_gemini_chatbot_repository.dart';
import 'src/discovery/facility_repository.dart';
import 'src/discovery/mentor_repository.dart';
import 'src/discovery/sync_facility_repository.dart';
import 'src/discovery/sync_mentor_repository.dart';
import 'src/locale_controller.dart';
import 'src/notifications/notification_controller.dart';
import 'src/learning/assessment_repository.dart';
import 'src/learning/education_repository.dart';
import 'src/learning/learning_cache.dart';
import 'src/learning/learning_progress_controller.dart';
import 'src/learning/progress_repository.dart';
import 'src/learning/supabase_education_repository.dart';
import 'src/learning/sync_education_repository.dart';
import 'src/sync/api_client.dart';
import 'src/sync/offline_sync_store.dart';
import 'src/sync/sync_manager.dart';

const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabasePublishableKey =
    String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final localeController = LocaleController(preferences);
  await localeController.load();
  final settingsController = AppSettingsController(preferences);
  await settingsController.load();
  final notificationController = InAppNotificationController(preferences);

  final apiClient = ApiClient();
  final syncStore = OfflineSyncStore(preferences: preferences);
  final syncManager = SyncManager(apiClient: apiClient, store: syncStore);
  unawaited(syncManager.init());
  unawaited(syncManager.syncAll());

  final facilityRepository = SyncFacilityRepository(
    store: syncStore,
    apiClient: apiClient,
    fallback: const LocalVerifiedFacilityRepository(),
  );
  final mentorRepository = SyncMentorRepository(
    store: syncStore,
    apiClient: apiClient,
    fallback: const LocalVerifiedMentorRepository(),
  );

  final supabaseClient = await _initializeSupabase();
  final authRepository = supabaseClient == null
      ? const UnconfiguredAuthRepository()
      : SupabaseAuthRepository(supabaseClient);
  final authController = AuthController(authRepository);
  final chatbotRepository = CompositeChatbotRepository(
    remoteRepository: supabaseClient == null
        ? null
        : SupabaseGeminiChatbotRepository(supabaseClient),
  );

  final educationRepository = supabaseClient == null
      ? SyncEducationRepository(store: syncStore, apiClient: apiClient)
      : SupabaseEducationRepository(supabaseClient, LearningCache());
  final assessmentRepository = supabaseClient == null
      ? SyncAssessmentRepository(store: syncStore, apiClient: apiClient)
      : SupabaseAssessmentRepository(supabaseClient, LearningCache());

  runApp(YegnaHealthApp(
    localeController: localeController,
    authController: authController,
    settingsController: settingsController,
    notificationController: notificationController,
    chatbotRepository: chatbotRepository,
    educationRepository: educationRepository,
    assessmentRepository: assessmentRepository,
    progressStore: ProgressRepository(supabaseClient),
    facilityRepository: facilityRepository,
    mentorRepository: mentorRepository,
    syncManager: syncManager,
  ));
}

Future<SupabaseClient?> _initializeSupabase() async {
  if (_supabaseUrl.isEmpty || _supabasePublishableKey.isEmpty) {
    return null;
  }
  try {
    await Supabase.initialize(
      url: _supabaseUrl,
      publishableKey: _supabasePublishableKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        localStorage: SecureAuthStorage(),
        pkceAsyncStorage: SecureAuthStorage(),
      ),
    );
    return Supabase.instance.client;
  } catch (_) {
    // Leave public pages usable while clearly keeping account services unavailable.
    return null;
  }
}

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

  ThemeData _buildLightTheme() {
    return ThemeData(
      fontFamily: 'PlusJakartaSans',
      fontFamilyFallback: const ['NotoSansEthiopic'],
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF005A71),
        surface: const Color(0xFFFAF8FF),
      ).copyWith(
        primary: const Color(0xFF005A71),
        secondary: const Color(0xFF006398),
        tertiary: const Color(0xFF005F40),
        surfaceContainerLow: const Color(0xFFF2F3FF),
        surfaceContainer: const Color(0xFFEAEDFF),
        outlineVariant: const Color(0xFFDAE2E6),
      ),
      scaffoldBackgroundColor: const Color(0xFFFAF8FF),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFAF8FF),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0.5,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          side: BorderSide(color: Color(0x1A005A71)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Color(0x1F005A71)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Color(0x1F005A71)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Color(0xFF005A71), width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: const WidgetStatePropertyAll(0),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: const WidgetStatePropertyAll(Color(0xFFF2F3FF)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        constraints: const BoxConstraints(minHeight: 52),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 76,
        backgroundColor: const Color(0xFFF2F3FF),
        indicatorColor: const Color(0xFFD3F1FF),
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
              fontSize: 12,
              height: 1.25,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: states.contains(WidgetState.selected)
                  ? const Color(0xFF005A71)
                  : const Color(0xFF59666B),
            )),
        iconTheme: const WidgetStatePropertyAll(
          IconThemeData(size: 22),
        ),
      ),
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: 32,
          height: 1.28,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        headlineMedium: TextStyle(
          fontSize: 26,
          height: 1.3,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        headlineSmall: TextStyle(
          fontSize: 23,
          height: 1.35,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          fontSize: 19,
          height: 1.35,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          height: 1.4,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(fontSize: 16, height: 1.55),
        bodyMedium: TextStyle(fontSize: 14, height: 1.55),
        bodySmall: TextStyle(fontSize: 12, height: 1.5),
        labelLarge: TextStyle(
          fontSize: 14,
          height: 1.4,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          height: 1.4,
          fontWeight: FontWeight.w600,
        ),
      ),
      useMaterial3: true,
    );
  }

  ThemeData _buildDarkTheme() {
    const darkBg = Color(0xFF0B132B);
    const darkSurface = Color(0xFF1C2541);
    const darkContainer = Color(0xFF1E293B);
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'PlusJakartaSans',
      fontFamilyFallback: const ['NotoSansEthiopic'],
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0284C7),
        brightness: Brightness.dark,
        surface: darkSurface,
      ).copyWith(
        primary: const Color(0xFF38BDF8),
        secondary: const Color(0xFF7DD3FC),
        tertiary: const Color(0xFF34D399),
        surfaceContainerLow: const Color(0xFF0F172A),
        surfaceContainer: darkContainer,
        outlineVariant: const Color(0xFF334155),
      ),
      scaffoldBackgroundColor: darkBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,
        iconTheme: IconThemeData(color: Color(0xFFF8FAFC)),
        titleTextStyle: TextStyle(
          color: Color(0xFFF8FAFC),
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: const CardThemeData(
        color: darkContainer,
        elevation: 0.5,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          side: BorderSide(color: Color(0x3338BDF8)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: darkContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Color(0x3338BDF8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Color(0x3338BDF8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Color(0xFF38BDF8), width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: const WidgetStatePropertyAll(0),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: const WidgetStatePropertyAll(Color(0xFF1E293B)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        constraints: const BoxConstraints(minHeight: 52),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 76,
        backgroundColor: const Color(0xFF0F172A),
        indicatorColor: const Color(0xFF0369A1),
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
              fontSize: 12,
              height: 1.25,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: states.contains(WidgetState.selected)
                  ? const Color(0xFF38BDF8)
                  : const Color(0xFF94A3B8),
            )),
        iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
              size: 22,
              color: states.contains(WidgetState.selected)
                  ? Colors.white
                  : const Color(0xFF94A3B8),
            )),
      ),
      useMaterial3: true,
    );
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
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
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
