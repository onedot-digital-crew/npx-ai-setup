---
paths:
  - "**/*.test.*"
  - "**/*.spec.*"
  - "**/tests/**"
  - "**/__tests__/**"
  - "**/*.test.sh"
---

# Testing Rules

## TDD Cycle (Mandatory)

1. **RED** — Write one minimal failing test for the desired behavior. Must fail because the feature doesn't exist, not a syntax error.
   - Python: `test_<function>_<scenario>_<expected>` | TS: `it("should <behavior> when <condition>")`
2. **VERIFY RED** — Run the test. Passes already? Rewrite it — it tests nothing.
3. **GREEN** — Simplest code that passes. Hardcoding is fine at this stage.
4. **VERIFY GREEN** — Run all tests, not just the new one.
5. **REFACTOR** — Improve quality. Tests must stay green. No new behavior.

When TDD applies: new functions, bug fixes (reproduce first), behavior changes.
Skip: documentation, config-only, formatting-only.

## Zero Tolerance for Failing Tests

Run the full suite, not just files you touched. "Pre-existing failure" is not an excuse — fix it.
A green suite is a prerequisite, not a nice-to-have.

## Mock Audit on Dependency Changes

When adding a new dependency to an existing function (new subprocess, I/O, API call):
- `Grep` for the function name in test files
- Add mocks for the new dependency to EVERY existing test
- Tests passing locally with real binaries fail in CI — this is the #1 cause of CI-only failures

## Mocking

Only mock: network calls, external services, file system side effects, time-dependent behavior.
Mock at module level (where imported, not where defined). Test > 1s = likely unmocked I/O.
Before mocking: understand what the dependency actually does. A mock that doesn't reflect reality is a lie — tests pass against the lie, then fail against reality.

