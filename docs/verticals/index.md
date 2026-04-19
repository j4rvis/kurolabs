# Verticals: Architecture Overview

## Concept

A "vertical" is a self-contained feature domain that shares the KuroLabs shell (auth, launcher, shared packages) but owns its own schema, UI, and business logic. All verticals live under `verticals/<name>/`.

Verticals are **modules within a single app**, not independent deployments. They cannot run standalone. The shell (`web/` and `mobile/`) composes them.

## Directory layout

```
web/                        # Single Next.js shell app
  app/
    (auth)/                 # Auth routes — shell concern
    (shell)/                # KuroLabs launcher dashboard — shell concern
    (questify)/             # Questify routes (imports from @questify/web)
  middleware.ts             # Shell-level auth protection

mobile/                     # Single Flutter shell app
  lib/
    features/shell/         # KuroLabs launcher (kurolabs_hub)
    router/                 # Top-level routing

shared/
  web/                      # @kurolabs/web — Supabase clients, auth middleware, core types
  mobile/packages/
    kurolabs_auth/          # Supabase + Riverpod auth provider (Flutter)
    kurolabs_hub/           # Module launcher UI (Flutter)
  supabase/                 # Canonical shared migrations (symlinked into each vertical)

verticals/<name>/
  web/                      # pnpm workspace package (@<name>/web) — components + logic only
  mobile/                   # Dart package — feature screens + ModuleConfig, no app entry point
  supabase/                 # Vertical-specific migrations, edge functions, seed data
    migrations/             # Symlinks → shared/supabase/migrations/ + vertical-specific files
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

## Vertical web modules (`verticals/<name>/web/`)

A pnpm workspace package (`@<name>/web`) that exports React components and TypeScript logic. It has **no** `next.config.ts`, no standalone `middleware.ts`, and no auth routes. The shell's `app/(<name>)/` route group provides the route files and imports from this package.

## Vertical mobile modules (`verticals/<name>/mobile/`)

A Dart package that exports a `ModuleConfig` and all feature screens/providers. It has **no** `main.dart` or Flutter app entry point. The shell app references it via a path dependency and registers it with `kurolabs_hub`.

## Scaffolding a new vertical

```bash
./scripts/new-vertical.sh <name>              # all three
./scripts/new-vertical.sh <name> --web        # web module only
./scripts/new-vertical.sh <name> --mobile     # mobile module only
./scripts/new-vertical.sh <name> --supabase   # DB only
```

Name must be lowercase kebab-case. The script copies templates and substitutes tokens (`__VERTICAL__`, `__VERTICAL_PASCAL__`, `__VERTICAL_SNAKE__`).

## Existing verticals

| Vertical | Status | Description |
|----------|--------|-------------|
| questify | Active | Habit/quest tracker with quests, epics, NPCs — see [questify.md](questify.md) |
