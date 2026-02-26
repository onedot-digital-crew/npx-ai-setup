# Spec: Global Definition of Done and Ignore Patterns

> **Spec ID**: 038 | **Created**: 2026-02-27 | **Status**: in-review | **Branch**: spec/038-dod-and-ignore-patterns

## Goal
Add auto-generated Definition of Done to CONVENTIONS.md and build-artifact ignore patterns to settings.json for higher baseline code quality and reduced token waste.

## Context
The /spec-review agent checks code only against spec-specific acceptance criteria. Generic quality gates (no console.log, no explicit any, linter clean) must be written into every spec manually. Additionally, Claude can read build artifacts (dist/, .output/, coverage/) wasting tokens and polluting context. Both fixes are template-level changes applied at setup time.

## Steps
- [x] Step 1: Extend CONVENTIONS.md generation prompt in `bin/ai-setup.sh` (~line 806) — add instruction: "Include a ## Definition of Done section with project-appropriate quality gates derived from detected tools (linter, TypeScript, test runner)."
- [x] Step 2: Add build-artifact deny rules to `templates/claude/settings.json` — add `Read(dist/**)`, `Read(.output/**)`, `Read(.nuxt/**)`, `Read(coverage/**)`, `Read(.next/**)`, `Read(build/**)` to the deny array.
- [x] Step 3: Add Critical Rule to `templates/CLAUDE.md` — "Never read or search inside build output directories (dist/, .output/, .nuxt/, .next/, build/, coverage/)."
- [x] Step 4: Update `templates/commands/spec-review.md` Step 5b — after verifying spec ACs, also verify code against the Definition of Done from `.agents/context/CONVENTIONS.md` if it exists.
- [x] Step 5: Verify all template files parse correctly and no existing functionality is broken.

## Acceptance Criteria
- [x] Fresh CONVENTIONS.md generation includes a DoD section with project-specific gates
- [x] settings.json deny list blocks Read access to common build artifact directories
- [x] /spec-review checks code against both spec ACs and the global DoD
- [x] Existing hooks, commands, and agents are unaffected

## Files to Modify
- `bin/ai-setup.sh` — extend CONVENTIONS.md generation prompt
- `templates/claude/settings.json` — add deny rules for build artifacts
- `templates/CLAUDE.md` — add Critical Rule for build directories
- `templates/commands/spec-review.md` — add DoD verification step

## Out of Scope
- Native .claudeignore support (not available in Claude Code)
- Per-spec DoD overrides
- Token budget tracking or cost monitoring
