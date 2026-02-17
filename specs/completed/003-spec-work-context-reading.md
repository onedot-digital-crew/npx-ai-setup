# Spec: Add context reading step to spec-work command

> **Spec ID**: 003 | **Created**: 2026-02-17 | **Status**: completed

## Goal
Ensure Sonnet reads project conventions and stack before executing spec steps, so generated code matches project patterns.

## Context
Currently spec-work.md goes straight from reading the spec to executing steps. Sonnet has no awareness of project conventions unless it happens to read them. Adding a context reading step ensures consistent code quality.

## Steps
- [x] Add step 3 "Read project context" after "Read the spec" in `templates/commands/spec-work.md`
- [x] Instruction: "Skim `.agents/context/CONVENTIONS.md` and `.agents/context/STACK.md` to follow project patterns and use correct libraries."
- [x] Renumber subsequent steps (3→4, 4→5, 5→6)

## Acceptance Criteria
- [x] spec-work.md has 6 process steps (was 5)
- [x] Context reading step references CONVENTIONS.md and STACK.md
- [x] Step numbering is sequential and correct

## Files to Modify
- `templates/commands/spec-work.md` — add step + renumber

## Out of Scope
- Changes to spec.md (creation command)
- Changes to the spec template
