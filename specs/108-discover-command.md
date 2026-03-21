# Spec: Add /discover Command for Reverse-Engineering Specs from Code

> **Spec ID**: 108 | **Created**: 2026-03-18 | **Status**: draft | **Complexity**: medium | **Branch**: —

## Goal
Add a `/discover` command template that reverse-engineers draft specs from existing codebases for legacy projects and onboarding.

## Context
Identified as a genuine gap during SpecForge evaluation — no existing command generates specs from code. `/analyze` produces an overview but not actionable specs. The command follows the `/analyze` pattern (parallel agents) and outputs standard spec format.

## Steps
- [ ] Step 1: Create `templates/commands/discover.md` with frontmatter (model: opus, mode: plan, allowed-tools: Read, Glob, Grep, Bash, Agent, Write, AskUserQuestion)
- [ ] Step 2: Implement Phase 1 — Codebase Inventory via 3 parallel agents (Entry Points, Module Boundaries, Data Flows) following the `/analyze` agent-dispatch pattern
- [ ] Step 3: Implement Phase 2 — 5W Analysis (What/Why/Who/When/Where) per discovered module, presented as structured summary to user
- [ ] Step 4: Implement Phase 3 — User selects which modules to spec, then generate draft specs in `specs/` using standard template (max 60 lines, Truths/Artifacts/Key Links)
- [ ] Step 5: Add scope-limiting option via AskUserQuestion (full codebase vs subdirectory) at command start
- [ ] Step 6: Register command in `lib/plugins.sh` template map so it gets installed by ai-setup

## Acceptance Criteria

### Truths
- [ ] Running `/discover` on a codebase produces a module inventory and generates draft specs in `specs/`
- [ ] Generated specs follow the standard template format (Goal, Context, Steps, Acceptance Criteria, Files to Modify, Out of Scope)

### Artifacts
- [ ] `templates/commands/discover.md` — complete command template (min 60 lines)

### Key Links
- [ ] `lib/plugins.sh` references `discover.md` in the command template map

## Files to Modify
- `templates/commands/discover.md` — new command template (create)
- `lib/plugins.sh` — register discover command in template map

## Out of Scope
- Automatic spec execution after generation
- Migration-delta or constitution artifacts (SpecForge patterns not adopted)
- Modifying existing `/analyze` command
