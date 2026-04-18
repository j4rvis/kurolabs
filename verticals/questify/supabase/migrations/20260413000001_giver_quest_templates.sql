-- ============================================================
-- Migration 6: Human Giver Quest Templates
-- Extends the quest giver system with a subscription model
-- that mirrors the NPC village template flow.
-- ============================================================

-- -------------------------------------------------------
-- Table: giver_quest_templates
-- Templates defined by a human quest giver for a specific
-- giver↔adventurer relationship. Mirrors npc_quest_templates.
-- -------------------------------------------------------
create table public.giver_quest_templates (
  id             uuid primary key default gen_random_uuid(),
  quest_giver_id uuid not null references public.quest_givers(id) on delete cascade,
  title          text not null,
  description    text,
  frequency      text not null check (frequency in ('daily','weekly','monthly','one_time')),
  difficulty     text not null default 'medium'
    check (difficulty in ('trivial','easy','medium','hard','deadly','legendary')),
  xp_reward      int not null default 100,
  sort_order     int not null default 0,
  created_at     timestamptz not null default now()
);

create index on public.giver_quest_templates (quest_giver_id);

-- -------------------------------------------------------
-- Extend quests table
-- Mirrors npc_quest_giver_id / npc_template_id pattern.
-- The existing quest_giver_id column (references auth.users)
-- is left as-is; quest_giver_relationship_id references the
-- junction table and is used by the new subscription flow.
-- -------------------------------------------------------
alter table public.quests
  add column quest_giver_relationship_id uuid references public.quest_givers(id) on delete set null,
  add column giver_template_id           uuid references public.giver_quest_templates(id) on delete set null;

create index on public.quests (quest_giver_relationship_id);

-- -------------------------------------------------------
-- RLS for giver_quest_templates
-- -------------------------------------------------------
alter table public.giver_quest_templates enable row level security;

-- Both adventurer (user_id) and giver (giver_user_id) can read
-- templates for accepted relationships.
create policy "giver_templates: parties can select"
  on public.giver_quest_templates for select
  to authenticated
  using (
    exists (
      select 1 from public.quest_givers qg
      where qg.id = giver_quest_templates.quest_giver_id
        and qg.status = 'accepted'
        and (
          qg.user_id        = (select auth.uid())
          or qg.giver_user_id = (select auth.uid())
        )
    )
  );

-- Only the giver can create templates (relationship must be accepted).
create policy "giver_templates: giver can insert"
  on public.giver_quest_templates for insert
  to authenticated
  with check (
    exists (
      select 1 from public.quest_givers qg
      where qg.id = giver_quest_templates.quest_giver_id
        and qg.giver_user_id = (select auth.uid())
        and qg.status = 'accepted'
    )
  );

-- Only the giver can update their own templates.
create policy "giver_templates: giver can update"
  on public.giver_quest_templates for update
  to authenticated
  using (
    exists (
      select 1 from public.quest_givers qg
      where qg.id = giver_quest_templates.quest_giver_id
        and qg.giver_user_id = (select auth.uid())
    )
  )
  with check (
    exists (
      select 1 from public.quest_givers qg
      where qg.id = giver_quest_templates.quest_giver_id
        and qg.giver_user_id = (select auth.uid())
    )
  );

-- Only the giver can delete their own templates.
create policy "giver_templates: giver can delete"
  on public.giver_quest_templates for delete
  to authenticated
  using (
    exists (
      select 1 from public.quest_givers qg
      where qg.id = giver_quest_templates.quest_giver_id
        and qg.giver_user_id = (select auth.uid())
    )
  );

