# Spec: Add Feedback Loop Patterns to Workflow Commands

> **Spec ID**: 042 | **Created**: 2026-02-27 | **Status**: completed | **Branch**: spec/042-feedback-loop-patterns

## Goal
Add explicit "validate → fix → repeat" feedback loops and progress checklist patterns to workflow commands that modify code but lack verification.

## Context
Anthropic's skill best practices show that feedback loops ("run validator → fix → repeat") significantly improve output quality. Our `spec-work.md` and `bug.md` already have verify-app/code-reviewer loops, but `techdebt.md` modifies code without any verification. Commands with complex multi-step workflows (`spec-work.md`, `bug.md`) benefit from explicit progress checklist patterns.

## Steps
- [x] Step 1: Add verify step to `templates/commands/techdebt.md` — after Step 4 (fixing clear wins), spawn `verify-app` to run tests/build, retry fixes up to 2 times if failures
- [x] Step 2: Add progress checklist copy pattern to `templates/commands/spec-work.md` — before Step 8 (Execute), output a trackable checklist that Claude checks off during execution
- [x] Step 3: Add retry loop to `templates/commands/test.md` Step 5 — make the "repeat until pass or 3 attempts" pattern more explicit with numbered attempt tracking
- [x] Step 4: Run smoke tests (`bash tests/smoke-test.sh`) to verify templates install correctly

## Acceptance Criteria
- [x] `techdebt.md` runs verify-app after making changes and retries on failure
- [x] `spec-work.md` includes a progress checklist pattern before execution
- [x] `test.md` has explicit attempt counter in retry loop
- [x] Smoke tests pass

## Files to Modify
- `templates/commands/techdebt.md` — add verification feedback loop
- `templates/commands/spec-work.md` — add progress checklist pattern
- `templates/commands/test.md` — make retry loop explicit

## Out of Scope
- Read-only commands (review, grill, analyze, spec-board) — no code changes to validate
- Single-action commands (commit, pr, release) — no loop needed
- Agent templates (`templates/agents/*.md`)
