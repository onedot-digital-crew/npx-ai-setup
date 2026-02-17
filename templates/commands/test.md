---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

Run the project's test suite and fix any failures.

## Process

1. **Detect test command**: Check `package.json` scripts for `test`, `test:unit`, `vitest`, or `jest`. If none found, check for `vitest.config.*` or `jest.config.*` files.
2. **Run tests**: Execute the detected test command.
3. **If all pass**: Report success and stop.
4. **If failures**: For each failing test:
   - Read the failing test file to understand what it expects
   - Read the source file being tested
   - Fix the **source code** (not the tests) to make tests pass
   - Re-run tests
5. **Repeat** until all tests pass or 3 attempts are exhausted.
6. If still failing after 3 attempts, report what was tried and what remains broken.

## Rules
- Fix source code, not tests (unless the test itself has a clear bug).
- Do not delete or skip failing tests.
- Do not install new dependencies without asking.
- If no test framework is detected, tell the user and stop.
