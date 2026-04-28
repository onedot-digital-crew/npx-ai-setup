#!/usr/bin/env bash
# debug-prep.sh — gather diagnostic context before Claude analyzes a bug
# Exits 0 with context summary; exits 1 on missing prerequisites
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/prep-lib.sh"

git_guard

echo "DEBUG_PREP_START $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo ""

# ---------------------------------------------------------------------------
# Recent commits (potential regression source)
# ---------------------------------------------------------------------------
echo "=== RECENT COMMITS (last 10) ==="
rtk_or_raw git log --oneline -10
echo ""

# ---------------------------------------------------------------------------
# Uncommitted changes (may contain partial fix attempts)
# ---------------------------------------------------------------------------
DIFF_STAT=$(git diff --stat 2> /dev/null || true)
STAGED_STAT=$(git diff --cached --stat 2> /dev/null || true)

if [[ -n "$DIFF_STAT" || -n "$STAGED_STAT" ]]; then
  echo "=== UNCOMMITTED CHANGES ==="
  [[ -n "$STAGED_STAT" ]] && echo "Staged:" && echo "$STAGED_STAT"
  [[ -n "$DIFF_STAT" ]] && echo "Unstaged:" && echo "$DIFF_STAT"
  echo ""
fi

# ---------------------------------------------------------------------------
# Test failures (if test framework detected)
# ---------------------------------------------------------------------------
if [[ -f "package.json" ]] && has node; then
  TEST_CMD=$(node -e "
    try {
      const s = require('./package.json').scripts || {};
      const p = ['test:unit','test:ci','test','vitest','jest'];
      for (const k of p) if (s[k]) { console.log(k); break; }
    } catch(e) {}
  " 2> /dev/null || true)

  if [[ -n "$TEST_CMD" ]]; then
    echo "=== TEST RESULTS ==="
    set +e
    if has rtk; then
      TEST_OUT=$(rtk err npm run "$TEST_CMD" 2>&1 | tail -40)
    else
      TEST_OUT=$(npm run "$TEST_CMD" 2>&1 | tail -40)
    fi
    TEST_EXIT=$?
    set -e
    if [[ $TEST_EXIT -eq 0 ]]; then
      echo "ALL_TESTS_PASSED"
    else
      echo "$TEST_OUT" | grep -E '(FAIL|Error|error|✗|×|expect|assert|timeout)' | head -20
      echo ""
      echo "Exit code: $TEST_EXIT"
    fi
    echo ""
  fi
elif [[ -f "go.mod" ]] && has go; then
  echo "=== TEST RESULTS ==="
  set +e
  TEST_OUT=$(go test ./... 2>&1 | tail -30)
  TEST_EXIT=$?
  set -e
  if [[ $TEST_EXIT -eq 0 ]]; then
    echo "ALL_TESTS_PASSED"
  else
    echo "$TEST_OUT" | grep -E '(FAIL|Error|panic)' | head -20
    echo ""
    echo "Exit code: $TEST_EXIT"
  fi
  echo ""
fi

# ---------------------------------------------------------------------------
# Build check (quick, non-blocking)
# ---------------------------------------------------------------------------
if [[ -f "$SCRIPT_DIR/build-prep.sh" ]]; then
  echo "=== BUILD STATUS ==="
  set +e
  BUILD_RESULT=$(bash "$SCRIPT_DIR/build-prep.sh" 2>&1 | grep -E '(BUILD_PASSED|BUILD ERRORS|Exit code)' | head -5)
  set -e
  if [[ -n "$BUILD_RESULT" ]]; then
    echo "$BUILD_RESULT"
  else
    echo "BUILD_SKIPPED (no output)"
  fi
  echo ""
fi

# ---------------------------------------------------------------------------
# Error logs (common locations)
# ---------------------------------------------------------------------------
for logfile in .nuxt/logs/error.log .next/error.log logs/error.log tmp/debug.log; do
  if [[ -f "$logfile" ]]; then
    echo "=== ERROR LOG: $logfile (last 20 lines) ==="
    tail -20 "$logfile"
    echo ""
  fi
done

# ---------------------------------------------------------------------------
# Prior debug investigations (specs/debug-*.md)
# ---------------------------------------------------------------------------
PRIOR=$(ls specs/debug-*.md 2> /dev/null || true)
if [[ -n "$PRIOR" ]]; then
  echo "=== PRIOR INVESTIGATIONS ==="
  echo "$PRIOR"
  echo ""
fi

echo "DEBUG_PREP_COMPLETE"
