---
created: 2026-04-21
tags: [chrome-extension, verticals, architecture]
---

# Chrome Extension Architecture in Verticals

Chrome extensions are a first-class sub-app type in KuroLabs verticals, alongside `web/`, `mobile/`, and `supabase/`. Each vertical that ships an extension owns it under `verticals/<name>/chrome-extension/`.

## Architecture

- **Location**: `verticals/<name>/chrome-extension/`
- **Standard files**: `manifest.json` (Manifest V3), `popup.html`, `popup.js`, `background.js`, `icons/`
- **Auth**: Uses `chrome.storage.local` for Supabase session storage. User logs in via the web app first; the extension reads the session from storage. Background service worker handles session refresh.
- **API calls**: Direct Supabase REST API calls with the stored auth token (no separate backend needed).

## Per-Vertical Pattern

Each vertical defines its own extension with vertical-specific capture UI and branding. There is no shared extension host — coupling would be too high and Manifest V3 requires a static extension ID per deployment.

## Launcher Integration

The KuroLabs hub launcher shows a "Get Extension" link on any vertical card that has a Chrome extension. This link navigates to the vertical's extension download page (e.g. `/omoi/chrome-extension`).

## Download Page

Each vertical with a Chrome extension hosts a download/install page at `/[vertical]/chrome-extension`. During development this links to a `.crx` side-load. In production it links to the Chrome Web Store listing.

## Scaffolding

Currently, `scripts/new-vertical.sh` does not scaffold `chrome-extension/` automatically. The Omoi extension is being built first to establish the pattern, then the template will be extracted and the script updated.

## First Vertical Using This Pattern

- **Omoi** (想い) — thought capture. Extension popup captures a quick thought without leaving the current tab. No page content is read unless the user explicitly includes a URL reference.

## Related

- [[Thought Capture Vertical Idea]]
- [[Omoi App Name Decision]]
- [[Bookmark Vertical Idea]]
