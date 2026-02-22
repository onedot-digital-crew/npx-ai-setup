---
model: opus
mode: plan
allowed-tools: Read, Write, Glob, Grep, Bash, AskUserQuestion
---

Create a structured spec for the following task: $ARGUMENTS

## Phase 1 — Challenge the Idea

Before writing anything, critically evaluate this idea. Present your findings in the chat.

### 1a — Load Skills
If `.claude/skills/` exists, glob all skill directories and read each `prompt.md` (first 5 lines only). Identify which skills are relevant to this task — apply their guidance and constraints throughout the entire challenge and spec phases.

### 1b — Concept Fit
Read `docs/CONCEPT.md`. Then answer:
- Does this align with the project's core principles: **one command, zero config, template-based**?
- Does it fit the "templates not generation" distinction?
- Would this belong in the scaffolding layer, or is it scope creep?

Rate concept fit: **ALIGNED / BORDERLINE / MISALIGNED**

### 1c — Necessity
Challenge it hard:
- What problem does it solve? Is that problem real or hypothetical?
- What happens if we don't build it?
- Is this solving a problem users have reported, or one we imagined?

### 1d — Overhead & Maintenance Cost
- How much ongoing maintenance does this add?
- Does it increase tool surface area (more flags, more config, more docs)?
- Does it add complexity that slows down the "one command" promise?

### 1e — Simpler Alternatives
List 1-3 alternatives, including:
- A simpler version (scope reduction)
- A workaround that avoids building anything
- **"Don't build it"** — explicitly if it applies

Scan with Glob and Grep to check if similar functionality already exists.

If any installed skill already covers this, note it as an alternative.

### 1f — Verdict

Output the verdict clearly in the chat. Choose exactly one:

**GO** — Concept fits, clearly needed, manageable complexity. Proceed to spec.

**SIMPLIFY** — Merits exist but scope is too large. State the smaller version, then ask the user to confirm before proceeding to spec.

**REJECT** — Misaligned, unnecessary, or unjustified overhead. State reason. Do NOT create a spec. Stop here.

---

## Phase 2 — Write the Spec

Only proceed if verdict is GO or user confirmed a SIMPLIFY scope.

### Step 1 — Determine spec number
Scan `specs/` (including `specs/completed/`) for existing `NNN-*.md` files, find the highest number, increment by 1. Always use 3-digit zero-padded numbers (`001`, `002`, ..., `099`, `100`).

### Step 2 — Analyze the task
Read only the most relevant 2-3 source files. Do NOT read the entire codebase.

If `.claude/skills/` exists, glob the skill directories and read their `prompt.md` files (titles/first line only). List any skills relevant to this task in the spec **Context** section so they're referenced during execution.

### Step 3 — Create the spec file
Create `specs/NNN-short-description.md` using the structure below.

### Step 4 — Present the spec
Show the spec to the user for review and refinement.

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

## Constraints & Rules
- **Total spec: max 60 lines.** If you need more, split into multiple specs.
- **Goal**: 1 sentence. **Context**: 2-3 sentences.
- **Steps**: Flat checkbox list, max 8 items. NO nested sub-steps, NO sub-headings.
- **Acceptance Criteria**: max 5 items. **Out of Scope**: max 3 items.
- **Files to Modify**: max 5 words per file. **Notes section**: omit unless truly necessary.
- If a task has more than 8 steps, split it into 2 specs and note the dependency.
- Use today's date. Filename: lowercase with hyphens.
- Be specific in steps — include file paths where possible.
- Always create `specs/` and `specs/completed/` if they don't exist.
- Do NOT over-read the codebase. 2-3 files max for analysis.
