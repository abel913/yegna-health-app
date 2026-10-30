# Handoff

## Current state

The owner reports Phase 1 and Phase 2 complete, including manual Phase 2 testing. Existing local records document Flutter tests/build and emulator UI navigation; older testing notes still contain provider-flow limitations, so use the owner's completion statement separately from those earlier workspace checks. Phase 3 technical preparation is documented in `docs/PHASE_3_IMPLEMENTATION_GUIDE.md`; implementation has not started.

## Implementation

- Added provider-independent auth models, validation, repository contract and controller; Supabase Auth adapter; localized registration/login/recovery/reset/profile states; guest access; profile edit and sign-out.
- Added direct Home access to the same auth/profile route to make Phase 2 visible from initial app launch.
- Session and PKCE verifier material use `flutter_secure_storage`. Only Supabase publishable client configuration is supplied at runtime. `config/supabase.local.json` is ignored and `config/supabase.example.json` contains placeholders.
- Supabase Email and Confirm email are enabled. Native callback `com.yegnahealth.amharic://auth-callback` is allowlisted in project settings and handled by Android intent-filter.
- No database schema/migration is present. Display name uses Auth `user_metadata` for display only and is never used for authorization.

## Commands/results

- `flutter pub get` — passed.
- `flutter gen-l10n` — passed using `l10n.yaml`.
- `dart format lib test` — passed (18 checked, 0 changed on final run).
- `flutter analyze` — passed (no issues).
- `flutter test` — passed (19 tests; widget coverage includes Home-to-account navigation, guest navigation, sign-in validation, registration/recovery navigation, Amharic auth UI, and authenticated profile edit/sign-out).
- `flutter build apk --debug --dart-define-from-file=config/supabase.local.json` — passed; debug APK built by Gradle in 48.6 seconds.
- Default AVD auto-graphics launch produced black captures and unresponsive taps. Relaunching `Medium_Phone_API_37.0` with `emulator -avd Medium_Phone_API_37.0 -gpu host -no-snapshot` (Intel Iris Xe) fixed visible rendering; ADB taps verified Home Account, registration, bottom navigation and Settings Account. The override is not saved into the AVD configuration.

The automated tests use fakes and do not contact Supabase. Live confirmation email, recovery email, deep-link exchange, account edits and sign-out have not yet been exercised with a real test account. Current SMTP settings have not been inspected; verify them and use an approved development account. Supabase's built-in sender has documented restrictions for non-team addresses and sending rate.

## Run on Windows

From PowerShell at the project root:

```powershell
flutter pub get
flutter gen-l10n
flutter run --dart-define-from-file=config/supabase.local.json
```

Keep `config/supabase.local.json` private and ignored. Do not use a service-role/secret key. If setting up another Supabase project, enable email confirmation and add `com.yegnahealth.amharic://auth-callback` to Auth URL Configuration's redirect allowlist. Ensure its Android intent filter still matches. Add SMTP if real recipient delivery requires it.

## Exact next step

The owner reports Phase 1 and Phase 2 complete, including manual Phase 2 testing. Earlier testing notes below record the evidence gathered in this workspace. The current authorized task was Phase 3 technical preparation only; wait for explicit authorization before implementation.

## Phase 3 planning artifact

The owner finalized Phase 3 decisions and requested the implementation guide. See `docs/PHASE_3_IMPLEMENTATION_GUIDE.md`; `docs/PHASE_3_PLAN.md` is the earlier proposal. The live project inventory again showed no app-owned `public` tables or project migrations; Supabase-managed `auth`/`storage` tables remain platform-owned. No source, dependency, Android, database, migration, or Supabase configuration changes were made for this planning task. Phase 3 has not started; implementation requires explicit owner authorization.
