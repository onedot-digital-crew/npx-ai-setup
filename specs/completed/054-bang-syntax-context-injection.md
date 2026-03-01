# Spec: Bang-Syntax Context Injection

> **Spec ID**: 054 | **Created**: 2026-03-01 | **Status**: completed | **Branch**: spec/054-bang-syntax-context-injection

## Goal
Replace manual git tool-call steps in /commit, /review, /pr with bang-syntax `## Context` sections that inject state before Claude runs.

## Context
Our commands spend 2-3 tool-call round-trips gathering git state (status, diff, log) before doing actual work. Claude Code's bang syntax (`!`command``) in a `## Context` section executes shell commands and injects output directly into the command template — zero tool calls needed. Anthropic uses this pattern in their own `commit-push-pr.md`.

## Steps
- [x] Step 1: In `templates/commands/commit.md`, add `## Context` section after the description (line 7) with `!`git status``, `!`git diff --staged``, `!`git diff``, `!`git log --oneline -5``. Remove steps 1-2 from Process, replace with "Analyze the changes shown in Context above."
- [x] Step 2: In `templates/commands/review.md`, add `## Context` section after the description (line 7) with `!`git rev-parse --abbrev-ref HEAD``, `!`git diff``, `!`git diff --staged``, `!`git diff main...HEAD 2>/dev/null``. Simplify step 1 to reference Context instead of running commands.
- [x] Step 3: In `templates/commands/pr.md`, add `## Context` section after the description (line 7) with `!`git status``, `!`git diff``, `!`git log --oneline main..HEAD``, `!`git branch --show-current``. Simplify step 2 to reference Context instead of running commands.
- [x] Step 4: Verify all three commands still have correct allowed-tools, model, and mode frontmatter

## Acceptance Criteria
- [x] All three commands have a `## Context` section with bang-syntax git commands
- [x] Process steps no longer instruct Claude to run git status/diff/log manually
- [x] Existing rules, allowed-tools, and workflow logic are unchanged

## Files to Modify
- `templates/commands/commit.md` - add Context section, simplify steps
- `templates/commands/review.md` - add Context section, simplify steps
- `templates/commands/pr.md` - add Context section, simplify steps

## Out of Scope
- Adding Context sections to other commands (spec, bug, grill, etc.)
- Changing command logic or rules beyond context gathering
- Adding new git commands not already present in the current steps
