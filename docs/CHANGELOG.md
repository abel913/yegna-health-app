# Changelog

## 2026-10-31 — Phase 3 final verification and RLS correction

- Corrected the public assessment visibility RLS correlation with additive migration `20261031095050_fix_assessment_publication_policy_correlation`; verified the applied migration and `pg_policies` predicate in the linked development project.
- Verified 23 Phase 3 tables with RLS, private answer-key/limiter read denial, privileged scorer/limiter RPC grants, and database guest-limit behavior (20 allowed, 21 denied). No content or test user data was seeded. `submit-assessment` remains ACTIVE v2.
- Corrected the local pgTAP plan count from 24 to 26 to match its 26 security assertions; all 26 corresponding read-only catalog checks passed remotely. A direct Deno eval harness also passed six logic assertions, although the native test runner still panics on Windows.
- Passed Flutter dependency resolution, l10n generation, format (33 files; 0 changed), analysis, all 27 tests, Android debug APK and standard Web build. Deno formatting/type-checking passed; Deno tests did not run because Deno 2.9.7 panicked on a Windows named pipe. Docker/pgTAP unavailable.
- Verified only Edge HTTP rejection paths. No reviewed content means no valid scoring or authenticated sync test; actual HTTP 429, pgTAP suite and live account-isolation tests remain outstanding. Phase 3 remains partial; Phase 4 has not started.

## 2026-10-30 — Material 3 visual refinement

- Refined shared color, typography, cards, inputs, search surfaces and bottom navigation styling; tightened Home hero/shortcuts, directory headers/empty states, Learning progress/tabs/empty states, and Account cards.
- Kept directory search and filter previews visibly noninteractive because verified records are unavailable. Preserved all existing application and backend behavior; no dependencies, ARB files, Android configuration, or Supabase resources changed.
- Inspected five destinations in English and Amharic on Android emulator; verified bottom navigation, locale toggle, and Home guest-auth entry. Final `dart format lib test` passed (33 files; 0 changed), `flutter analyze --no-pub` passed, all 27 Flutter tests passed, and `flutter build apk --debug --no-pub` passed and was installed. Phase 3 remains partial; Phase 4 has not started.

## 2026-10-30 — Stitch UI presentation integration

- Added a native Material 3 five-destination shell and integrated the Stitch-inspired Home and Learning layouts with existing education, assessment, progress, authentication, profile and locale flows.
- Added localized Facilities and Mentors empty-state screens with disabled controls because verified directory data is unavailable; no fake contact, facility, hotline or map data was introduced.
- Regenerated English/Amharic localizations and added navigation/localization regression coverage. Formatting, analysis, all 27 Flutter tests, and Android debug APK build passed.
- No Supabase schema/settings or backend code changed. No emulator was connected, so visual device comparison remains unverified. Phase 3 remains partial; Phase 4 has not started.

## 2026-10-30 — Shared guest scoring limit and final verification refresh

- Added an atomic private database rate-limit RPC and service-role-only access for the guest assessment scorer; deployed the additive migration and scorer v2 to the development project.
- Verified RLS/grants and the 20-allowed/21-rejected limit in a rolled-back SQL transaction. Deno type checking passed; Deno runtime tests and endpoint HTTP tests were blocked by Windows pipe/proxy failures.
- Re-attempted Flutter checks; invocations stalled without output and were interrupted. No fresh Flutter pass is claimed. Phase 3 remains partial because there is no reviewed quiz content and live positive scoring/sync plus visual verification remain open.

## 2026-10-30 — Phase 3 continuation verification

- Rechecked the linked development Supabase project: the two Phase 3 migrations remain applied, the scorer remains active, and all 22 app tables are empty with RLS enabled.
- Re-ran Flutter dependency resolution, localization generation, formatting, analysis, all 26 tests, and Android debug APK build; all passed. Deno type checking and all 6 Edge Function logic tests passed.
- Rechecked scorer negative HTTP behavior for missing API key, malformed guest request, invalid user bearer, and nonexistent quiz. No valid quiz exists for a successful score test.
- Updated current status, architecture, handoff, test evidence, feature inventory and known blockers. No migrations/functions were re-deployed, no content was published, and no Phase 4 work began.
- `flutter build web --no-pub` passed after one stalled attempt. Chrome startup did not connect to its debug service, and browser automation is disabled, so current visual verification remains unclaimed. The reference APK was not available.

## 2026-10-30 — Phase 3 implementation draft

