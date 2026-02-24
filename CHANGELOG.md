# Changelog

All notable changes are recorded here automatically when specs are completed via `/spec-work`.

Format: grouped by version. New entries go under `## [Unreleased]` and are moved to a versioned heading when `/release` is run.

---

<!-- Entries are prepended below this line, newest first -->

## [Unreleased]

- **Spec 028**: Fully automatic agent integration — `verify-app` auto-runs after spec implementation (blocks code-reviewer on FAIL), `staff-reviewer` auto-runs in `/pr` before draft
- **Spec 027**: Add code-architect agent — new opus agent for architectural assessment, auto-spawned by `spec-work` when spec has `**Complexity**: high`
- **Spec 026**: Add code-reviewer Agent — new reusable `code-reviewer` agent (sonnet) wired automatically into `spec-work` and `spec-review`, replacing inline review logic
- **Spec 025**: Add .claude/rules/general.md template + agent max_turns — installs a universal coding safety rules file and caps agent turn counts as a cost guard
- **Spec 024**: Smoke Test for bin/ai-setup.sh — added tests/smoke.sh and npm test script for syntax and function-presence checks
- **Spec 023**: Fix git add -A in Worktree Prompt — replaced git add -A with git add -u in spec-work-all subagent commit step
- **Spec 022**: Deduplicate Auto-Review Logic — removed duplicated review criteria from spec-work.md auto-review step, replaced with compact summary referencing `/spec-review` for full criteria
- **Spec 021**: /release command and git tagging — added `/release` slash command template, reformatted CHANGELOG with `[Unreleased]` + versioned headings, updated `/spec-work` to target `[Unreleased]`, backfilled git tags v1.1.0–v1.1.4, bumped version to 1.1.5

## [v1.1.4] — 2026-02-23

- **Spec 020**: Granular template update selector — smart update now shows a 5-category checkbox UI (Hooks, Settings, Commands, Agents, Other) before processing templates, so users can update only the categories they want

- **Spec 019**: Shopify templates moved to skills — relocated 8 Shopify knowledge templates from `templates/commands/shopify/` to `templates/skills/shopify-*/prompt.md`, updated all install/update/uninstall references to target `.claude/skills/`, removed redundant `dragnoir/Shopify-agent-skills` marketplace entries

## [v1.1.3] — 2026-02-23

- **Spec 018**: Native worktree rewrite — replaced manual `git worktree add/remove` in spec-work-all with Claude Code's native `Task(isolation: "worktree")`; subagent now handles .env copy, dep install, and branch rename

- **Spec 016**: Worktree env and deps — `spec-work-all` now auto-copies `.env*` files and runs dependency install (bun/npm/pnpm/yarn) into each worktree before launching agents; failures are warnings, not blockers

## [v1.1.2] — 2026-02-22

- **Spec 015**: Spec workflow branch and review improvements — `/spec-work` now prompts for branch creation before starting and offers auto-review with corrections after execution; `/spec-review` APPROVED verdict no longer suggests PR commands

- **Spec 014**: Skills Discovery Section — added `## Skills Discovery` to `templates/CLAUDE.md` so Claude can search and install skills on demand using `npx skills find` and `npx skills add`

- **feat**: Mini-VibeKanban spec workflow — full status lifecycle (`draft` → `in-progress` → `in-review` → `completed` / `blocked`), `/spec-board` Kanban overview with step progress, `/spec-review NNN` Opus-powered review with PR drafting, `/spec-work-all` rewritten to use Git worktrees for isolated parallel execution, `/spec-work` updated with status transitions

- **Spec 013**: Dynamic Template Map — replaced hardcoded TEMPLATE_MAP array and install loops with dynamic generation from `templates/` directory

- **feat**: `/spec` challenge phase deepened — now thinks through implementation before verdict, mirrors plan mode
- **feat**: `/spec` challenge uses `AskUserQuestion` at decision points during analysis
- **feat**: `/spec` and `/spec-work` auto-load relevant installed skills from `.claude/skills/`
- **feat**: `update-check.sh` hook — notifies at session start when a new `@onedot/ai-setup` version is available
- **fix**: Circuit breaker auto-resets when user sends next message

## [v1.1.1] — 2026-02-21

- **Spec 012**: /bug command — added `/bug` slash command template with structured reproduce → root cause → fix → verify workflow

## [v1.1.0] — 2026-02-21

- **feat**: Merge `/challenge` into `/spec` — spec now challenges the idea first (GO/SIMPLIFY/REJECT verdict) before writing the spec; `/challenge` command removed
- **feat**: Interactive checkbox selector for regeneration — replaces y/N prompt with arrow+space UI; 4 options: CLAUDE.md, Context, Commands, Skills
- **feat**: Split regeneration Skills into Commands (internal slash commands/agents) and Skills (external skills.sh)
- **fix**: Replace full model IDs with short aliases (`sonnet`) in all command/agent frontmatter — fixes IDE validation errors
- **docs**: Add ccusage to README as recommended tool for session token usage analysis
- **Spec 011**: Bulk Spec Execution via Agents — adds `/spec-work-all` slash command for parallel spec execution via subagents
- **feat**: Add `/challenge` command to `templates/commands/`
- **feat**: Expand system skill sets with verified skills — Nuxt adds vue+vueuse, Shopify adds shopify-theme-dev, Next.js adds nextjs-app-router-patterns, Laravel adds eloquent-best-practices
- **fix**: Add skills.sh registry pre-check in `install_skill()` — invalid skills skipped with warning
- **feat**: Add Next.js/React system option with auto-detection and skill routing
- **Spec 010**: Aura Frog Quality Patterns — Added Task Complexity Routing, dual-condition verification gate, and conditional TDD enforcement to `templates/CLAUDE.md`
- **Spec 009**: Auto-Detect System from Codebase Signals — Added `detect_system()` to resolve `--system auto`
- **Spec 008**: Feature Challenge Skill — Added `.claude/commands/challenge.md` with GO/SIMPLIFY/REJECT decision
- **Spec 007**: Deny list security hardening — Added `git clean`, `git checkout --`, `git restore` to deny list
- **Spec (untracked)**: Context-Refresher Subagent + Auto-Trigger
- **Spec (untracked)**: Project Concept Documentation — Added `docs/` with CONCEPT.md, ARCHITECTURE.md, DESIGN-DECISIONS.md
- **Spec 007**: Auto-Updated CHANGELOG.md on Spec Completion
