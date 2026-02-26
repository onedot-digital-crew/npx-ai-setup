---
model: sonnet
argument-hint: "[bug description]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task
---

Investigate and fix the following bug: $ARGUMENTS

## Process

### 1. Reproduce
- Identify the exact condition that triggers the bug
- If steps to reproduce are unclear, ask before proceeding
- Locate the relevant code path (use Grep/Glob, read 2-3 files max)

### 2. Root cause
- Trace the execution path to find where behavior diverges from expected
- State the root cause in one sentence before fixing

### 3. Fix
- Make the minimal change that fixes the root cause
- Do NOT refactor surrounding code or add unrelated improvements
- If the fix touches more than 3 files, stop and suggest creating a spec instead

### 4. Verify
Spawn `verify-app` via Task tool:
> "Verify the bug fix. Run the test suite if available. Run the build if available. Report PASS or FAIL."
- If **FAIL**: report the output and stop. Do NOT proceed to review. Suggest: re-investigate the root cause.
- If **PASS**: continue to Step 5.

### 5. Review
Spawn `code-reviewer` via Task tool. Pass the changed files and a one-line description of the fix.
- Verdict **PASS** or **CONCERNS**: done, report fix as complete.
- Verdict **FAIL**: flag for manual review, report the issues.

## Rules
- Fix only what is broken. No scope creep.
- If the bug is unclear or cannot be reproduced, ask the user before writing any code.
- If the root cause requires architectural changes, stop and recommend `/spec` instead.
