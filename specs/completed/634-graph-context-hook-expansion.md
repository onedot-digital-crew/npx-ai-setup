# Spec: graph-context.sh — Liquid + reverse-deps awareness

> **Spec ID**: 634 | **Created**: 2026-05-01 | **Status**: completed | **Complexity**: medium | **Branch**: —

## Goal

Extend `graph-context.sh` PreToolUse hook so every Read/Edit on a tracked file surfaces full graph context — JS/TS imports + reverse-deps + Liquid renderers + Graphify community label.

## Context

Hook today only injects JS/TS forward imports + imported-by from `.agents/context/graph.json`. Three artifacts go unused:

- `.agents/context/liquid-graph.json` — Shopify renders/snippets, never queried by any skill or hook
- `graphify-out/graph.json` — semantic communities, only manual `jq` reads in `agents.md`
- Reverse-deps on Edit — reviewer/implementer never sees who depends on the touched file

Result: skills/agents do not benefit from graphs they themselves help produce. Graphify has zero automatic consumers.

## Stack Coverage

- **Profiles affected**: nuxt-storyblok, shopify-liquid, nextjs, nuxtjs, laravel (anywhere a graph file exists)
- **Per-stack difference**:
  - JS/TS-stacks: forward + reverse imports from `graph.json` (existing, kept)
  - shopify-liquid: query `liquid-graph.json` for `.liquid` files — list renderers + rendered snippets
  - Any stack with `graphify-out/graph.json`: append community label/id (one line)

## Steps

- [x] Step 1: `templates/claude/hooks/graph-context.sh` — extract current JS/TS jq block into `_emit_jsts_neighbors()` helper for clarity
- [x] Step 2: `templates/claude/hooks/graph-context.sh` — add `_emit_jsts_reverse_deps()` for Edit tool only (skip on Read to avoid noise) — show top 5 importers
- [x] Step 3: `templates/claude/hooks/graph-context.sh` — add `_emit_liquid_neighbors()` triggered when `$REL_PATH` ends in `.liquid` and `liquid-graph.json` exists — show renderers + rendered snippets
- [x] Step 4: `templates/claude/hooks/graph-context.sh` — add `_emit_graphify_community()` triggered when `graphify-out/graph.json` exists — single-line community label
- [x] Step 5: `templates/claude/hooks/graph-context.sh` — keep `<50ms` budget: short-circuit if no graph file matches the current file's extension; cache jq output per session via `/tmp/graph-context-cache-$$`
- [x] Step 6: `.claude/hooks/graph-context.sh` — mirror changes (target install location)
- [x] Step 7: smoke test: run hook with sample `.ts`, `.liquid`, and unknown file in temp project with all three graph files — verify correct emit

## Acceptance Criteria

- [x] `bash -n templates/claude/hooks/graph-context.sh` clean
- [x] Hook returns `<50ms` (`time bash templates/claude/hooks/graph-context.sh` with sample input)
- [x] On Edit of a `.ts` file: stdout contains forward imports + reverse-deps + community label (if Graphify present)
- [x] On Read of a `.liquid` file with `liquid-graph.json` present: stdout contains renderers
- [x] On Read of unknown file: hook exits 0, no output
- [x] Hook stays no-op when no graph file exists (current behavior preserved)

## Files to Modify

- `templates/claude/hooks/graph-context.sh` — primary edit
- `.claude/hooks/graph-context.sh` — local install copy stays in sync

## External References

- jq edge/community queries already documented in `.claude/rules/agents.md` lines 56-97 — reuse those query shapes verbatim, no new query design needed

## Out of Scope

- New graph builders (no `liquid-graph` or `graphify` invocations from the hook)
- Auto-rebuild on stale graph (`context-freshness.sh` already covers that)
- Skill/agent prompt changes (handled by spec 635)
- Reviewer-agent integration (spec 636)
