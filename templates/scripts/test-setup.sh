#!/usr/bin/env bash
# test-setup.sh — Run ai-setup from local dev repo and validate with doctor
# Usage: bash .claude/scripts/test-setup.sh [dev-repo-path]
# Default dev repo: ~/Sites/npx-ai-setup
set -euo pipefail

DEV_REPO="${1:-$HOME/Sites/npx-ai-setup}"
SETUP_SCRIPT="$DEV_REPO/bin/ai-setup.sh"

if [ ! -f "$SETUP_SCRIPT" ]; then
  echo "FAIL: ai-setup.sh not found at $SETUP_SCRIPT"
  echo "Usage: bash .claude/scripts/test-setup.sh [/path/to/npx-ai-setup]"
  exit 1
fi

echo "=== Phase 1: Run ai-setup from $DEV_REPO ==="
echo ""
bash "$SETUP_SCRIPT"
setup_rc=$?

echo ""
echo "=== Phase 2: Doctor validation ==="
echo ""

if [ -f ".claude/scripts/doctor.sh" ]; then
  bash .claude/scripts/doctor.sh
  doctor_rc=$?
else
  echo "FAIL: doctor.sh not found — setup may have failed"
  doctor_rc=1
fi

echo ""
echo "=== Results ==="
if [ "$setup_rc" -eq 0 ] && [ "$doctor_rc" -eq 0 ]; then
  echo "ALL PASSED — setup + doctor OK"
else
  [ "$setup_rc" -ne 0 ] && echo "FAIL: setup exited with code $setup_rc"
  [ "$doctor_rc" -ne 0 ] && echo "FAIL: doctor reported failures"
  exit 1
fi
