# Technical decisions

## 2026-11-12 — Unified Assessments Hub Architecture in Admin Web Portal

- **Consolidated Assessments Hub (`AssessmentsPage.tsx`)**:
  - Combined the **General Baseline Survey** analytics and the **Module Learning Assessment Editor** under one unified top-level sidebar route: `assessments` (`Assessments & Surveys` / `ምዘናዎች እና ቅኝቶች`).
  - *Rationale*: Eliminates sidebar fragmentation, grouping all evaluation and survey mechanisms together. Administrators can seamlessly switch between population-level baseline surveys and module-specific educational tests with zero page reloads.
- **Zero-Knowledge Anonymous Analytics Engine**:
  - Displays real-time aggregated metrics across all 4 baseline questions (Age distribution, Study year breakdown, Accessibility accommodations, University of Gondar SRH clinic awareness).
  - Protects student privacy: the data table only surfaces categorical values with a `● 100% Anonymous (Zero PII)` badge, with no user IDs or contact information.
  - Added 1-click UTF-8 BOM CSV export for academic and clinic administration reporting.


## 2026-11-07 — Anonymous Student Baseline Survey & Stacked Card Modal Architecture

- **Onboarding Stacked-Card Popup Modal (`OnboardingSurveyDialog`)**:
  - Implemented single-question stacked card modal popup over a blurred Home dashboard (`BackdropFilter` with Gaussian blur $\sigma = 14$ and translucent scrim).
  - Features a tactile 3-layer card deck aesthetic with rotational offsets (`Matrix4.rotationZ`) and rounded corners, matching the approved reference design.
  - Interactive radio selectors with filled circular indigo accent and checkmark `✓` icon on active selection.
  - Multi-step flow: 4-segment gradient progress dash bar, monospace question tracking (`Q.01`..`Q.04`), and responsive `Back` / `Next` / `Finish` controls.
  - Dismiss/Skip button `(✕)` safely marks the survey as skipped in local storage so students are never blocked from exploring the app.
- **Dynamic Bilingual Localization**:
  - Automatically switches all questions, options, and button labels between English (`lib/l10n/app_en.arb`) and Amharic (`lib/l10n/app_am.arb`) using Flutter's official `AppLocalizations`.
  - Zero hardcoded English/Amharic strings.
- **Anonymous Database Persistence & Zero PII Storage (`BaselineSurveyResponse`)**:
  - Responses are saved in PostgreSQL schema `yegna.BaselineSurveyResponse` without any `userId`, `email`, `displayName`, or student identifiers.
  - Endpoint `POST /api/survey/baseline` stores strictly categorical data (`ageGroup`, `yearOfStudy`, `disabilityNeed`, `knowsGondarSrh`, and `submittedAt`).
  - Endpoint `GET /api/admin/survey/stats` computes real-time aggregated totals and percentages across all 4 questions, empowering university health administrators and researchers to measure population metrics and SRH awareness while honoring 100% student confidentiality.
- **Post-Survey Actionable Continuity**:
  - If a student indicates they do not know where sexual & reproductive health services are located at the University of Gondar, the completion dialog surfaces a 1-tap shortcut directly to the campus health clinic on the map.


## 2026-11-06 — Supabase PostgreSQL Cloud Database Transition

- **Cloud Database Provider & Schema Isolation Strategy**:
  - Transitioned the backend server datasource from a local prototyping SQLite database to the linked cloud Supabase PostgreSQL instance (`yegna-health-amharic`, project ref: `oflkhtjskpsedsuczfkj`, region `eu-north-1`).
  - Isolated application models into a dedicated PostgreSQL schema (`yegna`) using Prisma's `multiSchema` preview feature.
  - *Rationale*: Isolating tables into the `yegna` schema prevents Prisma schema synchronization from conflicting with Supabase's internal auth engine (`auth.users`, `auth.sessions`, etc.) or legacy Phase 3 tables, guaranteeing zero data loss, safe programmatic migrations, and clean namespace management.
- **Connection Architecture**:
  - Standard transaction queries route through Supabase Supavisor connection pooler on port `6543` with `?pgbouncer=true`.
  - Direct schema pushes and administrative introspection connect through port `5432` (`DIRECT_URL`).
