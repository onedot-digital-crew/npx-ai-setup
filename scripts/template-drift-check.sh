#!/usr/bin/env bash
# template-drift-check.sh — detect drift between .claude/ and templates/claude/
#
# Purpose: prevent silent divergence between repo-local Claude config and
# what `npx ai-setup` ships to target projects.
#
# Exit codes:
#   0 — no unexpected drift
#   1 — drift detected (printed to stderr)
#
# Usage:
#   bash scripts/template-drift-check.sh           # check
#   bash scripts/template-drift-check.sh --verbose # show all comparisons

set -o pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT" || exit 2

VERBOSE=0
[ "${1:-}" = "--verbose" ] && VERBOSE=1

# Files/dirs allowed to exist only in .claude/ (not in templates/)
# These are repo-local artifacts, not meant to ship.
LOCAL_ONLY_PATTERNS=(
  "agents"
  "commands"
  "plans"
  "skills"
  "scripts"
  "worktrees"
  "settings.local.json"
  "agent-memory"
  "claude-powerline.json"
  "changelog-audit.json"
  ".log"
  "docs/rtk-reference.md"
)

# Files allowed to exist only in templates/claude/ (not yet adopted locally)
TEMPLATE_ONLY_PATTERNS=(
  "rules/hooks-token-policy.md"
  "rules/typescript.md"
)

# Scripts allowed to be local-only (decision: keep repo-local, not shipped)
# Update this allowlist when adding new local-only scripts.
LOCAL_ONLY_SCRIPTS=(
  "analyze-fast.sh"
  "build-summary.sh"
  "codeburn-metrics.sh"
  "liquid-graph-refresh.sh"
  "measure-context-cost.sh"
  "quality-gate.sh"
  "session-deep-dive.sh"
  "session-extract.sh"
  "analyze-sessions.sh"
)

# Skills allowed to be local-only
LOCAL_ONLY_SKILLS=(
  "bash-defensive-patterns"
  "claude-changelog"
  "gh-cli"
  "orchestrate"
)

# Skills allowed to be template-only
TEMPLATE_ONLY_SKILLS=(
  "graphify"
)

drift_count=0
report() {
  echo "DRIFT: $*" >&2
  drift_count=$((drift_count + 1))
}

note() {
  [ "$VERBOSE" = "1" ] && echo "  ok: $*"
}

# Files allowed to differ between .claude/ and templates/claude/
# (intentional divergence — repo-local config vs target-project shipped config)
ALLOWED_CONTENT_DIVERGENCE=(
  ".claude/settings.json" # local has rtk + sandbox tweaks; template ships baseline
)

# 1. Compare .claude/ vs templates/claude/ — content diffs
check_content_drift() {
  local pair file_local file_tpl matched
  while IFS= read -r line; do
    case "$line" in
      "Files "*" and "*" differ")
        file_local="${line#Files }"
        file_local="${file_local%% and *}"
        file_tpl="${line#*and }"
        file_tpl="${file_tpl% differ}"
        matched=0
        for allowed in "${ALLOWED_CONTENT_DIVERGENCE[@]}"; do
          [ "$file_local" = "$allowed" ] && {
            matched=1
            break
          }
        done
        [ "$matched" = "0" ] && report "content differs: $file_local <-> $file_tpl"
        ;;
    esac
  done < <(diff -rq .claude/ templates/claude/ 2> /dev/null)
}

# Convert "Only in .claude/foo: bar" -> ".claude/foo/bar" for matching
_normalize_only_in() {
  # Input: "Only in DIR: NAME"
  # Output: "DIR/NAME"
  local s="${1#Only in }"
  local dir="${s%%:*}"
  local name="${s#*: }"
  echo "$dir/$name"
}

