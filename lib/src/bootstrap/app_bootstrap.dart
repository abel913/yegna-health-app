import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../account/app_settings_controller.dart';
import '../auth/auth_controller.dart';
import '../auth/backend_auth_repository.dart';
import '../auth/secure_auth_storage.dart';
import '../chatbot/chatbot_repository.dart';
import '../chatbot/composite_chatbot_repository.dart';
import '../chatbot/supabase_gemini_chatbot_repository.dart';
import '../discovery/facility_repository.dart';
import '../discovery/mentor_repository.dart';
import '../discovery/sync_facility_repository.dart';
import '../discovery/sync_mentor_repository.dart';
import '../learning/assessment_repository.dart';
import '../learning/education_repository.dart';
import '../learning/progress_repository.dart';
import '../learning/sync_education_repository.dart';
import '../locale_controller.dart';
import '../notifications/notification_controller.dart';
import '../sync/api_client.dart';
import '../sync/offline_sync_store.dart';
import '../sync/sync_manager.dart';

const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabasePublishableKey =
    String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

/// Holds all initialized core services and controllers for the application.
class AppBootstrapResult {
  const AppBootstrapResult({
    required this.localeController,
    required this.authController,
    required this.settingsController,
    required this.notificationController,
    required this.chatbotRepository,
    required this.educationRepository,
    required this.assessmentRepository,
    required this.progressStore,
    required this.facilityRepository,
    required this.mentorRepository,
    required this.syncManager,
  });

  final LocaleController localeController;
  final AuthController authController;
  final AppSettingsController settingsController;
  final InAppNotificationController notificationController;
  final ChatbotRepository chatbotRepository;
  final EducationRepository educationRepository;
  final AssessmentRepository assessmentRepository;
  final LearningProgressStore progressStore;
  final FacilityRepository facilityRepository;
  final MentorRepository mentorRepository;
  final SyncManager syncManager;
}

/// Initializes offline storage, backend repositories, and state controllers.
Future<AppBootstrapResult> bootstrapApp() async {
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

  final supabaseClient = await initializeSupabase();
  final authRepository = BackendAuthRepository(
    apiClient: apiClient,
    preferences: preferences,
  );
  unawaited(authRepository.init());
  final authController = AuthController(authRepository);

  final chatbotRepository = CompositeChatbotRepository(
    remoteRepository: supabaseClient == null
        ? null
        : SupabaseGeminiChatbotRepository(supabaseClient),
  );

  final educationRepository =
      SyncEducationRepository(store: syncStore, apiClient: apiClient);
  final assessmentRepository =
      SyncAssessmentRepository(store: syncStore, apiClient: apiClient);

  return AppBootstrapResult(
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
  );
}

/// Initializes Supabase client safely if environment keys are supplied.
Future<SupabaseClient?> initializeSupabase() async {
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
    return null;
  }
}
