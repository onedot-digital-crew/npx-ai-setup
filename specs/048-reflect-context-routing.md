# Spec: Extend /reflect with Context File Routing

> **Spec ID**: 048 | **Created**: 2026-02-28 | **Status**: draft

## Goal
Extend `/reflect` to route architectural discoveries and stack decisions into `.agents/context/` files, not just CLAUDE.md rules.

## Context
Spec 043 implemented `/reflect` for correction-to-rule conversion (CLAUDE.md, CONVENTIONS.md). Brainmaxxing analysis revealed a gap: architectural patterns, codebase gotchas, and stack decisions discovered during work have no persistent home. These belong in `.agents/context/ARCHITECTURE.md` and `.agents/context/STACK.md` — our existing project memory layer.

## Steps
- [ ] Step 1: Update `templates/commands/reflect.md` — add two new signal categories: ARCHITECTURAL (discovered patterns, component relationships, gotchas) and STACK (new deps, version decisions, tool choices discovered at runtime)
- [ ] Step 2: Extend the classification table — ARCHITECTURAL signals → `.agents/context/ARCHITECTURE.md`, STACK signals → `.agents/context/STACK.md`
- [ ] Step 3: Add context file reading step before drafting — read ARCHITECTURE.md and STACK.md to prevent duplicate additions (mirrors existing rule for CLAUDE.md/CONVENTIONS.md)
- [ ] Step 4: Update the AskUserQuestion proposal format to show all four possible target files, not just two
- [ ] Step 5: Add reflect prompt to `/commit` and `/pr` command templates — final step suggests running `/reflect` after a successful commit or PR creation

## Acceptance Criteria
- [ ] `/reflect` detects architectural and stack signals alongside correction signals
- [ ] Architectural findings route to `.agents/context/ARCHITECTURE.md`
- [ ] Stack findings route to `.agents/context/STACK.md`
- [ ] No duplicates written — reads target files before proposing additions
- [ ] All changes still require explicit user approval before writing
- [ ] `/commit` and `/pr` suggest running `/reflect` as a closing step

## Files to Modify
- `templates/commands/reflect.md` - extend signal detection and routing table
- `templates/commands/commit.md` - add reflect suggestion at end
- `templates/commands/pr.md` - add reflect suggestion at end

## Out of Scope
- `brain/` directory concept (our `.agents/context/` serves this purpose)
- `/ruminate` command for mining JSONL archives (Claude Code auto-memory covers forward-looking case)
- `/meditate` vault auditing command
