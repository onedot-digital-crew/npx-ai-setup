---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Runs the project test suite and fixes failures in source code. Use when tests are failing or before submitting changes.

## Process

1. **Detect test command**: Check `package.json` scripts for `test`, `test:unit`, `vitest`, or `jest`. If none found, check for `vitest.config.*` or `jest.config.*` files.
2. **Run tests**: Execute the detected test command.
3. **If all pass**: Report success and stop.
4. **If failures**: For each failing test:
   - Read the failing test file to understand what it expects
   - Read the source file being tested
   - Fix the **source code** (not the tests) to make tests pass
   - Re-run tests
5. **Repeat** with explicit attempt tracking:
   - **Attempt 1**: Apply fixes, re-run tests. If all pass: report success and stop.
   - **Attempt 2**: If still failing, read new error output, apply further fixes, re-run tests. If all pass: report success and stop.
   - **Attempt 3**: If still failing, apply one final round of fixes, re-run tests. If all pass: report success and stop.
6. If still failing after Attempt 3, report what was tried in each attempt and what remains broken.

## Rules
- Fix source code, not tests (unless the test itself has a clear bug).
- Do not delete or skip failing tests.
- Do not install new dependencies without asking.
- If no test framework is detected, tell the user and stop.
