#!/bin/bash
# Claude Code statusline script
# Receives JSON via stdin, outputs two lines to stdout
# Usage: echo '{"model":{"display_name":"Sonnet"},...}' | ~/.claude/statusline.sh

command -v jq >/dev/null 2>&1 || { echo "Claude"; echo "jq required"; exit 0; }

INPUT=$(cat)

MODEL=$(echo "$INPUT" | jq -r '.model.display_name // "Claude"')
WORK_DIR=$(echo "$INPUT" | jq -r '.workspace.current_dir // .cwd // "."')
PROJECT_DIR=$(echo "$INPUT" | jq -r '.workspace.project_dir // .workspace.current_dir // .cwd // "."')
DIR_NAME=$(basename "$WORK_DIR")
PCT=$(echo "$INPUT" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
COST=$(echo "$INPUT" | jq -r '.cost.total_cost_usd // 0')
DURATION=$(echo "$INPUT" | jq -r '.cost.total_duration_ms // 0')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // ""' | tr -cd 'a-zA-Z0-9_-')
REMAINING_PCT=$(echo "$INPUT" | jq -r '100 - (.context_window.used_percentage // 0)' | awk '{printf "%d", ($1+0.5)}')

# Ensure numeric values are valid (fallback to 0 on null/empty)
case "$PCT" in ''|null|*[!0-9]*) PCT=0 ;; esac
case "$REMAINING_PCT" in ''|null|*[!0-9]*) REMAINING_PCT=100 ;; esac
case "$COST" in ''|null) COST=0 ;; esac
case "$DURATION" in ''|null|*[!0-9]*) DURATION=0 ;; esac

# Cache expensive git status calls (stable cache file per project path).
BRANCH=""
STAGED=0
MODIFIED=0
UPDATE_BADGE=""
CACHE_ROOT="/tmp/claude-statusline-cache"
mkdir -p "$CACHE_ROOT" 2>/dev/null || true
DIR_KEY=$(printf '%s' "$PROJECT_DIR" | cksum | awk '{print $1}')
CACHE_FILE="$CACHE_ROOT/git-${DIR_KEY}.txt"
CACHE_MAX_AGE=5

cache_is_stale() {
  [ ! -f "$CACHE_FILE" ] && return 0
  local now mtime
  now=$(date +%s)
  mtime=$(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)
  [ $((now - mtime)) -gt "$CACHE_MAX_AGE" ]
}

if cache_is_stale; then
  if git -C "$WORK_DIR" rev-parse --git-dir >/dev/null 2>&1; then
    BRANCH=$(git -C "$WORK_DIR" branch --show-current 2>/dev/null || echo "")
    STAGED=$(git -C "$WORK_DIR" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    MODIFIED=$(git -C "$WORK_DIR" diff --numstat 2>/dev/null | wc -l | tr -d ' ')
    printf '%s|%s|%s\n' "$BRANCH" "${STAGED:-0}" "${MODIFIED:-0}" > "$CACHE_FILE" 2>/dev/null || true
  else
    printf '||\n' > "$CACHE_FILE" 2>/dev/null || true
  fi
fi

if [ -f "$CACHE_FILE" ]; then
  IFS='|' read -r BRANCH STAGED MODIFIED < "$CACHE_FILE"
fi

case "$STAGED" in ''|null|*[!0-9]*) STAGED=0 ;; esac
case "$MODIFIED" in ''|null|*[!0-9]*) MODIFIED=0 ;; esac

# ai-setup update badge (reads cached update-check result; no network call here).
SETUP_META="$PROJECT_DIR/.ai-setup.json"
if [ -f "$SETUP_META" ]; then
  INSTALLED_AI_SETUP=$(jq -r '.version // empty' "$SETUP_META" 2>/dev/null | sed 's/^v//' | tr -d '[:space:]')
  if [ -n "$INSTALLED_AI_SETUP" ]; then
    UPDATE_CACHE="/tmp/ai-setup-update-$(printf '%s' "$PROJECT_DIR" | cksum | awk '{print $1}').txt"
    if [ -f "$UPDATE_CACHE" ]; then
      LATEST_AI_SETUP=$(tr -d '[:space:]' < "$UPDATE_CACHE" | sed 's/^v//')
      if [ -n "$LATEST_AI_SETUP" ] && [ "$LATEST_AI_SETUP" != "$INSTALLED_AI_SETUP" ]; then
        UPDATE_BADGE=" | ai-setup v${INSTALLED_AI_SETUP} -> v${LATEST_AI_SETUP}"
      fi
    fi
  fi
fi

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
[ -n "$BRANCH" ] && BRANCH_PART=" (${BRANCH} +${STAGED} ~${MODIFIED})"
echo -e "${MODEL} · ${DIR_NAME}${BRANCH_PART}${UPDATE_BADGE}"

# Line 2: context bar + cost + duration
MINS=$(( DURATION / 60000 ))
printf "${COLOR}ctx: ${PCT}%%${RESET}  \$%.4f  %dm\n" "$COST" "$MINS"
