#!/usr/bin/env bash
set -euo pipefail

# ── helpers ───────────────────────────────────────────────────────────────────
die() { echo "error: $1" >&2; exit 1; }

# ── args / flags ──────────────────────────────────────────────────────────────
NAME="${1:-}"
[[ -z "$NAME" ]] && die "usage: new-vertical.sh <name> [--web] [--mobile] [--supabase]"
shift

DO_WEB=false; DO_MOBILE=false; DO_SUPABASE=false; ALL=true
while [[ $# -gt 0 ]]; do
  case "$1" in
    --web)      DO_WEB=true;      ALL=false ;;
    --mobile)   DO_MOBILE=true;   ALL=false ;;
    --supabase) DO_SUPABASE=true; ALL=false ;;
    *) die "unknown flag: $1" ;;
  esac
  shift
done
if $ALL; then DO_WEB=true; DO_MOBILE=true; DO_SUPABASE=true; fi

# ── validate name ─────────────────────────────────────────────────────────────
[[ "$NAME" =~ ^[a-z][a-z0-9-]*$ ]] || die "name must be lowercase kebab-case (e.g. my-app)"

# ── derived name forms ────────────────────────────────────────────────────────
KEBAB="$NAME"
PASCAL="$(echo "$NAME" | python3 -c "import sys; print(''.join(w.capitalize() for w in sys.stdin.read().strip().split('-')))")"
SNAKE="$(echo "$NAME" | tr '-' '_')"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATES="$REPO_ROOT/scripts/templates"
DEST="$REPO_ROOT/verticals/$KEBAB"

[[ -e "$DEST" ]] && die "verticals/$KEBAB already exists"

# ── scaffold_dir: copy template tree with token substitution ──────────────────
scaffold_dir() {
  local src="$1" dst="$2"
  mkdir -p "$dst"

  find "$src" -mindepth 1 | sort | while read -r item; do
    local rel="${item#$src/}"
    # Substitute tokens in path segments
    local rel_out
    rel_out="$(echo "$rel" \
      | sed "s/__VERTICAL_PASCAL__/$PASCAL/g" \
      | sed "s/__VERTICAL_SNAKE__/$SNAKE/g" \
      | sed "s/__VERTICAL__/$KEBAB/g")"
    # Strip .tmpl suffix (used for files like .gitignore.tmpl)
    rel_out="${rel_out%.tmpl}"

    local target="$dst/$rel_out"
    if [[ -d "$item" ]]; then
      mkdir -p "$target"
    else
      sed \
        -e "s|__VERTICAL_PASCAL__|$PASCAL|g" \
        -e "s|__VERTICAL_SNAKE__|$SNAKE|g" \
        -e "s|__VERTICAL__|$KEBAB|g" \
        "$item" > "$target"
    fi
  done
}

# ── scaffold each sub-app ─────────────────────────────────────────────────────
if $DO_WEB; then
  scaffold_dir "$TEMPLATES/web" "$DEST/web"
fi

if $DO_MOBILE; then
  scaffold_dir "$TEMPLATES/mobile" "$DEST/mobile"
fi

if $DO_SUPABASE; then
  scaffold_dir "$TEMPLATES/supabase" "$DEST/supabase"
  mkdir -p "$DEST/supabase/migrations"
  # Symlink shared migrations so new vertical starts with the canonical schema
  if [[ -d "$REPO_ROOT/shared/supabase/migrations" ]]; then
    for f in "$REPO_ROOT/shared/supabase/migrations"/*.sql; do
      [[ -e "$f" ]] || continue
      ln -sf "$f" "$DEST/supabase/migrations/$(basename "$f")"
    done
  fi
fi

# ── update root .gitignore ────────────────────────────────────────────────────
GITIGNORE="$REPO_ROOT/.gitignore"
if $DO_WEB && ! grep -qF "verticals/$KEBAB/web/.next/" "$GITIGNORE" 2>/dev/null; then
  printf '\n# %s web\nverticals/%s/web/.next/\nverticals/%s/web/out/\n' \
    "$KEBAB" "$KEBAB" "$KEBAB" >> "$GITIGNORE"
fi
if $DO_MOBILE && ! grep -qF "verticals/$KEBAB/mobile/.dart_tool/" "$GITIGNORE" 2>/dev/null; then
  printf '# %s mobile\nverticals/%s/mobile/.dart_tool/\nverticals/%s/mobile/.flutter-plugins\nverticals/%s/mobile/.flutter-plugins-dependencies\n' \
    "$KEBAB" "$KEBAB" "$KEBAB" "$KEBAB" >> "$GITIGNORE"
fi

echo "created verticals/$KEBAB"
