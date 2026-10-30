# Phase 3 Implementation Guide — Health Education and Assessments

**Preparation only. No Phase 3 implementation is authorized by this guide.** No app source, Android configuration, dependency, Supabase setting, schema, migration, or deployed function was changed to prepare it. Phase 3 remains not started. Start work only after the owner explicitly authorizes implementation.

## 1. Confirmed decisions and verified baseline

### Owner-confirmed decisions for Phase 3

- Article bodies use **structured Markdown**.
- Progress synchronization is optional for signed-in users.
- Quiz scoring is server-side; answer keys are never included in ordinary quiz-content responses.
- Caching is basic and online-first.
- Only professionally reviewed English and Amharic health content may be published.
- Preserve Flutter/Dart, Material 3, the existing locale preference, Supabase Auth and secure session handling. Guests can read and take quizzes, their progress remains local, and the app must not create anonymous Supabase users.

### Repository and live-project observations

- The Flutter shell in `lib/src/app.dart` has Home, Learn, Services and Settings destinations. Learn is still a localized placeholder. No education, quiz, assessment, or progress feature implementation was found.
- `lib/main.dart` initializes the locale controller and configures Supabase only when project URL and publishable key are supplied. It uses the publishable client key; no server key belongs in the mobile app.
- Auth is separated into `AuthRepository`, `SupabaseAuthRepository`, `AuthController` and auth pages. Auth operations require the provider and surface busy/error state. The current app does not fabricate a logged-in session.
- `SecureAuthStorage` implements Supabase session and PKCE persistence using `flutter_secure_storage`. `SharedPreferences` stores the supported `en`/`am` language preference. Preserve these behaviors and do not repurpose the locale preference store for sensitive progress data.
- UI strings are generated from `lib/l10n/app_en.arb` and `app_am.arb` using `l10n.yaml` and `flutter gen-l10n`. Dynamic article/quiz text belongs in reviewed database translations; UI controls, errors, status and accessibility labels belong in both ARB files.
- Read-only inventory of Supabase project `oflkhtjskpsedsuczfkj` found **no app-owned tables in `public`** and **no project migrations**. The `auth` and `storage` schemas contain Supabase-managed objects. Do not modify or repurpose those objects. API exposed-schema settings and grants for future application objects have not been configured or verified.
- The owner states that Phase 1 and Phase 2 are complete and Phase 2 was manually tested. Some repository status/testing notes still describe older Phase 2 checks as pending; reconcile those records as a separate documentation task before using them as current verification evidence.

The implementation guidance below is proposed. It is not evidence that tables, screens, functions, storage buckets, content, tests, or RLS exist today.

## 2. Target architecture

Keep the current Flutter app shell and add small feature boundaries behind repositories/controllers. Use Supabase Postgres for published content and authenticated learning history, plus one server-side submission/scoring boundary. Do not add a CMS or analytics stack until editorial operations require it.

```text
Flutter Material 3 UI
  ├─ Education feature ─ EducationRepository ─ Supabase published-content API
  ├─ Assessment feature ─ AssessmentRepository ─ published quiz API + submit Edge Function
  └─ Learning progress ─ ProgressRepository
       ├─ local encrypted progress store (guest and pending sync)
       └─ Supabase own-row history (signed-in, opt-in)

Supabase
  ├─ public, read-only published content tables (RLS + explicit SELECT grants)
  ├─ private, non-exposed answer-key table
  ├─ public, RLS protected user progress/attempt tables
  └─ submit-assessment Edge Function → server-only scoring/write operation
```

Keep Auth ownership in the existing auth layer. Feature code reads the current confirmed user identity from the existing controller; it does not store or refresh tokens independently. Expired sessions must stop progress sync and offer sign-in while leaving public reading available.

## 3. Proposed database structure

All objects below are new proposals because current inventory has no app-owned `public` tables or project migrations. Use UUID keys, UTC `timestamptz`, check constraints for enums/ranges, explicit `ON DELETE` behavior, and migrations created/reviewed locally before any authorized deployment.

### 3.1 Public bilingual content

