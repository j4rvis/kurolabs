## 1. Create web/ Next.js shell app

- [x] 1.1 Create `web/package.json` with `"name": "web"`, Next.js 16 + React 19 deps, and `dev/build/lint` scripts
- [x] 1.2 Create `web/next.config.ts`, `web/tsconfig.json`, `web/postcss.config.mjs`, `web/eslint.config.mjs` matching the current questify/web config
- [x] 1.3 Create `web/middleware.ts` importing `@kurolabs/web/middleware/auth` to protect all non-auth routes and redirect to `/auth/login`
- [x] 1.4 Create `web/app/layout.tsx` (root layout with global CSS, providers) and `web/app/page.tsx` (redirect to `/dashboard` or `/auth/login`)
- [x] 1.5 Create `web/app/(auth)/` route group — move login, signup, and OAuth callback route files from `verticals/questify/web/app/auth/` into the shell
- [x] 1.6 Create `web/app/(shell)/dashboard/page.tsx` — KuroLabs launcher dashboard listing registered verticals (Questify card)
- [x] 1.7 Create `web/app/(questify)/` route group — move Questify dashboard and API route files from `verticals/questify/web/app/dashboard/` and `verticals/questify/web/app/api/` into the shell; import components/logic from `@questify/web`
- [x] 1.8 Update `vercel.json` at repo root: remove `outputDirectory: verticals/questify/web/.next`, set `rootDirectory: web` (or equivalent) so Vercel builds from `web/`

## 2. Convert verticals/questify/web/ to @questify/web feature module

- [x] 2.1 Rename `"name"` in `verticals/questify/web/package.json` from `"web"` to `"@questify/web"` and remove `next`, `eslint-config-next`, and app-specific devDependencies that belong to the shell
- [x] 2.2 Delete `verticals/questify/web/next.config.ts` and `verticals/questify/web/middleware.ts`
- [x] 2.3 Delete `verticals/questify/web/app/auth/` (moved to shell in task 1.5)
- [x] 2.4 Delete `verticals/questify/web/app/layout.tsx` and `verticals/questify/web/app/page.tsx` (shell owns root layout)
- [x] 2.5 Delete `verticals/questify/web/app/dashboard/` and `verticals/questify/web/app/api/` route files (moved to shell's `(questify)/` in task 1.7); keep and reorganize any component/logic files that the shell routes import from
- [x] 2.6 Ensure `verticals/questify/web/` exports a clean set of components and types (e.g. `components/`, `lib/types.ts`) that the shell can import from `@questify/web`
- [x] 2.7 Verify TypeScript resolves `@questify/web` imports from within `web/` (check `tsconfig.json` path mappings if needed)

## 3. Create mobile/ Flutter shell app

- [x] 3.1 Create `mobile/pubspec.yaml` — name `kurolabs`, SDK constraint matching Dart 3.11.4, Flutter SDK dep, `go_router`, `flutter_riverpod`, path deps on `shared/mobile/packages/kurolabs_auth/`, `shared/mobile/packages/kurolabs_hub/`, and `verticals/questify/mobile/`
- [x] 3.2 Create `mobile/lib/main.dart` — initializes Supabase (via `kurolabs_auth`), sets up `ProviderScope`, and launches the shell app widget
- [x] 3.3 Create `mobile/lib/router/router.dart` — top-level `go_router` config with routes: auth flow, `HubScreen`, and delegates to each vertical's `ModuleConfig` routes
- [x] 3.4 Create `mobile/lib/features/shell/` — registers Questify `ModuleConfig` and passes the list to `HubScreen` from `kurolabs_hub`
- [x] 3.5 Create `mobile/lib/core/theme/` and `mobile/lib/core/constants/` (copy or adapt from current `verticals/questify/mobile/lib/core/` if it exists)
- [x] 3.6 Create Android and iOS runner config at `mobile/android/` and `mobile/ios/` (copy from current `verticals/questify/mobile/` and update bundle ID / app name to `com.kurolabs.hub`)

## 4. Convert verticals/questify/mobile/ to a Dart package

- [x] 4.1 Update `verticals/questify/mobile/pubspec.yaml`: rename to `questify_module`, confirm `publish_to: 'none'`, remove Flutter app-level dependencies (keep only feature-level deps), add path dep on `kurolabs_hub` for `ModuleConfig` type
- [x] 4.2 Delete `verticals/questify/mobile/lib/main.dart` and `verticals/questify/mobile/lib/app.dart`
- [x] 4.3 Create `verticals/questify/mobile/lib/questify_module.dart` — primary library file that exports a `ModuleConfig` instance (routes, launcher label, icon)
- [x] 4.4 Reorganize screens/widgets/providers under `verticals/questify/mobile/lib/` as needed so they're importable from the shell without relying on a Flutter app entry point
- [x] 4.5 Delete Android/iOS runner directories from `verticals/questify/mobile/` if present (they belong in the shell app now)
- [x] 4.6 Run `flutter pub get` in `mobile/` and verify the questify package resolves correctly

## 5. Update pnpm workspace and root config

- [x] 5.1 Update `pnpm-workspace.yaml` to add `"web"` alongside `"verticals/*/web"` and `"shared/web"`
- [x] 5.2 Update root `package.json`: rename from `"questify"` to `"kurolabs"`, update description; verify `dev/build/lint` scripts still target `--filter web` (which now resolves to `web/`)
- [x] 5.3 Run `pnpm install` from repo root and confirm all workspace packages resolve, including `@questify/web` and the new `web` shell

## 6. Update new-vertical.sh scaffold script

- [x] 6.1 Update the web module template in `scripts/new-vertical.sh` (or its template directory) to scaffold a pnpm package with `"name": "@__VERTICAL__/web"` and no `next.config.ts`, `middleware.ts`, or auth routes
- [x] 6.2 Update the mobile module template to scaffold a Dart package with `publish_to: 'none'`, no `main.dart`, and a `__VERTICAL___module.dart` exporting a `ModuleConfig`
- [x] 6.3 Update any README or inline comments in the script to reflect that new verticals are modules, not standalone apps
- [x] 6.4 Run `./scripts/new-vertical.sh test-vertical --web --mobile` on a temp branch to verify the new scaffold output matches the module pattern; delete the test scaffold
