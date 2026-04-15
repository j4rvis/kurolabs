-- ============================================================
-- Migration 3: Database Functions & Triggers
-- ============================================================

-- -------------------------------------------------------
-- Auto-create profile + character on new user signup
-- -------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, username, display_name)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'username', split_part(new.email, '@', 1)),
    coalesce(new.raw_user_meta_data->>'display_name', split_part(new.email, '@', 1))
  );

  insert into public.characters (user_id)
  values (new.id);

  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row
  execute function public.handle_new_user();

-- -------------------------------------------------------
-- Complete a quest atomically
-- Called by the complete-quest Edge Function (service role)
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

-- -------------------------------------------------------
-- Reset daily quests — called by the daily-reset Edge Function
-- -------------------------------------------------------
create or replace function public.reset_daily_quests()
returns void
language sql
security definer
set search_path = public
as $$
  update public.quests
  set
    status       = 'active',
    completed_at = null,
    updated_at   = now()
  where quest_type = 'daily'
    and status = 'completed'
    and date(completed_at) < current_date;
$$;

-- -------------------------------------------------------
-- Helper: compute xp_reward from difficulty
-- Used by the quests insert trigger to auto-set xp_reward
-- -------------------------------------------------------
create or replace function public.difficulty_to_xp(difficulty text)
returns int
language sql
immutable
as $$
  select case difficulty
    when 'trivial'   then 25
    when 'easy'      then 50
    when 'medium'    then 100
    when 'hard'      then 250
    when 'deadly'    then 500
    when 'legendary' then 1000
    else 100
  end;
$$;

create or replace function public.set_quest_xp_reward()
returns trigger
language plpgsql
as $$
begin
  new.xp_reward := public.difficulty_to_xp(new.difficulty);
  return new;
end;
$$;

create trigger quests_set_xp_reward
  before insert or update of difficulty
  on public.quests
  for each row
  execute function public.set_quest_xp_reward();
