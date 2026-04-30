# Agent Dispatch Table

Full agent delegation reference. See `.claude/rules/agents.md` for model routing rules and delegation criteria.

## When to Delegate

Use agents for focused, isolated work. Call them directly — do not ask the user first.

| Agent                | Trigger                                                                     | Model  |
| -------------------- | --------------------------------------------------------------------------- | ------ |
| bash-runner          | ≥3 Bash calls without architectural decisions (jq, find, log inspect)       | haiku  |
| context-scanner      | Stack profile detection / context-files scan                                | haiku  |
| implementer          | ≥2 Edit/Write in `lib/`, `templates/`, `.claude/scripts/`, `src/`, `specs/` | sonnet |
| code-reviewer        | After `implementer`-run or before merge                                     | sonnet |
| performance-reviewer | Hot-path edits, loops, data fetching, bundle-affecting code                 | sonnet |
| security-reviewer    | Auth changes, user input, secrets, OWASP, dependency updates                | sonnet |
| test-generator       | New functions/modules without test coverage                                 | sonnet |
| staff-reviewer       | Architecture skepticism on high-complexity changes (`Complexity: high`)     | opus   |

## When NOT to Delegate

- Single-file reads or searches — use Read/Glob/Grep directly
- Trivial fixes (typos, config tweaks) — faster to do inline
- Tasks requiring fewer than 3 tool calls — agent startup overhead exceeds the work
- Follow-up edits after a review — apply fixes yourself, do not re-delegate

## Scope Limits

- Reviewers (`code-reviewer`, `performance-reviewer`, `security-reviewer`, `staff-reviewer`) report findings — they do not fix
- `test-generator` writes tests only; never modifies source code
- `staff-reviewer` runs in plan mode — cannot edit files
- `bash-runner` has no Edit/Write tools — execution + read-only inspection only
