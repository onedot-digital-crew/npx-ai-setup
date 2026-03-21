# Spec: Promote agent-browser to required tool + install skill

> **Spec ID**: 141 | **Created**: 2026-03-22 | **Status**: in-review | **Branch**: main

## Goal
Make agent-browser a required CLI tool (npm install) and auto-install its official Claude Code skill for all projects.

## Context
agent-browser (vercel-labs) is currently registered as `optional/cargo` in `lib/cli-tools.sh`. Since v0.20+ it's available via npm (`npm install -g agent-browser`), removing the cargo prerequisite. The project also provides an official Claude Code skill via `npx skills add vercel-labs/agent-browser`. Both changes make it viable as a standard tool for all setups.

## Steps
- [x] Step 1: Update `lib/cli-tools.sh` — change agent-browser entry from `cargo:agent-browser:optional` to `npm:agent-browser:required`, update description to remove "(needs cargo)"
- [x] Step 2: Add `vercel-labs/agent-browser` to the core skills list in `lib/skills.sh` — add a new `browser` keyword entry in `get_keyword_skills()` or add it as a universal skill installed for all projects in `lib/generate.sh`
- [x] Step 3: Update `templates/claude/CLAUDE.md` browser automation section if it references cargo or marks agent-browser as optional
- [x] Step 4: Add `agent-browser install` post-install step to `lib/cli-tools.sh` — after npm install, Chrome for Testing needs to be downloaded (one-time `agent-browser install` command)
- [ ] Step 5: Run `bin/ai-setup.sh --check` to verify agent-browser shows as required and skill installs correctly

## Acceptance Criteria
- [x] `agent-browser` is listed as `required` with `npm` package manager in CLI_TOOL_REGISTRY
- [x] `npx skills add vercel-labs/agent-browser` runs during every setup (not gated by stack detection)
- [x] `agent-browser install` (Chrome download) is triggered after tool installation
- [x] Existing setups with cargo-installed agent-browser are not broken (idempotent)

## Files to Modify
- `lib/cli-tools.sh` — registry entry update + post-install hook
- `lib/skills.sh` or `lib/generate.sh` — universal skill installation
- `templates/claude/CLAUDE.md` — documentation update (if needed)

## Out of Scope
- browser-use CLI (different tool, not adopted)
- iOS Simulator integration
- Cloud browser features
