-- Require current cloud-sync consent before an idempotent retry reads prior
-- attempt data through the service-role scoring path.
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
    select count(distinct submitted_json.item->>'questionId')
    from jsonb_array_elements(p_answers) as submitted_json(item)
  ) <> v_question_count then
    raise exception 'invalid answer selection';
  end if;

  if p_user_id is not null and p_sync_enabled then
    if not exists (
      select 1 from public.user_learning_preferences pref
      where pref.user_id = p_user_id and pref.sync_enabled
    ) then
      raise exception 'progress synchronization is disabled';
    end if;
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
