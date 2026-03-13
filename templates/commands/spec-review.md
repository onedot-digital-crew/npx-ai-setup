---
model: opus
mode: plan
argument-hint: "[spec number]"
allowed-tools: Read, Glob, Grep, Bash, AskUserQuestion, Agent
---

Reviews spec $ARGUMENTS and its code changes against acceptance criteria. Use after spec-work to validate and close.

## Process

### 1. Find the spec
If `$ARGUMENTS` is a number (e.g. `011`), open `specs/011-*.md`. If it's a filename, open that directly. If empty, list all specs with status `in-review` in `specs/` and ask which one to review.

### 2. Validate status
The spec's status must be `in-review`. If it's `draft` or `in-progress`, report: "Spec is not ready for review (status: X). Run `/spec-work NNN` first." and stop. If it's `completed`, report: "Spec is already completed." and stop.

### 3. Read the spec
Understand Goal, Steps, Acceptance Criteria, Files to Modify, and Out of Scope. Note which steps and criteria are checked off.

### 4. Inspect code changes
Read the `**Branch**` field from the spec header. Then:

- If a branch exists (not `—`): run `git diff main...BRANCH` to see all changes on that branch
- If no branch: run `git diff` and `git diff --staged` to see uncommitted changes

For each changed file, read the full file to understand context around the changes. **Cap**: Read at most the 5 most significantly changed files in full; for remaining files, review only the diff hunks.

### 5. Review against spec

#### 5a — Spec compliance & acceptance criteria
- Are ALL steps checked off and matching what was described?
- Are acceptance criteria genuinely met (verify against diff, not checkboxes)?
- Was anything built that's listed in "Out of Scope"? Flag scope creep.

For structured acceptance criteria (Truths / Artifacts / Key Links), verify each category mechanically:
- **Truths**: Run the described command or check and confirm the output matches the stated behavior.
- **Artifacts**: Confirm the file exists, has real implementation (not a placeholder or stub), and meets any minimum line count specified.
- **Key Links**: Open the source file and confirm the stated import or reference is actually present.

#### 5b — Definition of Done
If `.agents/context/CONVENTIONS.md` contains a `## Definition of Done` section, verify the code changes satisfy those global quality gates. Report unmet gates as blocking issues.

#### 5c — Code quality
Spawn `code-reviewer` agent via Agent tool. Pass the full spec content and branch name. Use the agent's verdict (PASS / CONCERNS / FAIL) and issue list as code quality input. Do NOT duplicate its analysis inline.

#### 5d — Quality scoring

Based on evidence from 5a–5c, score 10 metrics (0–100 each):

| # | Metric | What to check |
|---|--------|---------------|
| 1 | **Spec Compliance** | All steps implemented exactly as described? |
| 2 | **Acceptance Criteria** | Every criterion genuinely met (verified, not assumed)? |
| 3 | **Test Coverage** | New functionality has tests; existing tests still pass? |
| 4 | **Requirements Fidelity** | Implementation matches the spec goal — no drift, no gold-plating? |
| 5 | **Code Clarity** | Code is readable, named well, no magic numbers or unexplained logic? |
| 6 | **Error Handling** | Failure paths handled; no silent failures, no unguarded throws? |
| 7 | **Security** | No credentials in code, no unsafe patterns, no exposed internals? |
| 8 | **Scope Adherence** | Nothing built outside the spec; no accidental scope creep? |
| 9 | **No Regressions** | Existing functionality unaffected; no broken imports or side effects? |
| 10 | **Completeness** | No TODOs, no stubs, no placeholder comments left in the diff? |

Display the score table:

```
Quality Score — Spec NNN
─────────────────────────────────────────
 1. Spec Compliance ........... XX
 2. Acceptance Criteria ........ XX
 3. Test Coverage .............. XX
 4. Requirements Fidelity ....... XX
 5. Code Clarity ............... XX
 6. Error Handling .............. XX
 7. Security .................... XX
 8. Scope Adherence ............. XX
 9. No Regressions .............. XX
10. Completeness ................. XX
─────────────────────────────────────────
   Average: XX.X    Minimum: XX
   Threshold: 85 avg / 70 min
```

### 6. Verdict

Present the review findings + quality score, then choose exactly one:

**APPROVED** — All criteria met AND avg ≥ 85 AND no metric < 70 AND code-reviewer PASS or CONCERNS.
1. Status → `completed`, move to `specs/completed/NNN-*.md`
2. Report: "Spec NNN approved. Score: XX.X avg / XX min."

**CHANGES REQUESTED** — code-reviewer FAIL, spec failures, avg < 85, or any metric < 70.
1. Add `## Review Feedback` with failing metrics and concrete fix instructions
2. Status → `in-progress`
3. Report: "Run `/spec-work NNN` to address feedback, then `/spec-review NNN` again."

**REJECTED** — Score < 60 avg or critical security/regression issue.
1. Status → `blocked`, add `## Review Feedback` with rejection reason
2. Report why and suggest next steps.

## Rules
- Do NOT make code changes. Only review and update spec status/feedback.
- Read the actual code before commenting — never speculate.
- Focus on what matters: spec compliance and bugs over style.
- If the diff is empty (no changes found), report this and ask the user to verify.
- Never push to remote or create PRs automatically.
