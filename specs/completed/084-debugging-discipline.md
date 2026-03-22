---
**Status**: completed
**Branch**: —
**Complexity**: low
---

# Spec 084 — Debugging Discipline Methodology

## Goal

Add a structured 6-point debugging methodology to prevent aimless fix loops that burn tokens without progress. Integrate into both `bug.md` (direct debugging) and `spec-work.md` (verification failure path).

## Context

When Claude encounters build/test failures, it often tries multiple rapid fixes without forming hypotheses, leading to circuit-breaker triggers and wasted context. GSD-2's execute-task prompt includes a debugging discipline section that enforces structured thinking before action. Our circuit-breaker catches the symptom (too many edits), but this addresses the cause (unstructured debugging).

**Dependency:** Spec 081 adds a step to `spec-work.md` and renumbers subsequent steps. Execute 081 first, or apply all spec-work.md changes in the same branch. The Haiku Investigator section is currently step 13 — step 14 after 081 runs.

**Note:** `bug.md` already has a minimal "State the root cause" instruction in section 2. This spec adds a richer methodology; the existing sections (Reproduce, Root cause, Fix, Verify, Review) remain unchanged.

Relevant files: `templates/commands/bug.md`, `templates/commands/spec-work.md`

## Steps

- [x] **Step 1 — Add debugging discipline to bug.md**
  In `templates/commands/bug.md`, add a "Debugging Discipline" section early in the process (after initial analysis, before any fix attempts):
  ```markdown
  ## Debugging Discipline

  Follow these rules strictly when investigating and fixing:

  1. **Hypothesis first.** State what you think is wrong and why, then test that specific theory. Don't shotgun-fix.
  2. **One variable at a time.** Make one change, test, observe. Multiple simultaneous changes mean you can't attribute what worked.
  3. **Read completely.** When investigating, read entire functions and their imports, not just the line that looks relevant.
  4. **Distinguish "I know" from "I assume."** Observable facts (the error says X, the test output shows Y) are strong evidence. Assumptions (this library should work this way) need verification.
  5. **Stop after 3 failed fixes.** If you've tried 3+ fixes without progress, your mental model is probably wrong. Stop. List what you know for certain. List what you've ruled out. Form fresh hypotheses from there.
  6. **Don't fix symptoms.** Understand *why* something fails before changing code. A test that passes after a change you don't understand is luck, not a fix.
  ```

- [x] **Step 2 — Add debugging discipline reference to spec-work.md**
  In `templates/commands/spec-work.md`, find the **"Verify implementation"** step (currently step 13, step 14 after Spec 081 runs) where the Haiku Investigator is defined. Add a note before the Investigator instructions:
  ```markdown
  When diagnosing failures, follow the debugging discipline:
  - Form a hypothesis before making any change
  - Change one variable at a time
  - After 3 failed fix attempts, stop and reassess your mental model
  - Don't fix symptoms — understand the root cause first
  ```
  This should appear between the Haiku Investigator instructions and the "Apply the investigator's suggested fix" line.

## Files to Modify

- `templates/commands/bug.md`
- `templates/commands/spec-work.md`
- `templates/skills/spec-work/SKILL.md` (mirror Step 2)

## Acceptance Criteria

- [x] `bug.md` contains the 6-point debugging discipline section placed before any fix attempts
- [x] `spec-work.md` references the debugging discipline before the Haiku Investigator instructions
- [x] All 6 rules use imperative mood ("State", "Change", "Read", "Stop", "Don't")
- [x] Rule 5 threshold (3 failed fixes) is below the circuit-breaker block threshold (8 edits)
- [x] `templates/skills/spec-work/SKILL.md` mirrors the spec-work.md change

## Out of Scope

- Changing the circuit-breaker thresholds or hook logic
- Adding debugging rules to other commands (review.md, analyze.md)
- Automated validation that debugging discipline was followed
