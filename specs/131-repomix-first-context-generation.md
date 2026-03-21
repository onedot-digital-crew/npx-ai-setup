# Spec: Repomix-First Context Generation via Dedicated Agent

> **Spec ID**: 131 | **Created**: 2026-03-21 | **Status**: draft | **Branch**: —

## Goal
Replace the shell-based one-shot context generation with a dedicated agent that reads a lean repomix snapshot for perfect project context. Eliminate duplicate generation paths and reduce snapshot size by ~85%.

## Context
Currently context files are generated via 3 different paths:
1. **One-shot** in `run_generation()` Step 2 — `claude -p` with shell-gathered snippets (blind, sees only fragments)
2. **context-refresher agent** — Haiku model, samples 3-5 files (too weak, wrong order: repomix after context)
3. **`/context-full` command** — generates full snapshot but writes no context files

All three are suboptimal. The repomix snapshot is 731KB / 211 files — ~60% is ballast (completed specs, skill templates, template copies).

**New approach**: Generate a *lean* repomix snapshot first (~80-120KB, top 30 files, aggressive excludes), then let a dedicated Sonnet agent read it + selectively explore files to produce high-quality context. This replaces paths 1 and 2.

## Steps
- [ ] Step 1: Create `templates/repomix-context.config.json` — lean config with aggressive excludes (`specs/completed/`, `specs/brainstorms/`, `templates/skills/`, `templates/commands/`, `templates/claude/`, `.agents/context/`, `.agents/repomix-*`, `.claude/superpowers-scrape/`, `CHANGELOG.md`, `*SCRAPE*`, binaries) and `topFilesLength: 30`.
- [ ] Step 2: In `lib/setup-compat.sh`, add `generate_repomix_context_snapshot()` that generates `.agents/repomix-context.xml` using the lean config. Keep existing `generate_repomix_snapshot()` for full snapshots.
- [ ] Step 3: Move repomix generation in `bin/ai-setup.sh` to before the Auto-Init block (after `update_gitignore`). Call `generate_repomix_context_snapshot` (lean) instead of `generate_repomix_snapshot` (full).
- [ ] Step 4: Create `templates/agents/project-context.md` — a Sonnet agent that: reads `.agents/repomix-context.xml` as primary input, selectively reads key files for detail, writes STACK.md + ARCHITECTURE.md + CONVENTIONS.md. Max 15 turns, tools: Read, Write, Glob, Bash.
- [ ] Step 5: In `lib/generate.sh`, remove Step 2 (CONTEXT_PROMPT one-shot, lines ~207-273). Replace with a `claude --agent project-context` call. Keep Steps 1a/1b (CLAUDE.md/AGENTS.md one-shot) unchanged.
- [ ] Step 6: Remove standalone context-refresher calls from `bin/ai-setup.sh` and `--regenerate` mode.
- [ ] Step 7: Replace `templates/agents/context-refresher.md` with a thin redirect to `project-context` agent. Mirror to `.claude/agents/`.
- [ ] Step 8: Update `.repomixignore` generation in `install_repomixignore()` with additional stack-specific excludes: Shopify (`*.min.js`, `assets/*.css`), Nuxt (`node_modules/.cache/`), Next (`public/`), Laravel (`public/build/`), Shopware (`public/theme/`).

## Acceptance Criteria
- [ ] `repomix-context.config.json` template exists with lean excludes + `topFilesLength: 30`
- [ ] Lean snapshot (`.agents/repomix-context.xml`) is <150KB for typical projects
- [ ] Lean snapshot exists before context agent runs
- [ ] New project-context agent produces all 3 context files in one run
- [ ] No more one-shot CONTEXT_PROMPT in `run_generation()`
- [ ] No more duplicate context generation (exactly once per setup)
- [ ] Agent reads lean repomix snapshot as primary source (verifiable in agent template)
- [ ] Full snapshot (`generate_repomix_snapshot`) still available for `/context-full`

## Files to Modify
- `templates/repomix-context.config.json` — NEW lean config for context generation
- `lib/setup-compat.sh` — add `generate_repomix_context_snapshot()`, extend `install_repomixignore()`
- `bin/ai-setup.sh` — reorder repomix, remove context-refresher calls
- `lib/generate.sh` — replace Step 2 one-shot with agent call
- `templates/agents/project-context.md` — NEW dedicated context agent
- `templates/agents/context-refresher.md` — redirect to project-context
- `.claude/agents/` — mirror changes

## Out of Scope
- CLAUDE.md / AGENTS.md generation (Steps 1a/1b stay as one-shot)
- Context file format changes (STACK.md, ARCHITECTURE.md, CONVENTIONS.md keep their structure)
- Full repomix snapshot changes (`repomix.config.json` stays as-is)

## References
- Brainstorm: `specs/133-evaluate-context-system.md`
