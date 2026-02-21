# Spec: Adapt Aura Frog Quality Patterns into Templates

> **Spec ID**: 010 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Add TDD enforcement and dual-condition verification gate to CLAUDE.md template, inspired by Aura Frog's quality discipline.

## Context
Aura Frog enforces TDD (no code before failing test) and dual-condition exit gates (tests pass + explicit verification). Our CLAUDE.md template has a basic Verification section but lacks TDD enforcement and strict exit criteria. Model routing and Playwright MCP are already covered by GSD profiles and existing settings — no changes needed there.

## Steps
- [x] Step 1: Add Task Complexity Routing section to `templates/CLAUDE.md` — simple/medium/complex classification with explicit model guidance
- [x] Step 2: Strengthen `templates/CLAUDE.md` Verification section with dual-condition gate — require both automated checks (tests/lint pass) AND explicit confirmation statement
- [x] Step 3: Add conditional TDD rule to `templates/CLAUDE.md` — enforce "write failing test first" only when test infrastructure exists (detected by Auto-Init)
- [x] Step 4: Update `bin/ai-setup.sh` Auto-Init CLAUDE.md generation prompt to detect test framework and conditionally include TDD rule
- [x] Step 5: Add Context7 MCP to `bin/ai-setup.sh` — already implemented at lines 1494-1537
- [x] Step 6: Validate with `bash -n bin/ai-setup.sh` and review generated output

## Acceptance Criteria
- [x] CLAUDE.md template includes Task Complexity Routing section (simple/medium/complex)
- [x] Verification section requires dual-condition exit (automated + explicit statement)
- [x] TDD rule included conditionally based on test framework detection
- [x] Auto-Init detects jest/vitest/mocha/pytest presence for TDD rule
- [x] Context7 MCP is written to `.mcp.json` in target project during setup

## Files to Modify
- `templates/CLAUDE.md` — add routing section, TDD rule, strengthen verification
- `bin/ai-setup.sh` — test framework detection, Context7 MCP setup

## Out of Scope
- Playwright MCP setup (project-specific, not generic)
- New agent personas (existing agents sufficient)
- Automatic model switching (not possible, guidance only)
