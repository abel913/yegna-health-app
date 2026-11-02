import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'l10n/app_localizations.dart';
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
import 'src/locale_controller.dart';
import 'src/learning/assessment_repository.dart';
import 'src/learning/education_repository.dart';
import 'src/learning/learning_cache.dart';
import 'src/learning/learning_progress_controller.dart';
import 'src/learning/progress_repository.dart';
import 'src/learning/supabase_education_repository.dart';

const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabasePublishableKey =
    String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final localeController = LocaleController(preferences);
  await localeController.load();

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
  runApp(YegnaHealthApp(
    localeController: localeController,
    authController: authController,
    chatbotRepository: chatbotRepository,
    educationRepository: supabaseClient == null
        ? const UnconfiguredEducationRepository()
        : SupabaseEducationRepository(supabaseClient, LearningCache()),
    assessmentRepository: supabaseClient == null
        ? const UnconfiguredAssessmentRepository()
        : SupabaseAssessmentRepository(supabaseClient, LearningCache()),
    progressStore: ProgressRepository(supabaseClient),
    facilityRepository: const LocalVerifiedFacilityRepository(),
    mentorRepository: const LocalVerifiedMentorRepository(),
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
    this.educationRepository,
    this.assessmentRepository,
    this.progressStore,
    this.facilityRepository,
    this.mentorRepository,
    this.chatbotRepository,
    super.key,
  });

  final LocaleController localeController;
  final AuthController authController;
  final EducationRepository? educationRepository;
  final AssessmentRepository? assessmentRepository;
  final LearningProgressStore? progressStore;
  final FacilityRepository? facilityRepository;
  final MentorRepository? mentorRepository;
  final ChatbotRepository? chatbotRepository;

  @override
  State<YegnaHealthApp> createState() => _YegnaHealthAppState();
}

class _YegnaHealthAppState extends State<YegnaHealthApp> {
  late final LearningProgressController _progressController;
  late final EducationRepository _educationRepository;
  late final AssessmentRepository _assessmentRepository;
  late final FacilityRepository _facilityRepository;
  late final MentorRepository _mentorRepository;
  late final ChatbotRepository _chatbotRepository;

  @override
  void initState() {
    super.initState();
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
          theme: ThemeData(
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
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 14, vertical: 13),
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
              labelTextStyle:
                  WidgetStateProperty.resolveWith((states) => TextStyle(
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
          ),
          home: AppShell(
            localeController: widget.localeController,
            authController: widget.authController,
            educationRepository: _educationRepository,
            assessmentRepository: _assessmentRepository,
            progressController: _progressController,
            facilityRepository: _facilityRepository,
            mentorRepository: _mentorRepository,
            chatbotRepository: _chatbotRepository,
          ),
        ),
      );
}
