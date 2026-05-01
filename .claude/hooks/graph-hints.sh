#!/usr/bin/env bash
# graph-hints.sh — merged PreToolUse hook (Spec 657)
# Replaces graph-before-read.sh + graph-context.sh.
#
# Modes:
#   pretool  → Read/Edit/Grep/Glob/Bash hints (default)
#   session  → reserved for SessionStart use; currently a no-op
#
# Output budget: <400 chars stderr or compact additionalContext JSON.
# Performance: <50ms (jq queries cached per session).
# Opt-out: .claude/settings.local.json {"graphBeforeRead": false}
#
# Never blocks. Always exit 0.

# shellcheck disable=SC2016
set -o pipefail

MODE="${1:-pretool}"
[ "$MODE" = "session" ] && exit 0

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
GRAPH_FILE="$PROJECT_DIR/.agents/context/graph.json"
LIQUID_GRAPH_FILE="$PROJECT_DIR/.agents/context/liquid-graph.json"
GRAPHIFY_FILE="$PROJECT_DIR/graphify-out/graph.json"
LOCAL_SETTINGS="$PROJECT_DIR/.claude/settings.local.json"

# --- Opt-out ---------------------------------------------------------------
if [ -f "$LOCAL_SETTINGS" ] && command -v jq > /dev/null 2>&1; then
  opt_out=$(jq -r 'if .graphBeforeRead == false then "false" else "true" end' "$LOCAL_SETTINGS" 2> /dev/null || echo "true")
  [ "$opt_out" = "false" ] && exit 0
fi

INPUT=""
if [ ! -t 0 ]; then
  INPUT=$(cat 2> /dev/null || true)
fi

TOOL_NAME=""
FILE_PATH=""
CMD=""
if [ -n "$INPUT" ] && command -v jq > /dev/null 2>&1; then
  TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2> /dev/null || true)
  FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2> /dev/null || true)
  CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2> /dev/null || true)
fi
TOOL_NAME="${TOOL_NAME:-${CLAUDE_TOOL_NAME:-}}"
FILE_PATH="${FILE_PATH:-${CLAUDE_TOOL_INPUT_FILE_PATH:-}}"
[ -z "$TOOL_NAME" ] && exit 0

# --- Session history (Grep counter) ---------------------------------------
CACHE_DIR="${HOME}/.cache/ai-setup"
SESSION_ID="${CLAUDE_SESSION_ID:-${PPID:-0}}"
HIST_FILE="${CACHE_DIR}/tool-history-${SESSION_ID}.log"
JQ_CACHE="${TMPDIR:-/tmp}/graph-hints-cache-$SESSION_ID"
mkdir -p "$CACHE_DIR" "$JQ_CACHE" 2> /dev/null || true
chmod 700 "$CACHE_DIR" 2> /dev/null || true
find "$CACHE_DIR" -name "tool-history-*.log" -mmin +1440 -delete 2> /dev/null || true

_cache_key() { printf '%s' "$1" | cksum | awk '{print $1}'; }

_cached_jq() {
  local cache_name="$1" data_file="$2" program="$3" rel="$4"
  [ -f "$data_file" ] || return 0
  local cache_file="$JQ_CACHE/$(_cache_key "$cache_name:$rel")"
  if [ -f "$cache_file" ]; then
    cat "$cache_file"
    return 0
  fi
  local out
  out=$(jq -r --arg file "$rel" "$program" "$data_file" 2> /dev/null || true)
  printf '%s\n' "$out" > "$cache_file" 2> /dev/null || true
  printf '%s\n' "$out"
}

# --- Read: large-file warning ---------------------------------------------
if [ "$TOOL_NAME" = "Read" ]; then
  [ -z "$FILE_PATH" ] && exit 0

  if [ -f "$GRAPH_FILE" ] && [ -f "$FILE_PATH" ] && command -v wc > /dev/null 2>&1; then
    line_count=""
    if command -v timeout > /dev/null 2>&1; then
      line_count=$(timeout 0.05 sh -c 'wc -l < "$1"' -- "$FILE_PATH" 2> /dev/null | tr -d ' ' || true)
    else
      line_count=$(wc -l < "$FILE_PATH" 2> /dev/null | tr -d ' ' || true)
    fi
    if [ -n "$line_count" ] && [ "$line_count" -gt 500 ] 2> /dev/null; then
      echo "Datei ${line_count} Zeilen. Zuerst: jq '.stats.top_hubs' .agents/context/graph.json" >&2
    fi
  fi
