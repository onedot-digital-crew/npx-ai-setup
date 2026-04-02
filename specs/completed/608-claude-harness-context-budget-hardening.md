# Spec: Claude Harness Context Budget Hardening

> **Spec ID**: 608 | **Created**: 2026-04-01 | **Status**: completed | **Complexity**: medium | **Branch**: —
> **Execution Order**: first (no dependencies)

## Goal
Ship leaner Claude defaults by reducing irrelevant auto-loaded context, tightening context-budget settings, and making SessionStart indexing relevant for Bash CLI repos like `@onedot/ai-setup`.

## Context
Research against the leaked Claude Code architecture points to three high-leverage harness layers that matter here: knowledge on demand, context compression, and task-relevant startup context. `npx-ai-setup` already has strong hook infrastructure, but its current defaults still over-index on generic frontend patterns and leave context-budget tuning conservative. This spec narrows the first optimization pass to defaults that improve session quality without inventing unsupported Claude settings or pretending local hooks can reproduce internal-only features.

### Verified Assumptions
- `install_settings()` always copies `templates/claude/settings.json` into repo-local `.claude/settings.json` before stack customization runs. — Evidence: `bin/ai-setup.sh`, `lib/setup.sh` | Confidence: High | If Wrong: settings changes would need a different install entrypoint
- `install_claudeignore()` merges new template patterns into an existing `.claudeignore` and is the canonical rollout path for auto-index exclusions. — Evidence: `bin/ai-setup.sh`, `lib/setup-compat.sh` | Confidence: High | If Wrong: ignore-pattern rollout would need migration logic elsewhere
- `file-index.sh` is currently optimized for Shopify/frontend shapes and contributes little or nothing for this Bash CLI repo shape. — Evidence: `templates/claude/hooks/file-index.sh` | Confidence: High | If Wrong: the Bash index would be redundant noise
- `context-loader.sh` already loads only frontmatter abstracts, so the next useful optimization is bounding and prioritizing that existing mechanism rather than replacing it with speculative per-directory heuristics. — Evidence: `templates/claude/hooks/context-loader.sh` | Confidence: High | If Wrong: the loader would need a bigger redesign

## Steps
- [x] Step 1: Expand `templates/.claudeignore` so setup-local audit and evaluation artifacts are excluded from auto-indexing by default; mirror the generated local `.claudeignore` for this repo.
- [x] Step 2: Tighten default context-budget knobs in `templates/claude/settings.json` by lowering `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` below the current default and reducing `BASH_MAX_OUTPUT_LENGTH` for long-running coding sessions; sync local copies.
- [x] Step 3: Refactor `templates/claude/hooks/file-index.sh` to emit a compact Bash-CLI-oriented index when repos contain `bin/`, `lib/`, `templates/`, `specs/`, or `.agents/context/`, instead of only frontend/shopify structures.
- [x] Step 4: Bound and prioritize `templates/claude/hooks/context-loader.sh` so SessionStart context remains short and stable as `.agents/context/` grows, preferring `STACK.md`, `ARCHITECTURE.md`, and `CONVENTIONS.md` over auxiliary context files.
- [x] Step 5: Update `templates/claude/hooks/README.md` and `templates/skills/token-optimizer/SKILL.md` so the shipped defaults are documented as local harness behavior rather than as a clone of internal Claude-only compression features.

## Acceptance Criteria

### Truths
- [x] Fresh setup installs a `.claudeignore` that excludes local AI-setup audit/eval debris from automatic context loading.
- [x] Context-budget settings compact earlier than the current default and capture less verbose Bash output than the current default.
- [x] SessionStart now emits a useful compact file index for Bash CLI repositories instead of falling back to frontend-only heuristics.
- [x] `context-loader.sh` remains abstract-based, but its output is bounded and priority-ordered rather than growing with every additional context file.

### Artifacts
- [x] `templates/.claudeignore` — expanded default ignore set (min 75 lines)
- [x] `templates/claude/settings.json` — includes revised env defaults and hook registrations remain intact
- [x] `templates/claude/hooks/file-index.sh` — Bash-CLI-aware startup index (min 50 lines)
- [x] `templates/claude/hooks/context-loader.sh` — bounded startup context loader (min 50 lines)

### Key Links
- [x] `bin/ai-setup.sh` → `lib/setup-compat.sh` via `install_claudeignore()`
- [x] `bin/ai-setup.sh` → `lib/setup.sh` via `install_settings()`
- [x] `templates/claude/settings.json` → `templates/claude/hooks/context-loader.sh` via SessionStart budget strategy

## Files to Modify
- `templates/.claudeignore` - exclude local-only setup artifacts from auto-indexing
- `.claudeignore` - sync local generated ignore file for repo verification
- `templates/claude/settings.json` - tighten default compaction and Bash output limits
- `.claude/settings.json` - keep local verification copy aligned
- `templates/claude/hooks/file-index.sh` - add Bash CLI repo indexing path
- `.claude/hooks/file-index.sh` - sync installed local copy
- `templates/claude/hooks/context-loader.sh` - bound startup context injection
- `.claude/hooks/context-loader.sh` - sync installed local copy
- `templates/claude/hooks/README.md` - document the new harness behavior
- `templates/skills/token-optimizer/SKILL.md` - align audit guidance with shipped defaults

## Out of Scope
- Generic plan/todo persistence beyond the existing spec-focused compact-state flow
- Permission preset profiles or managed-settings architecture
- Plugin-first migration or any change to official plugin installation behavior
