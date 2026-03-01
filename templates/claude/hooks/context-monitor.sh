#!/bin/bash
# context-monitor.sh — PostToolUse hook
# Warns when context window is approaching exhaustion by reading bridge file
# written by statusline.sh on every render.
#
# Outputs additionalContext JSON at <=35% remaining (WARNING) and <=25% (CRITICAL).
# Debounces via a counter file — 5 tool calls between warnings at same severity.
# Severity escalation (WARNING -> CRITICAL) bypasses debounce.
# Silent exit 0 when bridge file missing, stale (>60s), or jq unavailable.

command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)

SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // ""' 2>/dev/null)
[ -z "$SESSION_ID" ] && exit 0

BRIDGE_FILE="/tmp/claude-ctx-${SESSION_ID}.json"
[ -f "$BRIDGE_FILE" ] || exit 0

# Read bridge file
BRIDGE=$(cat "$BRIDGE_FILE" 2>/dev/null) || exit 0
[ -z "$BRIDGE" ] && exit 0

# Check staleness (>60s old = ignore)
TS=$(echo "$BRIDGE" | jq -r '.timestamp // 0' 2>/dev/null)
case "$TS" in ''|null|*[!0-9]*) TS=0 ;; esac
NOW=$(date +%s)
AGE=$(( NOW - TS ))
[ "$AGE" -gt 60 ] && exit 0

REMAINING=$(echo "$BRIDGE" | jq -r '.remaining_percentage // 100' 2>/dev/null)
case "$REMAINING" in ''|null|*[!0-9]*) exit 0 ;; esac

# Determine severity
SEVERITY=""
if [ "$REMAINING" -le 25 ]; then
  SEVERITY="CRITICAL"
elif [ "$REMAINING" -le 35 ]; then
  SEVERITY="WARNING"
fi

[ -z "$SEVERITY" ] && exit 0

# Debounce: track call counter and last severity
COUNTER_FILE="/tmp/claude-ctx-warn-${SESSION_ID}"
COUNTER=0
LAST_SEVERITY=""
if [ -f "$COUNTER_FILE" ]; then
  COUNTER=$(head -1 "$COUNTER_FILE" 2>/dev/null || echo 0)
  LAST_SEVERITY=$(tail -1 "$COUNTER_FILE" 2>/dev/null || echo "")
  case "$COUNTER" in ''|null|*[!0-9]*) COUNTER=0 ;; esac
fi

COUNTER=$(( COUNTER + 1 ))

# Bypass debounce on severity escalation (WARNING -> CRITICAL)
ESCALATED=false
if [ "$SEVERITY" = "CRITICAL" ] && [ "$LAST_SEVERITY" = "WARNING" ]; then
  ESCALATED=true
fi

# Suppress if under debounce threshold (5 calls) and no escalation
if [ "$COUNTER" -lt 5 ] && [ "$ESCALATED" = "false" ] && [ "$LAST_SEVERITY" = "$SEVERITY" ]; then
  printf '%s\n%s\n' "$COUNTER" "$SEVERITY" > "$COUNTER_FILE" 2>/dev/null || true
  exit 0
fi

# Reset counter and write state
printf '%s\n%s\n' "0" "$SEVERITY" > "$COUNTER_FILE" 2>/dev/null || true

# Build message
if [ "$SEVERITY" = "CRITICAL" ]; then
  MESSAGE="CRITICAL: Context window at ${REMAINING}% remaining. Compaction is imminent. Commit current work, save state to HANDOFF.md, and wrap up immediately before context is truncated."
else
  MESSAGE="WARNING: Context window at ${REMAINING}% remaining. Context compaction will fire at 30%. Consider committing current work and saving state to HANDOFF.md soon."
fi

# Output additionalContext JSON to stdout
printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"%s"}}\n' "$MESSAGE"

exit 0
