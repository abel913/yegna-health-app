# Phase 3 Proposal — Health Education and Assessments

> **Superseded as the current technical plan:** the owner later confirmed article format, progress sync, scoring, caching, and professional review decisions. Use [`PHASE_3_IMPLEMENTATION_GUIDE.md`](PHASE_3_IMPLEMENTATION_GUIDE.md) for the current implementation preparation. This earlier proposal remains as the original planning record; it does not authorize implementation.

**Status: earlier planning only.** This document is a proposal, not authorization to implement. No application source, database schema, Supabase settings, or migration history was changed while preparing it. Current owner decisions and status are recorded in `PHASE_STATUS.md` and `PHASE_3_IMPLEMENTATION_GUIDE.md`. Do not begin Phase 3 implementation or Phase 4 work without the owner's explicit authorization.

## 1. Scope and objectives

Deliver one coherent learning journey in Flutter: browse reviewed public health education in English or Amharic, open and resume an article, take an educational quiz, see explanations and results, and optionally sync learning progress for signed-in users. Guests retain access to public content and local-only progress. The app must clearly label content as general education, not diagnosis or personal medical advice.

In scope: content categories, search/filtering, article detail/related links, bilingual content, educational multiple-choice assessments, completion history, and accessible loading/empty/error/success states. Out of scope: clinical screening or diagnosis, care recommendations, provider/facility discovery, personalized treatment, Phase 4 capabilities, and publishing unreviewed sample material.

## 2. Audit findings

- The Flutter app already uses Dart, Material 3, `AppLocalizations`, English/Amharic ARB resources, a persisted locale controller, and a four-destination bottom navigation shell. “Learn” currently shows a localized placeholder. No article, category, quiz, assessment, or progress feature code was found.
- Startup initializes Supabase Auth only when URL and publishable key are configured. Auth is isolated behind `AuthRepository`/`AuthController`; secure session and PKCE data use `flutter_secure_storage`. `SharedPreferences` currently holds only the locale. Phase 3 must preserve those boundaries and must not store sensitive records in ordinary preferences.
- Read-only inventory of Supabase project `oflkhtjskpsedsuczfkj` found **zero tables in `public`** and **zero project migrations**. `auth` and `storage` contain platform-managed tables; no app-owned content or progress schema was found. Storage has no buckets. No table, setting, or migration was changed. Auth-managed user data is not an education schema and must not be repurposed.
- Existing architecture and decisions favor thin UI, repository/controller boundaries, no fabricated medical content, ARB for app UI, and expert-reviewed content with provenance. See `ARCHITECTURE.md`, `DECISIONS.md`, and `LOCALIZATION.md`.

## 3. Feature breakdown and user journeys

### Health education library

- Learn opens a library landing page with localized category names/descriptions, featured/recently updated published articles, and an accessible search field.
- Category selection opens a filtered article list. Search matches title, summary, and category in the active language; filters may include category and topic tags only after editorial taxonomy is agreed.
- Article detail displays title, summary, body, sources, review date, and educational-care disclaimer. Related articles are explicit editorial relations, restricted to published translations in the active locale.
- A language change keeps the same article and a best-effort reading location. Store a stable article/section anchor when possible; if the translated text has no matching anchor, remain at the article top and communicate the language switch. Do not promise pixel-perfect scroll preservation across different translations.

### Assessments

- Quiz list shows published quizzes with localized title, purpose, question count, and an educational-only label.
- Quiz flow presents one multiple-choice question at a time, supports answer selection/change, and offers next/back/submit with localized validation and progress indication.
- Results show score, correct-answer explanations, completion time, and Retake. Do not call a score a diagnosis, risk level, or clinical recommendation. Store each completed attempt as a separate history item; do not overwrite prior attempts.
- Content authors and qualified reviewers must approve questions, answer keys, explanations, and translations before publication.

### Learning progress and guests

- Guests can read content and take quizzes; their reading position and results are local-only and may be lost on reinstall/device change. Do not create anonymous Supabase users or upload guest learning history.
- Signed-in users may sync article completion and completed quiz attempts. Only store what is needed for history. Do not infer health status, expose progress to other users, or make progress a condition of access.
- If signed-in synchronization fails, keep the completed in-memory result visible and offer retry; clearly distinguish unsynced local completion from saved history. Conflict policy should append completed attempts and use the newest valid reading position per article.
- Account sign-out preserves no accessible private cache for the next user. Remove or isolate user-scoped cached progress on sign-out/account change; public article cache may remain.

