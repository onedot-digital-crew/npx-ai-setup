---
model: opus
mode: plan
allowed-tools: Read, Glob, Grep, Bash
---

Runs an adversarial code review blocking approval until all issues are resolved. Use before merging high-risk changes.

## Step 0: Scope Challenge

Before reading any code, challenge the scope of this review.

1. **Does this already exist?** Run Grep to search for similar functions, patterns, or logic already present in the codebase. If the change duplicates existing code, flag it immediately.
2. **Is this the minimum viable change?** Consider whether a smaller diff would solve the problem equally well.

Present the following three paths using AskUserQuestion:

```
A) Scope reduction — you identify a smaller version of this change and suggest it before proceeding
B) Full adversarial review — continue with the complete grill (all steps below)
C) Compressed review — quick pass, report top 3 issues only, no deep dive
```

Wait for the user's choice before proceeding. If A is chosen, suggest the smaller scope and stop. If C is chosen, skip to the issue list and report only the three most critical findings.

## Process

1. Run `git diff main...HEAD` (or `git diff` if on main) to identify all changes under review.
2. Read every changed file **completely** — not just the diff, the full file for context.
3. **What already exists** — Before flagging any issue, run Grep to find similar functions, patterns, or logic already present in the codebase. Document what was found. Do not flag existing patterns as new problems.
4. Act as a senior engineer who does NOT want to ship this. Challenge everything:
   - **Edge cases**: What happens with empty input, null, zero, max values, concurrent access?
   - **Error handling**: Are all error paths covered? Can errors propagate silently?
   - **Security**: Any injection, auth bypass, data exposure, SSRF, or path traversal?
   - **Race conditions**: Any shared state, async operations without proper synchronization?
   - **Missing validation**: Are inputs validated at system boundaries?
   - **Breaking changes**: Does this break any existing API, behavior, or contract?
   - **Data integrity**: Any risk of data loss, corruption, or inconsistency?
5. List every issue found. For each issue:
   - Severity: CRITICAL / HIGH / MEDIUM
   - File and line number
   - What could go wrong (concrete scenario, not theoretical)
   - Present resolution options in A/B/C format:

     ```
     **Option A** — [approach]: [tradeoff]
     **Option B** — [approach]: [tradeoff]
     **Option C** — [approach]: [tradeoff]
     -> Recommended: Option [X] because [reason]
     ```

   For each CRITICAL or HIGH issue, use AskUserQuestion to let the user choose which option to apply before continuing to the next issue.

6. **NOT reviewed** — At the end of the output, explicitly list what was out of scope for this review. Common exclusions: generated files in `dist/` or `.output/`, `node_modules/`, test fixtures, lock files (`package-lock.json`, `yarn.lock`), binary assets.
7. Verdict: BLOCK (has critical/high issues) or PASS (only medium or no issues).
8. **Self-verification table** — As the final step, double-check every single claim made in this review. Create a markdown table with the following columns:

   | Claim | File:Line | Verified |
   |-------|-----------|----------|
   | [each finding summarized in one line] | [exact file and line] | yes / no / partial |

   Every finding from step 5 must appear in this table. If a claim cannot be verified against an exact file and line, mark it as `no` and remove it from the blocking issues list.

## Rules
- Do NOT approve by default. The bar is: "Would I bet production uptime on this?"
- Do NOT make changes. Only report. The author fixes.
- Read the full file, not just the diff — bugs hide in context.
- Ignore style, formatting, and naming preferences — focus on correctness.
