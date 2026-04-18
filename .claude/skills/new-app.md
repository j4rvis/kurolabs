# new-app

Scaffold a new vertical (product line) in this monorepo.

## Trigger phrases
"new vertical", "scaffold X app", "create a new app called X", "add a vertical", "new product line"

## What the script does
`scripts/new-vertical.sh <name> [--web] [--mobile] [--supabase]`

- Copies `scripts/templates/` into `verticals/<name>/`
- Substitutes `__VERTICAL__`, `__VERTICAL_PASCAL__`, `__VERTICAL_SNAKE__` tokens
- Symlinks shared Supabase migrations into the new vertical
- Appends `.next/` and `.dart_tool/` entries to root `.gitignore`
- Prints one success line or an error — nothing else

Default (no flags): creates all three sub-apps (web + mobile + supabase).

## Steps

1. Confirm the vertical name with the user if not provided in the request.
   Name must be lowercase kebab-case (e.g. `habit-tracker`, `finance`).

2. Run the script:
   ```
   bash scripts/new-vertical.sh <name>
   ```
   Use flags to skip sub-apps the user doesn't want, e.g.:
   ```
   bash scripts/new-vertical.sh <name> --web --supabase
   ```

3. On success, run:
   ```
   pnpm install
   ```

4. Copy the env example:
   ```
   cp verticals/<name>/web/.env.local.example verticals/<name>/web/.env.local
   ```

5. Print the post-scaffold checklist (adapt based on what was scaffolded):

   **Web** — fill in `verticals/<name>/web/.env.local`:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE_KEY`
   Then run `pnpm --filter <name>-web dev`

   **Supabase** — link and push schema:
   ```
   cd verticals/<name>/supabase
   supabase link --project-ref <ref>
   supabase db push
   ```

   **Mobile** — install deps:
   ```
   cd verticals/<name>/mobile
   flutter pub get
   dart run build_runner build  # if using Riverpod codegen
   ```

   **Vercel** — create a new Vercel project pointing at this repo root.
   The `verticals/<name>/web/vercel.json` contains the correct build config.

## What NOT to do
- Do not read or modify any template files
- Do not create a Supabase project automatically
- Do not commit the generated files unless the user asks
