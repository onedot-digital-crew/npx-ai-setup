---
name: spec-review
description: Review a completed spec against its acceptance criteria. Use when the user says `/spec-review NNN`, "review spec NNN", or "validate spec NNN after implementation".
---

# Spec Review — Validate and Close a Spec

Reviews a spec in `specs/NNN-*.md` after implementation and decides whether it should be approved, sent back, or blocked.

## Process

1. **Find the spec**: open `specs/NNN-*.md` or the filename provided.

2. **Validate status**: review only specs with status `in-review`. If status differs, report it and stop.

3. **Read the spec**: understand Goal, Steps, Acceptance Criteria, Files to Modify, and Out of Scope.

4. **Inspect code changes**:
   - If the spec has a branch, compare it against `main`.
   - Otherwise inspect current staged and unstaged diffs.
   - Read the most important changed files fully before judging.

5. **Review against the spec**:
   - Verify checked steps match reality
   - Verify acceptance criteria are genuinely satisfied
   - Flag scope creep against Out of Scope
   - Check `.agents/context/CONVENTIONS.md` for global quality gates if present
   - For structured acceptance criteria (Truths / Artifacts / Key Links), verify each category mechanically:
     - **Truths**: Run the described command or check and confirm the output matches the stated behavior.
     - **Artifacts**: Confirm the file exists, has real implementation (not a placeholder or stub), and meets any minimum line count specified.
     - **Key Links**: Open the source file and confirm the stated import or reference is actually present.

6. **Choose a verdict**:
   - `APPROVED`: status becomes `completed`, move spec to `specs/completed/`
   - `CHANGES REQUESTED`: add concrete review feedback, set status to `in-progress`
   - `REJECTED`: set status to `blocked` with the rejection reason

## Rules

- Do not speculate. Read the actual code.
- Do not make implementation changes as part of the review.
- Focus on correctness, regressions, and acceptance criteria over style.
