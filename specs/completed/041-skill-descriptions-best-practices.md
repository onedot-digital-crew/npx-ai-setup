# Spec: Improve Command Descriptions to Follow Anthropic Best Practices

> **Spec ID**: 041 | **Created**: 2026-02-27 | **Status**: completed | **Branch**: spec/041-skill-descriptions-best-practices

## Goal
Rewrite the first body line (description) of all 15 `templates/commands/*.md` to state what the command does AND when to use it, in third person, under 120 characters.

## Context
Anthropic's skill best practices require descriptions that include both purpose and trigger conditions for reliable discovery. Our current descriptions only state the action ("Stage all changes...") but not when Claude should select them. The first line after YAML frontmatter is used as the discovery description in the system prompt.

## Steps
- [x] Step 1: Read all 15 `templates/commands/*.md` files and document current first-body-line descriptions
- [x] Step 2: Rewrite each description to format: "[What it does]. Use when [trigger condition]." — third person, max 120 chars
- [x] Step 3: For commands with `$ARGUMENTS` (bug, spec, spec-work, spec-review), keep the argument reference in the description
- [x] Step 4: Verify no description exceeds 120 characters by running a length check across all files
- [x] Step 5: Run smoke tests (`bash tests/smoke-test.sh`) to ensure templates still install correctly

## Acceptance Criteria
- [x] All 15 command descriptions follow the "what + when" pattern
- [x] All descriptions are in third person (no "you" or imperative-only)
- [x] No description exceeds 120 characters
- [x] Smoke tests pass

## Files to Modify
- `templates/commands/analyze.md` — description
- `templates/commands/bug.md` — description
- `templates/commands/commit.md` — description
- `templates/commands/context-full.md` — description
- `templates/commands/grill.md` — description
- `templates/commands/pr.md` — description
- `templates/commands/release.md` — description
- `templates/commands/review.md` — description
- `templates/commands/spec-board.md` — description
- `templates/commands/spec-review.md` — description
- `templates/commands/spec-work-all.md` — description
- `templates/commands/spec-work.md` — description
- `templates/commands/spec.md` — description
- `templates/commands/techdebt.md` — description
- `templates/commands/test.md` — description

## Out of Scope
- Adding `description:` frontmatter field (not confirmed supported by Claude Code)
- Changing command body/instructions beyond the first line
- Agent template descriptions (`templates/agents/*.md`)

## Review Feedback
Frontmatter fields were stripped from 4 files during description rewrite:
- `spec-work.md`: lost `disable-model-invocation: true` and `argument-hint: "[spec number]"`
- `bug.md`: lost `argument-hint: "[bug description]"` and `Task` from allowed-tools
- `spec.md`: lost `argument-hint: "[task description]"`
- `spec-review.md`: lost `argument-hint: "[spec number]"`
Fix: restore all original frontmatter fields — only the first body line (description) should change.
