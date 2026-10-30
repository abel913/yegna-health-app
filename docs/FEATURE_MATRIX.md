# Feature inventory

Evidence basis: user-provided project requirements. No original APK or verified product behavior was available for comparison.

| Feature area | Evidence / status | Planned phase | Open questions |
| --- | --- | --- | --- |
| Bilingual app shell | Implemented and Phase 1 verified; locale parity remains automated | 1 | Verify Amharic layout and fluent copy |
| Registration, login, email confirmation, recovery, profile, guest | Implemented with approved Supabase Auth; reachable from Home and Settings; 19 automated tests pass; emulator rendering and navigation manually verified with host graphics | 2 | Verify provider email delivery and live account lifecycle; persist AVD graphics workaround if needed; Amharic review |
| Account settings and sign-out | Implemented for confirmed sessions; provider-backed with controller/widget coverage | 2 | Verify using a live development account and expired session |
| Education, categories, FAQs | Not implemented; no content fabricated | 3 | Reviewed sources, editorial owner, licensing |
| Assessments, results, history | Not implemented | 3 | Validated methodology, clinical review, data retention |
| Facilities, maps, university mapping | Not implemented; no addresses fabricated | 4 | Authoritative dataset, map provider, update process |
| Mentors/professionals | Not implemented | 4 | Credential verification, availability, safety model |
| Notifications/preferences | Not implemented | 5 | Consent, provider, delivery and retention policy |
| Settings, language, theme, text size, accessibility, privacy | Locale selector implemented in source; rest planned | 1/5 | Accessibility and platform validation |
| Caching/offline | Not implemented | 5 | Offline scope and health-data sensitivity |
| Backend/security/release | Not implemented | 6 | Requirements, threat model, hosting, jurisdiction |

Status vocabulary: implemented (verified), implemented (unverified), planned, blocked. Auth code and automated tests are locally verified; provider email delivery and real-account end-to-end remain unverified. Nothing here claims original-app feature parity.
