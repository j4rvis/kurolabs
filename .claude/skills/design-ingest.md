# design-ingest

Ingest a Claude Design handoff zip into the KuroLabs project and clean up afterwards.

## Trigger phrases
"incorporate the design zip", "ingest the design handoff", "update the design system", "new design zip", "/design-ingest"

## What this does

Finds a Claude Design handoff zip in the project root, extracts it, copies each file to its permanent home, and deletes the zip and any extracted folder.

## Steps

### 1. Find the zip

Look for any `*.zip` in the project root that looks like a design handoff:
```
ls *.zip
```
If there are multiple, take the **newest by date** (Claude Design re-exports accumulate with `(1)`, `(2)` suffixes). If none found, tell the user and stop.

### 2. Extract to temp

```bash
unzip -o "<zipfile>" -d /tmp/ds-ingest
```

The zip always extracts into `kurolabs-design-system/project/`. So working root is:
```
/tmp/ds-ingest/kurolabs-design-system/project/
```

### 3. Copy files to permanent homes

Use this exact mapping. For each path, copy only if the file exists in the zip:

| Source (inside `project/`) | Destination(s) |
|---|---|
| `colors_and_type.css` | `.claude/skills/kurolabs-design/colors_and_type.css` |
| `assets/npc/*.png` | `.claude/skills/kurolabs-design/assets/npc/` |
| `fonts/SyneMono-Regular.ttf` | `.claude/skills/kurolabs-design/fonts/SyneMono-Regular.ttf`<br>`web/public/fonts/SyneMono-Regular.ttf`<br>`verticals/questify/web/public/fonts/SyneMono-Regular.ttf`<br>`verticals/omoi/web/public/fonts/SyneMono-Regular.ttf` |
| `preview/*.html` | `.claude/skills/kurolabs-design/preview/` |
| `ui_kits/hub/` | `.claude/skills/kurolabs-design/ui_kits/hub/` |
| `ui_kits/questify/` | `.claude/skills/kurolabs-design/ui_kits/questify/` |
| `ui_kits/omoi/` | `.claude/skills/kurolabs-design/ui_kits/omoi/` |
| `shared/theme/kurolabs.css` | `shared/theme/kurolabs.css`<br>`.claude/skills/kurolabs-design/shared/theme/kurolabs.css` |
| `shared/theme/hub.css` | `shared/theme/hub.css`<br>`.claude/skills/kurolabs-design/shared/theme/hub.css` |
| `shared/theme/questify.css` | `shared/theme/questify.css`<br>`.claude/skills/kurolabs-design/shared/theme/questify.css` |
| `shared/theme/omoi.css` | `shared/theme/omoi.css`<br>`.claude/skills/kurolabs-design/shared/theme/omoi.css` |
| `shared/theme/flutter/*.dart` | `shared/theme/flutter/`<br>`.claude/skills/kurolabs-design/shared/theme/flutter/` |

Create destination directories if they don't exist (`mkdir -p`).

### 4. Review the handoff README

Read `project/README.md` from the zip. Compare key sections against the current skill README at `.claude/skills/kurolabs-design/README.md`:
- Did accent colors change?
- Did typography change?
- Are there new token names?

If there are **substantive changes**, update `.claude/skills/kurolabs-design/README.md` to reflect them. If the handoff README is stale/identical to the old one (Claude Design sometimes doesn't update it), skip — the CSS files are authoritative.

### 5. Clean up

```bash
rm "<zipfile>"
rm -rf /tmp/ds-ingest
# Also remove any previously-extracted folder if present in project root:
rm -rf "kurolabs-design-system" "kurolabs-design-system 2/" 2>/dev/null || true
```

Also check for and remove other stale artifacts that sometimes appear in root:
- `Cinzel.zip`
- `SyneMono-Regular.ttf` (loose copy)

### 6. Report

Print a concise summary:
- Which files were updated
- Whether the skill README was updated or skipped (and why)
- Any destination directories that had to be created (signals a new web app was added)

## What NOT to do

- Do not edit `SKILL.md` in the skill directory — that's managed manually
- Do not commit the changes unless the user asks
- Do not copy `project/README.md` verbatim into the skill — review and update selectively
- Do not copy `project/uploads/` — those are scratch files from the Claude Design session
