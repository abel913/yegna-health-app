# Testing strategy and results

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
| Android emulator / visible interaction | The API 37 AVD with default `auto` graphics showed black output and ignored taps. The same AVD relaunched with `-gpu host` rendered Home visibly. ADB taps opened Home → Account → Sign in, Create account, bottom-nav Services and Settings → Account. Settings Account opened Sign in. This confirms rendering and navigation in that host-GPU session; real provider-backed login was not exercised. |

The test suite covers input validation, pending email confirmation, confirmed-session gate, safe provider errors, recovery response enumeration safety, profile display-name update, recovery event, unconfigured-provider behavior, locale preference, ARB key parity, app startup, Home-to-account navigation, guest/public navigation, sign-in validation, registration/recovery navigation, Amharic auth UI, registration verification-pending UI, and authenticated profile edit/sign-out navigation. Fake repositories are used; the tests do not send real email or call Supabase.

## Provider checks and settings

Dashboard configuration was inspected: Email enabled and Confirm email enabled. `com.yegnahealth.amharic://auth-callback` was added to the Auth redirect allowlist and the matching Android intent filter is present. These settings do not verify delivery or a complete user flow.

Not performed: live sign-up and confirmation link open on device; live sign-in; recovery/reset link; profile edit on a real account; session expiry; email delivery. The project's SMTP settings have not been inspected. Supabase documents that its built-in hosted sender only delivers to organization team addresses and is currently limited to 2 messages/hour; use custom SMTP for other recipients. Automated tests and a debug APK are not substitutes for these checks. Use a designated development account; do not put its credentials in source or test output.

## Not verified / future checks

- Physical-device testing, additional display sizes, large text and accessibility review.
- The AVD's default `auto` graphics behavior remains problematic on this host unless launched with `-gpu host`; that launch override was verified, but the persistent AVD configuration was not changed.
- Fluent/native Amharic approval.
- Release APK/AAB, production signing/deployment, security audit, privacy/jurisdiction review, or production SMTP.
- Future health features or backend database/RLS policies.

Do not describe unperformed checks as passed. Phase 2 remains in progress until provider email and account lifecycle checks succeed.
