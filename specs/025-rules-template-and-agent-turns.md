# Spec: Add .claude/rules/general.md Template + Agent max_turns

> **Spec ID**: 025 | **Created**: 2026-02-24 | **Status**: draft

## Goal

Install a universal `.claude/rules/general.md` coding safety rules file to target projects, and add `max_turns` limits to all agent templates.

## Context

Alex's AI Coding Starter Kit uses `.claude/rules/` as a third enforcement layer between CLAUDE.md (always loaded) and hooks (tool-level blocks). Rules auto-apply contextually, keeping CLAUDE.md lean. A framework-agnostic `general.md` enforces "read before modify" and "check before creating" at the prompt level. Additionally, his agents cap turns (30–50) as a cost guard; our agent templates have no `max_turns` frontmatter.

## Steps

- [ ] Step 1: Create `templates/claude/rules/general.md` with universal rules: always read before modifying, verify import paths by reading, check existing files before creating, run `git diff` after changes
- [ ] Step 2: Add `max_turns` frontmatter to `templates/agents/build-validator.md` (10), `verify-app.md` (20), `staff-reviewer.md` (20), `context-refresher.md` (15)
- [ ] Step 3: Update `bin/ai-setup.sh` install logic to copy `templates/claude/rules/` to `.claude/rules/` in target projects (alongside existing hooks copy)
- [ ] Step 4: Update `bin/ai-setup.sh` update logic to include `rules/` in the regeneration/sync paths

## Acceptance Criteria

- [ ] Running `npx @onedot/ai-setup` creates `.claude/rules/general.md` in the target project
- [ ] All 4 agent templates have `max_turns` in frontmatter
- [ ] Update mode syncs the rules file without overwriting user customizations (same pattern as hooks)
- [ ] `general.md` contains only framework-agnostic rules (no Next.js, no Supabase)

## Files to Modify

- `templates/claude/rules/general.md` - create new
- `templates/agents/build-validator.md` - add max_turns: 10
- `templates/agents/verify-app.md` - add max_turns: 20
- `templates/agents/staff-reviewer.md` - add max_turns: 20
- `templates/agents/context-refresher.md` - add max_turns: 15
- `bin/ai-setup.sh` - install + update rules/ directory

## Out of Scope

- Stack-specific rules (frontend.md, backend.md, security.md) — too project-specific
- Role-based agents (frontend-dev, backend-dev, qa-engineer) — audience mismatch
- Feature tracking system (features/INDEX.md) — we have specs/