## 4. Screen and navigation plan

Keep the existing bottom navigation and replace only the Learn placeholder with a feature entry point after implementation is authorized. Suggested routes:

1. **Learn library** — search, category chips/list, featured articles, empty/loading/error states.
2. **Category articles** — localized category heading, filter/sort, paged article cards.
3. **Article detail** — localized content, citation/source list, reviewed date, related content, progress control, language-change/resume behavior.
4. **Quiz list/detail** — published assessment cards and instructions.
5. **Quiz session** — question, options, progress, navigation and submit confirmation.
6. **Quiz result/history** — score and explanations, retake, signed-in history; guest result remains in the current local session/device store.
7. **Learning progress** — optional account area showing completed articles and attempts, protected by current Phase 2 auth state.

All routes need back navigation that preserves list/filter state where practical. Public content routes must work without Auth configuration. Account history must require a currently confirmed Supabase user and must show an actionable sign-in state when unavailable or expired.

## 5. Proposed database design

These definitions describe a target model only. Exact types, constraints, public schema exposure, and storage choices should be reviewed before writing any migration. Use UUID primary keys and `timestamptz` UTC timestamps unless project conventions establish otherwise. Keep the content publication model distinct from private per-user learning records.

### Public read-only published content

| Table | Proposed columns and relationships | Purpose / indexes |
| --- | --- | --- |
| `education_categories` | `id`, unique `slug`, `sort_order`, `status` (`draft`,`published`,`archived`), timestamps | Category identity independent of language. Index `(status, sort_order, id)`. |
| `education_category_translations` | `category_id` FK → categories, `locale` (`en`,`am`), `name`, `description`, `status`, `reviewed_at`; PK `(category_id, locale)` | Localized category labels. Index locale/status for library queries. |
| `education_articles` | `id`, unique `slug`, `category_id` FK, `status`, `published_at`, `updated_at`, `content_version` | Article identity and publication lifecycle. Index `(category_id, status, published_at DESC)`. |
| `education_article_translations` | `article_id` FK, `locale`, `title`, `summary`, `body` (structured document or markdown after format decision), `status`, `reviewed_at`, public `reviewer_attribution` (nullable, explicitly approved), `updated_at`; PK `(article_id, locale)` | Each language version is independently reviewed/published. Index `(locale, status, updated_at DESC)` and a locale-specific search index selected after search requirements are known. |
| `education_article_sources` | `id`, `article_id` FK, `locale` (nullable for shared sources), `title`, `publisher`, `url` or stable citation, `published_on`/`accessed_at`, `sort_order` | Source references for traceability. Index `(article_id, sort_order)`. |
| `education_article_relations` | `article_id` FK, `related_article_id` FK, `sort_order`; composite PK and `article_id <> related_article_id` check | Explicit editorially curated related articles; avoid opaque algorithmic recommendations initially. |
| `education_assessments` | `id`, unique `slug`, `status`, `version`, `published_at`, `updated_at` | Quiz identity/version. Index `(status, published_at DESC)`. Increment version when scoring-relevant content changes. |
| `education_assessment_translations` | `assessment_id` FK, `locale`, `title`, `description`, `instructions`, `status`, `reviewed_at`, optional reviewer attribution; PK `(assessment_id, locale)` | Localized quiz metadata. |
| `education_questions` | `id`, `assessment_id` FK, `position`, `status`; unique `(assessment_id, position)` | Ordered questions. Index `(assessment_id, position)`. |
| `education_question_translations` | `question_id` FK, `locale`, `prompt`, `explanation`, `status`, `reviewed_at`; PK `(question_id, locale)` | Localized question and post-answer explanation. |
| `education_answer_options` | `id`, `question_id` FK, `position`; unique `(question_id, position)` | Stable option identity/order. |
| `education_answer_option_translations` | `option_id` FK, `locale`, `label`; PK `(option_id, locale)` | Localized option text. |
| `education_answer_keys` *(private schema or server-only access)* | `question_id` FK/PK, `correct_option_id` FK, reviewer/version metadata | Keep answer keys out of client-readable content endpoints if quiz integrity matters. Never grant direct Data API access to this table. Score through a narrowly scoped server-side Postgres function or trusted Edge Function after deciding anonymous-quiz scoring behavior. |

