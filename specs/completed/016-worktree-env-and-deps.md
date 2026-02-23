# Spec: Auto-copy .env and install deps in spec-work-all worktrees

> **Spec ID**: 016 | **Created**: 2026-02-22 | **Status**: completed | **Branch**: spec/016-worktree-env-and-deps

## Goal
Make spec-work-all worktrees production-ready by copying .env files and installing dependencies automatically.

## Context
Inspired by Timberline's worktree manager, our `spec-work-all.md` creates bare worktrees without .env files or installed dependencies. Agents running in these worktrees fail silently when the project needs environment variables or node_modules. This adds two steps to the "Wave setup" section.

## Steps
- [x] Step 1: In `templates/commands/spec-work-all.md`, after `git worktree add` in "Wave setup", add .env copy step: copy all `.env*` files from repo root to worktree, excluding `.env.example` and `.env.template`. Use glob: `for f in .env*; do ...`
- [x] Step 2: In same section, add dependency auto-init: detect lockfile (bun.lockb→bun, package-lock.json→npm, pnpm-lock.yaml→pnpm, yarn.lock→yarn) and run `<pm> install` inside worktree. Skip if no lockfile found.
- [x] Step 3: Add error handling: if .env copy or dep install fails, log a warning but continue (don't block spec execution)
- [x] Step 4: Update the subagent prompt template to mention that .env and deps are pre-configured in the worktree

## Acceptance Criteria
- [x] Worktrees receive .env files (excluding example/template) before agents launch
- [x] Dependencies are installed via detected package manager before agents launch
- [x] Failures in env copy or dep install are warnings, not blockers

## Files to Modify
- `templates/commands/spec-work-all.md` — add env copy and dep init to Wave setup

## Out of Scope
- Supporting non-JS package managers (cargo, pip, go mod) — add later if needed
- Syncing .env changes back from worktree to main repo
- Session linking (symlink Claude project data across worktrees)
