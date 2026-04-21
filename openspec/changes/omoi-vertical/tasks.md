## 1. Scaffold Vertical

- [x] 1.1 Run `scripts/new-vertical.sh omoi` to scaffold web, mobile, and supabase sub-apps
- [x] 1.2 Run `pnpm install` after scaffolding
- [x] 1.3 Copy `verticals/omoi/web/.env.local.example` to `verticals/omoi/web/.env.local` and fill in Supabase credentials
- [x] 1.4 Create `verticals/omoi/chrome-extension/` directory with initial `manifest.json`, `popup.html`, `popup.js`, `background.js`, and `icons/` placeholders
- [x] 1.5 Add `omoi` entry to `docs/verticals/index.md`

## 2. Database Schema

- [x] 2.1 Create migration for `thoughts` table: `id`, `user_id`, `content` (text, not null), `category` (enum: question/reminder/insight/idea/other, default other), `tags` (text[]), `created_at`, `updated_at`
- [x] 2.2 Create migration for `thought_connections` junction table: `thought_id_a`, `thought_id_b` (UUID, both FK to thoughts), unique constraint on the ordered pair, check constraint `thought_id_a < thought_id_b`
- [x] 2.3 Add RLS policies to `thoughts`: users can CRUD their own rows only
- [x] 2.4 Add RLS policies to `thought_connections`: users can insert/delete connections only where both thoughts are theirs
- [x] 2.5 Create `updated_at` trigger on `thoughts` table (auto-update on row change)
- [x] 2.6 Run `supabase db push` in `verticals/omoi/supabase/` (applied via MCP tool)

## 3. Edge Functions

- [x] 3.1 Create `verticals/omoi/supabase/functions/enrich-thought/index.ts` — accepts `thought_id`, fetches content, extracts tags (keyword/regex-based), classifies category, writes back to the row
- [x] 3.2 Wire up Supabase Database Webhook (or call from API route) to trigger `enrich-thought` on INSERT and UPDATE to `thoughts` (wired fire-and-forget from POST /api/thoughts)
- [x] 3.3 Deploy the edge function: `supabase functions deploy enrich-thought` (deployed via MCP tool)

## 4. Web API Routes

- [x] 4.1 Create `web/app/(omoi)/api/thoughts/route.ts` — GET (list with pagination) and POST (create)
- [x] 4.2 Create `web/app/(omoi)/api/thoughts/[id]/route.ts` — GET (single + connections), PATCH (update), DELETE
- [x] 4.3 Create `web/app/(omoi)/api/thoughts/search/route.ts` — GET with `q`, `tag`, `category` query params
- [x] 4.4 Create `web/app/(omoi)/api/thoughts/stats/route.ts` — GET returns total, today count, connections count, top tags
- [x] 4.5 Create `web/app/(omoi)/api/thoughts/[id]/connections/route.ts` — POST (add connection) and DELETE (remove connection)

## 5. Web UI

- [x] 5.1 Create `verticals/omoi/web/` package with `package.json` (`@omoi/web`) and basic tsconfig
- [x] 5.2 Create `OmoiDashboard` component — recent thoughts list + stats bar + quick-capture input
- [x] 5.3 Create `ThoughtList` component with pagination, category badges, tag chips
- [x] 5.4 Create `ThoughtDetail` component — full content, tags, category, connections list, edit/delete actions
- [x] 5.5 Create `ThoughtSearch` component — search bar with debounce, tag filter chips, category dropdown
- [x] 5.6 Create `web/app/(omoi)/hub/omoi/dashboard/page.tsx` importing from `@omoi/web`
- [x] 5.7 Create `web/app/(omoi)/hub/omoi/thoughts/[id]/page.tsx` for thought detail view
- [x] 5.8 Create `web/app/(omoi)/hub/omoi/chrome-extension/page.tsx` — extension download/install page with description and CWS link

## 6. Chrome Extension

- [x] 6.1 Write `manifest.json` (Manifest V3): action popup, `storage` permission, host_permissions for Supabase URL
- [x] 6.2 Write `background.js` — session refresh logic using `chrome.storage.local`
- [x] 6.3 Write `popup.html` + `popup.js` — thought capture UI: text area, submit button, success/error states
- [x] 6.4 Implement session check on popup open: if no valid session, show "open Omoi to log in" message
- [x] 6.5 Implement thought submission: POST to Supabase REST API (`/rest/v1/thoughts`) with auth header from stored session
- [x] 6.6 Add extension icons (16px, 48px, 128px) in `icons/` (SVG source added; PNG generation is manual)
- [ ] 6.7 Test extension by loading unpacked in Chrome from `verticals/omoi/chrome-extension/` (manual)

## 7. Mobile Module

- [x] 7.1 Register Omoi Flutter module in `mobile/lib/router/` and hub launcher
- [x] 7.2 Create `thought_list_screen.dart` — paginated list with pull-to-refresh
- [x] 7.3 Create `thought_capture_sheet.dart` — bottom sheet with text field and submit button
- [x] 7.4 Create `thought_detail_screen.dart` — full content, tags, connections
- [x] 7.5 Create Supabase data layer (`thoughts_repository.dart`) with CRUD methods
- [x] 7.6 Create Riverpod providers for thought list, single thought, and stats
- [ ] 7.7 Implement home screen widget for Android (AppWidgetProvider) with capture input (requires native Android code — deferred)
- [x] 7.8 Run `flutter pub get` and `dart run build_runner build` in `verticals/omoi/mobile/`

## 8. Hub Integration

- [x] 8.1 Add Omoi module card to the KuroLabs web launcher with app name, icon, and navigation link
- [x] 8.2 Add "Get Extension" link to the Omoi launcher card that navigates to `/omoi/chrome-extension`
- [x] 8.3 Verify Omoi route group is protected by shell middleware (`web/middleware.ts` matcher) — protected via layout-level auth redirect

## 9. Docs & Vault

- [x] 9.1 Create `docs/verticals/omoi.md` documenting schema, API routes, edge functions, and Chrome extension
- [x] 9.2 Update `docs/verticals/index.md` to add Omoi to the existing verticals table
- [x] 9.3 Verify the Obsidian vault Chrome extension architecture note is present — confirmed at `obsidian/decisions/Chrome Extension Architecture in Verticals.md`
