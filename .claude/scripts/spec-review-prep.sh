#!/usr/bin/env bash
# spec-review-prep.sh — Pre-collect diff and doctor data for /spec-review
# Usage: bash .claude/scripts/spec-review-prep.sh <spec-file-or-number>
# Requires: bash 3.2+, git
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/prep-lib.sh"

git_guard

# ---------------------------------------------------------------------------
# Resolve spec file
# ---------------------------------------------------------------------------
SPEC_ARG="${1:-}"

if [ -z "$SPEC_ARG" ]; then
  printf "Usage: spec-review-prep.sh <spec-file-or-number>\n" >&2
  exit 1
fi

SPEC_FILE=""

if printf '%s' "$SPEC_ARG" | grep -qE '^[0-9]+$'; then
  PADDED="$(printf '%03d' "$((10#$SPEC_ARG))")"
  for _f in specs/${PADDED}-*.md specs/completed/${PADDED}-*.md; do
    [ -f "$_f" ] && SPEC_FILE="$_f" && break
  done
  if [ -z "$SPEC_FILE" ]; then
    printf "No spec found matching specs/%s-*.md\n" "$PADDED" >&2
    exit 1
  fi
elif [ -f "$SPEC_ARG" ]; then
  SPEC_FILE="$SPEC_ARG"
else
  printf "File not found: %s\n" "$SPEC_ARG" >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
section() { printf "\n=== %s ===\n\n" "$1"; }

# ---------------------------------------------------------------------------
# Header
# ---------------------------------------------------------------------------
SPEC_ID="$(basename "$SPEC_FILE" .md | grep -oE '^[0-9]+' || echo "???")"
SPEC_TITLE="$(grep -m1 '^# ' "$SPEC_FILE" 2> /dev/null | sed 's/^# //' || echo "Unknown")"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"
MAIN="$(main_branch)"

printf "SPEC_REVIEW_PREP_START %s\n" "$TIMESTAMP"
printf "Spec: %s (%s)\n" "$SPEC_FILE" "$SPEC_TITLE"

# ---------------------------------------------------------------------------
# 1. Extract branch from spec header
# ---------------------------------------------------------------------------
section "BRANCH"
SPEC_BRANCH="$(grep -E '^\>' "$SPEC_FILE" 2> /dev/null |
  head -1 |
  grep -oE '\*\*Branch\*\*: `[^`]+`' |
  tr -d '`' |
  sed 's/\*\*Branch\*\*: //' || true)"

if [[ -n "$SPEC_BRANCH" ]]; then
  printf "Spec branch: %s\n" "$SPEC_BRANCH"
  if git rev-parse --verify "$SPEC_BRANCH" > /dev/null 2>&1; then
    printf "Branch exists: yes\n"
    DIFF_BASE="${MAIN}...${SPEC_BRANCH}"
  else
    printf "Branch exists: no (using working tree diff)\n"
    DIFF_BASE=""
  fi
else
  printf "No branch in spec header — using working tree diff\n"
  DIFF_BASE=""
fi

# ---------------------------------------------------------------------------
# 2. Diff stat + full diff
# ---------------------------------------------------------------------------
section "DIFF STAT"
if [[ -n "$DIFF_BASE" ]]; then
  rtk_or_raw git diff "$DIFF_BASE" --stat 2> /dev/null || echo "(no diff)"
else
  STAGED_STAT="$(rtk_or_raw git diff --cached --stat 2> /dev/null || true)"
  UNSTAGED_STAT="$(rtk_or_raw git diff --stat 2> /dev/null || true)"
  [[ -n "$STAGED_STAT" ]] && printf "Staged:\n%s\n\n" "$STAGED_STAT"
  [[ -n "$UNSTAGED_STAT" ]] && printf "Unstaged:\n%s\n\n" "$UNSTAGED_STAT"
  [[ -z "$STAGED_STAT" ]] && [[ -z "$UNSTAGED_STAT" ]] && printf "(no changes)\n"
fi

section "FULL DIFF"
if [[ -n "$DIFF_BASE" ]]; then
  rtk_or_raw git diff "$DIFF_BASE" 2> /dev/null || echo "(no diff)"
else
  STAGED_DIFF="$(rtk_or_raw git diff --cached 2> /dev/null || true)"
  UNSTAGED_DIFF="$(rtk_or_raw git diff 2> /dev/null || true)"
  [[ -n "$STAGED_DIFF" ]] && printf "=== Staged ===\n%s\n" "$STAGED_DIFF"
  [[ -n "$UNSTAGED_DIFF" ]] && printf "=== Unstaged ===\n%s\n" "$UNSTAGED_DIFF"
  [[ -z "$STAGED_DIFF" ]] && [[ -z "$UNSTAGED_DIFF" ]] && printf "(no diff)\n"
fi

# ---------------------------------------------------------------------------
# 3. Most changed files (top 5 by lines changed)
# ---------------------------------------------------------------------------
section "TOP 5 CHANGED FILES"
if [[ -n "$DIFF_BASE" ]]; then
  git diff "$DIFF_BASE" --numstat 2> /dev/null |
    awk '{print ($1+$2), $3}' | sort -rn | head -5 ||
    echo "(none)"
else
  {
    git diff --cached --numstat 2> /dev/null
    git diff --numstat 2> /dev/null
  } |
    awk '{print ($1+$2), $3}' | sort -rn | head -5 ||
    echo "(none)"
fi

# ---------------------------------------------------------------------------
# 4. Doctor check
# ---------------------------------------------------------------------------
section "DOCTOR CHECK"
if [[ -f ".claude/scripts/doctor.sh" ]]; then
  DOCTOR_OUTPUT="$(bash .claude/scripts/doctor.sh 2>&1)" && DOCTOR_EXIT=0 || DOCTOR_EXIT=$?
  printf "%s\n" "$DOCTOR_OUTPUT"
  printf "\nexit_code: %s\n" "$DOCTOR_EXIT"
else
  printf "SKIP — no doctor.sh found\n"
  DOCTOR_EXIT=0
fi

# ---------------------------------------------------------------------------
# 5. Spec status + acceptance criteria summary
# ---------------------------------------------------------------------------
section "SPEC STATUS"
STATUS="$(grep -E '^\>' "$SPEC_FILE" 2> /dev/null |
  head -1 |
  sed -n 's/.*\*\*Status\*\*: \([^|]*\).*/\1/p' |
  tr -d ' ' || echo "unknown")"
