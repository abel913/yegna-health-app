# Testing strategy and results

# Final Phase 3 verification (2026-10-31)

## Flutter commands

- `flutter pub get` — PASS; dependencies resolved, no upgrades requested.
- `flutter gen-l10n` — PASS; existing `l10n.yaml` configuration retained.
- ARB key parity — PASS; 150 user-facing keys in each of English and Amharic, no unmatched keys.
- `dart format lib test` — PASS; 33 files checked, 0 changed.
- `flutter analyze` — PASS; no issues found.
- `flutter test` — PASS; all 27 tests passed.
- `flutter build apk --debug` — PASS; `build/app/outputs/flutter-apk/app-debug.apk` created.
- `flutter build web --no-pub` — PASS; standard Web output created. The build reported Wasm incompatibility with existing `flutter_secure_storage_web` legacy JS imports and a non-fatal Cupertino font notice; this was not a Wasm build.

## Edge Function and database

- Remote migrations confirmed: `20261030174702`, `20261030174920`, `20261030192800`, `20261031095050`. Corrected assessment publication RLS correlation verified remotely. The deployed `submit-assessment` function is ACTIVE v2, `verify_jwt=false` (handler validates API key and resolves user bearer tokens itself).
- HTTP checks actually run: missing API key `401 api_key_required`; invalid JSON-shaped submission `{}` `400 invalid_submission`; invalid bearer `401 invalid_session`; GET `405 method_not_allowed`; syntactically valid guest request with unknown question/option IDs `400 invalid_answers`. No score was returned.
- Database limiter check used a dedicated reserved documentation IP inside a bounded SQL block: attempts 1–20 allowed, attempt 21 denied; test row removed. A separate one-request HTTP check using a reserved forwarding-header value did not record that value, so repeated live requests were stopped to avoid throttling the gateway's real/shared caller. HTTP 429 is **not verified**.
- Catalog checks: 23 Phase 3 tables, all RLS-enabled; 34 foreign keys; 41 relevant indexes. All 26 security assertions corresponding to `supabase/tests/phase3_learning_security.test.sql` returned true in a direct read-only SQL query. `anon`/`authenticated` cannot select answer keys, explanations or limiter rows or execute privileged scorer/limiter RPCs; `service_role` can execute the server-side RPCs. Assessment/article/progress/attempt data counts were zero. No content or test identity was inserted. The local pgTAP file's plan count was corrected to 26, matching its 26 assertions; the pgTAP runner itself remains unrun.
- Supabase advisors rechecked: 6 private RLS-enabled no-policy tables (default deny), 1 authenticated SECURITY DEFINER history-clear warning, leaked-password protection disabled; performance advisories include 13 unindexed FKs, 7 RLS init-plan warnings and 7 unused-index notices. No formal security audit was performed.
- `deno fmt --check supabase/functions/submit-assessment` — PASS (3 files checked). `deno check supabase/functions/submit-assessment/index.ts` — PASS (entry and logic test modules checked). `deno test --allow-env supabase/functions/submit-assessment` and a retry with `--no-check` — BLOCKED: Deno 2.9.7 panicked on Windows `deno_pipe` with invalid handle before tests executed. A direct `deno eval` harness exercised the six logic assertions and passed; this is not reported as `deno test`.
- `docker info` — BLOCKED: Docker Desktop Linux engine pipe not found. Remote `pg_extension` check — pgTAP absent; `supabase/tests/phase3_learning_security.test.sql` was not executed as pgTAP. Catalog assertions and the bounded SQL limiter check are not a substitute for the full pgTAP suite.

## Remaining end-to-end checks

No reviewed quiz/article is published, so valid guest scoring and all authenticated score/sync/retry/retake/account-isolation flows remain unverified. The owner reports Phase 2 real-account development flows passed; automated provider tests are still repository fakes. SMTP/production email, browser visual/console testing, release build/signing, physical device, production deployment and full security audit were not performed. Phase 3 remains partial; Phase 4 has not started.

## UI refinement verification (2026-10-30)

