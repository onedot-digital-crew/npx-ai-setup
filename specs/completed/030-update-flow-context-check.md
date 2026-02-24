# Spec: Add context file check and granular regeneration to update flow

> **Spec ID**: 030 | **Created**: 2026-02-24 | **Status**: completed | **Branch**: —

## Goal
Ensure the smart update flow checks for missing `.agents/context/` files and offers granular regeneration via `ask_regen_parts` instead of a binary y/N prompt.

## Context
The "Different version" update path (option 1) uses a simple y/N prompt defaulting to No for context regeneration, while the "Same version" path already uses the granular `ask_regen_parts` selector. Context files may be entirely missing after updating from older versions — this is never detected or communicated.

## Steps
- [x] Step 1: After template update summary (line ~1414), add existence check for `.agents/context/{STACK,ARCHITECTURE,CONVENTIONS}.md` — count existing vs expected (3)
- [x] Step 2: If any context files are missing, print warning with count (e.g. "⚠️  2 of 3 context files missing — regeneration recommended")
- [x] Step 3: Replace the y/N prompt block (lines 1416-1429) with `ask_regen_parts` call, matching the same-version flow pattern (lines 1273-1283)
- [x] Step 4: If context files are missing, pre-set `REGEN_CONTEXT="yes"` before calling `ask_regen_parts` so Context is recommended (but user can still deselect)
- [x] Step 5: Verify idempotency — running update twice with all context files present must not force regeneration

## Acceptance Criteria
- [x] Missing context files are detected and reported during smart update
- [x] Update flow uses `ask_regen_parts` for granular control (CLAUDE.md, Context, Commands, Skills)
- [x] Default behavior regenerates context when files are missing, skips when all present
- [x] No regression in same-version and reinstall flows

## Files to Modify
- `bin/ai-setup.sh` — smart update section (lines ~1414-1429)

## Out of Scope
- Staleness detection for existing context files (age-based checks)
- Changes to the `--regen` CLI flag flow
- Modifications to `run_generation` itself
