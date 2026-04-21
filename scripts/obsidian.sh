#!/usr/bin/env bash
# obsidian.sh — thin wrapper around the Obsidian CLI for Claude Code
# Requires Obsidian v1.12+ with CLI enabled: Settings → General → Command line interface
# Obsidian must be running for most commands.

set -euo pipefail

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../obsidian" && pwd)"

usage() {
  cat <<EOF
Usage: scripts/obsidian.sh <command> [args]

Commands:
  search <query>         Search the vault
  read <path>            Read a note (path relative to vault root)
  create <path>          Create a new note
  append <path> <text>   Append text to a note
  tasks                  List all tasks in the vault
  open <path>            Open a note in Obsidian
  status                 Check if Obsidian CLI is available and running

Examples:
  scripts/obsidian.sh search "Questify"
  scripts/obsidian.sh read "projects/Questify.md"
  scripts/obsidian.sh create "daily/$(date +%Y-%m-%d).md"
  scripts/obsidian.sh tasks
EOF
}

check_cli() {
  if ! command -v obsidian &>/dev/null; then
    echo "ERROR: Obsidian CLI not found on PATH."
    echo "Enable it in Obsidian: Settings → General → Command line interface"
    echo "Then restart your terminal."
    exit 1
  fi
}

cmd="${1:-}"

case "$cmd" in
  status)
    if command -v obsidian &>/dev/null; then
      echo "Obsidian CLI: $(obsidian --version)"
      echo "Vault: $VAULT_DIR"
    else
      echo "Obsidian CLI: not found"
      echo "Enable in Obsidian: Settings → General → Command line interface"
    fi
    ;;
  search)
    check_cli
    query="${2:?Usage: search <query>}"
    obsidian search query="$query"
    ;;
  read)
    check_cli
    note="${2:?Usage: read <path>}"
    obsidian read "$note"
    ;;
  create)
    check_cli
    note="${2:?Usage: create <path>}"
    obsidian create "$note"
    ;;
  append)
    check_cli
    note="${2:?Usage: append <path> <text>}"
    text="${3:?Usage: append <path> <text>}"
    obsidian append "$note" "$text"
    ;;
  tasks)
    check_cli
    obsidian tasks
    ;;
  open)
    check_cli
    note="${2:?Usage: open <path>}"
    obsidian open "$note"
    ;;
  ""|help|--help|-h)
    usage
    ;;
  *)
    echo "Unknown command: $cmd"
    usage
    exit 1
    ;;
esac
