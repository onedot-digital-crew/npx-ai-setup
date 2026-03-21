# Spec: Add Stall Detection to /loop and /spec-work

> **Spec ID**: 125 | **Created**: 2026-03-21 | **Status**: draft | **Branch**: —

## Goal
Add stall detection to `/loop` skill and `/spec-work` command to prevent infinite iteration loops that burn tokens without progress.

## Context
Both `/loop` and `/spec-work` can get stuck repeating the same actions. Octopus uses stall detection (output similarity check + max iterations cap) to auto-abort. We have no iteration limits or progress checks. Inspired by claude-octopus skill-iterative-loop.md stall detection pattern.

## Steps
- [ ] Step 1: Add max-iterations parameter to `/loop` skill (default: 10, max: 30) with counter tracking
- [ ] Step 2: Add stall detection heuristic to `/loop`: if 2 consecutive iterations produce no file changes (git diff empty), warn and ask user to continue or abort
- [ ] Step 3: Add per-step timeout to `/spec-work`: if a single step takes >15 minutes without completing, pause and ask
- [ ] Step 4: Add total-iteration guard to `/spec-work`: if same step is retried >3 times, mark as blocked and move to next
- [ ] Step 5: Update both template and project-local command files

## Acceptance Criteria
- [ ] `/loop` has configurable max-iterations with default 10
- [ ] `/loop` detects stalled iterations (no file changes) and prompts user
- [ ] `/spec-work` marks steps as blocked after 3 retries instead of infinite loop
- [ ] Both commands report token/iteration stats at completion

## Files to Modify
- `templates/commands/spec-work.md` — add stall detection + retry limit
- `.claude/commands/spec-work.md` — mirror
- `.claude/skills/spec-work/SKILL.md` — update description

## Out of Scope
- Changes to /spec-work-all (parallel execution)
- Budget/cost limits (separate concern)
