#!/usr/bin/env bash
# spec-deps-check.sh — Validate spec dependency graph (depends_on frontmatter).
# Usage:
#   bash .claude/scripts/spec-deps-check.sh                 # check all specs
#   bash .claude/scripts/spec-deps-check.sh NNN             # check one spec — exit 1 if blocked
#   bash .claude/scripts/spec-deps-check.sh --json          # JSON output for tools
# Exit codes: 0 ok, 1 blocked or cycle detected, 2 usage error.
# Bash 3.2 compatible (no associative arrays).
set -euo pipefail

SPECS_DIR="specs"
MODE="all"
TARGET=""
JSON=0

for arg in "$@"; do
  case "$arg" in
    --json) JSON=1 ;;
    [0-9]*)
      TARGET="$arg"
      MODE="single"
      ;;
    -h | --help)
      sed -n '2,8p' "$0"
      exit 0
      ;;
    *)
      echo "unknown arg: $arg" >&2
      exit 2
      ;;
  esac
done

[ -d "$SPECS_DIR" ] || {
  echo "no specs/ dir" >&2
  exit 2
}

# Parallel arrays: IDS[i], STATUS[i], DEPS[i] (CSV).
IDS=()
STATUS=()
DEPS=()

# Lookup helpers (linear scan — N is small for spec dir).
status_of() {
  local needle="$1" i
  for i in "${!IDS[@]}"; do
    [ "${IDS[$i]}" = "$needle" ] && {
      echo "${STATUS[$i]}"
      return 0
    }
  done
  echo "missing"
}
deps_of() {
  local needle="$1" i
  for i in "${!IDS[@]}"; do
    [ "${IDS[$i]}" = "$needle" ] && {
      echo "${DEPS[$i]}"
      return 0
    }
  done
  echo ""
}

parse_spec() {
  local file="$1"
  local id="" status="draft" deps=""
  case "$file" in
    */completed/*) status="completed" ;;
  esac
  while IFS= read -r line; do
    case "$line" in
      "> **Spec ID**:"*)
        id="$(printf '%s\n' "$line" | sed -n 's/^> \*\*Spec ID\*\*: \([^|]*\).*/\1/p' | tr -d ' ')"
        local s
        s="$(printf '%s\n' "$line" | sed -n 's/.*\*\*Status\*\*: \([^|]*\).*/\1/p' | tr -d ' ')"
        [ -n "$s" ] && status="$s"
        ;;
      "<!-- depends_on:"*)
        deps="$(printf '%s\n' "$line" | sed -n 's/.*depends_on: *\[\([^]]*\)\].*/\1/p' | tr -d ' ')"
        ;;
    esac
  done < "$file"
  if [ -z "$id" ]; then
    local base
    base="$(basename "$file" .md)"
    id="${base%%-*}"
  fi
  echo "${id}|${status}|${deps}"
}

while IFS= read -r f; do
  [ -n "$f" ] || continue
  case "$(basename "$f")" in README.md | TEMPLATE.md | template.md) continue ;; esac
  IFS='|' read -r id status deps <<< "$(parse_spec "$f")"
  [ -n "$id" ] || continue
  case "$id" in *[!0-9]*) continue ;; esac
  IDS+=("$id")
  STATUS+=("$status")
  DEPS+=("$deps")
done < <(find "$SPECS_DIR" -maxdepth 2 -name "*.md" -type f 2> /dev/null | sort)

# Cycle detection (DFS, visited list as space-delimited string).
VISITED=""
STACK=""
CYCLE=""

in_list() {
  case " $1 " in *" $2 "*) return 0 ;; esac
  return 1
}

dfs() {
  local node="$1"
  in_list "$VISITED" "$node" && return 0
  STACK="$STACK $node"
  local d
  d="$(deps_of "$node")"
  local IFS_save="$IFS"
  IFS=','
  for dep in $d; do
    [ -n "$dep" ] || continue
    if in_list "$STACK" "$dep"; then
      CYCLE="${node} -> ${dep}"
      IFS="$IFS_save"
      return 1
    fi
    dfs "$dep" || {
      IFS="$IFS_save"
      return 1
    }
  done
  IFS="$IFS_save"
  STACK="${STACK% $node}"
  VISITED="$VISITED $node"
}

for id in "${IDS[@]}"; do
  dfs "$id" || break
done

blocked_by() {
  local id="$1"
  local d
  d="$(deps_of "$id")"
  local out=""
  local IFS_save="$IFS"
  IFS=','
  for dep in $d; do
    [ -n "$dep" ] || continue
    if [ "$(status_of "$dep")" != "completed" ]; then
      out="${out}${out:+,}${dep}"
    fi
  done
  IFS="$IFS_save"
  echo "$out"
}

emit_json_record() {
  local id="$1" status="$2" blockers="$3"
  local arr="[]"
  if [ -n "$blockers" ]; then
    arr="[$(echo "$blockers" | sed 's/,/, /g; s/[0-9][0-9]*/"&"/g')]"
  fi
  printf '  {"spec":"%s","status":"%s","blocked_by":%s}' "$id" "$status" "$arr"
}

if [ -n "$CYCLE" ]; then
  if [ "$JSON" = "1" ]; then
    printf '{"error":"cycle","cycle":"%s"}\n' "$CYCLE"
  else
    echo "❌ dependency cycle: $CYCLE" >&2
  fi
  exit 1
fi

if [ "$MODE" = "single" ]; then
  status="$(status_of "$TARGET")"
  if [ "$status" = "missing" ]; then
    echo "spec $TARGET not found" >&2
    exit 2
  fi
  blockers="$(blocked_by "$TARGET")"
  if [ "$JSON" = "1" ]; then
    echo "{"
    emit_json_record "$TARGET" "$status" "$blockers"
    echo
    echo "}"
  fi
  if [ -n "$blockers" ]; then
    blocker_status=""
    for b in $(echo "$blockers" | tr ',' ' '); do
      blocker_status="${blocker_status}${blocker_status:+, }${b}($(status_of "$b"))"
    done
    if [ "$JSON" != "1" ]; then
      echo "Spec $TARGET depends on $blocker_status — finish blockers first" >&2
    fi
    exit 1
  fi
  [ "$JSON" = "1" ] || echo "✓ spec $TARGET ready ($status)"
  exit 0
fi

# All-mode listing.
sorted_ids="$(printf '%s\n' "${IDS[@]}" | sort -n)"
if [ "$JSON" = "1" ]; then
  echo "["
  first=1
  for id in $sorted_ids; do
    [ "$first" = "1" ] || echo ","
    first=0
    emit_json_record "$id" "$(status_of "$id")" "$(blocked_by "$id")"
  done
  echo
  echo "]"
else
  printf '%-6s %-12s %s\n' "spec" "status" "blocked_by"
  for id in $sorted_ids; do
    blockers="$(blocked_by "$id")"
    printf '%-6s %-12s %s\n' "$id" "$(status_of "$id")" "${blockers:--}"
  done
fi

exit 0