-- -------------------------------------------------------
-- Updated complete_quest function
-- Replaces the version from migration 3 with an added guard:
-- quests linked to a giver relationship can only be completed
-- while that relationship is still active.
-- -------------------------------------------------------
create or replace function public.complete_quest(
  p_quest_id  uuid,
  p_user_id   uuid,
  p_notes     text default null
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_quest            public.quests%rowtype;
  v_epic             public.epics%rowtype;
  v_character        public.characters%rowtype;
  v_xp               int;
  v_new_xp           bigint;
  v_new_level        int;
  v_old_level        int;
  v_score_delta      int := 0;
  v_completion_count int;
  v_today            date := current_date;
  v_new_streak       int;
begin
  -- Lock and fetch the quest
  select * into v_quest
  from public.quests
  where id = p_quest_id and user_id = p_user_id
  for update;

  if not found then
    raise exception 'Quest not found or does not belong to user';
  end if;

  -- Guard: giver-linked quests require an active relationship
  if v_quest.quest_giver_relationship_id is not null then
    if not exists (
      select 1 from public.quest_givers qg
      where qg.id = v_quest.quest_giver_relationship_id
        and qg.status = 'accepted'
    ) then
      raise exception 'Quest giver relationship is no longer active';
    end if;
  end if;

  -- Prevent double-completion of non-daily quests
  if v_quest.quest_type != 'daily' and v_quest.status = 'completed' then
    raise exception 'Quest has already been completed';
  end if;

  -- For daily quests, prevent completing twice in the same day
  if v_quest.quest_type = 'daily' and v_quest.last_completed_date = v_today then
    raise exception 'Daily quest already completed today';
  end if;

  v_xp := v_quest.xp_reward;

  -- Handle streak logic for daily quests
  if v_quest.quest_type = 'daily' then
    if v_quest.last_completed_date = v_today - 1 then
      v_new_streak := v_quest.current_streak + 1;
    else
      v_new_streak := 1;
    end if;

    -- Streak bonus: +10% XP per 7-day streak milestone
    v_xp := v_xp + ((floor(v_new_streak::numeric / 7) * v_quest.xp_reward * 0.1))::int;

    update public.quests set
      status              = 'completed',
      current_streak      = v_new_streak,
      longest_streak      = greatest(longest_streak, v_new_streak),
      last_completed_date = v_today,
      completed_at        = now(),
      updated_at          = now()
    where id = p_quest_id;
  else
    update public.quests set
      status       = 'completed',
      completed_at = now(),
      updated_at   = now()
    where id = p_quest_id;

    v_new_streak := null;
  end if;

  -- Fetch the epic for ability score mapping
  if v_quest.epic_id is not null then
    select * into v_epic from public.epics where id = v_quest.epic_id;
  end if;

  -- Fetch and lock character
  select * into v_character
  from public.characters
  where user_id = p_user_id
  for update;

  v_old_level := v_character.level;
  v_new_xp    := v_character.total_xp + v_xp;

  -- Determine new level
  select coalesce(max(level), 1) into v_new_level
  from public.xp_thresholds
  where xp_needed <= v_new_xp;

  -- Ability score bump: +1 every 10 completions in the epic's stat
  if v_epic.ability_score is not null then
    select count(*) into v_completion_count
    from public.quest_completions qc
    join public.quests q on q.id = qc.quest_id
    where qc.user_id = p_user_id
      and q.epic_id = v_quest.epic_id;

    -- Every 10th completion (0-indexed: 9, 19, 29…) bumps the stat
    if (v_completion_count % 10) = 9 then
      v_score_delta := 1;
    end if;
  end if;

  -- Update character stats
  update public.characters set
    total_xp  = v_new_xp,
    level     = v_new_level,
    str       = str       + case when v_epic.ability_score = 'str'       then v_score_delta else 0 end,
    dex       = dex       + case when v_epic.ability_score = 'dex'       then v_score_delta else 0 end,
    con       = con       + case when v_epic.ability_score = 'con'       then v_score_delta else 0 end,
    int_score = int_score + case when v_epic.ability_score = 'int_score' then v_score_delta else 0 end,
    wis       = wis       + case when v_epic.ability_score = 'wis'       then v_score_delta else 0 end,
    cha       = cha       + case when v_epic.ability_score = 'cha'       then v_score_delta else 0 end,
    updated_at = now()
  where user_id = p_user_id;

  -- Log the completion event
  insert into public.quest_completions (
    quest_id, user_id, xp_earned, ability_score, score_delta, notes
  ) values (
    p_quest_id, p_user_id, v_xp, v_epic.ability_score, v_score_delta, p_notes
  );

  return jsonb_build_object(
    'xp_earned',            v_xp,
    'new_total_xp',         v_new_xp,
    'leveled_up',           v_new_level > v_old_level,
    'new_level',            v_new_level,
    'old_level',            v_old_level,
    'ability_score_bumped', v_score_delta > 0,
    'ability_score',        v_epic.ability_score,
    'streak',               v_new_streak
  );
end;
$$;
