## Why

The Questify web and mobile apps are currently standalone apps living inside `verticals/questify/`, making it structurally impossible to add a second vertical without running and deploying multiple separate apps. The architecture needs a single shell app per platform that composes multiple vertical feature modules — enabling future verticals to be added without new deployments.

## What Changes

- **BREAKING** Create `web/` — a new Next.js 16 shell app at the repo root that owns auth routes (`(auth)/`), the KuroLabs launcher dashboard (`(shell)/`), and Questify's routes (`(questify)/`). This replaces `verticals/questify/web/` as the deployable web entry point.
- **BREAKING** Strip `verticals/questify/web/` of its standalone Next.js entry points (`next.config.ts`, root `middleware.ts`, auth routes, layout) and convert it into a pnpm workspace package (`@questify/web`) that exports only feature components and logic.
- **BREAKING** Create `mobile/` — a new Flutter shell app at the repo root that owns auth, the `kurolabs_hub` launcher, and registers Questify's `ModuleConfig`. This replaces `verticals/questify/mobile/` as the runnable mobile entry point.
- **BREAKING** Strip `verticals/questify/mobile/` of its `main.dart` and Flutter app entry point, converting it into a Dart package that exports a `ModuleConfig` and feature screens/providers.
- Update `pnpm-workspace.yaml` to include `web` alongside `verticals/*/web` and `shared/web`; update root `package.json` scripts to target the new `web/` shell.
- Update `scripts/new-vertical.sh` to scaffold the new module pattern (no standalone entry points, export-only packages).

## Capabilities

### New Capabilities

- `web-shell`: Next.js shell app at `web/` — auth routes, KuroLabs launcher dashboard, middleware, Vercel deployment config, route groups per vertical
- `mobile-shell`: Flutter shell app at `mobile/` — `kurolabs_hub` launcher, top-level go_router, Riverpod setup, registers vertical ModuleConfigs

### Modified Capabilities

_None — no existing spec files require delta changes._

## Impact

- **Vercel**: Existing Vercel project will be retargeted to build from `web/` via `vercel.json` at repo root (already present). No new Vercel project needed.
- **pnpm workspace**: `pnpm-workspace.yaml` gains a `web` entry; root `package.json` name and scripts updated.
- **Flutter**: `verticals/questify/mobile/pubspec.yaml` loses the app entry (`main.dart`) and becomes `publish_to: none`; `mobile/pubspec.yaml` references it as a path dependency.
- **CI/dev workflow**: `pnpm dev` and `flutter run` now target `web/` and `mobile/` respectively.
- **No Supabase changes**: Schema, migrations, and edge functions are unaffected.
