-- Create category enum
create type thought_category as enum ('question', 'reminder', 'insight', 'idea', 'other');

-- thoughts table
create table thoughts (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users(id) on delete cascade,
  content     text not null,
  category    thought_category not null default 'other',
  tags        text[] not null default '{}',
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- thought_connections junction table
create table thought_connections (
  thought_id_a  uuid not null references thoughts(id) on delete cascade,
  thought_id_b  uuid not null references thoughts(id) on delete cascade,
  created_at    timestamptz not null default now(),
  constraint thought_connections_pkey primary key (thought_id_a, thought_id_b),
  constraint thought_connections_ordered check (thought_id_a < thought_id_b)
);

-- updated_at trigger
create or replace function set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger thoughts_updated_at
  before update on thoughts
  for each row execute function set_updated_at();

-- RLS: thoughts
alter table thoughts enable row level security;

create policy "users can view own thoughts"
  on thoughts for select
  using (auth.uid() = user_id);

create policy "users can insert own thoughts"
  on thoughts for insert
  with check (auth.uid() = user_id);

create policy "users can update own thoughts"
  on thoughts for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "users can delete own thoughts"
  on thoughts for delete
  using (auth.uid() = user_id);

-- RLS: thought_connections
alter table thought_connections enable row level security;

create policy "users can view own connections"
  on thought_connections for select
  using (
    exists (select 1 from thoughts where id = thought_id_a and user_id = auth.uid())
  );

create policy "users can insert connections between own thoughts"
  on thought_connections for insert
  with check (
    exists (select 1 from thoughts where id = thought_id_a and user_id = auth.uid())
    and exists (select 1 from thoughts where id = thought_id_b and user_id = auth.uid())
  );

create policy "users can delete own connections"
  on thought_connections for delete
  using (
    exists (select 1 from thoughts where id = thought_id_a and user_id = auth.uid())
  );
