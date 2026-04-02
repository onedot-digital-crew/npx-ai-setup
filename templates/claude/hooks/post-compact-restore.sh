#!/usr/bin/env bash
# post-compact-restore.sh — PostCompact hook with SessionStart(compact) fallback
# Restores a short resume hint from unified session state after compaction.
# Registered for both PostCompact (immediate) and SessionStart/compact (fallback).

# Drain stdin — some hook events pass a payload we don't need here
cat >/dev/null

command -v jq >/dev/null 2>&1 || exit 0

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
STATE_FILE="$PROJECT_ROOT/.claude/session-state.json"

# No state file means nothing to restore — exit silently
[ -f "$STATE_FILE" ] || exit 0

# ── Parse unified session state fields (all optional) ────────────────────────
HAS_ACTIVE=$(jq -r '.has_active_spec // false' "$STATE_FILE" 2>/dev/null)
ACTIVE_SPEC=$(jq -r '.active_spec // ""' "$STATE_FILE" 2>/dev/null)
NEXT_ACTION=$(jq -r '.next_action // ""' "$STATE_FILE" 2>/dev/null)
CURRENT_PHASE=$(jq -r '.phase // .current_phase // ""' "$STATE_FILE" 2>/dev/null)
SOURCE=$(jq -r '.source // ""' "$STATE_FILE" 2>/dev/null)
UPDATED_AT=$(jq -r '.updated_at // ""' "$STATE_FILE" 2>/dev/null)
SPECS=$(jq -r '.active_specs[]?' "$STATE_FILE" 2>/dev/null)

# Nothing active — no restore needed
[ "$HAS_ACTIVE" = "true" ] || exit 0
[ -n "$SPECS" ] || exit 0

# ── Normalize null strings from jq ───────────────────────────────────────────
[ "$ACTIVE_SPEC" = "null" ] && ACTIVE_SPEC=""
[ "$NEXT_ACTION" = "null" ] && NEXT_ACTION=""
[ "$CURRENT_PHASE" = "null" ] && CURRENT_PHASE=""
[ "$SOURCE" = "null" ] && SOURCE=""
[ "$UPDATED_AT" = "null" ] && UPDATED_AT=""

# ── Build restore message ────────────────────────────────────────────────────
MESSAGE="Context restored after compaction.\nActive specs:\n$(printf '%s\n' "$SPECS" | sed 's/^/- /')"
[ -n "$ACTIVE_SPEC" ] && MESSAGE="${MESSAGE}\nPrimary spec: ${ACTIVE_SPEC}"
[ -n "$CURRENT_PHASE" ] && MESSAGE="${MESSAGE}\nCurrent phase: ${CURRENT_PHASE}"
[ -n "$NEXT_ACTION" ] && MESSAGE="${MESSAGE}\nNext action: ${NEXT_ACTION}"
[ -n "$SOURCE" ] && MESSAGE="${MESSAGE}\nSaved via: ${SOURCE}"
[ -n "$UPDATED_AT" ] && MESSAGE="${MESSAGE}\nUpdated at: ${UPDATED_AT}"

# ── Emit additionalContext for Claude to pick up ─────────────────────────────
jq -n --arg msg "$MESSAGE" '{"additionalContext":$msg}'

exit 0
