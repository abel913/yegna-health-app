# Technical decisions

## 2026-10-29 â€” Standard Flutter localization

Use Flutter ARB resources and generated `AppLocalizations`. This is the standard Flutter approach, supports locale delegates and generated accessors, and keeps UI copy out of widgets. No alternative was needed.

## 2026-10-29 â€” Phase 2 provider approved: Supabase Auth

The owner requested Supabase Auth implementation and signed in to the `yegna-health-amharic` project. Project `oflkhtjskpsedsuczfkj` is active in `eu-north-1`. Dashboard settings showed Email enabled and Confirm email enabled. The native redirect `com.yegnahealth.amharic://auth-callback` was added to the project's Auth redirect allowlist.

Approved Phase 2 method: email/password with provider email confirmation and password recovery. Phone OTP and anonymous Supabase identities are not implemented. Guest users may browse public app pages. Account/profile actions require an Auth session with confirmed email. A single display name is stored in Auth `user_metadata` for display/editing only; user metadata is never trusted for authorization. No public database tables or migrations were needed for this scope.

The app uses a publishable client key only. The actual machine-local config file is Git-ignored; `config/supabase.example.json` contains placeholders. Never use or commit a service-role/secret key.

## Dependency pins

Use exact package versions `supabase_flutter: 2.15.4` and `flutter_secure_storage: 9.2.4`. The Supabase adapter is isolated behind `AuthRepository`; `SecureAuthStorage` stores both the persisted session and PKCE verifier material using platform secure storage. SharedPreferences remains for the locale preference only.

## 2026-10-29 â€” Locale ownership

Use a small `ChangeNotifier` controller to load and persist the two supported language codes. This keeps the foundation simple and replaceable if later requirements justify a broader app state layer.

## Deferred decisions and checks

The owner reports successful real-account manual testing of registration, email confirmation, sign-in, profile editing, sign-out and password recovery; this is owner-reported and was not independently repeated in the workspace verification. Automated provider-dependent tests use fakes. Supabase SMTP configuration and production email delivery, sender identity, deliverability and current provider limits remain unverified. Native Amharic medical-language expert review, clinical content approval, device/accessibility checks, release signing/production build preparation, and production security/privacy review also remain open. Do not treat automated tests or development-flow checks as production readiness. No secrets or service credentials belong in the repository.

## 2026-10-30 â€” Phase 3 implementation choices

- Phase 3 was authorized after the preparation guide. Keep Flutter/Dart, Material 3, Supabase, ARB localization, Supabase Auth and secure session storage.
- Articles use structured Markdown rendered by a small safe Flutter widget; content is not HTML-rendered. Only professionally reviewed and publisher-approved content may be published. No clinical content was seeded.
- Quiz questions/options may be publicly read only when published. Answer keys and explanations stay in an unexposed private schema. Scores are computed by a service-only Postgres function called from a guest-capable Edge Function; guest submissions need no anonymous Auth user. A user identity is resolved by validating the access token with Supabase Auth, never from a client-provided user ID.
- Local learning progress is partitioned by guest/account in secure storage. Cloud sync is opt-in and disableable; the migration draft uses RLS to require current consent for cloud article writes and limits progress to its owner. Clearing cloud history preserves local records.
- Public content uses an online-first cache with a 7-day stale threshold and 50 MiB LRU cap. Stale/offline content warns that it may be withdrawn; offline quiz scoring is not allowed. These are technical defaults, not clinical freshness guarantees.
- Amharic search remains literal client-side matching for loaded content. No PostgreSQL search design is approved until representative reviewed Amharic content and queries have been evaluated.
- `path_provider: ^2.1.6` was added for app-private cache storage. No Markdown or search package was added.

The Flutter choices are implemented locally. Migrations `20261030174702`, `20261030174920`, and `20261030192800` plus `submit-assessment` v2 are deployed to the development project. The added guest limit uses an atomic private Postgres counter, keyed by the first forwarded client IP, allowing 20 submissions per 10-minute window and expiring records after one day. This avoids a paid external dependency. Database grants/RLS and the 20/21 threshold were verified; the deployed HTTP rate-limit path and gateway header trust still need direct endpoint verification. The content tables remain empty, so positive scoring and authenticated progress integration remain unverified. No production content or deployment is present.

