---
name: spec-review
description: "Review a completed spec after implementation."
argument-hint: "<NNN spec number>"
---

Reviews spec $ARGUMENTS and its code changes against acceptance criteria. Use after spec-work to validate and close.

## Process

### 1. Find the spec
If `$ARGUMENTS` is a number, open `specs/NNN-*.md`. If empty, list specs with status `in-review` and ask. Must be `in-review` — otherwise report status and stop.

### 2. Read the spec
Understand Goal, Steps, Acceptance Criteria, Files to Modify, Out of Scope. Note checked items.

### 3. Inspect code changes

Run the prep script — it collects diff, doctor check, and spec status in one shell pass:

```bash
bash .claude/scripts/spec-review-prep.sh $ARGUMENTS
```

The output contains: branch detection, full diff (branch or working tree), top 5 changed files, doctor.sh results, and acceptance criteria progress.

Read full files for the 5 most changed files (listed in prep output); review only diff hunks for the rest.
Do NOT re-run `git diff` or `doctor.sh` — all data is in the prep output.

### 4. Review against spec

**4a — Goal achievement** ("Task done ≠ Goal achieved"):
- Verify the Goal is actually met, not just checkboxes
- Verify acceptance criteria against diff
- Flag Out of Scope violations

Verify each acceptance criterion: run commands, read modified files, confirm behavior matches.

**4b — Definition of Done**: Check `.agents/context/CONVENTIONS.md` DoD section if it exists.

**4c — Code quality** (by complexity):
- Low/Medium: spawn `code-reviewer` agent (model: sonnet)
- High: spawn `code-reviewer` AND `staff-reviewer` in parallel (model: sonnet)

**4d — Conditional reviewers** (spawn in parallel with 4c if applicable):
- Spec touches auth, user input, API endpoints, or secrets → also spawn `security-reviewer`
- Spec touches DB queries, loops, rendering, data fetching, or bundle imports → also spawn `performance-reviewer`

**4e — Doctor check** (already in prep output):
Check the `DOCTOR CHECK` section from step 3 prep output. Any FAIL blocks APPROVED verdict — must be fixed first.

### 5. Verdict

**APPROVED** — All criteria met, agents returned PASS/CONCERNS:
1. Status → `completed`, move to `specs/completed/`
2. Proceed to Finishing Gate

**CHANGES REQUESTED** — Agent FAIL or criteria not met:
1. Add `## Review Feedback` with fix instructions, status → `in-progress`

**REJECTED** — Critical security/regression:
1. Status → `blocked`, add feedback, suggest next steps

### 6. Finishing Gate (APPROVED only)

Ask user via `AskUserQuestion`:
1. **Merge to main** — `git checkout main && git merge BRANCH && git branch -d BRANCH`
2. **Push and create PR** — `git push -u origin BRANCH && gh pr create`
3. **Keep branch** — report name, no changes
4. **Discard** — confirm first, then `git checkout main && git branch -D BRANCH`

Clean up worktree after merge/push/discard if one exists.

## Next Step

- APPROVED + merged: `> 📦 Naechster Schritt: /commit — Changes committen`
- APPROVED + PR: `> 📤 Naechster Schritt: gh pr create — Pull Request via CLI`
- CHANGES REQUESTED: `> 🔧 Naechster Schritt: Feedback umsetzen, dann /spec-review NNN erneut`
- REJECTED: `> 🔧 Naechster Schritt: Kritische Issues fixen, dann /spec-review NNN erneut`

## Rules
- **Read-only** — no code changes, only spec status/feedback updates.
- Read actual code before commenting — never speculate.
- Focus on spec compliance and bugs over style.
- Never push or create PRs without explicit user choice.
- Review stays on Sonnet for all tiers — never downgrade to Haiku for review work.
