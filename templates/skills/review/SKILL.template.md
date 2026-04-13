---
name: review
description: Reviews uncommitted changes with selectable intensity. Use before committing or merging.
user-invocable: true
effort: medium
model: sonnet
disable-model-invocation: true
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
---

Reviews uncommitted changes with selectable intensity. Use before committing or merging.
Note: Mode C benefits from Opus for maximum depth.

## Process

### 0. Select intensity

Ask the user which review mode to run:

```
AskUserQuestion: Which review intensity?
A) Quick Scan — bugs + security, HIGH/MEDIUM issues only (~1 min)
B) Standard Review — bugs, security, performance, readability, tests, duplicates (~3 min)
C) Adversarial Grill — scope challenge, resolution options, self-verification table (~10 min)
```

### 1. Collect diff

Run:

```bash
!bash .claude/scripts/review-prep.sh
```

Fallbacks if needed:
- `!git diff`
- `!git diff --staged`
- `!git diff main...HEAD 2>/dev/null`

If all diffs are empty, report "No changes found." and stop.

### 2. Stub scan

Before analysis, scan for placeholders:
- `throw new Error("not implemented")`, `TODO`, `FIXME`, stub returns
- AI boilerplate comments
- Empty catch blocks or skeleton classes with no behavior

Flag every instance as **STUB** severity. STUB blocks shipping in all modes.

### 3A. Quick Scan

Check each changed file for:
- Bugs
- Security

Only report HIGH and MEDIUM confidence issues. End with PASS or BLOCK.

### 3B. Standard Review

Read every changed file completely. Check for:
- Bugs
- Security
- Performance
- Readability
- Missing tests
- Duplicate patterns

Only report HIGH and MEDIUM confidence issues. End with PASS or BLOCK.

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

If A: suggest smaller scope and stop. If C: report only the top 3 issues.

For full review, read every changed file completely and challenge:
- Edge cases
- Error handling
- Security
- Race conditions
- Validation at boundaries
- Breaking changes
- Data integrity
- Performance, readability, missing tests, duplicates

For each issue, report:
- Severity: CRITICAL / HIGH / MEDIUM
- File and line
- Concrete failure scenario
- Resolution options A/B/C with one recommended option

For each CRITICAL or HIGH issue, use AskUserQuestion before continuing.

List what was not reviewed.

Create a self-verification table:

| Claim | File:Line | Verified |
|-------|-----------|----------|
| [finding summary] | [exact file and line] | yes / no / partial |

If a blocking claim cannot be verified to an exact file and line, remove it from blocking issues.

### 4. Agent dispatch (Mode B and C only)

After the manual review, dispatch relevant agents in parallel:
- Always: `code-reviewer`
- If security-sensitive changes: `security-reviewer`
- If hot path changes: `performance-reviewer`

Merge agent findings into the final report and deduplicate overlaps.

## Rules
- Do NOT make changes. Only report findings.
- Read actual code before commenting.
- Focus on bugs and security over style.
- If no issues are found, say so clearly.

## Next Step

After addressing findings, run `/commit` or `/pr`.
