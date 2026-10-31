-- Phase 3 learning content and progress foundation.
-- Content writes are restricted to service_role until a vetted editorial client exists.
create schema if not exists yegna_private;
revoke all on schema yegna_private from public, anon, authenticated;
grant usage on schema yegna_private to service_role;

create type public.content_publication_status as enum ('draft', 'review', 'approved', 'published', 'withdrawn');
grant usage on type public.content_publication_status to anon, authenticated, service_role;

create table public.education_categories (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  sort_order integer not null default 0,
  publication_status public.content_publication_status not null default 'draft',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.education_category_translations (
  category_id uuid not null references public.education_categories(id) on delete cascade,
  locale text not null check (locale in ('en', 'am')),
  name text not null check (length(trim(name)) between 1 and 120),
  description text not null default '',
  publication_status public.content_publication_status not null default 'draft',
  reviewed_at timestamptz,
  reviewed_by uuid references auth.users(id) on delete set null,
  primary key (category_id, locale)
);

create table public.education_articles (
  id uuid primary key default gen_random_uuid(),
  category_id uuid not null references public.education_categories(id) on delete restrict,
  slug text not null unique check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index education_articles_category_idx on public.education_articles(category_id, id);

create table public.education_article_translations (
  article_id uuid not null references public.education_articles(id) on delete cascade,
  locale text not null check (locale in ('en', 'am')),
  title text not null check (length(trim(title)) between 1 and 200),
  summary text not null default '' check (length(summary) <= 1000),
  body_markdown text not null check (length(body_markdown) <= 200000),
  content_revision integer not null default 1 check (content_revision > 0),
  created_by uuid not null references auth.users(id) on delete restrict,
  publication_status public.content_publication_status not null default 'draft',
  reviewed_at timestamptz,
  review_due_at timestamptz,
  reviewed_by uuid references auth.users(id) on delete set null,
  publisher_id uuid references auth.users(id) on delete set null,
  published_at timestamptz,
  updated_at timestamptz not null default now(),
  primary key (article_id, locale),
  check (review_due_at is null or reviewed_at is null or review_due_at >= reviewed_at),
  check (publication_status <> 'published' or (reviewed_by is not null and reviewed_at is not null and review_due_at is not null and publisher_id is not null and published_at is not null))
);
create index education_article_translations_public_idx
  on public.education_article_translations(locale, updated_at desc)
  where publication_status = 'published';

create table public.education_article_sources (
  id uuid primary key default gen_random_uuid(),
  article_id uuid not null references public.education_articles(id) on delete cascade,
  locale text check (locale in ('en', 'am')),
  citation_title text not null,
  publisher text not null,
  canonical_url text,
  identifier text,
  published_on date,
  accessed_at timestamptz not null default now(),
  sort_order integer not null default 0,
  check (canonical_url is not null or identifier is not null)
);
create index education_article_sources_article_idx on public.education_article_sources(article_id, locale, sort_order);

create table public.education_article_relations (
  article_id uuid not null references public.education_articles(id) on delete cascade,
  related_article_id uuid not null references public.education_articles(id) on delete cascade,
  locale text not null check (locale in ('en', 'am')),
  sort_order integer not null default 0,
  primary key (article_id, related_article_id, locale),
  check (article_id <> related_article_id)
);
create index education_article_relations_order_idx on public.education_article_relations(article_id, locale, sort_order);

create table public.education_assessments (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.education_assessment_versions (
  id uuid primary key default gen_random_uuid(),
  assessment_id uuid not null references public.education_assessments(id) on delete restrict,
  version integer not null check (version > 0),
  publication_status public.content_publication_status not null default 'draft',
  published_at timestamptz,
  unique (assessment_id, version),
  unique (id, assessment_id)
);
create index education_assessment_versions_public_idx on public.education_assessment_versions(assessment_id, version desc)
  where publication_status = 'published';

create table public.education_assessment_sources (
  id uuid primary key default gen_random_uuid(),
  version_id uuid not null references public.education_assessment_versions(id) on delete cascade,
  locale text check (locale in ('en', 'am')),
  citation_title text not null,
  publisher text not null,
  canonical_url text,
  identifier text,
  published_on date,
  accessed_at timestamptz not null default now(),
  sort_order integer not null default 0,
  check (canonical_url is not null or identifier is not null)
);
create index education_assessment_sources_version_idx on public.education_assessment_sources(version_id, locale, sort_order);

create table public.education_assessment_version_translations (
  version_id uuid not null references public.education_assessment_versions(id) on delete cascade,
  locale text not null check (locale in ('en', 'am')),
  title text not null check (length(trim(title)) between 1 and 200),
  description text not null default '',
  instructions text not null default '',
  created_by uuid not null references auth.users(id) on delete restrict,
  publication_status public.content_publication_status not null default 'draft',
  reviewed_at timestamptz,
  review_due_at timestamptz,
  reviewed_by uuid references auth.users(id) on delete set null,
  publisher_id uuid references auth.users(id) on delete set null,
  published_at timestamptz,
  primary key (version_id, locale),
  check (publication_status <> 'published' or (reviewed_by is not null and reviewed_at is not null and review_due_at is not null and publisher_id is not null and published_at is not null))
);
create index education_assessment_translations_public_idx on public.education_assessment_version_translations(locale, version_id)
  where publication_status = 'published';

create table public.education_assessment_questions (
  id uuid primary key default gen_random_uuid(),
  version_id uuid not null references public.education_assessment_versions(id) on delete cascade,
  position integer not null check (position > 0),
  unique (version_id, position),
  unique (id, version_id)
);
create index education_assessment_questions_order_idx on public.education_assessment_questions(version_id, position);

create table public.education_assessment_question_translations (
  question_id uuid not null references public.education_assessment_questions(id) on delete cascade,
  locale text not null check (locale in ('en', 'am')),
  prompt text not null check (length(trim(prompt)) between 1 and 2000),
  primary key (question_id, locale)
);

create table public.education_assessment_options (
  id uuid primary key default gen_random_uuid(),
  question_id uuid not null references public.education_assessment_questions(id) on delete cascade,
  position integer not null check (position > 0),
  unique (question_id, position),
  unique (id, question_id)
);

create table public.education_assessment_option_translations (
  option_id uuid not null references public.education_assessment_options(id) on delete cascade,
  locale text not null check (locale in ('en', 'am')),
  label text not null check (length(trim(label)) between 1 and 1000),
  primary key (option_id, locale)
);

-- This schema is not exposed by the Data API. Answer keys are never returned by quiz-content queries.
create table yegna_private.education_assessment_answer_keys (
  question_id uuid primary key references public.education_assessment_questions(id) on delete cascade,
  option_id uuid not null,
  foreign key (option_id, question_id)
    references public.education_assessment_options(id, question_id) on delete cascade
);
create table yegna_private.education_assessment_explanations (
  question_id uuid not null references public.education_assessment_questions(id) on delete cascade,
  locale text not null check (locale in ('en', 'am')),
  explanation text not null check (length(trim(explanation)) between 1 and 4000),
  primary key (question_id, locale),
  foreign key (question_id, locale)
    references public.education_assessment_question_translations(question_id, locale) on delete cascade
);
grant select, insert, update, delete on all tables in schema yegna_private to service_role;

create or replace function yegna_private.guard_article_publication()
returns trigger language plpgsql security definer set search_path = '' as $$
declare v_health record;
begin
  if new.publication_status <> 'published' then return new; end if;
  if not exists (
    select 1 from yegna_private.editorial_memberships m
    where m.user_id = new.created_by and m.role = 'content_author'
  ) then raise exception 'content author role required'; end if;
  if not exists (
    select 1 from yegna_private.editorial_memberships m
    where m.user_id = new.publisher_id and m.role = 'publisher_admin'
  ) then raise exception 'publisher role required'; end if;
  select a.reviewer_id, a.approved_at, a.review_due_at into v_health
    from yegna_private.article_review_approvals a
    join yegna_private.editorial_memberships m on m.user_id = a.reviewer_id and m.role = 'health_reviewer'
    where a.article_id = new.article_id and a.locale = new.locale and a.review_kind = 'health'
      and a.review_due_at >= now()
    order by a.approved_at desc limit 1;
  if v_health.reviewer_id is null then raise exception 'current health review required'; end if;
  if new.locale = 'am' and not exists (
    select 1 from yegna_private.article_review_approvals a
    join yegna_private.editorial_memberships m on m.user_id = a.reviewer_id and m.role = 'amharic_medical_reviewer'
    where a.article_id = new.article_id and a.locale = new.locale and a.review_kind = 'amharic_medical_language'
      and a.review_due_at >= now()
  ) then raise exception 'current Amharic medical-language review required'; end if;
  if not exists (
    select 1 from public.education_article_sources s
    where s.article_id = new.article_id and (s.locale is null or s.locale = new.locale)
  ) then raise exception 'source reference required'; end if;
  new.reviewed_by := v_health.reviewer_id;
  new.reviewed_at := v_health.approved_at;
  new.review_due_at := v_health.review_due_at;
  new.published_at := coalesce(new.published_at, now());
  return new;
end;
$$;
create trigger guard_article_publication before insert or update on public.education_article_translations
  for each row execute function yegna_private.guard_article_publication();

create or replace function yegna_private.protect_published_article_translation()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  if tg_op = 'UPDATE' and old.publication_status = 'published' then
    if new.publication_status = 'withdrawn' then
      if (to_jsonb(new) - 'publication_status') <> (to_jsonb(old) - 'publication_status') then
        raise exception 'published article content is immutable';
      end if;
      if not exists (select 1 from yegna_private.editorial_memberships m
        where m.user_id = new.publisher_id and m.role = 'publisher_admin') then
        raise exception 'publisher role required to withdraw content';
      end if;
      return new;
    end if;
    if to_jsonb(new) <> to_jsonb(old) then
      raise exception 'published article content is immutable; create a new revision';
    end if;
  elsif tg_op = 'DELETE' and old.publication_status = 'published' then
    raise exception 'published article translation cannot be deleted; withdraw it';
  end if;
  if tg_op = 'DELETE' then return old; end if;
  return new;
end;
$$;
create trigger protect_published_article_translation before update or delete on public.education_article_translations
  for each row execute function yegna_private.protect_published_article_translation();

create or replace function yegna_private.protect_published_article_source()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  if exists (select 1 from public.education_article_translations t
    where t.article_id = coalesce(new.article_id, old.article_id) and t.publication_status = 'published') then
    raise exception 'sources for published articles are immutable';
  end if;
  if tg_op = 'DELETE' then return old; end if;
  return new;
end;
$$;
create trigger protect_published_article_source before insert or update or delete on public.education_article_sources
  for each row execute function yegna_private.protect_published_article_source();

create or replace function yegna_private.protect_published_article_identity()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  if exists (select 1 from public.education_article_translations t
    where t.article_id = old.id and t.publication_status = 'published') then
    raise exception 'published article cannot be deleted or reclassified';
  end if;
  if tg_op = 'DELETE' then return old; end if;
  return new;
end;
$$;
create trigger protect_published_article_identity before update or delete on public.education_articles
  for each row execute function yegna_private.protect_published_article_identity();

create or replace function yegna_private.guard_assessment_publication()
returns trigger language plpgsql security definer set search_path = '' as $$
declare
  v_question_count integer;
  v_health record;
begin
  if new.publication_status <> 'published' then return new; end if;
  if not exists (
    select 1 from yegna_private.editorial_memberships m
    where m.user_id = new.created_by and m.role = 'content_author'
  ) then raise exception 'content author role required'; end if;
  if not exists (
    select 1 from yegna_private.editorial_memberships m
    where m.user_id = new.publisher_id and m.role = 'publisher_admin'
  ) then raise exception 'publisher role required'; end if;
  select a.reviewer_id, a.approved_at, a.review_due_at into v_health
    from yegna_private.assessment_review_approvals a
    join yegna_private.editorial_memberships m on m.user_id = a.reviewer_id and m.role = 'health_reviewer'
    where a.version_id = new.version_id and a.locale = new.locale and a.review_kind = 'health'
      and a.review_due_at >= now()
    order by a.approved_at desc limit 1;
  if v_health.reviewer_id is null then raise exception 'current health review required'; end if;
  if new.locale = 'am' and not exists (
    select 1 from yegna_private.assessment_review_approvals a
    join yegna_private.editorial_memberships m on m.user_id = a.reviewer_id and m.role = 'amharic_medical_reviewer'
    where a.version_id = new.version_id and a.locale = new.locale and a.review_kind = 'amharic_medical_language'
      and a.review_due_at >= now()
  ) then raise exception 'current Amharic medical-language review required'; end if;
  if not exists (
    select 1 from public.education_assessment_sources s
    where s.version_id = new.version_id and (s.locale is null or s.locale = new.locale)
  ) then raise exception 'source reference required'; end if;
  select count(*) into v_question_count from public.education_assessment_questions q
    where q.version_id = new.version_id;
  if v_question_count = 0 or exists (
    select 1 from public.education_assessment_questions q
    left join public.education_assessment_question_translations qt on qt.question_id = q.id and qt.locale = new.locale
    left join yegna_private.education_assessment_answer_keys k on k.question_id = q.id
    left join yegna_private.education_assessment_explanations e on e.question_id = q.id and e.locale = new.locale
    where q.version_id = new.version_id and (qt.question_id is null or k.question_id is null or e.question_id is null)
  ) then raise exception 'complete reviewed question set required'; end if;
  if exists (
    select 1 from public.education_assessment_questions q
    join public.education_assessment_options o on o.question_id = q.id
    left join public.education_assessment_option_translations ot on ot.option_id = o.id and ot.locale = new.locale
    where q.version_id = new.version_id and ot.option_id is null
  ) then raise exception 'localized answer options required'; end if;
  new.reviewed_by := v_health.reviewer_id;
  new.reviewed_at := v_health.approved_at;
  new.review_due_at := v_health.review_due_at;
  new.published_at := coalesce(new.published_at, now());
  return new;
end;
$$;
create trigger guard_assessment_publication before insert or update on public.education_assessment_version_translations
  for each row execute function yegna_private.guard_assessment_publication();

create or replace function yegna_private.protect_published_assessment_translation()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  if tg_op = 'UPDATE' and old.publication_status = 'published' then
    if new.publication_status = 'withdrawn' then
      if (to_jsonb(new) - 'publication_status') <> (to_jsonb(old) - 'publication_status') then
        raise exception 'published assessment translation is immutable';
      end if;
      if not exists (select 1 from yegna_private.editorial_memberships m
        where m.user_id = new.publisher_id and m.role = 'publisher_admin') then
        raise exception 'publisher role required to withdraw content';
      end if;
      return new;
    end if;
    if to_jsonb(new) <> to_jsonb(old) then
      raise exception 'published assessment translation is immutable; create a new version';
    end if;
  elsif tg_op = 'DELETE' and old.publication_status = 'published' then
    raise exception 'published assessment translation cannot be deleted; withdraw it';
  end if;
  if tg_op = 'DELETE' then return old; end if;
  return new;
end;
$$;
create trigger protect_published_assessment_translation before update or delete on public.education_assessment_version_translations
  for each row execute function yegna_private.protect_published_assessment_translation();

create or replace function yegna_private.protect_published_assessment_version()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  if exists (select 1 from public.education_assessment_version_translations t
    where t.version_id = old.id and t.publication_status = 'published') then
    raise exception 'published assessment version is immutable; create a new version or withdraw its translations';
  end if;
  if tg_op = 'DELETE' then return old; end if;
  return new;
end;
$$;
create trigger protect_published_assessment_version before update or delete on public.education_assessment_versions
  for each row execute function yegna_private.protect_published_assessment_version();

create or replace function yegna_private.protect_published_assessment_content()
returns trigger language plpgsql security definer set search_path = '' as $$
declare
  v_question_id uuid;
  v_version_id uuid;
  v_published boolean := false;
begin
  if tg_table_name = 'education_assessment_questions' then
    v_version_id := coalesce((to_jsonb(new)->>'version_id')::uuid, (to_jsonb(old)->>'version_id')::uuid);
  elsif tg_table_name = 'education_assessment_question_translations' then
    v_question_id := coalesce((to_jsonb(new)->>'question_id')::uuid, (to_jsonb(old)->>'question_id')::uuid);
  elsif tg_table_name = 'education_assessment_options' then
    v_question_id := coalesce((to_jsonb(new)->>'question_id')::uuid, (to_jsonb(old)->>'question_id')::uuid);
  elsif tg_table_name = 'education_assessment_option_translations' then
    v_question_id := coalesce(
      (select o.question_id from public.education_assessment_options o where o.id = (to_jsonb(new)->>'option_id')::uuid),
      (select o.question_id from public.education_assessment_options o where o.id = (to_jsonb(old)->>'option_id')::uuid)
    );
  elsif tg_table_schema = 'yegna_private' and tg_table_name = 'education_assessment_answer_keys' then
    v_question_id := coalesce((to_jsonb(new)->>'question_id')::uuid, (to_jsonb(old)->>'question_id')::uuid);
  elsif tg_table_schema = 'yegna_private' and tg_table_name = 'education_assessment_explanations' then
    v_question_id := coalesce((to_jsonb(new)->>'question_id')::uuid, (to_jsonb(old)->>'question_id')::uuid);
  elsif tg_table_name = 'education_assessment_sources' then
    v_version_id := coalesce((to_jsonb(new)->>'version_id')::uuid, (to_jsonb(old)->>'version_id')::uuid);
  end if;
  if v_version_id is null and v_question_id is not null then
    select q.version_id into v_version_id from public.education_assessment_questions q where q.id = v_question_id;
  end if;
  if v_version_id is not null then
    select exists (
      select 1 from public.education_assessment_versions v
      left join public.education_assessment_version_translations t on t.version_id = v.id
      where v.id = v_version_id and (v.publication_status = 'published' or t.publication_status = 'published')
    ) into v_published;
  end if;
  if v_published then raise exception 'published assessment versions are immutable; create a new version'; end if;
  if tg_op = 'DELETE' then return old; end if;
  return new;
end;
$$;
create trigger protect_published_questions before insert or update or delete on public.education_assessment_questions
  for each row execute function yegna_private.protect_published_assessment_content();
create trigger protect_published_question_translations before insert or update or delete on public.education_assessment_question_translations
  for each row execute function yegna_private.protect_published_assessment_content();
create trigger protect_published_options before insert or update or delete on public.education_assessment_options
  for each row execute function yegna_private.protect_published_assessment_content();
create trigger protect_published_option_translations before insert or update or delete on public.education_assessment_option_translations
  for each row execute function yegna_private.protect_published_assessment_content();
create trigger protect_published_answer_keys before insert or update or delete on yegna_private.education_assessment_answer_keys
  for each row execute function yegna_private.protect_published_assessment_content();
create trigger protect_published_assessment_explanations before insert or update or delete on yegna_private.education_assessment_explanations
  for each row execute function yegna_private.protect_published_assessment_content();
create trigger protect_published_assessment_sources before insert or update or delete on public.education_assessment_sources
  for each row execute function yegna_private.protect_published_assessment_content();

create table public.user_learning_preferences (
  user_id uuid primary key references auth.users(id) on delete cascade,
  sync_enabled boolean not null default false,
  history_cleared_at timestamptz,
  updated_at timestamptz not null default now()
);

create table public.user_article_progress (
  user_id uuid not null references auth.users(id) on delete cascade,
  article_id uuid not null references public.education_articles(id) on delete cascade,
  locale text not null check (locale in ('en', 'am')),
  completed_at timestamptz not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, article_id, locale)
);
create index user_article_progress_user_updated_idx on public.user_article_progress(user_id, updated_at desc);

create table public.user_assessment_attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  version_id uuid not null references public.education_assessment_versions(id) on delete restrict,
  locale text not null check (locale in ('en', 'am')),
  request_id uuid not null,
  payload_fingerprint text not null,
  score integer not null check (score >= 0),
  total_questions integer not null check (total_questions > 0),
  completed_at timestamptz not null default now(),
  unique (user_id, request_id)
);
create index user_assessment_attempts_history_idx on public.user_assessment_attempts(user_id, completed_at desc);

-- Editorial role and review records are private; assignment alone never exposes drafts.
create table yegna_private.editorial_memberships (
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null check (role in ('content_author', 'health_reviewer', 'amharic_medical_reviewer', 'publisher_admin')),
  primary key (user_id, role)
);
create table yegna_private.article_review_approvals (
  article_id uuid not null,
  locale text not null check (locale in ('en', 'am')),
  reviewer_id uuid not null references auth.users(id) on delete restrict,
  review_kind text not null check (review_kind in ('health', 'amharic_medical_language')),
  approved_at timestamptz not null default now(),
  review_due_at timestamptz not null,
  primary key (article_id, locale, reviewer_id, review_kind),
  foreign key (article_id, locale) references public.education_article_translations(article_id, locale) on delete cascade
);
create table yegna_private.assessment_review_approvals (
  version_id uuid not null,
  locale text not null check (locale in ('en', 'am')),
  reviewer_id uuid not null references auth.users(id) on delete restrict,
  review_kind text not null check (review_kind in ('health', 'amharic_medical_language')),
  approved_at timestamptz not null default now(),
  review_due_at timestamptz not null,
  primary key (version_id, locale, reviewer_id, review_kind),
  foreign key (version_id, locale) references public.education_assessment_version_translations(version_id, locale) on delete cascade
);
grant select, insert, update, delete on all tables in schema yegna_private to service_role;
alter table yegna_private.education_assessment_answer_keys enable row level security;
alter table yegna_private.education_assessment_explanations enable row level security;
alter table yegna_private.editorial_memberships enable row level security;
alter table yegna_private.article_review_approvals enable row level security;
alter table yegna_private.assessment_review_approvals enable row level security;

-- Only the Edge Function's server-only service_role key can call this trusted scorer.
-- The function validates the published quiz, checks every submitted option and reads answer
-- keys server-side. It returns explanations only after submission and never returns keys on fetch.
create or replace function public.score_assessment(
  p_user_id uuid,
  p_version_id uuid,
  p_locale text,
  p_request_id uuid,
  p_answers jsonb,
  p_payload_fingerprint text,
  p_sync_enabled boolean
) returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_question_count integer;
  v_answer_count integer;
  v_score integer;
  v_existing public.user_assessment_attempts;
  v_detail jsonb;
  v_result jsonb;
begin
  if p_answers is null or jsonb_typeof(p_answers) <> 'array' then
    raise exception 'invalid submission';
  end if;
  if p_locale not in ('en', 'am') or p_request_id is null or
     jsonb_array_length(p_answers) not between 1 and 50 then
    raise exception 'invalid submission';
  end if;
  select count(*) into v_question_count from public.education_assessment_questions q
    where q.version_id = p_version_id;
  select count(*) into v_answer_count from jsonb_array_elements(p_answers) as submissions(item);
  if v_question_count = 0 or v_question_count <> v_answer_count then
    raise exception 'incomplete submission';
  end if;
  if exists (
    select 1 from (
      select submitted_json.item->>'questionId' as question_id,
             submitted_json.item->>'optionId' as option_id
      from jsonb_array_elements(p_answers) as submitted_json(item)
    ) submitted
    left join public.education_assessment_questions q
      on q.id::text = submitted.question_id and q.version_id = p_version_id
    left join public.education_assessment_options o
      on o.id::text = submitted.option_id and o.question_id::text = submitted.question_id
    where q.id is null or o.id is null
  ) or (
    select count(distinct submitted_json.item->>'questionId') from jsonb_array_elements(p_answers) as submitted_json(item)
  ) <> v_question_count then
    raise exception 'invalid answer selection';
  end if;

  if p_user_id is not null and p_sync_enabled then
    select * into v_existing from public.user_assessment_attempts
      where user_id = p_user_id and request_id = p_request_id;
    if found and v_existing.payload_fingerprint <> p_payload_fingerprint then
      raise exception 'request id already used for a different answer payload';
    end if;
  end if;
  if v_existing.id is null and not exists (
    select 1
    from public.education_assessment_versions v
    join public.education_assessment_version_translations t on t.version_id = v.id
    where v.id = p_version_id and v.publication_status = 'published'
      and t.locale = p_locale and t.publication_status = 'published'
      and t.review_due_at >= now()
  ) then
    raise exception 'assessment unavailable';
  end if;

  select count(*) filter (where k.option_id = (submitted.item->>'optionId')::uuid)
    into v_score
    from jsonb_array_elements(p_answers) submitted(item)
    join public.education_assessment_questions q on q.id = (submitted.item->>'questionId')::uuid
      and q.version_id = p_version_id
    join yegna_private.education_assessment_answer_keys k on k.question_id = q.id;

  select jsonb_agg(jsonb_build_object(
    'questionId', q.id,
    'selectedOptionId', (answers.item->>'optionId')::uuid,
    'correctOptionId', k.option_id,
    'isCorrect', k.option_id = (answers.item->>'optionId')::uuid,
    'explanation', e.explanation
  ) order by q.position) into v_detail
  from jsonb_array_elements(p_answers) answers(item)
  join public.education_assessment_questions q on q.id = (answers.item->>'questionId')::uuid
    and q.version_id = p_version_id
  join yegna_private.education_assessment_answer_keys k on k.question_id = q.id
  join yegna_private.education_assessment_explanations e on e.question_id = q.id and e.locale = p_locale;

  if jsonb_array_length(coalesce(v_detail, '[]'::jsonb)) <> v_question_count then
    raise exception 'assessment unavailable';
  end if;

  if p_user_id is not null and p_sync_enabled then
    if v_existing.id is not null then
      v_score := v_existing.score;
    else
      if not exists (select 1 from public.user_learning_preferences pref
        where pref.user_id = p_user_id and pref.sync_enabled) then
        raise exception 'progress synchronization is disabled';
      end if;
      insert into public.user_assessment_attempts
        (user_id, version_id, locale, request_id, payload_fingerprint, score, total_questions)
      values (p_user_id, p_version_id, p_locale, p_request_id, p_payload_fingerprint, v_score, v_question_count)
      on conflict (user_id, request_id) do nothing;
      select * into v_existing from public.user_assessment_attempts
        where user_id = p_user_id and request_id = p_request_id;
      if v_existing.payload_fingerprint <> p_payload_fingerprint then
        raise exception 'request id already used for a different answer payload';
      end if;
      v_score := v_existing.score;
    end if;
  end if;

  v_result := jsonb_build_object(
    'score', v_score,
    'totalQuestions', v_question_count,
    'details', v_detail
  );
  return v_result;
end;
$$;
revoke all on function public.score_assessment(uuid, uuid, text, uuid, jsonb, text, boolean) from public, anon, authenticated;
grant execute on function public.score_assessment(uuid, uuid, text, uuid, jsonb, text, boolean) to service_role;

create or replace function public.clear_my_learning_history()
returns void language plpgsql security definer set search_path = '' as $$
declare
  v_user_id uuid := auth.uid();
begin
  if v_user_id is null then
    raise exception 'authenticated user required';
  end if;
  delete from public.user_article_progress where user_id = v_user_id;
  delete from public.user_assessment_attempts where user_id = v_user_id;
  update public.user_learning_preferences
    set history_cleared_at = now(), updated_at = now()
    where user_id = v_user_id;
end;
$$;
revoke all on function public.clear_my_learning_history() from public, anon;
grant execute on function public.clear_my_learning_history() to authenticated;

alter table public.education_categories enable row level security;
alter table public.education_category_translations enable row level security;
alter table public.education_articles enable row level security;
alter table public.education_article_translations enable row level security;
alter table public.education_article_sources enable row level security;
alter table public.education_article_relations enable row level security;
alter table public.education_assessments enable row level security;
alter table public.education_assessment_versions enable row level security;
alter table public.education_assessment_sources enable row level security;
alter table public.education_assessment_version_translations enable row level security;
alter table public.education_assessment_questions enable row level security;
alter table public.education_assessment_question_translations enable row level security;
alter table public.education_assessment_options enable row level security;
alter table public.education_assessment_option_translations enable row level security;
alter table public.user_learning_preferences enable row level security;
alter table public.user_article_progress enable row level security;
alter table public.user_assessment_attempts enable row level security;

create policy published_categories_read on public.education_categories for select to anon, authenticated
  using (publication_status = 'published');
create policy published_category_translations_read on public.education_category_translations for select to anon, authenticated
  using (publication_status = 'published' and exists (select 1 from public.education_categories c where c.id = category_id and c.publication_status = 'published'));
-- Security-definer predicates keep related-row RLS checks from recursively invoking
-- one another. They return only a publication boolean and use a fixed empty search_path.
create or replace function yegna_private.article_translation_is_public(
  p_article_id uuid,
  p_locale text
) returns boolean
language sql stable security definer set search_path = '' as $$
  select (p_locale is null or p_locale in ('en', 'am')) and exists (
    select 1
    from public.education_article_translations t
    join public.education_articles a on a.id = t.article_id
    join public.education_categories c on c.id = a.category_id
    join public.education_category_translations ct
      on ct.category_id = c.id and ct.locale = t.locale
    where t.article_id = p_article_id and (p_locale is null or t.locale = p_locale)
      and t.publication_status = 'published' and t.review_due_at >= now()
      and c.publication_status = 'published' and ct.publication_status = 'published'
  );
$$;

create or replace function yegna_private.assessment_translation_is_public(
  p_version_id uuid,
  p_locale text
) returns boolean
language sql stable security definer set search_path = '' as $$
  select (p_locale is null or p_locale in ('en', 'am')) and exists (
    select 1
    from public.education_assessment_versions v
    join public.education_assessment_version_translations t on t.version_id = v.id
    where v.id = p_version_id and v.publication_status = 'published'
      and t.publication_status = 'published' and t.review_due_at >= now()
      and (p_locale is null or t.locale = p_locale)
  );
$$;

revoke all on function yegna_private.article_translation_is_public(uuid, text) from public;
revoke all on function yegna_private.assessment_translation_is_public(uuid, text) from public;
grant usage on schema yegna_private to anon, authenticated;
grant execute on function yegna_private.article_translation_is_public(uuid, text) to anon, authenticated;
grant execute on function yegna_private.assessment_translation_is_public(uuid, text) to anon, authenticated;

create policy published_articles_read on public.education_articles for select to anon, authenticated
  using (yegna_private.article_translation_is_public(id, null));
create policy published_article_translations_read on public.education_article_translations for select to anon, authenticated
  using (yegna_private.article_translation_is_public(article_id, locale));
create policy published_article_sources_read on public.education_article_sources for select to anon, authenticated
  using (yegna_private.article_translation_is_public(article_id, locale));
create policy published_article_relations_read on public.education_article_relations for select to anon, authenticated
  using (yegna_private.article_translation_is_public(article_id, locale)
    and yegna_private.article_translation_is_public(related_article_id, locale));
create policy published_assessments_read on public.education_assessments for select to anon, authenticated
  using (exists (select 1 from public.education_assessment_versions v where v.assessment_id = id and yegna_private.assessment_translation_is_public(v.id, null)));
create policy published_assessment_versions_read on public.education_assessment_versions for select to anon, authenticated
  using (yegna_private.assessment_translation_is_public(id, null));
create policy published_assessment_translations_read on public.education_assessment_version_translations for select to anon, authenticated
  using (yegna_private.assessment_translation_is_public(version_id, locale));
create policy published_assessment_sources_read on public.education_assessment_sources for select to anon, authenticated
  using (yegna_private.assessment_translation_is_public(version_id, locale));
create policy published_assessment_questions_read on public.education_assessment_questions for select to anon, authenticated
  using (yegna_private.assessment_translation_is_public(version_id, null));
create policy published_assessment_question_translations_read on public.education_assessment_question_translations for select to anon, authenticated
  using (exists (select 1 from public.education_assessment_questions q where q.id = question_id and yegna_private.assessment_translation_is_public(q.version_id, locale)));
create policy published_assessment_options_read on public.education_assessment_options for select to anon, authenticated
  using (exists (select 1 from public.education_assessment_questions q where q.id = question_id and yegna_private.assessment_translation_is_public(q.version_id, null)));
create policy published_assessment_option_translations_read on public.education_assessment_option_translations for select to anon, authenticated
  using (exists (select 1 from public.education_assessment_options o join public.education_assessment_questions q on q.id = o.question_id where o.id = option_id and yegna_private.assessment_translation_is_public(q.version_id, locale)));

revoke all on public.education_categories, public.education_category_translations,
  public.education_articles, public.education_article_translations,
  public.education_article_sources, public.education_article_relations,
  public.education_assessments, public.education_assessment_versions,
  public.education_assessment_sources, public.education_assessment_version_translations,
  public.education_assessment_questions, public.education_assessment_question_translations,
  public.education_assessment_options, public.education_assessment_option_translations,
  public.user_learning_preferences, public.user_article_progress,
  public.user_assessment_attempts from public, anon, authenticated;

grant select on public.education_categories, public.education_category_translations, public.education_articles,
  public.education_article_sources, public.education_article_relations,
  public.education_assessments, public.education_assessment_versions, public.education_assessment_version_translations,
  public.education_assessment_sources,
  public.education_assessment_questions, public.education_assessment_question_translations,
  public.education_assessment_options, public.education_assessment_option_translations to anon, authenticated;
revoke select on public.education_category_translations,
  public.education_article_translations,
  public.education_assessment_version_translations
  from public, anon, authenticated;
grant select (category_id, locale, name, description, publication_status, reviewed_at)
  on public.education_category_translations to anon, authenticated;
grant select (article_id, locale, title, summary, body_markdown, content_revision,
  publication_status, reviewed_at, review_due_at, published_at, updated_at)
  on public.education_article_translations to anon, authenticated;
grant select (version_id, locale, title, description, instructions, publication_status,
  reviewed_at, review_due_at, published_at)
  on public.education_assessment_version_translations to anon, authenticated;
grant select on public.education_categories, public.education_articles,
  public.education_assessment_version_translations to service_role;
grant all on public.education_categories, public.education_category_translations,
  public.education_articles, public.education_article_translations,
  public.education_article_sources, public.education_article_relations,
  public.education_assessments, public.education_assessment_versions,
  public.education_assessment_sources, public.education_assessment_version_translations,
  public.education_assessment_questions, public.education_assessment_question_translations,
  public.education_assessment_options, public.education_assessment_option_translations,
  public.user_learning_preferences, public.user_article_progress,
  public.user_assessment_attempts to service_role;

create policy own_learning_preferences on public.user_learning_preferences for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy own_article_progress_read on public.user_article_progress for select to authenticated
  using (user_id = auth.uid() and exists (
    select 1 from public.user_learning_preferences pref
    where pref.user_id = auth.uid() and pref.sync_enabled
  ));
create policy own_article_progress_insert on public.user_article_progress for insert to authenticated
  with check (user_id = auth.uid() and exists (
    select 1 from public.user_learning_preferences pref
    where pref.user_id = auth.uid() and pref.sync_enabled
  ));
create policy own_article_progress_update on public.user_article_progress for update to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid() and exists (
    select 1 from public.user_learning_preferences pref
    where pref.user_id = auth.uid() and pref.sync_enabled
  ));
create policy own_article_progress_delete on public.user_article_progress for delete to authenticated
  using (user_id = auth.uid());
create policy own_attempt_history_read on public.user_assessment_attempts for select to authenticated
  using (user_id = auth.uid() and exists (
    select 1 from public.user_learning_preferences pref
    where pref.user_id = auth.uid() and pref.sync_enabled
  ));
create policy own_attempt_history_delete on public.user_assessment_attempts for delete to authenticated
  using (user_id = auth.uid());
grant select on public.user_learning_preferences to authenticated;
grant insert (user_id, sync_enabled, updated_at) on public.user_learning_preferences to authenticated;
grant update (sync_enabled, updated_at) on public.user_learning_preferences to authenticated;
grant select, insert, update, delete on public.user_article_progress to authenticated;
grant select, delete on public.user_assessment_attempts to authenticated;
grant execute on function public.clear_my_learning_history() to authenticated;
grant all on public.user_learning_preferences, public.user_article_progress, public.user_assessment_attempts to service_role;


