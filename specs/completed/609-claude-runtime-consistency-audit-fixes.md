# Spec: Claude Runtime Consistency Audit Fixes

> **Spec ID**: 609 | **Created**: 2026-04-01 | **Status**: completed | **Complexity**: medium | **Branch**: —
> **Execution Order**: after 608

## Goal
Eliminate runtime inconsistencies between installed Claude behavior, hooks, skills, and docs so the setup behaves as documented and the docs describe the real runtime.

## Context
The audit found that several of the strongest harness ideas are already present, but the implementation is split across plugins, hooks, skills, and docs that do not always agree. This spec fixes concrete mismatches that are visible in the current repo: session-memory detection, contradictory spec-work instructions, threshold drift in warnings, and docs that describe the wrong protection layer.

### Verified Assumptions
- `claude-mem` is currently installed as a plugin path, not as an `.mcp.json` server, so hook logic that keys only off `.mcp.json` will miss it. — Evidence: `lib/plugins.sh`, `templates/claude/hooks/transcript-ingest.sh` | Confidence: High | If Wrong: memory-path fix would need a different detection strategy
- `spec-work` currently contains contradictory commit guidance that can produce divergent behavior. — Evidence: `templates/skills/spec-work/SKILL.md` | Confidence: High | If Wrong: only wording would need cleanup
- `context-monitor.sh` and `templates/claude/settings.json` currently describe different compact thresholds, so at least one of them is wrong today. — Evidence: `templates/claude/hooks/context-monitor.sh`, `templates/claude/settings.json` | Confidence: High | If Wrong: thresholds are being set elsewhere at runtime
- Token and workflow docs currently attribute some read-protection behavior to hooks even though the real enforcement sits in `permissions.deny`. — Evidence: `.claude/docs/token-optimization.md`, `templates/claude/settings.json`, `templates/claude/hooks/protect-files.sh` | Confidence: High | If Wrong: current docs would still need explicit clarification

## Steps
- [x] Step 1: Refactor `templates/claude/hooks/transcript-ingest.sh` so semantic-memory detection matches the actual supported `claude-mem` install path from `lib/plugins.sh` instead of assuming `.mcp.json`; sync `.claude/hooks/transcript-ingest.sh`.
- [x] Step 2: Resolve the commit/review contradiction in `templates/skills/spec-work/SKILL.md` so step text, rules, and completion flow all agree on when commits happen; sync `.claude/skills/spec-work/SKILL.md`.
- [x] Step 3: Align `templates/claude/hooks/context-monitor.sh` warning text with the compact threshold shipped in `templates/claude/settings.json`, and document the threshold source of truth in `templates/claude/hooks/README.md`; sync local copies.
- [x] Step 4: Correct runtime docs that currently misattribute protections, especially where `permissions.deny` is the real enforcement layer and hooks are only advisory or edit-time safety nets.
- [x] Step 5: Audit and normalize adjacent wording in `templates/CLAUDE.md`, `templates/WORKFLOW-GUIDE.md`, and `.claude/docs/token-optimization.md` so they describe actual local runtime behavior rather than imported internal-Claude terminology.

## Acceptance Criteria

### Truths
- [x] `transcript-ingest.sh` can correctly recognize the supported `claude-mem` installation path instead of silently assuming fallback file memory.
- [x] `spec-work` exposes one consistent commit/review flow.
- [x] Context warning messages describe the same compact threshold that the installed settings actually use.
- [x] Runtime docs distinguish accurately between hook-based protections, settings-based denies, and optional operator behaviors.

### Artifacts
- [x] `templates/claude/hooks/transcript-ingest.sh` — plugin-aware semantic-memory detection (min 100 lines)
- [x] `templates/skills/spec-work/SKILL.md` — single coherent commit/review contract (min 80 lines)
- [x] `templates/claude/hooks/context-monitor.sh` — threshold-consistent warning copy (min 40 lines)
- [x] `templates/WORKFLOW-GUIDE.md` — corrected runtime and workflow guidance (min 150 lines)

### Key Links
- [x] `lib/plugins.sh` → `templates/claude/hooks/transcript-ingest.sh` via claude-mem detection assumptions
- [x] `templates/claude/settings.json` → `templates/claude/hooks/context-monitor.sh` via compaction threshold messaging
- [x] `templates/skills/spec-work/SKILL.md` → `templates/WORKFLOW-GUIDE.md` via commit/review workflow contract

## Files to Modify
- `templates/claude/hooks/transcript-ingest.sh` - align memory detection with plugin install reality
- `.claude/hooks/transcript-ingest.sh` - sync installed local copy
- `templates/claude/settings.json` - keep threshold source of truth explicit
- `.claude/settings.json` - sync local verification copy if threshold text changes
- `templates/skills/spec-work/SKILL.md` - remove contradictory commit guidance
- `.claude/skills/spec-work/SKILL.md` - sync installed local copy
- `templates/claude/hooks/context-monitor.sh` - fix threshold messaging
- `.claude/hooks/context-monitor.sh` - sync installed local copy
- `templates/claude/hooks/README.md` - document threshold source of truth
- `templates/CLAUDE.md` - correct runtime-vs-operator wording where needed
- `templates/WORKFLOW-GUIDE.md` - fix hook/runtime explanations
- `.claude/docs/token-optimization.md` - correct protection-layer descriptions

## Out of Scope
- Redesigning semantic memory as a first-class separate subsystem
- Changing plugin installation strategy or plugin-first architecture
- Permission presets or global settings redesign
