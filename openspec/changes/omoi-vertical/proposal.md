## Why

KuroLabs currently hosts Questify (habit tracking) but has no vertical for capturing personal thoughts — the "inner world" counterpart to external content saving. Omoi fills this gap: a fast, frictionless thought-capture app that auto-tags, auto-categorizes, and connects thoughts into a queryable knowledge base of the user's own mind. The vault has existing naming decisions and a detailed idea note that confirm this is well-scoped and ready to build.

## What Changes

- New vertical `omoi` scaffolded under `verticals/omoi/` (web, mobile, supabase)
- New Supabase schema: `thoughts` table with auto-tagging, categorization, connections
- New web module `@omoi/web` with full CRUD UI, search, and stats views
- New Flutter mobile module with full CRUD and home-screen widget
- **New: Chrome extension** scaffold added as a first-class vertical artifact under `verticals/omoi/chrome-extension/` — quick thought capture from the browser without context switching
- **New: Chrome extension architecture** introduced as a standard vertical sub-app type (alongside web/mobile/supabase)
- Download link for the Chrome extension surfaced on the Omoi web app

## Capabilities

### New Capabilities

- `omoi-thought-crud`: Create, read, update, delete thoughts. Each thought has content, a category (question/reminder/insight/idea/other), tags, and optional connection references.
- `omoi-auto-enrichment`: On thought creation, automatically extract tags and classify category from content via an Edge Function.
- `omoi-connections`: Link thoughts to other thoughts. View related entries when querying a thought.
- `omoi-search`: Search thoughts by text, tag, or category. Returns connected thoughts alongside direct matches.
- `omoi-stats`: Per-user thought statistics (count today, total, connections count, top tags).
- `omoi-chrome-extension`: A Manifest V3 Chrome extension per vertical. Opens a popup to capture a thought (or bookmark, depending on vertical) without leaving the current tab. Authenticates via the vertical's Supabase project. Each vertical ships its own extension under `verticals/<name>/chrome-extension/`.
- `omoi-web-app`: Full CRUD web UI, search, stats, and a Chrome extension download link/page.
- `omoi-mobile-app`: Full CRUD mobile app with home-screen widget for instant capture.

### Modified Capabilities

- `vertical-hub`: Expose Chrome extension download links per vertical in the launcher dashboard.

## Impact

- `verticals/omoi/` — new directory (web, mobile, supabase, chrome-extension)
- `web/app/(omoi)/` — new route group in shell
- `mobile/lib/features/` — new Omoi module registered in hub
- `shared/supabase/` — no shared schema changes; Omoi uses its own migrations
- `scripts/new-vertical.sh` — should gain a `--chrome-extension` flag (or generate by default)
- `docs/verticals/index.md` — add Omoi entry
- Obsidian vault — Chrome extension architecture note (created alongside this proposal)
