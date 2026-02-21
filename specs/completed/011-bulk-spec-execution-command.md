# Spec: Bulk Spec Execution via Agents

> **Spec ID**: 011 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Add a `/spec-work-all` slash command that executes multiple specs in parallel or sequence using subagents.

## Context
Currently `/spec-work NNN` processes one spec at a time with a single agent. When multiple independent specs exist, users must run them one-by-one. A bulk command using subagents would dramatically speed up spec completion for batches of unrelated specs.

## Steps
- [x] Step 1: Create `templates/commands/spec-work-all.md` — slash command that lists all draft specs and dispatches each to a Task subagent
- [x] Step 2: Define parallelism strategy in the command: independent specs run in parallel, dependent specs run in sequence
- [x] Step 3: Add dependency detection: if spec A's "Out of Scope" mentions spec B, treat them as sequential
- [x] Step 4: Register `spec-work-all.md` in `bin/ai-setup.sh` template deployment (alongside spec-work.md)
- [x] Step 5: Update `templates/CLAUDE.md` Spec-Driven Development section to document `/spec-work-all`
- [x] Step 6: Update `README.md` slash commands table with new command

## Acceptance Criteria
- [x] `/spec-work-all` discovers all draft specs in `specs/` automatically
- [x] Independent specs execute in parallel via subagents
- [x] Each subagent follows the same spec-work process (check off steps, update CHANGELOG, move to completed/)
- [x] Final summary shows which specs completed, which failed

## Files to Modify
- `templates/commands/spec-work-all.md` — new command (create)
- `bin/ai-setup.sh` — register new template
- `templates/CLAUDE.md` — document command
- `README.md` — add to slash commands table

## Out of Scope
- Spec ordering / priority ranking
- Automatic rollback if a spec fails
- Interactive spec selection UI
