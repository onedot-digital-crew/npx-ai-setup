#!/usr/bin/env bash
# subagent-stop.sh — experimental usage logger for SubagentStop events
# Event availability is not guaranteed in public Claude releases.
# Logs all available fields defensively — missing fields are tolerated.

command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
[ -n "$INPUT" ] || exit 0

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
LOG_FILE="$PROJECT_ROOT/.claude/subagent-usage.log"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Parse input defensively — fall back to empty object on malformed JSON
PAYLOAD=$(printf '%s' "$INPUT" | jq -c '.' 2>/dev/null || printf '{}')

# Extract known fields for structured logging (all optional)
AGENT_NAME=$(printf '%s' "$PAYLOAD" | jq -r '.agent_name // "unknown"' 2>/dev/null)
MODEL=$(printf '%s' "$PAYLOAD" | jq -r '.model // "unknown"' 2>/dev/null)
DURATION=$(printf '%s' "$PAYLOAD" | jq -r '.duration_ms // "n/a"' 2>/dev/null)

# Ensure log directory exists
mkdir -p "$PROJECT_ROOT/.claude"

# Append structured log entry: timestamp, agent name, model, duration, full payload
printf '%s\tagent=%s\tmodel=%s\tduration=%s\t%s\n' \
  "$TIMESTAMP" "$AGENT_NAME" "$MODEL" "$DURATION" "$PAYLOAD" >> "$LOG_FILE"

exit 0
