---
model: opus
mode: plan
allowed-tools: Read, Glob, Grep, Bash
---

Reviews uncommitted changes and reports bugs, security issues, and improvements. Use before committing to catch issues.

## Context

- Current branch: `!git rev-parse --abbrev-ref HEAD`
- Unstaged changes: `!git diff`
- Staged changes: `!git diff --staged`
- Branch diff vs main: `!git diff main...HEAD 2>/dev/null`

## Process

1. Analyze all changes shown in Context above. If all diffs are empty, report "No changes found." and stop.
2. For each changed file, read the full file to understand context around the changes.
3. **What already exists** — Before reporting any finding, run one Grep pass across the codebase to check for similar functions, patterns, or logic. If duplicated logic is detected, note it explicitly: "Similar pattern already exists at [file:line] — verify this is intentional and not a copy-paste." Do not flag existing patterns as new problems.
4. Analyze each change for:
   - **Bugs**: Logic errors, off-by-one, null/undefined, race conditions
   - **Security**: Injection, XSS, secrets exposure, OWASP top 10
   - **Performance**: N+1 queries, unnecessary re-renders, memory leaks
   - **Readability**: Unclear names, missing context, overly complex logic
   - **Missing tests**: Changed logic without test coverage
5. Report findings with confidence levels (HIGH / MEDIUM / LOW).
6. Only report HIGH and MEDIUM confidence issues — skip stylistic preferences.

## Rules
- Do NOT make any changes. Only report findings.
- Read the actual code before commenting — never speculate.
- Focus on what matters: bugs and security over style.
- If no issues found, say so clearly.