| Table | Keys and principal columns | Indexes / use |
| --- | --- | --- |
| `education_categories` | PK `id`; unique `slug`; `sort_order`; `publication_status`; timestamps | `(publication_status, sort_order, id)` for library categories. |
| `education_category_translations` | PK `(category_id, locale)`; FK `category_id → education_categories(id)`; locale check `en/am`; `name`, `description`, `publication_status`, `reviewed_at`, optional public reviewer attribution | Index `(locale, publication_status)`. Each locale publishes independently. |
| `education_articles` | PK `id`; unique `slug`; FK `category_id`; publication status, `published_at`, `updated_at` | `(category_id, publication_status, published_at DESC)`. This identifies article independent of language. |
| `education_article_translations` | PK `(article_id, locale)`; FK `article_id → education_articles(id)`; locale check; `title`, `summary`, `body_markdown`, `content_revision`, `publication_status`, `reviewed_at`, `review_due_at`, approved public reviewer attribution, timestamps | `(locale, publication_status, updated_at DESC)` and locale-specific full-text index after Amharic search quality is validated. Store a documented Markdown subset/structured blocks; never accept raw HTML. |
| `education_article_sources` | PK `id`; FK `article_id`; optional locale; citation title, publisher, canonical URL/identifier, published/accessed dates, order | `(article_id, locale, sort_order)`. Preserve sources and license/provenance metadata. |
| `education_article_relations` | PK `(article_id, related_article_id, locale)`; both FKs to articles; order; no-self-link check | `(article_id, locale, sort_order)`. Editorial related links only; serving policy requires both localized articles to be published. |

### 3.2 Assessments and immutable quiz versions

Use immutable versions so saved attempts remain tied to the exact approved quiz a user completed. Publishing a material question/answer change creates a new version; do not edit scoring-relevant rows in a published version.

| Table | Keys and principal columns | Indexes / use |
| --- | --- | --- |
| `education_assessments` | PK `id`; unique `slug`; lifecycle status; timestamps | `(status, updated_at DESC)`. Stable assessment identity. |
| `education_assessment_versions` | PK `id`; FK `assessment_id`; integer `version`; lifecycle status; `published_at`; unique `(assessment_id, version)` | `(assessment_id, status, version DESC)`. Published rows immutable except explicit archive/unpublish controls. |
| `education_assessment_version_translations` | PK `(version_id, locale)`; FK version; locale check; title/description/instructions; status/review dates/approved attribution | `(locale, status)`. A locale is available only when its whole question set is reviewed/published. |
| `education_assessment_questions` | PK `id`; FK `version_id`; `position`; unique `(version_id, position)` | `(version_id, position)`. |
| `education_assessment_question_translations` | PK `(question_id, locale)`; FK question; prompt and post-submit explanation; status/review dates | `(locale, status)`. |
| `education_assessment_options` | PK `id`; FK question; `position`; unique `(question_id, position)` and unique `(question_id, id)` for composite answer-key reference | `(question_id, position)`. No correctness flag. |
| `education_assessment_option_translations` | PK `(option_id, locale)`; FK option; localized option label | locale-specific lookup. |
| `private.assessment_answer_keys` | PK `question_id`; FK to question; `correct_option_id`; composite FK `(question_id, correct_option_id) → education_assessment_options(question_id, id)`; reviewer/version audit metadata | `private` schema must not be in Supabase Data API exposed schemas; no `anon`/`authenticated` grants or RLS policies are a substitute for keeping this table unreachable. |

### 3.3 Personal progress and attempt history

| Table | Keys and principal columns | Access model / indexes |
| --- | --- | --- |
| `user_article_progress` | PK `(user_id, article_id, locale)`; FK `user_id → auth.users(id) ON DELETE CASCADE`; FK article; locale; `completed_revision`; `completed_at`; `updated_at` | Authenticated own-row read/insert/update only. `(user_id, completed_at DESC)`. Keep scroll position local unless a later requirement justifies syncing it. |
| `user_assessment_attempts` | PK `id`; FK `user_id → auth.users(id) ON DELETE CASCADE`; FK immutable assessment version; unique `(user_id, request_id)` idempotency UUID; score and question count; started/completed timestamps | Own-row SELECT only for clients; no direct client insert/update/delete. `(user_id, completed_at DESC)` and `(user_id, version_id, completed_at DESC)`. Score fields written by the trusted scoring path only. |

