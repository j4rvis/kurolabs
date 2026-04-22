# KuroLabs Design System — v2 (Paper / Japanese Edition)

## Overview

KuroLabs is a **D&D-themed monorepo hub** for interconnected apps, each named in Japanese style. The hub acts as a launcher — a tavern board where users choose their next adventure. Each vertical ("app") has its own identity color and persona, while sharing structural foundations.

**v2 aesthetic:** Light paper/washi ground. Warm neutrals, subtle grain texture, rectilinear radius. Syne Mono for all UI text; Cinzel reserved for logotype and kanji-display moments only.

---

## Products

| App | Japanese Name | Tagline | Accent Color |
|-----|--------------|---------|--------------|
| **KuroLabs Hub** | 黒ラボ | "Choose your adventure" | Amber ochre `#b07030` |
| **Questify** | — | "Turn daily habits into epic quests" | Vermilion `#b83c3c` |
| **Omoi** | 想 | "Capture thoughts, ideas, and insights" | Indigo `#3d5a9e` |

---

## File Index

```
README.md                    ← this file
colors_and_type.css          ← standalone CSS reference (all tokens + utilities)
SKILL.md                     ← agent skill manifest

assets/
  npc/                       ← AI-generated D&D NPC character portraits (Questify)

fonts/
  SyneMono-Regular.ttf       ← brand body font (copy to each app's public/fonts/)

preview/                     ← Design reference HTML cards
  tailwind-tokens.html       ← Tailwind v4 token layer overview
  flutter-theme.html         ← Flutter theme token overview
  colors-difficulty.html
  colors-hub.html
  component-hub-launcher.html
  component-omoi-stats.html
  component-omoi-thought.html
  component-quest-card.html
  type-fonts.html

shared/theme/                ← Production-ready CSS + Flutter theme files
  kurolabs.css               ← Layer 1: semantic base (Tailwind v4)
  hub.css                    ← Layer 2: hub — sets --color-primary
  questify.css               ← Layer 2: questify — primary + difficulty/type tokens
  omoi.css                   ← Layer 2: omoi — primary + category tokens
  flutter/
    kurolabs_colors.dart     ← Raw palette (private)
    kurolabs_theme.dart      ← Semantic ThemeExtension + ThemeData builder
    questify_theme.dart      ← Questify domain extension
    omoi_theme.dart          ← Omoi domain extension
    hub_theme.dart           ← Hub ThemeData
    theme.dart               ← Barrel export

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

- Questify uses a small set of emoji as decorative icons: ⚔️ (quests), 🔥 (streak). Also uses Japanese kanji as icons: `想` (Omoi).
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

All apps share a **paper/washi ground** — warm parchment surfaces with ink-scale text. Each app applies a single accent color on top. No dark mode; depth is achieved through layered surfaces, not shadows.

**Shared design intent:** Slightly Japanese in feel — clean hierarchy, minimal ornamentation, strong typographic presence.

### Base Palette (all apps)

| Token | Value | Use |
|-------|-------|-----|
| `--paper` / `bg-bg` | `#f5f0e8` | Page background — warm washi |
| `--paper-raised` / `bg-surface` | `#faf8f3` | Cards, panels, modals |
| `--paper-sunken` / `bg-surface-sunken` | `#ede7da` | Inputs, inset areas |
| `--paper-border` / `border-border` | `#d0c4b0` | Standard border |
| `--paper-divider` / `border-divider` | `#e2dbd0` | Soft section divider |
| `--ink-1` / `text-text` | `#1c1612` | Primary body text |
| `--ink-2` / `text-text-muted` | `#5c4f3d` | Secondary text |
| `--ink-3` / `text-text-subtle` | `#9c8c78` | Labels, placeholders |
| `--ink-4` / `text-text-disabled` | `#c4b8a6` | Disabled / ghost |

### App Accent Colors

| App | Token | Tailwind | Value |
|-----|-------|----------|-------|
| Hub | `--hub-accent` | `text-primary` | `#b07030` amber ochre |
| Questify | `--quest-accent` | `text-primary` | `#b83c3c` vermilion |
| Omoi | `--omoi-accent` | `text-primary` | `#3d5a9e` indigo |

### Difficulty / Semantic Colors (Questify)

| Token | Tailwind | Value | Use |
|-------|----------|-------|-----|
| `--diff-trivial` | `text-diff-trivial` | `#8a9099` | Grey |
| `--diff-easy` | `text-diff-easy` | `#3d7a52` | Green |
| `--diff-medium` | `text-diff-medium` | `#b07030` | Amber |
| `--diff-hard` | `text-diff-hard` | `#b85a20` | Orange |
| `--diff-deadly` | `text-diff-deadly` | `#b83c3c` | Red |
| `--diff-legendary` | `text-diff-legendary` | `#7040a0` | Purple |

