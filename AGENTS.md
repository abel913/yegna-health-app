# Project instructions

- Follow the authorized phase in `docs/PHASE_STATUS.md`; do not move to another phase without the owner's explicit instruction.
- Read `docs/PROJECT_MASTER_PLAN.md`, `docs/ARCHITECTURE.md`, and `docs/DECISIONS.md` before substantial changes.
- Keep changes focused, preserve existing work, and update `docs/PHASE_STATUS.md`, `docs/HANDOFF.md`, and relevant docs at the end of each task.
- This is an independent rebuild. Do not claim affiliation with the original app, extract/repackage an APK, reuse proprietary assets/private APIs, or store secrets in the repository.
- Do not fabricate medical content, providers, facilities, or backend behavior. Clearly distinguish general health education from professional care.
- Keep all user-facing text in English and Amharic ARB resources. Regenerate localization with `flutter gen-l10n`; do not edit generated files.
- Use Material 3, null-safe Dart, small widgets, descriptive names, and focused tests. Avoid adding dependencies without documenting their need in `docs/DECISIONS.md`.
- Do not implement fake authentication, assessments, maps, notifications, or backend services.
- Run formatting, analysis, and relevant tests after code changes when the SDK permits. Record actual command results; distinguish blocked checks from passing checks.
