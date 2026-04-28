#!/usr/bin/env bash
# lint-agents.sh — validates YAML frontmatter and required sections in agent files
# Exit 0: only warnings (or clean). Exit 1: at least one error.
#
# Integration: call from CI or as a pre-commit check:
#   bash scripts/lint-agents.sh
#
# To lint a specific directory:
#   AGENT_DIRS="templates/agents" bash scripts/lint-agents.sh

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ERRORS=0
WARNINGS=0

PASS="[PASS]"
FAIL="[FAIL]"
WARN="[WARN]"

_pass() { printf '%s %s\n' "$PASS" "$1"; }
_fail() {
  printf '%s %s\n' "$FAIL" "$1" >&2
  ERRORS=$((ERRORS + 1))
}
_warn() {
  printf '%s %s\n' "$WARN" "$1"
  WARNINGS=$((WARNINGS + 1))
}

# Directories to lint (space-separated, relative to repo root)
DEFAULT_DIRS="templates/agents .claude/agents"
AGENT_DIRS="${AGENT_DIRS:-$DEFAULT_DIRS}"

lint_file() {
  local file="$1"
  local basename
  basename="$(basename "$file")"
  local ok=1

  # Skip README and non-agent files
  case "$basename" in
    README.md | TEMPLATE.md) return 0 ;;
  esac

  # ── 1. Frontmatter present ────────────────────────────────────────────────
  local first_line
  first_line="$(head -1 "$file")"
  if [ "$first_line" != "---" ]; then
    _fail "$file: no YAML frontmatter (file must start with ---)"
    ok=0
  fi

  # ── 2. Required fields ────────────────────────────────────────────────────
  local required_fields="name description tools model"
  for field in $required_fields; do
    if ! grep -qE "^${field}:" "$file"; then
      _fail "$file: missing required field '${field}:'"
      ok=0
    fi
  done

  # ── 3. Required sections ──────────────────────────────────────────────────
  if ! grep -qE "^## When to Use" "$file"; then
    _fail "$file: missing required section '## When to Use'"
    ok=0
  fi

  if ! grep -qE "^## Avoid If" "$file"; then
    _fail "$file: missing required section '## Avoid If'"
    ok=0
  fi

  if ! grep -qE "^## (Behavior|Rules)" "$file"; then
    _fail "$file: missing required section '## Behavior' or '## Rules'"
    ok=0
  fi

  # ── 4. Minimum body length (>= 20 lines after frontmatter) ───────────────
  local total_lines
  total_lines="$(wc -l < "$file")"

  # Find end of frontmatter (second ---)
  local fm_end=0
  local count=0
  while IFS= read -r line; do
    count=$((count + 1))
    if [ "$line" = "---" ] && [ "$count" -gt 1 ]; then
      fm_end=$count
      break
    fi
  done < "$file"

  if [ "$fm_end" -gt 0 ]; then
    local body_lines=$((total_lines - fm_end))
    if [ "$body_lines" -lt 20 ]; then
      _fail "$file: body too short (${body_lines} lines, minimum 20 required)"
      ok=0
    fi
  else
    _warn "$file: could not determine frontmatter end — body length check skipped"
  fi

  # ── 5. Optional field warnings ────────────────────────────────────────────
  if ! grep -qE "^emoji:" "$file"; then
    _warn "$file: missing optional field 'emoji:'"
  fi
  if ! grep -qE "^vibe:" "$file"; then
    _warn "$file: missing optional field 'vibe:'"
  fi

  if [ "$ok" -eq 1 ]; then
    _pass "$file"
  fi
}

# ── Main ──────────────────────────────────────────────────────────────────────
echo "=== Agent Lint ==="
echo ""

FILE_COUNT=0
for dir in $AGENT_DIRS; do
  abs_dir="${REPO_ROOT}/${dir}"
  if [ ! -d "$abs_dir" ]; then
    _warn "Directory not found, skipping: $abs_dir"
    continue
  fi
  for file in "${abs_dir}"/*.md; do
    [ -f "$file" ] || continue
    FILE_COUNT=$((FILE_COUNT + 1))
    lint_file "$file"
  done
done

echo ""
echo "=== Summary ==="
echo "Files checked : $FILE_COUNT"
echo "Errors        : $ERRORS"
echo "Warnings      : $WARNINGS"
echo ""

if [ "$ERRORS" -gt 0 ]; then
  echo "[FAIL] $ERRORS error(s) found — fix before proceeding."
  exit 1
else
  echo "[PASS] All agents pass required checks."
  exit 0
fi
