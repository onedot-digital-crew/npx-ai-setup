# Spec: claude-mem settings merge + misplaced key cleanup

> **Spec ID**: 647 | **Created**: 2026-04-27 | **Status**: completed | **Complexity**: low | **Branch**: —

## Goal

On update, merge missing template keys into `~/.claude-mem/settings.json` without clobbering user edits. Warn when project-level `CLAUDE_MEM_*` keys are found in `.claude/settings.json`.

## Context

`install_claude_mem_settings()` skips silently when `~/.claude-mem/settings.json` exists — new template keys (e.g. `CLAUDE_MEM_SKIP_TOOLS` additions) never reach existing installs. Also, projects can accidentally end up with `CLAUDE_MEM_*` keys in `.claude/settings.json` (wrong location — claude-mem only reads `~/.claude-mem/`), causing silent misconfiguration.

## Stack Coverage
- **Profiles affected**: all
- **Per-stack difference**: none

## Steps

- [x] Step 1: `lib/plugins.sh` — `install_claude_mem_settings()`: if target exists, merge missing keys from template (jq/node) instead of skipping. Only adds absent keys; user-set values preserved.
- [x] Step 2: `lib/plugins.sh` — add `scan_misplaced_mem_settings()`: detect top-level `CLAUDE_MEM_*` keys in `.claude/settings.json`, print warning with key names, suggest manual cleanup. No auto-delete.
- [x] Step 3: `lib/update.sh` — call `scan_misplaced_mem_settings` in `run_smart_update()` after template processing.

## Acceptance Criteria

- [ ] `~/.claude-mem/settings.json` with subset of template keys → update adds missing keys, keeps existing values
- [ ] `~/.claude-mem/settings.json` with user-edited value → update does NOT overwrite that value
- [ ] `.claude/settings.json` with `CLAUDE_MEM_MODEL` key → warning printed during update
- [ ] `.claude/settings.json` without `CLAUDE_MEM_*` keys → no warning printed
- [ ] `bash -n lib/plugins.sh` and `bash -n lib/update.sh` pass

## Files to Modify

- `lib/plugins.sh` - merge logic + scanner function
- `lib/update.sh` - call scanner in run_smart_update

## Out of Scope

- Auto-removing misplaced keys from project settings
- Per-project settings override mechanism
- Node fallback for merge (jq guard already in codebase pattern — warn + skip if jq absent)