| Exact command/action | Result |
| --- | --- |
| `dart format lib test` | Passed; final run checked 33 files, 0 changed. |
| `flutter analyze --no-pub` | Passed; no issues found. |
| `flutter test --no-pub` | Passed; all 27 tests passed, including destination navigation, locale changes, learning flows, auth and profile behavior. |
| `flutter build apk --debug --no-pub` | Passed; `build/app/outputs/flutter-apk/app-debug.apk` generated. Java emitted a restricted-native-access warning; build succeeded. |
| Install and launch on `emulator-5554` | Passed; final debug APK installed and app relaunched on Medium Phone API 37 (Android 17). |
| Visual inspection / device taps | Captured all five destinations (Home, Facilities, Mentors, Learning, Account) in English and Amharic. After the directory/empty-state adjustment, recaptured all five in English and Learning in Amharic; after the final Learning error-card adjustment, rechecked the Amharic Learning error view. Tapped all bottom destinations, changed locale, and opened guest authentication from Home. No visible Amharic clipping. No live authentication submission was attempted. |

These are emulator checks on one virtual device only. Learning content availability depends on the configured backend and approved content; no production readiness, physical-device testing, release build, or security audit is claimed.

## Stitch UI integration verification (2026-10-30)

| Exact command | Result |
| --- | --- |
| `flutter pub get` | Passed; dependency resolution completed. No intentional dependency changes were made for this UI integration. |
| `flutter gen-l10n` | Passed; used the existing `l10n.yaml` and regenerated accessors from both ARBs. |
| `dart format lib test` | Passed; 33 files checked, 0 changed on the final run. |
| `flutter analyze --no-pub` | Passed; no issues found. |
| `flutter test --no-pub` | Passed; all 27 tests passed, including five-destination navigation, locale switching, article/detail, assessment, progress, and auth/profile flows. |
| `flutter build apk --debug --no-pub` | Passed; generated `build/app/outputs/flutter-apk/app-debug.apk`. Gradle emitted a Java restricted-native-access warning; build succeeded. |
| `flutter devices` | Windows, Chrome, and Edge found; no Android emulator or physical device was attached. |

Visual/emulator testing and a live Stitch screenshot comparison were not performed in this pass. Directory screens are tested as honest empty states; no directory backend or real records are present. Passing unit/widget tests and an APK build do not verify Supabase live scoring, content review, device rendering, or Phase 3 completion.

## Latest continuation verification (2026-10-30)

### Final Phase 3 continuation refresh

- Remote project confirmed `ACTIVE_HEALTHY`; migration `20261030192800` (`phase3_guest_assessment_rate_limit`) is applied and `submit-assessment` is active at version 2 with `verify_jwt=false`.
- Added an atomic, shared DB-backed guest limit of 20 submissions per client IP per fixed 10-minute window. Client IP counters are held in a private RLS-enabled table and expired after one day; only `service_role` can read the table or invoke the RPC. Authenticated submissions bypass the guest limiter. Missing IP context or limiter failures return 503; over-limit calls return 429 with `Retry-After: 600`.
- Supabase catalog verification passed: RLS is enabled; `anon` and `authenticated` lack table SELECT and RPC EXECUTE; `service_role` has the intended access.
- A remote SQL transaction exercised the limiter's atomic threshold for 21 attempts (first 20 allowed, 21st rejected), then rolled back the fixture. This verifies the database RPC logic; the deployed HTTP 429 path was not exercised because local HTTP requests fail through the environment proxy (`127.0.0.1:9`).
- `deno fmt` checked/formatted the three scorer TypeScript files; `deno check` passed. `deno test` was attempted twice and both attempts panicked in Deno 2.9.7 on Windows (`Unexpected client pipe failure`, invalid handle); the unit test suite did not run.
- Flutter verification commands were attempted again, but overlapping Flutter CLI invocations produced no output and were interrupted. A later sequential `flutter pub get` also produced no output and was interrupted. Therefore this refresh does not claim new Flutter results; the preceding successful results below remain historical evidence for the unchanged Dart code.
- There are still no approved quizzes or content. No successful guest/authenticated score, retake, server idempotency, authenticated consent flow, or account isolation was tested. No physical device, emulator or browser was available for visual verification in this refresh; the earlier limitation below still applies.

