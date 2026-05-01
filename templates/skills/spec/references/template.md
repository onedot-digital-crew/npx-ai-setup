# Spec Template

```markdown
# Spec: [Clear Title]

> **Spec ID**: NNN | **Created**: YYYY-MM-DD | **Status**: draft | **Complexity**: medium | **Branch**: —

<!-- Optional: depends_on lists spec IDs that must be completed before this spec can start. Tools (spec-board, spec-work) read this and block out-of-order execution. Omit if no dependencies. -->
<!-- depends_on: [654, 655] -->

## Goal
[One sentence]

## Context
[2-3 sentences. Why needed, what approach was chosen, relevant skills if any.]

### Verified Assumptions
- [Statement] — Evidence: `path/to/file:NN` | Confidence: High/Medium | If Wrong: [consequence]

## Stack Coverage
- **Profiles affected**: nuxt-storyblok, shopify-liquid (or "all" / "single: laravel")
- **Per-stack difference**: [what changes per stack, if any]

## Architecture (optional — heavy specs)
<!-- Cross-layer or new abstractions. Skip for single-file specs. -->
- [Component / module name] — [responsibility]
- Data flow: [A → B → C]

## Tech Stack (optional — when spec introduces a new dep)
- [lib@version] — [why chosen]

## Steps
- [ ] Step 1: `path/to/file` — description → verify: `[command or expected output]`
- [ ] Step 2: `path/to/file` — description → verify: `[check]`

## Acceptance Criteria
- [ ] "[observable behavior verifiable by running a command or reading output]"

## Files to Modify
- `path/to/file` — reason

## Changes to Existing Behavior (optional, brownfield only)
<!-- Include this block ONLY if spec modifies/removes >2 existing files. Skip for greenfield. -->
### MODIFIED: <component>
- Before: [behavior]
- After: [behavior]

### REMOVED: <component>
- Reason: [why removed]
- Migration: [how update-path handles it]

## Out of Scope
- What is NOT part of this task (max 3 items)
```

## Constraints

- Auto-split at >12 steps or cross-layer architecture (frontend + backend + DB). No hard line cap — coherence > brevity.
- Goal: 1 sentence. Context: 2-3 sentences. Out of Scope: max 3 items.
- Every step must reference a file path. No abstract steps.
- Use today's date (`date +%Y-%m-%d`). Filename: `NNN-lowercase-hyphens.md`.
- Create `specs/` and `specs/completed/` if missing.
- After split: cross-reference NNN ↔ NNN+1, note which runs first.

## Status Lifecycle (canonical vocab)

`Status:` MUST be one of: `draft` → `in-progress` → `in-review` → `completed` (or `blocked` from any state).
NEVER use synonyms like `done`, `finished`, `closed`, `merged`, `resolved` — `spec-board.sh` only buckets the canonical set; anything else hides the spec from the board.
On `completed`: ALWAYS move the file from `specs/NNN-*.md` to `specs/completed/NNN-*.md`. Status without move = drift (Type B).
