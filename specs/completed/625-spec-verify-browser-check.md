# Spec: spec-verify skill — optional browser check for frontend specs

> **Spec ID**: 625 | **Created**: 2026-04-06 | **Status**: completed | **Complexity**: low | **Branch**: —

## Goal
Add a standalone `/spec-verify NNN` skill that visually verifies frontend changes via MCP Playwright after `spec-run`.

## Context
`spec-review` checks code quality and acceptance criteria but never opens a browser. CSS bugs, layout regressions, and broken states go unnoticed until manual testing. The challenge verdict was SIMPLIFY: no integration into `spec-run`, just a standalone optional skill the user calls explicitly. Relies on MCP Playwright being configured.

### Verified Assumptions
- MCP Playwright available at runtime — Evidence: session MCP tools `mcp__playwright__*` | Confidence: High | If Wrong: skill reports "MCP Playwright not available" and exits
- Dev-server command in package.json — Evidence: standard npm convention | Confidence: Medium | If Wrong: skill asks user for start command
- Auto-discovered by template map — Evidence: `build_template_map()` in `lib/core.sh` | Confidence: High | If Wrong: add explicit entry

## Steps
- [x] Step 1: Create `templates/skills/spec-verify/SKILL.template.md` — reads spec, detects frontend files (.tsx/.jsx/.vue/.svelte/.css/.scss/.html/.twig), asks user for route, checks if dev server responds (curl localhost); if not: reads package.json for start command, starts it, waits for ready, runs verify, stops server after; navigates with MCP Playwright, takes screenshot, runs basic interaction checks, reports PASS/CONCERNS
- [x] Step 2: Add workflow hint row in `templates/claude/rules/workflow.md` — after `/spec-run` suggest `/spec-verify NNN` for frontend specs
- [x] Step 3: Verify skill is discoverable via `build_template_map()` and has correct frontmatter

## Acceptance Criteria
- [ ] "`ls templates/skills/spec-verify/SKILL.template.md` returns the file"
- [ ] "Skill frontmatter has name, description, and model fields"
- [ ] "`grep 'spec-verify' templates/claude/rules/workflow.md` shows the new hint row"

## Files to Modify
- `templates/skills/spec-verify/SKILL.template.md` - new skill (create)
- `templates/claude/rules/workflow.md` - add hint row

## Out of Scope
- Integration into spec-run pipeline (standalone only)
- Playwright installation handling (global MCP setup assumed)
- Visual regression testing / screenshot diffing
