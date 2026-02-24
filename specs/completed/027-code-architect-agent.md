# Spec: Add code-architect Agent Template

> **Spec ID**: 027 | **Created**: 2026-02-24 | **Status**: completed | **Branch**: spec/027-code-architect-agent

<!-- Status lifecycle: draft → in-progress → in-review → completed (or blocked at any stage) -->

## Goal
Add a `code-architect` agent template that performs design reviews and architectural assessments before or during complex spec implementation.

## Context
Claude Code exposes `code-architect` as a native subagent type for design reviews and architectural assessments — but the project has no template for it. `bin/ai-setup.sh` auto-installs all `templates/agents/*` to `.claude/agents/`, so only the template file is needed. The agent sits between `code-reviewer` (routine check) and `staff-reviewer` (adversarial production gate) in terms of depth and cost.

## Steps
- [x] Step 1: Create `templates/agents/code-architect.md` — model: opus, max_turns: 15; reviews proposed architecture or spec for design problems before implementation begins
- [x] Step 2: Update `templates/commands/spec-work.md` — add `Task` to `allowed-tools` (if not already added by 026); before executing steps, auto-spawn `code-architect` when spec file contains `**Complexity**: high` in its header
- [x] Step 3: Sync change to `.claude/commands/spec-work.md`

## Acceptance Criteria
- [x] `templates/agents/code-architect.md` exists with valid frontmatter, opus model, and architectural review criteria
- [x] Agent installed via normal `npx @onedot/ai-setup` flow (no bin/ai-setup.sh change needed)
- [x] `spec-work` spawns `code-architect` automatically for high-complexity specs

## Files to Modify
- `templates/agents/code-architect.md` — new file
- `templates/commands/spec-work.md` — auto-spawn code-architect for complex specs
- `.claude/commands/spec-work.md` — sync

## Out of Scope
- Changing `/spec` creation command
- Changing complexity detection beyond a simple header field
- Depends on: Spec 026 (Task tool already added to spec-work)
