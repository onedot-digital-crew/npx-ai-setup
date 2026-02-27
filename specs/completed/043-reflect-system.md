# Spec: Self-Improvement Reflect System

> **Spec ID**: 043 | **Created**: 2026-02-27 | **Status**: completed | **Branch**: spec/043-reflect-system | **Complexity**: high

## Goal
Create a `/reflect` command that detects corrections from the current session and converts them into permanent CLAUDE.md rules or convention updates.

## Context
Inspired by claude-reflect-system ("correct once, never again"). Currently corrections are lost between sessions — developers repeat the same feedback. This command analyzes session conversation for correction patterns (HIGH: "use X not Y", MEDIUM: approved approaches) and writes them as persistent rules. Integrates with existing CLAUDE.md and `.agents/context/CONVENTIONS.md`.

## Steps
- [x] Step 1: Create `templates/commands/reflect.md` — command that analyzes the conversation for correction signals (direct corrections, rejected approaches, approved patterns)
- [x] Step 2: Implement 3-tier signal detection in the command: HIGH (explicit corrections), MEDIUM (approved approaches), LOW (observations) — only apply HIGH+MEDIUM
- [x] Step 3: Define output targets: corrections about coding style → append to `.agents/context/CONVENTIONS.md`, corrections about project rules → append to CLAUDE.md Critical Rules section, corrections about tooling → append to CLAUDE.md Commands section
- [x] Step 4: Add safety: show proposed changes to user via AskUserQuestion before writing, create git-trackable changes (no silent mutations)
- [x] Step 5: Register the command in `lib/setup.sh` template map so it installs with ai-setup
- [x] Step 6: Run smoke tests to verify template installs correctly

## Acceptance Criteria
- [x] `/reflect` command exists and is installable via ai-setup
- [x] Command detects correction patterns from conversation context
- [x] Changes require explicit user approval before writing
- [x] Written changes are minimal, specific, and append-only (no destructive edits)

## Files to Modify
- `templates/commands/reflect.md` — new command template (create)
- `lib/setup.sh` — register reflect command in template map

## Out of Scope
- Auto-mode (hook-based automatic reflection) — future enhancement
- Skill file generation (YAML skill format) — use CLAUDE.md/context files instead
- Cross-session learning (that is claude-mem's responsibility)
