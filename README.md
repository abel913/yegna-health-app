# Yegna Health Amharic

An Android-first health education and service app for English- and Amharic-speaking users. Phase 1 is verified, and the owner reports successful manual Phase 2 Supabase Auth testing. Phase 3 Flutter learning features are implemented locally; four additive migrations and `submit-assessment` v2 are deployed to the development Supabase project. A publication-policy correlation defect was corrected in the fourth migration. The education and progress tables remain empty and no professionally reviewed content has been published, so successful scoring, authenticated sync, and end-to-end learning are not yet verified. See `docs/PHASE_STATUS.md` for current results and limits.

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

The linked development project already has the Phase 3 migrations and `submit-assessment` function. The education library remains empty until professionally reviewed English and Amharic content is entered and approved. Guest submissions are limited to 20 per client IP per fixed 10-minute window. Expired rate-limit rows are removed opportunistically on later guest calls; cleanup is not scheduled. For a separate local stack, apply reviewed migrations and configure the Edge Function only in a trusted server environment; never put service-role credentials in the Flutter define file.

Create `config/supabase.local.json` from the placeholder structure in `config/supabase.example.json`, using the Supabase project URL and **publishable** client key. The local file is ignored by Git. Do not place a service-role or secret key in a mobile app.

For a browser preview, use `flutter run -d chrome`. Choose **Settings** in the bottom navigation, then use the language menu to switch between English and Amharic. The selected locale is saved on device.

## Verify

```powershell
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Read [docs/PHASE_STATUS.md](docs/PHASE_STATUS.md) and [docs/HANDOFF.md](docs/HANDOFF.md) for results and remaining work. Supabase Auth URL Configuration must allow `com.yegnahealth.amharic://auth-callback`, and email confirmation should remain enabled. Owner-reported Phase 2 development flows are successful; SMTP and production delivery remain unverified. Generated localization files are produced by `flutter gen-l10n` and are not hand-edited. Phase 3 remains incomplete: no reviewed content is present and positive scoring/sync have not been verified. The database limit logic passed a 20/21 threshold check, but a live HTTP 429 response was not exercised because the gateway did not retain the reserved test IP header. Release builds, physical-device testing, production deployment and security audit are not verified.
