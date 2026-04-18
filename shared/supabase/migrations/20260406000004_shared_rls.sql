-- ============================================================
-- Shared Migration 4: RLS Policies for Core Tables
-- ============================================================

-- profiles
alter table public.profiles enable row level security;

create policy "profiles: owner full access"
  on public.profiles for all
  to authenticated
  using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id);

-- characters
alter table public.characters enable row level security;

create policy "characters: owner full access"
  on public.characters for all
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

-- xp_thresholds: readable by all authenticated users
alter table public.xp_thresholds enable row level security;

create policy "xp_thresholds: authenticated read"
  on public.xp_thresholds for select
  to authenticated
  using (true);
