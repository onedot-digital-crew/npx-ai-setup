# Spec: Improve spec-work branch handling and review flow

> **Spec ID**: 015 | **Created**: 2026-02-22 | **Status**: completed | **Branch**: —

## Goal
Add branch creation prompt to /spec-work, remove PR from /spec-review, and add optional auto-review with corrections to /spec-work.

## Context
The spec workflow currently lacks a branch prompt in /spec-work (users may work on main), suggests PR commands in /spec-review (unwanted), and requires a separate /spec-review step. This spec streamlines the flow: ask about branches upfront, remove PR noise, and offer inline auto-review with auto-fix after execution.

## Steps
- [x] Step 1: In `templates/commands/spec-work.md`, add `AskUserQuestion` to `allowed-tools` in frontmatter
- [x] Step 2: In `spec-work.md`, insert step 3 (after reading spec): ask user if a new branch should be created. If yes, derive `spec/NNN-title` from filename, run `git checkout -b`, update spec `**Branch**` field. If branch exists, offer to switch.
- [x] Step 3: In `spec-work.md`, replace step 9 (mark ready for review): ask user if auto-review should run. If no, keep current behavior (set `in-review`, suggest `/spec-review`).
- [x] Step 4: In `spec-work.md`, add step 10 (auto-review): full review pass — check spec compliance, acceptance criteria, code quality. Fix issues found. One pass only. If all good, set status `completed`, move to `specs/completed/`. If unfixable issues, keep `in-review` and report.
- [x] Step 5: In `templates/commands/spec-review.md`, remove PR preparation from APPROVED verdict (steps 3-4: PR title/body/commands). Keep status change and file move only.
- [x] Step 6: Update `templates/CLAUDE.md` spec workflow section to reflect that /spec-review no longer suggests PRs
- [x] Step 7: Renumber all steps in spec-work.md to account for inserted branch step and auto-review

## Acceptance Criteria
- [x] `/spec-work` asks about branch creation before starting work
- [x] `/spec-work` asks about auto-review after completing all steps
- [x] `/spec-review` APPROVED verdict has no PR commands or suggestions
- [x] Auto-review performs full check and auto-fixes issues in one pass

## Files to Modify
- `templates/commands/spec-work.md` — add branch prompt, auto-review option
- `templates/commands/spec-review.md` — remove PR from APPROVED
- `templates/CLAUDE.md` — update workflow description

## Out of Scope
- Changes to `/spec-work-all` (already has its own branch/worktree logic)
- Creating a separate `/pr` command
- Multi-pass review loops
