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

The owner reports successful real-account manual testing of registration, email confirmation, sign-in, profile editing, sign-out and password recovery; this is owner-reported and was not independently repeated in the workspace verification. Automated provider-dependent tests use fakes. Supabase SMTP configuration and production email delivery, sender identity, deliverability and current provider limits remain unverified. Native Amharic medical-language expert review, clinical content approval, device/accessibility checks, release signing/production build preparation, and production security/privacy review also remain open. Do not treat automated tests or development-flow checks as production readiness. No secrets or service credentials belong in the repository.

## 2026-10-30 — Phase 3 implementation choices

- Phase 3 was authorized after the preparation guide. Keep Flutter/Dart, Material 3, Supabase, ARB localization, Supabase Auth and secure session storage.
- Articles use structured Markdown rendered by a small safe Flutter widget; content is not HTML-rendered. Only professionally reviewed and publisher-approved content may be published. No clinical content was seeded.
- Quiz questions/options may be publicly read only when published. Answer keys and explanations stay in an unexposed private schema. Scores are computed by a service-only Postgres function called from a guest-capable Edge Function; guest submissions need no anonymous Auth user. A user identity is resolved by validating the access token with Supabase Auth, never from a client-provided user ID.
- Local learning progress is partitioned by guest/account in secure storage. Cloud sync is opt-in and disableable; the migration draft uses RLS to require current consent for cloud article writes and limits progress to its owner. Clearing cloud history preserves local records.
- Public content uses an online-first cache with a 7-day stale threshold and 50 MiB LRU cap. Stale/offline content warns that it may be withdrawn; offline quiz scoring is not allowed. These are technical defaults, not clinical freshness guarantees.
- Amharic search remains literal client-side matching for loaded content. No PostgreSQL search design is approved until representative reviewed Amharic content and queries have been evaluated.
- `path_provider: ^2.1.6` was added for app-private cache storage. No Markdown or search package was added.

The Flutter choices are implemented locally. Migrations `20261030174702`, `20261030174920`, and `20261030192800` plus `submit-assessment` v2 are deployed to the development project. The added guest limit uses an atomic private Postgres counter, keyed by the first forwarded client IP, allowing 20 submissions per 10-minute window and expiring records after one day. This avoids a paid external dependency. Database grants/RLS and the 20/21 threshold were verified; the deployed HTTP rate-limit path and gateway header trust still need direct endpoint verification. The content tables remain empty, so positive scoring and authenticated progress integration remain unverified. No production content or deployment is present.

## 2026-11-01 — App-wide typography: Plus Jakarta Sans & Noto Sans Ethiopic

- Replaced default system typography with bundled local Open Font License (OFL) assets:
  - English / Latin numbers & text: `Plus Jakarta Sans` (Variable Font `[wght]`). Ultra-modern geometric neo-grotesque typeface offering crisp contrast, contemporary proportions, and optimal screen readability.
  - Amharic / Ge'ez script: `Noto Sans Ethiopic` (Variable Font `[wdth,wght]`). The gold standard for modern screen-optimized Ethiopic script, eliminating archaic ductus and clipping.
- Implementation pattern: Declared in `pubspec.yaml` under `assets/fonts/` for 100% offline-first reliability in low-connectivity regions with zero additional package dependencies. Configured in `ThemeData` via `fontFamily: 'PlusJakartaSans'` with `fontFamilyFallback: const ['NotoSansEthiopic']`.
- Typography adjustments: Configured neutral `letterSpacing: 0` to prevent Amharic glyph collisions, paired with relaxed vertical line heights (`1.38 – 1.58`) to accommodate Ethiopic ascenders and vowel modifiers cleanly across all screens.
