# Spec: /bug Command for Bug Investigation

> **Spec ID**: 012 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Add a `/bug` slash command template that gives Claude a structured bug investigation workflow instead of defaulting to spec creation.

## Context
When users report bugs, Claude currently has no dedicated workflow — it either investigates ad-hoc or suggests creating a spec (wrong tool for bugs). A `/bug` command template gives Claude a clear protocol: reproduce → isolate → fix → verify, without the overhead of spec format.

## Steps
- [x] Step 1: Create `templates/commands/bug.md` with bug investigation workflow
- [x] Step 2: Add `"templates/commands/bug.md:.claude/commands/bug.md"` to `TEMPLATE_MAP` in `bin/ai-setup.sh`
- [x] Step 3: Add `bug.md` to the command install loop in `bin/ai-setup.sh` (fresh install path)
- [x] Step 4: Update `README.md` commands table to include `/bug`
- [x] Step 5: `bash -n bin/ai-setup.sh` syntax check

## Acceptance Criteria
- [x] `/bug "description"` starts a structured investigation (not a spec)
- [x] Template covers: reproduce → root cause → fix → verify
- [x] Installs automatically with `npx @onedot/ai-setup`
- [x] Appears in README command table

## Files to Modify
- `templates/commands/bug.md` - new command template (create)
- `bin/ai-setup.sh` - TEMPLATE_MAP + install loop
- `README.md` - commands table

## Out of Scope
- GitHub Issues integration
- Bug tracking database or persistence
