# Spec: Rename /bug to /debug with Hypothesis-First Method

> **Spec ID**: 120 | **Created**: 2026-03-21 | **Status**: draft | **Branch**: —

## Goal
Rename `/bug` to `/debug` and enhance with hypothesis-first methodology and mandatory regression test step.

## Context
Current `/bug` jumps from reproduce to fix. Octopus debugger agent uses scientific method: form hypothesis before fixing. Adding hypothesis step and regression test requirement reduces fix-it-again cycles. No new agent needed — enhanced inline command. Inspired by claude-octopus debugger agent.

## Steps
- [ ] Step 1: Create `templates/commands/debug.md` based on current `bug.md` with enhanced process: Reproduce → Hypothesis → Root Cause Isolate → Fix → Regression Test → Verify → Review
- [ ] Step 2: Add "Red Flag Detection" checklist to Step 2: silent exception swallowing, bare catch blocks, missing error propagation
- [ ] Step 3: Add mandatory regression test step: "Write a test that fails without the fix and passes with it"
- [ ] Step 4: Remove `templates/commands/bug.md`, update `.claude/commands/` to match
- [ ] Step 5: Update CLAUDE.md and WORKFLOW-GUIDE references from `/bug` to `/debug`

## Acceptance Criteria
- [ ] `/debug` command available with hypothesis-first flow (8 steps)
- [ ] Regression test is mandatory before verify step
- [ ] `/bug` removed (breaking change documented)
- [ ] Red Flag Detection checklist included in root cause step

## Files to Modify
- `templates/commands/debug.md` — new (replaces bug.md)
- `templates/commands/bug.md` — delete
- `.claude/commands/debug.md` — new
- `.claude/commands/bug.md` — delete

## Out of Scope
- Dedicated debugger agent (not needed, command handles it inline)
- Changes to verify-app or code-reviewer agents
