# Architecture

## Final Phase 3 backend verification (2026-10-31)

- The linked development database has four Phase 3 migration records. `20261031095050_fix_assessment_publication_policy_correlation.sql` fixes the public assessment policy so a published version is correlated to its outer `education_assessments.id`; before it, the unqualified `id` resolved to the version table and formed a tautological comparison. The correction is applied and verified in the remote `pg_policies` catalog.
- The 23 Phase 3 app tables all have RLS enabled. There are 6 private tables with no policies; these remain inaccessible through client roles by RLS default-deny. Client grants do not expose answer keys, explanations or limiter rows. The `score_assessment` and `consume_guest_assessment_rate_limit` RPCs are executable by `service_role` only. The Edge Function is ACTIVE v2; only its server environment holds `SUPABASE_SERVICE_ROLE_KEY`.
- Guest rate limit: first trusted forwarded address is used by `firstForwardedIp`; 20 accepted / 21st rejected within a fixed 10-minute bucket. Older than one-day rows are deleted opportunistically on a later guest attempt, not by scheduled expiry. The database gate passed a reserved-IP check; a live HTTP 429 response is still unverified because the ingress did not record the supplied reserved forwarding header and repeat traffic could throttle a shared caller.
- Content and progress tables have no records. No synthetic content was seeded. Consequently, public content retrieval, positive scoring, authenticated sync/retries, and account-isolation flows remain runtime-unverified. No clinical content has been approved or published.
- `clear_my_learning_history()` is an authenticated SECURITY DEFINER RPC flagged by the advisor. Its current function reads `auth.uid()`, rejects null identity, and updates only that user's history marker; keep it under security review and test the live owner-isolation path before completion.

## Phase 3 guest scoring abuse control

The guest-capable `submit-assessment` Edge Function validates optional user sessions and applies a shared database-backed limit to guest submissions before scoring. The private `yegna_private.guest_assessment_rate_limits` table is keyed by the gateway-supplied client IP and ten-minute fixed window; the service-only atomic RPC allows 20 requests per window and deletes rows older than one day opportunistically during later guest calls. There is no scheduled cleanup. Client roles cannot read the table or execute the RPC. Authenticated calls do not use the guest quota. Development catalog/threshold checks passed; live HTTP 429 and trust behavior for forwarded headers still require endpoint-level verification.

## Current structure

```text
lib/
  main.dart                 startup, dependencies, MaterialApp
  l10n/                     source ARB translations
  src/
    app.dart                five-destination navigation shell and Account entry
    home/                   Stitch-inspired public Home, existing education-repo articles
    discovery/              Facilities/Mentors presentation-only empty states
    locale_controller.dart  supported locale preference
    auth/                   auth contract, validation, controller, UI, Supabase adapter, secure storage
    learning/               education/assessment repositories, bounded cache, progress controller and UI
supabase/
  migrations/               two Phase 3 additive migrations, applied to development
  functions/                guest-capable server-scoring Edge Function, deployed to development
test/                       controller, localization, learning UI and cache tests
```

## Stitch UI integration boundary (2026-10-30)

`AppShell` uses Material 3 `NavigationBar` destinations for Home, Facilities, Mentors, Learning and Account. An `IndexedStack` retains each destination while `TickerMode` pauses inactive animations. Home receives the existing `EducationRepository` and routes article IDs into the existing article-detail flow. Learning remains connected to the existing repositories/controllers. Account routes into the existing provider-backed auth/profile UI and displays existing progress/language controls. Facilities and Mentors currently have no repository or directory data contract; their disabled controls and localized empty states are a safe presentation shell only. They are not functional provider/facility directories and do not imply Phase 4 has started.

Generated `lib/l10n/app_localizations*.dart` files belong to Flutter tooling; `flutter gen-l10n` creates them from ARB resources, and they must not be hand-edited.

## Data flow

At startup, `main` initializes Flutter, reads `preferred_locale` from SharedPreferences, and initializes Supabase only when URL and publishable key are supplied via `--dart-define-from-file`. It injects provider-backed education, assessment and progress repositories only when Supabase initializes; otherwise the public Learn tab shows localized unavailable/empty states. The linked development project contains the Phase 3 schema and deployed scorer, but all content/progress tables are empty. Catalog/RLS and negative HTTP behavior are checked; positive learning, scoring and sync workflows remain unverified.

## Dependencies

