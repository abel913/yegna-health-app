# Phase status

## Current phase: 3 preparation — Health Education and Assessments (planning only; implementation not started)

**Phase 2 record:** The owner now reports Phase 1 and Phase 2 complete, including manual Phase 2 testing. Earlier workspace verification notes below retain their exact results and limitations. Supabase Auth is approved and configured for the development client.

**Phase 3 boundary:** The owner authorized final technical preparation only. `docs/PHASE_3_IMPLEMENTATION_GUIDE.md` records confirmed design decisions and proposed implementation. No Phase 3 implementation has started.

## Implemented

- Phase 1 Flutter Material 3 shell, English/Amharic localization, persisted language setting, and public placeholder tabs remain in place.
- Android platform scaffold was generated with `flutter create --platforms=android .`; Gradle uses Kotlin DSL (`.gradle.kts`).
- Supabase Auth registration, password sign-in, confirmation-pending state, password recovery/reset via PKCE deep links, profile display-name editing, protected profile route and sign-out.
- Public guest browsing remains available and does not create an anonymous Supabase user.
- All new auth/profile states, validation and safe error messages are localized in English and Amharic.
- Supabase session and PKCE verifier material use `flutter_secure_storage`; local client config is ignored by Git and a placeholder example is provided.
- Email provider and email confirmation are enabled in the dashboard. The exact callback `com.yegnahealth.amharic://auth-callback` is allowlisted and matched by the Android manifest intent filter.
- No public database tables or SQL migrations were created. Display name uses user-editable Auth metadata solely for display/editing, never authorization.
- No reference APK was present; this is an independent implementation and no original-app feature parity is claimed.

## Phase 2 verification in this workspace

- `flutter pub get` — passed; pinned dependencies resolved and lockfile updated.
- `flutter gen-l10n` — passed with existing `l10n.yaml`; Flutter printed its informational note that this YAML supplies options. It remains in place.
- `flutter gen-l10n` — passed; existing `l10n.yaml` remains in place.
- `dart format lib test` — passed; 18 files checked, 0 changed on the final run.
- `flutter analyze` — passed; no issues found after the Home account entry was added.
- `flutter test` — passed; all 19 tests passed, including Home account entry, form validation, registration/recovery navigation, guest access, Amharic UI, and authenticated profile edit/sign-out.
- `flutter build apk --debug --dart-define-from-file=config/supabase.local.json` — passed; debug APK built successfully (Gradle `assembleDebug`, 48.6 seconds).
- Emulator diagnosis — with the API 37 AVD's default `auto` graphics, screenshots were black and taps did not navigate. Relaunched the same AVD using `emulator -avd Medium_Phone_API_37.0 -gpu host -no-snapshot`; Flutter rendered visibly on the host's Intel Iris Xe GPU. ADB taps opened Home Account/sign-in, registration, bottom navigation (Services), and Settings → Account/sign-in. No application or Android project files were changed for this graphics workaround. The AVD's persistent graphics configuration remains unchanged.
- Supabase dashboard — Email enabled, Confirm email enabled, native callback allowlist configured. No secret values are stored in these docs.

Automated tests use a fake repository for deterministic validation/state/UI checks; they do not call Supabase or send real email. A passing build does not establish live account-flow success.

## Remaining work and limits

- Complete live Supabase email/account end-to-end testing. If the black surface returns, persist a suitable hardware/host graphics mode in Android Studio Device Manager for this AVD.
- Verify sign-up/confirmation deep link, sign-in, recovery/reset deep link, profile edit, sign-out and expired-session behavior using an approved development account.
- Inspect the project's SMTP settings and verify live delivery; the current configuration has not been inspected. Supabase documents that its built-in hosted sender only delivers to team addresses and is currently limited to 2 messages/hour, so configure SMTP for other recipients.
- Native/fluent Amharic review, additional screen sizes, large text and physical-device checks remain unreported.
- Release builds/signing, production deployment, security audit and production policy review are not complete.
- Health content, assessments, facilities/maps and notifications remain out of scope.

## Exact next action

Inspect SMTP settings, then complete provider-backed email and account lifecycle checks with an approved development account. Configure SMTP if needed and record actual results. Do not begin Phase 3.

## Phase 3 planning note

The owner requested a planning-only proposal, then finalized the Phase 3 technical decisions. `docs/PHASE_3_IMPLEMENTATION_GUIDE.md` is the current implementation preparation guide; `docs/PHASE_3_PLAN.md` is the earlier proposal. The current work is preparation only: Phase 3 implementation has **not** started, and no source or Supabase schema changes were made.