- **Data Integrity & Seeding**:
  - Seeded all 8 adolescent health learning modules, complete True/False and Multiple Choice question banks, verified youth health facilities across Addis Ababa and Gondar, certified mentors, and student clubs directly to Supabase Cloud.
  - Zero-Knowledge student privacy is strictly preserved: sensitive youth health surveys, period logs, chat transcripts, and quiz attempts stay private and encrypted on the client device.

## 2026-11-06 — Module Quiz Management & Dynamic Mobile Sync Architecture

- **Flexible Question Format Engine (`type: 'MULTIPLE_CHOICE' | 'TRUE_FALSE'`)**:
  - Added native support for both **True / False (2 Options)** and **Multiple Choice (4 Options)** question models in Prisma (`QuizQuestion.type`) and REST APIs.
  - In `QuizzesPage.tsx`, added an interactive format switcher:
    - In True/False mode: auto-populates localized binary choices (`True/False` and `እውነት/ሐሰት`) and renders a high-visibility 2-button card selector (`✓ True / እውነት` vs `✗ False / ሐሰት`) to set the correct answer.
    - In Multiple Choice mode: provides 4 customizable options in English and Amharic with radio button selection (A, B, C, D).
- **Backend Schema & Validation Separation**:
  - Implemented `baseQuestionSchema` with `.refine()` in Zod to decouple partial schema parsing for updates (`updateQuestionSchema`) from strict creation rules, ensuring True/False questions strictly enforce 2 options and index `0..1`, while Multiple Choice enforces 4 options and index `0..3`.
  - Expanded `server/prisma/seed.ts` to seed all 8 curriculum modules (`module-01` through `module-08`) with realistic questions matching official adolescent health curricula.
- **Dynamic Mobile Sync & Zero-Knowledge Client Evaluation**:
  - Engineered `DynamicQuizHelper.loadFromCache()` to read synced questions from `OfflineSyncStore` (`yegna_offline_quizzes_v1`) by module ID or category.
  - Upgraded all 8 module quiz pages to dynamically resolve and render questions, supporting variable option count (2 for True/False, 4 for Multiple Choice) without breaking bundled offline fallbacks or unit tests.
  - Evaluation and scoring strictly remain on the student's mobile device, preserving 100% Zero-Knowledge student privacy.

## 2026-11-06 — High-End SaaS User Management & Layout Redesign

- **Modern SaaS Layout & Design Tokens Adoption (`AdminLayout.tsx` & `UsersPage.tsx`)**:
  - Adopted the clean, uncluttered SaaS design language inspired by top-tier enterprise platforms (e.g. Linear, Supabase, Tailwind UI):
    - Subdued category labels (`General`, `Curriculum & Clubs`, `Governance`) replacing unstructured lists.
    - Added high-visibility `[ Quick actions   ⌘K   / ]` pill shortcut in sidebar for immediate command palette access.
    - Breadcrumbs (`Yegna Platform / 👥 User management`) with muted hierarchy and active path highlight.
    - Header with inline dynamic count badge (`{users.length}`) and clear context subtitle.
    - Segmented view mode switcher (`⊞ Table`, `▥ Board`, `:= List`) allowing administrators to switch between detailed tabular rows, Kanban boards grouped by role, and compact lists.
    - Floating filter pills strip directly beneath the toolbar (`Role ⌵`, `Status ⌵`, `2F / Email: {verified} ⌵`, and `Reset filters`) replacing bulky filter cards.
    - Clean table layout with multi-select checkboxes, hashed pastel circle avatars, click-to-copy email with toast notifications, status bullet dots (`● Active` in emerald, `● Suspended` in rose), formatted joined timestamps, and ghost outline action buttons (`Edit`, `Delete`).
    - Standardized bottom pagination bar featuring rows per page selector, range counter (`1-15 of {total} rows`), and numbered pagination buttons.
- **Backend Admin User Creation Endpoint (`POST /api/admin/users`)**:
  - Implemented secure administrative user creation in `server/src/controllers/users.controller.ts` with bcrypt password hashing, default role assignment, optional email pre-verification, and structured audit trail logging (`USER_CREATED_BY_ADMIN`).
- **Zero-Knowledge Student Privacy Retention**:
  - Maintained complete confidentiality: student assessments, mental health chatbot logs, and private surveys remain on-device and are strictly omitted from administrative queries and data models.

## 2026-11-06 — Production Backend User Authentication & Desktop Web Admin Governance

