## Context

The codebase currently has `verticals/questify/web/` as a full standalone Next.js 16 app (owns its own `next.config.ts`, `middleware.ts`, auth routes, and Vercel deployment). Similarly, `verticals/questify/mobile/` is a full Flutter app with `main.dart`. This tightly couples the deployment surface to a single vertical, making it impossible to add new verticals without shipping separate apps.

The docs already describe the target architecture (shell + modules), but no shell apps exist yet. The migration is a big-bang cutover — existing apps will be broken mid-migration and restored as modules once the shells are complete.

Vercel is already configured via `vercel.json` at the repo root. The existing Vercel project will be retargeted to `web/` (the new shell) rather than `verticals/questify/web/`.

## Goals / Non-Goals

**Goals:**
- Create a `web/` Next.js 16 shell app that owns auth, the launcher dashboard, and all vertical route groups
- Create a `mobile/` Flutter shell app that owns auth, `kurolabs_hub` launcher, and vertical module registration
- Convert `verticals/questify/web/` into `@questify/web`: a pnpm workspace package that exports only components and logic (no standalone entry)
- Convert `verticals/questify/mobile/` into a Dart package that exports only `ModuleConfig` and feature code (no `main.dart`)
- Update workspace config and `new-vertical.sh` to reflect the new pattern

**Non-Goals:**
- Supabase schema, migrations, or edge functions are not touched
- No new Vercel project — existing project is reused
- No feature changes to Questify itself — only structural relocation
- No new verticals are scaffolded as part of this change

## Decisions

### D1: Single big-bang cutover, not incremental

**Decision**: Replace the old structure in one migration, not incrementally.

**Rationale**: The existing apps are not in production serving real users — the repo is early-stage. The overhead of maintaining compatibility shims during an incremental migration outweighs the risk.

**Alternative considered**: Keep `verticals/questify/web/` runnable during migration and add a `web/` shell alongside. Rejected because it doubles configuration surface (two next.configs, two middleware chains) and creates ambiguity about which app is canonical.

---

### D2: Shell owns route files; vertical packages export only components

**Decision**: Route files (`page.tsx`, `layout.tsx`, `loading.tsx`) live in `web/app/(questify)/`. The `@questify/web` package exports React components and data-fetching logic consumed by those route files.

**Rationale**: This keeps Next.js routing concerns (layouts, loading states, metadata) in one place (the shell) while allowing Questify's UI and business logic to evolve independently. Route files are thin — they import from `@questify/web` and don't contain business logic.

**Alternative considered**: Let vertical packages export full route modules via `next/dynamic` or route handler delegation. Rejected as overly complex and not how the existing code is structured.

---

### D3: Auth redirect pattern — middleware at shell level

**Decision**: `web/middleware.ts` (importing `@kurolabs/web/middleware/auth`) protects all non-public routes. Unauthenticated users are redirected to `/auth/login`.

**Rationale**: Auth is a shell concern, not a vertical concern. Centralizing it in shell middleware prevents each vertical from re-implementing protection.

---

### D4: Mobile shell registers ModuleConfigs explicitly

**Decision**: `mobile/lib/features/shell/` registers each vertical's `ModuleConfig` by importing and listing them directly in the shell code.

**Rationale**: Explicit registration is more readable and type-safe than auto-discovery. With a small number of verticals, discovery adds complexity without benefit.

---

### D5: `new-vertical.sh` updated last

**Decision**: Update the scaffold script only after all 4 structural tasks are complete, so the script reflects the actual file layout rather than a hypothetical target.

## Risks / Trade-offs

- **Dev environment broken mid-migration** → Mitigation: Complete all 6 tasks in a single focused session. The app will not run until at minimum tasks 1+2 (web) or 3+4 (mobile) are complete.

- **pnpm workspace filter names must be consistent** → The root `package.json` scripts use `--filter web`; the new shell app's `package.json` must have `"name": "web"`. Mitigation: Verify filter names before wiring scripts.

- **Vercel build path** → `vercel.json` must point `rootDirectory` to `web/`. If misconfigured, Vercel will fail to find `next.config.ts`. Mitigation: Update `vercel.json` as part of task 1 and verify in CI.

- **Flutter path dependencies** → `mobile/pubspec.yaml` references `verticals/questify/mobile/` via a relative path. If the Dart package's `pubspec.yaml` doesn't declare `publish_to: none` and a correct name, `flutter pub get` will fail. Mitigation: Verify `pubspec.yaml` format matches the shared package pattern.

## Migration Plan

1. Create `web/` shell (task 1) — sets up the deployable entry point
2. Strip and convert `verticals/questify/web/` (task 2) — moves routes into shell, package becomes module-only
3. Create `mobile/` shell (task 3) — sets up runnable Flutter app
4. Strip and convert `verticals/questify/mobile/` (task 4) — removes main.dart, exports ModuleConfig
5. Update pnpm workspace + root scripts (task 5)
6. Update `new-vertical.sh` (task 6)

**Rollback**: Git revert. No database changes, so rollback is purely code.

## Open Questions

_None — decisions are sufficient to begin implementation._
