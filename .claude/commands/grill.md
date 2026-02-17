---
model: opus
mode: plan
allowed-tools: Read, Glob, Grep, Bash
---

Adversarial code review. Do NOT approve until every issue is resolved.

## Process

1. Run `git diff main...HEAD` (or `git diff` if on main) to identify all changes under review.
2. Read every changed file **completely** — not just the diff, the full file for context.
3. Act as a senior engineer who does NOT want to ship this. Challenge everything:
   - **Edge cases**: What happens with empty input, null, zero, max values, concurrent access?
   - **Error handling**: Are all error paths covered? Can errors propagate silently?
   - **Security**: Any injection, auth bypass, data exposure, SSRF, or path traversal?
   - **Race conditions**: Any shared state, async operations without proper synchronization?
   - **Missing validation**: Are inputs validated at system boundaries?
   - **Breaking changes**: Does this break any existing API, behavior, or contract?
   - **Data integrity**: Any risk of data loss, corruption, or inconsistency?
4. List every issue found. For each issue:
   - Severity: CRITICAL / HIGH / MEDIUM
   - File and line number
   - What could go wrong (concrete scenario, not theoretical)
   - Suggested fix
5. Verdict: BLOCK (has critical/high issues) or PASS (only medium or no issues).

## Rules
- Do NOT approve by default. The bar is: "Would I bet production uptime on this?"
- Do NOT make changes. Only report. The author fixes.
- Read the full file, not just the diff — bugs hide in context.
- Ignore style, formatting, and naming preferences — focus on correctness.
