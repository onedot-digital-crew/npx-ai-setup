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
  echo "⛔ Circuit Breaker TRIGGERED: ${FILE_PATH} edited ${COUNT}x in 10min" >&2
  echo "" >&2
  echo "This usually means:" >&2
  echo "  • The current approach isn't working" >&2
  echo "  • You're stuck in a loop trying the same fix repeatedly" >&2
  echo "  • The file has a deeper issue that needs investigation" >&2
  echo "" >&2
  echo "Recommended actions:" >&2
  echo "  1. Explain to the user what you were trying to do" >&2
  echo "  2. Describe what went wrong and why you kept editing" >&2
  echo "  3. Propose a different approach or ask for guidance" >&2
  echo "  (Circuit breaker resets automatically when you send the next message)" >&2
  exit 2
fi

if [ "$COUNT" -ge "$WARN" ]; then
  echo "⚠️  Circuit Breaker Warning: ${FILE_PATH} edited ${COUNT}x in 10min (blocks at ${BLOCK})" >&2
  echo "Consider: Is this the right approach? Should you try something different?" >&2
fi

exit 0
