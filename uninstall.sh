#!/usr/bin/env bash
# uninstall.sh — remove delete-session.sh and its slash command from ~/.claude/
#
# Removes:
#   ~/.claude/scripts/delete-session.sh
#   ~/.claude/commands/delete-session.md
#
# Idempotent. Succeeds silently if files are already gone.

set -eu

FORCED=0
for arg in "$@"; do
  case "$arg" in
    --force|-f) FORCED=1 ;;
    --help|-h)  sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *)          echo "unknown flag: $arg" >&2; exit 2 ;;
  esac
done

remove_file() {
  local target="$1"
  if [ ! -e "$target" ]; then
    echo "✓ $target (already absent)"
    return 0
  fi
  if [ "$FORCED" -ne 1 ]; then
    read -r -p "Remove $target? [y/N] " confirm
    case "$confirm" in
      y|Y|yes|YES) ;;
      *) echo "  skipped."; return 0 ;;
    esac
  fi
  rm -- "$target"
  echo "✓ $target (removed)"
}

remove_file "$HOME/.claude/scripts/delete-session.sh"
remove_file "$HOME/.claude/commands/delete-session.md"

echo ""
echo "Uninstalled."
