-- ============================================================
-- Questify Migration 2: RLS Policies for Questify Tables
-- ============================================================

-- epics
alter table public.epics enable row level security;

create policy "epics: read system or own"
  on public.epics for select
  to authenticated
  using (is_system = true or (select auth.uid()) = user_id);

create policy "epics: insert own"
  on public.epics for insert
  to authenticated
  with check ((select auth.uid()) = user_id and is_system = false);

create policy "epics: update own"
  on public.epics for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "epics: delete own"
  on public.epics for delete
  to authenticated
  using ((select auth.uid()) = user_id);

-- quests
alter table public.quests enable row level security;

create policy "quests: owner full access"
  on public.quests for all
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

-- Quest givers with accepted status can read the quests of their adventurer
create policy "quests: accepted quest givers can read"
  on public.quests for select
  to authenticated
  using (
    exists (
      select 1 from public.quest_givers qg
      where qg.user_id = quests.user_id
        and qg.giver_user_id = (select auth.uid())
        and qg.status = 'accepted'
    )
  );

-- quest_completions: owners can read; writes are via Edge Function (service role)
alter table public.quest_completions enable row level security;

create policy "quest_completions: owner read"
  on public.quest_completions for select
  to authenticated
  using ((select auth.uid()) = user_id);

-- quest_givers
alter table public.quest_givers enable row level security;

create policy "quest_givers: adventurer full access"
  on public.quest_givers for all
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "quest_givers: giver can read own invites"
  on public.quest_givers for select
  to authenticated
  using ((select auth.uid()) = giver_user_id);

create policy "quest_givers: giver can accept or decline"
  on public.quest_givers for update
  to authenticated
  using ((select auth.uid()) = giver_user_id)
  with check ((select auth.uid()) = giver_user_id);