| Exact command/action | Result |
| --- | --- |
| `flutter pub get` | Passed; dependency constraints resolved; pinned versions were not upgraded. |
| `flutter gen-l10n` | Passed using `l10n.yaml`; Flutter printed its expected informational note. |
| `dart format lib test` | Passed; 31 files checked, 0 changed. |
| `flutter analyze` | Passed; no issues found. |
| `flutter test` | Passed; all 26 tests passed. |
| `flutter build apk --debug` | Passed; `build/app/outputs/flutter-apk/app-debug.apk` generated. |
| `flutter build web` | First attempt stalled without output and was interrupted; retry `flutter build web --no-pub` passed in 61.1 seconds and produced `build/web`. Non-blocking Wasm incompatibility and unused Cupertino icon-font warnings were emitted. |
| `flutter run -d chrome --dart-define-from-file=config/supabase.local.json --web-port=55321` | Started but did not connect to the debug service; interrupted. CUA reported local browser use is disabled, so no visible rendering or console verification was possible. |
| `deno check supabase/functions/submit-assessment/index.ts supabase/functions/submit-assessment/logic.ts supabase/functions/submit-assessment/logic_test.ts` | Passed; no diagnostics. |
| `deno test supabase/functions/submit-assessment/logic_test.ts` | Passed; 6 tests, 0 failures. |
| Read-only Supabase migration/function/table/advisor inventory | Passed; expected project and two migration versions confirmed; scorer active, 22 Phase 3 tables RLS-enabled and empty. |
| Direct remote SQL catalog checks | Passed; policies show user-owned progress and consent-gated reads/writes; answer-key/explanation tables deny client SELECT; scorer RPC is service-role only. |
| Deployed scorer HTTP checks (local publishable key only) | Passed expected negative responses: missing key 401, malformed guest body 400, invalid user token 401, absent assessment 400. No positive score was fabricated. |
| Reference APK search | No reference APK found; only project build outputs exist. UI parity comparison is not possible. |

The table below is the immediately preceding verification snapshot. The final continuation refresh above supersedes its migration count and function version. The database still contains no approved assessment content, so a valid successful score, duplicate/idempotent server retry, retake, interrupted network submission against a live quiz, or authenticated consent/account-isolation workflow could not be exercised. pgTAP remains unrun because `pgtap` is absent remotely and Docker engine access is unavailable. Browser-visible verification remains incomplete.

## Latest Phase 3 backend deployment verification (2026-10-30)

This is the current backend state and supersedes pre-deployment statements in the dated snapshots below. The target was the development project `yegna-health-amharic` (`oflkhtjskpsedsuczfkj`); no production migration, content, or deployment was performed.

