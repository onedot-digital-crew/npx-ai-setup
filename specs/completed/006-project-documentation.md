# Spec: Add Project Concept Documentation

> **Spec ID**: 006 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Create a `docs/` directory with conceptual documentation explaining the project idea, philosophy, and architecture.

## Context
The README serves as an NPM package reference (installation, usage, features). What's missing is higher-level documentation: why this project exists, what problem it solves, the design philosophy behind decisions (template-based vs generative, AI curation, hook-based safety). This helps contributors and users understand the thinking behind the tool.

## Steps
- [x] Step 1: Create `docs/` directory
- [x] Step 2: Create `docs/CONCEPT.md` — project vision, problem statement, design philosophy (why one command, why templates over generation, why AI curation)
- [x] Step 3: Create `docs/ARCHITECTURE.md` — how the system works end-to-end (setup flow, Auto-Init pipeline, template system, hook system, skill curation)
- [x] Step 4: Create `docs/DESIGN-DECISIONS.md` — key decisions with rationale (POSIX shell, no build step, cksum over md5, granular permissions, Haiku for curation)
- [x] Step 5: Add a `## Documentation` section to README.md linking to docs/

## Acceptance Criteria
- [x] `docs/` contains 3 markdown files covering concept, architecture, and design decisions
- [x] Each doc is self-contained and readable without the README
- [x] README links to the docs directory
- [x] All content in English

## Files to Modify
- `docs/CONCEPT.md` — new file
- `docs/ARCHITECTURE.md` — new file
- `docs/DESIGN-DECISIONS.md` — new file
- `README.md` — add docs link section

## Out of Scope
- API reference or code-level documentation
- Tutorials or getting-started guides
- Translating docs to other languages
