-- Correlate a version with the assessment row that owns it. Qualifying the outer
-- row avoids resolving the unqualified id to education_assessment_versions.id.
drop policy if exists published_assessments_read on public.education_assessments;
create policy published_assessments_read on public.education_assessments
  for select to anon, authenticated
  using (
    exists (
      select 1
      from public.education_assessment_versions v
      where v.assessment_id = education_assessments.id
        and yegna_private.assessment_translation_is_public(v.id, null)
    )
  );
