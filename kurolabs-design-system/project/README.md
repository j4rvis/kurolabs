# KuroLabs Design System

## Overview

KuroLabs is a **D&D-themed monorepo hub** for interconnected apps, each named in Japanese style. The hub acts as a launcher — a tavern board where users choose their next adventure. Each vertical ("app") has its own identity color and persona, while sharing structural foundations.

**Source:** GitHub repo `j4rvis/kurolabs` (branch: `main`)
Live repo: https://github.com/j4rvis/kurolabs

---

## Products

| App | Japanese Name | Tagline | Accent Color |
|-----|--------------|---------|--------------|
| **KuroLabs Hub** | 黒ラボ | "Choose your adventure" | Gold `#c9a227` |
| **Questify** | — | "Turn daily habits into epic quests" | Gold `#c9a227` + D&D palette |
| **Omoi** | 想 | "Capture thoughts, ideas, and insights" | Violet `#7c3aed` |

More verticals are planned. Each will follow the shared structural shell but carry its own identity color and Japanese character motif.

---

## File Index

```
README.md                    ← this file
colors_and_type.css          ← all CSS custom properties for the system
SKILL.md                     ← agent skill manifest

assets/
  npc/                       ← AI-generated D&D NPC character portraits (Questify)

preview/                     ← Design System tab card HTMLs
  colors-hub.html
  colors-questify.html
  colors-omoi.html
  type-scale.html
  type-fonts.html
  badges-questify.html
  badges-omoi.html
  components-questify.html
  components-omoi.html

ui_kits/
  hub/                       ← KuroLabs Hub launcher
  questify/                  ← Questify quest tracker
  omoi/                      ← Omoi thought capture
```

---

## CONTENT FUNDAMENTALS

### Voice & Tone

- **Questify**: Epic fantasy / D&D flavour. Commands feel like dungeon master prompts. Nouns are capitalized like game terms ("Quest Board", "Epic Quest", "Village"). Second-person: "Your adventure", "Visit the Village". Flavourful but functional — not overwrought.
- **Omoi**: Calm, minimal, zen. Minimalist copy like "What's on your mind?" and "Capture thought". Mono/code aesthetic in labels. Time shown as relative (`3h ago`, `just now`). Labels lowercase (`clear filter`, `next →`).
- **Hub**: Brief and inviting. Minimal copy, one-liner descriptions per app.

### Casing

- Display headings: `ALL CAPS` with wide letter-spacing (e.g. `KUROLABS`, `QUEST BOARD`)
- Body: Sentence case
- Badges/labels: Title Case for D&D terms; lowercase for Omoi system text
- Navigation items: Title Case

### Emoji / Unicode

- Questify uses a small set of emoji as decorative icons: ⚔️ (quests), 🔥 (streak). Also uses Japanese kanji as icons: `想` (Omoi), and potential future characters per vertical.
- Omoi avoids emoji entirely.
- Unicode `→` arrows used in navigation links.

### Numbers & Data

- XP values: integers with " XP" suffix (e.g. `250 XP`)
- Streaks: `🔥 N day streak`
- Stats: large bold number + small label below (e.g. `42 / Total`)
- Relative timestamps: `Xm ago`, `Xh ago`, `Xd ago`, `just now`

---

## VISUAL FOUNDATIONS

### Color Philosophy

KuroLabs uses **two distinct palettes** — one for D&D/fantasy apps (Questify, Hub), one for modern-minimal apps (Omoi). The hub aspires toward a **paper/washi aesthetic**: warm neutrals, subtle texture, bright but not garish.

**Shared design intent:** Slightly Japanese in feel — clean hierarchy, minimal ornamentation, strong typographic presence. Each app uses a single accent color against a near-neutral ground.

### Questify / Hub Palette

| Token | Value | Use |
|-------|-------|-----|
| `--tavern` | `#1a1208` | Page background (very dark brown) |
| `--tavern-light` | `#2d2010` | Card background |
| `--tavern-mid` | `#3d2f18` | Elevated surfaces, active states |
| `--tavern-border` | `#5a4025` | Borders, dividers |
| `--parchment` | `#f5e6c8` | Primary text |
| `--parchment-dark` | `#e0c990` | Headings on dark |
| `--parchment-muted` | `#c8aa78` | Secondary text, labels |
| `--ink` | `#2c1810` | Text on light backgrounds |
| `--ink-muted` | `#7a5c40` | Subdued text on light |
| `--gold` | `#c9a227` | Primary accent — links, active states, headings |
| `--gold-light` | `#f0c940` | Hover state for gold |

