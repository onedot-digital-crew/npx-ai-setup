#!/bin/bash
# config-change-audit.sh — ConfigChange hook
# Logs config mutations and blocks unsafe settings in user/project/local scopes.

command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
SOURCE=$(echo "$INPUT" | jq -r '.source // "unknown"' 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | jq -r '.file_path // empty' 2>/dev/null)

LOG_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude"
mkdir -p "$LOG_DIR"
printf '%s CONFIG_CHANGE source=%s file=%s\n' \
  "$(date -u +%FT%TZ)" "$SOURCE" "${FILE_PATH:-n/a}" >> "$LOG_DIR/config-changes.log"

# policy_settings cannot be blocked by Claude Code; keep this as audit-only.
[ "$SOURCE" = "policy_settings" ] && exit 0

# Security/compliance guardrails for mutable settings files.
if [ -n "$FILE_PATH" ] && [ -f "$FILE_PATH" ]; then
  if jq -e '.disableAllHooks == true' "$FILE_PATH" >/dev/null 2>&1; then
    echo "Blocked config change: disableAllHooks=true is not allowed in this setup." >&2
    exit 2
  fi

  if jq -e '.permissions.allow[]? | select(. == "Bash(*)")' "$FILE_PATH" >/dev/null 2>&1; then
    echo "Blocked config change: wildcard Bash(*) permission is not allowed." >&2
    exit 2
  fi
fi

exit 0
