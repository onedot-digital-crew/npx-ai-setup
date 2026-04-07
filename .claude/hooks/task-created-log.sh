#!/bin/bash
# task-created-log.sh — TaskCreated hook
# Logs task creation and blocks placeholder titles (TODO/TBD/WIP).

command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
TASK_ID=$(echo "$INPUT" | jq -r '.task_id // "unknown"' 2>/dev/null)
TASK_SUBJECT=$(echo "$INPUT" | jq -r '.task_subject // ""' 2>/dev/null)
TEAMMATE_NAME=$(echo "$INPUT" | jq -r '.teammate_name // "n/a"' 2>/dev/null)

LOG_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude"
mkdir -p "$LOG_DIR"
printf '%s TASK_CREATED id=%s teammate=%s subject=%s\n' \
  "$(date -u +%FT%TZ)" "$TASK_ID" "$TEAMMATE_NAME" \
  "$(printf '%s' "$TASK_SUBJECT" | tr '\r\n' '  ' | cut -c1-200)" \
  >> "$LOG_DIR/task-created.log"

# Block placeholder titles before the task is launched.
if printf '%s' "$TASK_SUBJECT" | grep -qiE '\b(TODO|TBD|WIP)\b'; then
  echo "Task creation blocked: title still contains TODO/TBD/WIP placeholder." >&2
  exit 2
fi

exit 0
