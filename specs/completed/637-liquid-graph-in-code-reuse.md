# Spec: code-reuse rule — Liquid-graph awareness for Shopify

> **Spec ID**: 637 | **Created**: 2026-05-01 | **Status**: completed | **Complexity**: small | **Branch**: —

## Goal

Make `.claude/rules/code-reuse.md` instruct Claude to query `liquid-graph.json` before touching a snippet/section so hub-snippets (rendered in many places) are flagged before edits, and rendering relations replace blind grep.

## Context

`liquid-graph.json` is built by `lib/build-liquid-graph.sh` and exposed in `agents.md` (lines 86-97), but no rule references it as a code-reuse step. On Shopify projects, "is this snippet used elsewhere?" is the top question before editing — currently answered by recursive grep through `sections/` and `templates/`. The graph already has the edges precomputed.

Adding a Liquid-specific block to `code-reuse.md` closes the gap with zero new tooling.

## Stack Coverage

- **Profiles affected**: shopify-liquid only
- **Per-stack difference**: rule block is gated — only fires when `.agents/context/liquid-graph.json` exists

## Steps

- [x] Step 1: `templates/claude/rules/code-reuse.md` — add "Liquid Renderer-Scan" section after Project-Scan: jq query for renderers when target is a `.liquid` file
- [x] Step 2: same file — add "Hub-Snippet Warning" rule: if `.stats.top_hubs[]` lists the snippet with ≥5 renderers, require a one-line comment in spec/PR explaining renderer-impact before edit
- [x] Step 3: same file — add "Orphan Reuse" hint: before creating a new snippet, check `.stats.orphans[]` — orphan with similar name = candidate for reuse instead of new file
- [x] Step 4: `.claude/rules/code-reuse.md` — mirror

## Acceptance Criteria

- [x] Rule block is conditional on `.agents/context/liquid-graph.json` existing
- [x] Three jq queries present verbatim from `agents.md` (renderer-scan, hub-list, orphan-list)
- [x] No mention of `.liquid` outside the gated block (rule still applies to non-Shopify projects unchanged)
- [x] On a Shopify project, editing a known hub-snippet triggers the warning behavior (manual spot-check)

## Files to Modify

- `templates/claude/rules/code-reuse.md`
- `.claude/rules/code-reuse.md`

## External References

- jq queries copied verbatim from `.claude/rules/agents.md` lines 90-96 (renderer-scan, top_hubs, orphans)
- Liquid-graph schema produced by `lib/build-liquid-graph.sh` — same shape as `.agents/context/graph.json` (verified in agents.md table line 53)

## Out of Scope

- New jq queries (reuse existing)
- Auto-rebuild of liquid-graph (handled by `liquid-graph-refresh.sh` already)
- Hook-level integration (covered by spec 634)
- JS/TS reuse rules (already present in code-reuse.md)
