# Architecture

## Current structure

```text
lib/
  main.dart                 startup, dependencies, MaterialApp
  l10n/                     source ARB translations
  src/
    app.dart                navigation shell, Home/Settings auth-profile entry
    locale_controller.dart  supported locale preference
    auth/                   auth contract, validation, controller, UI, Supabase adapter, secure storage
test/                       controller and localization tests
```

Generated `lib/l10n/app_localizations.dart` belongs to Flutter tooling and is not checked in; `flutter gen-l10n` creates it from ARB resources.

## Data flow

At startup, `main` initializes Flutter, reads `preferred_locale` from SharedPreferences, and initializes Supabase only when URL and publishable key are supplied via `--dart-define-from-file`. If config is absent or invalid, public pages remain usable and account actions clearly report auth as unavailable. The locale controller and generated ARB delegates resolve English or Amharic. Health, assessment, and other remote-data features are not implemented.

## Dependencies

- Flutter SDK and `flutter_localizations`: Material 3, platform widgets, locale delegates.
- `intl`: Flutter localization support.
- `shared_preferences`: non-sensitive UI language preference only; not for credentials or health records.
- `supabase_flutter` (pinned `2.15.4`): approved auth provider SDK, PKCE email/password flows, confirmation/recovery deep links, token refresh and auth state.
- `flutter_secure_storage` (pinned `9.2.4`): platform secure storage for Supabase session and PKCE verifier values.
- `flutter_lints`: static-analysis baseline.
- Flutter SDK test framework: unit/widget test infrastructure.

## Future boundaries

Keep widgets presentation-focused. Add feature/domain/data layers only as requirements justify them. Isolate remote APIs behind typed repository interfaces, validate responses, apply timeouts and recoverable errors, and keep secrets server-side. Decide authentication, backend, database, maps, health-content provenance, and offline storage after requirements, legal/privacy constraints, and operating context are assessed. Do not store identifiable health information in plain preferences.

## Phase 2 authentication boundary

`AuthController` owns UI state and validation. `AuthRepository` is the provider-independent contract; `SupabaseAuthRepository` calls Supabase Auth for registration, password sign-in, recovery, password update, display-name update and sign-out. Provider errors map to app-owned issue codes before localization. Authentication requires a Supabase-issued session and confirmed email. Supabase uses PKCE and the native callback `com.yegnahealth.amharic://auth-callback`.

`SecureAuthStorage` uses `flutter_secure_storage` for session and PKCE material. SharedPreferences remains limited to language selection. A single display name is held in Auth `user_metadata` for display/editing only; it is user-editable and is **not** used for authorization/RLS. No database tables or SQL migrations were created. A separate profile table would need a justified schema and owner-reviewed RLS design.

The account route is available from a visible Home button and the Settings account tile, separate from public tabs; profile data is shown only for a provider-confirmed session. Expired/removed sessions show a sign-in prompt. Email confirmation must remain enabled. The provider redirect allowlist and Android deep-link filter must stay aligned. The app consumes only a publishable client key; never include service-role/secret keys.

Live email confirmation/recovery delivery has not been verified. Configure suitable SMTP for arbitrary recipient addresses before broader testing or release. See `KNOWN_ISSUES.md`.
