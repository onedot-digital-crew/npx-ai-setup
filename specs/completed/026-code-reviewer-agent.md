# Spec: Add code-reviewer Agent and Wire Into Spec Workflow

> **Spec ID**: 026 | **Created**: 2026-02-24 | **Status**: completed | **Branch**: spec/026-code-reviewer-agent

<!-- Status lifecycle: draft → in-progress → in-review → completed (or blocked at any stage) -->

## Goal
Create a reusable `code-reviewer` agent and integrate it into `spec-work` and `spec-review` so review logic is delegated to the agent rather than duplicated inline.

## Context
The installed agents (`build-validator`, `verify-app`, `staff-reviewer`) are never automatically called — only `context-refresher` is triggered via hook. `spec-work` and `spec-review` both run inline review logic; a dedicated agent makes this reusable, consistently applied, and independently improvable. `bin/ai-setup.sh` already copies all `templates/agents/*` to `.claude/agents/` automatically.

## Steps
- [x] Step 1: Create `templates/agents/code-reviewer.md` — model: sonnet, max_turns: 15, read-only; accepts diff + optional spec context; reports bugs/security/quality at HIGH/MEDIUM confidence; returns PASS / CONCERNS / FAIL verdict
- [x] Step 2: Update `templates/commands/spec-work.md` — add `Task` to `allowed-tools`; auto-review step always spawns `code-reviewer` (no "ask user" — mandatory)
- [x] Step 3: Update `templates/commands/spec-review.md` — add `Task` to `allowed-tools`; step 5c (code quality) spawns `code-reviewer` agent with spec + branch diff
- [x] Step 4: Sync both to `.claude/commands/spec-work.md` and `.claude/commands/spec-review.md`

## Acceptance Criteria
- [x] `templates/agents/code-reviewer.md` exists with valid frontmatter and clear behavior rules
- [x] `spec-work` always spawns `code-reviewer` after steps complete (no user prompt)
- [x] `spec-review` step 5c delegates to `code-reviewer` instead of inline analysis
- [x] Deployed commands in `.claude/commands/` match templates

## Files to Modify
- `templates/agents/code-reviewer.md` — new file
- `templates/commands/spec-work.md` — add Task, delegate auto-review
- `templates/commands/spec-review.md` — add Task, delegate code quality check
- `.claude/commands/spec-work.md` — sync
- `.claude/commands/spec-review.md` — sync

## Out of Scope
- Changing `/review` or `/grill` commands
- Integrating `build-validator` or `verify-app` into commands
- Modifying `bin/ai-setup.sh`
