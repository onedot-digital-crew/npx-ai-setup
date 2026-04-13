---
name: spec
description: "Create a new spec for a task."
user-invocable: true
effort: high
model: opus
argument-hint: "<task description>"
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
  - AskUserQuestion
  - Agent
---

Creates a structured spec for the task: $ARGUMENTS. Use before implementing any multi-file or architectural change.

## Phase 1 — Triage and think through

### 1a. Load skills

If `.claude/skills/` exists, read the first 5 lines of each `SKILL.md` and apply relevant guidance.

### 1b. Detect input type and clarify

- If `$ARGUMENTS` is an existing `.md` file: read it and ask only for missing implementation details.
- If `$ARGUMENTS` is plain text: ask 1-3 focused questions only if ambiguity blocks a good spec.

### 1c. Quick triage

Read `.agents/context/CONCEPT.md` if present. Reject if the task is clearly misaligned.

If the work touches more than 5 files, adds a dependency or system, or changes architecture, use AskUserQuestion to recommend `/challenge` first.

### 1c.5. Challenge gate

Glob relevant source files.
- ≤10 results: read the top 3 directly
- >10 results: spawn a Haiku read-only subagent to return the 3 most relevant files and snippets

Answer four questions:
1. Is there existing code that already solves this?
2. Does the approach fight an established pattern?
3. What is the simplest alternative?
4. Where is the 6-month maintenance pain?

Present:

```
Challenge: [statement]
Quelle: path/to/file:NN
Empfehlung: [Weiter / Scope ändern / Ansatz überdenken]
```

Ask whether to continue, adjust the approach, or stop.

### 1d. Think it through

Sketch the implementation before writing:
- Files and systems touched
- Integration and data flow
- Edge cases and failure behavior
- Hidden complexity and test difficulty
- Impact surface + risk

Do a code-flow analysis for each key function:
1. Who calls it and what guards gate execution
2. What state it already sets
3. What error paths exist

Show a short list in chat, max 5 functions.

Each spec step must introduce a real new code change. Remove redundant steps. Add steps for blocked flows or missing error handling.

### 1e. Surface assumptions

Scan 3-5 relevant files. For each implicit assumption capture:
`Statement / Evidence / Confidence / If Wrong`

Only ask for confirmation when the assumption materially changes scope or implementation.

## Phase 2 — Write the spec

### 1. Determine spec number

Scan `specs/` and `specs/completed/`, find the highest `NNN-*.md`, increment by 1, use 3-digit zero padding.

### 2. Analyze the task

Read the 2-3 most relevant source files. Reuse the Phase 1 sketch. List relevant installed skills in the Context section.

### 3. Create the spec file

Translate the sketch into concrete steps with actual file paths.

Auto-split if:
- Draft exceeds 60 lines or 8 steps
- Steps span fundamentally different architectural layers

If split is needed, create `NNN` and `NNN+1`, cross-reference them, and note dependencies.

After drafting, validate each step:
- Existing code already does this → remove step
- Guard blocks the flow → add a guard-removal step
- Error path is unhandled → add explicit handling step

### 4. Present the spec

Show the draft for review and refinement.

### 5. Branch

Ask whether to create `spec/NNN-<slug>` now, later, or not at all.

## Spec Template

```markdown
# Spec: [Clear Title]

> **Spec ID**: NNN | **Created**: YYYY-MM-DD | **Status**: draft | **Complexity**: medium | **Branch**: —

## Goal
[One sentence]

## Context
[2-3 sentences. Why needed, what approach was chosen, relevant skills if any.]

### Verified Assumptions
- [Statement] — Evidence: `path/to/file` | Confidence: High | If Wrong: [consequence]

## Steps
- [ ] Step 1: description
- [ ] Step 2: description

## Acceptance Criteria
- [ ] "[observable behavior verifiable by running a command]"

## Files to Modify
- `path/to/file` - reason

## Out of Scope
- What is NOT part of this task
```

## Constraints & Rules
- Max 60 lines total; split if larger.
- Goal: 1 sentence. Context: 2-3 sentences.
- Max 8 flat steps. No nested steps.
- Max 5 acceptance criteria and 3 out-of-scope items.
- Steps must come from Phase 1 and include file paths.
- Use today's date and a lowercase hyphenated filename.
- Create `specs/` and `specs/completed/` if missing.

## Next Step

Run `/spec-validate NNN` or continue with `/spec-work NNN`.
