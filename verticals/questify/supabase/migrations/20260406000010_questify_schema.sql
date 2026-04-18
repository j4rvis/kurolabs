-- ============================================================
-- Questify Migration 1: Core Questify Tables
-- Depends on shared migrations 1–5 (profiles, characters, xp_thresholds).
-- ============================================================

-- epics: quest categories (system-wide or user-created)
create table public.epics (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid references auth.users(id) on delete cascade,
  name          text not null,
  description   text,
  icon_name     text,
  color_hex     text not null default '#8B4513',
  ability_score text not null default 'str'
    check (ability_score in ('str','dex','con','int_score','wis','cha')),
  is_system     boolean not null default false,
  created_at    timestamptz not null default now()
);

-- quests: the core entity
create table public.quests (
  id                  uuid primary key default gen_random_uuid(),
  user_id             uuid not null references auth.users(id) on delete cascade,
  epic_id             uuid references public.epics(id) on delete set null,
  quest_giver_id      uuid references auth.users(id) on delete set null,
  title               text not null,
  description         text,
  quest_type          text not null default 'side'
    check (quest_type in ('daily','side','epic')),
  difficulty          text not null default 'medium'
    check (difficulty in ('trivial','easy','medium','hard','deadly','legendary')),
  xp_reward           int not null default 100,
  recurrence_rule     text,
  due_date            date,
  status              text not null default 'active'
    check (status in ('active','completed','failed','archived')),
  completed_at        timestamptz,
  verified_at         timestamptz,
  verified_by         uuid references auth.users(id) on delete set null,
  current_streak      int not null default 0,
  longest_streak      int not null default 0,
  last_completed_date date,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now()
);

-- quest_completions: immutable log of every completion event
create table public.quest_completions (
  id            uuid primary key default gen_random_uuid(),
  quest_id      uuid not null references public.quests(id) on delete cascade,
  user_id       uuid not null references auth.users(id) on delete cascade,
  xp_earned     int not null,
  ability_score text,
  score_delta   int not null default 0,
  notes         text,
  completed_at  timestamptz not null default now()
);

-- quest_givers: adventurer <-> quest giver relationship
create table public.quest_givers (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null references auth.users(id) on delete cascade,
  giver_user_id   uuid not null references auth.users(id) on delete cascade,
  status          text not null default 'pending'
    check (status in ('pending','accepted','declined','revoked')),
  invited_at      timestamptz not null default now(),
  accepted_at     timestamptz,
  unique (user_id, giver_user_id)
);

-- Indexes for common query patterns
create index quests_user_id_idx           on public.quests (user_id);
create index quests_user_status_idx       on public.quests (user_id, status);
create index quests_user_type_idx         on public.quests (user_id, quest_type);
create index quest_completions_user_idx   on public.quest_completions (user_id);
create index quest_completions_quest_idx  on public.quest_completions (quest_id);
create index quest_givers_user_idx        on public.quest_givers (user_id);
create index quest_givers_giver_idx       on public.quest_givers (giver_user_id);