Do not persist per-question choices by default. The feature requirement is attempt history and score, and keeping only those fields minimizes potentially revealing learning records. Add answer detail only if a reviewed product requirement demonstrates its value and retention/privacy is approved. Do not duplicate email, display name, or other Auth profile data in these tables.

### 3.4 Foreign key, index and lifecycle rules

- Category deletion is restricted while articles reference it; archive instead of deleting published content.
- Article/translation source and relation rows cascade only with deliberate content deletion; published content should normally be archived/unpublished.
- Quiz version child rows cascade on deletion only for unpublished drafts. Published versions referenced by attempts are immutable and retained; archive them rather than delete.
- Deleting an Auth user cascades only their private progress/attempt data. Provide an explicit “clear learning history” path; do not delete the account as a side effect of clearing progress.
- Index every FK used in frequent joins/policies when Postgres does not create it automatically. Avoid speculative indexes; confirm with realistic query plans after reviewed content volume exists.

## 4. Grants, RLS and database security

Grants and RLS are separate controls: a grant makes an object callable/readable through the Data API; RLS constrains rows after access is granted. Verify the project's exposed schemas and default privileges before migration. Enable RLS on every app table in an exposed schema, then apply explicit least-privilege grants and test both layers.

### Public content

- `education_*` tables: RLS on; `anon` and `authenticated` receive `SELECT` only on content needed for published library/quiz reads. Revoke app-role `INSERT/UPDATE/DELETE/TRUNCATE/REFERENCES/TRIGGER` and any unintended function execution.
- Policies must check the parent publication status and active locale translation status. Draft, in-review, rejected, archived, expired-review, or partial quiz translations must not be returned to app roles.
- Reviewer operational identity and internal review notes stay in an unexposed editorial schema/table. Only an expressly approved public display attribution can be present in a public translation row.
- Never put `is_correct` or equivalent in option content, views, RPC payloads used to fetch a quiz, cache files, or logs.
- Check all view security behavior before adding views; prefer direct RLS queries or `security_invoker` views. Test grants and RLS independently.

### User progress

- RLS enabled on every progress/attempt table. Authenticated `SELECT` policies require `user_id = (select auth.uid())`; article progress insert/update use matching `WITH CHECK` and `USING` ownership predicates.
- No `anon` access to progress. Attempt table grants authenticated `SELECT` only; no client `INSERT`, `UPDATE`, or `DELETE`. Server scoring writes attempts only after verifying a real Supabase user JWT and derives the UID from the verified token, never from a caller-supplied UID.
- Use `auth.uid()`, not user-editable `user_metadata`, for row ownership. Keep guest scores local and do not create anonymous Auth users.
- Article completion sync is self-reported user-owned progress; client may upsert its own completion row through RLS. Server checks references/status to prevent completion for unknown/unpublished content where needed.
- Account deletion must remove owned progress through FK cascade, subject to the final privacy/retention decision.

### Answer key and scoring privileges

- `private` schema is not API-exposed. Revoke all privileges from `PUBLIC`, `anon`, and `authenticated` on `private.assessment_answer_keys`; grant read only to the trusted server execution identity. Verify actual Postgres ownership/default privileges, not only dashboard toggles.
- Preferred flow uses a Supabase Edge Function as the boundary and a narrowly scoped database scoring operation. Only that server-side path can read answer keys or insert attempt results. Use an invoker SQL function callable only by `service_role` if needed for one-transaction scoring; pin `search_path` to empty and schema-qualify every object. Revoke default `PUBLIC` function execution, then grant only to the trusted server role. Do not create a broadly callable `SECURITY DEFINER` scoring function in an exposed schema.
- The Edge Function uses a server-only secret in its managed environment if privileged database access is necessary. It must never be returned, logged, built into Flutter, or written into this repository. Prefer a minimal server call path and strict input checks; a service-role key bypasses RLS, so its handler must be narrow and covered by negative tests.
- Guest scoring is allowed but no guest attempt is stored in Supabase. A guest can call the public scoring endpoint; use request-size/question-count limits and appropriate abuse controls. Quiz scores are educational, not diagnostic.
- Content can initially be text-only; no Storage bucket is needed. If reviewed/licensed media is later approved, use a dedicated public read-only bucket for published assets only, with bounded file type/size and no user records.

## 5. Secure server-side quiz submission and scoring

### Request and response

