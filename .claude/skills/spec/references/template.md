# Spec Template

```markdown
# Spec: [Clear Title]

> **Spec ID**: NNN | **Created**: YYYY-MM-DD | **Status**: draft | **Complexity**: medium | **Branch**: —

## Goal
[One sentence]

## Context
[2-3 sentences. Why needed, what approach was chosen, relevant skills if any.]

### Verified Assumptions
- [Statement] — Evidence: `path/to/file:NN` | Confidence: High/Medium | If Wrong: [consequence]

## Stack Coverage
- **Profiles affected**: nuxt-storyblok, shopify-liquid (or "all" / "single: laravel")
- **Per-stack difference**: [what changes per stack, if any]

## Steps
- [ ] Step 1: `path/to/file` — description
- [ ] Step 2: `path/to/file` — description

## Acceptance Criteria
- [ ] "[observable behavior verifiable by running a command or reading output]"

## Files to Modify
- `path/to/file` — reason

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
On `completed`: ALWAYS move file `specs/NNN-*.md` → `specs/completed/NNN-*.md`. Status without move = drift (Type B).
