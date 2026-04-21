## Context

The hub architecture already exists but is incomplete and uses inconsistent route naming:

- **Web**: `web/app/(shell)/dashboard/page.tsx` renders a card grid with Questify as the only entry. `web/app/page.tsx` redirects to `/dashboard`. Questify routes live under `(questify)/dashboard/` — so quests are at `/dashboard/quests`, village at `/dashboard/village`. These names are misleading and conflict with the hub being `/dashboard`.
- **Mobile**: `mobile/lib/router/router.dart` already sets `/hub` as `initialLocation`, guards auth correctly, and renders `HubScreen` from `kurolabs_hub`. `modules.dart` registers only `questifyModule`. Mobile already uses the correct naming convention.

Web route renaming is required alongside adding User Management. Mobile is additive only.

## Goals / Non-Goals

**Goals:**
- Both web and mobile hubs list Questify and User Management as navigable entries
- Web routes renamed: hub at `/hub`, Questify routes under `/hub/questify/`, User Management under `/hub/user-management/`
- User Management vertical is scaffolded (`verticals/user-management/`) with basic profile and account settings screens
- The post-login destination on both platforms is the hub

**Non-Goals:**
- Redesigning the existing hub UI or navigation chrome
- Deep character-management features (level, XP, stats editing) — those belong to a separate change
- Authentication flow changes
- Any new verticals beyond User Management

## Decisions

### 1. Scaffold User Management with `new-vertical.sh`

Use `./scripts/new-vertical.sh user-management --web --mobile` to generate the standard package structure at `verticals/user-management/`. This ensures the vertical follows the same shape as Questify and is picked up by the correct workspace/dependency configs.

**Alternative considered**: Hand-craft the package. Rejected — the scaffold script exists for this purpose and enforces consistency.

### 2. Web route structure

The web app uses a consistent prefix convention: `/hub` is the launcher, each vertical's routes live under `/hub/<vertical-name>/`.

| Route | Handler |
|---|---|
| `/hub` | `(shell)/hub/page.tsx` — launcher card grid |
| `/hub/questify/quests` | `(questify)/hub/questify/quests/page.tsx` |
| `/hub/questify/village` | `(questify)/hub/questify/village/page.tsx` |
| `/hub/questify/village/[slug]` | `(questify)/hub/questify/village/[slug]/page.tsx` |
| `/hub/user-management` | `(user-management)/hub/user-management/page.tsx` |

`web/app/page.tsx` redirects to `/hub`. The existing `(shell)/dashboard/` and `(questify)/dashboard/` directories are renamed/moved accordingly.

**Alternative considered**: Keep `/dashboard` for the hub and add a separate prefix for verticals. Rejected — `/hub` is the correct semantic name for the launcher, and consistency across mobile and web reduces confusion.

### 3. Hub card data stays hardcoded (web)

The web hub's `verticals` array in `(shell)/hub/page.tsx` remains a static list. No dynamic registry, no database. The mobile equivalent is `registeredModules` in `modules.dart`.

**Alternative considered**: Derive vertical list from a shared config package. Premature — with two verticals a static list is sufficient. Extract when a third vertical is added.

## Risks / Trade-offs

- **Broken links during migration** → Any hardcoded `/dashboard/...` hrefs inside Questify components must be updated. Grep for `/dashboard` before declaring done.
- **User Management scope creep** → Keep the initial vertical to profile view + basic account settings only. Character stats and XP are read-only display, no editing.

## Migration Plan

1. Rename `web/app/(shell)/dashboard/` → `web/app/(shell)/hub/` (hub moves from `/dashboard` to `/hub`)
2. Rename `web/app/(questify)/dashboard/` → `web/app/(questify)/hub/questify/` (Questify routes move to `/hub/questify/...`)
3. Update `web/app/page.tsx` redirect from `/dashboard` to `/hub`
4. Grep codebase for any remaining `/dashboard` hrefs and fix them
5. Run scaffold script for `user-management` vertical
6. Implement minimal profile page in `verticals/user-management/web/` and `verticals/user-management/mobile/`
7. Add `(user-management)/hub/user-management/page.tsx` shell route
8. Add User Management card to hub with `href: "/hub/user-management"`
9. Register `userManagementModule` in mobile shell and router
10. Smoke-test both platforms

No database migrations required. No rollback needed — changes are purely additive UI/routing (plus renames).