Flutter fetches a published immutable assessment version and locale-specific prompts/options. That response contains question IDs, option IDs/text, version ID, and no correctness data or answer key. The client builds selections locally. On final submit it sends `{versionId, locale, answers:[{questionId, selectedOptionId}], requestId}` to the scoring Edge Function. It never sends or chooses a `userId` field.

### Server workflow

1. Validate HTTP method, content type, payload size, UUID formats, supported locale, maximum question count, exact question coverage, unique question IDs, and one option per question. Reject unknown/missing/duplicate questions, extra answers, and options that do not belong to their question/version.
2. Distinguish guest from authenticated calls. For signed-in calls, validate the bearer token with Supabase Auth/JWKS and derive the user ID from the verified claim. Reject expired, malformed, or invalid tokens. Treat no token as guest; never treat an arbitrary supplied UID or publishable key as identity. Do not enable anonymous sign-in.
3. Load the immutable published version and locale from trusted database state. Confirm it remains submit-eligible and the submitted IDs match its complete required question set.
4. Read correct-option IDs only from `private.assessment_answer_keys` in server context. Compute score and correctness on the server. Client scoring is display-only and never accepted as authoritative.
5. In one trusted database transaction, for authenticated callers insert one append-only attempt with the verified UID, immutable version ID, server score/question count and request ID. A unique `(user_id, request_id)` makes retries idempotent and returns the already-committed result rather than double-recording. For guests, do not persist an attempt; return an ephemeral result.
6. Return only the completed result: score, count, per-question correctness and reviewed explanation needed for learning. Correctness/explanations are not present in quiz-fetch responses. Post-submit teaching feedback necessarily reveals learning information to the participant; raw answer-key tables remain private and no endpoint permits key enumeration outside submitted attempts. The quiz is not a high-stakes test.
7. Return stable safe error codes for unavailable version, invalid answer set, expired session, network failure, and retryable server error. Do not log access tokens, full answer submissions, health-interest data, or secrets. Preserve the same request ID on retries.

### Important abuse and limitation note

Retakes and post-submit explanations are intentional educational behavior. A determined user can learn answers by completing attempts; the security boundary prevents direct key reads and client-forged persisted scores, not learning from feedback the app is designed to show. Guest attempts cannot be bound reliably to a real identity without tracking or account creation. Add server-side rate limiting only if abuse evidence warrants it, with a privacy-reviewed mechanism. Never represent scores as a clinical assessment.

## 6. Flutter feature architecture

Suggested modules (names are proposals and should follow local naming after implementation authorization):

```text
lib/src/education/
  domain/education_models.dart
  domain/education_repository.dart
  data/supabase_education_repository.dart
  data/article_cache_store.dart
  presentation/learning_library_page.dart
  presentation/category_articles_page.dart
  presentation/article_detail_page.dart
  presentation/education_controller.dart
lib/src/assessments/
  domain/assessment_models.dart
  domain/assessment_repository.dart
  data/supabase_assessment_repository.dart
  presentation/assessment_controller.dart
  presentation/assessment_list_page.dart
  presentation/assessment_session_page.dart
  presentation/assessment_result_page.dart
lib/src/learning_progress/
  domain/progress_models.dart
  domain/progress_repository.dart
  data/local_progress_store.dart
  data/supabase_progress_repository.dart
  presentation/learning_history_page.dart
```

- Repositories own Supabase mapping, validation, cache/network boundaries, and safe error conversion; controllers own loading/data/empty/error state and UI actions; widgets remain presentation-focused.
- Keep `AuthController` as the source of session truth. `ProgressRepository` receives the current verified user ID from auth state and cancels/blocks cloud calls on sign-out or session expiry.
- Replace only the current Learn placeholder route with the library. Preserve Home, Services, Settings, Account/Auth navigation and language selector. Add History in the library/account area without adding a new bottom-nav tab unless usability testing proves it necessary.
- Use `Scaffold`, `NavigationBar`, `SearchBar`, `FilterChip`, `ListTile`/cards, semantic `RadioListTile` or equivalent accessible answer controls, and visible progress/error/retry UI consistent with the existing Material 3 theme.

## 7. Screens and user journeys

