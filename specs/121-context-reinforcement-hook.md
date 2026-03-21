# Spec: Context Reinforcement Hook After Compaction

> **Spec ID**: 121 | **Created**: 2026-03-21 | **Status**: draft | **Branch**: —

## Goal
Add a SessionStart hook that re-injects critical rules after context compaction to prevent rule drift.

## Context
After compaction, Claude sometimes forgets enforcement rules (skill-first, read-before-modify, human approval gates). Octopus solves this with a `context-reinforcement.sh` SessionStart hook that re-injects "Iron Laws" via additionalContext. Our rules in `.claude/rules/` are loaded at session start but lost after compaction. This hook ensures they survive.

## Steps
- [ ] Step 1: Create `templates/hooks/context-reinforcement.sh` — reads key rules from `.claude/rules/*.md`, outputs them as `additionalContext` JSON
- [ ] Step 2: Select which rules to reinforce (max 5 — most critical: read-before-modify, skill-first, human-approval-gates, verify-before-done, no-sandbox-bypass)
- [ ] Step 3: Add hook to `templates/claude/settings.json` under SessionStart event
- [ ] Step 4: Ensure hook completes in <50ms (no file reads beyond .claude/rules/, no API calls)
- [ ] Step 5: Test: run compaction, verify rules appear in additionalContext after restart

## Acceptance Criteria
- [ ] Hook fires on SessionStart and injects top 5 rules as additionalContext
- [ ] Hook execution <50ms
- [ ] Rules survive context compaction
- [ ] No duplicate injection if rules already in context (idempotent)

## Files to Modify
- `templates/hooks/context-reinforcement.sh` — new
- `templates/claude/settings.json` — add SessionStart hook entry

## Out of Scope
- Changing which rules exist in `.claude/rules/`
- Output quality gates (separate concern)
