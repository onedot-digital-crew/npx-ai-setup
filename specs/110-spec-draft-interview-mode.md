# Spec: Add Draft-First Interview Mode to /spec Command

> **Spec ID**: 110 | **Created**: 2026-03-19 | **Status**: in-progress | **Branch**: —

<!-- Status lifecycle: draft → in-progress → in-review → completed (or blocked at any stage) -->

## Goal
Extend `/spec` to detect when `$ARGUMENTS` points to an existing .md file and enter a proactive interview loop instead of the normal clarify flow.

## Context
Currently `/spec` always generates specs from a text description. When users already have a rough draft spec, they must manually prompt Claude to interview them. This adds a conditional branch in Phase 1b: if input is a file path → read it, run exhaustive AskUserQuestion interview across technical, UX, tradeoff, and edge-case dimensions, then write the refined spec back to the file. Normal text-argument flow remains unchanged.

## Steps
- [x] Step 1: In `templates/commands/spec.md` Phase 1b, add input-type detection: check if `$ARGUMENTS` matches an existing `.md` file path
- [x] Step 2: Add new Phase 1b-interview block: read draft file, then systematically interview via AskUserQuestion (categories: technical implementation, UI/UX, edge cases, tradeoffs, dependencies) — questions must be non-obvious, continue until all areas covered
- [x] Step 3: After interview completes, write refined spec back to the draft file, then continue with Phase 1c
- [x] Step 4: Mirror identical changes to `.claude/commands/spec.md`
- [ ] Step 5: Test both paths: (a) `/spec "text description"` still works as before, (b) `/spec specs/110-spec-draft-interview-mode.md` triggers interview mode

## Acceptance Criteria
- [ ] File-path argument triggers interview mode; text argument triggers normal flow
- [ ] Interview asks minimum 3 rounds of non-obvious AskUserQuestion calls
- [ ] Refined spec is written back to the original draft file
- [ ] Existing Phase 1b (Clarify) unchanged for text arguments

## Files to Modify
- `templates/commands/spec.md` — add conditional branch + interview phase
- `.claude/commands/spec.md` — mirror changes

## Out of Scope
- New slash commands or skills
- Changes to spec-work, spec-validate, or other spec commands
