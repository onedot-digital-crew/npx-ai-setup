#!/usr/bin/env bash
# Smoke test for bin/ai-setup.sh
# Checks syntax and key function presence — does NOT execute the script interactively.

set -euo pipefail

SCRIPT="bin/ai-setup.sh"
PASS=0
FAIL=0

pass() { echo "  PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL + 1)); }

echo "=== Smoke test: $SCRIPT ==="

# Step 1: Syntax check
if bash -n "$SCRIPT" 2>&1; then
  pass "bash -n syntax check"
else
  fail "bash -n syntax check"
fi

# Step 2: Key function presence
for fn in build_template_map run_generation select_system; do
  if grep -q "${fn}()" "$SCRIPT"; then
    pass "function ${fn}() exists"
  else
    fail "function ${fn}() missing"
  fi
done

# Summary
echo ""
echo "Results: ${PASS} passed, ${FAIL} failed"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
