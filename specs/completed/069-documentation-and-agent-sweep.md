# Spec: Agent Rules and Template Standardization

> **Spec ID**: 069 | **Created**: 2026-03-09 | **Status**: completed | **Branch**: —

## Goal
Create agent delegation rules file and standardize agent template metadata so Claude delegates correctly without being asked.

## Context
Our template ships 9 agents but no rule defining when each should be used. Agent templates have inconsistent metadata fields (some missing `memory`, others missing fields). A rules file is always active — zero user action required.

## Steps
- [x] Step 1: Create `templates/claude/rules/agents.md` with agent-to-task mapping table, trigger conditions, scope limits, and anti-patterns for over-delegation
- [x] Step 2: Standardize `templates/agents/*.md` metadata fields (ensure all agents have consistent `name`, `description`, `tools`, `model`, `max_turns` fields) — verified: already consistent, no changes needed
- [x] Step 3: Register `agents.md` in rules template map in `lib/core.sh` — verified: `build_template_map()` auto-discovers all files under `templates/claude/rules/`, no manual registration needed

## Acceptance Criteria
- [ ] `templates/claude/rules/agents.md` exists with all generated agents documented
- [ ] All agent templates use consistent metadata fields
- [ ] No runtime behavior changes — documentation only (except new rules file)

## Files to Modify
- `templates/claude/rules/agents.md` — new file
- `templates/agents/*.md` — metadata standardization
- `lib/core.sh` — register agents.md rule

## Out of Scope
- New agents or hooks
- Installer behavior changes
- Hook design principles documentation (already covered in hooks/README)
- Monorepo context guidance
