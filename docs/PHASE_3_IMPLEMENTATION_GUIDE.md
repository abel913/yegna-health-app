# Phase 3 Implementation Guide — Health Education and Assessments

**Status: Phase 3 is PARTIAL (last verified 2026-10-31).** The original sections below preserve the approved preparation design. Flutter learning code is local; four additive migrations and `submit-assessment` v2 are deployed to development project `oflkhtjskpsedsuczfkj`. The fourth migration corrected a public assessment visibility policy. There is no reviewed content, so positive scoring/synchronization integration remains unverified. See `docs/PHASE_STATUS.md` and `docs/TESTING.md` for current evidence. Do not mark Phase 3 complete or begin Phase 4.

### Historical continuation verification update (2026-10-30)

This is a historical 2026-10-30 snapshot; its test counts and Deno result are superseded by the final verification record in `docs/TESTING.md` dated 2026-10-31. It did not establish positive scoring or authenticated sync. The browser did not connect to the debug service, and no visual verification was claimed.

### Final verification update (2026-10-31)

`flutter pub get`, `flutter gen-l10n`, `dart format lib test` (33 files, 0 changed), `flutter analyze` (clean), `flutter test` (27 passed), `flutter build apk --debug`, and `flutter build web --no-pub` passed. English and Amharic each have 150 matching ARB keys. Deno format/type check passed; `deno test` panicked on a Windows pipe before running, although a direct Deno eval harness passed the six logic assertions. Four remote migration records are present, and the corrected assessment RLS correlation plus all 26 equivalent catalog security predicates passed. The database limiter allowed 20 and denied 21 in an isolated SQL check. No approved content or dedicated authenticated test user is available; positive scoring, HTTP 429, sync/isolation and pgTAP execution remain outstanding. Phase 3 remains partial.

## 1. Confirmed decisions and pre-implementation baseline

The repository and hosted-project observations in this section describe the inspection made before Phase 3 implementation and are historical. The current code/schema draft status is recorded at the end of this guide.

### Owner-confirmed decisions for Phase 3

- Article bodies use **structured Markdown**.
- Progress synchronization is optional for signed-in users.
- Quiz scoring is server-side; answer keys are never included in ordinary quiz-content responses.
- Caching is basic and online-first.
- Only professionally reviewed English and Amharic health content may be published.
- Preserve Flutter/Dart, Material 3, the existing locale preference, Supabase Auth and secure session handling. Guests can read and take quizzes, their progress remains local, and the app must not create anonymous Supabase users.

### Repository and live-project observations

- At preparation time, the Flutter shell had Home, Learn, Services and Settings destinations, with Learn a localized placeholder. Phase 3 implementation has since replaced that placeholder locally.
- `lib/main.dart` initializes the locale controller and configures Supabase only when project URL and publishable key are supplied. It uses the publishable client key; no server key belongs in the mobile app.
- Auth is separated into `AuthRepository`, `SupabaseAuthRepository`, `AuthController` and auth pages. Auth operations require the provider and surface busy/error state. The current app does not fabricate a logged-in session.
- `SecureAuthStorage` implements Supabase session and PKCE persistence using `flutter_secure_storage`. `SharedPreferences` stores the supported `en`/`am` language preference. Preserve these behaviors and do not repurpose the locale preference store for sensitive progress data.
- UI strings are generated from `lib/l10n/app_en.arb` and `app_am.arb` using `l10n.yaml` and `flutter gen-l10n`. Dynamic article/quiz text belongs in reviewed database translations; UI controls, errors, status and accessibility labels belong in both ARB files.
- Read-only inventory of Supabase project `oflkhtjskpsedsuczfkj` found **no app-owned tables in `public`** and **no project migrations**. The `auth` and `storage` schemas contain Supabase-managed objects. Do not modify or repurpose those objects. API exposed-schema settings and grants for future application objects have not been configured or verified.
- Phase 1 and Phase 2 are complete according to the owner. The owner specifically reports successful real-account manual testing of registration, email confirmation, sign-in, profile editing, sign-out and password recovery. This is owner-reported verification and was not independently repeated for this guide. Historical automated results in other project documents use test doubles for provider-dependent behavior and remain a separate evidence category. SMTP configuration and production readiness are separate open items.

