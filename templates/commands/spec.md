---
allowed-tools: Read, Write, Glob, Grep, Bash, AskUserQuestion
---

Create a structured spec for the following task: $ARGUMENTS

## Process

1. **Determine spec number**: Scan `specs/` (including `specs/completed/`) for existing `NNN-*.md` files, find the highest number, and increment by 1. If no specs exist, start at `001`. Always use 3-digit zero-padded numbers (`001`, `002`, ..., `010`, ..., `099`, `100`).

2. **Analyze the task**: Based on the task description above, read relevant source files to understand:
   - Which files will be affected
   - What the current behavior is
   - What dependencies or risks exist

3. **Create the spec file**: Create `specs/NNN-short-description.md` using this structure:

```markdown
# Spec: [Clear Title]

> **Spec ID**: NNN | **Created**: YYYY-MM-DD | **Status**: draft

## Goal
[One sentence: what is the desired outcome?]

## Context
[Why is this needed? What triggered this task?]

## Steps

### Step 1: [Title]
- [ ] Detail A
- [ ] Detail B

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Files to Modify
- `path/to/file` - reason

## Out of Scope
- What is NOT part of this task

## Notes
- Technical hints, dependencies, risks
```

4. **Present the spec** to the user for review and refinement.

## Rules
- Use today's date for the Created field
- Keep the short-description in the filename lowercase with hyphens
- Be specific in steps — include file paths and function names where possible
- List ALL files that will be modified
- Acceptance criteria must be verifiable (checkboxes)
- Always create the `specs/` directory and `specs/completed/` if they don't exist

## Completing a Spec

When the user confirms a spec is done:
1. Update the status from `draft` to `completed`
2. Move the file to `specs/completed/NNN-short-description.md`
