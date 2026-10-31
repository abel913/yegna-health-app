-- Shared guest assessment limit: 20 valid submissions per client IP per 10-minute window.
-- Address records are private and retained for at most one day; cleanup is performed
-- opportunistically on each guest attempt. No request body, answer, or user data is stored.
create table yegna_private.guest_assessment_rate_limits (
  client_ip inet not null,
  window_started timestamptz not null,
  request_count integer not null check (request_count > 0),
  primary key (client_ip, window_started)
);
create index guest_assessment_rate_limits_expiry_idx
  on yegna_private.guest_assessment_rate_limits(window_started);
alter table yegna_private.guest_assessment_rate_limits enable row level security;
revoke all on yegna_private.guest_assessment_rate_limits from public, anon, authenticated;
grant select, insert, update, delete on yegna_private.guest_assessment_rate_limits to service_role;

create or replace function public.consume_guest_assessment_rate_limit(p_client_ip inet)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_now timestamptz := clock_timestamp();
  v_window timestamptz;
  v_count integer;
begin
  if p_client_ip is null then
    raise exception 'client address required';
  end if;

  v_window := date_bin(interval '10 minutes', v_now, timestamptz '2000-01-01 00:00:00+00');

  delete from yegna_private.guest_assessment_rate_limits
    where window_started < v_now - interval '1 day';

  insert into yegna_private.guest_assessment_rate_limits(client_ip, window_started, request_count)
    values (p_client_ip, v_window, 1)
  on conflict (client_ip, window_started) do update
    set request_count = yegna_private.guest_assessment_rate_limits.request_count + 1
  returning request_count into v_count;

  return v_count <= 20;
end;
$$;
revoke all on function public.consume_guest_assessment_rate_limit(inet) from public, anon, authenticated;
grant execute on function public.consume_guest_assessment_rate_limit(inet) to service_role;
