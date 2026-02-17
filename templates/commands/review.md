---
model: opus
mode: plan
allowed-tools: Read, Glob, Grep, Bash
---

Review all uncommitted changes and suggest improvements.

## Process

1. Run `git diff` and `git diff --staged` to see all pending changes.
2. For each changed file, read the full file to understand context around the changes.
3. Analyze each change for:
   - **Bugs**: Logic errors, off-by-one, null/undefined, race conditions
   - **Security**: Injection, XSS, secrets exposure, OWASP top 10
   - **Performance**: N+1 queries, unnecessary re-renders, memory leaks
   - **Readability**: Unclear names, missing context, overly complex logic
   - **Missing tests**: Changed logic without test coverage
4. Report findings with confidence levels (HIGH / MEDIUM / LOW).
5. Only report HIGH and MEDIUM confidence issues — skip stylistic preferences.

## Rules
- Do NOT make any changes. Only report findings.
- Read the actual code before commenting — never speculate.
- Focus on what matters: bugs and security over style.
- If no issues found, say so clearly.
