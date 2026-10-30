# Windows setup

1. Install Git for Windows, Flutter stable (including bundled Dart), Android Studio, and an Android SDK through Android Studio's SDK Manager.
2. Add the Flutter `bin` directory to the user PATH. Restart PowerShell and confirm `flutter --version` and `dart --version` return.
3. Run `flutter doctor -v`; accept Android SDK licenses with `flutter doctor --android-licenses` and address reported Android toolchain items.
4. In the project directory, run:

```powershell
flutter pub get
flutter gen-l10n
dart format lib test
flutter analyze
flutter test
flutter devices
flutter run --dart-define-from-file=config/supabase.local.json
```

5. Keep `config/supabase.local.json` Git-ignored; use `config/supabase.example.json` only as a shape example. It should contain the project's Supabase URL and publishable client key; never use a service-role/secret key in the app.
6. Supabase Auth URL Configuration must allow `com.yegnahealth.amharic://auth-callback`; Email and Confirm email must remain enabled. Configure appropriate SMTP before relying on verification/recovery messages to arbitrary recipients.
7. In the app, use **Settings** for English/Amharic, then open Account to test guest/account flows. Use a designated development account for live auth checks; automated tests use fakes.

## This workspace's tool configuration

An extracted SDK folder exists at `C:\src\flutter_windows_3.47.8-stable\flutter`; it is not on PATH, and Flutter needs write access to its SDK cache to run. Phase 2 commands were successfully run here using its absolute executable path and approved access. See `TESTING.md` for actual command results. Android Studio and Android SDK are configured on this machine. Use the normal PATH setup above on a developer workstation.
