---
model: opus
mode: plan
allowed-tools: Read, Glob, Grep, Bash, AskUserQuestion, Task
---

Review a completed spec and its code changes: $ARGUMENTS

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

For each changed file, read the full file to understand context around the changes.

### 5. Review against spec

#### 5a — Spec compliance
- Are ALL steps checked off? If not, which are missing and why?
- Does the implementation match what each step described?
- Was anything built that's listed in "Out of Scope"? Flag scope creep.

#### 5b — Acceptance criteria
- Verify each acceptance criterion. Are they genuinely met by the code?
- Don't just trust checkboxes — verify against the actual diff.

#### 5b2 — Definition of Done
If `.agents/context/CONVENTIONS.md` exists and contains a `## Definition of Done` section, verify the code changes also satisfy those global quality gates (e.g. no lint errors, no explicit any, all tests green, code formatted). Report any gates that are not met as blocking issues.

#### 5c — Code quality
Spawn the `code-reviewer` agent via Task tool. Pass:
- The full spec content (goal, steps, acceptance criteria, out of scope)
- The branch name from the spec header (so the agent runs `git diff main...BRANCH`)

Use the agent's verdict (PASS / CONCERNS / FAIL) and issue list as the code quality result for this review. Do NOT perform inline code analysis — delegate entirely to the agent.

### 6. Verdict

Present the review findings, then choose exactly one:

**APPROVED** — All criteria met, code quality acceptable (agent verdict PASS or CONCERNS with no blockers).
1. Change spec status from `in-review` to `completed`
2. Move the spec file: `specs/NNN-*.md` -> `specs/completed/NNN-*.md`
3. Report: "Spec NNN approved and completed."

**CHANGES REQUESTED** — Issues found that need fixing (agent verdict FAIL, or spec compliance failures).
1. Add a `## Review Feedback` section at the end of the spec file with the specific issues
2. Change spec status from `in-review` back to `in-progress`
3. Report the issues and suggest: "Run `/spec-work NNN` to address the feedback, then `/spec-review NNN` again."

**REJECTED** — Fundamental problems, spec should not be merged.
1. Change spec status to `blocked`
2. Add `## Review Feedback` section with the rejection reason
3. Report why and suggest next steps (rewrite spec, discard, etc.)

## Rules
- Do NOT make code changes. Only review and update spec status/feedback.
- Read the actual code before commenting — never speculate.
- Focus on what matters: spec compliance and bugs over style.
- If the diff is empty (no changes found), report this and ask the user to verify.
- Never push to remote or create PRs automatically.
