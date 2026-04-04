#!/bin/bash
# session-length.sh — PostToolUse hook
# Counts tool calls per session and warns when sessions get too long.
# At 100 calls: suggest /pause. At 200 calls: strongly recommend fresh session.
# Debounces: only emits every 25 tool calls after first warning.

INPUT=$(cat)

SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // ""' 2>/dev/null)
SESSION_ID=$(echo "$SESSION_ID" | tr -cd 'a-zA-Z0-9_-')
[ -z "$SESSION_ID" ] && exit 0

COUNTER_FILE="/tmp/claude-session-len-${SESSION_ID}"

# Increment counter
COUNT=0
[ -f "$COUNTER_FILE" ] && COUNT=$(head -1 "$COUNTER_FILE" 2>/dev/null || echo 0)
case "$COUNT" in ''|*[!0-9]*) COUNT=0 ;; esac
COUNT=$(( COUNT + 1 ))
echo "$COUNT" > "$COUNTER_FILE" 2>/dev/null || true

# Thresholds
WARN=100
CRITICAL=200
DEBOUNCE=25

[ "$COUNT" -lt "$WARN" ] && exit 0

# Debounce: only emit at threshold crossings and every DEBOUNCE calls after
SINCE_WARN=$(( COUNT - WARN ))
if [ "$COUNT" -ge "$CRITICAL" ]; then
  SINCE_CRIT=$(( COUNT - CRITICAL ))
  if [ "$SINCE_CRIT" -ne 0 ] && [ $(( SINCE_CRIT % DEBOUNCE )) -ne 0 ]; then
    exit 0
  fi
  MESSAGE="SESSION ZU LANG (${COUNT} tool calls). Context drift ist wahrscheinlich. Empfehlung: /pause und neue Session starten. Alternativ: /reflect um Learnings zu sichern, dann /clear."
elif [ "$SINCE_WARN" -ne 0 ] && [ $(( SINCE_WARN % DEBOUNCE )) -ne 0 ]; then
  exit 0
else
  MESSAGE="Session hat ${COUNT} tool calls erreicht. Ueberlege ob /pause + frische Session sinnvoll ist, oder ob Teilaufgaben an Subagents delegiert werden koennen."
fi

command -v jq >/dev/null 2>&1 || { echo "$MESSAGE" >&2; exit 0; }
jq -n --arg msg "$MESSAGE" '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":$msg}}'
exit 0
