---
name: spec
description: Create a new spec for a task. Use when the user says `/spec ...`, "create a spec for X", "write a spec for X", "spec out X", or "plan X as a spec".
---

# Spec — Create a Structured Implementation Plan

Creates a spec file in `specs/NNN-title.md` for an approved task before coding begins.

## Process

1. **Challenge the idea**:
   - What specific problem does this solve?
   - Is it in scope for this codebase?
   - What breaks if we do not build it?

2. **Clarify if needed**: ask 1-3 focused questions if the task is ambiguous. Wait for answers.

3. **Determine the next spec number**: run `ls specs/*.md | sort | tail -1` to find the highest number, increment by 1.

4. **Think through implementation**:
   - Which files change?
   - What is the exact change in each file?
   - Edge cases and failure modes?
   - Hidden complexity?

5. **Write the spec file** `specs/NNN-title.md` using this structure:
   - Goal
   - Context
   - Steps
   - Acceptance Criteria
   - Files to Modify
   - Out of Scope

## Rules

- Steps must be atomic.
- Acceptance criteria must be directly verifiable.
- Keep specs under 60 lines and 8 steps.
- Status stays `draft` until execution begins.
