# Localization workflow

Supported UI locales: English (`en`) and Amharic (`am`). Source files: `lib/l10n/app_en.arb` and `lib/l10n/app_am.arb`; configuration is `l10n.yaml`. Add matching message keys and placeholders to both files, preserving placeholder names and meaning, then run `flutter gen-l10n`. Use `AppLocalizations.of(context)` for all user-visible widget copy; never hardcode interface strings in widgets.

The Settings language selector persists the selected supported code using SharedPreferences. Generated code is a build output and should not be manually edited. Tests should check both locales and parity of message IDs where practical.

## Completeness checklist

- [x] Navigation and foundation shell labels exist in both locales.
- [x] Language selector and description exist in both locales.
- [x] Initial empty-state and safety boundary copy exist in both locales.
- [x] Generate localization code; the owner reports `flutter gen-l10n` completed with this configuration and all 4 tests passed.
- [x] Verify language switching and saved selection across restart in the Android Studio emulator (owner-reported).
- [ ] Verify Amharic font fallback, shaping, line wrapping, large text, and small screens across additional devices.
- [ ] Native/fluent Amharic reviewer approves initial wording.
- [ ] Localize all future forms, validation, errors, dialogs, assessments, content, notifications, and accessibility semantics before those features ship.

## Phase 2 authentication localization

Auth/profile UI now has matching English and Amharic resources for sign-in, registration, email-verification pending, password recovery/reset, guest access, loading, validation, safe provider/network errors, profile editing, unavailable session, sign-out and success states. The approved flow is email/password with email confirmation; phone OTP is not part of this scope. Raw Supabase error details are not shown. ARB key parity is covered by an automated test, and widget tests exercise the account entry and registration-pending state.

Live email wording/delivery and Amharic fluency still need user/account testing and review by a native Amharic speaker. Add both locale strings for every future state.

Do not machine-translate sensitive medical terminology or unreviewed health guidance. Educational content needs a separate reviewed content workflow and provenance.
