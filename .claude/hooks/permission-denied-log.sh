#!/usr/bin/env bash
# permission-denied-log.sh — experimental denial logger
# Emits source-specific hints only when the payload identifies the denial source.

command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
[ -n "$INPUT" ] || exit 0

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
LOG_FILE="$PROJECT_ROOT/.claude/permission-denied.log"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

SOURCE=$(printf '%s' "$INPUT" | jq -r '.source // .reason_source // ""' 2>/dev/null)
TOOL=$(printf '%s' "$INPUT" | jq -r '.tool_name // .tool // ""' 2>/dev/null)
ACTION=$(printf '%s' "$INPUT" | jq -r '.action // .permission // ""' 2>/dev/null)
DETAIL=$(printf '%s' "$INPUT" | jq -r '.message // .detail // ""' 2>/dev/null)
PAYLOAD=$(printf '%s' "$INPUT" | jq -c '.' 2>/dev/null || printf '{}')

[ "$SOURCE" = "null" ] && SOURCE=""
[ "$TOOL" = "null" ] && TOOL=""
[ "$ACTION" = "null" ] && ACTION=""
[ "$DETAIL" = "null" ] && DETAIL=""

mkdir -p "$PROJECT_ROOT/.claude"
printf '%s\t%s\n' "$TIMESTAMP" "$PAYLOAD" >> "$LOG_FILE"

case "$SOURCE" in
  permissions.deny|project_settings|user_settings|policy_settings)
    printf '[permission-denied] %s blocked %s via %s.\n' "${TOOL:-Tool}" "${ACTION:-action}" "$SOURCE" >&2
    ;;
  *)
    printf '[permission-denied] %s blocked %s. Check .claude/permission-denied.log for payload details.\n' "${TOOL:-Tool}" "${ACTION:-action}" >&2
    ;;
esac

[ -n "$DETAIL" ] && printf '[permission-denied] %s\n' "$DETAIL" >&2

exit 0
