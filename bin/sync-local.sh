#!/usr/bin/env bash
# sync-local.sh — dev-only: sync templates/ → repo-local .claude/, .github/, agents, scripts, specs
#
# Single source of truth: templates/. Repo-local mirrors are generated.
# Never edit .claude/{agents,hooks,rules,scripts,docs,settings.json} or .github/ directly.
#
# Usage:
#   bash bin/sync-local.sh                   # sync all template-managed paths
#   bash bin/sync-local.sh --dry-run         # show planned writes, no changes
#   bash bin/sync-local.sh --check           # exit 1 if any drift exists (no writes)
#   bash bin/sync-local.sh --prune           # also delete orphans (no template source)
#   bash bin/sync-local.sh --prune --dry-run # list orphans, do not delete
#   bash bin/sync-local.sh --root-docs       # also sync root-level CLAUDE.md/AGENTS.md
#
# Safe by default: never touches marketplace/plugin/local-only skills, agent-memory,
# settings.local.json, logs, plans, worktrees.

set -o pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT" || exit 2

DRY_RUN=0
CHECK=0
PRUNE=0
ROOT_DOCS=0

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --check)
      CHECK=1
      DRY_RUN=1
      ;;
    --prune) PRUNE=1 ;;
    --root-docs) ROOT_DOCS=1 ;;
    -h | --help)
      sed -n '2,18p' "$0"
      exit 0
      ;;
    *)
      echo "unknown flag: $arg" >&2
      exit 2
      ;;
  esac
done

# Skills allowed to live only in .claude/skills (marketplace, plugins, local-only).
# Mirrors LOCAL_ONLY_SKILLS in scripts/template-drift-check.sh — keep in sync.
LOCAL_ONLY_SKILLS=(
  "agent-browser"
  "bash-defensive-patterns"
  "claude-changelog"
  "gh-cli"
  "orchestrate"
  "release"
)

# Scripts allowed to live only in .claude/scripts (repo-local dev tools).
LOCAL_ONLY_SCRIPTS=(
  "analyze-fast.sh"
  "analyze-sessions.sh"
  "build-summary.sh"
  "codeburn-metrics.sh"
  "liquid-graph-refresh.sh"
  "measure-context-cost.sh"
  "quality-gate.sh"
  "release-prep.sh"
  "session-deep-dive.sh"
  "session-extract.sh"
)

# Files in .claude/ allowed to be local-only (logs, runtime state, IDE config).
LOCAL_ONLY_TOP=(
  "agent-memory"
  "agent-metrics.log"
  "changelog-audit.json"
  "claude-powerline.json"
  "commands"
  "config-changes.log"
  "permission-denied.log"
  "plans"
  "settings.local.json"
  "subagent-usage.log"
  "task-completed.log"
  "task-created.log"
  "tool-failures.log"
  "worktrees"
)

# .claude/settings.json deliberately diverges (local has rtk + sandbox tweaks).
ALLOWED_DIVERGENCE=(
  ".claude/settings.json"
)

drift_count=0
write_count=0
skip_count=0
prune_count=0

_log_drift() {
  echo "DRIFT: $*" >&2
  drift_count=$((drift_count + 1))
}

_log_write() {
  echo "  write: $1"
  write_count=$((write_count + 1))
}

_log_prune() {
  echo "  prune: $1"
  prune_count=$((prune_count + 1))
}

_is_allowed_divergence() {
  local target="$1"
  local a
  for a in "${ALLOWED_DIVERGENCE[@]}"; do
    [ "$a" = "$target" ] && return 0
  done
  return 1
}

_in_array() {
  local needle="$1"
  shift
  local item
  for item in "$@"; do
    [ "$item" = "$needle" ] && return 0
  done
  return 1
}

# Map a templates/ path to its repo-local target. Returns empty for skipped paths.
_map_target() {
  local rel="$1"
  case "$rel" in
    skills/*) echo "" ;; # handled separately
    commands/*) echo "" ;;
    context-bundles/*) echo "" ;;
    claudeignore/*) echo "" ;;
    claude/rules/typescript.md) echo ".claude/rules/typescript.md" ;;
    mcp.json) echo "" ;; # merge logic, not a plain copy
    claude/*) echo ".${rel}" ;;
    github/*) echo ".${rel}" ;;
    agents/*) echo ".claude/${rel}" ;;
    scripts/*) echo ".claude/${rel}" ;;
    specs/*) echo "${rel}" ;;
    AGENTS.md | CLAUDE.md | WORKFLOW-GUIDE.md)
      [ "$ROOT_DOCS" = "1" ] && echo "${rel}" || echo ""
      ;;
    decisions.md) echo "" ;; # not mirrored locally
    codex/config.toml)
      [ "$ROOT_DOCS" = "1" ] && echo "${rel}" || echo ""
      ;;
    gemini/* | claude-mem/*) echo "" ;; # opt-in extras, not mirrored
    *) echo "" ;;
  esac
}

# Copy src → dst if different. Honours DRY_RUN. Updates counters.
_sync_file() {
  local src="$1"
  local dst="$2"

  if _is_allowed_divergence "$dst"; then
    skip_count=$((skip_count + 1))
    return 0
  fi

  if [ -f "$dst" ] && cmp -s "$src" "$dst"; then
    skip_count=$((skip_count + 1))
    return 0
  fi

  if [ "$CHECK" = "1" ]; then
    _log_drift "$dst differs from $src"
    return 0
  fi

  if [ "$DRY_RUN" = "1" ]; then
    _log_write "$dst (from $src)"
    return 0
  fi

  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  _log_write "$dst"
}

# 1. Generic templates/ → target sync (claude/, github/, agents/, scripts/, specs/, optional root)
sync_generic() {
  while IFS= read -r -d '' src; do
    local rel="${src#templates/}"
    local filename="${rel##*/}"
    [ "$filename" = ".DS_Store" ] && continue

    local dst
    dst="$(_map_target "$rel")"
    [ -z "$dst" ] && continue

    _sync_file "$src" "$dst"
  done < <(find templates -type f \! -path "templates/skills/*" \! -path "templates/commands/*" \! -path "templates/context-bundles/*" \! -path "templates/claudeignore/*" \! -path "templates/gemini/*" \! -path "templates/claude-mem/*" -print0 2> /dev/null | sort -z)
}

