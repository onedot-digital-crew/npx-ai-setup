---
name: review
description: "Reviews uncommitted changes or a spec ($ARGUMENTS). Trigger: 'review changes', 'review spec', 'before I commit', 'check my work'."
argument-hint: "[--spec NNN | --quick | --deep]"
user-invocable: true
effort: medium
model: sonnet
allowed-tools:
  - Read
  - Edit
  - Glob
  - Grep
  - Bash
  - Agent
  - AskUserQuestion
---

Two modes: **diff review** (default) and **spec review** (`--spec NNN`).
Spec mode is auto-invocable from `/spec-work`. Plain `/review` stays user-only.

## Mode select

Inspect `$ARGUMENTS`:

- `--spec NNN` or `NNN` (3 digits) → **Spec mode** — jump to section "Spec Mode".
- `--quick` → diff Mode A (Quick Scan).
- `--deep` → diff Mode C (Adversarial Grill).
- empty / other → diff mode with `AskUserQuestion`.

---

## Diff Mode

### 0. Select intensity

If `$ARGUMENTS` is empty or unrecognized:

```
AskUserQuestion: Which review intensity?
A) Quick Scan — bugs + security, HIGH/MEDIUM only (~1 min)
B) Standard Review — bugs, security, performance, readability, tests, duplicates (~3 min)
C) Adversarial Grill — scope challenge, resolution options, self-verification (~10 min)
```

Mode C benefits from Opus for maximum depth.

### 1. Collect diff

```bash
!bash .claude/scripts/review-prep.sh
```

Fallbacks: `!git diff` / `!git diff --staged` / `!git diff main...HEAD 2>/dev/null`.
If all empty, report "No changes found." and stop.

### 2. Stub scan

Before analysis, scan for placeholders:

- `throw new Error("not implemented")`, `TODO`, `FIXME`, stub returns
- AI boilerplate comments
- Empty catch blocks or skeleton classes with no behavior

Flag every instance as **STUB** severity. STUB blocks shipping in all modes.

### 3A. Quick Scan

Check each changed file for bugs and security. Only HIGH/MEDIUM. End PASS or BLOCK.

### 3B. Standard Review

Read every changed file completely. Check bugs, security, performance, readability, missing tests, duplicate patterns. Only HIGH/MEDIUM. End PASS or BLOCK.

### 3C. Adversarial Grill

Before deep review, challenge scope:

1. Does similar code already exist?
2. Is this the smallest change that solves the problem?

Present:

```
A) Scope reduction
B) Full adversarial review
C) Compressed review — top 3 issues only
```

If A: suggest smaller scope and stop. If C: report only top 3.

For full review, read every changed file completely and challenge: edge cases, error handling, security, race conditions, validation at boundaries, breaking changes, data integrity, performance, readability, missing tests, duplicates.

For each issue:

- Severity: CRITICAL / HIGH / MEDIUM
- File and line
- Concrete failure scenario
- Resolution options A/B/C with one recommended

For each CRITICAL or HIGH issue, use AskUserQuestion before continuing.

List what was not reviewed.

Self-verification table:

| Claim             | File:Line             | Verified           |
| ----------------- | --------------------- | ------------------ |
| [finding summary] | [exact file and line] | yes / no / partial |

If a blocking claim cannot be verified to an exact file/line, remove it from blocking issues.

### 4. Agent dispatch (Mode B and C only)

Check agent existence (`ls .claude/agents/<name>.md`) before spawn. Missing optional agents skip silently.

Dispatch in parallel (single message, multiple Agent calls):

- Always: `code-reviewer` (required, must exist)
- Security-sensitive changes AND `security-reviewer` exists → spawn
- Hotpath signal matches (see below) AND `performance-reviewer` exists → spawn

**Performance-reviewer hotpath heuristic** (spawn ONLY if at least one matches):

- Stack `shopify-liquid` AND diff touches a Liquid file listed in `.agents/context/liquid-graph.json` `top_hubs` with `imported_by ≥ 5`
- Stack `nuxt-storyblok`/`nuxtjs`/`nextjs` AND diff contains: `useFetch`/`useAsyncData`/`v-for` with side-effects/`.map(` chains/composables in `composables/` `useState`/full-lib imports
- Stack `laravel`/`shopware` AND diff contains: `->where`/`::query`/raw SQL/loops over query results
- Universal: new DB call inside loop, full-library import where tree-shaking version exists, new event listener without cleanup
- User explicitly requests perf review

