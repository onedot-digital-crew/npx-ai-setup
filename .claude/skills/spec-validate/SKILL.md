---
name: spec-validate
description: Validate a draft spec before execution — checks quality and readiness BEFORE implementation begins. Triggers on: `/spec-validate NNN`, "validate spec NNN", "is spec 042 ready to implement", "check if spec NNN is ready", "review the spec quality", "is this spec good enough to execute". Key distinction: spec-validate is for BEFORE coding starts. Does NOT trigger for reviewing a spec AFTER implementation (use spec-review), creating a spec, or running/executing a spec.
---

# Spec Validate — Score a Draft Before Execution

Validates a draft spec and reports whether it is strong enough for implementation.

## Process

1. **Find the spec**: open `specs/NNN-*.md` or the filename provided.

2. **Validate status**: only validate specs with `Status: draft`. Otherwise report the current status and stop.

3. **Load context**: read `.agents/context/CONVENTIONS.md` if present to calibrate expectations.

4. **Score the spec** on:
   - Goal clarity
   - Step decomposition
   - Dependency identification
   - Coverage completeness
   - Acceptance criteria quality
   - Scope coherence
   - Risk and blockers
   - File coverage
   - Out of scope clarity
   - Integration awareness

5. **Return a verdict**:
   - `PASS` if the spec is ready for `/spec-work`
   - `FAIL` with concrete improvement points if it is weak

## Rules

- Read-only. Do not edit the spec.
- Be strict. Weak specs should fail.
- Only report real gaps with actionable fixes.