# 2. Skills: templates/skills/<name>/SKILL.template.md → .claude/skills/<name>/SKILL.md
#    Plus references/* recursively.
sync_skills() {
  if [ ! -d "templates/skills" ]; then
    return 0
  fi

  local d name src_skill dst_skill
  for d in templates/skills/*/; do
    name="$(basename "$d")"
    src_skill="${d}SKILL.template.md"
    dst_skill=".claude/skills/${name}/SKILL.md"

    if [ ! -f "$src_skill" ]; then
      continue
    fi

    _sync_file "$src_skill" "$dst_skill"

    if [ -d "${d}references" ]; then
      while IFS= read -r -d '' ref; do
        local rel="${ref#"${d}references/"}"
        _sync_file "$ref" ".claude/skills/${name}/references/${rel}"
      done < <(find "${d}references" -type f \! -name ".DS_Store" -print0 2> /dev/null | sort -z)
    fi
  done
}

# 3. Orphan detection. Reports by default, prunes with --prune.
_handle_orphan() {
  local dst="$1"

  if [ "$CHECK" = "1" ]; then
    _log_drift "orphan (no template source): $dst"
    return 0
  fi

  if [ "$PRUNE" = "0" ]; then
    echo "  orphan: $dst (run with --prune to delete)"
    return 0
  fi

  if [ "$DRY_RUN" = "1" ]; then
    _log_prune "$dst"
    return 0
  fi

  if [ -d "$dst" ]; then
    rm -rf "$dst"
  else
    rm -f "$dst"
  fi
  _log_prune "$dst"
}

scan_orphans() {
  local f name basename rel

  # .claude/agents
  if [ -d ".claude/agents" ]; then
    while IFS= read -r -d '' f; do
      basename="${f##*/}"
      [ -f "templates/agents/${basename}" ] || _handle_orphan "$f"
    done < <(find .claude/agents -maxdepth 1 -type f -print0 2> /dev/null | sort -z)
  fi

  # .claude/hooks
  if [ -d ".claude/hooks" ]; then
    while IFS= read -r -d '' f; do
      basename="${f##*/}"
      [ -f "templates/claude/hooks/${basename}" ] || _handle_orphan "$f"
    done < <(find .claude/hooks -maxdepth 1 -type f -print0 2> /dev/null | sort -z)
  fi

  # .claude/rules
  if [ -d ".claude/rules" ]; then
    while IFS= read -r -d '' f; do
      basename="${f##*/}"
      [ -f "templates/claude/rules/${basename}" ] || _handle_orphan "$f"
    done < <(find .claude/rules -maxdepth 1 -type f -print0 2> /dev/null | sort -z)
  fi

  # .claude/docs
  if [ -d ".claude/docs" ]; then
    while IFS= read -r -d '' f; do
      basename="${f##*/}"
      # rtk-reference.md is local-only by design
      [ "$basename" = "rtk-reference.md" ] && continue
      [ -f "templates/claude/docs/${basename}" ] || _handle_orphan "$f"
    done < <(find .claude/docs -maxdepth 1 -type f -print0 2> /dev/null | sort -z)
  fi

  # .claude/scripts
  if [ -d ".claude/scripts" ]; then
    while IFS= read -r -d '' f; do
      basename="${f##*/}"
      _in_array "$basename" "${LOCAL_ONLY_SCRIPTS[@]}" && continue
      [ -f "templates/scripts/${basename}" ] || _handle_orphan "$f"
    done < <(find .claude/scripts -maxdepth 1 -type f -print0 2> /dev/null | sort -z)
  fi

  # .claude/skills (whole dirs only — never delete a marketplace skill)
  if [ -d ".claude/skills" ]; then
    local d
    for d in .claude/skills/*/; do
      name="$(basename "$d")"
      _in_array "$name" "${LOCAL_ONLY_SKILLS[@]}" && continue
      [ -d "templates/skills/${name}" ] && continue
      _handle_orphan "$d"
    done
  fi
}

# 4. Top-level .claude/ entries (other than the dirs above)
scan_top_orphans() {
  if [ ! -d ".claude" ]; then
    return 0
  fi
  local entry name
  for entry in .claude/*; do
    [ -e "$entry" ] || continue
    name="$(basename "$entry")"
    case "$name" in
      agents | hooks | rules | docs | scripts | skills) continue ;;
    esac
    _in_array "$name" "${LOCAL_ONLY_TOP[@]}" && continue
    case "$name" in
      *.log) continue ;;
      settings.json) continue ;; # allowed divergence
    esac
    _handle_orphan "$entry"
  done
}

# Run
echo "→ syncing templates/ → repo-local mirrors"
sync_generic
sync_skills

echo "→ scanning for orphans"
scan_orphans
scan_top_orphans

echo ""
if [ "$CHECK" = "1" ]; then
  if [ "$drift_count" -gt 0 ]; then
    echo "drift: $drift_count issue(s)" >&2
    exit 1
  fi
  echo "drift: clean"
  exit 0
fi

echo "writes: $write_count   skipped: $skip_count   pruned: $prune_count"
[ "$DRY_RUN" = "1" ] && echo "(dry-run — no changes written)"
exit 0
