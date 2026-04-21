---
name: "Note: Create Obsidian Note"
description: Create a new Obsidian note with a generated title, inferred folder, frontmatter, and related links
category: Vault
tags: [obsidian, vault, notes]
---

Create a new Obsidian note from the provided content.

---

**Input**: Everything after `/note` is the note content. It may be a raw thought, a decision, a spec snippet, or anything worth capturing.

**Steps**

1. **Get content**

   If nothing was provided after `/note`, use the **AskUserQuestion tool** to ask:
   > "What do you want to capture in this note?"

2. **Generate title and filename**

   From the content, derive:
   - A short, descriptive **title** in Title Case (3–6 words, human-readable)
   - A **filename** in `Title Case.md` format (same as title, with `.md` extension)

   Good titles are specific and searchable: prefer `XP Leveling Formula` over `XP Notes`, `Auth Session Token Storage Decision` over `Auth`.

3. **Infer folder**

   Pick the most appropriate subfolder based on content:
   - `projects/` — about a specific vertical or feature (Questify, auth, shared infra, etc.)
   - `decisions/` — an architectural or design decision, a tradeoff, a "we chose X because Y"
   - `ideas/` — a rough idea, future feature, or speculation
   - `daily/` — a daily log, standup note, or date-specific entry
   - Vault root (`obsidian/`) — general or doesn't fit above

   The full path will be `obsidian/<folder>/<filename>` or `obsidian/<filename>` for root.

4. **Search for related notes via CLI**

   Check CLI availability:
   ```bash
   scripts/obsidian.sh status
   ```

   If available, extract 2–3 key terms from the content and run a search per term:
   ```bash
   scripts/obsidian.sh search "<term>"
   ```
   Use only the note titles returned by the CLI as `[[WikiLinks]]` — do not invent or infer connections.

   If the CLI is not available, omit the Related section entirely.

5. **Write the note**

   Create the file using the **Write tool** at the inferred path. Use this structure:

   ```markdown
   ---
   created: <YYYY-MM-DD>
   tags: [<1–3 inferred tags>]
   ---

   # <Title>

   <Content — lightly cleaned up for clarity and formatting, meaning preserved exactly>

   ## Related

   - [[<note title from CLI results>]]
   - [[<note title from CLI results>]]
   ```

   - Clean up the content lightly (fix typos, add punctuation, improve readability) but preserve the user's meaning exactly — no summarizing or rewriting
   - `## Related` contains only note titles from CLI search results — never invented
   - Omit `## Related` if CLI was unavailable or returned no results
   - Tags should be lowercase and short (e.g. `questify`, `auth`, `xp`, `decision`)

6. **Open in Obsidian**

   If the CLI is available, open the note:
   ```bash
   scripts/obsidian.sh open "<folder>/<filename>"
   ```

**Output**

Tell the user:
- The file path created
- The title generated
- Any related notes linked
- One sentence: "Open with `/note` again or edit directly in Obsidian."
