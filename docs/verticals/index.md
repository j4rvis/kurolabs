# Verticals: Architecture Overview

## Concept

A "vertical" is a self-contained app that shares the KuroLabs core (auth, characters, XP) but owns its own feature schema, UI, and business logic. All verticals live under `verticals/<name>/`.

## Directory layout

```
shared/
  web/               # @kurolabs/web npm package — Supabase clients, auth middleware, core types
  mobile/packages/
    kurolabs_auth/   # Supabase + Riverpod auth provider (Flutter)
    kurolabs_hub/    # Module launcher UI (Flutter)
  supabase/          # Canonical shared migrations (symlinked into each vertical)

verticals/<name>/
  web/               # Next.js app
  mobile/            # Flutter app
  supabase/          # Vertical-specific migrations, edge functions, seed data
    migrations/      # Contains symlinks → shared/supabase/migrations/ + vertical-specific files
```

## Shared schema

Applied first (migrations `…000001`–`…000005`):

| Table | Purpose |
|-------|---------|
| `profiles` | User metadata (username, display_name, avatar_url, character_class) |
| `characters` | D&D character sheet (level, total_xp, str/dex/con/int_score/wis/cha) |
| `xp_thresholds` | Leveling curve (20 levels, seeded) |

Auth trigger auto-creates a profile + character on signup.

## Shared web package (`@kurolabs/web`)

Exports:
- `@kurolabs/web/supabase/client` — browser Supabase client factory
- `@kurolabs/web/supabase/server` — server/SSR client factory (cookies)
- `@kurolabs/web/middleware/auth` — Next.js middleware (session refresh + route protection)
- `@kurolabs/web/types/core` — `Profile`, `Character`, `XpThreshold` types

## Scaffolding a new vertical

```bash
./scripts/new-vertical.sh <name>              # all three
./scripts/new-vertical.sh <name> --web        # web only
./scripts/new-vertical.sh <name> --mobile     # mobile only
./scripts/new-vertical.sh <name> --supabase   # DB only
```

Name must be lowercase kebab-case. The script copies templates, substitutes tokens (`__VERTICAL__`, `__VERTICAL_PASCAL__`, `__VERTICAL_SNAKE__`), and symlinks shared migrations.

## Existing verticals

| Vertical | Status | Description |
|----------|--------|-------------|
| questify | Active | Habit/quest tracker with quests, epics, NPCs — see [questify.md](questify.md) |