Pure docs/config/CSS-only diffs do NOT trigger performance-reviewer.

Merge agent findings, deduplicate overlaps.

### 5. Output (Diff Mode)

End report with PASS or BLOCK. After addressing findings, suggest `/commit` or `/pr`.

---

## Spec Mode (`--spec NNN`)

### S0. Stack-scan

If `.agents/context/STACK.md` exists and is newer than 24h, read it; otherwise spawn `context-scanner` (model: haiku).

```bash
find .agents/context/STACK.md -mtime -1 -print 2>/dev/null
```

Use its `stack`, `conventions`, `key_paths` output when judging ACs and reviewer scope.

### S1. Find the spec

If a number is given, open `specs/NNN-*.md`. Otherwise list specs with status `in-review` via `AskUserQuestion`. Spec must be `in-review`.

### S2. Read the spec

Read Goal, Steps, Acceptance Criteria, Files to Modify, Out of Scope. Note checked items.

### S3. Inspect code changes

```bash
bash .claude/scripts/spec-review-prep.sh $ARGUMENTS
```

Output includes branch detection, full diff, top 5 changed files, AC progress. Read the 5 most-changed files completely; review only diff hunks for the rest. Do not re-run `git diff`.

### S4. Review against spec

**S4a — Goal achievement**: verify Goal met, ACs against diff, Out-of-Scope violations. Verify each AC with commands and file reads.

**S4b — DoD**: check `.agents/context/CONVENTIONS.md` DoD section if it exists.

**S4c — Code quality** (existence-checked, missing optional agents skip silently):

- Always: `code-reviewer` (sonnet) — required.
- High-complexity AND `staff-reviewer` exists → parallel with code-reviewer.

**S4d — Conditional reviewers**:

- Auth/input/API/secrets AND `security-reviewer` → spawn.
- Hotpath signal matches (see Diff Mode section 4 heuristic) AND `performance-reviewer` → spawn. Pure docs/config/CSS diffs skip performance-reviewer.

Check agent existence via `ls .claude/agents/<name>.md`. Run all reviewers in parallel (single message, multiple Agent calls). Review stays on Sonnet — Opus only on explicit request.

**S4e — Doctor check**: use `DOCTOR CHECK` section from prep output. Any FAIL blocks APPROVED.

**S4f — Delta-Block check (brownfield only)**: If spec has `## Changes to Existing Behavior` block, verify each `### MODIFIED:` and `### REMOVED:` entry against the diff:

- `MODIFIED:` entries → diff must show changes to that component (file/function/hook), not just additions elsewhere.
- `REMOVED:` entries → diff must show deletion + migration path (e.g. `cleanup_known_orphans` entry, doc-scrub).
- Mismatch (delta says REMOVED but diff still keeps file) → block APPROVED, append fix to feedback.
- Greenfield specs without delta-block → skip S4f silently.

### S5. Verdict

**APPROVED** — all ACs met, agents PASS/CONCERNS:

1. Spec `**Status**` → `completed`, move file to `specs/completed/`.
2. Proceed to Finishing Gate.

**CHANGES REQUESTED** — agent FAIL or ACs not met:

1. Append `## Review Feedback` with fix instructions, status → `in-progress`.

**REJECTED** — critical security/regression:

1. Status → `blocked`, append feedback, suggest next steps.

### S6. Finishing Gate (APPROVED only)

`AskUserQuestion`:

1. **Merge to main** — `git checkout main && git merge BRANCH && git branch -d BRANCH`
2. **Push and create PR** — `git push -u origin BRANCH && gh pr create`
3. **Keep branch** — report name, no changes
4. **Discard** — confirm first, then `git checkout main && git branch -D BRANCH`

Clean up worktree after merge/push/discard if one exists.

### S7. Next Step

- APPROVED + merged: `> 📦 Naechster Schritt: /commit — Changes committen`
- APPROVED + PR: `> 📤 Naechster Schritt: gh pr create — Pull Request via CLI`
- CHANGES REQUESTED: `> 🔧 Naechster Schritt: Feedback umsetzen, dann /review --spec NNN erneut`
- REJECTED: `> 🔧 Naechster Schritt: Kritische Issues fixen, dann /review --spec NNN erneut`

---

## Rules

- **Read-only on code** — diff mode reports findings, spec mode also writes spec status/feedback (status field + `## Review Feedback` section + file move).
- Read actual code before commenting — never speculate.
- Focus on bugs/security/spec compliance over style.
- If no issues found, say so clearly.
- Never push or create PRs without explicit user choice.
