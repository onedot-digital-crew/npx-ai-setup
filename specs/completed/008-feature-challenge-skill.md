# Spec: Feature Challenge & Brainstorm Skill

> **Spec ID**: 008 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Create a local `/challenge` skill that critically questions proposed features before implementation begins.

## Context
New feature ideas often get implemented without questioning whether they're truly needed, add unnecessary overhead, or solve the wrong problem. A dedicated skill acts as a "devil's advocate" — forcing structured critical thinking, including an explicit "don't build it" option, before any code is written. This skill is project-local (`.claude/commands/`), not a template for target projects.

## Steps
- [x] Step 1: Create `.claude/commands/challenge.md` with structured challenge prompt
- [x] Step 2: Include phases: (1) restate the idea, (2) **concept fit** — does it align with "one command, zero config, template-based"? (3) **is it necessary at all?** (4) overhead/maintenance cost, (5) complexity/risks, (6) simpler alternatives or "don't build it", (7) verdict
- [x] Step 3: Accept `$ARGUMENTS` as the feature description to challenge
- [x] Step 4: Use `model: sonnet` and read-only tools (`Read, Glob, Grep`) — no edits
- [x] Step 5: Skill reads `docs/CONCEPT.md` to validate concept alignment; reads codebase for overlap
- [x] Step 6: End with GO / SIMPLIFY / REJECT — REJECT explicitly covers "unnecessary overhead"

## Acceptance Criteria
- [x] `/challenge "add feature X"` produces a structured critical analysis
- [x] Concept fit is explicitly evaluated against `docs/CONCEPT.md`
- [x] Skill checks for overlap with existing functionality
- [x] Output includes simpler alternatives when applicable
- [x] No file modifications — purely analytical

## Files to Modify
- `.claude/commands/challenge.md` — new skill file

## Out of Scope
- Not a template for target projects (project-local only)
- No integration into spec-work workflow
- No automated blocking of feature implementation
