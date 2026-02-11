#!/bin/bash
# Circuit Breaker: Erkennt wenn Claude sich im Kreis dreht
# Trackt Edit-Haeufigkeit pro Datei. Warnt ab 5x, blockiert ab 8x in 10 Min.
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
  echo "Circuit Breaker: $FILE_PATH ${COUNT}x in 10min editiert. STOP." >&2
  echo "Du drehst dich im Kreis. Erklaere dem User das Problem." >&2
  exit 2
fi

if [ "$COUNT" -ge "$WARN" ]; then
  echo "Circuit Breaker: $FILE_PATH ${COUNT}x in 10min editiert." >&2
  echo "Pruefe ob du dich wiederholst. Erwaege einen anderen Ansatz." >&2
fi

exit 0
