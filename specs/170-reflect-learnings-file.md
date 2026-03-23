# Spec: Reflect Smart Merge with Dedicated LEARNINGS.md

> **Spec ID**: 170 | **Created**: 2026-03-23 | **Status**: in-progress | **Complexity**: medium | **Branch**: —

## Goal
Move /reflect output from append-only writes into shared context files to a dedicated LEARNINGS.md with smart merge (ADD/UPDATE/REMOVE).

## Context
/reflect currently appends to STACK.md, ARCHITECTURE.md, CONVENTIONS.md, and CLAUDE.md. These files get overwritten by generate.sh during updates, losing all reflect entries. Solution: reflect writes to its own `.agents/context/LEARNINGS.md` which generate.sh never touches. Within LEARNINGS.md, reflect uses smart merge instead of append-only to prevent bloat.

### Verified Assumptions
- generate.sh does full Write (overwrite) of context files — Evidence: `lib/generate.sh:226-256` | Confidence: High | If Wrong: merge approach would be needed
- /reflect is the only command writing curated entries to context files — Evidence: grep of templates/commands/ | Confidence: High | If Wrong: other commands need same treatment
- No marker system exists to distinguish generated vs. manual content — Evidence: file inspection | Confidence: High | If Wrong: could leverage existing markers
- Template and active command files must stay in sync — Evidence: project convention | Confidence: High | If Wrong: only one location needs updating

## Steps
- [x] Step 1: Update `templates/commands/reflect.md` — change target from individual context files to `.agents/context/LEARNINGS.md`. Restructure Step 2 classification to use LEARNINGS.md sections (## Corrections, ## Conventions, ## Architecture, ## Stack). Keep CLAUDE.md Critical Rules as separate target for workflow/process rules.
- [x] Step 2: Implement smart merge in reflect Step 3+5 — when LEARNINGS.md exists, read it first. For each proposed entry: detect semantic overlap with existing entries. Present three operation types in Step 4 approval: `+ ADD` (new), `~ UPDATE` (refine existing), `- REMOVE` (stale/contradicted). Replace append-only rule with merge rule.
- [x] Step 3: Mirror all changes to `.claude/commands/reflect.md` (active command file).
- [ ] Step 4: Update CLAUDE.md template (`templates/CLAUDE.md`) — add `LEARNINGS.md` to the "Project Context" reference list with description "Session learnings from /reflect (persistent across updates)".
- [ ] Step 5: Update active `CLAUDE.md` — add same LEARNINGS.md reference.

## Acceptance Criteria

### Truths
- [ ] "/reflect writes new entries to .agents/context/LEARNINGS.md, not to STACK.md/ARCHITECTURE.md/CONVENTIONS.md"
- [ ] "/reflect proposes UPDATE and REMOVE operations for existing LEARNINGS.md entries, not just ADD"
- [ ] "generate.sh regeneration does not touch LEARNINGS.md"

### Artifacts
- [ ] `.agents/context/LEARNINGS.md` — referenced in CLAUDE.md Project Context section

### Key Links
- [ ] `templates/commands/reflect.md` → `.agents/context/LEARNINGS.md` as write target
- [ ] `templates/CLAUDE.md` → `.agents/context/LEARNINGS.md` in Project Context list

## Files to Modify
- `templates/commands/reflect.md` — redirect output + smart merge logic
- `.claude/commands/reflect.md` — mirror template changes
- `templates/CLAUDE.md` — add LEARNINGS.md reference
- `CLAUDE.md` — add LEARNINGS.md reference

## Out of Scope
- Changes to generate.sh or /analyze (they keep their overwrite behavior)
- Migration of existing reflect entries from context files into LEARNINGS.md
- CLAUDE.md Critical Rules target (stays as-is — process rules still go there)
