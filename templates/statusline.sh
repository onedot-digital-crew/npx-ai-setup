#!/bin/bash
# Claude Code statusline script
# Receives JSON via stdin, outputs two lines to stdout
# Usage: echo '{"model":{"display_name":"Sonnet"},...}' | ~/.claude/statusline.sh

command -v jq >/dev/null 2>&1 || { echo "Claude"; echo "jq required"; exit 0; }

INPUT=$(cat)

MODEL=$(echo "$INPUT" | jq -r '.model.display_name // "Claude"')
DIR=$(basename "$PWD")
BRANCH=$(git branch --show-current 2>/dev/null || echo "")
PCT=$(echo "$INPUT" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
COST=$(echo "$INPUT" | jq -r '.cost.total_cost_usd // 0')
DURATION=$(echo "$INPUT" | jq -r '.cost.total_duration_ms // 0')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // ""')
REMAINING_PCT=$(echo "$INPUT" | jq -r '100 - (.context_window.used_percentage // 0)' | cut -d. -f1)

# Ensure numeric values are valid (fallback to 0 on null/empty)
case "$PCT" in ''|null|*[!0-9]*) PCT=0 ;; esac
case "$REMAINING_PCT" in ''|null|*[!0-9]*) REMAINING_PCT=100 ;; esac
case "$COST" in ''|null) COST=0 ;; esac
case "$DURATION" in ''|null|*[!0-9]*) DURATION=0 ;; esac

# Write bridge file for context-monitor hook
if [ -n "$SESSION_ID" ]; then
  EPOCH=$(date +%s)
  printf '{"session_id":"%s","remaining_percentage":%s,"used_pct":%s,"timestamp":%s}\n' \
    "$SESSION_ID" "$REMAINING_PCT" "$PCT" "$EPOCH" \
    > "/tmp/claude-ctx-${SESSION_ID}.json" 2>/dev/null || true
fi

# Color coding for context bar
if [ "$PCT" -ge 80 ]; then
  COLOR="\033[31m"   # red
elif [ "$PCT" -ge 50 ]; then
  COLOR="\033[33m"   # yellow
else
  COLOR="\033[32m"   # green
fi
RESET="\033[0m"

# Line 1: model + dir + branch
BRANCH_PART=""
[ -n "$BRANCH" ] && BRANCH_PART=" ($BRANCH)"
echo -e "${MODEL} · ${DIR}${BRANCH_PART}"

# Line 2: context bar + cost + duration
MINS=$(( DURATION / 60000 ))
printf "${COLOR}ctx: ${PCT}%%${RESET}  \$%.4f  %dm\n" "$COST" "$MINS"
