# Omoi Vertical

**想い** (omoi) — personal thought capture. Named after the Japanese word for "thought/feeling."

## Overview

Omoi is a frictionless thought-capture app: write down ideas, questions, reminders, and insights. Thoughts are auto-tagged and auto-categorized via a server-side Edge Function, and can be connected to form a personal knowledge graph.

## Directory Layout

```
verticals/omoi/
  web/                          # @omoi/web — React components + types
    lib/types.ts                # Thought, ThoughtStats interfaces
    components/thoughts/        # OmoiDashboard, ThoughtList, ThoughtDetail, ThoughtSearch
  mobile/                       # omoi_module — Flutter screens + Riverpod providers
    lib/
      omoi_module.dart          # Library entry (exports module config + routes)
      omoi_module_config.dart   # ModuleConfig(name: 'Omoi', path: '/omoi')
      omoi_routes.dart          # GoRouter routes: /omoi, /omoi/thoughts/:id
      features/thoughts/
        repositories/thoughts_repository.dart
        providers/thoughts_providers.dart
        screens/
          thought_list_screen.dart
          thought_capture_sheet.dart
          thought_detail_screen.dart
  supabase/
    migrations/20260421000001_omoi_thoughts.sql
    functions/enrich-thought/index.ts
  chrome-extension/
    manifest.json               # Manifest V3
    popup.html / popup.js       # Capture UI
    background.js               # Session refresh alarm
    icons/                      # icon16/48/128.png (generate from icon.svg)
```

## Database Schema

### `thoughts`

| Column | Type | Notes |
|--------|------|-------|
| `id` | uuid | PK, `gen_random_uuid()` |
| `user_id` | uuid | FK → `auth.users`, cascade delete |
| `content` | text | Not null |
| `category` | thought_category | Enum: question/reminder/insight/idea/other |
| `tags` | text[] | Default `{}` |
| `created_at` | timestamptz | Default `now()` |
| `updated_at` | timestamptz | Auto-updated via trigger |

RLS: users can CRUD their own rows only.

### `thought_connections`

| Column | Type | Notes |
|--------|------|-------|
| `thought_id_a` | uuid | FK → thoughts (the smaller UUID) |
| `thought_id_b` | uuid | FK → thoughts (the larger UUID) |
| `created_at` | timestamptz | |

Constraints: composite PK, check `thought_id_a < thought_id_b` (enforces canonical ordering, prevents duplicates).

RLS: users can insert/delete connections where both thoughts belong to them.

## API Routes

All routes live at `web/app/(omoi)/api/thoughts/`.

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/thoughts` | List with pagination (`page`, `limit`) |
| POST | `/api/thoughts` | Create. Fires `enrich-thought` async. |
| GET | `/api/thoughts/:id` | Single thought + connections |
| PATCH | `/api/thoughts/:id` | Update content/category/tags |
| DELETE | `/api/thoughts/:id` | Delete |
| GET | `/api/thoughts/search` | Search by `q`, `tag`, `category` |
| GET | `/api/thoughts/stats` | total, today, connections, top_tags |
| POST | `/api/thoughts/:id/connections` | Add connection (`other_id` body) |
| DELETE | `/api/thoughts/:id/connections` | Remove (`other_id` query param) |

## Edge Functions

### `enrich-thought`

- **Location:** `verticals/omoi/supabase/functions/enrich-thought/index.ts`
- **Trigger:** Called fire-and-forget from the POST `/api/thoughts` route
- **Input:** `{ thought_id: string }`
- **Behavior:** Fetches thought content, runs rule-based tag extraction (hashtags + capitalized words) and category classification (keyword patterns), writes back `category` and `tags`
- **Auth:** No JWT required (called server-to-server with anon key)

## Web App Routes

| URL | Page |
|-----|------|
| `/hub/omoi/dashboard` | `OmoiDashboard` — recent thoughts, stats, quick capture |
| `/hub/omoi/thoughts/:id` | `ThoughtDetail` — full content, connections, edit/delete |
| `/hub/omoi/chrome-extension` | Extension download/install instructions |

## Chrome Extension

- **Location:** `verticals/omoi/chrome-extension/`
- **Manifest V3** — `action` popup, `storage` permission, `host_permissions` for Supabase URL
- **Auth:** Reads session from `chrome.storage.local` (key: `omoi_session`). User must be logged in via the web app first.
- **Capture:** POSTs to Supabase REST API `/rest/v1/thoughts` with the stored access token
- **Session refresh:** Background service worker refreshes the token every 50 minutes via an alarm
- **Icons:** Generate from `icons/icon.svg` (purple background, 想 character)
- **Install:** Load unpacked from `verticals/omoi/chrome-extension/` in Chrome developer mode

## Mobile Module

- **Package:** `omoi_module` at `verticals/omoi/mobile/`
- **Routes:** `/omoi` (list), `/omoi/thoughts/:id` (detail)
- **State:** Riverpod providers — `thoughtListProvider(page)`, `thoughtDetailProvider(id)`, `thoughtConnectionsProvider(id)`, `thoughtStatsProvider`
- **Capture:** Bottom sheet (`ThoughtCaptureSheet`) accessible from FAB and AppBar

## Hub Registration

The Omoi card is shown on the KuroLabs launcher at `/hub` with a "Get Extension →" link to the chrome-extension page.