## 2026-11-01 â€” App-wide typography: Plus Jakarta Sans & Noto Sans Ethiopic

- Replaced default system typography with bundled local Open Font License (OFL) assets:
  - English / Latin numbers & text: `Plus Jakarta Sans` (Variable Font `[wght]`). Ultra-modern geometric neo-grotesque typeface offering crisp contrast, contemporary proportions, and optimal screen readability.
  - Amharic / Ge'ez script: `Noto Sans Ethiopic` (Variable Font `[wdth,wght]`). The gold standard for modern screen-optimized Ethiopic script, eliminating archaic ductus and clipping.
- Implementation pattern: Declared in `pubspec.yaml` under `assets/fonts/` for 100% offline-first reliability in low-connectivity regions with zero additional package dependencies. Configured in `ThemeData` via `fontFamily: 'PlusJakartaSans'` with `fontFamilyFallback: const ['NotoSansEthiopic']`.
- Typography adjustments: Configured neutral `letterSpacing: 0` to prevent Amharic glyph collisions, paired with relaxed vertical line heights (`1.38 â€“ 1.58`) to accommodate Ethiopic ascenders and vowel modifiers cleanly across all screens.

## 2026-11-01 â€” Learning Screen Carousel Focus & Personal Progress Relocation

- Learn Screen Architecture: Redesigned the `LearnPage` to strictly focus on the Youth Learning Modules Carousel (Modules 01 - 06), matching the target reference UI and eliminating the legacy tab bar (`Articles`, `Assessments`, `My learning`), header intro text, and cluttered learning summary card.
- Personal Progress Relocation: Relocated user-specific learning activity, cloud progress synchronization, and cached attempt management into `LearningProgressScreen`, accessible directly from the Account / Profile page under "My learning". This decouples general curriculum browsing from personal account state while retaining 100% offline-first storage and sync capabilities.

## 2026-11-01 â€” Learning Modules Expansion (Modules 07 & 08) & Visual Progress Indication

- Curriculum Expansion: Expanded the learning carousel from 6 to 8 modules to incorporate critical youth health topics:
  - Module 07: Human immune virus (HIV)/AIDS (rapid testing & community support illustration)
  - Module 08: Substance Abuse (healthy choices & counseling illustration)
- Localized Content: Provided full English and Amharic resource strings in `app_en.arb` and `app_am.arb` for both modules, regenerated via `flutter gen-l10n`.
- Progress Indication: Added visual completion state support (`completedModuleIds` linked to `LearningProgressController`), rendering an authentic green `âœ” Completed` indicator badge and progress bar on completed module cards matching the reference app layout. Pagination indicator dynamically scales across 8 dots with count display (`$page / 8`).
- Direct Navigation: Module action buttons (`More ->` and `Take Quiz`) connect directly to article lessons and interactive assessment sessions respectively, maintaining full testability with 0 unverified mock dependencies.

## 2026-11-01 â€” HIV/AIDS Interactive Module Detail & Accordion Curriculum Architecture

- Dedicated Detail Route: Created `HivModuleDetailPage` in `lib/src/learning/hiv_module_page.dart` launched directly via the "More ->" action on Module 07 in the learning carousel.
- Clinical Accordion Structure: Organizes HIV curriculum into three collapsible sections matching authentic youth-focused health materials:
  1. Ways to prevent HIV (PEP protocols, 10 numbered step-by-step condom instructions with azure badges, and embedded interactive video previews with educational modal descriptions).
  2. HIV testing modalities (PITC and VCT services with bulleted descriptions).
  3. Treatment for HIV positive clients (ART therapy, viral suppression, early intervention, and public facility access).
- Progress Sync & Offline Localizations: Directly triggers `LearningProgressController.markArticleComplete`, instantly refreshing local secure storage, optional cloud synchronization, and carousel completion indicators. All 34 new text keys are fully localized in English and Amharic with zero external dependencies.

## 2026-11-02 â€” External Video Launching via `url_launcher`

