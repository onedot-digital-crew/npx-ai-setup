# Spec: Enhanced generation prompts for STACK.md, CONVENTIONS.md, and Critical Rules

> **Spec ID**: 002 | **Created**: 2026-02-17 | **Status**: completed

## Goal
Improve the auto-generation prompts so STACK.md includes an "Avoid" section, CONVENTIONS.md covers testing and deeper error handling, and Critical Rules generation follows specific categories.

## Context
Lean+ research shows that "DO NOT USE" lists prevent wrong library suggestions (e.g., axios when project uses custom apiClient). Testing conventions and error handling depth are currently missing from CONVENTIONS.md generation. Critical Rules prompt is too vague, producing generic output.

## Steps
- [x] Add "Avoid" bullet to STACK.md generation prompt in `bin/ai-setup.sh` (~line 489)
- [x] Expand "Error handling patterns" bullet in CONVENTIONS.md prompt with specifics (try-catch, error boundaries, API errors, logging)
- [x] Add "Testing patterns" bullet to CONVENTIONS.md prompt (test location, naming, framework, what is tested)
- [x] Expand Critical Rules prompt with specific categories (code style, TypeScript, imports, framework, testing)
- [x] Add "Omit categories where no evidence exists" guard to prevent fabrication

## Acceptance Criteria
- [x] STACK.md prompt includes "Avoid" instruction with examples
- [x] CONVENTIONS.md prompt has 6 bullets (was 5) including testing
- [x] Critical Rules prompt lists 5 category hints
- [x] `bash -n bin/ai-setup.sh` passes

## Files to Modify
- `bin/ai-setup.sh` — 3 prompt sections

## Out of Scope
- ARCHITECTURE.md prompt changes
- Changing the generation model or max-turns