The architecture and schema sections below record the approved design. They do not by themselves certify that runtime behavior, hosted tables, deployed functions, content, or RLS has passed verification. The current implementation is partial and remains unverified against Supabase.

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
- Guest scoring is allowed without anonymous Supabase accounts. Expose only the scoring Edge Function as an explicitly public endpoint (for example, disable gateway JWT enforcement for that function if required by the deployed Supabase configuration), while requiring the publishable project API key and enforcing strict method, payload, version, question-count and rate/abuse limits in the handler. The function treats a missing user bearer token as a guest; if a bearer token is supplied, it must validate it and reject invalid/expired credentials rather than silently downgrade to guest. This public invocation permission does not grant guests Data API access to private tables, answer keys, attempts, or progress. Keep answer keys in a non-exposed schema and grant only the trusted server execution identity access. No anonymous Auth user is created and no guest attempt/user record is written. Quiz scores are educational, not diagnostic.
- Content can initially be text-only; no Storage bucket is needed. If reviewed/licensed media is later approved, use a dedicated public read-only bucket for published assets only, with bounded file type/size and no user records.

## 5. Secure server-side quiz submission and scoring

### Request and response

Flutter fetches a published immutable assessment version and locale-specific prompts/options. That response contains question IDs, option IDs/text, version ID, and no correctness data or answer key. The client builds selections locally. On final submit it sends `{versionId, locale, answers:[{questionId, selectedOptionId}], requestId}` to the scoring Edge Function. It never sends or chooses a `userId` field.

### Server workflow

1. Validate HTTP method, content type, payload size, UUID formats, supported locale, maximum question count, exact question coverage, unique question IDs, and one option per question. Reject unknown/missing/duplicate questions, extra answers, and options that do not belong to their question/version.
2. Make the function callable by public guests using the app's publishable project key, without requiring an Auth session or creating an anonymous account. If Supabase gateway JWT verification is disabled for this function to permit guest calls, perform optional bearer validation inside the function: no bearer means guest; a supplied invalid/expired bearer is rejected; a valid bearer establishes the authenticated caller. Derive user ID only from verified identity, never from a request field, publishable key, or user metadata. The public function URL/key authorizes only bounded scoring requests, not database reads or writes by the guest.
3. Load the immutable published version and locale from trusted database state. Confirm it remains submit-eligible and the submitted IDs match its complete required question set.
4. Read correct-option IDs only from `private.assessment_answer_keys` in server context. Compute score and correctness on the server. Client scoring is display-only and never accepted as authoritative.
5. In one trusted database transaction, for authenticated callers insert one append-only attempt with the verified UID, immutable version ID, server score/question count and request ID only when the user has explicitly opted into progress synchronization and this submission is eligible for sync. With sync off (the default), return an ephemeral result and create no cloud attempt. A unique `(user_id, request_id)` makes synced retries idempotent and returns the already-committed result rather than double-recording; reuse with a different version or payload must be rejected. For guests, never persist an attempt or request record; return an ephemeral result. A repeated guest request may be recomputed and return the same deterministic result, but it creates no cloud history.
6. Return only the completed result: score, count, per-question correctness and reviewed explanation needed for learning. Correctness/explanations are not present in quiz-fetch responses. Post-submit teaching feedback necessarily reveals learning information to the participant; raw answer-key tables remain private and no endpoint permits key enumeration outside submitted attempts. The quiz is not a high-stakes test.
7. Return stable safe error codes for unavailable version, invalid answer set, expired session, network failure, and retryable server error. Do not log access tokens, full answer submissions, health-interest data, or secrets. Preserve the same request ID on retries.

### Important abuse and limitation note

Retakes and post-submit explanations are intentional educational behavior. A determined user can learn answers by completing attempts; the security boundary prevents direct key reads and client-forged persisted scores, not learning from feedback the app is designed to show. Guest attempts cannot be bound reliably to a real identity without tracking or account creation. Requests are bounded by payload size and question count, and the deployed development scorer now applies a shared 20-request-per-IP/10-minute limit. Verify forwarded-IP behavior and distributed-abuse resistance before release. Never represent scores as a clinical assessment.

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

