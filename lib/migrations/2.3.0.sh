#!/bin/bash
# Migration: v2.2.x → v2.3.0
# Fix: sandbox.enabled blocks .git/index.lock writes on macOS, breaking git add/commit.
# Disables sandbox in existing project settings (no allowedWritePaths key in schema).
# (Note: tool-redirect.sh — formerly part of this migration — has since been removed.)
# Idempotent: safe to run multiple times.

echo "  [2.3.0] Applying migration..."

settings_file=".claude/settings.json"

# ------------------------------------------------------------------
# 1. Disable sandbox in existing settings.json
# ------------------------------------------------------------------
if [ -f "$settings_file" ] && command -v jq > /dev/null 2>&1; then
  current=$(jq -r '.sandbox.enabled // empty' "$settings_file" 2> /dev/null)
  if [ "$current" = "true" ]; then
    tmp=$(mktemp)
    jq '.sandbox.enabled = false' "$settings_file" > "$tmp" && mv "$tmp" "$settings_file"
    echo "  [2.3.0] Disabled sandbox in $settings_file (was breaking git add/commit on macOS)."
  else
    echo "  [2.3.0] Sandbox already off or not configured — skipping."
  fi
elif [ -f "$settings_file" ]; then
  echo "  [2.3.0] WARN: jq not available — manually set sandbox.enabled to false in $settings_file."
fi

# ------------------------------------------------------------------
# 2. tool-redirect.sh removed in later release — skipped here.
#    (Was: redirect bare grep/find/cat/git to native tools.)
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# 3. Update commit skill (better permission-error handling)
# ------------------------------------------------------------------
_update_file "templates/skills/commit/SKILL.template.md" ".claude/skills/commit/SKILL.md"

echo "  [2.3.0] Done."
