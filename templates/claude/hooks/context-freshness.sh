#!/bin/bash
# context-freshness.sh — UserPromptSubmit hook
# Warns when .agents/context/ files may be outdated (package.json or tsconfig changed)
# Silent pass when up-to-date or state file missing (~10ms runtime, no API calls)
#
# Cache note: Warning is injected as stderr output (shown as a system message in Claude's turn),
# NOT by editing CLAUDE.md. This preserves the prompt cache prefix — editing static layers
# mid-session would invalidate the cache for all subsequent turns.

STATE_FILE=".agents/context/.state"
[ ! -f "$STATE_FILE" ] && exit 0

# Read stored hashes
STORED_PKG=""
STORED_TSC=""
while IFS='=' read -r key val; do
  case "$key" in
    PKG_HASH) STORED_PKG="$val" ;;
    TSCONFIG_HASH) STORED_TSC="$val" ;;
  esac
done < "$STATE_FILE"

CHANGED=""

# Compare package.json
if [ -n "$STORED_PKG" ] && [ -f "package.json" ]; then
  CURRENT_PKG=$(cksum package.json 2>/dev/null | cut -d' ' -f1,2)
  [ "$CURRENT_PKG" != "$STORED_PKG" ] && CHANGED="package.json"
fi

# Compare tsconfig.json
if [ -n "$STORED_TSC" ] && [ -f "tsconfig.json" ]; then
  CURRENT_TSC=$(cksum tsconfig.json 2>/dev/null | cut -d' ' -f1,2)
  [ "$CURRENT_TSC" != "$STORED_TSC" ] && CHANGED="${CHANGED:+$CHANGED, }tsconfig.json"
fi

if [ -n "$CHANGED" ]; then
  echo "Warning: Project context may be outdated ($CHANGED changed). Run: npx @onedot/ai-setup --regenerate" >&2
fi

exit 0
