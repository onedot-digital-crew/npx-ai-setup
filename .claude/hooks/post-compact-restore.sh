#!/usr/bin/env bash
# post-compact-restore.sh — SessionStart hook (matcher: compact)
# Restores a short resume hint after compaction.

cat >/dev/null

command -v jq >/dev/null 2>&1 || exit 0

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
STATE_FILE="$PROJECT_ROOT/.claude/compact-state.json"
[ -f "$STATE_FILE" ] || exit 0

HAS_ACTIVE=$(jq -r '.has_active_spec // false' "$STATE_FILE" 2>/dev/null)
[ "$HAS_ACTIVE" = "true" ] || {
  rm -f "$STATE_FILE"
  exit 0
}

SPECS=$(jq -r '.active_specs[]?' "$STATE_FILE" 2>/dev/null)
[ -n "$SPECS" ] || {
  rm -f "$STATE_FILE"
  exit 0
}

MESSAGE="Context restored after compaction.\nActive specs:\n$(printf '%s\n' "$SPECS" | sed 's/^/- /')\nResume the in-progress spec before starting unrelated work."
rm -f "$STATE_FILE"
jq -n --arg msg "$MESSAGE" '{"additionalContext":$msg}'

exit 0