Article/assessment translations should be listable only when both the parent and translation are published and reviewed. A view, if used, must not accidentally bypass RLS; prefer direct policies or a `security_invoker` view supported by the deployed Postgres version. Avoid making `education_*` authoring tables writeable from the mobile client.

### Private learning records

| Table | Proposed columns and relationships | Purpose / indexes |
| --- | --- | --- |
| `user_article_progress` | `user_id` FK → `auth.users(id)` `ON DELETE CASCADE`, `article_id` FK, `content_version`, `completed_at`, `updated_at`; PK `(user_id, article_id)` | Minimal per-user completion state. Index `(user_id, completed_at DESC)`. Keep precise reading position local by default; persist it only if user value justifies additional retention. |
| `user_assessment_attempts` | `id`, `user_id` FK → `auth.users(id)` `ON DELETE CASCADE`, `assessment_id` FK, `assessment_version`, `started_at`, `completed_at`, `score`, `question_count` | Append-only completed attempt history. Index `(user_id, completed_at DESC)` and `(user_id, assessment_id, completed_at DESC)`. Define score bounds and nullability for incomplete attempts. |
| `user_assessment_answers` | `attempt_id` FK → attempts `ON DELETE CASCADE`, `question_id` FK, nullable `selected_option_id` FK, `is_correct` (only server-calculated if persisted), PK `(attempt_id, question_id)` | Optional answer-level history. Include only if explanations/review history require it; otherwise retain score and omit detailed answers to reduce sensitive-data volume. |

Do not duplicate user email, display name, or other Auth profile fields in progress rows. User progress is personal learning metadata and should be treated as private even though the content itself is public.

## 6. RLS, API exposure, and storage

- Enable RLS on every app-owned table in an exposed schema. Grant `anon`/`authenticated` only `SELECT` on published content access paths. RLS policies must constrain content to parent and translation status `published`, supported locale, and non-archived parent; draft/review rows are never visible to app roles.
- Keep authoring writes behind an editorial workflow. Do not grant app clients insert/update/delete on content, source, translation, question, option, relation, or answer-key tables. Use a separate trusted admin workflow; never ship a service-role key in Flutter.
- Store learning rows in a non-public schema if practical, with only explicitly granted API access; otherwise use `public` with RLS. Policies require `user_id = auth.uid()` for select/insert/update/delete as appropriate. Insert/update checks must prevent changing another user's rows, attempt ownership, assessment references, or server-computed score fields. For append-only attempt history, deny client update/delete unless account data deletion requirements explicitly require a controlled path.
- `UPDATE` requires a compatible `SELECT` policy. Test policies as `anon`, user A, user B, and privileged content editor. Never use mutable `user_metadata` for authorization.
- If correct answers remain private, scoring should be atomic and validated against the published assessment version. A server function must validate question/option membership, one completion per submitted item, score bounds, and caller ownership before writing the attempt. Decide whether an anonymous invocation can return an ephemeral result without storing it. For a low-stakes quiz where client-side scoring is accepted, document that answers are inspectable and scores are self-reported; do not describe these as secure/authoritative.
- Initial content can use text-only rows and citation URLs; no Storage bucket is required. If reviewed diagrams/audio are later approved, use a dedicated public read-only bucket for published, non-sensitive assets, constrained file types/size, stable paths and content licensing. Never place private user records in public buckets.
- Search should start with Postgres text search over the active locale's published title/summary/body; assess Amharic tokenization quality with real reviewed content before promising full-text search. Add trigram or external search only if quality/performance evidence warrants a documented dependency.

## 7. Content management and clinical review

1. Appoint an editorial owner and qualified health professional(s), including a qualified Amharic medical-language reviewer. Define the topic boundaries, source hierarchy, review cadence, correction/escalation process, and who can publish.
2. Create content from authoritative sources and retain citation title, publisher, canonical URL/identifier, source publication date, and access date. Confirm reuse/license rights before storing excerpts or media.
3. Draft English and Amharic independently or with a qualified translation workflow. Do not rely on unchecked machine translation for medical terminology, questions, explanations, warnings, or accessibility labels.
4. Track each locale's editorial state independently (`draft` → `in_review` → `approved` → `published` → `archived`). Require source references, reviewer approval, and review date before a translation becomes public. Re-review translated content whenever the source meaning or clinical recommendation changes.
5. Keep operational reviewer identity in a private editorial record; expose only an explicitly approved professional attribution (name/credentials) where appropriate. Do not expose staff email, account IDs, internal notes, or unapproved identity data through public content APIs.
6. Publish atomically per locale, retain version history, allow fast unpublish/correction, and show review/source metadata to readers. Never seed the production database with placeholder/sample medical advice.