| Exact command/action | Result |
| --- | --- |
| `npx.cmd --yes --package=supabase supabase --version` | Passed; Supabase CLI 2.122.0. |
| `npx.cmd --yes --package=supabase supabase db push --linked --dry-run --skip-vault` | Did not complete; stalled at `Initialising login role` and was interrupted after about one minute. No migration plan was returned. |
| `npx.cmd --yes --package=supabase supabase db push --linked --skip-vault --yes` | Did not complete; stalled at `Initialising login role` and was interrupted before applying through the CLI. |
| Supabase remote migration tool: base migration | First attempt failed with PostgreSQL `42703` (missing `published_at` on assessment translations) and rolled back. After fixing the column and publication trigger, the migration applied successfully. |
| Supabase remote migration tool: sync-retry guard | Passed; second additive migration applied successfully. Remote migration versions are `20261030174702` and `20261030174920`; matching local filenames are present. |
| Remote schema inventory/catalog checks | Passed: 17 public app tables and 5 private tables exist, all empty with RLS enabled; 42 indexes were listed. Twenty-three read-only security assertions passed for grants, answer-key privacy, scorer execution, consent-gated progress access, and retry-consent ordering. |
| Remote pgTAP security test | Not run: `pgtap` is not installed in the remote project, and the Docker engine is unavailable for `supabase test db`. The matching catalog assertions were run directly as read-only SQL; they are not a pgTAP run. |
| `npx.cmd --yes --package=supabase supabase functions deploy submit-assessment --use-api --no-verify-jwt --project-ref oflkhtjskpsedsuczfkj` | Passed; function is `ACTIVE`, version 1, with `verify_jwt=false` for guest access. |
| Deployed function HTTP checks | Passed expected responses: no API key → 401 `api_key_required`; guest invalid body → 400 `invalid_submission`; invalid user bearer → 401 `invalid_session`; synthetic assessment ID → 400 `invalid_answers` because no published quiz exists. |
| Function runtime logs | Sampled after requests; only normal `booted` messages appeared, no logged runtime errors. No credentials or request headers were queried. |
| `deno check supabase/functions/submit-assessment/index.ts supabase/functions/submit-assessment/logic.ts` | Passed. |
| `deno test supabase/functions/submit-assessment/logic_test.ts` | This turn's attempt failed before tests ran: Deno 2.9.7 panicked on Windows with `Unexpected client pipe failure` / invalid handle. An earlier recorded run passed all 6 tests; the failed rerun does not replace that historical result. |

No reviewed English/Amharic article or assessment content exists in the development database. Therefore, successful scoring, correct-answer feedback, valid retakes, duplicate/idempotent retry behavior, interrupted-submission recovery against the server, and authenticated cloud progress/account-isolation flows could not be tested without inventing unreviewed content or using a real user session. They remain open. Guest scoring has no application-level rate limit yet. Security Advisor also reports intentionally policy-less private tables (deny-all), the authenticated clear-history `SECURITY DEFINER` function, disabled leaked-password protection, and performance advisories for some foreign-key indexes and `auth.uid()` policy expressions; see `PHASE_STATUS.md` for details.

## Pre-deployment Phase 3 local checks (2026-10-30)

This dated snapshot records client-side checks before backend deployment; the current remote backend results are at the top of this document.

The initial Phase 3 verification attempt was blocked by Windows process permissions. After running the SDK commands with the required process access, the following final checks completed on 2026-10-30:

| Exact command | Result |
| --- | --- |
| `flutter pub get` | Passed; dependencies resolved with no dependency upgrades. |
| `flutter gen-l10n` | Passed using the existing `l10n.yaml`. Flutter printed its informational note that the YAML supplies options; it was retained. English and Amharic key parity test passed. |
| `dart format lib test` | Passed; final run checked 29 files, 0 changed. |
| `flutter analyze` | Passed; `No issues found!` |
| `flutter test` | Passed; all 26 tests passed, including learning UI, retry, cache, localization and existing auth/widget tests. |
| `flutter build apk --debug` | Passed; Gradle built `build/app/outputs/flutter-apk/app-debug.apk`. |
| `deno check supabase/functions/submit-assessment/index.ts supabase/functions/submit-assessment/logic.ts supabase/functions/submit-assessment/logic_test.ts` | Passed. |
| `deno test supabase/functions/submit-assessment/logic_test.ts` | Blocked by Deno 2.9.7 Windows panic (`Unexpected client pipe failure`, invalid handle). |
| Supabase database / pgTAP tests | Not run: Docker daemon is unavailable and Supabase CLI could not reach the hosted project through the current proxy. The migration remains unapplied. |
| Android emulator / visible interaction | Not run in this Phase 3 repair; APK packaging passed as listed above. |

Flutter widget tests cover Learn navigation and locale switching, article completion, quiz validation/result/retake, guest sync restriction, authenticated sync/history clear, pending-submission recovery after restart, and cache staleness/LRU. Supabase database integration remains unverified: the migration is still unapplied, the Edge Function undeployed, and no hosted RLS/scoring tests were run. TypeScript tests are present for request bounds, guest API-key bearer handling, invalid identifiers/locales, duplicate answers and stable payload fingerprints; Deno runtime execution remains blocked by the Windows pipe failure recorded below.

