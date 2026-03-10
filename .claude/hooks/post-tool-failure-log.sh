#!/bin/bash
# post-tool-failure-log.sh — PostToolUseFailure hook
# Appends a compact one-line failure record to .claude/tool-failures.log.

command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // "unknown"' 2>/dev/null)
ERR=$(echo "$INPUT" | jq -r '.error // "unknown error"' 2>/dev/null)
INTERRUPT=$(echo "$INPUT" | jq -r '.is_interrupt // false' 2>/dev/null)

LOG_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude"
mkdir -p "$LOG_DIR"

ERR_ONELINE=$(printf '%s' "$ERR" \
  | tr '\r\n' '  ' \
  | sed 's/[[:space:]]\+/ /g' \
  | cut -c1-400)

printf '%s TOOL_FAIL tool=%s interrupt=%s error=%s\n' \
  "$(date -u +%FT%TZ)" "$TOOL" "$INTERRUPT" "$ERR_ONELINE" >> "$LOG_DIR/tool-failures.log"

exit 0
