# Web

One Next.js shell app lives at `web/` (repo root). It owns auth, the KuroLabs launcher dashboard, and composes all vertical routes. Vertical-specific web code lives at `verticals/<name>/web/` as pnpm workspace packages — they export components and logic but have no standalone entry point.

## Commands

From the repo root:
```bash
pnpm dev        # dev server at localhost:3000
pnpm build      # production build
pnpm lint       # ESLint
```

Or from inside `web/`:
```bash
pnpm dev / build / lint
```

To run a specific workspace:
```bash
pnpm --filter web dev
```

## ⚠️ Next.js version warning

This project uses **Next.js 16.2.2** — there are breaking changes from earlier versions. Before writing any Next.js-specific code, read the relevant guide in:

```
web/node_modules/next/dist/docs/
```

Heed deprecation notices. Do not assume App Router APIs match your training data.

## Shell app structure (`web/`)

```
app/
  layout.tsx             # Root layout
  page.tsx               # Landing/redirect
  (auth)/                # Login, signup, OAuth callback — shell concern
  (shell)/               # KuroLabs launcher dashboard — shell concern
  (questify)/            # Questify routes (import from @questify/web)
  api/
    auth/                # Auth API handlers
    questify/            # Questify API handlers
components/
  shell/                 # Shell UI components (nav, launcher cards, etc.)
lib/
middleware.ts            # Auth protection (imports from @kurolabs/web/middleware/auth)
```

## Vertical web modules

Each vertical's `verticals/<name>/web/` is a pnpm workspace package — it is **not** a standalone Next.js app and cannot run independently. It exports feature components and business logic consumed by the shell.

```
verticals/<name>/web/
  components/            # Feature-specific React components
  lib/
    types.ts             # Vertical-specific TypeScript types
  package.json           # name: @<name>/web — no Next.js entry point
```

The shell's `app/(<name>)/` route group provides the actual Next.js route files and imports from the vertical's package.

## Auth pattern

All `/dashboard`, `/(questify)`, and `/api` routes are protected by `web/middleware.ts`. It uses `@kurolabs/web/middleware/auth` which refreshes the Supabase session on every request. API routes create a server Supabase client via `@kurolabs/web/supabase/server`.

## Deployment

Vercel. `vercel.json` at root configures the build pointing to `web/`.