1. **Library:** categories, featured/recent reviewed articles, search. Show loading skeleton, no-content state, retryable network error, and cached/offline indicator.
2. **Category results:** localized category heading, title/summary cards, locale-specific search and optional taxonomy filters. Preserve filters and scroll when returning from an article.
3. **Article detail:** title, summary, safe structured Markdown body, sources/citation links, review date, reviewer attribution where approved, education-not-clinical-care notice, related published articles, completion action. Locale switch remains on same article and restores the nearest stable section anchor when available.
4. **Assessment list/instructions:** published quizzes with purpose, question count, expected time if validated, and education-only note.
5. **Assessment session:** one question at a time, selectable answers, next/back, required-answer validation, question progress, submit confirmation. Preserve the selected answers locally if the network fails on final submit.
6. **Result:** server-returned score, explanations and correctness feedback, completion date, Retake. Never show a score until server result returns; label it educational.
7. **Learning history:** optional sign-in prompt for private synced history; list completed article revisions and quiz attempts. Guest sees device-local history only. Offer explicit sync opt-in and clear-history controls.

Navigation/back behavior must preserve scroll/filter/session state as appropriate. Language change must not silently substitute an unpublished translation; show an explicit unavailable-locale message and keep navigation understandable.

## 8. Localization requirements

- All UI controls, labels, category-empty messages, validation, loading/error/retry/offline states, quiz directions, score descriptions, accessibility semantics, account/sync consent, and destructive clear-history confirmations use paired English/Amharic ARB keys with parity tests.
- Health articles, categories, questions, answer options and explanations are content records with `locale=en|am`, separate qualified review per locale and publication state. Do not put changing editorial articles into ARB.
- Do not auto-translate medical content. If current-language content is unpublished, clearly show unavailable/not-yet-reviewed copy in that language instead of silently displaying the other language.
- Structured Markdown renderer must support a documented safe subset (headings, paragraphs, lists, emphasis, blockquotes, approved links); strip/reject raw HTML, scripts, embedded remote HTML and unsafe URL schemes. Keep headings/anchors stable enough to restore reading position on language switch.
- Test long Amharic copy, fonts/shaping, right line wrapping, screen reader names, text scale, focus order, contrast and both locales on target Android screen sizes. Qualified Amharic clinical-language review is a release dependency.

## 9. Local cache and synchronization

### Public content cache

- Online-first: query the active locale, render fresh response, and write only published public DTOs keyed by object ID, locale and content revision. Use bounded LRU/size and a configurable TTL; never cache draft data, Auth tokens or unpublished quiz keys.
- Proposed storage: app-support directory with compact JSON cache files and atomic replace. Add an explicit, pinned `path_provider` dependency only if the project does not already declare/use a stable app-support path API. This dependency is **not added** in this preparation task. If dependency policy rejects it, defer disk cache to in-memory and revisit rather than storing article bodies in `SharedPreferences`.
- A cached article shows cached/offline status and source/review date. If it is past its editorial review-due date or cache expiry, do not present it as current guidance; show stale/unavailable state and require refresh. Content unpublishing cannot be learned while offline, so cache TTL bounds but cannot eliminate that risk.
- Cache quiz prompts/options only if a fresh published version has been downloaded. Never include answer keys. Offline users may select answers locally and keep a pending request ID; display “Waiting for connection” rather than score/completion until the server accepts it. If that version has been withdrawn or replaced, explain and ask the learner to reload.

### Local progress and cloud sync

- Use existing `flutter_secure_storage` for compact local progress metadata keyed by `guest` or a principal-specific user ID namespace; preserve unrelated Auth/PKCE keys. Store completed article ID/locale/revision/time and quiz result summaries only—no passwords, tokens, raw answer sets or free text. Provide explicit clear-history behavior.
- Guest completion/history remains on device and is never uploaded automatically. No anonymous Supabase Auth identity is created.
- Signed-in cloud progress is opt-in, default off. Keep the sync preference with that principal's local secure progress metadata; do not add a new app preference table unless product scope later demands cross-device sync settings.
- On opt-in, explain what will sync. Upload queued article completions idempotently; submit quiz attempts through the scoring function only. Keep unsynced items on network error, retry with the same request ID, and mark them synced only after server confirmation. Do not sync guest history without a deliberate, separately reviewed import/consent action.
- Cloud article progress upserts own `(user_id, article_id, locale)` row. Preserve completion time/revision policy; never overwrite a newer article revision with an older pending record. Quiz attempts append with idempotency key and immutable quiz version.
- On account change/sign-out, cancel sync, clear in-memory user data and current user's on-device progress/cache partition unless the owner explicitly elects “keep this account's data on this device.” Never clear Supabase Auth storage by broad key deletion. Public article cache may remain.
- Offline article reading uses cache; offline quiz scoring waits for connectivity; account history may display last synchronized state with an explicit stale indicator. Online is needed to complete authoritative scoring and cloud sync.