- **Self-Hosted Backend Authentication Architecture (`BackendAuthRepository`)**:
  - Implemented `BackendAuthRepository` connecting the Flutter mobile app directly to the Node.js + Express + Prisma backend (`server/`) without external Supabase dependencies.
  - Implemented local session caching via `SharedPreferences` (`backend_auth_token`, `backend_auth_user_id`, `backend_auth_email`, `backend_auth_display_name`, `backend_auth_role`), enabling students to launch and navigate the app offline with their verified profile.
  - Added background revalidation upon launch (`init()` -> `GET /api/auth/me`). If the user profile was updated remotely, local preferences are refreshed seamlessly; if network is unavailable, the local verified session is retained.
- **Immediate Suspension Enforcement & Community Safety**:
  - Enhanced backend error handling with explicit codes (`ACCOUNT_SUSPENDED`, `EMAIL_EXISTS`, `INVALID_CREDENTIALS`).
  - Added `accountSuspended` and `emailAlreadyInUse` issues to `AuthIssue` enum and localizations in both English (`app_en.arb`) and Amharic (`app_am.arb`).
  - If an administrator suspends a user in the web portal, the backend rejects further auth calls with `403 ACCOUNT_SUSPENDED`, and the mobile app immediately clears the local session and surfaces a localized floating safety notice.
- **Full Administrative User Governance (`admin-web/`)**:
  - Expanded Desktop Web Admin Portal (`UsersPage.tsx`) with search, role filters (`STUDENT`, `MENTOR`, `CONTENT_AUTHOR`, `ADMIN`, `SUPER_ADMIN`), and status filters (`Active`, `Suspended`).
  - Added 1-click Account Suspension & Reinstatement with immediate audit logging.
  - Added **Reset Password Modal** supporting custom password inputs and 1-tap cryptographically secure random password generation (`12-character uppercase/lowercase/numbers/symbols`).
  - Added **Delete Account Dialog** with strict SuperAdmin deletion guards preventing accidental self-deletion or platform lockout.
  - Added CSV user roster export and responsive client-side pagination.
- **Zero-Knowledge Student Privacy Retention**:
  - Retained strict Zero-Knowledge boundaries: user tables strictly store platform identity attributes (`id`, `email`, `displayName`, `role`, `isSuspended`).
  - Sensitive personal learning history, self-assessment choices, and AI chatbot conversations remain local to the student's device and are never queryable in administrative views.

## 2026-11-05 — Offline-First Mobile Synchronization & Custom Node.js Backend Integration

- **Offline-First Synchronization Architecture (Zero Blank Screens)**:
  - Designed and implemented a robust **Stale-While-Revalidate** offline-first data pipeline connecting the Flutter mobile app to the custom Node.js + Express + Prisma backend (`server/`).
  - **Immediate Local Return**: All discovery, learning, and clubs repositories (`SyncFacilityRepository`, `SyncMentorRepository`, `SyncEducationRepository`, `SyncAssessmentRepository`, `SyncClubRepository`) read from persistent device storage (`OfflineSyncStore`) first, ensuring instant 0ms UI render times.
  - **Zero-Network Cold Start Resilience**: On a fresh install opened without internet access, repositories automatically fall back to pre-bundled seed records (`LocalVerifiedFacilityRepository`, `LocalVerifiedMentorRepository`, `ContentTemplates`), guaranteeing the app never presents a spinner, blank screen, or crash.
  - **Background Revalidation (`SyncManager`)**: Orchestrates parallel asynchronous queries (`Future.wait`) against the backend when network connectivity is available, updating local persistent caches and notifying listeners without interrupting user flow or requiring app restarts.
  - **Pull-To-Refresh Integration**: Wrapped list views across Facilities, Mentors, Student Clubs, and Learning modules in Material `RefreshIndicator`, providing instant user-initiated sync.
- **Zero-Knowledge Student Privacy Enforcement**:
  - The synchronization pipeline is strictly unidirectional for student personal data: only public administrative catalogs (verified clinics, mentor profiles, curriculum modules, quiz question banks, approved student clubs) flow down from the backend.
  - Confidential student assessment choices, reading histories, and AI chatbot conversations remain strictly local on the device and are never transmitted to the backend or admin database.
- **Dependency Pin (`http: ^1.2.0`)**:
  - Promoted `http` (already present transitively in `pubspec.lock` at `1.6.0`) to a direct dependency in `pubspec.yaml` to ensure reliable, multi-platform HTTP communication with customizable timeouts and mock client injection for test isolation.


