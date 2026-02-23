# Spec: Rewrite spec-work-all to use native worktree isolation

> **Spec ID**: 018 | **Created**: 2026-02-23 | **Status**: completed | **Branch**: spec/018-native-worktree-rewrite

## Goal
Replace manual git worktree management in spec-work-all.md with Claude Code's native `isolation: "worktree"` on the Task tool, and bump version to 1.1.3.

## Context
Claude Code now has built-in worktree support via `Task(isolation: "worktree")`. Our spec-work-all.md manually manages worktrees with ~40 lines of bash (create, .env copy, dep install, cleanup). The native approach handles creation, isolation, and cleanup automatically. This rewrite simplifies the template and moves spec file/CHANGELOG updates to the orchestrator (cleaner separation of concerns).

## Steps
- [x] Step 1: Rewrite `templates/commands/spec-work-all.md` — remove Section 3 (gitignore setup), replace Wave setup (manual worktree/env/deps) with `Task(isolation: "worktree")`, remove Wave cleanup. Orchestrator sets spec status before launch and updates branch/CHANGELOG after return.
- [x] Step 2: Update subagent prompt: remove worktree path instructions, add "copy .env* from main repo and run dep install if lockfile exists" as first steps, add "rename branch to `spec/NNN-title`" before commit.
- [x] Step 3: Move spec file updates (check off steps, status, CHANGELOG) from subagent to orchestrator — subagent only does implementation + commit inside worktree.
- [x] Step 4: Update `templates/CLAUDE.md` spec workflow section — mention native worktree isolation.
- [x] Step 5: Bump version in `package.json` from 1.1.2 to 1.1.3.

## Acceptance Criteria
- [x] spec-work-all uses `Task(isolation: "worktree")` instead of manual `git worktree add/remove`
- [x] No `.worktrees/` directory or `.gitignore` management in the template
- [x] Subagent prompt includes .env copy, dep install, and branch rename instructions
- [x] package.json version is 1.1.3

## Files to Modify
- `templates/commands/spec-work-all.md` — full rewrite of worktree management
- `templates/CLAUDE.md` — update workflow description
- `package.json` — version bump

## Out of Scope
- Changes to `/spec-work` (single spec execution — uses branch prompt, not worktrees)
- Adding `isolation: worktree` to custom agent frontmatter files
- Changing the spec template format