- Online-first: query the active locale, render fresh response, and write only published public DTOs keyed by object ID, locale and content revision. Provisional technical defaults are a maximum 50 MB article/content cache and a 7-day TTL from last successful validation. Make both values configurable. Use bounded least-recently-used eviction at the size limit and automatically remove expired entries when practical. These defaults are cache-management values only; seven days is not a clinically approved medical-content validity period. Clinical and editorial reviewers must approve the content freshness and expiry policy before release. Never cache draft data, Auth tokens, answer keys, or scoring responses containing correctness/explanations beyond the current result/session.
- Implemented draft: app-support directory cache using `path_provider: ^2.1.6`, compact JSON files, a 7-day stale threshold and 50 MiB LRU cap. This code has not been device-tested; storage integrity and atomic replacement remain follow-up hardening.
- Previously downloaded articles remain readable offline within the cache bounds. Clearly distinguish cached/offline content from freshly retrieved content and show its last-validated date. Expired or withdrawn content must never be presented as current medical guidance. After TTL or `review_due_at`, label content stale and show a clear warning that it may be outdated; offline access may remain available with that warning, subject to the approved editorial freshness policy. When online, revalidate publication status before presenting cached content as current; if withdrawn, remove it from normal library results and purge it on the next successful refresh. Withdrawal status cannot necessarily be checked while offline, so an already cached article may remain on device until reconnect; disclose this limitation. The TTL is not a clinical review interval and does not establish validity.
- Cache quiz prompts/options only if a published version has been downloaded, subject to the same size/TTL bounds. Never include answer keys. Offline users may select answers locally and keep an opaque pending request ID; display a waiting-to-submit state, not a score, explanation, or completion. On reconnect, submit to the server; if the version has expired, been withdrawn, or is no longer eligible, explain and ask the learner to reload. There is no authoritative offline quiz scoring.

### Local progress and cloud sync

- Use existing `flutter_secure_storage` for compact local progress metadata keyed by `guest` or a principal-specific user ID namespace; preserve unrelated Auth/PKCE keys. Store completed article ID/locale/revision/time and quiz result summaries only—no passwords, tokens, raw answer sets or free text. Provide explicit clear-history behavior.
- Guest completion/history remains on device and is never uploaded automatically. No anonymous Supabase Auth identity is created.
- Signed-in cloud progress is opt-in, default off. Provide an explicit choice to enable sync, an always-available way to disable it, and clear language about exactly what is synchronized. Disabling stops future uploads/downloads but leaves local progress usable and does not silently delete remote history. Keep the sync preference with that principal's local secure progress metadata; do not add a new app preference table unless product scope later demands cross-device sync settings.
- On opt-in, explain what will sync. Upload queued article completions idempotently; submit quiz attempts through the scoring function only, with cloud attempt persistence enabled only while the user's explicit sync choice is on. With sync off, the scoring function still returns the authoritative result but stores no attempt. Keep unsynced items on network error, retry with the same request ID, and mark them synced only after server confirmation. Do not sync guest history without a deliberate, separately reviewed import/consent action.
- Cloud article progress upserts own `(user_id, article_id, locale)` row. Preserve completion time/revision policy; never overwrite a newer article revision with an older pending record. Quiz attempts append with idempotency key and immutable quiz version.
- Provide a separate “Clear synchronized learning history” action. Require confirmation, then call an authenticated, narrowly scoped server operation that deletes only the verified caller's rows from `user_article_progress` and `user_assessment_attempts`; enforce identity from the validated JWT/`auth.uid()` and ownership/RLS, never accept a target user ID. The operation must be safe to retry and report partial/network failure without claiming completion. Clear the caller's corresponding local history only after confirmed cloud deletion, or offer a clearly named separate “clear on this device” action; do not delete the Auth account. Disabling sync alone must not delete anything. Preserve account isolation and audit that user A cannot clear user B's data.
- On account change/sign-out, cancel sync and clear in-memory data for the prior principal. Keep local progress partitioned by principal so it remains usable when the same account is signed in again, unless the user separately clears it; do not expose one account's local records to another account. Never clear Supabase Auth storage by broad key deletion. Public article cache may remain.
- Offline article reading uses cache; offline quiz scoring waits for connectivity; account history may display last synchronized state with an explicit stale indicator. Online is needed to complete authoritative scoring and cloud sync.

## 10. Testing and verification plan

### Flutter unit/widget

