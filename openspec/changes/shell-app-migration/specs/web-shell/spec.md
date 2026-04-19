## ADDED Requirements

### Requirement: Shell app exists at web/ and is the sole Next.js entry point
The `web/` directory at the repo root SHALL be the only Next.js application in the monorepo. No `verticals/*/web/` package SHALL contain a `next.config.ts` or act as a deployable Next.js app.

#### Scenario: Only web/ has next.config.ts
- **WHEN** the repo is inspected for `next.config.ts` files
- **THEN** exactly one exists, at `web/next.config.ts`

---

### Requirement: Auth routes live in the shell
The shell SHALL provide `/auth/login`, `/auth/signup`, and `/api/auth/callback` routes in the `(auth)` route group. These routes SHALL NOT be duplicated in any vertical package.

#### Scenario: Unauthenticated user visits a protected route
- **WHEN** a user without a valid session visits any non-auth route
- **THEN** the middleware redirects them to `/auth/login`

#### Scenario: Auth callback completes
- **WHEN** Supabase OAuth callback hits `/api/auth/callback`
- **THEN** the session is created and the user is redirected to the launcher dashboard

---

### Requirement: Shell middleware protects all non-public routes
`web/middleware.ts` SHALL import `@kurolabs/web/middleware/auth` and protect all routes except `(auth)` and static assets.

#### Scenario: Protected route with valid session
- **WHEN** a user with a valid Supabase session visits `/dashboard`
- **THEN** the request proceeds without redirect

#### Scenario: Protected route without session
- **WHEN** a user without a session visits any route outside `(auth)`
- **THEN** they are redirected to `/auth/login`

---

### Requirement: KuroLabs launcher dashboard exists in the shell
The shell SHALL provide a launcher dashboard route (e.g., `/dashboard`) in the `(shell)` route group that renders links/cards to all registered verticals.

#### Scenario: Authenticated user visits the launcher
- **WHEN** an authenticated user visits the launcher dashboard
- **THEN** they see a card or entry point for each registered vertical (currently: Questify)

---

### Requirement: Questify routes live in web/app/(questify)/
The shell SHALL contain a `(questify)` route group that provides all Questify page and API routes. Route files in this group SHALL import from `@questify/web` and SHALL NOT contain business logic directly.

#### Scenario: Questify dashboard route renders
- **WHEN** an authenticated user visits the Questify dashboard route
- **THEN** the page renders using components from `@questify/web`

---

### Requirement: Vercel deployment targets web/
The `vercel.json` at the repo root SHALL configure `rootDirectory` or equivalent so Vercel builds from `web/`.

#### Scenario: Vercel build succeeds
- **WHEN** Vercel runs a production build
- **THEN** it finds `web/next.config.ts` and builds successfully

---

### Requirement: @questify/web is a module-only pnpm package
`verticals/questify/web/package.json` SHALL have `"name": "@questify/web"` and SHALL NOT have a `next.config.ts`, standalone `middleware.ts`, or auth routes. It SHALL export only React components and TypeScript logic.

#### Scenario: @questify/web has no standalone entry
- **WHEN** `verticals/questify/web/` is inspected
- **THEN** there is no `next.config.ts` and no auth route files

#### Scenario: Shell can import from @questify/web
- **WHEN** a route file in `web/app/(questify)/` imports from `@questify/web`
- **THEN** TypeScript resolves the import without errors
