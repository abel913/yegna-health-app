# Project master plan

## Product and evidence

Yegna Health Amharic is an independent Android-first health education and service app for English- and Amharic-speaking users. The only repository content before Phase 1 was a minimal README. No reference APK was present in the project. Original product behavior, content, providers, maps, and backend remain unverified. Do not imply affiliation with another app owner.

## Planned capabilities

Registration/login/OTP/recovery/profile/guest; health education/categories/FAQs; assessments/results/history; facility discovery/maps/university mapping; mentor/professional discovery; notifications/preferences; language/theme/text-size/accessibility/privacy; offline caching; secure backend integration; testing and release. These are plans, not verified parity requirements. See `FEATURE_MATRIX.md`.

## Architecture direction

Flutter + Dart, Material 3, standard Flutter ARB localization with generated `AppLocalizations`, a thin presentation shell, and small services/controllers behind clear boundaries. Supabase Auth is approved for Phase 2; auth uses a repository/controller boundary and platform secure storage for session and PKCE material. Public health data and other backend features remain out of scope. See `ARCHITECTURE.md` and `DECISIONS.md`.

## Phases and acceptance criteria

1. **Foundation — verified:** Material 3 shell/navigation; English and Amharic infrastructure and persisted selector; initial tests; debug build and emulator behavior verified by the owner.
2. **Authentication and profiles — owner reports complete:** owner approved Supabase Auth email/password with email confirmation and recovery. Registration, login, verification-pending, recovery/reset, guest browsing, profile editing, sign-out and bilingual states are implemented. The owner reports manual Phase 2 testing completed; see `PHASE_STATUS.md` and `TESTING.md` for the recorded workspace checks and their evidence boundaries.
3. **Education and assessments:** reviewed, attributable content and localization; assessment methodology and history designed responsibly.
4. **Facilities, maps, FAQs, professional support:** verified data sources, consent/privacy, accurate boundaries and localization.
5. **Notifications, personalization, accessibility, offline:** user controls, accessibility and offline behavior verified and tested.
6. **Backend, comprehensive testing, security, release:** authorized integration, security review, operational documentation and release readiness.

Phase order may be refined with the owner; do not silently advance or build simulated production behavior. Phase 3 is currently in planning only and implementation has not started. See `PHASE_3_IMPLEMENTATION_GUIDE.md` for the finalized technical preparation.
