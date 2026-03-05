#!/bin/bash
# task-completed-gate.sh — TaskCompleted hook
# Prevents clearly incomplete task closures and logs task completion attempts.

command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
TASK_ID=$(echo "$INPUT" | jq -r '.task_id // "unknown"' 2>/dev/null)
TASK_SUBJECT=$(echo "$INPUT" | jq -r '.task_subject // ""' 2>/dev/null)
TASK_DESCRIPTION=$(echo "$INPUT" | jq -r '.task_description // ""' 2>/dev/null)
TEAMMATE_NAME=$(echo "$INPUT" | jq -r '.teammate_name // "n/a"' 2>/dev/null)

LOG_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude"
mkdir -p "$LOG_DIR"
printf '%s TASK_COMPLETED id=%s teammate=%s subject=%s\n' \
  "$(date -u +%FT%TZ)" "$TASK_ID" "$TEAMMATE_NAME" "$(printf '%s' "$TASK_SUBJECT" | tr '\r\n' '  ' | sed 's/[[:space:]]\+/ /g' | cut -c1-200)" \
  >> "$LOG_DIR/task-completed.log"

# Block obviously unfinished placeholders in task metadata.
if printf '%s\n%s' "$TASK_SUBJECT" "$TASK_DESCRIPTION" | grep -qiE '\b(TODO|TBD|WIP)\b'; then
  echo "Task completion blocked: task still contains TODO/TBD/WIP markers." >&2
  exit 2
fi

# Block unresolved merge conflict markers in tracked files.
if command -v git >/dev/null 2>&1 && git rev-parse --git-dir >/dev/null 2>&1; then
  if git grep -n -E '^(<<<<<<<|=======|>>>>>>>)' -- . >/dev/null 2>&1; then
    echo "Task completion blocked: unresolved merge conflict markers found." >&2
    exit 2
  fi
fi

exit 0
