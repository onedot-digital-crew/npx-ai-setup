#!/bin/bash
# Cross-platform notification hook for Claude Code
# Supports: macOS (osascript), Linux (notify-send), silent fallback

TITLE="Claude Code"
MESSAGE="Claude Code is ready"

case "$(uname -s)" in
  Darwin)
    osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\"" 2>/dev/null || true
    ;;
  Linux)
    if command -v notify-send >/dev/null 2>&1; then
      notify-send "$TITLE" "$MESSAGE" 2>/dev/null || true
    fi
    ;;
  *)
    # Silent fallback for unsupported platforms
    ;;
esac
