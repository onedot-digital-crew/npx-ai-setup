# Spec: Token Efficiency Optimization

> **Spec ID**: 004 | **Created**: 2026-02-21 | **Status**: completed

## Goal
Reduce per-setup token footprint by ~400 tokens through removing duplication in generation prompts and CLAUDE.md template comments.

## Context
Direct file inspection confirmed 4 real optimization areas. Generation prompts in ai-setup.sh repeat "Do NOT read any files" twice per prompt (L471+L483, L493+L526). The CLAUDE.md template has 18 lines of HTML placeholder comments (L14-32) that Claude reads every session but never uses. The skill curator prompt has an example response (L768-770) that duplicates the already-stated format. Settings.json granular rules are intentional (security), not waste.

## Steps
- [x] Step 1: `bin/ai-setup.sh` L483 — remove duplicate "Do NOT read any files" line from prompt 1 (already stated on L471)
- [x] Step 2: `bin/ai-setup.sh` L526 — remove duplicate "Do NOT read any files" line from prompt 2 (already stated on L493)
- [x] Step 3: `bin/ai-setup.sh` L497-521 — compress 3×8 bullet-point file descriptions to 3 single-line descriptions (~180 tokens saved)
- [x] Step 4: `bin/ai-setup.sh` L768-770 — remove example response from skill curator prompt (format already stated on L766-767)
- [x] Step 5: `templates/CLAUDE.md` L14-21 — replace 8-line `<!-- Auto-Init will populate... -->` comment block with single line `<!-- Auto-Init populates this -->`
- [x] Step 6: `templates/CLAUDE.md` L23-32 — replace 10-line Critical Rules comment block with single line `<!-- Auto-Init populates this -->`
- [x] Step 7: Run `bash -n bin/ai-setup.sh` to verify syntax

## Acceptance Criteria
- [x] Each generation prompt has "Do NOT read" only once
- [x] Context file descriptions compressed without losing semantic content
- [x] CLAUDE.md template HTML comments are single-line stubs
- [x] `bash -n bin/ai-setup.sh` passes clean

## Files to Modify
- `bin/ai-setup.sh` — remove prompt duplicates, compress descriptions
- `templates/CLAUDE.md` — compress HTML comment blocks

## Out of Scope
- settings.json rule consolidation (security-by-design, not waste)
- Agent template restructuring
- Command template changes (commit.md, pr.md already lean at 22/24 lines)