## 10. Testing and verification plan

### Flutter unit/widget

- Model parsing, locale/revision selection, Markdown safe rendering/link policy, article search/filter/related relation behavior, stable-anchor language switching, cache TTL/size and stale content behavior.
- Quiz ordering, one answer per question, selection/back/next validation, duplicate submit prevention, retry with same request ID, no client score calculation accepted, server result decoding and retake.
- Progress guest/user partitioning, opt-in defaults, queue/retry/idempotency, user switch/sign-out clearing, stale sync conflict resolution.
- Widget coverage for every loading/empty/error/offline/validation/success state, EN/AM copy, navigation/back state, dynamic text scale, semantic labels and keyboard/screen-reader operability.
- Regression of Phase 1 locale persistence/navigation and Phase 2 sign-in/registration/recovery/profile/edit/sign-out using existing test patterns.

### Supabase database/Edge Function security

- Start from a clean local Supabase database and verify migration order/rollback. Use Supabase database tests (pgTAP/`supabase test db`) for constraints, composite answer-key FK, version immutability, indexes, grants and RLS.
- Exercise `anon`, authenticated user A, authenticated user B and server role. Verify anonymous sees published localized content only; draft/review/archived/expired rows are invisible; direct answer-key select fails; direct user-attempt insert/update/delete fails; user A cannot read or alter user B's progress/history; private schema cannot be reached through Data API.
- Edge Function tests: absent token guest path, valid user JWT, invalid/expired/malformed JWT, spoofed UID ignored, malformed/oversized payload, duplicate/missing/extra question, option from wrong question/version, unpublished or stale version, score boundaries, idempotent retries, no guest persistence, user attempt stored once, safe failure and no secret/token logging.
- Verify score and explanations are computed by server from private answer keys. Confirm quiz fetch payload, local cache and logs contain no correctness or answer-key field.
- Test migration against the current empty app schema in a disposable local/staging project; do not use production as a test database.

### Integration, content and device

