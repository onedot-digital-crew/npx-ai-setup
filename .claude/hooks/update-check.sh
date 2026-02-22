#!/bin/bash
# UserPromptSubmit hook: update check + circuit breaker reset
# Runs on each user message (~15ms, no blocking calls)

# Auto-reset circuit breaker — user sending a message = they've acknowledged the loop
PROJ_HASH=$(echo "$PWD" | shasum | cut -c1-8)
CB_LOG="/tmp/claude-cb-${PROJ_HASH}.log"
[ -f "$CB_LOG" ] && rm -f "$CB_LOG"

SETUP_JSON=".ai-setup.json"
[ ! -f "$SETUP_JSON" ] && exit 0

INSTALLED=$(jq -r '.version // empty' "$SETUP_JSON" 2>/dev/null)
[ -z "$INSTALLED" ] && exit 0

# Cache per project (24h TTL)
CACHE="/tmp/ai-setup-update-$(echo "$PWD" | cksum | cut -d' ' -f1).txt"

if [ -f "$CACHE" ]; then
  if [ "$(uname)" = "Darwin" ]; then
    AGE=$(( $(date +%s) - $(stat -f %m "$CACHE") ))
  else
    AGE=$(( $(date +%s) - $(stat -c %Y "$CACHE") ))
  fi

  if [ "$AGE" -lt 86400 ]; then
    LATEST=$(cat "$CACHE")
    if [ -n "$LATEST" ] && [ "$LATEST" != "$INSTALLED" ]; then
      echo "ai-setup v${LATEST} available (you have v${INSTALLED}). Run: npx @onedot/ai-setup"
    fi
    exit 0
  fi
fi

# Stale or no cache — background fetch
(npm view @onedot/ai-setup version 2>/dev/null > "$CACHE") &
exit 0
