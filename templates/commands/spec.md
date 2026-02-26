---
model: opus
mode: plan
argument-hint: "[task description]"
allowed-tools: Read, Write, Glob, Grep, Bash, AskUserQuestion
---

Create a structured spec for the following task: $ARGUMENTS

## Phase 1 — Challenge & Think Through

Before writing anything: challenge the idea hard, then think it completely through. Present findings in the chat.

### 1a — Load Skills
If `.claude/skills/` exists, glob all skill directories and read each `SKILL.md` (first 5 lines only). Apply their guidance throughout the entire process.

### 1b — Clarify
If the request is ambiguous or underspecified, ask 1-3 focused questions before proceeding. Wait for answers. Skip if the task is clear.

### 1c — Concept Fit
Read `docs/CONCEPT.md` if it exists. Answer:
- Does this align with the project's core principles?
- Is it in scope for this codebase/tool?
- Would this belong in the core, or is it a plugin/workaround?

Rate: **ALIGNED / BORDERLINE / MISALIGNED**. If MISALIGNED → **REJECT** immediately.

### 1d — Necessity
- What specific problem does this solve? Is it real or hypothetical?
- What breaks or stays painful if we don't build it?
- Who reported this problem — users, or us?

### 1e — Think It Through
Sketch the full implementation mentally before writing the spec.
**Use `AskUserQuestion` at any decision point** — don't assume, ask. Multiple rounds are fine.

**Implementation path:**
- Which files/systems change? What exactly happens in each?
- How does it integrate with existing code — what calls what?
- What are the data flows or state changes?

**Edge cases & failure modes:**
- What inputs or states could break this?
- What happens when it fails — is it recoverable?
- What are the implicit dependencies or side effects?

**Hidden complexity:**
- What looks simple but isn't?
- What will be hard to test or debug later?
- What will be annoying to maintain in 6 months?

### 1f — Overhead & Risk
- Maintenance burden added?
- Does it increase surface area (more config, more flags, more docs)?
- What's the risk if the implementation is wrong?

### 1g — Simpler Alternatives
List 1-3 alternatives:
- A smaller scope version
- A workaround that avoids building anything
- **"Don't build it"** — explicitly if it applies

Scan with Glob and Grep for similar existing functionality. Check installed skills for overlap.

### 1h — Verdict

Present a clear summary of the thinking above, then choose exactly one:

**GO** — Needed, fits, complexity is understood. The implementation sketch from 1e becomes the basis for the spec steps.

**SIMPLIFY** — Merits exist but scope is too large. State the reduced scope. Ask user to confirm before proceeding.

**REJECT** — Misaligned, unnecessary, or risk outweighs benefit. State reason. Stop here.

---

## Phase 2 — Write the Spec

Only proceed if verdict is GO or user confirmed a SIMPLIFY scope.

### Step 1 — Determine spec number
Scan `specs/` (including `specs/completed/`) for existing `NNN-*.md` files, find the highest number, increment by 1. Use 3-digit zero-padded numbers.

### Step 2 — Analyze the task
Read the 2-3 most relevant source files. Use the implementation sketch from Phase 1e — do not re-analyze from scratch.

List any relevant installed skills in the spec Context section.

### Step 3 — Create the spec file
Translate the Phase 1e implementation sketch into spec steps. Steps should reflect actual implementation path, not generic placeholders.

### Step 4 — Present the spec
Show the spec to the user for review and refinement.

### Step 5 — Branch
Use `AskUserQuestion` to ask: "Branch fuer diese Spec erstellen?"
- **Ja** — run `git checkout -b spec/NNN-<slug>` (slug = spec filename without number prefix)
- **Nein** — skip, user bleibt auf aktuellem Branch
- **Spaeter** — skip, user entscheidet selbst

## Spec Template

```markdown
# Spec: [Clear Title]

> **Spec ID**: NNN | **Created**: YYYY-MM-DD | **Status**: draft | **Branch**: —

<!-- Status lifecycle: draft → in-progress → in-review → completed (or blocked at any stage) -->
<!-- Branch is set automatically by /spec-work-all (worktree mode) or manually -->

## Goal
[One sentence]

## Context
[2-3 sentences. Why needed, what approach was chosen, relevant skills if any.]

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
- **Total spec: max 60 lines.** If more, split into multiple specs.
- **Goal**: 1 sentence. **Context**: 2-3 sentences.
- **Steps**: Flat checkbox list, max 8 items. No nested sub-steps.
- **Acceptance Criteria**: max 5 items. **Out of Scope**: max 3 items.
- Steps must come from the Phase 1e implementation sketch — be specific, include file paths.
- Use today's date. Filename: lowercase with hyphens.
- Always create `specs/` and `specs/completed/` if they don't exist.
