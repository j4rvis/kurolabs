-- ============================================================
-- Shared Migration 1: Core User Tables
-- Applies to every KuroLabs vertical that uses Supabase auth.
-- ============================================================

-- profiles: extends auth.users with display metadata
create table public.profiles (
  id              uuid primary key references auth.users(id) on delete cascade,
  username        text unique not null,
  display_name    text,
  avatar_url      text,
  character_class text not null default 'Adventurer',
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

-- characters: the D&D character sheet per user
create table public.characters (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null unique references auth.users(id) on delete cascade,
  level       int not null default 1,
  total_xp    bigint not null default 0,
  str         int not null default 10,
  dex         int not null default 10,
  con         int not null default 10,
  int_score   int not null default 10,
  wis         int not null default 10,
  cha         int not null default 10,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);
