# Localization workflow

## Stitch UI integration update (2026-10-30)

Added bilingual labels and states for Home, featured articles, Facilities, Mentors, learning progress, and directory-unavailable notices. That 2026-10-30 snapshot recorded 160 matching keys; the current 2026-10-31 source files contain 150 matching keys each. `flutter gen-l10n` completed with `l10n.yaml` retained. Automated tests exercised switching English to Amharic while navigating the app. Device-level font shaping, overflow and accessibility checks remain outstanding because no emulator was attached.

Supported UI locales: English (`en`) and Amharic (`am`). Source files: `lib/l10n/app_en.arb` and `lib/l10n/app_am.arb`; configuration is `l10n.yaml`. Add matching message keys and placeholders to both files, preserving placeholder names and meaning, then run `flutter gen-l10n`. Use `AppLocalizations.of(context)` for all user-visible widget copy; never hardcode interface strings in widgets.

The Settings language selector persists the selected supported code using SharedPreferences. Generated code is a build output and should not be manually edited. Tests should check both locales and parity of message IDs where practical. Phase 3 adds bilingual learning UI strings in both ARBs; article/quiz content translations are database content and need independent professional review.

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

The owner reports successful live manual testing of registration, email confirmation and password recovery; this workspace did not independently repeat those flows. Production email delivery remains unverified. Fluent/native Amharic review remains outstanding, including medical-language expert review before any health content is published. Add both locale strings for every future state.

Do not machine-translate sensitive medical terminology or unreviewed health guidance. Educational content needs a separate reviewed content workflow and provenance.

## Phase 3 learning localization

The local implementation adds matching ARB strings for Learn tabs, search/category filters, loading/error/empty/stale states, article completion, assessment navigation/validation/results/explanations/retry, progress sync consent, and clearing synchronized history. Run `flutter gen-l10n` after changing the ARBs; a direct Flutter `LocalizationsGenerator` invocation succeeded in the restricted workspace, but the standard CLI command stalled and generated output therefore needs ordinary Windows verification. Database article titles/bodies, categories, quiz prompts/options and explanations are separate per-locale content and must not be machine-published; Amharic clinical meaning requires qualified review. Search currently performs literal client-side matching only; no PostgreSQL Amharic search strategy has been selected.
# Current localization verification (2026-10-31)

- `flutter gen-l10n` completed with the existing `l10n.yaml`; the YAML is retained.
- English and Amharic ARB files each contain 150 user-facing message keys with no unmatched keys.
- Generated localization remains source-generated; no generated Dart file is edited manually.
