# Spec: Harden deny list in settings.json template

> **Spec ID**: 007 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Add missing destructive git commands to the deny list in `templates/claude/settings.json`.

## Context
The current deny list blocks `rm -rf`, `git reset --hard`, and `npm publish`, but misses `git clean` which can irreversibly delete untracked files. Other destructive patterns like `git checkout .` and `git restore .` (discard all uncommitted changes) are also unguarded. The suggestions about Copilot symlinks, GSD sub-agents, and `npm run verify` are not relevant to this project's templates.

## Steps
- [x] Step 1: Add `Bash(git clean *)` to deny list in `templates/claude/settings.json`
- [x] Step 2: Add `Bash(git checkout -- *)` to deny list (discards uncommitted file changes)
- [x] Step 3: Add `Bash(git restore *)` to deny list (modern equivalent of checkout --)
- [x] Step 4: Verify `git push` is already sufficiently scoped (allow only `claude/*` branches, general push not allowed)
- [x] Step 5: Run `bash -n bin/ai-setup.sh` to validate no syntax issues
- [x] Step 6: Test that settings.json remains valid JSON

## Acceptance Criteria
- [x] `git clean`, `git checkout --`, and `git restore` are denied
- [x] Existing allow/deny entries unchanged
- [x] Valid JSON after edits

## Files to Modify
- `templates/claude/settings.json` - add deny entries

## Out of Scope
- Copilot symlink strategy (not used in this project)
- GSD sub-agent path resolution (not part of templates)
- `npm run verify` command (not defined in templates)
