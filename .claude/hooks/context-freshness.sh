#!/bin/bash
# context-freshness.sh — UserPromptSubmit hook
# Warns when .agents/context/ files may be outdated (package.json or tsconfig changed)
# Silent pass when up-to-date or state file missing (~10ms runtime, no API calls)
#
# Cache note: Warning is injected as stderr output (shown as a system message in Claude's turn),
# NOT by editing CLAUDE.md. This preserves the prompt cache prefix — editing static layers
# mid-session would invalidate the cache for all subsequent turns.

STATE_FILE=".agents/context/.state"
REPOMIX_HASH_FILE=".agents/context/.repomix-hash"
[ ! -f "$STATE_FILE" ] && exit 0

# Age check — warn if last refresh >7 days ago
STATE_AGE_DAYS=$((($(date +%s) - $(stat -f %m "$STATE_FILE" 2> /dev/null || stat -c %Y "$STATE_FILE" 2> /dev/null || echo "0")) / 86400))
AGE_WARNING=""
[ "$STATE_AGE_DAYS" -gt 7 ] 2> /dev/null && AGE_WARNING="context is ${STATE_AGE_DAYS} days old"

# Read stored hashes
STORED_PKG=""
STORED_TSC=""
STORED_GIT=""
while IFS='=' read -r key val; do
  case "$key" in
    PKG_HASH) STORED_PKG="$val" ;;
    TSCONFIG_HASH) STORED_TSC="$val" ;;
    GIT_HASH) STORED_GIT="$val" ;;
  esac
done < "$STATE_FILE"

CHANGED=""

# Compare git commit count since last refresh (warn only at 5+ commits)
# Skips gracefully in shallow clones where STORED_GIT may not exist in local history
if [ -n "$STORED_GIT" ] && git cat-file -e "${STORED_GIT}^{commit}" 2> /dev/null; then
  COMMIT_COUNT=$(git rev-list --count "${STORED_GIT}..HEAD" 2> /dev/null || echo "0")
  [ "$COMMIT_COUNT" -ge 5 ] 2> /dev/null && CHANGED="${COMMIT_COUNT} commits since last context refresh"
fi

# Compare package.json
if [ -n "$STORED_PKG" ] && [ -f "package.json" ]; then
  CURRENT_PKG=$(cksum package.json 2> /dev/null | cut -d' ' -f1,2)
  [ "$CURRENT_PKG" != "$STORED_PKG" ] && CHANGED="${CHANGED:+$CHANGED, }package.json"
fi

# Compare tsconfig.json
if [ -n "$STORED_TSC" ] && [ -f "tsconfig.json" ]; then
  CURRENT_TSC=$(cksum tsconfig.json 2> /dev/null | cut -d' ' -f1,2)
  [ "$CURRENT_TSC" != "$STORED_TSC" ] && CHANGED="${CHANGED:+$CHANGED, }tsconfig.json"
fi

# Check graph.json staleness (older than last git commit)
GRAPH_WARNING=""
GRAPH_FILE=".agents/context/graph.json"
if [ -f "$GRAPH_FILE" ]; then
  GRAPH_MTIME=$(stat -f %m "$GRAPH_FILE" 2> /dev/null || stat -c %Y "$GRAPH_FILE" 2> /dev/null || echo "0")
  LAST_COMMIT_TIME=$(git log -1 --format=%ct 2> /dev/null || echo "0")
  if [ "$LAST_COMMIT_TIME" -gt "$GRAPH_MTIME" ] 2> /dev/null; then
    GRAPH_WARNING="graph.json predates last commit"
  fi
fi

REASON="$CHANGED"
[ -n "$REASON" ] && [ -n "$AGE_WARNING" ] && REASON="$REASON, $AGE_WARNING" || REASON="${REASON:-$AGE_WARNING}"
[ -n "$REASON" ] && [ -n "$GRAPH_WARNING" ] && REASON="$REASON, $GRAPH_WARNING" || REASON="${REASON:-$GRAPH_WARNING}"
if [ -n "$REASON" ]; then
  echo "[CONTEXT STALE] .agents/context/ may be outdated ($REASON). Run /analyze to regenerate." >&2
fi

# repomix structural drift: if hash file exists, warn when source changed significantly
# Hash is written by analyze-fast.sh after a successful repomix run (opt-in only)
if [ -f "$REPOMIX_HASH_FILE" ] && command -v repomix > /dev/null 2>&1; then
  stored_repomix_hash=$(cat "$REPOMIX_HASH_FILE" 2> /dev/null || true)
  # Hash format must be "<timestamp>:<file_count>" — both numeric. Reject anything else (corrupt/malformed file).
  case "$stored_repomix_hash" in
    *:*)
      stored_file_count="${stored_repomix_hash#*:}"
      ;;
    *)
      stored_file_count=""
      ;;
  esac
  # Numeric guard: must be positive integer, otherwise skip drift check
  case "$stored_file_count" in
    "" | *[!0-9]*) stored_file_count="" ;;
  esac
  if [ -n "$stored_file_count" ] && [ "$stored_file_count" -gt 0 ]; then
    current_file_count=$(git ls-files 2> /dev/null | grep -cE '\.(ts|tsx|js|jsx|vue|php|sh|py)$' || echo "0")
    delta=$((current_file_count - stored_file_count))
    [ "$delta" -lt 0 ] && delta=$((-delta))
    # Warn only if file count changed by >10% (structural drift, not just edits)
    threshold=$((stored_file_count / 10))
    [ "$threshold" -lt 3 ] && threshold=3
    if [ "$delta" -ge "$threshold" ]; then
      echo "[CONTEXT STALE] Source file count changed by ${delta} files since last repomix snapshot. Run /analyze to refresh." >&2
    fi
  fi
fi

# Hint: graph.json missing entirely (JS/TS project without graph)
# Guard: only hint for JS/TS apps (src/, app/, or pages/ directory present)
# Bash CLI repos that happen to have a package.json for npm distribution don't benefit from graph.json
if [ ! -f "$GRAPH_FILE" ] && [ -f "package.json" ] && { [ -d "src" ] || [ -d "app" ] || [ -d "pages" ]; }; then
  echo "[HINT] No graph.json found. Run /analyze to build the dependency graph for faster agent navigation." >&2
fi

exit 0
