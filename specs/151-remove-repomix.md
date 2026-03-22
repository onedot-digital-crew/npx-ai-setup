# Spec: Remove repomix completely

> **Spec ID**: 151 | **Created**: 2026-03-22 | **Status**: draft | **Branch**: —

## Goal
Remove all repomix integration — snapshot generation, config templates, CLI tool requirement, freshness hooks, and agent references.

## Context
Repomix packs the entire repo into one XML file for LLM context. Claude Code has native codebase tools (Glob, Grep, Read) making the snapshot redundant. Only 2 agents read it optionally. The 122k-line snapshot adds no value but costs install time (npm), generation time (120s timeout), and disk space. Evaluated via /evaluate — no consumer depends on it critically.

### Verified Assumptions
- No command or hook depends on the snapshot for core functionality — Evidence: only `context-refresher` and `project-auditor` agents reference it optionally | Confidence: High | If Wrong: those agents need fallback paths
- `context-freshness.sh` hook only warns about stale snapshot — Evidence: `templates/claude/hooks/context-freshness.sh:52-66` | Confidence: High | If Wrong: hook has other critical logic we'd lose
- repomix is listed as `required` in CLI tools — Evidence: `lib/cli-tools.sh:15` | Confidence: High | If Wrong: already optional

## Steps
- [ ] Step 1: Remove `generate_repomix_snapshot()`, `install_repomix_config()`, `install_repomixignore()` from `lib/setup-compat.sh`
- [ ] Step 2: Remove repomix calls from `bin/ai-setup.sh` (lines ~108-110) and `lib/update.sh` (lines ~155, ~437)
- [ ] Step 3: Remove repomix from `lib/cli-tools.sh` CLI_TOOL_REGISTRY (required → delete entry)
- [ ] Step 4: Remove `templates/repomix.config.json` and `repomix.config.json` (root)
- [ ] Step 5: Remove repomix references from agents (`context-refresher.md`, `project-auditor.md`) and `context-freshness.sh` hook snapshot section
- [ ] Step 6: Remove `.agents/repomix-snapshot.xml` and `.repomixignore` from gitignore generation in `lib/setup.sh`
- [ ] Step 7: Run `grep -r repomix lib/ bin/ templates/` to catch any remaining references. Verify `bash -n` on all modified files.

## Acceptance Criteria
- [ ] Zero references to repomix in `lib/`, `bin/`, `templates/` (except specs/completed/)
- [ ] `bin/ai-setup.sh` runs without repomix installed
- [ ] No snapshot generation during fresh install or update
- [ ] Agents still function without snapshot (graceful skip)

## Files to Modify
- `lib/setup-compat.sh` — remove 3 functions (~95 lines)
- `lib/update.sh` — remove 2 generate_repomix_snapshot calls
- `lib/cli-tools.sh` — remove registry entry
- `lib/setup.sh` — remove gitignore entries
- `bin/ai-setup.sh` — remove 3 calls
- `templates/repomix.config.json` — DELETE
- `repomix.config.json` — DELETE
- `templates/agents/context-refresher.md` — remove repomix section
- `templates/agents/project-auditor.md` — remove repomix reference
- `templates/claude/hooks/context-freshness.sh` — remove snapshot section

## Out of Scope
- Removing repomix from user machines (their global install)
- Alternative codebase snapshot tool
- Changes to `.claudeignore`
