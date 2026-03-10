---
name: spec-work
description: Execute a spec step by step. Use when the user says "work on spec NNN", "execute spec NNN", "implement spec NNN", or "run spec NNN". NNN is a 3-digit spec number.
---

# Spec Work — Execute a Spec Step by Step

Executes a spec from `specs/NNN-*.md` step by step, commits after each step, and verifies the result.

## Process

1. **Find the spec**: If given a number (e.g. `074`), open `specs/074-*.md`. If a filename, open directly.

2. **Read the spec** — understand Goal, Steps, Acceptance Criteria, Files to Modify.

3. **Read project context**: Skim `.agents/context/CONVENTIONS.md` and `.agents/context/STACK.md`.

4. **Update status**: Set `**Status**: in-progress` in the spec header.

5. **Print a progress checklist** of all steps before starting:
   ```
   Progress — Spec NNN
   [ ] Step 1: <title>
   [ ] Step 2: <title>
   ```

6. **Resume check**: Scan for already-checked steps (`- [x]`). If found, skip them and continue from the first unchecked step.

7. **Execute each step** in order:
   - Implement the change
   - Check it off in the spec: `- [ ]` → `- [x]`
   - Commit: `git add -A && git commit -m "spec(NNN): step N — <title>"`
   - If blocked, stop and ask

8. **Verify acceptance criteria** — check each one off in the spec.

9. **Update CHANGELOG.md** — add entry under `## [Unreleased]`:
   `- **Spec NNN**: [title] — [one-sentence summary]`

10. **Run tests/build** if available (`bash tests/smoke.sh` or equivalent). Report PASS or FAIL.

11. **Set status to `completed`**, move file: `specs/NNN-*.md` → `specs/completed/NNN-*.md`.

## Rules
- Commit after every step — enables crash resilience
- Never skip the status update and file move at the end
- If a step fails, set status to `blocked` and stop
