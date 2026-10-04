create or replace function public.submit_vote(p_school_name text)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if auth.uid() is null then
    raise exception '로그인이 필요합니다.';
  end if;

  if not exists (
    select 1
    from public.schools as s
    where s.name = p_school_name
  ) then
    raise exception '등록되지 않은 학교입니다.';
  end if;

  insert into public.votes (user_id, school_name, vote_date)
  values (
    auth.uid(),
    p_school_name,
    (now() at time zone 'Asia/Seoul')::date
  )
  on conflict (user_id, vote_date)
  do update set school_name = excluded.school_name;
end;
$$;

revoke all on function public.submit_vote(text) from public, anon, authenticated;
grant execute on function public.submit_vote(text) to authenticated;
