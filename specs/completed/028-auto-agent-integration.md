# Spec: Fully Automatic Agent Integration Into Workflow

> **Spec ID**: 028 | **Created**: 2026-02-24 | **Status**: completed | **Branch**: spec/028-auto-agent-integration

<!-- Status lifecycle: draft → in-progress → in-review → completed (or blocked at any stage) -->

## Goal
Wire `verify-app` into `spec-work` and `staff-reviewer` into `/pr` so all installed agents run automatically at the right workflow moments without user prompting.

## Context
After 026 and 027, agents are available and `code-reviewer` runs automatically. Two remaining gaps: (1) `verify-app` never runs — `spec-work` completes steps but never checks if build/tests pass; (2) `staff-reviewer` (opus) is designed as a production gate but `/pr` never calls it. Both should be mandatory, not optional.

## Steps
- [x] Step 1: Update `templates/commands/spec-work.md` — after all steps complete, auto-spawn `verify-app` before `code-reviewer`; if verify-app returns FAIL, stop and report without running code-reviewer
- [x] Step 2: Update `templates/commands/pr.md` — add `Task` to `allowed-tools`; spawn `staff-reviewer` automatically before drafting PR title/body; include reviewer verdict in PR output
- [x] Step 3: Sync both to `.claude/commands/spec-work.md` and `.claude/commands/pr.md`

## Acceptance Criteria
- [x] `spec-work` post-implementation order: `verify-app` → `code-reviewer` → report
- [x] `verify-app` FAIL blocks the code-reviewer step and reports build/test errors
- [x] `/pr` always runs `staff-reviewer` before generating the PR description
- [x] Deployed commands in `.claude/commands/` match templates

## Files to Modify
- `templates/commands/spec-work.md` — add verify-app spawn before code-reviewer
- `templates/commands/pr.md` — add Task, spawn staff-reviewer
- `.claude/commands/spec-work.md` — sync
- `.claude/commands/pr.md` — sync

## Out of Scope
- Modifying `build-validator` (covered by verify-app)
- Changing `spec-work-all` (uses worktrees — verify handled per-worktree)
- Depends on: Spec 026 (Task already in spec-work allowed-tools)
