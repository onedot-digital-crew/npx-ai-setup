#!/usr/bin/env bash
# release.sh — Version bump, CHANGELOG entry, git tag
# Usage: bash .claude/scripts/release.sh [patch|minor|major]
# Requires: bash 3.2+, git, python3 (or node) for JSON manipulation
set -euo pipefail

# ── Dependency checks ──────────────────────────────────────────────────────────
if ! command -v git >/dev/null 2>&1; then
  echo "ERROR: git not found in PATH" >&2; exit 1
fi

# ── Dirty check ────────────────────────────────────────────────────────────────
if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
  echo "ERROR: Uncommitted changes found. Commit or stash them before releasing." >&2
  git status --short >&2
  exit 1
fi

# ── Read current version from package.json ─────────────────────────────────────
if [ ! -f "package.json" ]; then
  echo "ERROR: package.json not found in current directory." >&2; exit 1
fi

if command -v python3 >/dev/null 2>&1; then
  CURRENT_VERSION="$(python3 -c "import json; print(json.load(open('package.json'))['version'])" 2>/dev/null)"
elif command -v node >/dev/null 2>&1; then
  CURRENT_VERSION="$(node -e "process.stdout.write(require('./package.json').version)")"
else
  echo "ERROR: python3 or node required to read package.json version" >&2; exit 1
fi

if [ -z "$CURRENT_VERSION" ]; then
  echo "ERROR: Could not read version from package.json" >&2; exit 1
fi

# ── Commits since last tag ─────────────────────────────────────────────────────
LAST_TAG="$(git describe --tags --abbrev=0 2>/dev/null || true)"
echo "# Release"
echo ""
if [ -n "$LAST_TAG" ]; then
  echo "## Commits since ${LAST_TAG}"
  git log --oneline "${LAST_TAG}..HEAD" 2>/dev/null || echo "  (none)"
else
  echo "## Recent commits (no previous tag)"
  git log --oneline -10 2>/dev/null || echo "  (none)"
fi

echo ""
echo "Current version: **${CURRENT_VERSION}**"
echo ""

# ── Determine bump type ────────────────────────────────────────────────────────
BUMP="${1:-}"
if [ -z "$BUMP" ]; then
  echo "Bump type? [patch / minor / major]"
  read -r BUMP
fi

case "$BUMP" in
  patch|minor|major) ;;
  *) echo "ERROR: Invalid bump type '${BUMP}'. Use patch, minor, or major." >&2; exit 1 ;;
esac

# ── Calculate new version ──────────────────────────────────────────────────────
IFS='.' read -r VMAJOR VMINOR VPATCH <<< "$CURRENT_VERSION"
VMAJOR="${VMAJOR:-0}"; VMINOR="${VMINOR:-0}"; VPATCH="${VPATCH:-0}"

case "$BUMP" in
  major) VMAJOR=$((VMAJOR + 1)); VMINOR=0; VPATCH=0 ;;
  minor) VMINOR=$((VMINOR + 1)); VPATCH=0 ;;
  patch) VPATCH=$((VPATCH + 1)) ;;
esac
NEW_VERSION="${VMAJOR}.${VMINOR}.${VPATCH}"
TODAY="$(date +%Y-%m-%d)"

echo "New version:     **${NEW_VERSION}** (${BUMP} bump)"
echo ""

# ── Check CHANGELOG.md ─────────────────────────────────────────────────────────
if [ ! -f "CHANGELOG.md" ]; then
  echo "ERROR: CHANGELOG.md not found. Create one with an '## [Unreleased]' section first." >&2
  exit 1
fi
if ! grep -q "## \[Unreleased\]" CHANGELOG.md 2>/dev/null; then
  echo "ERROR: No '## [Unreleased]' section found in CHANGELOG.md." >&2
  echo "       Add one or run the CHANGELOG migration before releasing." >&2
  exit 1
fi

# ── Confirmation gate ──────────────────────────────────────────────────────────
echo "---"
echo "Ready to:"
echo "  1. Update package.json  ${CURRENT_VERSION} → ${NEW_VERSION}"
echo "  2. Update CHANGELOG.md  [Unreleased] → [v${NEW_VERSION}] — ${TODAY}"
echo "  3. git commit -m \"release: v${NEW_VERSION}\""
echo "  4. git tag v${NEW_VERSION}"
echo ""
printf "Proceed? [y/N] "
read -r CONFIRM
case "$CONFIRM" in
  [Yy]*) ;;
  *) echo "Aborted."; exit 0 ;;
esac

# ── Update package.json ────────────────────────────────────────────────────────
if command -v python3 >/dev/null 2>&1; then
  python3 - <<PYEOF
import json, sys
with open('package.json', 'r') as f:
    data = json.load(f)
data['version'] = '${NEW_VERSION}'
with open('package.json', 'w') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write('\n')
print("  Updated package.json: ${CURRENT_VERSION} -> ${NEW_VERSION}")
PYEOF
elif command -v node >/dev/null 2>&1; then
  node - <<NJEOF
const fs = require('fs');
const p = JSON.parse(fs.readFileSync('package.json', 'utf8'));
p.version = '${NEW_VERSION}';
fs.writeFileSync('package.json', JSON.stringify(p, null, 2) + '\n');
console.log('  Updated package.json: ${CURRENT_VERSION} -> ${NEW_VERSION}');
NJEOF
fi

# ── Update CHANGELOG.md ────────────────────────────────────────────────────────
# Replace [Unreleased] with versioned heading and insert new [Unreleased] above
NEW_HEADER="## [Unreleased]"$'\n\n\n'"## [v${NEW_VERSION}] — ${TODAY}"

if command -v python3 >/dev/null 2>&1; then
  python3 - <<PYEOF
with open('CHANGELOG.md', 'r') as f:
    content = f.read()
updated = content.replace('## [Unreleased]', '${NEW_HEADER}', 1)
with open('CHANGELOG.md', 'w') as f:
    f.write(updated)
print('  Updated CHANGELOG.md: [Unreleased] -> [v${NEW_VERSION}] — ${TODAY}')
PYEOF
else
  # Portable sed fallback (GNU + BSD compatible via temp file)
  TMPFILE="$(mktemp)"
  sed "s|## \[Unreleased\]|${NEW_HEADER}|" CHANGELOG.md > "$TMPFILE"
  mv "$TMPFILE" CHANGELOG.md
  echo "  Updated CHANGELOG.md"
fi

# ── Commit and tag ─────────────────────────────────────────────────────────────
git add package.json CHANGELOG.md
git commit -m "release: v${NEW_VERSION}"
git tag "v${NEW_VERSION}"

echo ""
echo "Done. Tagged v${NEW_VERSION}."
echo ""
echo "When ready to publish:"
echo "  git push && git push --tags"
