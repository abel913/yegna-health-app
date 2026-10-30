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
import 'src/locale_controller.dart';

const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabasePublishableKey =
    String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final localeController = LocaleController(preferences);
  await localeController.load();

  final authRepository = await _createAuthRepository();
  final authController = AuthController(authRepository);
  runApp(YegnaHealthApp(
    localeController: localeController,
    authController: authController,
  ));
}

Future<AuthRepository> _createAuthRepository() async {
  if (_supabaseUrl.isEmpty || _supabasePublishableKey.isEmpty) {
    return const UnconfiguredAuthRepository();
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
    return SupabaseAuthRepository(Supabase.instance.client);
  } catch (_) {
    // Leave public pages usable while clearly keeping account services unavailable.
    return const UnconfiguredAuthRepository();
  }
}

class YegnaHealthApp extends StatelessWidget {
  const YegnaHealthApp({
    required this.localeController,
    required this.authController,
    super.key,
  });

  final LocaleController localeController;
  final AuthController authController;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Listenable.merge([localeController, authController]),
        builder: (context, _) => MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          locale: localeController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF087E70)),
            useMaterial3: true,
          ),
          home: AppShell(
            localeController: localeController,
            authController: authController,
          ),
        ),
      );
}
