create or replace function public.get_my_vote()
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select v.school_name
  from public.votes as v
  where v.user_id = auth.uid()
    and v.vote_date = (now() at time zone 'Asia/Seoul')::date
  limit 1;
$$;

revoke all on function public.get_my_vote() from public, anon, authenticated;
grant execute on function public.get_my_vote() to authenticated;

revoke all on function public.get_vote_totals() from public, anon, authenticated;
grant execute on function public.get_vote_totals() to anon, authenticated;
