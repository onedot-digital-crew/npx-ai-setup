#!/bin/bash
# Agent lifecycle metrics logger (dev-tool for this repo only — NOT a template)
# Logs SubagentStart/SubagentStop events to .claude/agent-metrics.log as JSONL
#
# Usage: registered under SubagentStart and SubagentStop hooks
# Payload via stdin: JSON with event context
# Output: appends one JSONL line per event to .claude/agent-metrics.log

LOG_FILE="${CLAUDE_PROJECT_DIR:-.}/.claude/agent-metrics.log"

PAYLOAD=$(cat /dev/stdin 2>/dev/null || echo "{}")
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Extract fields — graceful fallback if jq absent or field missing
if command -v jq >/dev/null 2>&1; then
  AGENT=$(echo "$PAYLOAD" | jq -r '.agent_name // .name // "unknown"' 2>/dev/null)
  EVENT=$(echo "$PAYLOAD" | jq -r '.event // "subagent"' 2>/dev/null)
else
  AGENT="unknown"
  EVENT="subagent"
fi

# Derive event type from script name (agent-metrics.sh called for both start/stop)
# Caller passes EVENT env var to distinguish; fallback to payload
HOOK_EVENT="${HOOK_EVENT:-${EVENT}}"

printf '{"ts":"%s","event":"%s","agent":"%s"}\n' \
  "$TIMESTAMP" "$HOOK_EVENT" "$AGENT" >> "$LOG_FILE" 2>/dev/null || true
