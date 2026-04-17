---
paths:
  - "**/*.test.*"
  - "**/*.spec.*"
  - "**/tests/**"
  - "**/__tests__/**"
  - "**/*.test.sh"
---

# Testing Rules

## Zero Tolerance

Run the full suite. "Pre-existing failure" is no excuse — fix it.

## Mock Audit on Dependency Changes

When adding a dependency (subprocess, I/O, API call) to an existing function:
- Grep for the function in test files
- Add mocks to EVERY existing test — #1 cause of CI-only failures

## Mocking Boundaries

Mock only: network, external services, FS side effects, time. At module level.
Test > 1s = likely unmocked I/O. A wrong mock is a lie — tests pass against the lie, fail in reality.

## Naming + Assertions

Descriptive names: `it("returns null when user ID does not exist")`.
Assert specific values: `toBe(42)`, not `toBeTruthy()`. Cover empty/null/boundary/error.

## Anti-Patterns

- Dependent test order
- Asserting mocks were called instead of outputs
- Incomplete mocks (missing fields)
- Unmocked env binaries (won't exist in CI)
- Test-only methods in production classes