fi

# --- Read/Edit: graph neighbors (additionalContext) -----------------------
emit_neighbors() {
  case "$TOOL_NAME" in
    Read | Edit | MultiEdit) ;;
    *) return 0 ;;
  esac
  [ -z "$FILE_PATH" ] && return 0

  local rel
  rel=$(
    python3 - "$FILE_PATH" "$PROJECT_DIR" 2> /dev/null << 'PYEOF' || true
import os, sys
try:
    print(os.path.relpath(sys.argv[1], sys.argv[2]))
except Exception:
    print('')
PYEOF
  )
  [ -z "$rel" ] && return 0
  case "$rel" in ../*) return 0 ;; esac

  local kind=""
  case "$rel" in
    *.js | *.jsx | *.mjs | *.cjs | *.ts | *.tsx | *.vue | *.svelte) kind="jsts" ;;
    *.liquid) kind="liquid" ;;
    *) return 0 ;;
  esac

  local result=""
  if [ "$kind" = "jsts" ]; then
    fwd=$(_cached_jq "jsts-fwd" "$GRAPH_FILE" '
      (.edges // []) as $e |
      ($e | map(select(.source==$file and (.kind=="explicit" or .kind==null))) | map(.target) | unique | .[0:5]) as $imp |
      if ($imp|length)==0 then "" else
        "[GRAPH] " + ($file|split("/")|last) + " imports: " + ($imp | map(split("/")|last) | join(", "))
      end' "$rel")
    [ -n "$fwd" ] && result="$fwd"
    case "$TOOL_NAME" in
      Edit | MultiEdit)
        rev=$(_cached_jq "jsts-rev" "$GRAPH_FILE" '
          (.edges // []) as $e |
          ($e | map(select(.target==$file)) | map(.source) | unique | .[0:5]) as $imps |
          if ($imps|length)==0 then "" else
            "[GRAPH] reverse-deps: " + ($imps | map(split("/")|last) | join(", "))
          end' "$rel")
        [ -n "$rev" ] && result="${result:+$result }$rev"
        ;;
    esac
  elif [ "$kind" = "liquid" ]; then
    liq=$(_cached_jq "liquid" "$LIQUID_GRAPH_FILE" '
      (.edges // []) as $e |
      ($e | map(select(.target==$file)) | map(.source) | unique | .[0:5]) as $r |
      if ($r|length)==0 then "" else
        "[LIQUID] " + ($file|split("/")|last) + " renderers: " + ($r | map(split("/")|last) | join(", "))
      end' "$rel")
    [ -n "$liq" ] && result="$liq"
  fi

  if [ -n "$result" ] && [ -f "$GRAPHIFY_FILE" ]; then
    com=$(_cached_jq "gfy" "$GRAPHIFY_FILE" '
      (.communities // []) | map(select((.nodes // []) | index($file))) | .[0] as $c |
      if $c==null then "" else
        "[GRAPHIFY] community: " + (($c.id // "") | tostring) +
        (if ($c.label // "") != "" then " " + $c.label else "" end)
      end' "$rel")
    [ -n "$com" ] && result="$result $com"
  fi

  if [ -n "$result" ] && command -v jq > /dev/null 2>&1; then
    jq -n --arg ctx "$result" '{"additionalContext": $ctx}'
  fi
}
emit_neighbors

# --- Grep/Glob: 4× consecutive warning ------------------------------------
if [ "$TOOL_NAME" = "Grep" ] || [ "$TOOL_NAME" = "Glob" ]; then
  echo "Grep" >> "$HIST_FILE" 2> /dev/null || true
  consec=0
  if [ -f "$HIST_FILE" ]; then
    while IFS= read -r line; do
      case "$line" in
        Grep) consec=$((consec + 1)) ;;
        *) consec=0 ;;
      esac
    done < "$HIST_FILE"
  fi
  if [ "$consec" -ge 4 ]; then
    echo "${consec}x Grep. Graph billiger: jq '.stats.top_hubs' .agents/context/graph.json" >&2
  fi
fi

# --- Bash with graph query resets the counter -----------------------------
if [ "$TOOL_NAME" = "Bash" ] && [ -n "$CMD" ]; then
  case "$CMD" in
    *graph.json* | *jq*graph*)
      echo "GraphQuery" >> "$HIST_FILE" 2> /dev/null || true
      ;;
  esac
fi

exit 0
