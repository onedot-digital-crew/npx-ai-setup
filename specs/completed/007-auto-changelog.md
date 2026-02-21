# Spec: Auto-Updated CHANGELOG.md on Spec Completion

> **Spec ID**: 007 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Create a CHANGELOG.md that automatically updates with date and changes whenever a spec is completed via `/spec-work`.

## Context
There is no changelog tracking completed specs and their changes. Adding an automatic update step to the `/spec-work` command ensures every completed spec produces a changelog entry without manual effort. The changelog groups entries by date.

## Steps
- [x] Step 1: Create `CHANGELOG.md` in project root with initial structure (header, format description)
- [x] Step 2: Add changelog update step to `templates/commands/spec-work.md` between "verify acceptance criteria" and "complete the spec" — prepend entry under today's date heading with spec title and summary of changes
- [x] Step 3: Also add the same changelog step to the project's own `.claude/commands/spec-work.md` so it takes effect immediately
- [x] Step 4: Validate by dry-reading the updated spec-work template to confirm the instruction flow is correct

## Acceptance Criteria
- [x] `CHANGELOG.md` exists in project root with a clear format
- [x] `templates/commands/spec-work.md` includes an automatic changelog update step
- [x] `.claude/commands/spec-work.md` also includes the changelog update step
- [x] Changelog entries are grouped by date with spec title and change summary

## Files to Modify
- `CHANGELOG.md` — create with initial structure
- `templates/commands/spec-work.md` — add changelog step
- `.claude/commands/spec-work.md` — add changelog step

## Out of Scope
- Retroactively adding entries for specs 001-006
- Changelog formatting beyond date + spec title + summary