### Difficulty / Semantic Colors (Questify)

| Token | Value | Use |
|-------|-------|-----|
| `--diff-trivial` | `#6c757d` | Grey |
| `--diff-easy` | `#3a8c4e` | Green |
| `--diff-medium` | `#c9a227` | Gold |
| `--diff-hard` | `#d4732a` | Orange |
| `--diff-deadly` | `#c0392b` | Red |
| `--diff-legendary` | `#8e44ad` | Purple |
| `--type-daily` | `#2980b9` | Blue |
| `--type-side` | `#27ae60` | Green |
| `--type-epic` | `#8e44ad` | Purple |

### Omoi Palette

| Token | Value | Use |
|-------|-------|-----|
| `--omoi-bg` | `#09090b` | Page background (zinc-950) |
| `--omoi-surface` | `#18181b` | Card background (zinc-900) |
| `--omoi-border` | `#27272a` | Borders (zinc-800) |
| `--omoi-text` | `#e4e4e7` | Primary text (zinc-200) |
| `--omoi-muted` | `#71717a` | Secondary text (zinc-500) |
| `--omoi-accent` | `#7c3aed` | Violet — primary actions |
| `--omoi-accent-hover` | `#6d28d9` | Violet darker |

### Typography

**Fonts used in production:**
- `Cinzel` (Google Fonts) — serif display, used for all hero headings in Questify/Hub. Weights 400/600/700. All-caps tracking.
- `Geist Sans` (Vercel) — clean geometric sans, body text across all apps
- `Geist Mono` (Vercel) — monospaced, code, tags in Omoi

**Substitutes for design system (Google Fonts CDN):**
- Cinzel → ✅ available on Google Fonts
- Geist Sans → substituted with **Inter** (nearest match)
- Geist Mono → replaced with **Syne Mono** (brand font, `fonts/SyneMono-Regular.ttf`)

### Backgrounds & Texture

- Questify/Hub: Near-black warm brown (`#1a1208`). No texture in code, but design intent is **washi/parchment paper feel** — subtle grain or aged paper texture is appropriate.
- Omoi: Flat near-black zinc. Clean and digital.

### Spacing

- Base unit: `4px` (Tailwind defaults)
- Card padding: `16px` (p-4)
- Section gaps: `24px` (gap-6)
- Page max-width: `max-w-4xl` (896px)

### Cards

- Background: `--tavern-light` / `--omoi-surface`
- Border: `1px solid` `--tavern-border` / `--omoi-border`
- Radius: `rounded-lg` (8px)
- No drop shadow — borders define card edges
- Hover: border color shifts to accent (`hover:border-gold` / `hover:border-zinc-700`)

### Corner Radii

- Cards, inputs: `rounded-lg` (8px)
- Badges/chips: `rounded-full`
- Buttons: `rounded` (4px)

### Hover / Active States

- Links & buttons: color transition (`transition-colors`)
- Cards: border accent highlight
- No opacity-based hover — always color shift
- Active filter tabs: `bg-tavern-mid text-gold`

### Shadows

None used. Depth is created with background layers and borders.

### Animations

- Only CSS `transition-colors` — no motion libraries
- Duration: default Tailwind (150ms)
- No entrance/exit animations in production code

### Iconography

See **ICONOGRAPHY** section below.

---

## ICONOGRAPHY

- **No dedicated icon library** — icons are a mix of emoji and Unicode characters
- Emoji icons used in Hub: ⚔️ Questify, 想 Omoi (kanji), 👤 User Management
- Questify uses 🔥 for streak indicators inline in text
- Omoi uses no icons — text labels only
- No SVG icon sprite or font found in codebase
- **Recommendation**: Lucide React would be consistent with the minimal, clean aesthetic for future expansion

### NPC Character Portraits

Located in `assets/npc/` — AI-generated fantasy character art per life category:

| File | Character | Category |
|------|-----------|----------|
| `Fitness_Bronn Ironveil.png` | Bronn Ironveil | Fitness |
| `Mindfulness_Brother Ashveil.png` | Brother Ashveil | Mindfulness |
| `Reading_Elspeth Inkwell.png` | Elspeth Inkwell | Reading |
| `Writing_Finn Quillmark.png` | Finn Quillmark | Writing |
| `Errands_Pip-Quickpocket.png` | Pip Quickpocket | Errands |

Full set (17 NPCs) available in the GitHub repo under `images/` and `verticals/questify/web/public/images/npc/`.
