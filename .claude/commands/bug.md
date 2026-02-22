---
model: sonnet
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
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
- Run existing tests if available (`npm test`, `npx vitest`, etc.)
- Manually verify the fix addresses the reported symptom
- Check for regressions in adjacent code paths

## Rules
- Fix only what is broken. No scope creep.
- If the bug is unclear or cannot be reproduced, ask the user before writing any code.
- If the root cause requires architectural changes, stop and recommend `/spec` instead.
