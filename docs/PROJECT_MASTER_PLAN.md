# Project master plan

## Current phase gate (2026-10-31)

Phase 3 implementation is present locally and the development schema/scoring Edge Function are deployed. The fourth additive migration corrects the published-assessment RLS correlation. Phase 3 remains PARTIAL: the remote education/progress tables are empty; no professionally reviewed content exists; successful live scoring, authenticated synchronization, retries/retakes and isolation have not been demonstrated. Flutter checks currently pass (27 tests, clean analysis, Android debug and standard Web builds). Database pgTAP and Deno runtime tests remain blocked by missing Docker/pgTAP and a Windows Deno 2.9.7 pipe panic. Do not start Phase 4 until Phase 3 acceptance is met and explicitly authorized.

## Product and evidence

Yegna Health Amharic is an independent Android-first health education and service app for English- and Amharic-speaking users. The only repository content before Phase 1 was a minimal README. No reference APK was present in the project. Original product behavior, content, providers, maps, and backend remain unverified. Do not imply affiliation with another app owner.

## Planned capabilities

Registration/login/OTP/recovery/profile/guest; health education/categories/FAQs; assessments/results/history; facility discovery/maps/university mapping; mentor/professional discovery; notifications/preferences; language/theme/text-size/accessibility/privacy; offline caching; secure backend integration; testing and release. These are plans, not verified parity requirements. See `FEATURE_MATRIX.md`.

## Architecture direction

Flutter + Dart, Material 3, standard Flutter ARB localization with generated `AppLocalizations`, a thin presentation shell, and small services/controllers behind clear boundaries. Supabase Auth is approved for Phase 2; auth uses a repository/controller boundary and platform secure storage for session and PKCE material. Public health data and other backend features remain out of scope. See `ARCHITECTURE.md` and `DECISIONS.md`.

## Phases and acceptance criteria

1. **Foundation — verified:** Material 3 shell/navigation; English and Amharic infrastructure and persisted selector; initial tests; debug build and emulator behavior verified by the owner.
2. **Authentication and profiles — owner reports complete:** owner approved Supabase Auth email/password with email confirmation and recovery. Registration, login, verification-pending, recovery/reset, guest browsing, profile editing, sign-out and bilingual states are implemented. The owner reports manual Phase 2 testing completed; see `PHASE_STATUS.md` and `TESTING.md` for the recorded workspace checks and their evidence boundaries.
3. **Education and assessments — implementation in progress:** Flutter library/assessment/progress work is implemented locally. Four additive migrations and `submit-assessment` v2 are deployed to the development Supabase project, including a shared guest scoring limiter and a correction to the assessment publication policy. The education schema is empty, no reviewed corpus exists, and positive scoring/sync integration is not verified; see `PHASE_STATUS.md` and `TESTING.md`. Do not call the phase complete yet.
4. **Facilities, maps, FAQs, professional support:** verified data sources, consent/privacy, accurate boundaries and localization.
5. **Notifications, personalization, accessibility, offline:** user controls, accessibility and offline behavior verified and tested.
6. **Backend, comprehensive testing, security, release:** authorized integration, security review, operational documentation and release readiness.

Phase order may be refined with the owner; do not silently advance or build simulated production behavior. Phase 3 is authorized and underway; Phase 4 has not started. See `PHASE_3_IMPLEMENTATION_GUIDE.md` for the approved design and current local implementation record.
