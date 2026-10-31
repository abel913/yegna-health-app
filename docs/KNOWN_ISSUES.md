# Known issues and limitations

## Final Phase 3 blockers and security notes (2026-10-31)

- Development content is empty. Professionally reviewed and approved bilingual content is required before articles or quizzes can be published; do not seed or publish fabricated health content. Positive scoring and authenticated sync/retry/isolation cannot be verified without an approved quiz and a dedicated development test user.
- The database rate-limit function passed a 20/21 threshold check, but the deployed Edge Function's actual HTTP 429 was not exercised. A reserved `X-Forwarded-For` value was not recorded as the caller address at ingress. Repeating calls risks throttling a shared gateway address; use an isolated test network/IP for the HTTP test. Expiry is opportunistic (older rows are removed when the function is called), not scheduled.
- Local `deno fmt --check` and `deno check` pass, but Deno 2.9.7 `deno test` panics on Windows named-pipe handles before running tests. A direct `deno eval` harness passed the six logic assertions. Docker Desktop's Linux engine is unavailable, and the remote project does not have pgTAP, so the SQL pgTAP runner was not executed; all 26 corresponding read-only catalog assertions and the remote reserved-IP threshold check passed.
- Supabase security advisor still reports leaked-password protection disabled and the authenticated SECURITY DEFINER history-clear RPC. The function checks `auth.uid()` and scopes updates to that user, but live isolation testing is outstanding. Six private tables have RLS enabled with no policies (intentional default-deny). Performance advisories report 13 unindexed FKs and 7 RLS init-plan findings; assess before production.
- Flutter Web JS build passes, but the Wasm dry-run identifies the existing secure-storage Web package's legacy `dart:html`/`dart:js_util` imports as Wasm-incompatible. Browser UI/console inspection, release signing/build, physical device, production deploy, SMTP delivery and full security audit remain unverified.

Phase 3 remains PARTIAL; Phase 4 has not started.

## Stitch UI integration (2026-10-30)

- Facilities and Mentors screens are localized empty-state presentation only. Search, filters, contact actions, map behavior, and directory records are unavailable until a verified data source and separately authorized scope exist.
- No Android emulator or physical device was connected during this integration verification. Amharic shaping/overflow and visual comparison against Stitch screenshots remain unverified on-device; automated widget tests and a successful debug APK build were completed.
- Phase 3 content/backend positive integration gates remain open; this UI integration does not mark Phase 3 complete.

- **Historical snapshot only (2026-10-30):** the then-current record described three deployed migrations and stalled Flutter attempts. The 2026-10-31 final verification supersedes it: four migration records are present, Flutter tests and builds passed, and the assessment policy correction is applied. Phase 3 is still incomplete because there is no reviewed content, no positive scoring/authenticated sync test, and HTTP 429, pgTAP and account-isolation verification remain outstanding.
- A fresh Supabase CLI was available ephemerally through the official npm/npx package at version 2.122.0. CLI project listing and Supabase MCP read-only inventory confirmed the `yegna-health-amharic` project. Docker CLI 29.8.0 is installed, but `docker info` cannot connect to `npipe:////./pipe/dockerDesktopLinuxEngine`. Docker Desktop's Linux engine remains unavailable.
- Current remote state: the authorized development migrations and scorer are deployed. Older text below describing a rejected migration or absent backend is historical and superseded by `PHASE_STATUS.md` and `TESTING.md`.
- No professionally reviewed English/Amharic articles, categories or quiz content have been supplied or seeded; the public library/assessment list is expected to be empty. Amharic search uses basic literal client filtering; a database search strategy awaits evaluation against reviewed Amharic data.
- Guest scoring is unauthenticated at the user-account layer but requires the public API key and bounded payload. A shared database-backed limit now allows 20 valid-shaped submissions per forwarded client IP per 10-minute fixed window and retains counters for at most one day. The database threshold/security checks passed; deployed HTTP `429` behavior and trustworthiness of the forwarded-IP header through the configured gateway still need an end-to-end request test. Operational monitoring and resistance to distributed IP abuse are not established.
- Current Windows shell HTTP calls are blocked by the configured proxy endpoint `127.0.0.1:9`; do not interpret this as an Edge Function failure. Deno 2.9.7 tests panic on an invalid pipe handle on this host; use a supported Deno environment to run them.
- Offline cached articles may remain available after withdrawal until the app reconnects; they carry a stale/possibly-withdrawn warning. Offline quiz scoring is unavailable. The 7-day threshold and 50 MiB cap are technical defaults, not clinical guidance.

- The owner reports successful real-account manual testing of registration, email confirmation, sign-in, profile editing, sign-out and password recovery. This report was not independently repeated in the latest workspace checks. Session-expiry behavior remains unverified.
- On this host, the API 37 `Medium_Phone_API_37.0` AVD using its default `auto` graphics mode showed black captures and ignored ADB taps, including native Settings interaction. Relaunching the same AVD with `-gpu host` (Intel Iris Xe) restored visible Flutter rendering and tap navigation. The emulator's persisted AVD graphics setting was not changed; relaunch with host graphics or select hardware/host graphics in Device Manager if the issue returns.
- Supabase SMTP configuration and production email delivery, sender identity, deliverability and provider limits have not been verified. Check the current provider limits and configure appropriate SMTP before production use.
- The Supabase project is a development integration. No production deployment, security audit, privacy/jurisdiction review, RLS-backed profile table, or release signing has been completed.
- The app profile currently includes only email and editable display name. The display name is stored in user-editable Auth `user_metadata` for presentation only; it is not suitable for authorization or trusted claims.
- Phone OTP, OAuth/social providers, MFA and account deletion/export are not implemented or included in the approved Phase 2 scope.
- Native Amharic medical-language expert review and clinical content approval remain required before health content publication. Physical-device compatibility, additional screen sizes, large text and accessibility review remain unreported.
- Health learning/services remain placeholders. No reference APK was available, so original behavior and feature parity are not established.
- Debug APK build, static analysis, and automated tests pass; release builds/signing remain unverified (see `TESTING.md`).

## Latest Phase 3 verification (2026-10-30)

The latest run supersedes earlier workspace notes that Flutter and Deno tests were blocked: `flutter analyze` passed with no issues, all 26 `flutter test` cases passed, `deno check` passed, and all 6 Edge Function logic tests passed. The Android debug APK and standard JavaScript Web build succeeded. The Web build reports that `flutter_secure_storage_web` uses APIs incompatible with Wasm and warns about an unused Cupertino icon font; these did not prevent the JavaScript build.

The reviewed migrations are applied and the scorer is active in development. Latest local Flutter checks passed (26 tests, analysis, localization generation and Android debug build); Deno check and 6 logic tests passed. The current Web build/Chrome launch did not complete. No clinical content has been provided or published.
