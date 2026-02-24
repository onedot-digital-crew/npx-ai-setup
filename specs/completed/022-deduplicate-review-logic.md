# Spec: Deduplicate Auto-Review Logic in spec-work

> **Spec ID**: 022 | **Created**: 2026-02-24 | **Status**: in-review | **Branch**: spec/022-deduplicate-review-logic

## Goal
Remove the duplicated review criteria from `spec-work.md`'s auto-review step and reference the shared review logic instead.

## Context
`spec-work.md` Step 10 and `spec-review.md` contain near-identical review criteria (spec compliance, acceptance criteria, code quality checks). If one changes, the other silently goes stale — a maintenance trap. The auto-review step should describe *what* to do, not re-define the criteria.

## Steps
- [x] Step 1: Read `spec-work.md` Step 10 and `spec-review.md` §5 side by side to confirm duplication
- [x] Step 2: Rewrite `spec-work.md` Step 10 "yes" path to a compact summary — check spec compliance, criteria, and HIGH/MEDIUM code issues — without copy-pasting the full review schema
- [x] Step 3: Add a note: "For full review criteria see `/spec-review`"
- [x] Step 4: Sync the same change to `.claude/commands/spec-work.md`

## Acceptance Criteria
- [x] `spec-work.md` Step 10 no longer duplicates review criteria from `spec-review.md`
- [x] Auto-review behavior is unchanged (still checks compliance, criteria, quality)
- [x] Both templates and deployed commands are updated

## Files to Modify
- `templates/commands/spec-work.md` — replace verbose auto-review criteria
- `.claude/commands/spec-work.md` — sync deployed copy

## Out of Scope
- Changing spec-review.md logic
- Merging the two commands