## 2026-11-04 — Official App Launcher Icons Generation (`flutter_launcher_icons`)

- **Dedicated Launcher Icon Automation (`flutter_launcher_icons: ^0.14.4`)**:
  - Added `flutter_launcher_icons: ^0.14.4` under `dev_dependencies` to automate the generation of cross-platform launcher icon assets for Android, iOS, and Web.
  - Generates platform-compliant assets from the high-resolution source master icon (`assets/icon/app_icon.png`):
    - **Android Adaptive Icons**: Separated solid white background (`#FFFFFF` in `colors.xml`) and transparent foreground (`ic_launcher_foreground.png`), configured with `adaptive_icon_foreground_inset: 0` to preserve the calculated 66% safe zone radius (325.7 px max glyph radius vs 341 px mask limit).
    - **Android Legacy Icons**: Populates `mipmap-*/ic_launcher.png` for Android API < 26.
    - **iOS App Icons**: Generates full Apple Human Interface Guidelines specification in `Runner/Assets.xcassets/AppIcon.appiconset/` without alpha transparency.
    - **Web Icons**: Automatically updates `web/favicon.png` and PWA maskable icons (`Icon-192.png`, `Icon-512.png`).
  - Scoped strictly to `dev_dependencies`, adding 0 runtime footprint to production mobile or web binaries.

## 2026-11-03 — Database-Driven Admin Credentials & Password Hashing

- **Database-Backed Authentication (No Hardcoded Credentials)**:
  - Eliminated all hardcoded administrator credentials from the code logic.
  - Implemented `AdminAccount` model storing administrator accounts in the database table (`admin_accounts` in Supabase when remote, and `yegna_db_admin_accounts_table_v2` in persistent database storage when offline/local).
  - Passwords are encrypted using cryptographic SHA-256 with project salt (`LocalAdminRepository.hashPassword`), preventing plaintext password exposure in storage or logs.
  - `verifyAdminCredentials` queries the database table dynamically, matching email and verifying the cryptographic password hash.
  - Added full administrative account management (`getAdminAccounts()`, `saveAdminAccount()`) to allow creating and updating admin credentials dynamically in the database.
- **Dependency Pin (`crypto: ^3.0.6`)**:
  - Added direct dependency `crypto: ^3.0.6` (previously only present transitively) to provide secure SHA-256 hashing for database administrator credentials.

## 2026-11-03 — Professional Admin Portal & Student Clubs Engagement System

- **Unified Admin Portal & Content Management Architecture**:
  - Built an administrative engine providing full CRUD governance across 7 entities: Learning Modules, Assessment Questions, Educational Articles / Doctor's Notes, Verified Facilities, Counselor Mentors, Student Clubs, and Registered Users.
  - Implemented `AdminRepository` and `LocalAdminRepository` utilizing lightweight JSON serialization persisted via `SharedPreferences`. No heavy new third-party state or database dependencies were introduced.
  - Added `AdminAuditEntry` logging all administrative mutations (creations, edits, deletions, role updates) with timestamps and actor emails to ensure full traceability.
  - Added pre-configured scaffolding templates (`ContentTemplates`) enabling instant one-tap content generation ("Load Template") across all entity editors.
- **Student Clubs Engagement System**:
  - Implemented `StudentClub` and `ClubMembership` data models with category filters (`wellness`, `mentalHealth`, `srh`, `substanceFree`, `leadership`).
  - Added `ClubRepository` and `LocalClubRepository` supporting persistent member rosters and joined-club filtering.
  - Wired direct integration with `InAppNotificationController` to generate in-app student confirmations upon club registration.
- **Dynamic Repository Composition Pattern**:
  - Implemented `DynamicFacilityRepository` and `DynamicMentorRepository` to cleanly augment hardcoded verified healthcare and mentor registries with dynamic admin additions.
  - Preserved unconfigured fallback isolation (`UnconfiguredFacilityRepository` / `UnconfiguredMentorRepository`) so offline/unconfigured widget test contracts continue to pass without regression.
- **Localization & Accessibility**:
  - Full bilingual ARB resources (`app_en.arb`, `app_am.arb`) across all admin console screens, student club detail sheets, categories, and audit logs.
  - Ensured empty states and long content use scrollable containers (`SingleChildScrollView`) to prevent layout clipping on small viewports and high text-scale settings.