## Phase 1 owner-verified results

The project owner reported these earlier checks from Windows/Android Studio: `flutter pub get`, localization generation, `flutter create --platforms=android .`, `dart format lib test`, clean `flutter analyze`, all 4 then-existing tests, `flutter build apk --debug`, emulator launch/page behavior, English/Amharic switching and locale persistence after restart. The current assistant later independently reran the Phase 2 checks below.

## Phase 2 checks run in this workspace

Commands were run from the project root using the SDK referenced in `android/local.properties` (`C:\src\flutter_windows_3.47.8-stable\flutter`).

| Exact command | Result |
| --- | --- |
| `flutter pub get` | Passed; pinned dependencies resolved and lockfile updated. |
| `flutter gen-l10n` | Passed with the existing `l10n.yaml`; retained the file. |
| `dart format lib test` | Passed; final run: 18 files checked, 0 changed. |
| `flutter analyze` | Passed; no issues found (rerun during emulator diagnosis, 20.7 seconds). |
| `flutter test` | Passed; all 19 automated tests passed (rerun during emulator diagnosis). |
| `flutter build apk --debug --dart-define-from-file=config/supabase.local.json` | Passed; rerun during emulator diagnosis, Gradle `assembleDebug` built the debug APK in 53.9 seconds. |
| Android emulator / visible interaction | The API 37 AVD with default `auto` graphics showed black output and ignored taps. The same AVD relaunched with `-gpu host` rendered Home visibly. ADB taps opened Home → Account → Sign in, Create account, bottom-nav Services and Settings → Account. Settings Account opened Sign in. This confirms rendering and navigation in that host-GPU session; provider-backed flows were not part of this emulator interaction check. |

The test suite covers input validation, pending email confirmation, confirmed-session gate, safe provider errors, recovery response enumeration safety, profile display-name update, recovery event, unconfigured-provider behavior, locale preference, ARB key parity, app startup, Home-to-account navigation, guest/public navigation, sign-in validation, registration/recovery navigation, Amharic auth UI, registration verification-pending UI, and authenticated profile edit/sign-out navigation. Fake repositories are used; the tests do not send real email or call Supabase.

## Provider checks and settings

Dashboard configuration was inspected: Email enabled and Confirm email enabled. `com.yegnahealth.amharic://auth-callback` was added to the Auth redirect allowlist and the matching Android intent filter is present. Separately, the owner reports successful real-account manual testing of registration, email confirmation, sign-in, profile editing, sign-out and password recovery. This is owner-reported verification and was not independently repeated in this workspace. Automated test results below remain separate and use fakes; they do not constitute provider-backed testing.

Not independently performed in this workspace: the owner-reported live flows listed above, and session-expiry testing. SMTP configuration and production email delivery, sender identity, deliverability, provider limits and production behavior remain unverified. Automated tests and a debug APK do not establish production email readiness. Use a designated development account; do not put its credentials in source or test output.

## Not verified / future checks

- Physical-device testing, additional display sizes, large text and accessibility review.
- The AVD's default `auto` graphics behavior remains problematic on this host unless launched with `-gpu host`; that launch override was verified, but the persistent AVD configuration was not changed.
- Native Amharic medical-language expert review and clinical content approval before publication.
- Supabase SMTP configuration and production email delivery, sender identity, deliverability and provider-limit review.
- Release APK/AAB preparation and signing, production deployment, security audit and privacy/jurisdiction review.
- Future health features or backend database/RLS policies.

Do not describe unperformed checks as passed. Phase 2 is complete according to the owner's report of successful real-account manual testing of registration, email confirmation, sign-in, profile editing, sign-out and password recovery. The automated test suite uses fakes and does not independently verify those live flows. Production-readiness items above remain open.

## Flutter Web preview verification (2026-10-30)

