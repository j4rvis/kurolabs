## 1. Rename Web Routes

- [x] 1.1 Move `web/app/(shell)/dashboard/` → `web/app/(shell)/hub/` so the launcher is served at `/hub`
- [x] 1.2 Move `web/app/(questify)/dashboard/layout.tsx` and all children to `web/app/(questify)/hub/questify/` so Questify routes are served at `/hub/questify/quests`, `/hub/questify/village`, etc.
- [x] 1.3 Update `web/app/page.tsx` redirect from `/dashboard` to `/hub`
- [x] 1.4 Grep codebase for remaining `/dashboard` hrefs (e.g. in nav links, Questify components) and update them to their new paths

## 2. Scaffold User Management Vertical

- [x] 2.1 Run `./scripts/new-vertical.sh user-management --web --mobile` to generate `verticals/user-management/web/` and `verticals/user-management/mobile/`
- [x] 2.2 Verify generated packages resolve (`pnpm install` from root; `flutter pub get` in `verticals/user-management/mobile/`)

## 3. User Management — Web

- [x] 3.1 Implement `ProfilePage` component in `verticals/user-management/web/components/` that reads `profiles` and displays display name, username, avatar, and character class
- [x] 3.2 Add edit form for `display_name` and `username` with Supabase update and uniqueness error handling
- [x] 3.3 Add a Sign Out button that calls `supabase.auth.signOut()` and redirects to `/hub`
- [x] 3.4 Export `ProfilePage` from `verticals/user-management/web/index.ts`
- [x] 3.5 Create shell route `web/app/(user-management)/hub/user-management/page.tsx` that imports and renders `ProfilePage` from `@user-management/web`

## 4. User Management — Mobile

- [x] 4.1 Implement `UserManagementScreen` widget in `verticals/user-management/mobile/` with profile read display (display name, username, avatar, character class)
- [x] 4.2 Add edit functionality for `display_name` and `username` with Supabase update and error state
- [x] 4.3 Add Sign Out button that calls `supabase.auth.signOut()` (auth state change triggers router redirect to `/auth/login`)
- [x] 4.4 Define and export `userManagementModule` as a `ModuleConfig` from the mobile package
- [x] 4.5 Add `/hub/user-management` route to `mobile/lib/router/router.dart`
- [x] 4.6 Register `userManagementModule` in `mobile/lib/features/shell/modules.dart`

## 5. Web Hub — Add User Management Card

- [x] 5.1 Update the `verticals` array in `web/app/(shell)/hub/page.tsx` to add User Management with name, icon (👤), description, and `href: "/hub/user-management"`

## 6. Verification

- [x] 6.1 Web: `/` redirects to `/hub`; hub shows Questify and User Management cards
- [x] 6.2 Web: Questify card navigates to `/hub/questify/quests`; village at `/hub/questify/village`
- [x] 6.3 Web: User Management card navigates to `/hub/user-management`; profile loads and edits save
- [x] 6.4 Web: unauthenticated user is redirected to login; no `/dashboard` URLs remain in the app
- [x] 6.5 Mobile: hub shows Questify and User Management cards; both navigate correctly
- [x] 6.6 Mobile: unauthenticated launch → login; post-login → hub at `/hub`
- [x] 6.7 Mobile: user management screen loads profile, edits save, sign-out redirects to login
