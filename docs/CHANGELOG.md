# Changelog

## 2026-10-29 — Phase 2 emulator rendering and interaction diagnosis

- Identified graphics mode as the environment cause: API 37 AVD in `auto` mode rendered black and ignored ADB taps; the same AVD launched with `-gpu host` rendered Home on Intel Iris Xe and accepted taps.
- Manually verified Home Account → Sign in, Create account, Services bottom navigation and Settings → Account → Sign in in the emulator. The workaround was a launch override; persisted AVD settings remain unchanged.
- No app source, Android project configuration, or credentials were changed. Live Supabase account/email verification remains outstanding.

## 2026-10-29 — Phase 2 account entry and interaction coverage

- Added a localized Account/Manage account button to Home so sign-in, registration, and profile access are visible from initial launch; Settings account access remains available.
- Added widget coverage for Home account navigation, guest navigation, sign-in validation, and registration/recovery mode changes.
- `flutter gen-l10n`, `dart format lib test`, `flutter analyze` and `flutter test` passed; all 19 tests passed, including a verified-user profile edit/sign-out widget path. Debug APK build with the local Supabase define file passed.
- The emulator launched the app and exposed the updated Home semantics tree, but screenshots remained black and shell-injected taps did not navigate. Manual UI interaction and provider-backed authentication remain unverified; Phase 2 is still in progress.

## 2026-10-29 — Phase 2 Supabase Auth implementation

- Added Supabase Auth email/password registration and sign-in, provider email-confirmation pending state, password recovery/reset deep-link flow, profile display-name editing, guest access and sign-out.
- Added English and Amharic labels, validation, loading, success and safe error states for auth/profile screens.
- Added a provider-independent repository/controller boundary and deterministic unit/widget tests.
- Pinned `supabase_flutter` 2.15.4 and `flutter_secure_storage` 9.2.4. Session and PKCE material use secure platform storage; language preference remains in SharedPreferences.
- Configured `com.yegnahealth.amharic://auth-callback` in Android manifest and the signed-in Supabase project's redirect allowlist. Confirm email is enabled.
- Added a Git-ignored local Supabase config and a safe placeholder example. No service-role secret, database table or migration was added.
- `flutter gen-l10n`, `dart format lib test`, `flutter analyze` (clean) and `flutter test` (17 passing, including an Amharic auth-screen widget test) were run successfully in this workspace.
- Live account/email delivery testing is outstanding; Phase 2 is not declared complete. No Phase 3 work was started.

## 2026-10-29 — Phase 1 foundation verified

- Established Flutter Material 3 shell, English/Amharic ARB localization, and persisted language selection.
- Added Android platform scaffolding with `flutter create --platforms=android .`; Gradle files use Kotlin DSL.
- Project owner verified `flutter pub get`, localization generation, formatting, clean analysis, all 4 then-existing tests, debug APK build, emulator launch/page behavior, English/Amharic switching and preference persistence after restart.
- Physical-device coverage, release build/signing, deployment and security audit remain unperformed.
