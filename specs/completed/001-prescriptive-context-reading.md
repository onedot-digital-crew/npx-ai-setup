# Spec: Prescriptive context reading and stuck instruction

> **Spec ID**: 001 | **Created**: 2026-02-17 | **Status**: completed

## Goal
Make CLAUDE.md template actively instruct Claude to read context files before complex tasks, and add a soft "stuck" detection instruction.

## Context
Current "Project Documentation" section passively lists files. Lean+ research shows prescriptive instructions ("MUST read before...") significantly improve context utilization. Also: circuit breaker fires at 5 edits, but a soft instruction at 3 catches issues earlier.

## Steps
- [x] Rename "## Project Documentation" to "## Project Context (read before complex tasks)" in `templates/CLAUDE.md`
- [x] Change passive list to prescriptive: "Before multi-file changes or new features, read `.agents/context/`:"
- [x] Reorder to STACK → ARCHITECTURE → CONVENTIONS with enhanced descriptions
- [x] Add "If you edit the same file 3+ times without progress, stop and ask for guidance." to Communication Protocol

## Acceptance Criteria
- [x] CLAUDE.md template has prescriptive "read before" instruction
- [x] "Stuck" instruction present in Communication Protocol
- [x] Section references match what STACK.md and CONVENTIONS.md will generate

## Files to Modify
- `templates/CLAUDE.md` — rewrite sections

## Out of Scope
- Changes to generation prompts (separate spec)
