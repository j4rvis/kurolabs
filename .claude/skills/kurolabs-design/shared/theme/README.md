# KuroLabs Tailwind Theme

Semantic, layered Tailwind v4 theme. Each layer only knows what it needs to.

## Architecture

```
shared/theme/
  kurolabs.css   ← Layer 1: semantic base (surfaces, text, primary)
  hub.css        ← Layer 2: hub — sets --color-primary only
  questify.css   ← Layer 2: questify — primary + difficulty/type tokens
  omoi.css       ← Layer 2: omoi — primary + category tokens
```

**The base theme knows nothing about quests, thoughts, XP, or any app domain.**  
App-specific semantic tokens live only in their own layer file.

## Setup

In your app's `globals.css`, replace everything with:

```css
@import "tailwindcss";
@import "../../shared/theme/questify.css";   /* hub.css / omoi.css / kurolabs.css */
```

Copy `SyneMono-Regular.ttf` → `public/fonts/SyneMono-Regular.ttf` in each app.

## Adding a new app

1. Create `shared/theme/myapp.css`:
```css
@import "./kurolabs.css";

:root {
  --color-primary:      #your-color;
  --color-primary-soft: #your-tint;

  /* App domain tokens — only this file knows about them */
  --color-myapp-thing: #...;
}

@theme inline {
  --color-myapp-thing: var(--color-myapp-thing);
}
```
2. Choose a kanji + romaji label for the hub card.

---

## Semantic Token Reference

### Surfaces
| Class | Value | Use |
|-------|-------|-----|
| `bg-bg` | `#f5f0e8` | Page background |
| `bg-surface` | `#faf8f3` | Cards, panels, modals |
| `bg-surface-sunken` | `#ede7da` | Inputs, inset areas |
| `bg-hover-bg` | `#faf8f3` | Hover state surface |
| `bg-active-bg` | `#ede7da` | Pressed / active state |

### Borders
| Class | Value | Use |
|-------|-------|-----|
| `border-border` | `#d0c4b0` | Standard border |
| `border-divider` | `#e2dbd0` | Soft section divider |
| `border-primary` | app color | Hover / active accent border |

### Text
| Class | Value | Use |
|-------|-------|-----|
| `text-text` | `#1c1612` | Primary body text |
| `text-text-muted` | `#5c4f3d` | Secondary text |
| `text-text-subtle` | `#9c8c78` | Labels, placeholders |
| `text-text-disabled` | `#c4b8a6` | Disabled / ghost text |
| `text-primary` | app color | Accent text |

### Primary (contextual — changes per app)
| Class | Use |
|-------|-----|
| `text-primary` | Accent headings, active labels |
| `bg-primary` | Filled buttons, active indicators |
| `bg-primary-soft` | Tinted badge backgrounds |
| `border-primary` | Hover borders, focus rings |

### Fonts
| Class | Font |
|-------|------|
| `font-sans` | Syne Mono — all UI text |
| `font-display` | Cinzel — logotype + kanji only |

---

## Questify-only tokens (in `questify.css`)

```
text-diff-trivial / easy / medium / hard / deadly / legendary
bg-diff-trivial-soft / easy-soft / ...
text-type-daily / side / epic
bg-type-daily-soft / side-soft / epic-soft
```

## Omoi-only tokens (in `omoi.css`)

```
text-cat-philosophy / reading / ideas / writing / general
bg-cat-philosophy-soft / reading-soft / ...
```

---

## Design rules

- **No shadows** — depth via `bg-bg` → `bg-surface` → `bg-surface-sunken`
- **Borders**: `1px border-border` by default; `border-primary` on hover/focus
- **Radius**: `rounded-sm` (2px) most elements; `rounded-md` (4px) cards
- **Hover**: `hover:border-primary hover:bg-surface transition-colors`
- **Transitions**: always `transition-colors duration-150`
- **Kanji**: `font-display` at large size, very low opacity (`.08`–`.15`) as watermark