- Flutter SDK and `flutter_localizations`: Material 3, platform widgets, locale delegates.
- `intl`: Flutter localization support.
- `shared_preferences`: non-sensitive UI language preference only; not for credentials or health records.
- `supabase_flutter` (pinned `2.15.4`): approved auth provider SDK, PKCE email/password flows, confirmation/recovery deep links, token refresh and auth state.
- `flutter_secure_storage` (pinned `9.2.4`): platform secure storage for Supabase session and PKCE verifier values.
- `path_provider` (`^2.1.6`): locates app-private support storage for public educational content cache. Cache payloads do not include answer keys.
- `flutter_lints`: static-analysis baseline.
- Flutter SDK test framework: unit/widget test infrastructure.

## Future boundaries

Keep widgets presentation-focused. Add feature/domain/data layers only as requirements justify them. Isolate remote APIs behind typed repository interfaces, validate responses, apply timeouts and recoverable errors, and keep secrets server-side. Decide authentication, backend, database, maps, health-content provenance, and offline storage after requirements, legal/privacy constraints, and operating context are assessed. Do not store identifiable health information in plain preferences.

## Phase 2 authentication boundary

`AuthController` owns UI state and validation. `AuthRepository` is the provider-independent contract; `SupabaseAuthRepository` calls Supabase Auth for registration, password sign-in, recovery, password update, display-name update and sign-out. Provider errors map to app-owned issue codes before localization. Authentication requires a Supabase-issued session and confirmed email. Supabase uses PKCE and the native callback `com.yegnahealth.amharic://auth-callback`.

`SecureAuthStorage` uses `flutter_secure_storage` for session and PKCE material. SharedPreferences remains limited to language selection. A single display name is held in Auth `user_metadata` for display/editing only; it is user-editable and is **not** used for authorization/RLS. No database tables or SQL migrations were created. A separate profile table would need a justified schema and owner-reviewed RLS design.

The account route is available from a visible Home button and the Settings account tile, separate from public tabs; profile data is shown only for a provider-confirmed session. Expired/removed sessions show a sign-in prompt. Email confirmation must remain enabled. The provider redirect allowlist and Android deep-link filter must stay aligned. The app consumes only a publishable client key; never include service-role/secret keys.

The owner reports successful real-account manual testing of registration, email confirmation and password recovery. The current workspace did not independently repeat those flows. Supabase SMTP configuration and production delivery, sender identity and deliverability remain unverified; verify these before production use. See `KNOWN_ISSUES.md`.

## Phase 3 local implementation architecture

- `EducationRepository` and `AssessmentRepository` isolate typed UI-facing data; Supabase adapters fetch only published English/Amharic content and reviewed/unexpired rows. UI search is literal client-side matching against loaded title/summary. The PostgreSQL Amharic search strategy remains unselected until tested against reviewed Amharic content.
- `LearningCache` stores public categories, article previews, article bodies and quiz questions/options in app support storage. Entries older than seven days are marked stale; the cache enforces a 50 MiB LRU cap. An online missing/withdrawn translation removes its cache item; offline copies remain available with a warning. Quiz submissions never receive an offline score.
- Guest and per-user progress is partitioned in `flutter_secure_storage`. Sync defaults off, requires authenticated opt-in and can be disabled. The migration draft requires the sync preference in RLS for cloud article writes. Attempts are scored by the server. Clearing synced history uses an own-user database function and retains local records.
- `submit-assessment` accepts bounded guest POSTs with a public API key and no Auth account, or validates a supplied access token with Supabase Auth. It calls a service-only scoring RPC. Keys/explanations are stored in the unexposed `yegna_private` schema. The service-role key is read server-side and never supplied to Flutter.
- The migrations and Edge Function are deployed to the linked development project. Remote catalog assertions verified RLS, grants, private-answer access restrictions and sync-consent policies. Negative endpoint behavior was tested over HTTP. The pgTAP suite remains unrun (Docker engine unavailable and remote pgTAP extension absent); positive scoring, authenticated sync, and account-isolation integration remain unverified because no approved quiz content or authenticated integration test session is available.

### Latest Phase 3 migration review (2026-10-30)

The draft migration was reviewed against a read-only inventory of the confirmed `yegna-health-amharic` development project (active/healthy, PostgreSQL 17, no app migrations, app tables, or Edge Functions). Article and assessment publication RLS now uses narrow `SECURITY DEFINER` boolean predicates in the unexposed `yegna_private` schema with a fixed empty search path, avoiding recursive related-table policies. Public-table privileges are explicitly revoked before the intended read/owner-scoped grants. The own-history clearing RPC is narrowly authenticated and no longer allows clients to alter its server-maintained marker directly. These are local draft properties only; they are not live until a migration is applied and database-role tests pass.

The direct remote migration application was rejected by automatic approval review. No remote schema change or Edge Function deployment occurred, and no indirect workaround was attempted. See `TESTING.md` for the approval blocker and command results.
