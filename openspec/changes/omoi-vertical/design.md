## Context

KuroLabs is a monorepo with a shared shell (auth, launcher, character/XP system) and self-contained verticals. Questify is the only active vertical. Omoi is a new vertical for personal thought capture — the "inner world" counterpart to Kioku (external bookmarks). Omoi is named after the Japanese word for "thought/feeling" (想い). The vault confirms the naming decision and a detailed idea note specifying all platforms including a Chrome extension.

Currently, verticals support three sub-apps: `web/`, `mobile/`, and `supabase/`. Chrome extensions are not yet a standard vertical artifact. This design introduces them.

## Goals / Non-Goals

**Goals:**
- Scaffold the full Omoi vertical (web, mobile, supabase, chrome-extension)
- Define the Omoi data model: thoughts with tags, categories, and connections
- Add auto-enrichment (tag extraction + category classification) via an Edge Function
- Introduce `verticals/<name>/chrome-extension/` as a standard vertical sub-app pattern
- Surface a Chrome extension download link on the Omoi web app
- Register Omoi in the mobile hub

**Non-Goals:**
- AI-powered semantic search or embeddings (deferred)
- Public sharing of thoughts
- Collaboration / multi-user thoughts
- Modifying `scripts/new-vertical.sh` in this change (tracked separately as follow-up)

## Decisions

### 1. Chrome extension lives inside the vertical, not shared

**Decision:** `verticals/<name>/chrome-extension/` — each vertical owns its extension.

**Rationale:** Extensions are vertical-specific in UI, API calls, and branding. A shared extension host would require dynamic routing and add coupling. Manifest V3 requires a static extension ID per deployment, so separation is also practical.

**Alternative considered:** A single shared extension with vertical tabs. Rejected — too much complexity for a first pass, and verticals may have completely different capture UIs.

### 2. Auto-enrichment via Edge Function (not client-side)

**Decision:** On thought creation, a Supabase Edge Function `enrich-thought` is called to extract tags and classify category. Results are written back to the thought row.

**Rationale:** Keeps enrichment server-side, allows future model upgrades without client changes, and avoids exposing API keys to the browser/extension.

**Alternative considered:** Client-side enrichment with a lightweight model. Rejected — no model available in-browser, and would require shipping large assets to the extension.

### 3. Connections are symmetric, stored as pairs

**Decision:** A `thought_connections` junction table with `(thought_id_a, thought_id_b)` where `thought_id_a < thought_id_b` (enforced by constraint) to prevent duplicates.

**Rationale:** Simple to query bidirectionally with a single `OR` condition. No directionality needed for the current use case.

**Alternative considered:** Directed connections (from/to). Deferred — no requirement for direction yet.

### 4. Chrome extension authenticates via Supabase magic link / stored session

**Decision:** Extension popup uses `supabase-js` with `chrome.storage.local` for session persistence. On first open, user is prompted to log in via the web app (which writes a session token the extension reads via `chrome.storage`). 

**Rationale:** Avoids embedding credentials in the extension. Follows the pattern used by tools like Linear's extension.

**Alternative considered:** OAuth flow inside the popup. More friction, deferred for now.

### 5. Download link served from the Omoi web app

**Decision:** A static page at `/omoi/chrome-extension` explains the extension and links to the Chrome Web Store listing (or a packaged `.crx` for side-loading during development).

**Rationale:** No separate landing page needed — the web app already handles auth and is the natural home for the download link.

## Risks / Trade-offs

- **Edge Function latency on thought creation** → Enrichment is async (fire-and-forget); the thought is saved immediately and tags/category are filled in shortly after. UI should show a "processing" state.
- **Chrome extension review timeline** → Publishing to the Web Store takes days-weeks. Plan for a side-loadable dev build first, Web Store as a follow-up.
- **Session sync complexity (extension ↔ web)** → Using `chrome.storage.local` requires the user to log in via the web app first. Mitigation: clear onboarding flow in the extension popup.
- **`new-vertical.sh` doesn't yet scaffold `chrome-extension/`** → Template scaffolding is a follow-up. The Omoi extension will be built manually first, then the template is extracted.

## Open Questions

- Which auto-enrichment model/service? (OpenAI, Anthropic, or rule-based heuristics?) → Start with rule-based regex/keyword extraction; swap to LLM later.
- Should the Chrome extension also work for Kioku (bookmarks) when that vertical is built? → Yes, but that's Kioku's scope, not Omoi's.
