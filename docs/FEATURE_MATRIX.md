# Feature inventory

## Current evidence (2026-10-31)

- **Implemented locally; automated Flutter coverage passes:** localized article/assessment browsing and detail flows, client-side validation/answer selection, server-result presentation/retry state, local caching and guest progress, opt-in sync UI, account progress/history controls, and five-destination navigation. `flutter test` currently passes all 27 tests.
- **Backend deployed; structural checks pass:** four additive migrations and `submit-assessment` v2 are present in development. All 23 Phase 3 tables have RLS. Answer keys and private limiter data are not client-readable; privileged scoring/limiter RPC execution is restricted to `service_role`. Publication correlation was corrected and verified remotely.
- **Live behavior verified only for rejection paths:** API key required (401), malformed body (400), invalid bearer (401), method restriction (405), and an invalid-answer guest request (400). Database limiter threshold logic permits 20 and rejects 21 in one window.
- **Not verified / unavailable:** no reviewed public categories/articles/quizzes; no successful score, authenticated score, optional cloud sync, retry/retake, history isolation, stale content withdrawal behavior against published content, or real 429 response. No Deno test suite or pgTAP suite ran successfully. Mentors/Facilities remain truthful empty presentation states; no fake data.

Phase 3 is **PARTIAL**, not complete. Phase 4 is not started.

Evidence basis: user-provided project requirements. No original APK or verified product behavior was available for comparison.

| Feature area | Evidence / status | Planned phase | Open questions |
| --- | --- | --- | --- |
| Bilingual app shell and five-destination navigation | Implemented; English/Amharic labels regenerated and navigation widget-tested | 1 / UI integration | Run device/screenshot and accessibility review for Amharic layout |
| Registration, login, email confirmation, recovery, profile, guest | Implemented with approved Supabase Auth; reachable from Home and Settings; 19 automated tests pass; emulator rendering and navigation manually verified with host graphics | 2 | Owner reports successful real-account manual tests of registration, confirmation, sign-in and recovery; SMTP/production delivery, session expiry and Amharic review remain open |
| Account settings and sign-out | Implemented for confirmed sessions; provider-backed with controller/widget coverage | 2 | Owner reports successful real-account manual tests of profile editing and sign-out; session expiry remains unverified |
| Education categories, bilingual article library/details, search, sources and related links | Flutter browsing/detail UI and repository implemented; development schema/RLS deployed and verified; no content seeded | 3 | Supply licensed, professionally reviewed EN/AM content; validate Amharic search on reviewed corpus and live article flows |
| Assessments, server scoring, results, retake and pending retry | Flutter UI/retry, scorer, and schema deployed; negative endpoint checks and local UI/retry tests pass; no quizzes seeded | 3 | Verify valid guest/auth scoring, idempotency, retakes and explanations against approved quiz content |
| Learning progress, guest local records and opt-in sync | Local records/cache and opt-in sync implemented; consent/ownership RLS deployed and catalog-verified; no live sync test | 3 | Run authenticated sync, clear-history, disable-consent and account-isolation tests |
| Facilities, maps, university mapping | Presentation-only localized empty screen; controls disabled; no records or addresses fabricated | 4 (UI shell only in current integration) | Authoritative dataset, map provider, update process; real directory feature not implemented |
| Mentors/professionals | Presentation-only localized empty screen; controls disabled; no profiles fabricated | 4 (UI shell only in current integration) | Credential verification, availability, safety model; real directory feature not implemented |
| Notifications/preferences | Not implemented | 5 | Consent, provider, delivery and retention policy |
| Settings, language, theme, text size, accessibility, privacy | Locale selector implemented in source; rest planned | 1/5 | Accessibility and platform validation |
| Public education cache/offline | Local app-support cache (7-day stale threshold, 50 MiB LRU) and browser in-memory cache implemented; cache tests pass; no offline score | 3 | Verify actual device/browser offline and withdrawal behavior with reviewed content |
| Backend/security/release | Phase 3 schema/scorer and shared guest limiter deployed to development; catalog/RPC threshold checked; full integration/security/release readiness unverified | 4/6 | HTTP limiter verification, pgTAP and positive scoring/sync integration, threat model, hosting, jurisdiction, release signing |

Status vocabulary: implemented (verified), implemented (unverified), planned, blocked. Auth code and automated tests are locally verified; the owner separately reports successful real-account manual testing of the listed flows. Automated tests use fakes and do not call Supabase. SMTP configuration and production email delivery remain unverified. Nothing here claims original-app feature parity.
