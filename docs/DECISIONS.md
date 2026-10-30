# Technical decisions

## 2026-10-29 — Standard Flutter localization

Use Flutter ARB resources and generated `AppLocalizations`. This is the standard Flutter approach, supports locale delegates and generated accessors, and keeps UI copy out of widgets. No alternative was needed.

## 2026-10-29 — Phase 2 provider approved: Supabase Auth

The owner requested Supabase Auth implementation and signed in to the `yegna-health-amharic` project. Project `oflkhtjskpsedsuczfkj` is active in `eu-north-1`. Dashboard settings showed Email enabled and Confirm email enabled. The native redirect `com.yegnahealth.amharic://auth-callback` was added to the project's Auth redirect allowlist.

Approved Phase 2 method: email/password with provider email confirmation and password recovery. Phone OTP and anonymous Supabase identities are not implemented. Guest users may browse public app pages. Account/profile actions require an Auth session with confirmed email. A single display name is stored in Auth `user_metadata` for display/editing only; user metadata is never trusted for authorization. No public database tables or migrations were needed for this scope.

The app uses a publishable client key only. The actual machine-local config file is Git-ignored; `config/supabase.example.json` contains placeholders. Never use or commit a service-role/secret key.

## Dependency pins

Use exact package versions `supabase_flutter: 2.15.4` and `flutter_secure_storage: 9.2.4`. The Supabase adapter is isolated behind `AuthRepository`; `SecureAuthStorage` stores both the persisted session and PKCE verifier material using platform secure storage. SharedPreferences remains for the locale preference only.

## 2026-10-29 — Locale ownership

Use a small `ChangeNotifier` controller to load and persist the two supported language codes. This keeps the foundation simple and replaceable if later requirements justify a broader app state layer.

## Deferred decisions and checks

Current SMTP configuration/live email delivery and real-account end-to-end testing are unverified. Supabase's built-in hosted sender has documented team-only recipient and rate restrictions. Privacy/jurisdiction review, release signing, security audit, maps/content providers, offline policy, analytics, and notification provider remain open. Do not treat test-mode/unit coverage as verification of live account delivery or production readiness. No secrets or service credentials belong in the repository.