- Launched the app in Google Chrome at `http://localhost:54752/` using `flutter run -d chrome --dart-define-from-file=config/supabase.local.json`. The app initialized Supabase and rendered the Flutter UI. Home was visibly rendered in English and Amharic.
- Manually tapped the Home Account entry, guest continuation, Learn/Articles and Assessments tabs, Services and Settings navigation, registration, and password-recovery navigation. The public shell/navigation and auth forms were responsive. Guest continuation returned to public Home. Language switching to Amharic updated the shell and screen text, including the Learn error state; locale persistence in a browser restart was not tested.
- Learn Articles and Assessments both displayed the app's localized connection/unavailable state. No article detail or quiz attempt could be exercised; this run does not verify the content backend or quiz scoring. No credentials were submitted. Live browser authentication, email delivery, authenticated profile behavior, and profile protection were not tested in Chrome.
- Chrome DevTools was not successfully opened through the available UI automation, so browser console errors are **unverified**. The `flutter run` output showed app startup and Supabase initialization and no Flutter runtime error in the captured output; this is not a substitute for inspecting the browser console.
- Web preview limitations: Supabase browser redirect allowlisting for this localhost origin and production origin still needs explicit verification/configuration in the approved Supabase project. No remote settings were changed. Browser secure storage relies on the web platform implementation and should be validated under HTTPS before production. The web learning cache is in-memory and does not persist across browser reloads. This is a development preview, not production readiness.

## Full local Phase 3 check snapshot before backend deployment (2026-10-30)

| Exact command/action | Result |
| --- | --- |
| `flutter pub get` | Passed; no dependency upgrades. |
| `flutter gen-l10n` | Passed using existing `l10n.yaml`; its informational message was expected. |
| `dart format lib test` | Passed; 31 files checked, 0 changed. |
| `flutter analyze` | Passed; `No issues found!` |
| `flutter test` | Passed; all 26 tests. |
| `flutter build apk --debug` | Passed; `build/app/outputs/flutter-apk/app-debug.apk` built. |
| `flutter build web` | Passed; standard JavaScript output built at `build/web`. Wasm dry-run warnings identify `flutter_secure_storage_web` use of `dart:html`/`dart:js_util`; an unused Cupertino icon-font warning was also emitted. Neither blocked the JavaScript build. |
| `deno check supabase/functions/submit-assessment/index.ts supabase/functions/submit-assessment/logic.ts supabase/functions/submit-assessment/logic_test.ts` | Passed. |
| `deno test supabase/functions/submit-assessment/logic_test.ts` | Passed; 6 tests, 0 failures. This supersedes the earlier Deno pipe panic. |
| `docker --version` / `docker info` | Docker CLI 29.8.0 is installed; engine access failed with permission denied for `npipe:////./pipe/dockerDesktopLinuxEngine`. |
| `npx --yes --package=supabase supabase --version` | Passed; official npm/npx CLI version 2.122.0 used ephemerally, without adding a Node dependency to the Flutter project. |
| `npx --yes --package=supabase supabase projects list` | Passed; the CLI session was authenticated and listed the confirmed project. |
| `npx --yes --package=supabase supabase migration list --project-ref oflkhtjskpsedsuczfkj` | Did not complete; stalled at `Initializing login role` and was interrupted. Supabase MCP read-only migration inventory returned no migrations. |
| Supabase MCP read-only project/schema/function inventory | Confirmed active/healthy project `yegna-health-amharic`, PostgreSQL 17, and no app migrations/tables/Edge Functions. A post-rejection recheck returned the same state. |
| Supabase MCP remote migration apply | Rejected by automatic approval review as a high-risk schema mutation. No remote change occurred; no indirect workaround was attempted. The reviewed local draft remains unapplied and no Edge Function was deployed. |

The latest Flutter and Deno results supersede earlier workspace entries saying those test runners were blocked. Database migration replay, pgTAP, live RLS, Edge Function deployment/integration, guest/authenticated scoring and progress synchronization still have not passed. The local migration is not verified by a PostgreSQL parser/runtime in this environment. Phase 3 remains incomplete without backend deployment/verification and professionally reviewed English/Amharic content.
