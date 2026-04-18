# Web

Next.js apps live at `verticals/<name>/web/`. The shared web library is at `shared/web/` (`@kurolabs/web`).

## Commands

From the repo root (runs the questify web app):
```bash
pnpm dev        # dev server at localhost:3000
pnpm build      # production build
pnpm lint       # ESLint
```

Or from inside `verticals/questify/web/`:
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
verticals/questify/web/node_modules/next/dist/docs/
```

Heed deprecation notices. Do not assume App Router APIs match your training data.

## App structure

```
app/
  layout.tsx         # Root layout
  page.tsx           # Landing/redirect
  auth/              # Login, signup, callback
  dashboard/         # Protected main app
  api/               # API route handlers
components/          # Shared React components
lib/
  types.ts           # All domain types for this vertical
  supabase/          # Supabase client setup (imports from @kurolabs/web)
middleware.ts        # Auth protection (imports from @kurolabs/web/middleware/auth)
```

## Auth pattern

All `/dashboard` and `/api` routes are protected by `middleware.ts`. It uses `@kurolabs/web/middleware/auth` which refreshes the Supabase session on every request. API routes create a server Supabase client via `@kurolabs/web/supabase/server`.

## Deployment

Vercel. `vercel.json` at root configures the build. The root `package.json` `dev`/`build`/`lint` scripts delegate to the questify web workspace.