- End-to-end guest article/read/search/quiz/result/retake; signed-in opt-in progress/article history; offline cached article; queued quiz submission after reconnect; expired session and sign-out privacy behavior.
- Qualified clinical review and separate qualified Amharic clinical translation review for every published locale; source/license/citation/date verification, correction/unpublish workflow.
- Android emulator (including the development host's proven `-gpu host` mode) and physical-device checks, large fonts, accessibility semantics, slow/offline networks, cache staleness, locale switching and back-stack restoration.
- Automated checks must not be described as clinical content certification or real-user testing.

## 11. Implementation sequence and gates

### 3.0 — Editorial/privacy and migration readiness

Approve initial topics, authoritative sources/licenses, clinical + Amharic reviewers, review date policy, content publishing roles, retention/deletion, guest-to-user policy, quiz feedback behavior and cache TTL. Confirm current exposed schemas/default grants, Supabase CLI/project linkage and clean migration baseline. No app user features before these gates are signed off.

### 3.1 — Content schema, RLS and reviewed bilingual MVP content

Create migration(s) for category/article/source/relationship tables, publication/version rules, RLS and explicit grants. Add content models/repository/cache and replace Learn placeholder with library/category/article routes. Seed only professionally reviewed English/Amharic material. Test policies with anon/user roles before staging data.

### 3.2 — Immutable quiz model and server scoring

Add assessment/version/question/option translations and private answer-key schema. Implement scoring Edge Function plus trusted atomic database operation, server validation, idempotent attempt storage for authenticated users and ephemeral guest scoring. Build Flutter quiz list/session/results using server results only. Never seed unreviewed sample clinical questions.

### 3.3 — Local learning progress and opt-in authenticated sync

Implement secure local guest/user progress partitions, opt-in control, article completion sync under own-row RLS, server-created attempt history, retry/conflict/sign-out handling, privacy copy and history UI. Validate user isolation and account lifecycle.

### 3.4 — Hardening and acceptance

Run migrations from clean local DB and staging, all Dart/Flutter/database/Edge tests, RLS security matrix, accessibility/device/localization QA and qualified content sign-off. Verify offline freshness and withdrawn content behavior. Update docs with actual results; only then assess whether Phase 3 acceptance is met. Phase 4 remains separately gated.

## 12. Acceptance checklist

- [ ] Learn library/category/search/article/related-content journey works for guest users in both locales.
- [ ] Every visible clinical article and assessment is reviewed and licensed; review date, references, and education-not-care boundary are visible.
- [ ] Language switching stays on the same article with best-effort section position; no silent fallback to unreviewed translation.
- [ ] Quiz list/session/result/retake works; answer key is absent from fetched content/cache and score is server-computed; post-submit feedback is localized and safe.
- [ ] Guests can complete quizzes and retain local summary without anonymous Auth account or cloud attempt storage.
- [ ] Authenticated users explicitly opt into progress sync; only their own article completions and server-scored attempt history are visible; sync retries are idempotent.
- [ ] RLS/grants tests prove drafts and keys hidden, user A/B isolation, no direct client attempt writes, and no service secret in mobile assets/config.
- [ ] Online-first cache shows freshness state, obeys size/TTL/review-due policy, and has a tested offline path. Offline submissions receive no score until server verification.
- [ ] Every new UI/validation/error/accessibility string has English/Amharic ARB keys with parity; content locale review is separately approved.
- [ ] Existing Phase 1 and Phase 2 automated and manual behavior passes regression verification; results are recorded by command/device.
- [ ] Database migrations, Edge Function deployment, release and privacy/security review are recorded only after they actually occur. Phase 3 completion is not claimed before all gates pass.

## 13. Risks and unresolved implementation gates

- **Editorial ownership:** named qualified health and Amharic medical-language reviewers, first topics, sources, reuse rights, cadence, and correction SLA remain to be supplied/approved.
- **Progress privacy:** agree retention period and whether users can clear history/export it; the guide proposes clear-history and cascade on account deletion, but jurisdiction/privacy review is still required.
- **Server secret handling:** Edge Function privileged access is powerful and must be narrowly scoped, tested and kept server-side. Consider least-privilege DB role if feasible instead of broad service-role access; never use service role from Flutter.
- **Guest scoring abuse:** public scoring can be automated. Set payload bounds; decide whether rate limiting/abuse telemetry is necessary without collecting disproportionate identifiers.
- **Feedback vs answer secrecy:** raw answer-key tables/data stay private, but post-submit correct-answer explanations necessarily teach the user. Confirm that “never expose answer keys” means no key in quiz fetch/client storage and only derived feedback after a completed attempt.
- **Amharic full-text search:** validate available PostgreSQL text search/tokenization against reviewed content before selecting FTS configuration; start with locale-specific search and test quality.
- **Cache freshness:** choose/approve a bounded TTL and review-due behavior with clinicians. Offline caches cannot observe an immediate unpublish event.
- **Data API config:** current exposed schemas and default grants were not inspected. Verify these before any migration; do not assume RLS alone creates or restricts access.
- **Phase status evidence:** owner reports Phase 1/2 completed, while some older docs still state Phase 2 live account/email verification is pending. Reconcile documentation before implementation so it records whether checks were owner-reported or independently verified.
- **Dependencies:** no new package is added here. `path_provider` is a candidate only if an app-support file cache is implemented and no already-approved path API exists. Keep the first release online-first and avoid adding Markdown/search packages unless the selected safe renderer/search implementation requires and documents them.

## 14. References

- Supabase [Securing the Data API](https://supabase.com/docs/guides/api/securing-your-api): grants and RLS are independent access layers.
- Supabase [Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security): policy testing and least privilege.
- Supabase [Database Functions](https://supabase.com/docs/guides/database/functions): invoker/definer and function privilege guidance.
- Supabase [Securing Edge Functions](https://supabase.com/docs/guides/functions/auth): caller identity and server-side function authentication patterns.
- Supabase [Anonymous Sign-Ins](https://supabase.com/docs/guides/auth/auth-anonymous): anonymous auth users are distinct from public `anon` access; this product will not create anonymous users.
