# Spec 078 — Fix PreCompact Hook: Selective Staging and Proper Commit Message

**Status:** in-review
**Issue:** https://github.com/onedot-digital-crew/npx-ai-setup/issues/3

## Goal

Fix the PreCompact hook so it stages only tracked modified files (not all files via `git add -A`) and uses a conventional commit message instead of `wip: auto-save before context compaction`. Also remove `--no-verify` which violates git rules.

## Context

The PreCompact hook in `templates/claude/settings.json` currently:
- Uses `git add -A` — stages everything, including untracked/unrelated files
- Uses `--no-verify` — bypasses hooks, violating `.claude/rules/git.md`
- Uses message `wip: auto-save before context compaction` — not a valid conventional commit

Fix: replace with `git add -u` (only tracked modified files) and a proper `chore:` message.

## Steps

1. **Edit** `templates/claude/settings.json`: replace the PreCompact hook command:
   - `git add -A` → `git add -u`
   - Remove `--no-verify`
   - Message: `chore: save session state before context compaction`

2. **Edit** `.claude/settings.json` (local installed copy): apply identical change.

## Acceptance Criteria

- `templates/claude/settings.json` PreCompact hook uses `git add -u`, no `--no-verify`, message is `chore: save session state before context compaction`
- `.claude/settings.json` PreCompact hook matches the template exactly
- No other fields in either settings file are changed

## Files to Modify

- `templates/claude/settings.json`
- `.claude/settings.json`

## Out of Scope

- Staging newly created untracked files (requires session tracking — future spec)
- Changing any other hooks