STATUS="${STATUS:-unknown}"
printf "Status: %s\n" "$STATUS"

AC_TOTAL="$(awk '/^## Acceptance Criteria/{f=1;next} f&&/^## /{exit} f&&/^\s*-\s*\[/{c++} END{print c+0}' "$SPEC_FILE")"
AC_DONE="$(awk '/^## Acceptance Criteria/{f=1;next} f&&/^## /{exit} f&&/^\s*-\s*\[x\]/{c++} END{print c+0}' "$SPEC_FILE")"
printf "Acceptance Criteria: %s/%s done\n" "$AC_DONE" "$AC_TOTAL"

STEP_TOTAL="$(awk '/^## Steps/{f=1;next} f&&/^## /{exit} f&&/^\s*-\s*\[/{c++} END{print c+0}' "$SPEC_FILE")"
STEP_DONE="$(awk '/^## Steps/{f=1;next} f&&/^## /{exit} f&&/^\s*-\s*\[x\]/{c++} END{print c+0}' "$SPEC_FILE")"
printf "Steps: %s/%s done\n" "$STEP_DONE" "$STEP_TOTAL"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
section "SUMMARY FOR CLAUDE"
printf "Spec: %s — %s\n" "$SPEC_ID" "$SPEC_TITLE"
printf "Status: %s\n" "$STATUS"
printf "Branch: %s\n" "${SPEC_BRANCH:-"(working tree)"}"
printf "Doctor: %s\n" "$([[ "$DOCTOR_EXIT" -eq 0 ]] && echo "PASS" || echo "FAIL (exit $DOCTOR_EXIT)")"
printf "AC: %s/%s | Steps: %s/%s\n" "$AC_DONE" "$AC_TOTAL" "$STEP_DONE" "$STEP_TOTAL"
printf "\nUse diff and doctor output above. Do NOT re-run git diff or doctor.sh.\n"
printf "\nSPEC_REVIEW_PREP_END\n"
