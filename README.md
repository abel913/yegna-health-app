# Yegna Health Amharic

An Android-first health education and service app planned for English- and Amharic-speaking users. The Phase 1 foundation is verified. Phase 2 email/password account flows use the owner-approved Supabase Auth development project; live email and account end-to-end checks are still pending. Health content, assessments and production backend data features are not implemented.

## Prerequisites

- Windows 10/11, Git, Flutter stable with Dart, Android Studio, and an Android SDK.
- An Android emulator or device for Android verification. Flutter web is available for a quick UI check.
- See [docs/SETUP_WINDOWS.md](docs/SETUP_WINDOWS.md) for setup and diagnostics.

## Setup and run

From PowerShell in this folder:

```powershell
flutter doctor -v
flutter pub get
flutter gen-l10n
flutter run --dart-define-from-file=config/supabase.local.json
```

Create `config/supabase.local.json` from the placeholder structure in `config/supabase.example.json`, using the Supabase project URL and **publishable** client key. The local file is ignored by Git. Do not place a service-role or secret key in a mobile app.

For a browser preview, use `flutter run -d chrome`. Choose **Settings** in the bottom navigation, then use the language menu to switch between English and Amharic. The selected locale is saved on device.

## Verify

```powershell
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Read [docs/PHASE_STATUS.md](docs/PHASE_STATUS.md) and [docs/HANDOFF.md](docs/HANDOFF.md) for verified results and remaining work. Supabase Auth URL Configuration must allow `com.yegnahealth.amharic://auth-callback`, and email confirmation should remain enabled. Configure SMTP before relying on live email delivery. Generated localization files are produced by `flutter gen-l10n` and are not hand-edited. Release builds, physical-device testing, production deployment and live email/account flows are not verified.
