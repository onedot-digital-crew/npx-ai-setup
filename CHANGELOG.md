# Changelog

All notable changes are recorded here automatically when specs are completed via `/spec-work`.

Format: grouped by date, each entry includes spec ID, title, and a brief summary of changes.

---

<!-- Entries are prepended below this line, newest first -->

## 2026-02-21

- **Spec 012**: /bug Command for Bug Investigation — added `/bug` slash command template with structured reproduce → root cause → fix → verify workflow, registered in TEMPLATE_MAP and install loop.

## 2026-02-21 — v1.1.0

- **feat**: Merge `/challenge` into `/spec` — spec now challenges the idea first (GO/SIMPLIFY/REJECT verdict in chat) before writing the spec; `/challenge` command removed.
- **feat**: Interactive checkbox selector for regeneration — replaces the y/N prompt with an arrow+space UI (same style as system selector); 4 options: CLAUDE.md, Context, Commands, Skills.
- **feat**: Split regeneration Skills into Commands (internal slash commands/agents) and Skills (external skills.sh); Commands re-deploys templates from the package.
- **fix**: Replace full model IDs (`claude-sonnet-4-6`) with short aliases (`sonnet`) in all command/agent frontmatter — fixes IDE validation errors.
- **docs**: Add ccusage to README as recommended tool for session token usage analysis.

## 2026-02-21

- **Spec 011**: Bulk Spec Execution via Agents — adds `/spec-work-all` slash command that discovers all draft specs and executes them in parallel via subagents, with wave-based dependency ordering and a final summary report.


- **feat**: Add `/challenge` command to `templates/commands/` — all target projects now get adversarial feature evaluation out of the box.

- **feat**: Expand system skill sets with verified skills — Nuxt adds vue+vueuse, Shopify adds shopify-theme-dev, Next.js adds nextjs-app-router-patterns, Laravel adds eloquent-best-practices.
- **fix**: Add skills.sh registry pre-check in `install_skill()` — skills not found in registry are skipped with a warning instead of failing.
- **fix**: Replace unverified Next.js skills with `vercel-labs/agent-skills@vercel-react-best-practices` and `jeffallan/claude-skills@nextjs-developer`.
- **fix**: Anchor skill validation regex with `$` to reject invalid skill IDs containing colons (e.g. `react:components`).
- **fix**: Replace invalid Next.js skill with verified registry skills (wshobson/agents@nextjs-app-router-patterns, sickn33/antigravity-awesome-skills@nextjs-best-practices).
- **feat**: Add Next.js/React system option with auto-detection and skill routing; update Nuxt label to "Nuxt 4 / Vue".

- **Spec 010**: Aura Frog Quality Patterns — Added Task Complexity Routing section (simple/medium/complex with model guidance), dual-condition verification gate, and conditional TDD enforcement to `templates/CLAUDE.md`; added test framework detection (jest/vitest/mocha/pytest) to `bin/ai-setup.sh` Auto-Init to include TDD rules only when tests exist; confirmed Context7 MCP already implemented.

- **Spec 009**: Auto-Detect System from Codebase Signals — Added `detect_system()` to resolve `--system auto` to a concrete system (shopify/nuxt/laravel/shopware/storyblok) via shell signals (`theme.liquid`, `artisan`, `composer.json`, `package.json` keywords), stores the resolved system in `.ai-setup.json`, and restores it on `--regenerate` runs.
- **Spec 008**: Feature Challenge Skill — Added `.claude/commands/challenge.md`, a local `/challenge` skill that critically evaluates feature ideas across 7 phases (restate, concept fit, necessity, overhead, complexity, alternatives, verdict) and returns a GO / SIMPLIFY / REJECT decision.

- **Spec 007**: Deny list security hardening — Added `git clean`, `git checkout --`, and `git restore` to the deny list in `templates/claude/settings.json` to prevent destructive git operations on uncommitted work.
- **Spec (untracked)**: Context-Refresher Subagent + Auto-Trigger — Added `context-refresher` agent template (Sonnet), updated `context-freshness.sh` hook to emit `[CONTEXT STALE]` signal, updated `templates/CLAUDE.md` to instruct Claude to invoke the agent automatically on stale context, and registered the agent in `bin/ai-setup.sh`.
- **Spec (untracked)**: Project Concept Documentation — Added `docs/` directory with `CONCEPT.md` (vision & design philosophy), `ARCHITECTURE.md` (end-to-end system flow), and `DESIGN-DECISIONS.md` (9 key technical decisions with rationale). Added `## Documentation` link section to `README.md`.
- **Spec 007**: Auto-Updated CHANGELOG.md on Spec Completion — Added `CHANGELOG.md` and updated both `spec-work` command templates to automatically prepend a changelog entry when a spec is completed.