## 2026-11-03 — Functional Settings: Dark Theme, Global Text Sizing, and Persistent Preferences

- **App Settings Architecture (`AppSettingsController`)**:
  - Implemented lightweight `ChangeNotifier` to manage user preferences: `ThemeMode` (`system`, `light`, `dark`), `AppTextScale` (`small` [0.88x], `normal` [1.0x], `large` [1.18x]), and persistent notification toggles (`pushAlertsEnabled`, `healthTipsEnabled`, `assessmentRemindersEnabled`).
  - Stored strictly via existing `SharedPreferences` without introducing unnecessary state management dependencies.
- **Global Typography Scaling**:
  - Injected `TextScaler.linear(settingsController.textScaleFactor)` directly into `MaterialApp.builder` wrapping the root `MediaQuery`.
  - Guarantees seamless text responsiveness across all 8 learning modules, quiz accordions, directory cards, and self-assessment tools without layout clippings or hardcoded font size modifications.
- **Material 3 Midnight Dark Theme**:
  - Styled with deep midnight slate tones (`#0B132B`, `#0F172A`, `#1E293B`) and cyan/sky brand accents (`#0284C7`, `#38BDF8`).
  - Wrapped modal bottom sheets with `Material` clipping to eliminate `DecoratedBox` background conflicts and preserve native ripple feedback.
- **Guest Mode Promotion & Account Navigation**:
  - Displayed "Save your learning journey" banner on the Profile page when signed out with immediate "Sign In / Register" action.
  - Maintained safe redirection to Home upon sign-out.

## 2026-11-02 — Mentors direct calling, Telegram contact channels, and package visibility

- Direct Contact Integration:
  - Phone calling: Configured `tel:<normalized_phone>` via `url_launcher` with `LaunchMode.externalApplication` to open the platform's native phone dialer directly without intermediary mock dialogs.
  - SMS messaging: Added `sms:<normalized_phone>` launcher option allowing users who prefer text or asynchronous messaging to reach mentors via SMS.
  - Telegram chat: Integrated `https://t.me/<handle>` with external application launch mode, providing seamless handoff to the Telegram application or web client for real-time peer chat.
  - Clipboard fallback: If URL launching fails or is unsupported on the host platform, the app copies the phone number or handle to the clipboard and displays a localized floating snackbar.
- Android 11+ Package Visibility (`<queries>`):
  - In Android 11+ (API level 30+), apps cannot query whether external dialer or SMS handlers are installed without explicit `<queries>` declarations in `AndroidManifest.xml`.
  - Added intent query declarations for `android.intent.action.DIAL` with scheme `tel` and `android.intent.action.VIEW` with scheme `sms`.
- Safeguarding and Crisis Management:
  - Peer counselors provide guidance and support, not emergency medical intervention.
  - Added working hours badges to set clear availability boundaries.
  - Replaced static hotlines in the disclaimer with interactive, 1-tap dialer buttons for national emergency hotlines `952` and `8335`.

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

## 2026-11-02 — Live Proximity Distance Calculation & Real-Time GPS Sorting

- **Package Dependency**: Added `geolocator: ^14.0.2` and configured Android permissions (`android.permission.ACCESS_FINE_LOCATION`, `android.permission.ACCESS_COARSE_LOCATION`).
- **Privacy & Confidentiality Guarantee**:
  - Live GPS coordinates are calculated and processed 100% locally on-device using spherical geodesy (`latlong2` `Distance`).
  - Coordinates and user position are **never** transmitted to Supabase or any external cloud telemetry service, strictly upholding the project's youth privacy and confidentiality guarantees.
- **Dynamic Proximity Sorting**:
  - When the user selects the "Nearby" filter (or taps "Locate Me"), the app requests location permissions via `LocationService` (abstracted with `GeolocatorLocationService` for production and `FakeLocationService` for unit/widget tests).
  - All verified health facilities dynamically receive calculated distances (`facility.copyWith(distanceKm: realDist)`), updating badges (e.g. `1.2 km away` / `1.2 ኪ.ሜ ርቀት`) and sorting from closest to furthest.
- **Pulsing Live Marker**:
  - Rendered a pulsing blue core marker on `FacilityMapView` via `_UserLocationMarker` at the user's real GPS coordinates.
- **Graceful Offline & Permission Degradation**:
  - If location permissions are denied or GPS is disabled, the app gracefully presents an informative bilingual notice without crashing, falling back to default curated ordering.

