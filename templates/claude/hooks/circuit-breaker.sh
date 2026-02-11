#!/bin/bash
# Circuit Breaker: Detects when Claude is going in circles
# Tracks edit frequency per file. Warns at 5x, blocks at 8x within 10 min.
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -z "$FILE_PATH" ] && exit 0

PROJ_HASH=$(echo "$PWD" | shasum | cut -c1-8)
LOG="/tmp/claude-cb-${PROJ_HASH}.log"
NOW=$(date +%s)
WINDOW=600
WARN=5
BLOCK=8

echo "$NOW $FILE_PATH" >> "$LOG"

CUTOFF=$((NOW - WINDOW))
awk -v c="$CUTOFF" '$1 >= c' "$LOG" > "${LOG}.tmp" 2>/dev/null && mv "${LOG}.tmp" "$LOG"

COUNT=$(grep -cF "$FILE_PATH" "$LOG" 2>/dev/null || echo 0)

if [ "$COUNT" -ge "$BLOCK" ]; then
  echo "Circuit Breaker: $FILE_PATH edited ${COUNT}x in 10min. STOP." >&2
  echo "You are going in circles. Explain the problem to the user." >&2
  exit 2
fi

if [ "$COUNT" -ge "$WARN" ]; then
  echo "Circuit Breaker: $FILE_PATH edited ${COUNT}x in 10min." >&2
  echo "Check if you are repeating yourself. Consider a different approach." >&2
fi

exit 0