- Integrated a bilingual Learn experience for category/article browsing, search/filtering, article reading/source links/related content, assessments, progress history and sync settings.
- Added bounded online-first education cache (7-day stale threshold, 50 MiB LRU) and secure local guest/account progress with opt-in synchronization and restart-safe pending quiz retries.
- Added a draft Supabase migration for reviewed public educational content, localized quiz versions, private answer keys/editorial approvals, consent-gated private progress and server-side scoring; added a guest-capable scoring Edge Function.
- Added Flutter widget/cache tests, TypeScript logic tests and pgTAP security assertions. `dart format` and Deno type-check passed. Flutter analyzer/widget tests and Deno runtime tests are blocked in the current Windows sandbox; the database migration/tests and deployment were not run.
- No reviewed content was seeded. Phase 3 remains in progress and Phase 4 has not started.

## 2026-10-30 — Phase 2 status and Phase 3 planning reconciliation

- The owner reports successful real-account manual testing of Phase 2 registration, email confirmation, sign-in, profile editing, sign-out and password recovery. This is owner-reported manual verification and was not independently repeated in this documentation update.
- Historical automated tests remain separate evidence and use fake repositories/test doubles for provider-dependent behavior; they do not call Supabase or verify live email delivery.
- Supabase SMTP configuration and production sender identity, email deliverability and provider limits remain unverified. Clinical/Amharic medical-language approval, device/accessibility checks, release signing/build preparation, and production security/privacy review also remain outstanding.
- Refined the Phase 3 planning guide with provisional configurable cache defaults (50 MB maximum, 7-day TTL, bounded LRU), explicit offline/stale-content handling, and the existing implementation-authorization boundary. Phase 3 remains planned only; no implementation was started.

Entries below preserve the status recorded when they were written. Any earlier statement that live Phase 2 tests were outstanding is superseded by the owner-reported confirmation above; it remains historical context, not the current status.

## 2026-10-29 — Phase 2 emulator rendering and interaction diagnosis

- Identified graphics mode as the environment cause: API 37 AVD in `auto` mode rendered black and ignored ADB taps; the same AVD launched with `-gpu host` rendered Home on Intel Iris Xe and accepted taps.
- Manually verified Home Account → Sign in, Create account, Services bottom navigation and Settings → Account → Sign in in the emulator. The workaround was a launch override; persisted AVD settings remain unchanged.
- No app source, Android project configuration, or credentials were changed. At the time this entry was written, live Supabase account/email verification had not yet been reported.

## 2026-10-29 — Phase 2 account entry and interaction coverage

- Added a localized Account/Manage account button to Home so sign-in, registration, and profile access are visible from initial launch; Settings account access remains available.
- Added widget coverage for Home account navigation, guest navigation, sign-in validation, and registration/recovery mode changes.
- `flutter gen-l10n`, `dart format lib test`, `flutter analyze` and `flutter test` passed; all 19 tests passed, including a verified-user profile edit/sign-out widget path. Debug APK build with the local Supabase define file passed.
- The emulator launched the app and exposed the updated Home semantics tree, but screenshots remained black and shell-injected taps did not navigate in that diagnostic run. This historical status was superseded by the later host-GPU emulator check and the owner's subsequent live-authentication test report.

## 2026-10-29 — Phase 2 Supabase Auth implementation

- Added Supabase Auth email/password registration and sign-in, provider email-confirmation pending state, password recovery/reset deep-link flow, profile display-name editing, guest access and sign-out.
- Added English and Amharic labels, validation, loading, success and safe error states for auth/profile screens.
- Added a provider-independent repository/controller boundary and deterministic unit/widget tests.
- Pinned `supabase_flutter` 2.15.4 and `flutter_secure_storage` 9.2.4. Session and PKCE material use secure platform storage; language preference remains in SharedPreferences.
- Configured `com.yegnahealth.amharic://auth-callback` in Android manifest and the signed-in Supabase project's redirect allowlist. Confirm email is enabled.
- Added a Git-ignored local Supabase config and a safe placeholder example. No service-role secret, database table or migration was added.
- `flutter gen-l10n`, `dart format lib test`, `flutter analyze` (clean) and `flutter test` (17 passing, including an Amharic auth-screen widget test) were run successfully in this workspace.
- At the time this entry was written, live account/email testing had not yet been reported. This was superseded by the owner-reported manual flow verification above. Production SMTP/email readiness remains outstanding. No Phase 3 work was started.

## 2026-10-29 — Phase 1 foundation verified

- Established Flutter Material 3 shell, English/Amharic ARB localization, and persisted language selection.
- Added Android platform scaffolding with `flutter create --platforms=android .`; Gradle files use Kotlin DSL.
- Project owner verified `flutter pub get`, localization generation, formatting, clean analysis, all 4 then-existing tests, debug APK build, emulator launch/page behavior, English/Amharic switching and preference persistence after restart.
- Physical-device coverage, release build/signing, deployment and security audit remain unperformed.
