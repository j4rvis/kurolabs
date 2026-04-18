# Supabase

## Project

The Questify Supabase project is at `verticals/questify/supabase/`. Config: `config.toml` (project id: `kurolabs`, API port 54321, DB port 54322, PostgreSQL 17).

## Local dev

```bash
cd verticals/questify/supabase
supabase start          # start local stack
supabase stop           # stop local stack
supabase status         # show local URLs and keys
```

## Migrations

Migrations are in `verticals/questify/supabase/migrations/`. Shared migrations (`…000001`–`…000005`) are symlinks into `shared/supabase/migrations/` — do not edit them in the vertical directory.

```bash
supabase migration new <name>         # create a new migration file
supabase db push                      # push to remote
supabase db reset                     # reset local DB and re-run all migrations
```

When adding shared schema changes, edit in `shared/supabase/migrations/` — all verticals pick them up via symlinks.

## Edge Functions

```bash
supabase functions serve <name>       # run a single function locally
supabase functions deploy <name>      # deploy to remote
supabase functions deploy             # deploy all functions
```

Function source: `verticals/questify/supabase/functions/<name>/index.ts` (Deno).

## Type generation

```bash
supabase gen types typescript --local > verticals/questify/web/lib/database.types.ts
```

## Schema overview

See [verticals/questify.md](verticals/questify.md) for table-level detail.

**RLS model:** all tables have RLS enabled. Users can only read/write their own rows. Quest givers have limited visibility into assigned quests. Always work through the Supabase client (not the service role key) in application code so RLS is enforced.

## Shared vs. vertical migrations

| Range | Owns | Location |
|-------|------|---------|
| `…000001`–`…000005` | Shared | `shared/supabase/migrations/` (symlinked) |
| `…000010`+ | Questify | `verticals/questify/supabase/migrations/` |

Keep shared migration numbers below `000010` to avoid ordering conflicts with vertical migrations.
