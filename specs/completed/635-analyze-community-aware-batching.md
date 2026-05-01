# Spec: analyze — community-aware batching + false-positive guards

> **Spec ID**: 635 | **Created**: 2026-05-01 | **Status**: completed | **Complexity**: medium | **Branch**: —

## Goal

Cut analyze false-positive rate ~60% and start using `graphify-out/graph.json` automatically: batch source files by community (when graph exists), inject stack auto-import hints, and gate cross-file claims behind a verification rule.

## Context

`/analyze` produces too many false positives in real audits (nuxt-onedot run produced ~5 wrong claims in one pass):

1. **Auto-imports flagged as missing** — Nuxt/Nitro auto-imports from `app/composables/`, `app/utils/`, `server/utils/` are reported as undefined. Batch-haiku has no framework awareness.
2. **Phantom cross-file bugs** — synthesizer claims "dual patching between A.ts and B.ts" because batches see only one side; cross-file inference is structurally unsafe with random 8-file chunks.
3. **Pattern-match suspicions reported as issues** — prompt says "note any issues" with no confidence gate, so haiku dumps every suspicion.

Graphify is installed but no skill uses its communities. analyze builds its own graph but ignores the semantic one. Both problems share one fix: batch by community, not by chunk.

## Stack Coverage

- **Profiles affected**: all (analyze is generic)
- **Per-stack difference**:
  - nuxt/nuxt-storyblok: stack-hint includes Nuxt auto-import paths (`composables/`, `utils/`, `server/utils/`)
  - laravel: hint includes facade/service-provider auto-resolution
  - shopify-liquid: hint includes snippet rendering convention (no JS imports)
  - default: hint section omitted

## Steps

- [x] Step 1: `templates/skills/analyze/SKILL.template.md` — add Step 0c "Load graph artifacts": probe `graphify-out/graph.json` and `.agents/context/STACK.md` once before mode selection
- [x] Step 2: `templates/skills/analyze/SKILL.template.md` — change mode selection: when `graphify-out/graph.json` exists AND ≥2 communities present → use new "community mode" instead of fast/batch
- [x] Step 3: `templates/skills/analyze/references/agents-batch-mode.md` — add **stack hint block** to batch-agent prompt template (auto-import paths from STACK.md if present)
- [x] Step 4: `templates/skills/analyze/references/agents-batch-mode.md` — add **confidence gate** rule to batch-agent prompt: "Only report HIGH or MEDIUM confidence issues. Skip pattern-match suspicions. If unsure, omit."
- [x] Step 5: `templates/skills/analyze/references/agents-batch-mode.md` — add **synthesizer cross-file rule**: "Cross-file claims (A depends on B, dual-patch, shared bug) MUST be verifiable from the batch outputs you received. If you cannot trace the claim to two batch reports that both saw the relevant files, drop the claim."
- [x] Step 6: `templates/skills/analyze/references/agents-community-mode.md` — new file: prompt template that batches by community (one batch per community, files from same community only) — same haiku model, but cross-file patterns within a batch are now safe
- [x] Step 7: `.claude/skills/analyze/` — mirror all template changes
- [x] Step 8: smoke verification: dry-run analyze on `~/Sites/nuxt-onedot` (which has graphify-out present? if not, build first) — manually inspect output for the three failure modes

## Acceptance Criteria

- [x] When `graphify-out/graph.json` exists with ≥2 communities, SKILL.md routes to community-mode (verify by reading SKILL.md flow)
- [x] Batch prompts include "Auto-import paths:" line when STACK.md contains a known framework token (nuxt, laravel, etc.)
- [x] Batch prompts include the "HIGH or MEDIUM confidence" gate verbatim
- [x] Synthesizer prompt rejects cross-file claims not traceable to ≥2 batches
- [x] Re-run on nuxt-onedot: zero auto-import false positives, zero cross-batch phantom claims
- [x] No regression for projects without graphify-out: fast/batch mode unchanged

## Files to Modify

- `templates/skills/analyze/SKILL.template.md` — mode routing + step 0c
- `templates/skills/analyze/references/agents-batch-mode.md` — stack hint + confidence gate + synthesizer rule
- `templates/skills/analyze/references/agents-community-mode.md` — NEW
- `.claude/skills/analyze/SKILL.md` — mirror
- `.claude/skills/analyze/references/agents-batch-mode.md` — mirror
- `.claude/skills/analyze/references/agents-community-mode.md` — mirror

## External References

- Graphify community schema verified via `.claude/rules/agents.md` lines 63-71 (`.communities[].nodes[]`, `.communities[].label`)
- jq community-extraction queries copy from `templates/skills/graphify/SKILL.template.md` lines 48-56

## Out of Scope

- New graphify build trigger (skill remains opt-in; community mode skips silently if absent)
- Reviewer-agent graph use (spec 636)
- Liquid-graph integration in analyze (Liquid projects rarely run analyze; covered by hook in spec 634)
- Replacing haiku with sonnet by default (cost regression — keep `effort: xhigh|max → sonnet` rule unchanged)
