#!/usr/bin/env bash
# tests/update-path.sh — End-to-end smoke for `--patch` migration
# Simulates an old install with deprecated artifacts and verifies cleanup_known_orphans removes them.
# Exits 0 on success, 1 on failure. Idempotent: second run produces no diff.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d -t ai-setup-update-path.XXXXXX)"
trap 'rm -rf "$TMP"' EXIT

PASS=0
FAIL=0
pass() {
  echo "  PASS: $1"
  PASS=$((PASS + 1))
}
fail() {
  echo "  FAIL: $1"
  FAIL=$((FAIL + 1))
}

echo "=== Update-path smoke ==="
echo "Tmp: $TMP"

# Stage 1: simulate old install with deprecated files
mkdir -p "$TMP/.claude/hooks" "$TMP/.claude/skills/spec-review" "$TMP/.claude/skills/release" "$TMP/.claude/scripts"
touch "$TMP/.claude/hooks/graph-before-read.sh"
touch "$TMP/.claude/hooks/graph-context.sh"
touch "$TMP/.claude/skills/spec-review/SKILL.md"
touch "$TMP/.claude/skills/release/SKILL.md"
touch "$TMP/.claude/scripts/release.sh"
touch "$TMP/.claude/scripts/release-prep.sh"
echo '{"version":"0.0.1"}' > "$TMP/.claude/.metadata.json"

# Source update lib + invoke cleanup
cd "$TMP"
# shellcheck source=/dev/null
. "$REPO_ROOT/lib/update.sh"

UPD_REMOVED=0
UPD_BACKED_UP=0
UPD_REMOVED_BACKED_UP=0

cleanup_known_orphans > /dev/null 2>&1 || true

# Stage 2: assert deprecated artifacts removed
DEPRECATED=(
  ".claude/hooks/graph-before-read.sh"
  ".claude/hooks/graph-context.sh"
  ".claude/skills/spec-review/SKILL.md"
  ".claude/skills/spec-review"
  ".claude/skills/release/SKILL.md"
  ".claude/skills/release"
  ".claude/scripts/release.sh"
  ".claude/scripts/release-prep.sh"
)
for path in "${DEPRECATED[@]}"; do
  if [ -e "$path" ]; then
    fail "deprecated artifact still present: $path"
  else
    pass "removed: $path"
  fi
done

# Stage 3: idempotency — second run must produce no diff
SNAPSHOT_BEFORE="$(find . -type f -o -type d 2> /dev/null | LC_ALL=C sort | sha256sum | awk '{print $1}')"
cleanup_known_orphans > /dev/null 2>&1 || true
SNAPSHOT_AFTER="$(find . -type f -o -type d 2> /dev/null | LC_ALL=C sort | sha256sum | awk '{print $1}')"
if [ "$SNAPSHOT_BEFORE" = "$SNAPSHOT_AFTER" ]; then
  pass "idempotent: second cleanup produced no diff"
else
  fail "non-idempotent: cleanup changed state on second run"
fi

# Stage 4: ensure templates no longer ship deprecated files (catches accidental re-add)
cd "$REPO_ROOT"
TEMPLATE_GUARDS=(
  "templates/skills/release"
  "templates/skills/spec-review"
  "templates/scripts/release.sh"
  "templates/scripts/release-prep.sh"
  "templates/claude/hooks/graph-before-read.sh"
  "templates/claude/hooks/graph-context.sh"
)
for path in "${TEMPLATE_GUARDS[@]}"; do
  if [ -e "$path" ]; then
    fail "template still ships removed artifact: $path"
  else
    pass "template free of: $path"
  fi
done

echo ""
echo "=== Result: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ]