# 2. Check files only in .claude/ — must match LOCAL_ONLY_PATTERNS
check_local_only() {
  local path
  while IFS= read -r line; do
    case "$line" in
      "Only in .claude"*)
        path="$(_normalize_only_in "$line")"
        local matched=0
        for pat in "${LOCAL_ONLY_PATTERNS[@]}"; do
          case "$path" in
            *"/$pat" | *"/$pat/"* | *"$pat")
              matched=1
              break
              ;;
          esac
        done
        [ "$matched" = "0" ] && report "unexpected local-only: $path"
        ;;
    esac
  done < <(diff -rq .claude/ templates/claude/ 2> /dev/null)
}

# 3. Check files only in templates/claude/ — must match TEMPLATE_ONLY_PATTERNS
check_template_only() {
  local path
  while IFS= read -r line; do
    case "$line" in
      "Only in templates/claude"*)
        path="$(_normalize_only_in "$line")"
        local matched=0
        for pat in "${TEMPLATE_ONLY_PATTERNS[@]}"; do
          case "$path" in
            *"/$pat" | *"/$pat/"* | *"$pat")
              matched=1
              break
              ;;
          esac
        done
        [ "$matched" = "0" ] && report "unexpected template-only: $path"
        ;;
    esac
  done < <(diff -rq .claude/ templates/claude/ 2> /dev/null)
}

# 4. Compare .claude/scripts/ vs templates/scripts/ (separate install path)
check_scripts_drift() {
  if [ ! -d "templates/scripts" ] || [ ! -d ".claude/scripts" ]; then
    return 0
  fi
  local file basename matched
  while IFS= read -r line; do
    case "$line" in
      "Only in .claude/scripts:"*)
        basename="${line#Only in .claude/scripts: }"
        matched=0
        for s in "${LOCAL_ONLY_SCRIPTS[@]}"; do
          [ "$basename" = "$s" ] && {
            matched=1
            break
          }
        done
        [ "$matched" = "0" ] && report "script local-only (not allowlisted): .claude/scripts/$basename"
        ;;
      "Only in templates/scripts:"*)
        basename="${line#Only in templates/scripts: }"
        report "script template-only: templates/scripts/$basename (missing in .claude/scripts/)"
        ;;
      "Files "*" differ")
        file="${line#Files }"
        file="${file%% and *}"
        report "script content differs: $file"
        ;;
    esac
  done < <(diff -rq .claude/scripts/ templates/scripts/ 2> /dev/null)
}

# 5. Skills divergence: SKILL.md (local) vs SKILL.template.md (template) is OK
#    Only flag entire missing skill directories outside the allowlists.
check_skills_drift() {
  if [ ! -d "templates/skills" ] || [ ! -d ".claude/skills" ]; then
    return 0
  fi
  local name matched
  for d in .claude/skills/*/; do
    name="$(basename "$d")"
    if [ ! -d "templates/skills/$name" ]; then
      matched=0
      for s in "${LOCAL_ONLY_SKILLS[@]}"; do
        [ "$name" = "$s" ] && {
          matched=1
          break
        }
      done
      [ "$matched" = "0" ] && report "skill local-only (not allowlisted): .claude/skills/$name"
    fi
  done
  for d in templates/skills/*/; do
    name="$(basename "$d")"
    if [ ! -d ".claude/skills/$name" ]; then
      matched=0
      for s in "${TEMPLATE_ONLY_SKILLS[@]}"; do
        [ "$name" = "$s" ] && {
          matched=1
          break
        }
      done
      [ "$matched" = "0" ] && report "skill template-only (not allowlisted): templates/skills/$name"
    fi
  done
}

check_content_drift
check_local_only
check_template_only
check_scripts_drift
check_skills_drift

if [ "$drift_count" -gt 0 ]; then
  echo "" >&2
  echo "Found $drift_count drift issue(s)." >&2
  echo "Resolve by syncing files, updating allowlist in this script, or moving scripts/skills to the correct location." >&2
  exit 1
fi

note "no drift detected"
exit 0
