#!/usr/bin/env bash
# ci-prep.sh — check CI status for the current branch
# Green path: "ALL_CHECKS_PASSED" → 0 tokens for Claude
# Outputs failures only when checks are pending/failing.
#
# Usage: bash .claude/scripts/ci-prep.sh
# Exit 0: green path (all passed) or no PR/CI found
# Exit 2: failures found (Claude will analyze)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/prep-lib.sh"

git_guard

# Require gh CLI
if ! has gh; then
  echo "NO_GH_CLI: install gh CLI to check CI status" >&2
  exit 1
fi

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")

# No PR → check recent runs directly
PR_NUM=$(gh pr view --json number --jq '.number' 2>/dev/null || echo "")

if [ -z "$PR_NUM" ]; then
  # No PR open — check most recent workflow run on this branch
  RUNS=$(gh run list --branch "$BRANCH" --limit 1 --json status,conclusion,name \
    --jq '.[] | "\(.status) \(.conclusion // "pending") \(.name)"' 2>/dev/null || true)

  if [ -z "$RUNS" ]; then
    echo "NO_CI_RUNS: no workflow runs found for branch ${BRANCH}"
    exit 0
  fi

  # All completed+success → green path
  # grep -v filters out matching lines; grep -q . checks if any non-matching lines remain
  if echo "$RUNS" | grep -v "^completed success" | grep -q .; then
    echo "=== CI RUNS (branch: ${BRANCH}) ==="
    gh run list --branch "$BRANCH" --limit 5 2>/dev/null || true
    exit 2
  fi

  echo "ALL_CHECKS_PASSED"
  exit 0
fi

# PR exists — use gh pr checks
CHECKS_OUTPUT=$(gh pr checks "$PR_NUM" 2>/dev/null || true)

if [ -z "$CHECKS_OUTPUT" ]; then
  echo "NO_CHECKS: no checks found for PR #${PR_NUM}"
  exit 0
fi

# Green path: all checks passed
if echo "$CHECKS_OUTPUT" | grep -qE "^(fail|pending|queued|in_progress)" 2>/dev/null; then
  :  # has failures — fall through
elif ! echo "$CHECKS_OUTPUT" | grep -qiE "(fail|error|cancel)" 2>/dev/null; then
  echo "ALL_CHECKS_PASSED"
  exit 0
fi

# Failures found — emit compact output for Claude
echo "=== CI CHECKS (PR #${PR_NUM}) ==="
# Filter to only failing/pending lines to reduce token usage
echo "$CHECKS_OUTPUT" | grep -vE "^\s*(pass|✓|✅)" 2>/dev/null || echo "$CHECKS_OUTPUT"
exit 2
