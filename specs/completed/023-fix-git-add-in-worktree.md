# Spec: Fix git add -A in spec-work-all Worktree Prompt

> **Spec ID**: 023 | **Created**: 2026-02-24 | **Status**: in-review | **Branch**: spec/023-fix-git-add-in-worktree

## Goal
Replace `git add -A` with `git add -u` in the `spec-work-all.md` subagent commit step to match project conventions.

## Context
`spec-work-all.md` embeds a shell snippet ending with `git add -A && git commit`. This contradicts the rule in `commit.md` ("never use `git add -A` — avoid accidentally staging secrets or binaries"). In a worktree context the risk is lower but the inconsistency undermines the project's own safety conventions.

## Steps
- [x] Step 1: Locate the commit line in `spec-work-all.md` subagent prompt (`git add -A && git commit`)
- [x] Step 2: Replace with `git add -u && git commit -m "spec(NNN): [spec title]"` (stages tracked changes only)
- [x] Step 3: Sync to `.claude/commands/spec-work-all.md`

## Acceptance Criteria
- [x] No `git add -A` in any spec-work-all template or deployed command
- [x] `git add -u` is used instead (tracks modified/deleted, ignores untracked secrets)

## Files to Modify
- `templates/commands/spec-work-all.md` — fix commit line in subagent prompt
- `.claude/commands/spec-work-all.md` — sync deployed copy

## Out of Scope
- Changing the broader worktree setup logic
- Adding secret scanning
