#!/bin/bash
# Check for @onedot/ai-setup updates (background, cached, <50ms)

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
