---
allowed-tools: Read, Write, Glob, Grep, Bash, AskUserQuestion
---

Create a structured spec for the following task: $ARGUMENTS

## Process

1. **Determine spec number**: Scan `specs/` (including `specs/completed/`) for existing `NNN-*.md` files, find the highest number, and increment by 1. If no specs exist, start at `001`. Always use 3-digit zero-padded numbers (`001`, `002`, ..., `010`, ..., `099`, `100`).

2. **Analyze the task**: Read only the most relevant 2-3 source files to understand the change. Do NOT read the entire codebase.

3. **Create the spec file**: Create `specs/NNN-short-description.md` using the structure below.

4. **Present the spec** to the user for review and refinement.

## Spec Template

```markdown
# Spec: [Clear Title]

> **Spec ID**: NNN | **Created**: YYYY-MM-DD | **Status**: draft

## Goal
[One sentence]

## Context
[2-3 sentences max. Why is this needed?]

## Steps
- [ ] Step 1: description
- [ ] Step 2: description
- [ ] Step 3: description

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Files to Modify
- `path/to/file` - reason

## Out of Scope
- What is NOT part of this task
```

## Size Constraints (CRITICAL)
- **Total spec: max 60 lines.** If you need more, the task should be split into multiple specs.
- **Goal**: 1 sentence
- **Context**: 2-3 sentences
- **Steps**: Flat checkbox list, max 8 items. NO nested sub-steps, NO sub-headings per step.
- **Acceptance Criteria**: max 5 items
- **Files to Modify**: just the list, no explanations longer than 5 words per file
- **Out of Scope**: max 3 items
- **Notes section**: omit unless truly necessary
- If a task has more than 8 steps, split it into 2 specs and note the dependency.

## Rules
- Use today's date for the Created field
- Keep the short-description in the filename lowercase with hyphens
- Be specific in steps — include file paths where possible
- Acceptance criteria must be verifiable (checkboxes)
- Always create the `specs/` directory and `specs/completed/` if they don't exist
- Do NOT over-read the codebase. 2-3 files max for analysis.

## Completing a Spec

When the user confirms a spec is done:
1. Update the status from `draft` to `completed`
2. Move the file to `specs/completed/NNN-short-description.md`