Each difficulty has `-soft` (badge background) and `-border` variants.

### Thought Category Colors (Omoi)

| Token | Tailwind | Value |
|-------|----------|-------|
| `--color-cat-philosophy` | `text-cat-philosophy` | `#5840a0` |
| `--color-cat-reading` | `text-cat-reading` | `#3d7a52` |
| `--color-cat-ideas` | `text-cat-ideas` | `#2d5a8e` |
| `--color-cat-writing` | `text-cat-writing` | `#b85a20` |
| `--color-cat-general` | `text-cat-general` | `#8c7a68` |

Each category has `-soft` and `-border` variants.

### Typography

**Production fonts:**
- `Syne Mono` — brand body font, all UI text. `font-sans` in Tailwind. Self-hosted: `public/fonts/SyneMono-Regular.ttf`
- `Cinzel` (Google Fonts) — display serif, logotype + kanji moments only. `font-display` in Tailwind. Weights 400/700. All-caps tracking.

**Usage rule:** Cinzel at low opacity (`.08`–`.15`) as watermark kanji. Everything else: Syne Mono.

### Backgrounds & Texture

All apps use `#f5f0e8` with an SVG fractalNoise overlay at `opacity: 0.04` — subtle paper grain, built into `body` in `kurolabs.css`. No external texture images needed.

### Spacing

- Base unit: `4px` (Tailwind defaults)
- Card padding: `16px` (p-4)
- Section gaps: `24px` (gap-6)
- Page max-width: `max-w-4xl` (896px)

### Cards

- Background: `bg-surface` (`#faf8f3`)
- Border: `1px border-border` (`#d0c4b0`)
- Radius: `rounded-md` (4px)
- No drop shadow — borders define card edges
- Hover: `hover:border-primary transition-colors`

### Corner Radii

- Most elements: `rounded-sm` (2px)
- Cards, modals: `rounded-md` (4px)
- Larger panels: `rounded-lg` (6px)

### Hover / Active States

- Links & buttons: `hover:border-primary hover:bg-surface transition-colors`
- Cards: border shifts to `border-primary`
- Active states: `bg-active-bg` (`bg-surface-sunken`)
- No opacity-based hover — always color shift
- Duration: `transition-colors duration-150`

### Shadows

None. Depth via `bg-bg` → `bg-surface` → `bg-surface-sunken` layering.

---

## TAILWIND v4 — HOW IT WORKS

Theme is layered CSS. Each app's `globals.css`:

```css
@import "tailwindcss";
@import "../../shared/theme/questify.css";   /* or hub.css / omoi.css */
```

The base (`kurolabs.css`) registers semantic tokens. App layers override `--color-primary` only. App-specific tokens (difficulty, categories) live only in their app layer.

See `shared/theme/README.md` and `preview/tailwind-tokens.html` for the full token reference.

---

## FLUTTER — HOW IT WORKS

```dart
// In your app's main.dart:
MaterialApp(theme: QuestifyThemeData.build(), ...)  // or OmoiThemeData / HubThemeData

// Access base tokens anywhere:
final t = KuroLabsTheme.of(context);
Container(color: t.surface)

// Access app-specific tokens (Questify):
final q = QuestifyTheme.of(context);
Badge(color: q.diffEasy)
```

Copy all files from `shared/theme/flutter/` into `shared/mobile/lib/theme/`. Declare fonts in `pubspec.yaml`.

---

## ICONOGRAPHY

- **No dedicated icon library** — icons are emoji and Unicode characters
- Hub: ⚔️ Questify, 想 Omoi (kanji), 👤 User Management
- Questify: 🔥 streak indicators
- Omoi: no icons — text labels only
- **Recommendation**: Lucide React for future expansion (consistent with minimal aesthetic)

### NPC Character Portraits

Located in `assets/npc/` — AI-generated fantasy character art per life category:

| File | Character | Category |
|------|-----------|----------|
| `Fitness_Bronn Ironveil.png` | Bronn Ironveil | Fitness |
| `Mindfulness_Brother Ashveil.png` | Brother Ashveil | Mindfulness |
| `Reading_Elspeth Inkwell.png` | Elspeth Inkwell | Reading |
| `Writing_Finn Quillmark.png` | Finn Quillmark | Writing |
| `Errands_Pip-Quickpocket.png` | Pip Quickpocket | Errands |

Full set (17 NPCs) available under `verticals/questify/web/public/images/npc/`.
