# Spec: Pause/Resume Commands for Session Handoff

> **Spec ID**: 140 | **Created**: 2026-03-22 | **Status**: completed | **Complexity**: medium | **Branch**: —

## Goal
Add `/pause` and `/resume` commands that create structured session handoff files for seamless work continuation.

## Context
Adapted from GSD's `pause-work` + `resume-work`. Currently we mention HANDOFF.md in CLAUDE.md but have no structured system. `/pause` captures current state (active specs, completed work, remaining tasks, open decisions, blockers) into `.continue-here.md`. `/resume` loads this file and routes to the next action. This solves context loss between sessions without relying on git log archaeology.

## Steps
- [x] Step 1: Create `templates/commands/pause.md` — gather state from git status, open specs, recent commits; write `.continue-here.md` with Position/Completed/Remaining/Decisions/Blockers sections; commit as WIP
- [x] Step 2: Create `templates/commands/resume.md` — check for `.continue-here.md`, load and present state, detect incomplete specs, offer next action routing (continue spec-work, review, or start new work)
- [x] Step 3: Mirror both commands to `.claude/commands/`
- [ ] Step 4: Add to `bin/ai-setup.sh` command installation list
- [x] Step 5: Update CLAUDE.md Context Management section to reference `/pause` instead of manual HANDOFF.md
- [ ] Step 6: Test — run `/pause`, verify handoff file, start new session, run `/resume`, verify state restoration

## Acceptance Criteria
- [x] `/pause` creates `.continue-here.md` with all 5 sections and commits it
- [x] `/resume` detects and loads `.continue-here.md`, presents status, offers next actions
- [x] `/resume` without a handoff file gracefully falls back to git log + spec board
- [x] CLAUDE.md references `/pause` for session handoff

## Files to Modify
- `templates/commands/pause.md` — new file
- `templates/commands/resume.md` — new file
- `templates/CLAUDE.md` — update Context Management section

## Out of Scope
- Multi-session history (only latest handoff, not a log)
- Automatic pause on context compaction (separate concern)