- Model parsing, locale/revision selection, Markdown safe rendering/link policy, article search/filter/related relation behavior, stable-anchor language switching, cache TTL/size and stale content behavior.
- Quiz ordering, one answer per question, selection/back/next validation, duplicate rapid-submit prevention, idempotent retry with the same request ID (including lost response after a committed server write), same request ID with altered payload rejection, retake with a fresh request ID, interrupted submission/reconnect recovery, no client score accepted, server result decoding, and guest submission without persistence or Auth account.
- Progress guest/user partitioning, opt-in defaults, queue/retry/idempotency, user switch/sign-out clearing, stale sync conflict resolution.
- Widget coverage for every loading/empty/error/offline/validation/success state, EN/AM copy, navigation/back state, dynamic text scale, semantic labels and keyboard/screen-reader operability.
- Regression of Phase 1 locale persistence/navigation and Phase 2 sign-in/registration/recovery/profile/edit/sign-out using existing test patterns.

### Supabase database/Edge Function security

- Start from a clean local Supabase database and verify migration order/rollback. Use Supabase database tests (pgTAP/`supabase test db`) for constraints, composite answer-key FK, version immutability, indexes, grants and RLS.
- Exercise `anon`, authenticated user A, authenticated user B and server role. Verify anonymous sees published localized content only; draft/review/archived/expired rows are invisible; direct answer-key select fails; direct user-attempt insert/update/delete fails; user A cannot read or alter user B's progress/history; private schema cannot be reached through Data API.
- Edge Function tests: public guest invocation without an Auth account, guest result is ephemeral/no progress or attempt row created, valid user JWT, invalid/expired/malformed supplied JWT rejected, spoofed UID ignored, malformed/oversized payload, duplicate/missing/extra question, option from wrong question/version, unpublished or stale version, score boundaries, duplicate submissions, idempotent retries after simulated response loss, altered-payload replay rejection, fresh-ID retake, interrupted submission/retry, user attempt stored once, safe failure and no secret/token logging. Verify public invocation cannot read/write private tables except the narrowly scoped scoring path and cannot access answer keys except to compute the submitted result.
- Verify score and explanations are computed by server from private answer keys. Confirm quiz fetch payload, local cache and logs contain no correctness or answer-key field.
- Test migration against the current empty app schema in a disposable local/staging project; do not use production as a test database.

### Integration, content and device