## 8. Implementation subphases

### 3.0 — Requirements and editorial readiness

- **Features:** finalize user journeys, guest/signed-in sync policy, topics, source standards, content format, quiz scoring/integrity, retention, accessibility and offline expectations.
- **Likely files:** `docs/DECISIONS.md`, `docs/ARCHITECTURE.md`, `docs/LOCALIZATION.md`, `docs/TESTING.md`, new editorial/content policy docs. No app files until implementation is authorized.
- **Database:** none. Confirm whether production content can be sourced/reviewed before building.
- **Tests:** define test cases and a synthetic non-medical fixture strategy; no clinical sample content.
- **Acceptance:** product owner and qualified content/editorial owners approve content and privacy rules, quiz model, MVP topic list and publication workflow.
- **Dependencies:** editorial owner and qualified EN/AM reviewers; content sources and licensing.

### 3.1 — Public bilingual content foundation

- **Features:** typed content models/repository, category/library/list/detail, search/filter, related articles, per-locale states, citations, review labels, reading-position preservation.
- **Likely files:** `lib/src/education/` feature/domain/data/presentation modules; ARB additions only for UI chrome; Learn destination integration in `lib/src/app.dart`; repository tests and localized widget tests.
- **Database:** migration for categories, translations, articles, sources, relations; RLS and read grants; seed only reviewed/publishable content after approval.
- **Tests:** model parsing, locale fallback policy (prefer explicit unavailable-language state over silently showing the other language), query/filter behavior, RLS role matrix, search quality with reviewed EN/AM content, loading/error/empty, long-text/accessibility and language-switch scroll behavior.
- **Acceptance:** guest can discover and open published EN and AM articles; drafts are inaccessible; article/source/review metadata displays; switching language preserves the article and best-effort reading location; failures are recoverable.
- **Dependencies:** approved schema, editorial content and source references, locale-specific search decision.

### 3.2 — Quiz content and end-to-end assessment flow

- **Features:** bilingual published quiz list/detail, question selection, back/next, validation, completion, score, explanations, retry/retake.
- **Likely files:** `lib/src/assessments/` models/repository/controller/pages; quiz ARB UI strings; quiz unit/widget tests.
- **Database:** assessment/translation/question/option tables plus private answer keys; add scoring RPC/Edge Function only if the chosen integrity policy requires it. Version quiz definitions so historical attempts remain interpretable.
- **Tests:** answer selection, question-order/version consistency, scoring boundaries, explanation localization, duplicate submission/idempotency, no missing/unpublished locale question, auth/guest behavior, RLS and server validation.
- **Acceptance:** user can complete and retake a reviewed bilingual educational quiz; results and explanations match approved answer keys; no score is presented as clinical advice; transient failure does not silently discard a completed result.
- **Dependencies:** qualified assessment/question review, decision on answer-key secrecy and server scoring.

### 3.3 — Progress, account history, and guest continuity

- **Features:** guest-local completion state, authenticated sync of article completion and attempts, progress/history view, retry/conflict/sign-out handling.
- **Likely files:** `lib/src/learning_progress/` repository/sync/controller/UI; targeted changes to `AuthController` listeners/account area; local store adapter if justified; unit/widget/integration tests.
- **Database:** private progress and attempt tables; RLS, ownership constraints, retention/deletion policy, indexes; migration only after privacy/security review.
- **Tests:** user A/B isolation, no history for guest, sign-in transition and conflict behavior, sign-out cache clearing, expired session, offline/retry, account deletion implications, append-only attempts, no duplicate completion loss.
- **Acceptance:** guests retain public browsing and only device-local progress; signed-in users can read/write only their own allowed history; no cross-user leakage; sync is recoverable and clearly labeled.
- **Dependencies:** data minimization/retention approval, auth lifecycle behavior and RLS review.

### 3.4 — Editorial publishing, hardening, and release gate

