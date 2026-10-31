begin;
select plan(26);

select ok(
  has_schema_privilege('anon', 'yegna_private', 'USAGE')
  and not has_table_privilege('anon', 'yegna_private.education_assessment_answer_keys', 'SELECT')
  and not has_table_privilege('authenticated', 'yegna_private.education_assessment_answer_keys', 'SELECT'),
  'clients can call narrow publication helpers but cannot read private answer keys'
);
select ok(
  not has_table_privilege('anon', 'yegna_private.education_assessment_answer_keys', 'SELECT'),
  'anonymous clients cannot read answer keys'
);
select ok(
  not has_table_privilege('authenticated', 'yegna_private.education_assessment_explanations', 'SELECT'),
  'authenticated clients cannot read explanations before submission'
);
select ok(
  has_table_privilege('service_role', 'yegna_private.education_assessment_answer_keys', 'SELECT'),
  'server-side service role can read answer keys for scoring'
);
select ok(
  has_function_privilege(
    'service_role',
    'public.score_assessment(uuid,uuid,text,uuid,jsonb,text,boolean)',
    'EXECUTE'
  ),
  'server-side scoring function is callable by the Edge Function role'
);
select ok(
  not has_function_privilege(
    'anon',
    'public.score_assessment(uuid,uuid,text,uuid,jsonb,text,boolean)',
    'EXECUTE'
  ),
  'ordinary anonymous clients cannot call the privileged scoring RPC directly'
);
select ok(
  (select position('progress synchronization is disabled' in prosrc) < position('select * into v_existing' in prosrc)
   from pg_proc where oid = 'public.score_assessment(uuid,uuid,text,uuid,jsonb,text,boolean)'::regprocedure),
  'scoring retries check current sync consent before reading stored attempts'
);
select ok(
  not has_table_privilege('authenticated', 'public.user_assessment_attempts', 'INSERT'),
  'clients cannot write or forge quiz scores'
);
select ok(
  (select relrowsecurity from pg_class where oid = 'public.user_learning_preferences'::regclass),
  'learning sync preferences have row level security enabled'
);
select ok(
  (select relrowsecurity from pg_class where oid = 'public.user_assessment_attempts'::regclass),
  'assessment history has row level security enabled'
);
select ok(
  (select with_check like '%sync_enabled%'
   from pg_policies
   where schemaname = 'public' and tablename = 'user_article_progress' and policyname = 'own_article_progress_insert'),
  'cloud article progress writes require explicit sync consent'
);
select ok(
  (select qual like '%assessment_translation_is_public%'
   from pg_policies
   where schemaname = 'public' and tablename = 'education_assessment_options' and policyname = 'published_assessment_options_read'),
  'answer option policy delegates visibility to the publication-gated predicate'
);
select ok(
  (select qual like '%v.assessment_id = education_assessments.id%'
      and qual not like '%v.assessment_id = v.id%'
   from pg_policies
   where schemaname = 'public' and tablename = 'education_assessments'
     and policyname = 'published_assessments_read'),
  'assessment visibility correlates each public version to its owning assessment'
);
select ok(
  (select pg_get_functiondef('yegna_private.assessment_translation_is_public(uuid,text)'::regprocedure)
      like '%t.publication_status = ''published''%'
      and pg_get_functiondef('yegna_private.assessment_translation_is_public(uuid,text)'::regprocedure)
      like '%t.review_due_at >= now()%'),
  'assessment publication predicate requires published status and current review'
);
select ok(
  (select qual like '%sync_enabled%'
   from pg_policies
   where schemaname = 'public' and tablename = 'user_article_progress' and policyname = 'own_article_progress_read'),
  'cloud article progress reads require explicit sync consent'
);
select ok(
  (select qual like '%sync_enabled%'
   from pg_policies
   where schemaname = 'public' and tablename = 'user_assessment_attempts' and policyname = 'own_attempt_history_read'),
  'cloud assessment history reads require explicit sync consent'
);
select ok(
  not has_column_privilege('anon', 'public.education_article_translations', 'reviewed_by', 'SELECT')
  and not has_column_privilege('anon', 'public.education_article_translations', 'publisher_id', 'SELECT'),
  'public article readers cannot retrieve internal editor and reviewer identities'
);
select ok(
  has_column_privilege('anon', 'public.education_article_translations', 'title', 'SELECT'),
  'public article readers can retrieve the localized content columns'
);
select ok(
  not has_column_privilege('anon', 'public.education_assessment_version_translations', 'reviewed_by', 'SELECT')
  and not has_column_privilege('anon', 'public.education_assessment_version_translations', 'publisher_id', 'SELECT'),
  'public quiz readers cannot retrieve internal reviewer or publisher identities'
);
select ok(
  not has_column_privilege('anon', 'public.education_category_translations', 'reviewed_by', 'SELECT'),
  'public category readers cannot retrieve internal reviewer identities'
);
select ok(
  not has_table_privilege('anon', 'public.user_learning_preferences', 'INSERT')
  and not has_table_privilege('authenticated', 'public.user_learning_preferences', 'DELETE'),
  'clients cannot create or delete synchronization preference rows arbitrarily'
);
select ok(
  not has_column_privilege('authenticated', 'public.user_learning_preferences', 'history_cleared_at', 'UPDATE'),
  'clients cannot manipulate the server-owned clear-history marker'
);
select ok(
  has_function_privilege('authenticated', 'public.clear_my_learning_history()', 'EXECUTE')
  and not has_function_privilege('anon', 'public.clear_my_learning_history()', 'EXECUTE'),
  'only authenticated users can invoke own-history clearing'
);
select ok(
  has_function_privilege('anon', 'yegna_private.article_translation_is_public(uuid,text)', 'EXECUTE')
  and has_function_privilege('anon', 'yegna_private.assessment_translation_is_public(uuid,text)', 'EXECUTE'),
  'anonymous read policies can call narrow publication predicates'
);
select ok(
  not has_table_privilege('anon', 'yegna_private.guest_assessment_rate_limits', 'SELECT')
  and not has_table_privilege('authenticated', 'yegna_private.guest_assessment_rate_limits', 'SELECT')
  and has_table_privilege('service_role', 'yegna_private.guest_assessment_rate_limits', 'SELECT'),
  'guest rate-limit records are private to the server role'
);
select ok(
  has_function_privilege('service_role', 'public.consume_guest_assessment_rate_limit(inet)', 'EXECUTE')
  and not has_function_privilege('anon', 'public.consume_guest_assessment_rate_limit(inet)', 'EXECUTE')
  and not has_function_privilege('authenticated', 'public.consume_guest_assessment_rate_limit(inet)', 'EXECUTE'),
  'only the server role can consume guest rate-limit buckets'
);

select * from finish();
rollback;