- End-to-end guest article/read/search/quiz/result/retake; signed-in opt-in progress/article history; offline cached article; queued quiz submission after reconnect; expired session and sign-out privacy behavior.
- Content workflow tests and permissions: content author can prepare drafts; health reviewer records clinical approval; qualified Amharic medical-language reviewer independently approves the Amharic version; publisher/administrator alone can publish or withdraw and can publish only when both required review approvals and source/review metadata are complete. Verify unapproved states are not publicly queryable.
- Qualified clinical review and separate qualified Amharic clinical translation review for every published locale; source/license/citation/date verification, correction/unpublish workflow.
- Android emulator (including the development host's proven `-gpu host` mode) and physical-device checks, large fonts, accessibility semantics, slow/offline networks, cache staleness, locale switching and back-stack restoration.
- Automated checks must not be described as clinical content certification or real-user testing.

## 11. Implementation sequence and gates

### 3.0 — Editorial/privacy and migration readiness

Before public content and hosted deployment, approve initial topics, authoritative sources/licenses, named clinical + Amharic reviewers, review-date policy, editorial permissions, retention/deletion and abuse controls. Before choosing PostgreSQL Amharic search, build a representative reviewed corpus and validate query behavior (tokenization, inflections, phrase and partial matches, spelling variants, relevance, false positives/negatives and latency). Compare strategies against a documented query set. Reconfirm exposed schemas/default grants and a clean local/staging migration baseline. These remain content and deployment gates, not a reason to misstate local implementation status.

Editorial permission model: **content author** creates and revises draft English/Amharic records and citations; **health reviewer** approves clinical accuracy and sources; **Amharic medical-language reviewer** independently approves the Amharic medical meaning and terminology; **publisher/administrator** manages lifecycle and is the only role permitted to make approved translations public or withdraw them. Keep internal reviewer identities/notes in an unexposed editorial area with least privilege. Publication must be blocked unless each locale being published has its required approvals, source references, review date and due date. A role may hold multiple responsibilities only if organizational policy permits and the approvals remain explicit and auditable. Only approved content is publicly available.

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
- [ ] Every visible clinical article and assessment is reviewed and licensed; required clinical and Amharic medical-language approvals, review date, references, and education-not-care boundary are recorded and visible as appropriate. Only publisher-approved content is public.
- [ ] Language switching stays on the same article with best-effort section position; no silent fallback to unreviewed translation.
- [ ] Quiz list/session/result/retake works; answer key is absent from fetched content/cache and score is server-computed; post-submit feedback is localized and safe.
- [ ] Guests can call the bounded scoring function without an Auth account, complete quizzes and retain local summary without anonymous Auth account or cloud attempt storage; public scoring grants no access to private records or answer-key data.
- [ ] Authenticated users can opt into and disable progress sync; local progress remains usable. Only their own article completions and server-scored attempt history are visible; retries are idempotent, clear-synchronized-history deletes only their cloud records, and account isolation is verified.
- [ ] RLS/grants tests prove drafts and keys hidden, user A/B isolation, no direct client attempt writes, and no service secret in mobile assets/config.
- [ ] Online-first cache respects the approved TTL/size caps, supports offline article reading with freshness and stale-content warnings, removes withdrawn content at next online validation, and has a tested offline path. Offline submissions receive no score until server verification.
- [ ] Every new UI/validation/error/accessibility string has English/Amharic ARB keys with parity; content locale review is separately approved.
- [ ] Existing Phase 1 and Phase 2 automated and manual behavior passes regression verification; results are recorded by command/device.
- [ ] Database migrations, Edge Function deployment, release and privacy/security review are recorded only after they actually occur. Phase 3 completion is not claimed before all gates pass.

## 13. Risks and unresolved implementation gates

- **Editorial ownership:** named qualified health and Amharic medical-language reviewers, first topics, sources, reuse rights, cadence, and correction SLA remain to be supplied/approved.
- **Progress privacy:** agree retention period and whether users can clear history/export it; the guide proposes clear-history and cascade on account deletion, but jurisdiction/privacy review is still required.
- **Server secret handling:** Edge Function privileged access is powerful and must be narrowly scoped, tested and kept server-side. Consider least-privilege DB role if feasible instead of broad service-role access; never use service role from Flutter.
- **Guest scoring abuse:** public scoring can be automated. Payload bounds and a shared per-IP limiter are implemented in development; verify that the managed gateway supplies a trustworthy forwarded address, test HTTP 429 behavior, and assess distributed-IP abuse and operational monitoring before release.
- **Feedback vs answer secrecy:** raw answer-key tables/data stay private, but post-submit correct-answer explanations necessarily teach the user. Confirm that “never expose answer keys” means no key in quiz fetch/client storage and only derived feedback after a completed attempt.
- **Amharic search:** final PostgreSQL search strategy is unresolved until measured against a representative, professionally reviewed Amharic corpus and query set; do not select solely by English-language assumptions.
- **Cache freshness:** approve configurable cache limits and the content freshness/expiry policy with clinical and editorial reviewers. The proposed 7-day TTL is provisional and technical, not a clinical validity interval. Offline caches cannot observe an immediate withdrawal event.
- **Data API config:** current exposed schemas and default grants were not inspected. Verify these before any migration; do not assume RLS alone creates or restricts access.
- **SMTP / production readiness:** the owner reports Phase 2 live authentication flows manually tested successfully. SMTP configuration and delivery to arbitrary recipients, production email readiness, security/privacy review, release signing and production deployment are distinct checks and remain unverified until separately recorded.
- **Dependencies:** no new package is added here. `path_provider` is a candidate only if an app-support file cache is implemented and no already-approved path API exists. Keep the first release online-first and avoid adding Markdown/search packages unless the selected safe renderer/search implementation requires and documents them.

## Latest development backend deployment and verification (2026-10-30)

The owner explicitly authorized development deployment. The confirmed project was `yegna-health-amharic` (`oflkhtjskpsedsuczfkj`, `ACTIVE_HEALTHY`). Before applying SQL, the remote app schemas, relevant type/functions, migrations and Edge Functions were empty. The migration was reviewed for destructive SQL; it contains no `DROP`/`TRUNCATE`, and the only `DELETE` statements are inside the authenticated user's explicit clear-history RPC.

The CLI `db push --linked --dry-run --skip-vault` and authorized `db push --linked --skip-vault --yes` both stalled at `Initialising login role` and were stopped before returning a plan/result. The reviewed migration was applied through the authenticated Supabase remote migration tool instead. First apply failed on a missing `published_at` column for assessment translations and fully rolled back; the column and publication trigger were fixed before successful application. A follow-up migration closes a retry path that could otherwise read an existing attempt after sync consent was disabled. The remote migration versions are `20261030174702` and `20261030174920`; matching local filenames are retained.

The remote schema now has 17 public education/progress tables and 6 private tables (5 content/review tables plus the guest limiter). The 22 education/progress/content tables remain empty; the limiter has only transient test/request counters. All 23 app tables have RLS enabled. Twenty-three original read-only catalog assertions passed, covering grants, answer-key privacy, scorer privilege, ownership policies, sync-consent-gated reads/writes, and consent checking before idempotent retry lookups. The `pgTAP` extension is not installed remotely, and the Docker engine is unavailable, so `supabase/tests/phase3_learning_security.test.sql` was not run as pgTAP.

At the initial deployment on 2026-10-30, three migration records were present. The final 2026-10-31 record is `20261031095050_fix_assessment_publication_policy_correlation`. `submit-assessment` remains active at version 2, `verify_jwt=false`. Guests reach the handler without creating Auth accounts; the handler verifies any non-publishable-key bearer through Supabase Auth before associating the request with a user. The scorer and rate-limit RPCs are executable only by `service_role`; the function reads that credential from server environment and it is not in Flutter source/config. The guest limiter allows 20 submissions per gateway-supplied client IP per fixed 10-minute window and cleans rows older than one day opportunistically on guest calls. The database counter/grants were verified; live HTTP 429 remains unverified because a reserved forwarding-header value was not recorded by the ingress and repeating calls could throttle a shared caller.

`deno check` passed. A fresh `deno test` attempt hit Deno 2.9.7's Windows pipe panic; an earlier recorded run passed all 6 logic tests. There is no published assessment, so valid scoring, correct-answer feedback, duplicate/idempotent retry, retake, interrupted submission and live authenticated sync/isolation cannot be positively tested without unreviewed content or a real user session. No content was invented or published.

Security Advisor reported: private tables with RLS and no policies (intentional deny-all for client roles); an authenticated-only `SECURITY DEFINER` clear-history function (fixed empty `search_path`, derives user from `auth.uid()`, and updates only that user's history marker); disabled Auth leaked-password protection; plus performance advisories for some unindexed foreign keys, `auth.uid()` policy initialization and currently unused indexes. The guest limiter uses a shared database-backed counter (20 requests per forwarded client IP per 10-minute window) and removes rows older than one day opportunistically during later guest calls; there is no scheduled cleanup. Catalog grants and the database threshold were checked. Direct HTTP 429 and forwarded-header trust remain unverified. These remaining checks and lack of reviewed content keep Phase 3 incomplete; Phase 4 remains unstarted.

## 14. References

- Supabase [Securing the Data API](https://supabase.com/docs/guides/api/securing-your-api): grants and RLS are independent access layers.
- Supabase [Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security): policy testing and least privilege.
- Supabase [Database Functions](https://supabase.com/docs/guides/database/functions): invoker/definer and function privilege guidance.
- Supabase [Securing Edge Functions](https://supabase.com/docs/guides/functions/auth): caller identity and server-side function authentication patterns.
- Supabase [Anonymous Sign-Ins](https://supabase.com/docs/guides/auth/auth-anonymous): anonymous auth users are distinct from public `anon` access; this product will not create anonymous users.

## Historical local implementation record (before backend deployment, 2026-10-30)

This is a snapshot from before development-backend deployment. The deployment section immediately above records the current backend state. It reports local code additions and historical checks, not production behavior.

### Added locally

- Flutter: `lib/src/learning/` contains typed content models, education and assessment repository contracts/adapters, a seven-day stale/50 MiB LRU public content cache, secure per-identity progress storage, account-aware progress controller, and article/assessment/progress UI. `lib/src/app.dart` routes the Learn tab to these screens; `lib/main.dart` wires the adapters. English/Amharic ARBs include the new UI states.
- Supabase draft: `supabase/migrations/20261030111305_phase3_education_learning.sql` defines localized content, article sources/relations, immutable assessment versions, `yegna_private` answer keys/explanations/reviewer assignments, user sync preferences, article completions and attempts, RLS/grants, a service-only scorer and own-history clearing function. `supabase/config.toml` configures `submit-assessment` to perform its own optional JWT validation so guests can submit without anonymous accounts.
- Edge Function: `supabase/functions/submit-assessment/` validates request size, locale, UUIDs and duplicate questions; it distinguishes a guest API-key bearer from a user token, validates real tokens through Supabase Auth, and passes no client-supplied user ID to the server scorer. Answer keys are not returned by content fetches. Deno type checking passed; function behavior has not been integration-tested.
- Tests: Flutter UI/cache tests and Deno logic tests were added, as well as pgTAP security assertions. The tests are not equivalent to run results; see `docs/TESTING.md`.

### Actual verification and blockers

- `dart pub get --offline` — passed using the machine's existing Pub cache.
- `dart format lib test` — passed; final run checked 29 files with 0 changed (an earlier pass formatted 3 files).
- `flutter gen-l10n` — standard CLI attempt stalled without output and was interrupted. Direct invocation of Flutter's `LocalizationsGenerator` with the Flutter tools package configuration exited successfully; generated Dart localization files were then formatted. Re-run standard Flutter CLI generation in a normal Windows environment.
- `flutter analyze` / `flutter test` — both Flutter CLI attempts stalled without output and were interrupted. Direct Dart analyzer/test attempts failed to spawn subprocesses with `CreateFile failed 5` (Windows access denied). No Phase 3 analyze/test pass is claimed.
- `deno check supabase/functions/submit-assessment/index.ts supabase/functions/submit-assessment/logic.ts supabase/functions/submit-assessment/logic_test.ts` — passed.
- `deno test supabase/functions/submit-assessment/logic_test.ts` — Deno 2.9.7 panicked on Windows with `Unexpected client pipe failure` / invalid handle.
- `flutter build apk --debug`, Android emulator, Supabase migration/pgTAP, Edge deployment, live RLS tests and guest/authenticated scoring integration tests — not run.
- GitHub `git ls-remote` and Supabase CLI project listing — network/proxy transport failure in the current shell despite browser sign-in. The live Supabase schema was not re-inspected during this implementation pass.

### Not yet accepted

- Run standard Flutter generation, analyzer and all widget tests on Windows with a writable Flutter SDK and subprocess execution enabled; fix any failures.
- Review the migration carefully, then apply it to a clean local Supabase database. Run pgTAP/RLS tests for anonymous, authenticated user A/B and service-role boundaries. The current host's Docker daemon is not running and hosted Supabase is unreachable.
- Deploy the Edge Function only to an approved development/staging project after migration review. Verify guest calls, authenticated opt-in sync, invalid/expired sessions, duplicate and idempotent retries, retakes, interrupted submissions, disabled-sync behavior, and no private answer-key access.
- Supply professionally reviewed and properly licensed English/Amharic content. No health content or quiz was fabricated or seeded.
- Validate Amharic search against reviewed content before choosing a PostgreSQL search implementation. Verify device/offline/withdrawal/accessibility behavior and content-review publication workflow.
- Update this guide, `PHASE_STATUS.md`, `HANDOFF.md` and `TESTING.md` with every actual result. Phase 3 remains in progress; Phase 4 has not started.

### Pre-deployment execution and migration review (2026-10-30)

The results below are a pre-deployment snapshot and are superseded by the current development-backend record above.

- The local migration was tightened to use non-recursive publication-check predicates in `yegna_private`, explicitly revoke client table privileges before granting the intended public read and own-progress access, and keep the history-clear timestamp server-managed. The history-clear RPC validates `auth.uid()` and deletes only that caller's rows. These are reviewed local SQL changes, not live database behavior.
- Latest local checks: `flutter pub get`, `flutter gen-l10n`, `dart format lib test` (31 files, 0 changed), `flutter analyze` (no issues), `flutter test` (26 passed), `flutter build apk --debug`, `flutter build web`, `deno check`, and `deno test` (6 passed). See `docs/TESTING.md` for exact outcomes and build warnings.
- Docker CLI is present but its Linux engine named pipe is inaccessible. The official Supabase CLI package was run through npx (2.122.0); project listing worked. The remote migration-list CLI call stalled, so the authenticated Supabase MCP read-only inventory was used to confirm project identity and that there are no app migrations, tables or functions.
- The Supabase MCP migration-apply action was rejected by automatic approval review because it interpreted the operation as a high-risk schema change and did not accept the pasted authorization as trusted direct approval. No alternate path was used; post-rejection inventory confirmed the remote project remained unchanged. The migration is unapplied and Edge Function is undeployed. Database parsing/replay, pgTAP/RLS and endpoint integration are still unverified.
- No professionally reviewed content was supplied or published, so article/assessment journeys cannot yet be verified against real content. Do not mark Phase 3 complete.