- **Features:** approved content update/unpublish flow, final accessibility/localization polish, performance and offline behavior within the approved scope.
- **Likely files:** editorial runbooks, CI/schema checks, feature tests, docs and any focused UX fixes.
- **Database:** review migration history, RLS advisors, grants, backup/rollback and content version/unpublish behavior; no new tables without a demonstrated requirement.
- **Tests:** regression suite, emulator/device navigation, EN/AM review, large text/screen reader, network loss, RLS role matrix, migration rollback on staging, security review.
- **Acceptance:** editorially approved bilingual content is publishable/correctable; tests and accessibility checks meet agreed gates; deployment and rollback are documented; Phase 3 status is marked complete only after evidence is recorded.
- **Dependencies:** staging environment, professional approval, localization sign-off and release owner.

## 9. Testing strategy

- **Dart/unit:** parsing/version rules, locale selection, filtering, scoring, article progress and sync merge logic.
- **Flutter widget:** every loading/empty/error/success/validation state, EN/AM layout, semantics labels, keyboard/focus and navigation/list-state restoration.
- **Integration:** public content with Auth absent, guest reading/quiz flow, confirmed-auth progress sync, recovery from network/session errors, sign-out privacy boundaries.
- **Database/security:** migration from empty project, foreign keys/checks/indexes, RLS as anon/user A/user B/editor, attempts that spoof owner/score/version, drafts never visible, scoring function validation, grants and API exposure.
- **Content QA:** qualified clinical source review, translation review, citation/link verification, date freshness, publication/unpublish correction and license checks. Software tests cannot certify medical accuracy.
- **Device/accessibility:** emulator and physical Android devices, text scaling, screen readers, contrast, focus order, large/long Amharic strings, offline and slow network.
- **Regression:** preserve existing Phase 1 navigation/locale persistence and Phase 2 registration/login/recovery/profile/sign-out. Do not claim backend live checks from fake repository tests.

## 10. Phase 3 acceptance criteria

1. Guests can browse searchable, categorized, published articles and related content in English and Amharic; every clinical article has suitable references, locale-specific professional review date, and an education-not-care notice.
2. Language switching remains on the same content item and preserves a best-effort reading position without showing unpublished or unreviewed translations.
3. Users can finish, view, understand, and retake reviewed bilingual educational quizzes with correct localized explanations and transparent score semantics.
4. Guests' progress remains local; confirmed users can see their own synchronized completion and attempt history; user A cannot read or modify user B's records.
5. Loading, empty, error, retry, validation, offline, session-expiry and success states are bilingual, accessible, and tested.
6. App-owned content/progress tables have reviewed migrations, foreign keys, useful indexes, least-privilege grants and tested RLS. No secrets or service-role keys are shipped in Flutter.
7. Existing Phase 1 and Phase 2 tests/behavior pass regression checks. Manual emulator/device checks are recorded separately from automated tests.
8. Qualified health and Amharic reviewers approve all content before publication; no unverified sample medical guidance is shipped.

## 11. Risks and dependencies

- **Clinical safety/content quality:** needs qualified topic reviewers and a correction process; engineering cannot substitute for clinical review.
- **Amharic translation/search:** terminology and tokenizer quality may be uneven; validate with reviewed language material and avoid silent locale fallback.
- **Sensitive progress data:** reading/quiz history may imply health interests. Minimize collection, state retention/deletion rules, isolate with RLS and offer public education without sign-in.
- **Scoring integrity:** a public client can be modified. Decide if educational scores are explicitly self-reported or server-scored with private answer keys; never treat either as clinical assessment.
- **Content API exposure:** RLS does not itself grant Data API access. Verify schema exposure, explicit grants and policies; published content is public by design, draft/editorial content is not.
- **Publication consistency:** English/Amharic may reach approval at different times. Publish per locale, show availability honestly, and prevent related links to unavailable translations.
- **Empty project baseline:** no app-owned `public` tables/migrations exist yet, so avoid duplicate profile/content tables and do not repurpose `auth` internals. Confirm live schema immediately before any authorized migration.
- **Offline complexity:** define cache expiration and account-switch cleanup before storing progress; begin online-first unless offline use is a validated requirement.
- **Platform/auth regressions:** retain secure session handling and exercise existing Phase 2 flows after auth-dependent progress work.

## 12. Authorization gate

Before implementation, obtain explicit owner authorization to start Phase 3 and decisions on: initial topic/content set and qualified reviewers; article body format; whether progress sync is in MVP; retention/deletion; quiz answer-key integrity/server scoring; search and offline scope; and editorial publishing access. At that point, re-inspect the current schema and migration state before drafting/applying any migration. This proposal alone does not authorize app, database, or Supabase changes.
