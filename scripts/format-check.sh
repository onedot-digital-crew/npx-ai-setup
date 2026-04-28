#!/usr/bin/env bash
# format-check.sh — bash format + lint guard
# Exit 0: clean. Exit 1: format drift or shellcheck error.
#
# Usage:
#   bash scripts/format-check.sh           # check only (CI/pre-commit)
#   bash scripts/format-check.sh --fix     # rewrite files in place
#
# Style is configured via .editorconfig (shfmt reads it):
#   - 2-space indent
#   - switch_case_indent
#   - space_redirects

set -o pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

MODE="check"
if [ "${1:-}" = "--fix" ]; then
  MODE="fix"
fi

# Require shfmt
if ! command -v shfmt > /dev/null 2>&1; then
  echo "[FAIL] shfmt not installed. Install: brew install shfmt" >&2
  exit 1
fi

# Require shellcheck
if ! command -v shellcheck > /dev/null 2>&1; then
  echo "[FAIL] shellcheck not installed. Install: brew install shellcheck" >&2
  exit 1
fi

# Collect bash files (skip vendored/build dirs)
# Bash 3.2 compatible — no mapfile
SH_FILES=()
while IFS= read -r f; do
  SH_FILES+=("$f")
done < <(
  find . -type f \( -name '*.sh' -o -name '*.bash' \) \
    -not -path './node_modules/*' \
    -not -path './.git/*' \
    -not -path './dist/*' \
    -not -path './.output/*' \
    -not -path './tests/fixtures/*' |
    sort
)

if [ "${#SH_FILES[@]}" -eq 0 ]; then
  echo "[PASS] no shell files found"
  exit 0
fi

echo "=== Format Check (shfmt) ==="
echo "Files: ${#SH_FILES[@]} | Mode: $MODE"
echo ""

ERRORS=0

if [ "$MODE" = "fix" ]; then
  shfmt -w "${SH_FILES[@]}"
  echo "[OK] shfmt rewrote files in place"
else
  if ! shfmt -d "${SH_FILES[@]}"; then
    echo "" >&2
    echo "[FAIL] format drift detected. Fix with: bash scripts/format-check.sh --fix" >&2
    ERRORS=$((ERRORS + 1))
  else
    echo "[PASS] shfmt clean"
  fi
fi

echo ""
echo "=== Lint (shellcheck) ==="

# Severity: errors only (warnings/info advisory, kept off CI gate)
if ! shellcheck -S error -x "${SH_FILES[@]}"; then
  echo "" >&2
  echo "[FAIL] shellcheck errors above" >&2
  ERRORS=$((ERRORS + 1))
else
  echo "[PASS] shellcheck clean (severity=error)"
fi

echo ""
echo "=== Markdown / JSON / YAML (prettier) ==="

PRETTIER="./node_modules/.bin/prettier"
if [ ! -x "$PRETTIER" ]; then
  echo "[WARN] prettier not installed locally — run: npm install" >&2
  echo "Skipping prose format check."
else
  PRETTIER_GLOB=("**/*.md" "**/*.json" "**/*.yml")
  if [ "$MODE" = "fix" ]; then
    "$PRETTIER" --write "${PRETTIER_GLOB[@]}" > /dev/null 2>&1 || true
    echo "[OK] prettier rewrote files in place"
  else
    PRETTIER_OUT="$(mktemp)"
    if "$PRETTIER" --check "${PRETTIER_GLOB[@]}" > "$PRETTIER_OUT" 2>&1; then
      echo "[PASS] prettier clean"
    else
      tail -20 "$PRETTIER_OUT" >&2
      echo "" >&2
      echo "[FAIL] prettier drift. Fix with: bash scripts/format-check.sh --fix" >&2
      ERRORS=$((ERRORS + 1))
    fi
    rm -f "$PRETTIER_OUT"
  fi
fi

echo ""
if [ "$ERRORS" -gt 0 ]; then
  exit 1
fi
echo "[PASS] format + lint clean"
exit 0
