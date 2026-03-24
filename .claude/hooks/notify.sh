#!/bin/bash
# Cross-platform notification hook for Claude Code
# Supports: macOS (osascript), Linux (notify-send), silent fallback
# Claude Code passes notification data via stdin as JSON:
# {"message": "Task complete", "title": "Claude Code", "level": "info"}

# Read stdin payload
PAYLOAD=$(cat /dev/stdin 2>/dev/null || echo "{}")

MSG=""
TTL=""
if command -v jq >/dev/null 2>&1; then
  MSG=$(echo "$PAYLOAD" | jq -r '.message // empty' 2>/dev/null)
  TTL=$(echo "$PAYLOAD" | jq -r '.title // empty' 2>/dev/null)
fi

TITLE="${TTL:-Claude Code}"
MESSAGE="${MSG:-Claude Code is ready}"

case "$(uname -s)" in
  Darwin)
    osascript -e "display notification \"$(printf '%s' "$MESSAGE" | sed 's/["\]/\\&/g')\" with title \"$(printf '%s' "$TITLE" | sed 's/["\]/\\&/g')\"" 2>/dev/null || true
    ;;
  Linux)
    if command -v notify-send >/dev/null 2>&1; then
      notify-send -- "$TITLE" "$MESSAGE" 2>/dev/null || true
    fi
    ;;
  *)
    # Silent fallback for unsupported platforms
    ;;
esac
