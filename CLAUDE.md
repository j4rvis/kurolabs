# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What is this?

KuroLabs is a monorepo for building D&D-themed apps. Currently hosts **Questify**, a habit/quest tracker. Shared infrastructure (auth, characters, XP) is reused across future verticals.

## Obsidian Vault

The `obsidian/` folder is a live knowledge base. Use it as context when relevant.

**When to read the vault:**
- Before proposing, designing, or implementing a feature — check for existing notes, decisions, or specs
- When the user references something that might be documented (a feature name, a vertical, a past decision)
- When running `opsx:propose` — always check the vault for related context before generating a proposal
- When asked to summarize, organize, or build on existing knowledge

**How to access it:**
- Direct file reads (`obsidian/*.md`) always work
- If Obsidian is running, use `scripts/obsidian.sh` for search and task listing:
  ```bash
  scripts/obsidian.sh search "query"   # semantic search across vault
  scripts/obsidian.sh tasks            # list open tasks
  scripts/obsidian.sh read "path.md"   # read a specific note
  ```
- Check CLI availability first: `scripts/obsidian.sh status`

**When to write to the vault:**
- When the user asks to save a note, decision, or summary
- After a significant design discussion — offer to save a summary note

## Docs

- [docs/web.md](docs/web.md) — Next.js web apps, commands, conventions
- [docs/flutter.md](docs/flutter.md) — Flutter mobile apps, commands, packages
- [docs/api.md](docs/api.md) — API routes and Edge Functions
- [docs/supabase.md](docs/supabase.md) — Database schema, migrations, RLS, Edge Functions
- [docs/skills.md](docs/skills.md) — Claude Code skills and OpenSpec workflow
- [docs/verticals/index.md](docs/verticals/index.md) — Vertical architecture: shared vs. vertical-specific
- [docs/verticals/questify.md](docs/verticals/questify.md) — Questify vertical in detail