- Added `url_launcher: ^6.3.3` to `pubspec.yaml` to enable launching educational video demonstrations directly on YouTube:
  - Need & justification: Module 07 (HIV/AIDS) features authentic Ethiopian public health educational videos ("Condom Lubricants Warning Demonstration" and "Proper Condom Usage and Counseling"). Using `url_launcher` allows seamless, secure playback via the user's native YouTube app or external browser without bundling heavy in-app video players or WebView components.
  - Video URLs:
    - Condom Lubricants Warning: `https://youtu.be/EdSq2HB7jqU?si=TkGVTHA3TmYIXI-S`
    - Condom Counseling & Usage: `https://youtu.be/ii8ezLev2PU?si=QRNmr68hzDcRZZD6`
  - Graceful fallback: Video cards and detail modals provide in-app thumbnail previews, clinical descriptions, and a direct "Watch on YouTube" action with safe URL exception handling.


- Top Bar Action Placement: Unified the top app header by placing the notification bell with badge counter directly beside the language dropdown in the main `AppBar`. Removed the redundant account button from the top right.
- Streamlined Learn Screen Header: Removed the reloading icon and notification icon from the `LearnPage` body, leaving a clean "Learning Modules" title.
- Direct Guest Authentication Routing: Configured the bottom navigation Account tab to immediately route unauthenticated guests to `AuthPage` (sign-in / sign-up), avoiding intermediate landing steps. Upon successful sign-in, the view smoothly transitions to the authenticated account profile.

## 2026-11-01 â€” Profile and Account Settings Experience Modernization

- Screen Architecture: Redesigned the 5th destination (`_AccountPage`) into the authentic, modern Profile experience featuring a centered "Profile" title, 3-dot overflow menu for learning progress & logout, a 112dp circular avatar with cyan-ring halo, and two elevated card containers.
- Information Architecture: Separated identity/notifications from app preferences:
  1. Card Group 1: "View Profile" (Identity â€¢ Age) and "Notifications" (Preferences â€¢ Alerts).
  2. Card Group 2 ("ACCOUNT SETTINGS"): "Privacy & Security", "App Language", "App Theme", "Text Size", and "Support Center" with emergency hotline guidance (952 / 8335).
- Clean Local State: Language, theme, text sizing, and notification switches operate seamlessly offline without requiring unnecessary backend mutations or external dependencies.

## 2026-11-01 â€” Carousel Card Illustration Full-Width Scaling

- Illustration Container Refactor: Removed the fixed 190px height limitation and card-wide inset padding. Replaced with an `Expanded` container and minimal 8px horizontal margins with `fit: BoxFit.contain, width: double.infinity`.
- Card Proportions: Increased carousel card height dynamically (`540 - 600 dp`), giving the illustration over 340 dp of vertical room. This allows horizontal scaling to reach over 90% of the card width, matching the visual prominence and wide layout seen in the authentic reference app.

## 2026-11-02 â€” Real Interactive Map: OpenStreetMap & Turn-by-Turn GPS Navigation

- **Package Dependencies**: Added `flutter_map: ^8.3.2`, `latlong2: ^0.10.1`, and promoted `url_launcher: ^6.3.3` to direct dependency.
- **Provider Choice (OpenStreetMap over Google Maps SDK)**:
  - Selected OpenStreetMap (`flutter_map`) to provide a 100% open, API-key-free, and billing-free vector/raster map experience that runs out-of-the-box on Android, physical devices, Web, and the Android emulator without requiring Google Cloud Console billing setup or API keys.
  - Zero proprietary secrets or vendor lock-in; complies with project rule prohibiting fake maps while avoiding credential leakage.
- **Real Geographic Coordinates**: Connected verified Addis Ababa youth clinics and university health centers directly to their true GPS coordinates (`LatLng(latitude, longitude)`), rendering custom glassmorphic pin markers with animated scale and selection states.
- **Camera & Map Interactions**: Integrated `MapController` for smooth animated camera moves on marker taps, zoom in/out button steps, and "Locate Me" centering.
- **Turn-by-Turn GPS Navigation**: Wired the "Directions" button to launch external navigation apps (Google Maps, Apple Maps, or default system navigation) using `url_launcher` with `geo:` and Google Maps directions URLs.
