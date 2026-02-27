# Spec: Enhance /grill with scope challenge, options format, and what-exists section

> **Spec ID**: 045 | **Created**: 2026-02-28 | **Status**: in-review | **Branch**: spec/045-grill-review-enhancements

## Goal
Adapt Garry Tan's plan-exit-review patterns into `/grill` (full) and `/review` (light) to improve review depth and actionability.

## Context
The gist introduces three valuable patterns missing from our review commands: a pre-review Scope Challenge that catches unnecessary changes early, an A/B/C options format that makes issue resolution concrete, and explicit "What already exists" / "NOT reviewed" sections. `/grill` is the adversarial deep-review that benefits from all three. `/review` is a lighter pre-commit check that gets only the "What already exists" addition. `/spec-review` already delegates to `code-reviewer` and needs no changes.

## Steps
- [x] Step 1: Add Step 0 to `templates/commands/grill.md` — before analysis, challenge scope: does this already exist? Is this the minimum viable change? Offer three paths: scope reduction / full adversarial review / compressed review
- [x] Step 2: Change issue format in `grill.md` — replace "Suggested fix" with Options A/B/C (tradeoffs + directive recommendation), using AskUserQuestion for each blocking issue
- [x] Step 3: Add "What already exists" section to `grill.md` output — grep for similar functions/patterns before flagging issues
- [x] Step 4: Add "NOT reviewed" disclaimer to `grill.md` output — explicitly list what was out of scope
- [x] Step 5: Add light "What already exists" check to `templates/commands/review.md` — one grep pass for duplicated logic before reporting findings
- [x] Step 6: Add self-verification table as final step in `grill.md` — "Double check every single claim. At the end, make a table of what you were able to verify."

## Acceptance Criteria
- [x] `/grill` starts with a scope challenge before any code analysis
- [x] Each grill finding includes labeled options (A/B/C) with a directive recommendation
- [x] Grill output includes "What already exists" and "NOT reviewed" sections
- [x] `/review` output includes a brief "What already exists" note when duplication is detected
- [x] `/grill` ends with a self-verification table listing every claim and its verification status
- [x] Both commands remain read-only (no code changes)

## Files to Modify
- `templates/commands/grill.md` — Steps 1–4, 6: scope challenge, options format, new output sections, self-verification table
- `templates/commands/review.md` — Step 5: light duplication check

## Out of Scope
- Changes to `/spec-review` (already structured with code-reviewer agent)
- ASCII flow diagrams (complexity vs. value ratio too low for shell projects)
- TODOS.md integration (we use specs instead)
