---
name: spec-work-all
description: Execute all draft specs in parallel waves. Use when the user says `/spec-work-all`, "run all draft specs", or "implement all ready specs in parallel".
---

# Spec Work All — Batch Execute Draft Specs

Executes all draft specs in `specs/` in dependency-aware waves.

## Process

1. **Discover draft specs**: scan `specs/` for `NNN-*.md` files with `Status: draft`.

2. **Detect dependencies**: if a spec references another spec in Out of Scope or Context, run the dependency first.

3. **Execute in waves**:
   - Set each active spec to `in-progress`
   - Derive a branch name `spec/NNN-title`
   - Run one isolated implementation flow per spec

4. **Post-process results**:
   - Successful specs move to `in-review`
   - Failed specs become `blocked` with a reason
   - Add a changelog entry for each successful spec under `## [Unreleased]`

5. **Summarize**:
   - Completed specs
   - Failed specs
   - Recommended next step: `/spec-review NNN`

## Rules

- Respect spec dependencies.
- Do not silently skip blocked specs.
- Report partial completion clearly.
